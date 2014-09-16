Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaIPQG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:06:58 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:51293 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbaIPQG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:06:57 -0400
MIME-Version: 1.0
In-Reply-To: <db9b257536558b5f068e97717bb0f25bcc603ae4.1410883257.git.luto@amacapital.net>
References: <db9b257536558b5f068e97717bb0f25bcc603ae4.1410883257.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 16 Sep 2014 09:06:34 -0700
Message-ID: <CALCETrVyGZmpNvSZShC+dT+oWbj7NbfNP=P3m5p5u4A7Z_5YOw@mail.gmail.com>
Subject: Re: [PATCH] parisc: Use secure_computing_strict, not secure_computing
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Kees Cook <keescook@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 9:05 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> After commit a4412fc9486e, the secure_computing function is only
> available if seccomp filters are implemented by the architecture.
> Architectures without seccomp filters use secure_computing_strict
> instead.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>
> This is minimally tested because my cross-compiler toolchain for parisc
> is quite broken.  ptrace.c seems to *compile*, but it doesn't assemble.

Failed to mention: this applies on top of what tip/master, aka what
happens when tip/seccomp is merged with a newer -linus kernel.

--Andy

>
>  arch/parisc/kernel/ptrace.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/parisc/kernel/ptrace.c b/arch/parisc/kernel/ptrace.c
> index 3bab72462ab5..5961cc86d6d2 100644
> --- a/arch/parisc/kernel/ptrace.c
> +++ b/arch/parisc/kernel/ptrace.c
> @@ -270,11 +270,11 @@ long do_syscall_trace_enter(struct pt_regs *regs)
>  {
>         long ret = 0;
>
> -       /* Do the secure computing check first. */
> -       if (secure_computing(regs->gr[20])) {
> -               /* seccomp failures shouldn't expose any additional code. */
> -               return -1;
> -       }
> +       /*
> +        * Do the secure computing check first. seccomp failures
> +        * shouldn't expose any additional code.
> +        */
> +       secure_computing_strict(regs->gr[20]);
>
>         if (test_thread_flag(TIF_SYSCALL_TRACE) &&
>             tracehook_report_syscall_entry(regs))
> --
> 1.9.3
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
