Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab3GaQGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 12:06:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54852 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab3GaQGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:06:12 -0400
Date: Wed, 31 Jul 2013 18:05:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Don Morris <don.morris@hp.com>
Cc: Mel Gorman <mgorman@suse.de>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched, numa: Use {cpu, pid} to create task groups for
 shared faults
Message-ID: <20130731160553.GF3008@twins.programming.kicks-ass.net>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <20130730113857.GR3008@twins.programming.kicks-ass.net>
 <20130731150751.GA15144@twins.programming.kicks-ass.net>
 <51F93105.8020503@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F93105.8020503@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 11:45:09AM -0400, Don Morris wrote:
> > +
> > +static void task_numa_free(struct task_struct *p)
> > +{
> > +	kfree(p->numa_faults);
> > +	if (p->numa_group) {
> > +		struct numa_group *grp = p->numa_group;
> 
> See below.
> 
> > +		int i;
> > +
> > +		for (i = 0; i < 2*nr_node_ids; i++)
> > +			atomic_long_sub(p->numa_faults[i], &grp->faults[i]);
> > +
> > +		spin_lock(&p->numa_lock);
> > +		spin_lock(&group->lock);
> > +		list_del(&p->numa_entry);
> > +		spin_unlock(&group->lock);
> > +		rcu_assign_pointer(p->numa_group, NULL);
> > +		put_numa_group(grp);
> 
> So is the local variable group or grp here? Got to be one or the
> other to compile...

Feh, compiling is soooo overrated! :-)

Thanks.
