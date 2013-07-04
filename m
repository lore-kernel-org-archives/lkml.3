Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab3GDOkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 10:40:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754032Ab3GDOkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 10:40:23 -0400
Date: Thu, 4 Jul 2013 15:40:18 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/13] sched: Account for the number of preferred tasks
 running on a node when selecting a preferred node
Message-ID: <20130704144018.GS1875@suse.de>
References: <1372861300-9973-1-git-send-email-mgorman@suse.de>
 <1372861300-9973-14-git-send-email-mgorman@suse.de>
 <20130703183243.GB18898@dyad.programming.kicks-ass.net>
 <20130704093716.GO1875@suse.de>
 <20130704130719.GC29916@linux.vnet.ibm.com>
 <20130704135415.GR1875@suse.de>
 <20130704140612.GO18898@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130704140612.GO18898@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 04:06:13PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 04, 2013 at 02:54:15PM +0100, Mel Gorman wrote:
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 9247345..387f28d 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -863,9 +863,13 @@ find_idlest_cpu_node(int this_cpu, int nid)
> >  		load = weighted_cpuload(i);
> >  
> >  		if (load < min_load) {
> > -			/* Do not preempt a task running on a preferred node */
> > +			/*
> > +			 * Do not preempt a task running on a preferred node or
> > +			 * tasks are are pinned to their current CPU
> > +			 */
> >  			struct task_struct *p = cpu_rq(i)->curr;
> > -			if (p->numa_preferred_nid != nid) {
> > +			if (p->numa_preferred_nid != nid &&
> > +			    cpumask_weight(tsk_cpus_allowed(p)) > 1) {
> 
> We have p->nr_cpus_allowed for that.
> 

/me slaps self

That's a bit easier to calculate, thanks.

-- 
Mel Gorman
SUSE Labs
