Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab3GaHyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 03:54:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41699 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab3GaHyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 03:54:21 -0400
Date: Wed, 31 Jul 2013 08:54:14 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/18] sched: Track NUMA hinting faults on per-node basis
Message-ID: <20130731075414.GD2296@suse.de>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <1373901620-2021-3-git-send-email-mgorman@suse.de>
 <20130717105030.GB17211@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130717105030.GB17211@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 12:50:30PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 15, 2013 at 04:20:04PM +0100, Mel Gorman wrote:
> > index cc03cfd..c5f773d 100644
> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
> > @@ -503,6 +503,17 @@ DECLARE_PER_CPU(struct rq, runqueues);
> >  #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
> >  #define raw_rq()		(&__raw_get_cpu_var(runqueues))
> >  
> > +#ifdef CONFIG_NUMA_BALANCING
> > +static inline void task_numa_free(struct task_struct *p)
> > +{
> > +	kfree(p->numa_faults);
> > +}
> > +#else /* CONFIG_NUMA_BALANCING */
> > +static inline void task_numa_free(struct task_struct *p)
> > +{
> > +}
> > +#endif /* CONFIG_NUMA_BALANCING */
> > +
> >  #ifdef CONFIG_SMP
> >  
> >  #define rcu_dereference_check_sched_domain(p) \
> 
> 
> I also need the below hunk to make it compile:
> 

Weird, I do not see the same problem so it's something .config specific.
Can you send me the .config you used please?

-- 
Mel Gorman
SUSE Labs
