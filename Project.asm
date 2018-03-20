S;----------------by: Nir Grotel

IDEAL
MODEL small
STACK 100h
DATASEG

szMsg1 db "Hi! What do you want to do?",10,13,10,13,"/h-help(see all the commands)",10,13,"/e-Exit",10,13,10,13,"$" ;Start Message
szHelloWorld db 10,13,"Hello World!",10,13,"$" ;String contains the text: Hello World!
ErrorMsg db 10,13,"Illegal Command,Try again!",10,13,"$" ;String contains the text :Illegal Command,Try again!
filenameStr db 13,0,13 dup("$");string that will get the name of the file from input
help db 10,13,"HELP LIST:",10,13,"-----------",10,13,"Commands are:",10,13," /e-Exit",10,13," /h-help",10,13," /1-Says: 'Hello World!'",10,13," /c - Create a file",10,13," /w-Write to file",10,13," /r-Read file",10,13," /D-Delete file",10,13,"$" ;string that shows the commands
filehandle dw 0;file handle
ErrorOpenMsg db 'Error',10,13,'$' ;string contains :Error
FileNameLength db "(file name consists of 4 letters MUST!! (template: 'test.tst'))","$" ;string contains the instructor of the commands 
r db 10,13,"/r/ ","$";string contains /r/
c db ,10,13,"/c/ ","$";string contains /c/
w db ,10,13,"/w/ ","$";string contains /w/
d db ,10,13,"/d/ ","$";string contains /d/
GoodBye db 10,13,"Good Bye! ","$";string contains Good Bye
KeyStrokeMsg db 10,13,"Press Any Key To Continue! ","$";string contains Press Any Key To Continue!
fileString db 255 dup (0);string that will contain the string inside the file
space db " ","$";string that makes space
CommandMsg db 10,13,"Enter your command:",10,13,"Command: ","$",10,13;string that contains: Enter your comamnd: command:
filereaderline db "file's text:","$";string that contains: file's text. writes it for some procedures
WriteStr db 0,255 dup ("$");string that may contain 100 letters,used for writing in file
endchar db '$';stops WriteStr from writing more


CODESEG 

proc Exitp ;says Good Bye, waits for KeyStroke and Exits Procedure
    mov dx,offset GoodBye
    mov ah,9h
    int 21h 
	call KeyStroke
	mov ax, 4c00h
    int 21h
endp Exitp

proc Exitp1 ;says Good Bye, waits for KeyStroke and Exits Procedure
    mov dx,offset GoodBye
    mov ah,9h
    int 21h 
	call KeyStroke1
	mov ax, 4c00h
    int 21h
endp Exitp1
    
proc WipeClean ;cleans fileString for future uses
     mov  [byte ptr fileString + bx], 0
     inc  bx
     cmp  bx, 255
     jb   WipeClean
	 ret
endp WipeClean

proc WipeCleanWrite ;cleans WriteStr for future uses
     mov  [byte ptr WriteStr + bx], 0
     inc  bx
     cmp  bx, 255
     jb   WipeClean
	 ret
endp WipeCleanWrite	 
                               
proc OpenFile ;Open file
    mov ah,3Dh
    mov al,2
    lea dx,[filenameStr+2]
    int 21h
    jc openerror
    mov [filehandle],ax
    ret
openerror:  
    mov dx,offset ErrorOpenMsg
    mov ah,9h
    int 21h
	call Exitp1
	
    ret
endp OpenFile  

proc CreateFile ;create File
	mov ah,3ch 
    mov cx,00000000b 
    lea dx,[filenameStr+2] 
    int 21h 
    jc CreateError 
    mov [filehandle],ax
	ret
CreateError:  
    mov dx,offset ErrorOpenMsg
    mov ah,9h
    int 21h
    ret
endp CreateFile	 

proc ReadFile ;read file
    mov ah,3fh
    mov bx,[filehandle]
    mov cx,255
    lea dx,[fileString]
    int 21h
    ret
endp ReadFile   

