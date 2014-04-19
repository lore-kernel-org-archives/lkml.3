Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaDSIMF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 04:12:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:16880 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaDSILx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 04:11:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,887,1389772800"; 
   d="scan'208";a="515792061"
Date: Sat, 19 Apr 2014 16:11:46 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [sched,rcu] b84c4e08143: +3.1% will-it-scale.per_thread_ops
Message-ID: <20140419081146.GA29068@localhost>
References: <20140417040353.GF8702@localhost>
 <20140417135503.GK4496@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417135503.GK4496@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 06:55:03AM -0700, Paul E. McKenney wrote:
> On Thu, Apr 17, 2014 at 12:03:53PM +0800, Fengguang Wu wrote:
> > Hi Paul,
> > 
> > FYI, this improves will-it-scale/open1 throughput.
> 
> Cool!  Not a planned benefit, but I will take it.  ;-)
> 
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git dev.2014.04.14a
> > commit b84c4e08143c98dad4b4d139f08db0b98b0d3ec4 ("sched,rcu: Make cond_resched() report RCU quiescent states")
> 
> But how should I read the data below?  I see lots of positive percentages
> and lots of negative percentages for the delta, and all near zero for
> standard deviation.  Is the overall improvement an average of these or
> some such?  What is being measured?

There are a lot of things being measured, which are shown after each
"TOTAL".  For example, to get an overview of the report:

grep "TOTAL" this_email

     563496 ~ 0%      +3.1%     581059 ~ 0%  TOTAL will-it-scale.per_thread_ops
     756894 ~ 0%      +2.8%     778452 ~ 0%  TOTAL will-it-scale.per_process_ops
       0.57 ~ 0%      -2.7%       0.55 ~ 0%  TOTAL will-it-scale.scalability
     346764 ~ 2%     -74.0%      90164 ~ 1%  TOTAL slabinfo.kmalloc-256.active_objs
      10837 ~ 2%     -73.9%       2824 ~ 1%  TOTAL slabinfo.kmalloc-256.active_slabs
      10837 ~ 2%     -73.9%       2824 ~ 1%  TOTAL slabinfo.kmalloc-256.num_slabs
     346821 ~ 2%     -73.9%      90393 ~ 1%  TOTAL slabinfo.kmalloc-256.num_objs
     105961 ~ 1%     -63.0%      39153 ~ 1%  TOTAL meminfo.SUnreclaim
      26432 ~ 1%     -62.9%       9814 ~ 1%  TOTAL proc-vmstat.nr_slab_unreclaimable
      87318 ~ 0%    +130.0%     200809 ~ 0%  TOTAL softirqs.RCU
     140354 ~ 1%     -47.6%      73490 ~ 0%  TOTAL meminfo.Slab
      77391 ~ 1%     -46.7%      41235 ~ 2%  TOTAL cpuidle.C6-NHM.usage
      38368 ~ 2%     -37.6%      23954 ~ 2%  TOTAL softirqs.SCHED
       1.24 ~ 4%     -35.4%       0.80 ~ 3%  TOTAL perf-profile.cpu-cycles.do_notify_resume.int_signal.close
       1.43 ~ 4%     +41.9%       2.03 ~ 4%  TOTAL perf-profile.cpu-cycles.rcu_process_callbacks.__do_softirq.irq_exit.smp_apic_timer_in
rupt.apic_timer_interrupt
       1.27 ~ 3%     -30.0%       0.89 ~ 6%  TOTAL perf-profile.cpu-cycles.setup_object.isra.46.new_slab.__slab_alloc.kmem_cache_alloc.g
empty_filp
       1.54 ~ 7%     +35.6%       2.09 ~ 8%  TOTAL perf-profile.cpu-cycles.kmem_cache_alloc.getname_flags.getname.do_sys_open.sys_open
       4.21 ~ 2%     -29.1%       2.98 ~ 3%  TOTAL perf-profile.cpu-cycles.link_path_walk.path_openat.do_filp_open.do_sys_open.sys_open
       1.37 ~ 4%     -23.1%       1.05 ~ 7%  TOTAL perf-profile.cpu-cycles.__d_lookup_rcu.lookup_fast.link_path_walk.path_openat.do_filp
en
       0.88 ~17%     +29.1%       1.14 ~ 9%  TOTAL perf-profile.cpu-cycles.path_init.path_openat.do_filp_open.do_sys_open.sys_open
       0.67 ~16%     +33.6%       0.90 ~10%  TOTAL perf-profile.cpu-cycles.restore_sigcontext.sys_rt_sigreturn.stub_rt_sigreturn.raise
       3.19 ~ 1%     +17.4%       3.74 ~ 5%  TOTAL perf-profile.cpu-cycles.file_free_rcu.rcu_process_callbacks.__do_softirq.irq_exit.smp
ic_timer_interrupt
       4329 ~ 7%     +15.2%       4986 ~ 5%  TOTAL slabinfo.vm_area_struct.active_objs
       2536 ~ 1%     -75.8%        614 ~ 9%  TOTAL time.involuntary_context_switches
      32593 ~ 1%     -62.1%      12349 ~ 2%  TOTAL interrupts.0:IO-APIC-edge.timer
       6934 ~ 9%     +86.2%      12908 ~ 7%  TOTAL interrupts.RES
        490 ~ 1%     -37.3%        307 ~ 1%  TOTAL vmstat.system.cs
       1639 ~ 0%      -8.8%       1495 ~ 0%  TOTAL vmstat.system.in
     819681 ~ 0%      -3.7%     789527 ~ 0%  TOTAL interrupts.LOC

> > Legend:
> > 	~XX%    - stddev percent
> > 	[+-]XX% - change percent
> > 
> > 
> >                           time.involuntary_context_switches
> > 
> >    3500 ++------------------------------------------------------------------+
> >         |             .*..                                                  |
> >    3000 ++         .*.    *..*..  .*..*.. .*..                              |
> >         *..*..*..*.             *.       *                                  |
> >         |                                     *..*..     .*..     .*..*     |
> >    2500 ++                                          *..*.    *..*.          |
> >         |                                                                   |
> >    2000 ++                                                                  |
> >         |                                                                   |
> >    1500 ++                                                                  |
> >         |                                                                   |
> >         |                                                                   |
> >    1000 ++                                                                  |
> >         |     O  O  O              O  O                   O  O     O        O
> >     500 O+-O-----------O--O--O--O--------O-O--O--O--O--O--------O-----O--O--+
> > 
> > 
> > 	[*] bisect-good sample
> > 	[O] bisect-bad  sample
> 
> So the good case increases involuntary context switches, but helps something
> else?  Or does the benefit stem from increased involuntary context switches
> and thus less time spinning or some such?

In bisect POV, branch BASE is good and HEAD is bad. Which has nothing
to do with the improvement/regression in performance POV.

Here the HEAD(bisect bad) commit has less involuntary_context_switches
which indicates an improvement over BASE.  It does look like close to
the root cause of improved will-it-scale throughput.

Thanks,
Fengguang
