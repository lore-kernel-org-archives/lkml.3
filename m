Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab3JIMst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:48:49 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:43392 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3JIMss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:48:48 -0400
Date: Wed, 9 Oct 2013 14:48:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/63] Basic scheduler support for automatic NUMA
 balancing V9
Message-ID: <20131009124844.GA21428@gmail.com>
References: <1381141781-10992-1-git-send-email-mgorman@suse.de>
 <20131009110353.GA19370@gmail.com>
 <20131009120544.GE3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131009120544.GE3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Oct 09, 2013 at 01:03:54PM +0200, Ingo Molnar wrote:
> >  kernel/sched/fair.c:819:22: warning: 'task_h_load' declared 'static' but never defined [-Wunused-function]
> 
> Not too pretty, but it avoids the warning:
> 
> ---
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -681,6 +681,8 @@ static u64 sched_vslice(struct cfs_rq *c
>  }
>  
>  #ifdef CONFIG_SMP
> +static unsigned long task_h_load(struct task_struct *p);
> +
>  static inline void __update_task_entity_contrib(struct sched_entity *se);
>  
>  /* Give new task start runnable values to heavy its load in infant time */
> @@ -816,8 +818,6 @@ update_stats_curr_start(struct cfs_rq *c
>   * Scheduling class queueing methods:
>   */
>  
> -static unsigned long task_h_load(struct task_struct *p);
> -
>  #ifdef CONFIG_NUMA_BALANCING

Hm, so we really want to do a split-up of this file once things have 
calmed down - that will address such dependency issues.

Until then this fix will do, I've backmerged it to the originating patch.

Thanks,

	Ingo