proc DeleteFile ;delete file
    mov ah,41h
    lea dx,[filenameStr+2]
    int 21h
	ret
endp DeleteFile

proc DisplayFileString ;display the string (fileString)
	mov dl, 10
	mov ah, 2
	int 21h

	mov dl, 13
	mov ah, 2
	int 21h
	
    mov ah,09h
    lea dx,[fileString]
    int 21h 
	
	mov dl, 10
	mov ah, 2
	int 21h

	mov dl, 13
	mov ah, 2
	int 21h
	ret
endp DisplayFileString 

proc DisplayWriteStr;display the string (WriteStr)
	mov dl, 10
	mov ah, 2
	int 21h

	mov dl, 13
	mov ah, 2
	int 21h
	
    mov ah,09h
    lea dx,[WriteStr+2]
    int 21h 
	ret
endp DisplayWriteStr 

proc DisplayFileName;display the string (filenameStr)
	mov dl, 10
	mov ah, 2
	int 21h

	mov dl, 13
	mov ah, 2
	int 21h
	
    mov ah,09h
    lea dx,[filenameStr]
    int 21h 
	ret
endp DisplayFileName  

proc KeyStroke1 ;wait for key press and restard program
	mov dx,offset KeyStrokeMsg
    mov ah,9h
    int 21h    
	
	xor ax,ax
    int 16h
	jmp start
	ret
endp KeyStroke1

proc KeyStroke ;wait for key press
	mov dx,offset KeyStrokeMsg
    mov ah,9h
    int 21h    
	
	xor ax,ax
    int 16h
	ret
endp KeyStroke

proc WriteToFile;write to file
    mov ah,40h
    mov bx,[filehandle]
    mov cx,255
    lea dx,[WriteStr+2]
    int 21h
    ret
endp WriteToFile

proc CloseFile ;close file
    mov ah,3Eh
    mov bx,[filehandle]
    int 21h
    ret
endp CloseFile  

start:
    mov ax, @data
    mov ds, ax
	
	mov ah,0 ;cleans the screen
	mov al,2
	int 10h
	
    mov dx,offset szMsg1 ;prints start message to screen
    mov ah,9h
    int 21h
    jmp GetCommandLetter 

PrintLine: ;prints Hello World! to screen
    mov dx, offset szHelloWorld
    mov ah, 9h
    int 21h
    jmp GetCommandLetter
	
_Error: ;prints Error message to screen
    mov dx,offset ErrorMsg
    mov ah,9h
    int 21h
	
	
	mov  bl, 0
	mov  bh, 0
	xor ax,ax
	xor bx,bx	

GetCommandLetter: ;get 2 letter commands and jumps to the right label for the command 
	
   mov dx,offset CommandMsg
    mov ah,9h
    int 21h
	
	
    mov ah, 1h
    int 21h
    mov bl,al   

    mov ah, 1h
    int 21h
    mov bh,al  	
compare:    
	
    cmp bl,'/' ;checks if the first letter is /
    jne _Error;if not than jumps to _Error label to print Error on screen
	
    cmp bh,'h' ;if the second letter is h than jumps to _help to print the help string on screen
    je _help

    cmp bh,'H';if the second letter is h than jumps to _help to print the help string on screen
    je _help

    cmp  bh,'1' ;if the second letter equals to 1 than prints Hello World!
    je PrintLine

    cmp bh,'e' ;if the second letter equals to e than jumps to exit procedure to exit the program
    je _Exitp

    cmp bh,'E';if the second letter equals to e than jumps to exit procedure to exit the program
    je _Exitp

    mov dx,offset space ;prints space to screen
    mov ah,9h
    int 21h
    mov dx,offset FileNameLength ;prints Filename Length instructor message to screen
    mov ah,9h
    int 21h
	
	
	cmp bh,'c' ;if the second letter equals to c  than jumps to CreatingFile to create a file
    je CreatingFile

    cmp bh,'C';if the second letter equals to c  than jumps to CreatingFile to create a file
    je CreatingFile

    cmp  bh,'r';if the second letter equals to r  than jumps to GetFileName to read a file
    je GetFileName

    cmp  bh,'R';if the second letter equals to r  than jumps to GetFileName to read a file
    je GetFileName
	
	 cmp  bh,'w';if the second letter equals to w  than jumps to WritingToFile to write to file
    je jmpToWritingFile

    cmp  bh,'W'    ;if the second letter equals to w  than jumps to WritingToFile to write to file
    je jmpToWritingFile
	
	cmp  bh,'d'     ;if the second letter equals to d  than jumps to DeleteFileName to delete a file
    je jmpToDeleteFileName

    cmp  bh,'D'     ;if the second letter equals to d  than jumps to DeleteFileName to delete a file
    je jmpToDeleteFileName

    jmp _Error      ;if not any of this commands than prints Error

