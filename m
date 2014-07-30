Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaG3WE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:04:26 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:49697 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbaG3WEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:04:25 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Richard Henderson <rth@twiddle.net>
Cc: linux-kernel@vger.kernel.org, mcree@orcon.net.nz,
        linux-alpha@vger.kernel.org
Subject: Re: [PATCH 1/2] alpha: Remove "strange" OSF/1 fork semantics
References: <1406756552-23864-1-git-send-email-rth@twiddle.net>
	<1406756552-23864-2-git-send-email-rth@twiddle.net>
Date: Wed, 30 Jul 2014 23:04:20 +0100
In-Reply-To: <1406756552-23864-2-git-send-email-rth@twiddle.net> (Richard
	Henderson's message of "Wed, 30 Jul 2014 11:42:31 -1000")
Message-ID: <yw1xk36u5wrf.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Henderson <rth@twiddle.net> writes:

> The assignment to regs->r20 kills the original tls_val input
> to the clone syscall, which means that clone can no longer be
> restarted with the original inputs.
>
> We could, perhaps, retain this result for true fork, but OSF/1
> compatibility is no longer important.  Note that glibc has never
> used the r20 result value, instead always testing r0 vs 0 to
> determine the child/parent status.

What effect does this have on OSF/1 compat?

> This failure can be seen in the glibc nptl/tst-eintr* tests.
>
> Reported-by: Michael Cree <mcree@orcon.net.nz>
> Signed-off-by: Richard Henderson <rth@twiddle.net>
> ---
>  arch/alpha/kernel/process.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
> index 1941a07..77028d7 100644
> --- a/arch/alpha/kernel/process.c
> +++ b/arch/alpha/kernel/process.c
> @@ -278,8 +278,6 @@ copy_thread(unsigned long clone_flags, unsigned long usp,
>  	*childregs = *regs;
>  	childregs->r0 = 0;
>  	childregs->r19 = 0;
> -	childregs->r20 = 1;	/* OSF/1 has some strange fork() semantics.  */
> -	regs->r20 = 0;
>  	stack = ((struct switch_stack *) regs) - 1;
>  	*childstack = *stack;
>  	childstack->r26 = (unsigned long) ret_from_fork;
> -- 
> 1.9.3
>

-- 
Måns Rullgård
mans@mansr.com
