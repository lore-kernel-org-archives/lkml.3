Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbaISK70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 06:59:26 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:34788 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaISK7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 06:59:25 -0400
Date: Fri, 19 Sep 2014 12:59:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        keescook@chromium.org, linux@arm.linux.org.uk, ralf@linux-mips.org,
        heiko.carstens@de.ibm.com, tglx@linutronix.de,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] parisc: Use secure_computing_strict, not secure_computing
Message-ID: <20140919105920.GA14133@gmail.com>
References: <db9b257536558b5f068e97717bb0f25bcc603ae4.1410883257.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db9b257536558b5f068e97717bb0f25bcc603ae4.1410883257.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed the PARISC maintainer. Original patch quoted below.)

* Andy Lutomirski <luto@amacapital.net> wrote:

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
>  	long ret = 0;
>  
> -	/* Do the secure computing check first. */
> -	if (secure_computing(regs->gr[20])) {
> -		/* seccomp failures shouldn't expose any additional code. */
> -		return -1;
> -	}
> +	/*
> +	 * Do the secure computing check first. seccomp failures
> +	 * shouldn't expose any additional code.
> +	 */
> +	secure_computing_strict(regs->gr[20]);
>  
>  	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
>  	    tracehook_report_syscall_entry(regs))

