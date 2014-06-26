Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbaFZCQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 22:16:56 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52416 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbaFZCQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 22:16:55 -0400
Date: Wed, 25 Jun 2014 19:16:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, Jet Chen <jet.chen@intel.com>
Subject: Re: [rcu] 0acd7c39a85: +11.0% will-it-scale.scalability
Message-ID: <20140626021648.GQ4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140626015616.GD12239@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626015616.GD12239@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062602-3532-0000-0000-000002BBCB61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2014 at 09:56:16AM +0800, Fengguang Wu wrote:
> Hi Paul,
> 
> FYI, we are pleased to notice big performance gains in some
> will-it-scale test cases:

Unfortunately, this one is also obsoleted by commit 4a81e8328d37 (Reduce
overhead of cond_resched() checks for RCU).  Hopefully that commit also
shows similar performance gains.  ;-)

							Thanx, Paul

> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu_cond_resched.2014.06.20c
> commit 0acd7c39a85836d90451b6c278c5cfdd21c055f3 ("rcu: Add RCU_COND_RESCHED_QS for large systems")
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       0.30 ~ 2%     +14.3%       0.34 ~ 3%  lkp-sbx04/will-it-scale/open1
>       0.34 ~ 3%      +8.1%       0.37 ~ 1%  nhm4/will-it-scale/read1
>       0.64 ~ 3%     +11.0%       0.71 ~ 2%  TOTAL will-it-scale.scalability
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>     592828 ~ 1%      +3.8%     615531 ~ 1%  lkp-sbx04/will-it-scale/open1
>     592828 ~ 1%      +3.8%     615531 ~ 1%  TOTAL will-it-scale.per_process_ops
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       1689 ~ 0%    +498.1%      10107 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>       1689 ~ 0%    +498.1%      10107 ~ 2%  TOTAL slabinfo.dentry.active_slabs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      72052 ~ 0%    +489.8%     424930 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>      72052 ~ 0%    +489.8%     424930 ~ 2%  TOTAL slabinfo.Acpi-State.num_objs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      71629 ~ 0%    +492.6%     424494 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>      71629 ~ 0%    +492.6%     424494 ~ 2%  TOTAL slabinfo.Acpi-State.active_objs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       1689 ~ 0%    +498.1%      10107 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>       1689 ~ 0%    +498.1%      10107 ~ 2%  TOTAL slabinfo.dentry.num_slabs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       1412 ~ 0%    +490.0%       8331 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>       1412 ~ 0%    +490.0%       8331 ~ 2%  TOTAL slabinfo.Acpi-State.active_slabs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      70980 ~ 0%    +498.1%     424517 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>      70980 ~ 0%    +498.1%     424517 ~ 2%  TOTAL slabinfo.dentry.num_objs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      70444 ~ 0%    +502.0%     424054 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>      70444 ~ 0%    +502.0%     424054 ~ 2%  TOTAL slabinfo.dentry.active_objs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>        472 ~ 0%   +1557.0%       7827 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>        472 ~ 0%   +1557.0%       7827 ~ 2%  TOTAL slabinfo.shmem_inode_cache.num_slabs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>        472 ~ 0%   +1557.0%       7827 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>        472 ~ 0%   +1557.0%       7827 ~ 2%  TOTAL slabinfo.shmem_inode_cache.active_slabs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      22697 ~ 0%   +1555.5%     375756 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>      22697 ~ 0%   +1555.5%     375756 ~ 2%  TOTAL slabinfo.shmem_inode_cache.num_objs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      22297 ~ 0%   +1584.0%     375494 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>      22297 ~ 0%   +1584.0%     375494 ~ 2%  TOTAL slabinfo.shmem_inode_cache.active_objs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       1412 ~ 0%    +490.0%       8331 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>       1412 ~ 0%    +490.0%       8331 ~ 2%  TOTAL slabinfo.Acpi-State.num_slabs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>     230182 ~ 2%    +214.7%     724407 ~ 1%  lkp-sbx04/will-it-scale/open1
>      29926 ~ 1%   +1179.6%     382938 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>     260108 ~ 2%    +325.7%    1107345 ~ 1%  TOTAL slabinfo.kmalloc-256.active_objs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       3605 ~ 2%    +214.1%      11325 ~ 1%  lkp-sbx04/will-it-scale/open1
>        478 ~ 1%   +1153.4%       5991 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>       4083 ~ 2%    +324.1%      17316 ~ 1%  TOTAL slabinfo.kmalloc-256.num_slabs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       3605 ~ 2%    +214.1%      11325 ~ 1%  lkp-sbx04/will-it-scale/open1
>        478 ~ 1%   +1153.4%       5991 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>       4083 ~ 2%    +324.1%      17316 ~ 1%  TOTAL slabinfo.kmalloc-256.active_slabs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>     230776 ~ 2%    +214.1%     724862 ~ 1%  lkp-sbx04/will-it-scale/open1
>      30619 ~ 1%   +1152.4%     383473 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>     261395 ~ 2%    +324.0%    1108335 ~ 1%  TOTAL slabinfo.kmalloc-256.num_objs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      38033 ~ 2%     +85.2%      70426 ~ 3%  lkp-sbx04/will-it-scale/open1
>      27083 ~ 8%    +375.9%     128878 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>      65116 ~ 4%    +206.1%     199305 ~ 2%  TOTAL numa-meminfo.node1.SUnreclaim
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       9470 ~ 1%     +87.6%      17770 ~ 4%  lkp-sbx04/will-it-scale/open1
>       6769 ~ 8%    +375.7%      32201 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>      16240 ~ 4%    +207.7%      49971 ~ 2%  TOTAL numa-vmstat.node1.nr_slab_unreclaimable
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>     302149 ~ 1%     -73.4%      80465 ~ 0%  lkp-nex05/will-it-scale/lock1
>     853141 ~ 2%     -66.6%     284788 ~ 3%  lkp-sbx04/will-it-scale/open1
>     693207 ~ 0%     -82.6%     120744 ~ 9%  lkp-sbx04/will-it-scale/unlink2
>     434870 ~ 2%     -63.8%     157362 ~ 1%  lkp-wsx01/will-it-scale/futex2
>      55884 ~ 5%     -55.3%      24956 ~ 4%  nhm4/will-it-scale/read1
>    2339252 ~ 1%     -71.4%     668317 ~ 3%  TOTAL softirqs.RCU
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      51492 ~ 3%     +75.4%      90311 ~ 2%  lkp-sbx04/will-it-scale/open1
>      39615 ~ 2%    +332.8%     171468 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>      91107 ~ 3%    +187.3%     261779 ~ 1%  TOTAL numa-meminfo.node0.SUnreclaim
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>   18566237 ~32%    +133.3%   43314913 ~21%  lkp-sbx04/will-it-scale/open1
>   22235565 ~30%    +176.7%   61536286 ~21%  lkp-sbx04/will-it-scale/unlink2
>   40801803 ~31%    +157.0%  104851199 ~21%  TOTAL cpuidle.C1-SNB.time
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      12835 ~ 4%     +76.6%      22664 ~ 3%  lkp-sbx04/will-it-scale/open1
>       9928 ~ 2%    +331.3%      42820 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>      22764 ~ 3%    +187.7%      65484 ~ 1%  TOTAL numa-vmstat.node0.nr_slab_unreclaimable
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>     149956 ~ 1%     +81.6%     272270 ~ 1%  lkp-sbx04/will-it-scale/open1
>     112319 ~ 0%    +312.8%     463620 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>     262275 ~ 1%    +180.6%     735890 ~ 1%  TOTAL meminfo.SUnreclaim
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      49308 ~ 4%     +66.6%      82136 ~ 3%  lkp-sbx04/will-it-scale/open1
>      38437 ~ 5%    +314.4%     159290 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>      87745 ~ 4%    +175.1%     241426 ~ 2%  TOTAL numa-meminfo.node1.Slab
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      37339 ~ 1%     +81.4%      67717 ~ 1%  lkp-sbx04/will-it-scale/open1
>      28028 ~ 0%    +313.1%     115797 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>      65368 ~ 1%    +180.7%     183514 ~ 1%  TOTAL proc-vmstat.nr_slab_unreclaimable
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      31729 ~ 8%     +79.4%      56907 ~ 2%  lkp-sbx04/will-it-scale/open1
>      22831 ~ 6%    +295.0%      90181 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>      54560 ~ 7%    +169.6%     147088 ~ 2%  TOTAL numa-meminfo.node2.SUnreclaim
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       8014 ~ 9%     +77.4%      14215 ~ 3%  lkp-sbx04/will-it-scale/open1
>       5703 ~ 6%    +294.5%      22500 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>      13717 ~ 8%    +167.6%      36715 ~ 2%  TOTAL numa-vmstat.node2.nr_slab_unreclaimable
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      14049 ~ 9%    +162.8%      36926 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>      14049 ~ 9%    +162.8%      36926 ~ 2%  TOTAL numa-meminfo.node0.SReclaimable
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       3505 ~ 9%    +163.0%       9218 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>       3505 ~ 9%    +163.0%       9218 ~ 1%  TOTAL numa-vmstat.node0.nr_slab_reclaimable
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       2840 ~ 6%    +167.5%       7598 ~ 4%  lkp-sbx04/will-it-scale/unlink2
>       2840 ~ 6%    +167.5%       7598 ~ 4%  TOTAL numa-vmstat.node1.nr_slab_reclaimable
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      11353 ~ 6%    +167.9%      30411 ~ 4%  lkp-sbx04/will-it-scale/unlink2
>      11353 ~ 6%    +167.9%      30411 ~ 4%  TOTAL numa-meminfo.node1.SReclaimable
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      62873 ~ 2%     +60.7%     101060 ~ 2%  lkp-sbx04/will-it-scale/open1
>      53665 ~ 2%    +288.3%     208395 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>     116538 ~ 2%    +165.5%     309456 ~ 1%  TOTAL numa-meminfo.node0.Slab
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>     195370 ~ 0%     +62.8%     318033 ~ 1%  lkp-sbx04/will-it-scale/open1
>     161158 ~ 0%    +258.0%     576939 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>     356528 ~ 0%    +151.0%     894972 ~ 1%  TOTAL meminfo.Slab
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      28175 ~ 2%     +78.7%      50339 ~ 4%  lkp-sbx04/will-it-scale/open1
>      22550 ~10%    +211.4%      70229 ~ 5%  lkp-sbx04/will-it-scale/unlink2
>      50725 ~ 6%    +137.7%     120568 ~ 5%  TOTAL numa-meminfo.node3.SUnreclaim
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       7070 ~ 3%     +77.8%      12570 ~ 4%  lkp-sbx04/will-it-scale/open1
>       5633 ~10%    +211.2%      17532 ~ 5%  lkp-sbx04/will-it-scale/unlink2
>      12704 ~ 6%    +137.0%      30102 ~ 5%  TOTAL numa-vmstat.node3.nr_slab_unreclaimable
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      48838 ~ 1%    +132.0%     113319 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>      48838 ~ 1%    +132.0%     113319 ~ 1%  TOTAL meminfo.SReclaimable
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      12200 ~ 1%    +132.1%      28313 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>      12200 ~ 1%    +132.1%      28313 ~ 1%  TOTAL proc-vmstat.nr_slab_reclaimable
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      39455 ~ 5%     +58.3%      62461 ~ 3%  lkp-sbx04/will-it-scale/open1
>      33103 ~10%    +172.9%      90331 ~ 3%  lkp-sbx04/will-it-scale/unlink2
>      72559 ~ 7%    +110.6%     152793 ~ 3%  TOTAL numa-meminfo.node3.Slab
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      43199 ~ 8%     +57.6%      68080 ~ 4%  lkp-sbx04/will-it-scale/open1
>      35542 ~ 7%    +224.5%     115339 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>      31726 ~ 7%     +15.3%      36592 ~12%  lkp-wsx01/will-it-scale/futex2
>     110469 ~ 7%     +99.2%     220012 ~ 4%  TOTAL numa-meminfo.node2.Slab
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      12710 ~12%     +97.9%      25157 ~ 5%  lkp-sbx04/will-it-scale/unlink2
>      12710 ~12%     +97.9%      25157 ~ 5%  TOTAL numa-meminfo.node2.SReclaimable
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       3179 ~11%     +97.5%       6279 ~ 5%  lkp-sbx04/will-it-scale/unlink2
>       3179 ~11%     +97.5%       6279 ~ 5%  TOTAL numa-vmstat.node2.nr_slab_reclaimable
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      10553 ~ 9%     +90.5%      20102 ~ 6%  lkp-sbx04/will-it-scale/unlink2
>      10553 ~ 9%     +90.5%      20102 ~ 6%  TOTAL numa-meminfo.node3.SReclaimable
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       2644 ~10%     +89.9%       5020 ~ 6%  lkp-sbx04/will-it-scale/unlink2
>       2644 ~10%     +89.9%       5020 ~ 6%  TOTAL numa-vmstat.node3.nr_slab_reclaimable
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       6034 ~26%     +16.1%       7008 ~22%  lkp-sbx04/will-it-scale/open1
>       6034 ~26%     +16.1%       7008 ~22%  TOTAL numa-vmstat.node2.nr_active_file
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      24139 ~26%     +16.1%      28033 ~22%  lkp-sbx04/will-it-scale/open1
>      24139 ~26%     +16.1%      28033 ~22%  TOTAL numa-meminfo.node2.Active(file)
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       0.55 ~35%     +94.2%       1.08 ~14%  lkp-sbx04/will-it-scale/unlink2
>       0.55 ~35%     +94.2%       1.08 ~14%  TOTAL perf-profile.cpu-cycles.rcu_nocb_kthread.kthread.ret_from_fork
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>     498234 ~ 1%     -35.9%     319244 ~ 1%  lkp-sbx04/will-it-scale/open1
>     425531 ~ 2%     -39.8%     256020 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>     923765 ~ 2%     -37.7%     575264 ~ 2%  TOTAL cpuidle.C7-SNB.usage
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>        327 ~ 9%     -26.2%        241 ~21%  lkp-nex05/will-it-scale/lock1
>        327 ~ 9%     -26.2%        241 ~21%  TOTAL slabinfo.blkdev_ioc.num_objs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>        327 ~ 9%     -26.2%        241 ~21%  lkp-nex05/will-it-scale/lock1
>        327 ~ 9%     -26.2%        241 ~21%  TOTAL slabinfo.blkdev_ioc.active_objs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>    4608661 ~ 5%     +15.0%    5300401 ~ 3%  lkp-sbx04/will-it-scale/open1
>     631679 ~ 4%     +64.1%    1036539 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>    5240340 ~ 5%     +20.9%    6336941 ~ 3%  TOTAL numa-numastat.node2.numa_hit
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>    4606166 ~ 5%     +15.0%    5298738 ~ 3%  lkp-sbx04/will-it-scale/open1
>     630014 ~ 4%     +64.4%    1035707 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>    5236180 ~ 5%     +21.0%    6334445 ~ 3%  TOTAL numa-numastat.node2.local_node
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>    6319649 ~ 2%     +11.6%    7054325 ~ 3%  lkp-sbx04/will-it-scale/open1
>    1017618 ~ 3%     +59.6%    1624227 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>    7337268 ~ 3%     +18.3%    8678552 ~ 2%  TOTAL numa-numastat.node1.local_node
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>    6323803 ~ 2%     +11.6%    7058478 ~ 3%  lkp-sbx04/will-it-scale/open1
>    1021772 ~ 3%     +59.4%    1628381 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>    7345576 ~ 3%     +18.3%    8686859 ~ 2%  TOTAL numa-numastat.node1.numa_hit
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>    3533020 ~ 7%     +16.2%    4106277 ~ 3%  lkp-sbx04/will-it-scale/open1
>     529616 ~ 6%     +59.8%     846268 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>    4062636 ~ 7%     +21.9%    4952546 ~ 3%  TOTAL numa-numastat.node3.local_node
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>    3534685 ~ 7%     +16.2%    4108772 ~ 3%  lkp-sbx04/will-it-scale/open1
>     532111 ~ 6%     +59.7%     849592 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>    4066797 ~ 7%     +21.9%    4958364 ~ 3%  TOTAL numa-numastat.node3.numa_hit
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>     699767 ~ 4%     +30.0%     909550 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>     699767 ~ 4%     +30.0%     909550 ~ 2%  TOTAL numa-vmstat.node1.numa_local
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>     710327 ~ 4%     +29.5%     920095 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>     710327 ~ 4%     +29.5%     920095 ~ 2%  TOTAL numa-vmstat.node1.numa_hit
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>     355465 ~ 3%     +32.2%     469857 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>     355465 ~ 3%     +32.2%     469857 ~ 1%  TOTAL numa-vmstat.node2.numa_local
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>     401800 ~ 0%     +30.8%     525635 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>     401800 ~ 0%     +30.8%     525635 ~ 1%  TOTAL numa-meminfo.node1.MemUsed
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>     330376 ~ 1%     +11.7%     369194 ~ 1%  lkp-sbx04/will-it-scale/open1
>     327252 ~ 0%     +47.0%     480920 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>     657628 ~ 0%     +29.3%     850114 ~ 1%  TOTAL numa-meminfo.node0.MemUsed
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>     395008 ~ 2%     +28.8%     508797 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>     395008 ~ 2%     +28.8%     508797 ~ 1%  TOTAL numa-vmstat.node2.numa_hit
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>   84008013 ~ 4%     +12.5%   94488610 ~ 1%  lkp-sbx04/will-it-scale/open1
>   20904484 ~ 1%     +35.9%   28407692 ~ 0%  lkp-sbx04/will-it-scale/unlink2
>  104912497 ~ 3%     +17.1%  122896302 ~ 1%  TOTAL proc-vmstat.pgalloc_normal
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>         20 ~19%     +69.3%         34 ~32%  lkp-sbx04/will-it-scale/unlink2
>         20 ~19%     +69.3%         34 ~32%  TOTAL cpuidle.C6-SNB.usage
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>   90818481 ~ 4%     +12.2%  1.019e+08 ~ 1%  lkp-sbx04/will-it-scale/open1
>   24507722 ~ 1%     +32.8%   32552022 ~ 0%  lkp-sbx04/will-it-scale/unlink2
>  1.153e+08 ~ 3%     +16.6%  1.344e+08 ~ 1%  TOTAL proc-vmstat.pgfree
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>   23331601 ~ 4%     +11.8%   26096052 ~ 1%  lkp-sbx04/will-it-scale/open1
>    7360836 ~ 1%     +29.1%    9500981 ~ 0%  lkp-sbx04/will-it-scale/unlink2
>   30692438 ~ 3%     +16.0%   35597034 ~ 1%  TOTAL proc-vmstat.numa_local
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>   23344069 ~ 4%     +11.8%   26108517 ~ 1%  lkp-sbx04/will-it-scale/open1
>    7373303 ~ 1%     +29.0%    9513445 ~ 0%  lkp-sbx04/will-it-scale/unlink2
>   30717373 ~ 3%     +16.0%   35621962 ~ 1%  TOTAL proc-vmstat.numa_hit
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>     293077 ~ 3%      +9.2%     320181 ~ 3%  lkp-sbx04/will-it-scale/open1
>     289901 ~ 3%     +29.0%     374077 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>     582978 ~ 3%     +19.1%     694258 ~ 2%  TOTAL numa-meminfo.node2.MemUsed
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       1.34 ~10%     -18.2%       1.10 ~ 6%  lkp-sbx04/will-it-scale/open1
>       1.34 ~10%     -18.2%       1.10 ~ 6%  TOTAL perf-profile.cpu-cycles.task_work_add.filp_close.__close_fd.sys_close.system_call_fastpath
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>     310408 ~ 3%     +17.2%     363768 ~ 4%  lkp-sbx04/will-it-scale/unlink2
>     310408 ~ 3%     +17.2%     363768 ~ 4%  TOTAL numa-vmstat.node3.numa_local
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>     278872 ~ 3%     +18.9%     331653 ~ 2%  lkp-sbx04/will-it-scale/unlink2
>     278872 ~ 3%     +18.9%     331653 ~ 2%  TOTAL numa-meminfo.node3.MemUsed
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       1.83 ~ 3%     +17.5%       2.15 ~ 3%  nhm4/will-it-scale/read1
>       1.83 ~ 3%     +17.5%       2.15 ~ 3%  TOTAL perf-profile.cpu-cycles.find_lock_entry.shmem_getpage_gfp.shmem_file_read_iter.new_sync_read.vfs_read
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>     350441 ~ 3%     +15.4%     404433 ~ 4%  lkp-sbx04/will-it-scale/unlink2
>     350441 ~ 3%     +15.4%     404433 ~ 4%  TOTAL numa-vmstat.node3.numa_hit
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      11130 ~ 1%     +18.7%      13216 ~ 2%  lkp-nex05/will-it-scale/lock1
>      13337 ~ 2%     +15.2%      15360 ~ 4%  lkp-sbx04/will-it-scale/unlink2
>      12236 ~ 1%     +16.4%      14247 ~ 1%  lkp-wsx01/will-it-scale/futex2
>      36704 ~ 2%     +16.7%      42823 ~ 3%  TOTAL slabinfo.kmalloc-192.num_objs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      11130 ~ 1%     +18.6%      13206 ~ 2%  lkp-nex05/will-it-scale/lock1
>      13337 ~ 2%     +14.8%      15306 ~ 4%  lkp-sbx04/will-it-scale/unlink2
>      12236 ~ 1%     +16.4%      14247 ~ 1%  lkp-wsx01/will-it-scale/futex2
>      36704 ~ 2%     +16.5%      42760 ~ 3%  TOTAL slabinfo.kmalloc-192.active_objs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>    6819069 ~ 3%      +8.6%    7407793 ~ 2%  lkp-sbx04/will-it-scale/open1
>    3615190 ~ 1%     +15.2%    4164246 ~ 0%  lkp-sbx04/will-it-scale/unlink2
>   10434260 ~ 2%     +10.9%   11572039 ~ 1%  TOTAL proc-vmstat.pgalloc_dma32
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>    8856248 ~ 3%      +8.6%    9619086 ~ 2%  lkp-sbx04/will-it-scale/open1
>    5216071 ~ 2%     +14.6%    5979211 ~ 0%  lkp-sbx04/will-it-scale/unlink2
>   14072319 ~ 2%     +10.8%   15598298 ~ 1%  TOTAL numa-numastat.node0.local_node
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>    8860401 ~ 3%      +8.6%    9623240 ~ 2%  lkp-sbx04/will-it-scale/open1
>    5220224 ~ 2%     +14.6%    5983365 ~ 0%  lkp-sbx04/will-it-scale/unlink2
>   14080626 ~ 2%     +10.8%   15606605 ~ 1%  TOTAL numa-numastat.node0.numa_hit
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       4865 ~ 2%     +13.5%       5524 ~ 6%  lkp-sbx04/will-it-scale/open1
>       4865 ~ 2%     +13.5%       5524 ~ 6%  TOTAL cpuidle.C1-SNB.usage
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       2231 ~ 5%      +9.1%       2434 ~ 7%  lkp-sbx04/will-it-scale/unlink2
>       2231 ~ 5%      +9.1%       2434 ~ 7%  TOTAL numa-meminfo.node3.KernelStack
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       2438 ~ 2%     +10.7%       2700 ~ 1%  lkp-nex05/will-it-scale/lock1
>       2438 ~ 2%     +10.7%       2700 ~ 1%  TOTAL slabinfo.signal_cache.num_objs
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>      17183 ~ 1%    +131.6%      39791 ~ 0%  lkp-nex05/will-it-scale/lock1
>      67122 ~ 3%     -18.0%      55048 ~ 0%  lkp-sbx04/will-it-scale/open1
>      67648 ~ 6%     -18.5%      55135 ~ 0%  lkp-sbx04/will-it-scale/unlink2
>      21242 ~ 0%     +99.3%      42326 ~ 0%  lkp-wsx01/will-it-scale/futex2
>       6224 ~ 3%     +52.1%       9468 ~ 2%  nhm4/will-it-scale/read1
>     179420 ~ 4%     +12.5%     201771 ~ 0%  TOTAL time.involuntary_context_switches
> 
> acf426994c75e38  0acd7c39a85836d90451b6c27  
> ---------------  -------------------------  
>       1054 ~ 1%     +19.4%       1258 ~ 1%  lkp-nex05/will-it-scale/lock1
>       4445 ~ 1%     -40.5%       2645 ~ 0%  lkp-sbx04/will-it-scale/open1
>       3861 ~ 0%     -55.5%       1717 ~ 1%  lkp-sbx04/will-it-scale/unlink2
>       1142 ~ 1%     +15.4%       1318 ~ 1%  lkp-wsx01/will-it-scale/futex2
>        527 ~ 1%     +18.1%        622 ~ 1%  nhm4/will-it-scale/read1
>      11030 ~ 1%     -31.4%       7562 ~ 1%  TOTAL vmstat.system.cs
> 
> 
> Legend:
> 	~XX%    - stddev percent
> 	[+-]XX% - change percent
> 
> 
>                           time.involuntary_context_switches
> 
>   75000 *+--*----------------*----------------------------------------------+
>         |                   : +                                             |
>         |      *...*..      :  +               *                            |
>   70000 ++            *... :    +             + +                           |
>         |                 *      *...*..     +   +    .*                    |
>         |                               *...*     + ..                      |
>   65000 ++                                         *                        |
>         |                                                                   |
>   60000 ++                                                                  |
>         |                                                                   |
>         |                                                                   |
>   55000 O+  O  O      O   O  O   O   O  O   O  O   O   O  O   O  O   O  O   O
>         |          O                                                        |
>         |                                                                   |
>   50000 ++------------------------------------------------------------------+
> 
> 
>                                  vmstat.system.cs
> 
>   6000 ++-------------------------------------------------------------------+
>        |                                                                    |
>   5500 *+..*..*...*...*..*...*..*...                                        |
>        |                            *.                                      |
>   5000 ++                             ..                                    |
>        |                                                                    |
>   4500 ++                               *..*...*...*..                      |
>        |                                              *                     |
>   4000 ++                                                                   |
>        |                                                                    |
>   3500 ++                                                                   |
>        |                                                                    |
>   3000 ++                                                                   |
>        |   O          O         O   O   O  O   O      O      O       O  O   O
>   2500 O+-----O---O------O---O---------------------O------O------O----------+
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

