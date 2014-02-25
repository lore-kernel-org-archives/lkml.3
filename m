Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaBYBdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:33:18 -0500
Received: from mga03.intel.com ([143.182.124.21]:32899 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbaBYBdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:33:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,538,1389772800"; 
   d="scan'208";a="481195656"
Date: Tue, 25 Feb 2014 09:33:14 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [sched/balance] 7511dd0a7: +2.1e+05% context switches
Message-ID: <20140225013314.GA8148@localhost>
References: <20140219130028.GB8169@localhost>
 <5305ACF9.60403@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5305ACF9.60403@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 03:21:29PM +0800, Alex Shi wrote:
> On 02/19/2014 09:00 PM, Fengguang Wu wrote:
> > bc575710efe937e  7511dd0a73aaf2ca4bcd829f9
> > ---------------  -------------------------
> >       2029 ~ 0%    +222.9%       6551 ~17%  lkp-snb01/micro/will-it-scale/pthread_mutex2
> >     143678 ~42%  +4.8e+05%  6.927e+08 ~ 0%  lkp-snb01/micro/will-it-scale/sched_yield
> >     145708 ~42%  +4.8e+05%  6.927e+08 ~ 0%  TOTAL time.involuntary_context_switches
> 
> 
> Thanks for testing, Fengguang!
> 
> Does the context switch increasing happen on whole patchset? or just
> happens on this patch?

Only this patch. Some other patches actually reduce the context switches.
This is all the changes for branch alexshi/topdown:

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
    111372 ~ 1%     +60.1%     178267 ~ 1%  lkp-ws02/micro/hackbench/1600%-threads-pipe
    111372 ~ 1%     +60.1%     178267 ~ 1%  TOTAL hackbench.throughput

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
  11862017 ~10%    +769.1%  1.031e+08 ~ 9%  lkp-ws02/micro/hackbench/1600%-threads-pipe
  11862017 ~10%    +769.1%  1.031e+08 ~ 9%  TOTAL numa-numastat.node0.numa_hit

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
  11862016 ~10%    +769.1%  1.031e+08 ~ 9%  lkp-ws02/micro/hackbench/1600%-threads-pipe
  11862016 ~10%    +769.1%  1.031e+08 ~ 9%  TOTAL numa-numastat.node0.local_node

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
   4629280 ~ 9%    +714.0%   37683303 ~ 9%  lkp-ws02/micro/hackbench/1600%-threads-pipe
   4629280 ~ 9%    +714.0%   37683303 ~ 9%  TOTAL proc-vmstat.pgalloc_dma32

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
   6476588 ~11%    +751.1%   55123483 ~ 7%  lkp-ws02/micro/hackbench/1600%-threads-pipe
   6476588 ~11%    +751.1%   55123483 ~ 7%  TOTAL numa-vmstat.node0.numa_hit

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
   6380486 ~11%    +761.9%   54995307 ~ 7%  lkp-ws02/micro/hackbench/1600%-threads-pipe
   6380486 ~11%    +761.9%   54995307 ~ 7%  TOTAL numa-vmstat.node0.numa_local

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
     24214 ~ 1%     -71.8%       6824 ~ 7%  lkp-a03/micro/will-it-scale/sched_yield
     55173 ~ 0%     -76.9%      12720 ~ 0%  lkp-snb01/micro/will-it-scale/pthread_mutex2
     55292 ~ 0%     -78.9%      11653 ~ 3%  lkp-snb01/micro/will-it-scale/sched_yield
    134680 ~ 0%     -76.8%      31198 ~ 3%  TOTAL interrupts.RES

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
     25891 ~ 1%     +99.5%      51664 ~ 0%  lkp-a03/micro/will-it-scale/sched_yield
     25891 ~ 1%     +99.5%      51664 ~ 0%  TOTAL softirqs.SCHED

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
   4282244 ~ 1%     -46.6%    2284599 ~ 8%  lkp-ws02/micro/hackbench/1600%-threads-pipe
   4282244 ~ 1%     -46.6%    2284599 ~ 8%  TOTAL proc-vmstat.pgfault

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
    105276 ~ 0%     -43.3%      59659 ~ 0%  lkp-snb01/micro/will-it-scale/pthread_mutex2
    105799 ~ 1%     -38.0%      65577 ~ 1%  lkp-snb01/micro/will-it-scale/sched_yield
    211075 ~ 0%     -40.7%     125236 ~ 0%  TOTAL cpuidle.C7-SNB.usage

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
 4.174e+08 ~ 0%     +31.2%  5.478e+08 ~ 0%  lkp-a03/micro/will-it-scale/sched_yield
 4.174e+08 ~ 0%     +31.2%  5.478e+08 ~ 0%  TOTAL cpuidle.C4.time

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
     20.64 ~ 0%     +23.9%      25.57 ~ 0%  lkp-snb01/micro/will-it-scale/sched_yield
     20.64 ~ 0%     +23.9%      25.57 ~ 0%  TOTAL turbostat.%c1

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
    214235 ~ 0%     -13.4%     185581 ~ 0%  lkp-a03/micro/will-it-scale/sched_yield
    214235 ~ 0%     -13.4%     185581 ~ 0%  TOTAL interrupts.LOC

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
    133373 ~ 0%     -10.8%     119020 ~ 0%  lkp-a03/micro/will-it-scale/sched_yield
    133373 ~ 0%     -10.8%     119020 ~ 0%  TOTAL softirqs.TIMER

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
      1109 ~ 8%   +9292.8%     104250 ~ 1%  lkp-a03/micro/will-it-scale/sched_yield
      4060 ~38%  +1.2e+05%    4868923 ~ 2%  lkp-snb01/micro/will-it-scale/sched_yield
      5169 ~32%  +96094.8%    4973173 ~ 2%  TOTAL vmstat.system.cs

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
      2045 ~ 1%    +221.7%       6578 ~ 2%  lkp-snb01/micro/will-it-scale/pthread_mutex2
      2045 ~ 1%    +221.7%       6578 ~ 2%  TOTAL time.involuntary_context_switches

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
       800 ~ 0%     -18.8%        650 ~ 0%  lkp-a03/micro/will-it-scale/sched_yield
       800 ~ 0%     -18.8%        650 ~ 0%  TOTAL vmstat.system.in

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
     50.56 ~ 0%      -1.8%      49.64 ~ 0%  lkp-snb01/micro/will-it-scale/pthread_mutex2
     50.55 ~ 0%      -9.4%      45.80 ~ 0%  lkp-snb01/micro/will-it-scale/sched_yield
    101.11 ~ 0%      -5.6%      95.44 ~ 0%  TOTAL turbostat.%c0

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
      1518 ~ 0%      -4.9%       1443 ~ 0%  lkp-snb01/micro/will-it-scale/pthread_mutex2
      1518 ~ 0%      -4.9%       1443 ~ 0%  TOTAL time.user_time

      v3.14-rc2  d2f8e017fdd913fc150160508  
---------------  -------------------------  
       488 ~ 0%      -4.8%        465 ~ 0%  lkp-snb01/micro/will-it-scale/pthread_mutex2
       488 ~ 0%      -4.8%        465 ~ 0%  TOTAL time.percent_of_cpu_this_job_got

Thanks,
Fengguang
