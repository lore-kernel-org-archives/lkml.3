Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3HEHck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 03:32:40 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64025 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab3HEHcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 03:32:39 -0400
X-AuditID: 9c930197-b7bfbae000000e88-48-51ff5515a4b8
Date: Mon, 5 Aug 2013 16:32:48 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH v2 3/3] sched: clean-up struct sd_lb_stat
Message-ID: <20130805073248.GC27240@lge.com>
References: <1375408223-10934-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375408223-10934-4-git-send-email-iamjoonsoo.kim@lge.com>
 <51FB382B.80209@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FB382B.80209@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	if (busiest->group_imb) {
> > +		busiest->sum_weighted_load =
> > +			min(busiest->sum_weighted_load, sds->sd_avg_load);
> 
> Right here we get confused as to why the total load is being compared
> against load per task (although you are changing it to load per task above).

Yes, you are right. I will add load_per_task to struct sg_lb_stats.


> > @@ -4771,12 +4763,13 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
> >  	 * Be careful of negative numbers as they'll appear as very large values
> >  	 * with unsigned longs.
> >  	 */
> > -	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
> > +	max_pull = min(busiest->avg_load - sds->sd_avg_load,
> > +						load_above_capacity);
> 
> This is ok, but readability wise max_load is much better. max_load
> signifies the maximum load per task on a group in this sd, and avg_load
> signifies the total load per task across the sd. You are checking if
> there is imbalance in the total load in the sd and try to even it out
> across the sd.  Here "busiest" does not convey this immediately.

You may be confused. max_load doesn't means the maximum load per task.
It means that the busiest group's load per cpu power. And here max doesn't
mean maximum load in this sd, instead, load of busiest sg. IMO,
busiest->avg_load convey proper meaning.

Thanks.
