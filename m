Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3F1MWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 08:22:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab3F1MWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 08:22:50 -0400
Date: Fri, 28 Jun 2013 13:22:45 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] sched: Track NUMA hinting faults on per-node basis
Message-ID: <20130628122245.GS1875@suse.de>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <1372257487-9749-3-git-send-email-mgorman@suse.de>
 <20130627155748.GX28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130627155748.GX28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 05:57:48PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 26, 2013 at 03:38:01PM +0100, Mel Gorman wrote:
> > @@ -503,6 +503,18 @@ DECLARE_PER_CPU(struct rq, runqueues);
> >  #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
> >  #define raw_rq()		(&__raw_get_cpu_var(runqueues))
> >  
> > +#ifdef CONFIG_NUMA_BALANCING
> > +extern void sched_setnuma(struct task_struct *p, int node, int shared);
> 
> Stray line; you're introducing that function later with a different
> signature.
> 

Fixed, thanks.

-- 
Mel Gorman
SUSE Labs
