Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbaAQO4d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:56:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbaAQO4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:56:31 -0500
Date: Fri, 17 Jan 2014 14:56:27 +0000
From: Mel Gorman <mgorman@suse.de>
To: Preeti Murthy <preeti.lkml@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH] sched: Calculate effective load even if local weight is 0
Message-ID: <20140117145627.GY4963@suse.de>
References: <20140106113912.GC6178@suse.de>
 <CAM4v1pNQsoJxgC9Kwe+ca=hSbDYr3huNrchzqWEvs26AfypmSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAM4v1pNQsoJxgC9Kwe+ca=hSbDYr3huNrchzqWEvs26AfypmSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 01:22:40PM +0530, Preeti Murthy wrote:
> Hi,
> 
> On Mon, Jan 6, 2014 at 5:09 PM, Mel Gorman <mgorman@suse.de> wrote:
> > (Rik, you authored this patch so it should be sent from you and needs a
> > signed-off assuming people are ok with the changelog.)
> >
> > Thomas Hellstrom bisected a regression where erratic 3D performance is
> > experienced on virtual machines as measured by glxgears. It identified
> > commit 58d081b5 (sched/numa: Avoid overloading CPUs on a preferred NUMA
> > node) as the problem which had modified the behaviour of effective_load.
> >
> > Effective load calculates the difference to the system-wide load if a
> > scheduling entity was moved to another CPU. The task group is not heavier
> > as a result of the move but overall system load can increase/decrease as a
> > result of the change. Commit 58d081b5 (sched/numa: Avoid overloading CPUs
> > on a preferred NUMA node) changed effective_load to make it suitable for
> > calculating if a particular NUMA node was compute overloaded. To reduce
> > the cost of the function, it assumed that a current sched entity weight
> > of 0 was uninteresting but that is not the case.
> >
> > wake_affine uses a weight of 0 for sync wakeups on the grounds that it
> > is assuming the waking task will sleep and not contribute to load in the
> > near future. In this case, we still want to calculate the effective load
> > of the sched entity hierarchy. As effective_load is no longer used by
> 
> Would it be worth mentioning that besides sync wakeups, wake_affine() uses a
> weight of 0 for the sched entity, for effective load calculation on
> the prev_cpu as well?
> This is so as to find the effect of  moving this task away from the
> prev_cpu. Here
> too we are interested in calculating the effective load of the root
> task group of this
> sched entity on the prev_cpu and the below restored check will be relevant.
> 
> Without the below check the difference in the loads of the wake affine
> CPU and the
> prev_cpu can get messed up.
> 

I was too slow getting to this mail unfortunately. The patch is already
merged upstream with the changelog as-is.

-- 
Mel Gorman
SUSE Labs
