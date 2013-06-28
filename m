Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab3F1OBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:01:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39619 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab3F1OBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:01:04 -0400
Date: Fri, 28 Jun 2013 15:00:59 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] sched: Split accounting of NUMA hinting faults that
 pass two-stage filter
Message-ID: <20130628140059.GA1875@suse.de>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <1372257487-9749-8-git-send-email-mgorman@suse.de>
 <20130627145658.GV28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130627145658.GV28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 04:56:58PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 26, 2013 at 03:38:06PM +0100, Mel Gorman wrote:
> > +void task_numa_fault(int last_nid, int node, int pages, bool migrated)
> >  {
> >  	struct task_struct *p = current;
> > +	int priv = (cpu_to_node(task_cpu(p)) == last_nid);
> >  
> >  	if (!sched_feat_numa(NUMA))
> >  		return;
> >  
> >  	/* Allocate buffer to track faults on a per-node basis */
> >  	if (unlikely(!p->numa_faults)) {
> > -		int size = sizeof(*p->numa_faults) * nr_node_ids;
> > +		int size = sizeof(*p->numa_faults) * 2 * nr_node_ids;
> >  
> >  		/* numa_faults and numa_faults_buffer share the allocation */
> > -		p->numa_faults = kzalloc(size * 2, GFP_KERNEL);
> > +		p->numa_faults = kzalloc(size * 4, GFP_KERNEL);
> >  		if (!p->numa_faults)
> >  			return;
> 
> So you need a buffer 2x the size in total; but you're now allocating
> a buffer 4x larger than before.
> 
> Isn't doubling size alone sufficient?

/me slaps self

This was a rebase screwup. Thanks.

-- 
Mel Gorman
SUSE Labs
