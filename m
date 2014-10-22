Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaJVR40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 13:56:26 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38817 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbaJVR4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 13:56:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Drysdale <drysdale@google.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
References: <1413978269-17274-1-git-send-email-drysdale@google.com>
	<1413978269-17274-4-git-send-email-drysdale@google.com>
Date: Wed, 22 Oct 2014 12:55:34 -0500
In-Reply-To: <1413978269-17274-4-git-send-email-drysdale@google.com> (David
	Drysdale's message of "Wed, 22 Oct 2014 12:44:29 +0100")
Message-ID: <87wq7sgfah.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+weDaf7IExoFi/hnfwzLeLT1IbIyL08iI=
X-SA-Exim-Connect-IP: 68.113.178.29
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  3.0 XMDrug1234561 Drug references
	*  0.7 XMSubLong Long Subject
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.4 XMBrknScrpt_02 Possible Broken Spam Script
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ******;David Drysdale <drysdale@google.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 766 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 3.0 (0.4%), b_tie_ro: 2.1 (0.3%), parse: 1.24 (0.2%),
	extract_message_metadata: 6 (0.8%), get_uri_detail_list: 4.1 (0.5%),
	tests_pri_-1000: 6 (0.8%), tests_pri_-950: 1.78 (0.2%), tests_pri_-900: 1.52
	(0.2%), tests_pri_-400: 30 (3.9%), check_bayes: 29 (3.8%), b_tokenize: 9
	(1.2%), b_tok_get_all: 11 (1.4%), b_comp_prob: 2.6 (0.3%), b_tok_touch_all:
	2.4 (0.3%), b_finish: 1.90 (0.2%), tests_pri_0: 694 (90.6%), tests_pri_500: 8
	(1.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv5 man-pages 3/3] execveat.2: initial man page for execveat(2)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Drysdale <drysdale@google.com> writes:

> Signed-off-by: David Drysdale <drysdale@google.com>
> ---
>  man2/execveat.2 | 144 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 144 insertions(+)
>  create mode 100644 man2/execveat.2
>
> diff --git a/man2/execveat.2 b/man2/execveat.2
> new file mode 100644
> index 000000000000..d19571a3eb9d
> --- /dev/null
> +++ b/man2/execveat.2
> @@ -0,0 +1,144 @@
> +.\" Copyright (c) 2014 Google, Inc.
> +.\"
> +.\" %%%LICENSE_START(VERBATIM)
> +.\" Permission is granted to make and distribute verbatim copies of this
> +.\" manual provided the copyright notice and this permission notice are
> +.\" preserved on all copies.
> +.\"
> +.\" Permission is granted to copy and distribute modified versions of this
> +.\" manual under the conditions for verbatim copying, provided that the
> +.\" entire resulting derived work is distributed under the terms of a
> +.\" permission notice identical to this one.
> +.\"
> +.\" Since the Linux kernel and libraries are constantly changing, this
> +.\" manual page may be incorrect or out-of-date.  The author(s) assume no
> +.\" responsibility for errors or omissions, or for damages resulting from
> +.\" the use of the information contained herein.  The author(s) may not
> +.\" have taken the same level of care in the production of this manual,
> +.\" which is licensed free of charge, as they might when working
> +.\" professionally.
> +.\"
> +.\" Formatted or processed versions of this manual, if unaccompanied by
> +.\" the source, must acknowledge the copyright and authors of this work.
> +.\" %%%LICENSE_END
> +.\"
> +.TH EXECVEAT 2 2014-04-02 "Linux" "Linux Programmer's Manual"
> +.SH NAME
> +execveat \- execute program relative to a directory file descriptor
> +.SH SYNOPSIS
> +.B #include <unistd.h>
> +.sp
> +.BI "int execve(int " fd ", const char *" pathname ","
            ^^^^^^ That needs to be execveat
> +.br
> +.BI "           char *const " argv "[],  char *const " envp "[],"
> +.br
> +.BI "           int " flags);
> +.SH DESCRIPTION
> +The
> +.BR execveat ()
> +system call executes the program pointed to by the combination of \fIfd\fP and \fIpathname\fP.
> +The
> +.BR execveat ()
> +system call operates in exactly the same way as
> +.BR execve (2),
> +except for the differences described in this manual page.
> +
> +If the pathname given in
> +.I pathname
> +is relative, then it is interpreted relative to the directory
> +referred to by the file descriptor
> +.I fd
> +(rather than relative to the current working directory of
> +the calling process, as is done by
> +.BR execve (2)
> +for a relative pathname).
> +
> +If
> +.I pathname
> +is relative and
> +.I fd
> +is the special value
> +.BR AT_FDCWD ,
> +then
> +.I pathname
> +is interpreted relative to the current working
> +directory of the calling process (like
> +.BR execve (2)).
> +
> +If
> +.I pathname
> +is absolute, then
> +.I fd
> +is ignored.
> +
> +If
> +.I pathname
> +is an empty string and the
> +.BR AT_EMPTY_PATH
> +flag is specified, then the file descriptor
> +.I fd
> +specifies the file to be executed.
> +
> +.I flags
> +can either be 0, or include the following flags:
> +.TP
> +.BR AT_EMPTY_PATH
> +If
> +.I pathname
> +is an empty string, operate on the file referred to by
> +.IR fd
> +(which may have been obtained using the
> +.BR open (2)
> +.B O_PATH
> +flag).
> +.TP
> +.B AT_SYMLINK_NOFOLLOW
> +If the file identified by
> +.I fd
> +and a non-NULL
> +.I pathname
> +is a symbolic link, then the call fails with the error
> +.BR EINVAL .
> +.SH "RETURN VALUE"
> +On success,
> +.BR execveat ()
> +does not return. On error \-1 is returned, and
> +.I errno
> +is set appropriately.
> +.SH ERRORS
> +The same errors that occur for
> +.BR execve (2)
> +can also occur for
> +.BR execveat ().
> +The following additional errors can occur for
> +.BR execveat ():
> +.TP
> +.B EBADF
> +.I fd
> +is not a valid file descriptor.
> +.TP
> +.B EINVAL
> +Invalid flag specified in
> +.IR flags .
> +.TP
> +.B ENOTDIR
> +.I pathname
> +is relative and
> +.I fd
> +is a file descriptor referring to a file other than a directory.
> +.SH VERSIONS
> +.BR execveat ()
> +was added to Linux in kernel 3.???.
> +.SH NOTES
> +In addition to the reasons explained in
> +.BR openat (2),
> +the
> +.BR execveat ()
> +system call is also needed to allow
> +.BR fexecve (3)
> +to be implemented on systems that do not have the
> +.I /proc
> +filesystem mounted.
> +.SH SEE ALSO
> +.BR execve (2),
> +.BR fexecve (3)
