Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaILH3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 03:29:00 -0400
Received: from ozlabs.org ([103.22.144.67]:47276 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbaILH27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 03:28:59 -0400
Message-ID: <1410506936.17540.7.camel@concordia>
Subject: Re: [PATCH v3 1/3] init/main.c: Give init_task a canary
From: Michael Ellerman <mpe@ellerman.id.au>
To: Aaron Tomlin <atomlin@redhat.com>
Cc: peterz@infradead.org, dzickus@redhat.com, jcastillo@redhat.com,
        riel@redhat.com, x86@kernel.org, akpm@linux-foundation.org,
        minchan@kernel.org, bmr@redhat.com, prarit@redhat.com, oleg@redhat.com,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        mingo@redhat.com, aneesh.kumar@linux.vnet.ibm.com, akpm@google.com,
        jgh@redhat.com, linuxppc-dev@lists.ozlabs.org, tglx@linutronix.de,
        pzijlstr@redhat.com
Date: Fri, 12 Sep 2014 17:28:56 +1000
In-Reply-To: <1410450088-18236-2-git-send-email-atomlin@redhat.com>
References: <1410255749-2956-1-git-send-email-atomlin@redhat.com>
	 <1410450088-18236-1-git-send-email-atomlin@redhat.com>
	 <1410450088-18236-2-git-send-email-atomlin@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-11 at 16:41 +0100, Aaron Tomlin wrote:
> Tasks get their end of stack set to STACK_END_MAGIC with the
> aim to catch stack overruns. Currently this feature does not
> apply to init_task. This patch removes this restriction.
> 
> diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
> index 51ab9e7..35d0760c 100644
> --- a/arch/powerpc/mm/fault.c
> +++ b/arch/powerpc/mm/fault.c
> @@ -30,7 +30,6 @@
>  #include <linux/kprobes.h>
>  #include <linux/kdebug.h>
>  #include <linux/perf_event.h>
> -#include <linux/magic.h>
>  #include <linux/ratelimit.h>
>  #include <linux/context_tracking.h>
>  
> @@ -538,7 +537,7 @@ void bad_page_fault(struct pt_regs *regs, unsigned long address, int sig)
>  		regs->nip);
>  
>  	stackend = end_of_stack(current);
> -	if (current != &init_task && *stackend != STACK_END_MAGIC)
> +	if (*stackend != STACK_END_MAGIC)
>  		printk(KERN_ALERT "Thread overran stack, or stack corrupted\n");

This part looks fine.

Acked-by: Michael Ellerman <mpe@ellerman.id.au>

cheers


