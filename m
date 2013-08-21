Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab3HUIiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:38:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50804 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab3HUIiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:38:12 -0400
Date: Wed, 21 Aug 2013 10:38:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH 04/10] sched, fair: Shrink sg_lb_stats and play memset
 games
Message-ID: <20130821083802.GO3258@twins.programming.kicks-ass.net>
References: <20130819160058.539049611@infradead.org>
 <20130819160425.310264395@infradead.org>
 <20130821020829.GA6142@lge.com>
 <20130821022002.GC6142@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821022002.GC6142@lge.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 11:20:02AM +0900, Joonsoo Kim wrote:
> > With below change, we can simply do 'offsetof(struct sd_lb_stats, busiest_stat)'.
> > 
> > @@ -4546,7 +4546,7 @@ static bool update_sd_pick_busiest(struct lb_env *env,
> >                                    struct sched_group *sg,
> >                                    struct sg_lb_stats *sgs)
> >  {
> > -       if (sgs->avg_load <= sds->busiest_stat.avg_load)
> > +       if (!sds->busiest && sgs->avg_load <= sds->busiest_stat.avg_load)
> >                 return false;
> >  
> >         if (sgs->sum_nr_running > sgs->group_capacity)
> > 
> 
> Sorry, instead of !sds->busiest, it should be sds->busiest. :)

Of course ;-) However I'm not sure which I prefer.. adding this extra
condition or having the initialization extra tricky. I'll sit on it a
little longer.
