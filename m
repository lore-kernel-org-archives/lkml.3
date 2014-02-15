Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaBOJwP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 04:52:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:33248 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaBOJwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 04:52:14 -0500
Date: Sat, 15 Feb 2014 10:52:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Juri Lelli <juri.lelli@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched/deadline: Fix bad accounting of nr_running
Message-ID: <20140215095207.GI14089@laptop.programming.kicks-ass.net>
References: <20140214235946.60a89b65@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214235946.60a89b65@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 11:59:46PM -0500, Steven Rostedt wrote:
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 0dd5e09..84c2454 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -844,14 +844,14 @@ static void __dequeue_task_dl(struct rq *rq,
> struct task_struct *p, int flags) {
>  	dequeue_dl_entity(&p->dl);
>  	dequeue_pushable_dl_task(rq, p);
> +
> +	dec_nr_running(rq);
>  }
>  
>  static void dequeue_task_dl(struct rq *rq, struct task_struct *p, int
> flags) {
>  	update_curr_dl(rq);
>  	__dequeue_task_dl(rq, p, flags);
> -
> -	dec_nr_running(rq);
>  }
>  
>  /*

That patch is so line-wrapped... tskk!
