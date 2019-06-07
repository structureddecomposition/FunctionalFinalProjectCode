;CIS11 Final Project Code 
;Structured Decomposition
;	Alegria Nieto
;	Javon James
;	Sean Crews
;
;DONE	Contain appropriate addresses: origination, fill, array, input and output. (20 points)
;DONE	Display counted values in console. (20 points)
;DONE	Use appropriate labels and comments. (20 points)
;DONE	Contain appropriate instructions for arithmetic, data movement and conditional operations. (40 points)
;DONE	Comprise of 2 or more subroutines and implement subroutine calls. (20 points)
;DONE	Use branching for control: conditional and iterative. (30 points)
;DONE?	Manage overflow and storage allocation. (20 points)
;NEEDED	Manage stack: include PUSH-POP operation on stack. (20 points)
;DONE	Include save-restore operations. (30 points)
;NEEDED	Include pointer (20 points)
;DONE	Implement ASCII conversion operations (30 points)
;DONE?	Use appropriate system call directives. (10 point)
;PART3	Testing (20 points): Test the program using the team names.		

		.ORIG 	x3000			;Starting address.
		LD	R0, POINTER
		PUTc				;Prints the char in R0

RERUN
		
		JSR CLEAN			;jump to subroutine "CLEAN"
						;return from "CLEAN" here
		LEA	R1, INARRAY		;load input array starting address to R0
		AND	R3, R3, #0		;initialize R3 to zero
		AND 	R2, R2, #0		;initialize R2 to zero
		
		LEA	R0, PROMPT1		;Load address of PROMPT1 into r0.
		PUTS				;Print contents of r0 (PROMPT1).

	
INLOOP						;input loop to feed array
		GETC				;get first character
		ADD	R2, R0, #-10		;end of entry, enter key pressed
		BRz	ENDIN			;if zero, enter key has been pressed
						;goto end of input label ENDIN
		STR	R0, R1, #0		;store first character into input array
		OUT				;output character to console
		ADD	R1, R1, #1		;increment counter to access next byte in input array
		ADD	R3, R3, #1		;increment number of elements in R3
		STI	R3, ELEMENTS		;store number of array elements to label "ELEMENTS"
		LD	R6, EOL			;store maximum array size to label "EOL"
		ADD	R4, R3, R6		;OVERFLOW PREVENTION add number of elements to max array size 
		BRn	INLOOP			;if elements + array size negative, continue loop
	
ENDIN						;input done, echo prompts
		LEA	R0, LF			;load address of LF
		PUTS				;output LF for empty line
		LEA	R0, MSG1		;load address of message 1
		PUTS				;output MSG1
		LEA	R0, INARRAY		;load address of array to R0
		PUTS				;output INARRAY to console show array
		LEA	R0, PROMPT2		;load address of prompt2 to R0
		PUTS				;output PROMPT2 to console
		AND	R0, R0, #0		;initialize R0 to zero
		BR	GETCHAR			;branch to subroutine GETCHAR		

GETCHAR						;subroutine to get user char
		GETC				;get user character
		STI	R0, USERCHAR		;store userchar to x3100
		LEA	R0, MSG1		;load address of message 1
		PUTS				;output MSG1
		LDI	R0, USERCHAR		;load value of USERCHAR to R0
		OUT				;echo user character
		JSR CLEAN			;jump to subroutine CLEAN
						;return from "CLEAN" here
		
		LDI	R0, USERCHAR		;load USERCHAR to R0
		NOT	R0, R0			;negate USERCHAR
		ADD	R0, R0, #1		;2s complement of USERCHAR
		LEA	R1, INARRAY		;load address of 1st element of INARRAY TO R1	
		LDI	R4, ELEMENTS		;load contents of ELEMENTS to R4

		JSR CHARTEST			;jump to subroutine "CHARTEST"
						;return from "CHARTEST" here

		

		INARRAY		.BLKW 30	;array storing user string with max size 30


		PROMPT1		.STRINGZ 	"\nEnter full name without spaces. Ex: alanturing\n"
		PROMPT2		.STRINGZ	"\nEnter character to search for\n"
		LF		.STRINGZ	"\n"
		MSG1		.STRINGZ	"\nYou have entered: "		
		MSG2		.STRINGZ	"\nThe occurences of "
		MSG3		.STRINGZ	" is/are "
		USERCHAR	.FILL		x3100	;location for user character
		ELEMENTS	.FILL		x3101	;location for number of elements
		CHARCOUNT	.FILL		x3102	;location for occurences in string
		ASCIINUM	.FILL		#48	;offset for numeric value of occurences
		EOL		.FILL		#-30	;end of line for checking max array size
		POINTER		.FILL		RERUN	;address locAtion for pointer
		ENDLINE		.FILL		x0A	;A decimal 10, or a hex 'A'
		
CLEAN						;subroutine to re-initialize registers
		ST	R5, SaveReg5		;save R5
		AND	R0, R0, #0		;initialize R0 to zero
		AND	R1, R1, #0		;initialize R1 to zero
		AND	R2, R2, #0		;initialize R2 to zero
		AND	R3, R3, #0		;initialize R3 to zero
		AND	R4, R4, #0		;initialize R4 to zero
		LD	R5, SaveReg5		;restore R5
		AND	R6, R6, #0		;initialize R6 to zero
