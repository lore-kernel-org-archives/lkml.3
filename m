Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbaFZCSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 22:18:39 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42807 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbaFZCSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 22:18:38 -0400
Date: Wed, 25 Jun 2014 19:18:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Jet Chen <jet.chen@intel.com>
Subject: Re: [rcu] e552592e038: +39.2% vm-scalability.throughput, +19.7%
 turbostat.Pkg_W
Message-ID: <20140626021832.GR4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140626014219.GB12239@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626014219.GB12239@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062602-9332-0000-0000-00000133E14B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 09:42:19AM +0800, Fengguang Wu wrote:
> Hi Paul,
> 
> We noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git urgent.2014.06.21a
> commit e552592e0383bc72e35eb21a9fabd84ad873cff1 ("rcu: Reduce overhead of cond_resched() checks for RCU")

This one is also obsolete, but the good news is that the replacement
commit 4a81e8328d37 (Reduce overhead of cond_resched() checks for RCU)
is quite similar, so here is hoping for similar results from it.

							Thanx, Paul

> Test case: brickland3/vm-scalability/300s-anon-w-seq-mt-64G
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>   89766370 ~ 6%     +39.2%   1.25e+08 ~ 9%  TOTAL vm-scalability.throughput
>  1.317e+09 ~ 8%     -45.2%   7.21e+08 ~10%  TOTAL cpuidle.C6-IVT-4S.time
>          9 ~ 6%     +58.8%         15 ~ 5%  TOTAL vmstat.procs.r
>      12.27 ~14%     +44.7%      17.74 ~12%  TOTAL turbostat.%c1
>      20538 ~ 4%     -21.3%      16155 ~ 4%  TOTAL cpuidle.C6-IVT-4S.usage
>      77.66 ~ 2%     -15.0%      65.98 ~ 5%  TOTAL turbostat.%c6
>        260 ~ 2%     -16.4%        217 ~ 4%  TOTAL vmstat.memory.buff
>      51920 ~ 7%     -14.3%      44489 ~ 5%  TOTAL numa-meminfo.node0.PageTables
>      53822 ~ 5%     -15.6%      45404 ~ 6%  TOTAL proc-vmstat.nr_page_table_pages
>     215196 ~ 5%     -15.7%     181409 ~ 6%  TOTAL meminfo.PageTables
>      52182 ~ 4%     -15.2%      44271 ~ 6%  TOTAL proc-vmstat.nr_anon_transparent_hugepages
>      12881 ~ 7%     -13.4%      11150 ~ 5%  TOTAL numa-vmstat.node0.nr_page_table_pages
>  1.068e+08 ~ 4%     -15.2%   90492587 ~ 6%  TOTAL meminfo.AnonHugePages
>   26983682 ~ 4%     -14.5%   23071571 ~ 6%  TOTAL proc-vmstat.nr_anon_pages
>  1.079e+08 ~ 4%     -14.5%   92289854 ~ 6%  TOTAL meminfo.AnonPages
>  1.083e+08 ~ 4%     -14.2%   92897630 ~ 6%  TOTAL meminfo.Active(anon)
>  1.084e+08 ~ 4%     -14.2%   92970821 ~ 6%  TOTAL meminfo.Active
>   27067517 ~ 4%     -14.2%   23232055 ~ 6%  TOTAL proc-vmstat.nr_active_anon
>      52565 ~ 3%     -12.0%      46273 ~ 3%  TOTAL proc-vmstat.nr_shmem
>      52499 ~ 3%     -12.0%      46215 ~ 3%  TOTAL proc-vmstat.nr_inactive_anon
>     214447 ~ 3%     -10.5%     191862 ~ 2%  TOTAL meminfo.Shmem
>     214197 ~ 3%     -10.5%     191636 ~ 2%  TOTAL meminfo.Inactive(anon)
>       2779 ~13%     -53.5%       1291 ~19%  TOTAL time.involuntary_context_switches
>       1156 ~ 8%     +82.3%       2108 ~ 9%  TOTAL time.percent_of_cpu_this_job_got
>      11.58 ~10%     -44.4%       6.45 ~ 9%  TOTAL time.elapsed_time
>       1008 ~ 5%     +79.5%       1810 ~ 7%  TOTAL time.voluntary_context_switches
>       9.23 ~ 8%     +72.8%      15.95 ~ 8%  TOTAL turbostat.%c0
>      12679 ~ 8%     +70.8%      21659 ~ 9%  TOTAL vmstat.system.in
>        145 ~ 7%     +60.6%        234 ~ 8%  TOTAL vmstat.io.bo
>       3721 ~ 7%     +35.2%       5029 ~ 8%  TOTAL vmstat.system.cs
>            ~ 1%     +26.7%            ~ 5%  TOTAL turbostat.Cor_W
>            ~ 2%     +21.2%            ~ 3%  TOTAL turbostat.RAM_W
>            ~ 1%     +19.7%            ~ 4%  TOTAL turbostat.Pkg_W
> 
> 
> All test cases:
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>   89766370 ~ 6%     +39.2%   1.25e+08 ~ 9%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>   89766370 ~ 6%     +39.2%   1.25e+08 ~ 9%  TOTAL vm-scalability.throughput
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>       0.36 ~ 1%      -9.8%       0.32 ~ 2%  lkp-nex05/will-it-scale/open1
>       0.36 ~ 1%      -9.8%       0.32 ~ 2%  TOTAL will-it-scale.scalability
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>     466616 ~ 1%      -2.6%     454267 ~ 1%  lkp-nex05/will-it-scale/open1
>     511556 ~ 0%      -1.3%     504762 ~ 0%  lkp-snb01/will-it-scale/signal1
>     978172 ~ 0%      -2.0%     959029 ~ 0%  TOTAL will-it-scale.per_process_ops
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>    1381706 ~ 1%      +2.3%    1413190 ~ 0%  lkp-snb01/will-it-scale/futex2
>     299558 ~ 0%      -1.8%     294312 ~ 0%  lkp-snb01/will-it-scale/signal1
>    1681264 ~ 1%      +1.6%    1707503 ~ 0%  TOTAL will-it-scale.per_thread_ops
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      84771 ~ 2%    +575.2%     572390 ~ 1%  lkp-nex05/will-it-scale/open1
>      84771 ~ 2%    +575.2%     572390 ~ 1%  TOTAL slabinfo.kmalloc-256.active_objs
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>       2656 ~ 2%    +573.8%      17896 ~ 1%  lkp-nex05/will-it-scale/open1
>       2656 ~ 2%    +573.8%      17896 ~ 1%  TOTAL slabinfo.kmalloc-256.num_slabs
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      85011 ~ 2%    +573.7%     572697 ~ 1%  lkp-nex05/will-it-scale/open1
>      85011 ~ 2%    +573.7%     572697 ~ 1%  TOTAL slabinfo.kmalloc-256.num_objs
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>       2656 ~ 2%    +573.8%      17896 ~ 1%  lkp-nex05/will-it-scale/open1
>       2656 ~ 2%    +573.8%      17896 ~ 1%  TOTAL slabinfo.kmalloc-256.active_slabs
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>    1533310 ~ 2%     -83.7%     250652 ~ 1%  lkp-nex05/will-it-scale/open1
>     289790 ~ 4%     -67.2%      94913 ~ 4%  lkp-snb01/will-it-scale/futex2
>     204559 ~ 4%     -62.6%      76449 ~ 7%  lkp-snb01/will-it-scale/signal1
>    2027660 ~ 3%     -79.2%     422015 ~ 3%  TOTAL softirqs.RCU
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      47388 ~ 5%    +147.5%     117277 ~ 1%  lkp-nex05/will-it-scale/open1
>      47388 ~ 5%    +147.5%     117277 ~ 1%  TOTAL numa-meminfo.node0.SUnreclaim
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      11836 ~ 5%    +149.4%      29520 ~ 2%  lkp-nex05/will-it-scale/open1
>      11836 ~ 5%    +149.4%      29520 ~ 2%  TOTAL numa-vmstat.node0.nr_slab_unreclaimable
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      97325 ~ 0%    +125.2%     219188 ~ 1%  lkp-nex05/will-it-scale/open1
>      97325 ~ 0%    +125.2%     219188 ~ 1%  TOTAL meminfo.SUnreclaim
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      24304 ~ 0%    +125.0%      54686 ~ 0%  lkp-nex05/will-it-scale/open1
>      24304 ~ 0%    +125.0%      54686 ~ 0%  TOTAL proc-vmstat.nr_slab_unreclaimable
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>       6364 ~ 8%    +117.8%      13864 ~ 3%  lkp-nex05/will-it-scale/open1
>       6364 ~ 8%    +117.8%      13864 ~ 3%  TOTAL numa-vmstat.node1.nr_slab_unreclaimable
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      25487 ~ 8%    +115.7%      54988 ~ 4%  lkp-nex05/will-it-scale/open1
>      25487 ~ 8%    +115.7%      54988 ~ 4%  TOTAL numa-meminfo.node1.SUnreclaim
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      63365 ~ 5%    +110.5%     133379 ~ 1%  lkp-nex05/will-it-scale/open1
>      63365 ~ 5%    +110.5%     133379 ~ 1%  TOTAL numa-meminfo.node0.Slab
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>       6335 ~11%     +83.5%      11625 ~ 4%  lkp-nex05/will-it-scale/open1
>       6335 ~11%     +83.5%      11625 ~ 4%  TOTAL numa-vmstat.node3.nr_slab_unreclaimable
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      25370 ~11%     +82.1%      46193 ~ 5%  lkp-nex05/will-it-scale/open1
>      25370 ~11%     +82.1%      46193 ~ 5%  TOTAL numa-meminfo.node3.SUnreclaim
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>     140861 ~ 0%     +86.5%     262647 ~ 1%  lkp-nex05/will-it-scale/open1
>     140861 ~ 0%     +86.5%     262647 ~ 1%  TOTAL meminfo.Slab
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>  1.317e+09 ~ 8%     -45.2%   7.21e+08 ~10%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>  1.317e+09 ~ 8%     -45.2%   7.21e+08 ~10%  TOTAL cpuidle.C6-IVT-4S.time
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      38627 ~ 5%     +77.8%      68673 ~ 5%  lkp-nex05/will-it-scale/open1
>      38627 ~ 5%     +77.8%      68673 ~ 5%  TOTAL numa-meminfo.node1.Slab
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>       1.10 ~ 5%     +70.3%       1.88 ~ 0%  lkp-nex05/will-it-scale/open1
>       1.10 ~ 5%     +70.3%       1.88 ~ 0%  TOTAL perf-profile.cpu-cycles.setup_object.isra.47.__slab_alloc.kmem_cache_alloc.get_empty_filp.path_openat
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>       2.54 ~ 6%     -37.7%       1.58 ~ 5%  lkp-snb01/will-it-scale/futex2
>       2.54 ~ 6%     -37.7%       1.58 ~ 5%  TOTAL perf-profile.cpu-cycles.get_futex_key.futex_wait_setup.futex_wait.do_futex.sys_futex
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>          9 ~ 6%     +58.8%         15 ~ 5%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>          9 ~ 6%     +58.8%         15 ~ 5%  TOTAL vmstat.procs.r
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      12.27 ~14%     +44.7%      17.74 ~12%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>      12.27 ~14%     +44.7%      17.74 ~12%  TOTAL turbostat.%c1
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>     661578 ~ 2%     -33.4%     440676 ~ 0%  lkp-nex05/will-it-scale/open1
>     661578 ~ 2%     -33.4%     440676 ~ 0%  TOTAL cpuidle.C3-NHM.usage
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      39783 ~ 9%     +50.5%      59862 ~ 5%  lkp-nex05/will-it-scale/open1
>      39783 ~ 9%     +50.5%      59862 ~ 5%  TOTAL numa-meminfo.node3.Slab
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>       2.03 ~ 8%     +34.1%       2.73 ~ 2%  lkp-nex05/will-it-scale/open1
>       2.03 ~ 8%     +34.1%       2.73 ~ 2%  TOTAL perf-profile.cpu-cycles.rcu_nocb_kthread.kthread.ret_from_fork
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      20538 ~ 4%     -21.3%      16155 ~ 4%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>      20538 ~ 4%     -21.3%      16155 ~ 4%  TOTAL cpuidle.C6-IVT-4S.usage
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>       1.07 ~ 4%     -17.3%       0.88 ~ 8%  lkp-nex05/will-it-scale/open1
>       1.07 ~ 4%     -17.3%       0.88 ~ 8%  TOTAL perf-profile.cpu-cycles.__alloc_fd.get_unused_fd_flags.do_sys_open.sys_open.system_call_fastpath
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      77.66 ~ 2%     -15.0%      65.98 ~ 5%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>      77.66 ~ 2%     -15.0%      65.98 ~ 5%  TOTAL turbostat.%c6
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>       0.96 ~ 3%     -14.8%       0.82 ~ 5%  lkp-snb01/will-it-scale/futex2
>       0.96 ~ 3%     -14.8%       0.82 ~ 5%  TOTAL perf-profile.cpu-cycles.put_page.get_futex_key.futex_wait_setup.futex_wait.do_futex
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>       1.08 ~ 4%     +22.4%       1.33 ~ 2%  lkp-nex05/will-it-scale/open1
>       1.08 ~ 4%     +22.4%       1.33 ~ 2%  TOTAL perf-profile.cpu-cycles.memset.get_empty_filp.path_openat.do_filp_open.do_sys_open
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>        260 ~ 2%     -16.4%        217 ~ 4%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>        260 ~ 2%     -16.4%        217 ~ 4%  TOTAL vmstat.memory.buff
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      51920 ~ 7%     -14.3%      44489 ~ 5%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>      51920 ~ 7%     -14.3%      44489 ~ 5%  TOTAL numa-meminfo.node0.PageTables
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      53822 ~ 5%     -15.6%      45404 ~ 6%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>      53822 ~ 5%     -15.6%      45404 ~ 6%  TOTAL proc-vmstat.nr_page_table_pages
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>     215196 ~ 5%     -15.7%     181409 ~ 6%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>     215196 ~ 5%     -15.7%     181409 ~ 6%  TOTAL meminfo.PageTables
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      52182 ~ 4%     -15.2%      44271 ~ 6%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>      52182 ~ 4%     -15.2%      44271 ~ 6%  TOTAL proc-vmstat.nr_anon_transparent_hugepages
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      12881 ~ 7%     -13.4%      11150 ~ 5%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>      12881 ~ 7%     -13.4%      11150 ~ 5%  TOTAL numa-vmstat.node0.nr_page_table_pages
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>  1.068e+08 ~ 4%     -15.2%   90492587 ~ 6%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>  1.068e+08 ~ 4%     -15.2%   90492587 ~ 6%  TOTAL meminfo.AnonHugePages
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>   26983682 ~ 4%     -14.5%   23071571 ~ 6%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>   26983682 ~ 4%     -14.5%   23071571 ~ 6%  TOTAL proc-vmstat.nr_anon_pages
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>       1.83 ~ 6%     +19.3%       2.18 ~ 5%  lkp-nex05/will-it-scale/open1
>       1.83 ~ 6%     +19.3%       2.18 ~ 5%  TOTAL perf-profile.cpu-cycles.get_empty_filp.path_openat.do_filp_open.do_sys_open.sys_open
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>  1.079e+08 ~ 4%     -14.5%   92289854 ~ 6%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>  1.079e+08 ~ 4%     -14.5%   92289854 ~ 6%  TOTAL meminfo.AnonPages
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>     254457 ~ 2%     -12.2%     223290 ~ 1%  lkp-nex05/will-it-scale/open1
>     254457 ~ 2%     -12.2%     223290 ~ 1%  TOTAL softirqs.SCHED
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>  1.083e+08 ~ 4%     -14.2%   92897630 ~ 6%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>  1.083e+08 ~ 4%     -14.2%   92897630 ~ 6%  TOTAL meminfo.Active(anon)
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>  1.084e+08 ~ 4%     -14.2%   92970821 ~ 6%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>  1.084e+08 ~ 4%     -14.2%   92970821 ~ 6%  TOTAL meminfo.Active
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>   27067517 ~ 4%     -14.2%   23232055 ~ 6%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>   27067517 ~ 4%     -14.2%   23232055 ~ 6%  TOTAL proc-vmstat.nr_active_anon
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      52565 ~ 3%     -12.0%      46273 ~ 3%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>      52565 ~ 3%     -12.0%      46273 ~ 3%  TOTAL proc-vmstat.nr_shmem
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      52499 ~ 3%     -12.0%      46215 ~ 3%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>      52499 ~ 3%     -12.0%      46215 ~ 3%  TOTAL proc-vmstat.nr_inactive_anon
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>     214447 ~ 3%     -10.5%     191862 ~ 2%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>     214447 ~ 3%     -10.5%     191862 ~ 2%  TOTAL meminfo.Shmem
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>     214197 ~ 3%     -10.5%     191636 ~ 2%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>     214197 ~ 3%     -10.5%     191636 ~ 2%  TOTAL meminfo.Inactive(anon)
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>     681017 ~ 0%     +10.3%     751298 ~ 0%  lkp-nex05/will-it-scale/open1
>     681017 ~ 0%     +10.3%     751298 ~ 0%  TOTAL numa-meminfo.node0.MemUsed
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>       2779 ~13%     -53.5%       1291 ~19%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>      65403 ~ 4%     -10.8%      58332 ~ 0%  lkp-nex05/will-it-scale/open1
>       9638 ~ 2%    +109.9%      20234 ~ 1%  lkp-snb01/will-it-scale/futex2
>      10665 ~ 2%    +103.8%      21733 ~ 2%  lkp-snb01/will-it-scale/signal1
>      88486 ~ 4%     +14.8%     101591 ~ 1%  TOTAL time.involuntary_context_switches
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>       1156 ~ 8%     +82.3%       2108 ~ 9%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>       1156 ~ 8%     +82.3%       2108 ~ 9%  TOTAL time.percent_of_cpu_this_job_got
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      11.58 ~10%     -44.4%       6.45 ~ 9%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>      11.58 ~10%     -44.4%       6.45 ~ 9%  TOTAL time.elapsed_time
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>       1008 ~ 5%     +79.5%       1810 ~ 7%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>       1008 ~ 5%     +79.5%       1810 ~ 7%  TOTAL time.voluntary_context_switches
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>       9.23 ~ 8%     +72.8%      15.95 ~ 8%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>       9.23 ~ 8%     +72.8%      15.95 ~ 8%  TOTAL turbostat.%c0
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>      12679 ~ 8%     +70.8%      21659 ~ 9%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>      12679 ~ 8%     +70.8%      21659 ~ 9%  TOTAL vmstat.system.in
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>        145 ~ 7%     +60.6%        234 ~ 8%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>        145 ~ 7%     +60.6%        234 ~ 8%  TOTAL vmstat.io.bo
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>       3721 ~ 7%     +35.2%       5029 ~ 8%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>       5805 ~ 2%     -55.9%       2563 ~ 0%  lkp-nex05/will-it-scale/open1
>        897 ~ 1%     +10.8%        994 ~ 1%  lkp-snb01/will-it-scale/futex2
>        908 ~ 0%     +11.7%       1014 ~ 0%  lkp-snb01/will-it-scale/signal1
>      11332 ~ 3%     -15.3%       9601 ~ 4%  TOTAL vmstat.system.cs
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>            ~ 1%     +26.7%            ~ 5%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>            ~ 1%     +26.7%            ~ 5%  TOTAL turbostat.Cor_W
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>            ~ 2%     +21.2%            ~ 3%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>            ~ 2%     +21.2%            ~ 3%  TOTAL turbostat.RAM_W
> 
>       v3.16-rc1  e552592e0383bc72e35eb21a9  
> ---------------  -------------------------  
>            ~ 1%     +19.7%            ~ 4%  brickland3/vm-scalability/300s-anon-w-seq-mt-64G
>            ~ 1%     +19.7%            ~ 4%  TOTAL turbostat.Pkg_W
> 
> 
> Legend:
> 	~XX%    - stddev percent
> 	[+-]XX% - change percent
> 
> 
>                                  vmstat.system.cs
> 
>   6000 *+-*------*--*-------------------------------------------------------+
>        |      *.       *...  .*..                                           |
>   5500 ++                  *.    *                                          |
>        |                                                                    |
>   5000 ++                                                                   |
>        |                                                                    |
>   4500 ++                                                                   |
>        |                                                                    |
>   4000 ++                                                                   |
>        |                                                                    |
>   3500 ++                                                                   |
>        |                                                                    |
>   3000 ++                                                                   |
>        |                                                                    |
>   2500 O+-O---O--O--O--O---O--O--O---O--O--O--O---O--O--O---O--O--O--O---O--O
> 
> 
> 	[*] bisect-good sample
> 	[O] bisect-bad  sample
> 
> 
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
> 
> Thanks,
> Fengguang
> 

