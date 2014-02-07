Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaBGVJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 16:09:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35353 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbaBGVJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 16:09:11 -0500
Date: Fri, 7 Feb 2014 22:09:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] sched: Init idle->on_rq in init_idle()
Message-ID: <20140207210905.GV5002@laptop.programming.kicks-ass.net>
References: <1391803122-4425-1-git-send-email-bigeasy@linutronix.de>
 <1391803122-4425-2-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391803122-4425-2-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 08:58:37PM +0100, Sebastian Andrzej Siewior wrote:
> From: Thomas Gleixner <tglx@linutronix.de>

Distinct lack of rationale here.

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  kernel/sched/core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b46131e..64f75f9 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4473,6 +4473,7 @@ void init_idle(struct task_struct *idle, int cpu)
>  	rcu_read_unlock();
>  
>  	rq->curr = rq->idle = idle;
> +	idle->on_rq = 1;
>  #if defined(CONFIG_SMP)
>  	idle->on_cpu = 1;
>  #endif
> -- 
> 1.9.rc1
> 