_Exitp:       ;label that calls Exitp to exit the program
call Exitp

_help:  ;label that prints the help string and than goes to command label
    mov dx,offset help
    mov ah,9h
    int 21h
    jmp GetCommandLetter

jmpToWritingFile:     ;jumps to WritingToFile label
jmp WritingToFile

jmpToDeleteFileName:     ;jumps to DisplayFileName label	
jmp DeleteFileName
	
GetFileName:      ;reads file and prints what it contains to screen,than it jumps to the command label
    mov dx,offset r
    mov ah,9h
    int 21h
    mov dx,offset filenameStr
    mov bx,dx
    mov [byte ptr bx],13    ;8+1+3+1
    mov ah,0Ah
    int 21h
    mov dx,offset filenameStr + 2
    mov ah,9h
    int 21h
    mov [byte ptr filenameStr+2+8],0
    call OpenFile 
	xor  bx,bx
	call WipeClean
    call ReadFile
    mov dx,offset filereaderline 
    mov ah,9h 
    int 21h
    call DisplayFileString
    call CloseFile 
    jmp GetCommandLetter

CreatingFile:      ;creates file from user input,than jumps to command label
	mov dx,offset c
    mov ah,9h
    int 21h
    mov dx,offset filenameStr
    mov bx,dx
    mov [byte ptr bx],13    ;8+1+3+1
    mov ah,0Ah
    int 21h
    mov dx,offset filenameStr + 2
    mov ah,9h
    int 21h
    mov [byte ptr filenameStr+2+8],0
    call CreateFile 
	;call DisplayFileName
	xor  bx,bx
    call CloseFile 
	call WipeClean
	jmp GetCommandLetter
	
WritingToFile:     ;writes text to file from user input,than jumps to commamnd label
	mov dx,offset w
    mov ah,9h
    int 21h
    mov dx,offset filenameStr
    mov bx,dx
    mov [byte ptr bx],13    ;8+1+3+1
    mov ah,0Ah
    int 21h
    mov dx,offset filenameStr + 2
    mov ah,9h
    int 21h
    mov [byte ptr filenameStr+2+8],0
    call OpenFile 
	xor  bx,bx
	call WipeClean
	call WipeCleanWrite
    mov dx,offset filereaderline 
    mov ah,9h 
    int 21h
	mov dx,offset WriteStr
    mov bx,dx
    mov [byte ptr bx],100    ;8+1+3+1
    mov ah,0Ah
    int 21h
	call WriteToFile
    call CloseFile 
	call WipeClean
	;call DisplayWriteStr
    jmp GetCommandLetter	
	
DeleteFileName:      ;deletes file from user input
    mov dx,offset d
    mov ah,9h
    int 21h
    mov dx,offset filenameStr
    mov bx,dx
    mov [byte ptr bx],13    ;8+1+3+1
    mov ah,0Ah
    int 21h
    mov dx,offset filenameStr + 2
    mov ah,9h
    int 21h
    mov [byte ptr filenameStr+2+8],0 
	xor  bx,bx
	call WipeClean
    call DeleteFile
    jmp GetCommandLetter
	



exit:
    mov ax, 4c00h
    int 21h
END start