RET						;return to calling program
SaveReg5	.FILL	x0			;fill register 5 with value hex zero

CHARTEST					;subroutine to compare userchar to array elements
		LDR	R2, R1, #0		;load contents of 1st element of INARRAY TO R1	
		ADD	R3, R0, R2		;add negated USERCHAR to INARRAY to compare
		ADD	R1, R1,#1		;increment R1 to cycle through INARRAY
		ADD	R4, R4, #-1		;decrement ELEMENTS	as counter for iterations
		BRn	OUTPREP			;if elements goes negative, goto OUTPREP
		ADD	R3, R3, #0		;copy of R3 for branch comparison
		BRnp	CHARTEST	 	;if R3 is neg or pos, not a match repeat CHARTEST
		BRz	OCCURENCE		;if zero is a match, goto subroutine OCCURENCE

OCCURENCE					;subroutine to count occurences of user character
		ADD	R6, R6, #1		;increment R6 for each OCCURENCE of USERCHAR in INARRAY
		STI	R6, CHARCOUNT		;store incremented count to label "CHARCOUNT"
		ADD	R4, R4, #0		;copy of value in ELEMENTS
		BRp	CHARTEST		;while ELEMENTS stays positive, loop to CHARTEST
		

OUTPREP						;subroutine to calculate and output results
		JSR CLEAN			;subroutine to re-initialize registers
						;return from "CLEAN" here
		LEA	R0, LF			;load address of LF
		PUTS				;output LF for empty line
		LEA	R0, MSG2		;load address of message 2
		PUTS				;output message 2
		AND	R0, R0, #0		;initialize R0 to zero
		LDI	R1, USERCHAR		;load value of user character to R1
		ADD	R0, R1, #0		;copy value of user character to R0
		OUT				;output user character
		AND	R0, R0, #0		;initialize R0 to zero
		LEA	R0, MSG3		;load address of message 3
		PUTS				;output message 3
		AND	R0, R0, #0		;initialize R0 to zero
		LDI	R2, CHARCOUNT 		;load value of occurences to R2
		LD	R4, ASCIINUM		;load ASCII offset for numeric value to R4
		ADD	R0, R2, R4		;add occurences and offset, store in R0
		OUT				;output numeric value of occurences
		;BR	POINTER			;unconditional branch to subroutine RERUN






		LEA 	R0, PROMPT1
		PUTs                		; TRAP x22
		LEA	R0, PROMPT2
		PUTs				; TRAP x2
		LD 	R0, POINTER
		OUT                 		; TRAP x21
		IN                  		; TRAP x23

		AND 	R5, R5, #0      	; clear R5
		ADD 	R5, R5, R0      	; Store the user input into R5

		AND 	R1, R1, #0      	; clear R1, R1 is our loop count
		LD 	R2, INLOOP   		; load our mask limit into R2
		NOT 	R2, R2          	; Invert the bits in R2
		ADD 	R2, R2, #1      	; because of 2's compliment we have
                    		    		; to add 1 to R2 to get -4

		LEA 	R3, INARRAY      	; load the first memory location 
                    		    		; in our binary mask array
		ADD 	R3, R3, R1      	; use R1 as our array index and
                    		    		; add that to the first array location
		LDR 	R4, R3, #0      	; load the next binary mask into R4

		AND 	R4, R4, R5      	; AND the user input with the 
                    		    		; binary mask
		BRz 	ENDIN
		LD 	R0, ASCIINUM
		OUT                 		; TRAP x21
		ADD 	R1, R1, #1      	; add one to our loop counter
		BR 	GETCHAR    		; loop again

		ADD 	R1, R1, #1      	; add one to our loop counter
		BR 	GETCHAR    		; loop again

		LD 	R0, POINTER
		OUT                 		; TRAP x21
		HALT                		; TRAP x25





;RET		POINTER
		HALT				;pause processor		
;RERUN						;subroutine to restart program
;		AND	R0, R0, #0
;		LEA	R0, POINTER		;load address of POINTER (x3000) to R0
;		LDR	R0, R0, #0		;load contents of POINTER to R0
;		HALT				;pause processor

;POINTER
;		LEA	R5, ELEMENTS		; pointer: initialize a register with an ELEMENTS address
;		AND	R0, R0, #0		; Clear R0
;		ADD	R0, R0, #4		; R0 = 4
;		STR	R0, R5, #0		; Object = 4
;		
;		ADD 	R0, R5, #0		; Generate memory addresss of object
;		STR	R0, R5, #-1		; Pointer = &object
;
;		LDR	R0, R5, #-1		; R0 contains the value of ptr
;		LDR	R1, R0, #0		; R1 <- *ptr
;		ADD	R1, R1, #1		; *ptr + 1
;		STR	R1, R0, #0		; *ptr = *ptr + 1
;		
;		ADD 	R0, R5, #-1 		; addr of valueB
;		ADD 	R6, R6, #-1 		; push
;		STR	R0, R6, #0
;		ADD	R0, R5, #0  		; addr of valueA
;		ADD 	R6, R6, #-1 		; push
;		STR 	R0, R6, #0	
;



.END						;end program