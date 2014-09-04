Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaIDPay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:30:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:47209 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaIDPax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:30:53 -0400
Date: Thu, 4 Sep 2014 17:30:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Aaron Tomlin <atomlin@redhat.com>
Cc: mingo@redhat.com, dzickus@redhat.com, bmr@redhat.com, jcastillo@redhat.com,
        oleg@redhat.com, pzijlstr@redhat.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, x86@kernel.org,
        rostedt@goodmis.org, hannes@cmpxchg.org,
        aneesh.kumar@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, minchan@kernel.org
Subject: Re: [PATCH 1/2] sched: Add helper for task stack page overrun
 checking
Message-ID: <20140904153047.GD346@worktop.programming.kicks-ass.net>
References: <1409842224-11847-1-git-send-email-atomlin@redhat.com>
 <1409842224-11847-2-git-send-email-atomlin@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409842224-11847-2-git-send-email-atomlin@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 03:50:23PM +0100, Aaron Tomlin wrote:

> @@ -537,8 +535,8 @@ void bad_page_fault(struct pt_regs *regs, unsigned long address, int sig)
>  	printk(KERN_ALERT "Faulting instruction address: 0x%08lx\n",
>  		regs->nip);
>  
> -	stackend = end_of_stack(current);
> -	if (current != &init_task && *stackend != STACK_END_MAGIC)
> +	if (current != &init_task &&
> +		task_stack_end_corrupted(current))

superfluous linebreak.

> @@ -2614,6 +2615,8 @@ static inline unsigned long *end_of_stack(struct task_struct *p)
>  }
>  
>  #endif

Here otoh we could do with some extra whitespace

> @@ -171,8 +170,8 @@ check_stack(unsigned long ip, unsigned long *stack)
>  			i++;
>  	}
>  
> -	if ((current != &init_task &&
> -		*(end_of_stack(current)) != STACK_END_MAGIC)) {
> +	if (current != &init_task &&
> +		task_stack_end_corrupted(current)) {

Again, superfluous linebreak.
