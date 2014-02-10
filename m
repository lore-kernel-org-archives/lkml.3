Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaBJLYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:24:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42597 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbaBJLYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:24:19 -0500
Date: Mon, 10 Feb 2014 12:24:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org
Subject: Re: [PATCH 06/14] asmlinkage: Make trace_hardirq visible
Message-ID: <20140210112411.GH9987@twins.programming.kicks-ass.net>
References: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
 <1391845930-28580-6-git-send-email-ak@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391845930-28580-6-git-send-email-ak@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 08:52:02AM +0100, Andi Kleen wrote:
> Can be called from assembler code.

This lacks context; what does __visible do and why does it matter for
asm.

> Cc: peterz@infradead.org
> Cc: mingo@kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  kernel/locking/lockdep.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
> index c8b6753c..aa3bf15 100644
> --- a/kernel/locking/lockdep.c
> +++ b/kernel/locking/lockdep.c
> @@ -2557,7 +2557,7 @@ static void __trace_hardirqs_on_caller(unsigned long ip)
>  	debug_atomic_inc(hardirqs_on_events);
>  }
>  
> -void trace_hardirqs_on_caller(unsigned long ip)
> +__visible void trace_hardirqs_on_caller(unsigned long ip)
>  {
>  	time_hardirqs_on(CALLER_ADDR0, ip);
>  
> @@ -2610,7 +2610,7 @@ EXPORT_SYMBOL(trace_hardirqs_on);
>  /*
>   * Hardirqs were disabled:
>   */
> -void trace_hardirqs_off_caller(unsigned long ip)
> +__visible void trace_hardirqs_off_caller(unsigned long ip)
>  {
>  	struct task_struct *curr = current;
>  
> -- 
> 1.8.5.2
> 
