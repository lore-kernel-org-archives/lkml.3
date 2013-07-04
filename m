Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660Ab3GDJZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:25:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39295 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab3GDJZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:25:03 -0400
Date: Thu, 4 Jul 2013 10:25:00 +0100
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/13] sched: Favour moving tasks towards nodes that
 incurred more faults
Message-ID: <20130704092500.GL1875@suse.de>
References: <1372861300-9973-1-git-send-email-mgorman@suse.de>
 <1372861300-9973-10-git-send-email-mgorman@suse.de>
 <20130703182748.GA18898@dyad.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130703182748.GA18898@dyad.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 08:27:48PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 03, 2013 at 03:21:36PM +0100, Mel Gorman wrote:
> >  static bool migrate_improves_locality(struct task_struct *p, struct lb_env *env)
> >  {
> 
> > +	if (p->numa_faults[task_faults_idx(dst_nid, 1)] >
> > +	    p->numa_faults[task_faults_idx(src_nid, 1)])
> > +		return true;
> 
> > +}
> 
> > +static bool migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
> > +{
> 
> > +	if (p->numa_faults[src_nid] > p->numa_faults[dst_nid])
> >  		return true;
> 
> I bet you wanted to use task_faults_idx() there too ;-)
> 

You won that bet. Fixed.

-- 
Mel Gorman
SUSE Labs
