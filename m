Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab3FELPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:15:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48919 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3FELPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:15:51 -0400
Date: Wed, 5 Jun 2013 13:15:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/3] sched: code refine in unthrottle_cfs_rq()
Message-ID: <20130605111544.GA8923@twins.programming.kicks-ass.net>
References: <51AD87A8.6080608@linux.vnet.ibm.com>
 <51AD87EB.1070605@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AD87EB.1070605@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 02:23:39PM +0800, Michael Wang wrote:
> Directly use rq to save some code.
> 
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>

Please send patches against tip/master; the below didn't apply cleanly.
It was a trivial conflict so I applied force and made it fit.

Thanks!

> ---
>  kernel/sched/fair.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index c61a614..1e10911 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2298,7 +2298,7 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
>  	int enqueue = 1;
>  	long task_delta;
>  
> -	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
> +	se = cfs_rq->tg->se[cpu_of(rq)];
>  
>  	cfs_rq->throttled = 0;
>  	raw_spin_lock(&cfs_b->lock);
> -- 
> 1.7.4.1
> 
