Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbaCDIhP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 03:37:15 -0500
Received: from mx01-fr.bfs.de ([193.174.231.67]:39059 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756384AbaCDIhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 03:37:12 -0500
Message-ID: <531590B4.8070307@bfs.de>
Date: Tue, 04 Mar 2014 09:37:08 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] new Page: isalpha__3(3)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi List,
The ctype macros like  isalpha(3) have a locale specific counterpart.
This page was missing.

re,
 wh


Signed-off-by: wharms@bfs.de <wharms@bfs.de>


.\" Copyright (c) 2013 by Walter Harms
.\"
.\" %%%LICENSE_START(VERBATIM)
.\" Permission is granted to make and distribute verbatim copies of this
.\" manual provided the copyright notice and this permission notice are
.\" preserved on all copies.
.\"
.\" Permission is granted to copy and distribute modified versions of this
.\" manual under the conditions for verbatim copying, provided that the
.\" entire resulting derived work is distributed under the terms of a
.\" permission notice identical to this one.
.\"
.\" Since the Linux kernel and libraries are constantly changing, this
.\" manual page may be incorrect or out-of-date.  The author(s) assume no
.\" responsibility for errors or omissions, or for damages resulting from
.\" the use of the information contained herein.  The author(s) may not
.\" have taken the same level of care in the production of this manual,
.\" which is licensed free of charge, as they might when working
.\" professionally.
.\"
.\" Formatted or processed versions of this manual, if unaccompanied by
.\" the source, must acknowledge the copyright and authors of this work.
.\" %%%LICENSE_END
.\"
.\"
.TH ISALPHA_L 3 2013-09-20 "GNU" "Linux Programmer's Manual"
.SH NAME
isalnum_l, isalpha_l, isblank_l, iscntrl_l, isdigit_l, isgraph_l, islower_l,
isprint_l, ispunct_l, isspace_l, isupper_l, isxdigit_l \- character
classification routines
.SH SYNOPSIS
.nf
.B #include <ctype.h>
.sp
.BI "int isalnum_l(int " "c" ", locale_t " loc );
.br
.BI "int isalpha_l(int " "c" ", locale_t " loc );
.br
.BI "int isascii_l(int " "c" ", locale_t " loc );
.br
.BI "int isblank_l(int " "c" ", locale_t " loc );
.br
.BI "int iscntrl_l(int " "c" ", locale_t " loc );
.br
.BI "int isdigit_l(int " "c" ", locale_t " loc );
.br
.BI "int isgraph_l(int " "c" ", locale_t " loc );
.br
.BI "int islower_l(int " "c" ", locale_t " loc );
.br
.BI "int isprint_l(int " "c" ", locale_t " loc );
.br
.BI "int ispunct_l(int " "c" ", locale_t " loc );
.br
.BI "int isspace_l(int " "c" ", locale_t " loc );
.br
.BI "int isupper_l(int " "c" ", locale_t " loc );
.br
.BI "int isxdigit_l(int " "c" ", locale_t " loc );
.fi
.sp
.SH DESCRIPTION
These functions check whether
.IR c ,
which must have the value of an
.I unsigned char
or
.BR EOF ,
falls into a certain character class according to the current locale.
.TP
.BR isalnum_l ()
checks for an alphanumeric character; it is equivalent to
.BI "(isalpha(" c ") || isdigit(" c "))" \fR.
.TP
.BR isalpha_l ()
checks for an alphabetic character; in the standard \fB"C"\fP
locale, it is equivalent to
.BI "(isupper_l(" c ") || islower_l(" c "))" \fR.
In some locales, there may be additional characters for which
.BR isalpha ()
is true\(emletters which are neither upper case nor lower
case.
.TP
.BR isascii_l ()
checks whether \fIc\fP is a 7-bit
.I unsigned char
value that fits into
the ASCII character set.
.TP
.BR isblank_l ()
checks for a blank character; that is, a space or a tab.
.TP
.BR iscntrl_l ()
checks for a control character.
.TP
.BR isdigit_l ()
checks for a digit (0 through 9).
.TP
.BR isgraph_l ()
checks for any printable character except space.
.TP
.BR islower_l ()
checks for a lower-case character.
.TP
.BR isprint_l ()
checks for any printable character including space.
.TP
.BR ispunct_l ()
checks for any printable character which is not a space or an
alphanumeric character.
.TP
.BR isspace_l ()
checks for white-space characters.
In the
.B """C"""
and
.B """POSIX"""
locales, these are: space, form-feed
.RB ( \(aq\ef\(aq ),
newline
.RB ( \(aq\en\(aq ),
carriage return
.RB ( \(aq\er\(aq ),
horizontal tab
.RB ( \(aq\et\(aq ),
and vertical tab
.RB ( \(aq\ev\(aq ).
.TP
.BR isupper_l ()
checks for an uppercase letter.
.TP
.BR isxdigit_l ()
checks for a hexadecimal digits, that is, one of
.br
.BR "0 1 2 3 4 5 6 7 8 9 a b c d e f A B C D E F" .
.SH RETURN VALUE
The values returned are nonzero if the character
.I c
falls into the tested class, and a zero value
if not.
.SH CONFORMING TO
POSIX.1-2008 specifies all of these functions.
.SH NOTES
The details of what characters belong into which class depend on the current
locale.
.sp
from
.IR locale.h :
The concept of one static locale per category is not very well
thought out.  Many applications will need to process its data using
information from several different locales.  Another application is
the implementation of the internationalization handling in the
upcoming ISO C++ standard library.  To support this another set of
the functions using locale data exist which have an additional
argument.

For example,
.BR isupper ()
will not recognize an A-umlaut (\(:A) as an uppercase letter in the default
.B "C"
locale.
.SH EXAMPLE
The following example takes a locale abbreviation like "de_DE" as argument.
Is no argument is supplied it will use "C". With "de_DE" the code will
identify the O-Umlaut correctly as alphanumeric character but not with "C".
In contrast the punctuation will perform as before.
.nf

#include <stdio.h>
#include <locale.h>

int main(int argc,char *argv[])
{
  char *str="c2p\(:O.,";
  int i;
  locale_t loc;
    if (argc > 1 )
      loc = newlocale (LC_ALL_MASK, argv[1], NULL);
    else
      loc = newlocale (LC_ALL_MASK, "C", NULL);

  for(i=0;str[i]!=0;i++) {
    if (isalnum_l(str[i],loc))
	printf("The character %c is alphanumeric.\\n",str[i]);
    if ( ispunct_l(str[i],loc) )
	printf ("The character %c is punctuation.\\n",str[i]);
  }
  return 0;
}

.fi
.SH SEE ALSO
.BR iswalnum (3),
.BR iswalpha (3),
.BR iswblank (3),
.BR iswcntrl (3),
.BR iswdigit (3),
.BR iswgraph (3),
.BR iswlower (3),
.BR iswprint (3),
.BR iswpunct (3),
.BR iswspace (3),
.BR iswupper (3),
.BR iswxdigit (3),
.BR setlocale (3),
.BR toascii (3),
.BR tolower (3),
.BR toupper (3),
.BR ascii (7),
.BR locale (7)
