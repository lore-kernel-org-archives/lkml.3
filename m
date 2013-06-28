Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab3F1JCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:02:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45776 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab3F1JCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:02:08 -0400
Date: Fri, 28 Jun 2013 11:01:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] sched: Update NUMA hinting faults once per scan
Message-ID: <20130628090159.GC28407@twins.programming.kicks-ass.net>
References: <1372257487-9749-1-git-send-email-mgorman@suse.de>
 <1372257487-9749-5-git-send-email-mgorman@suse.de>
 <20130628063233.GC17195@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628063233.GC17195@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 12:02:33PM +0530, Srikar Dronamraju wrote:
> * Mel Gorman <mgorman@suse.de> [2013-06-26 15:38:03]:
> > @@ -831,9 +837,13 @@ void task_numa_fault(int node, int pages, bool migrated)
> >  	if (unlikely(!p->numa_faults)) {
> >  		int size = sizeof(*p->numa_faults) * nr_node_ids;
> >  
> > -		p->numa_faults = kzalloc(size, GFP_KERNEL);
> > +		/* numa_faults and numa_faults_buffer share the allocation */
> > +		p->numa_faults = kzalloc(size * 2, GFP_KERNEL);
> 
> Instead of allocating buffer to hold the current faults, cant we pass
> the nr of pages and node information (and probably migrate) to
> task_numa_placement()?.

I'm afraid I don't get your question; there's more storage required than
just the arguments.

> Why should task_struct be passed as an argument to  task_numa_placement().
> It seems it always will be current.

Customary for parts -- motivated by the fact that usage of current
is/can be more expensive than passing an argument.
