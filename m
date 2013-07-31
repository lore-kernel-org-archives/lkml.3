Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024Ab3GaJiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:38:20 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:51838 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757147Ab3GaJiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:38:18 -0400
Date: Wed, 31 Jul 2013 15:08:02 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Hillf Danton <dhillf@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/18] sched: Reschedule task on preferred NUMA node once
 selected
Message-ID: <20130731093802.GB4880@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1373901620-2021-1-git-send-email-mgorman@suse.de>
 <1373901620-2021-9-git-send-email-mgorman@suse.de>
 <CAJd=RBB8rzy8bZ1JWkkmGBX2ucZ0kr9aOsiiwgV2s0y9_0z6fw@mail.gmail.com>
 <20130731090727.GI2296@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130731090727.GI2296@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073109-5806-0000-0000-000022406B25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mel Gorman <mgorman@suse.de> [2013-07-31 10:07:27]:

> On Wed, Jul 17, 2013 at 09:31:05AM +0800, Hillf Danton wrote:
> > On Mon, Jul 15, 2013 at 11:20 PM, Mel Gorman <mgorman@suse.de> wrote:
> > > +static int
> > > +find_idlest_cpu_node(int this_cpu, int nid)
> > > +{
> > > +       unsigned long load, min_load = ULONG_MAX;
> > > +       int i, idlest_cpu = this_cpu;
> > > +
> > > +       BUG_ON(cpu_to_node(this_cpu) == nid);
> > > +
> > > +       rcu_read_lock();
> > > +       for_each_cpu(i, cpumask_of_node(nid)) {
> > 
> > Check allowed CPUs first if task is given?
> > 
> 
> If the task is not allowed to run on the CPUs for that node then how
> were the NUMA hinting faults recorded?
> 

But still we could check if the task is allowed to run on a cpu before we
capture the load of the cpu. This would avoid us trying to select a cpu
whose load is low but which cannot run this task.

> -- 
> Mel Gorman
> SUSE Labs
> 

-- 
Thanks and Regards
Srikar Dronamraju

