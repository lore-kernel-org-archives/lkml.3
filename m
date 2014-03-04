Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbaCDBBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 20:01:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:63881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838AbaCDBBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 20:01:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,582,1389772800"; 
   d="scan'208";a="485489341"
Date: Tue, 4 Mar 2014 09:00:25 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [sched/balance] 598143917: -1.8% turbostat.Pkg_W
Message-ID: <20140304010025.GA10470@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex,

FYI, we noticed the below changes on commit 598143917dc5ecf11f0764de4166ee7c98e90aff
("sched: only do load balance on tick_do_timer_cpu") in your git tree

https://github.com/alexshi/power-scheduling.git single-balance

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
     63743 ~ 0%     -82.4%      11200 ~ 2%  lkp-nex05/micro/will-it-scale/futex2
     63430 ~ 0%     -83.4%      10546 ~ 1%  lkp-nex05/micro/will-it-scale/signal1
     60358 ~ 0%     -80.6%      11704 ~ 4%  lkp-snb01/micro/will-it-scale/sched_yield
    187532 ~ 0%     -82.2%      33451 ~ 2%  TOTAL interrupts.RES

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
    197848 ~ 1%     -97.5%       5000 ~ 5%  lkp-nex05/micro/will-it-scale/futex2
    192607 ~ 7%     -96.8%       6186 ~31%  lkp-nex05/micro/will-it-scale/signal1
     86509 ~ 5%     -96.1%       3399 ~ 9%  lkp-snb01/micro/will-it-scale/sched_yield
    476965 ~ 4%     -96.9%      14586 ~17%  TOTAL softirqs.SCHED

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
    103938 ~ 1%     -36.2%      66267 ~ 0%  lkp-snb01/micro/will-it-scale/sched_yield
    103938 ~ 1%     -36.2%      66267 ~ 0%  TOTAL cpuidle.C7-SNB.usage

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
      5193 ~11%      +7.7%       5595 ~10%  lkp-nex05/micro/will-it-scale/futex2
      5193 ~11%      +7.7%       5595 ~10%  TOTAL numa-vmstat.node1.nr_slab_unreclaimable

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
     20777 ~11%      +7.7%      22382 ~10%  lkp-nex05/micro/will-it-scale/futex2
     20777 ~11%      +7.7%      22382 ~10%  TOTAL numa-meminfo.node1.SUnreclaim

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
    215721 ~ 3%     -16.4%     180390 ~ 2%  lkp-nex05/micro/will-it-scale/futex2
    235264 ~ 2%     -18.9%     190850 ~ 3%  lkp-nex05/micro/will-it-scale/signal1
    450985 ~ 2%     -17.7%     371241 ~ 2%  TOTAL cpuidle.C3-NHM.usage

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
     19.88 ~ 0%     +12.5%      22.38 ~ 2%  lkp-nex05/micro/will-it-scale/signal1
     20.65 ~ 0%     +24.5%      25.70 ~ 1%  lkp-snb01/micro/will-it-scale/sched_yield
     40.53 ~ 0%     +18.6%      48.08 ~ 1%  TOTAL turbostat.%c1

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
    261584 ~ 8%      -9.8%     235897 ~ 5%  lkp-nex05/micro/will-it-scale/futex2
    261584 ~ 8%      -9.8%     235897 ~ 5%  TOTAL numa-numastat.node1.local_node

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
    261584 ~ 8%      -9.8%     235897 ~ 5%  lkp-nex05/micro/will-it-scale/futex2
    261584 ~ 8%      -9.8%     235897 ~ 5%  TOTAL numa-numastat.node1.numa_hit

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
      9292 ~ 3%      -8.0%       8545 ~ 4%  lkp-snb01/micro/will-it-scale/sched_yield
      9292 ~ 3%      -8.0%       8545 ~ 4%  TOTAL slabinfo.anon_vma.active_objs

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
      9292 ~ 3%      -7.8%       8563 ~ 4%  lkp-snb01/micro/will-it-scale/sched_yield
      9292 ~ 3%      -7.8%       8563 ~ 4%  TOTAL slabinfo.anon_vma.num_objs

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
    204033 ~ 1%      -8.6%     186466 ~ 3%  lkp-snb01/micro/will-it-scale/sched_yield
    204033 ~ 1%      -8.6%     186466 ~ 3%  TOTAL softirqs.RCU

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
     34331 ~ 5%      +4.7%      35960 ~ 4%  lkp-nex05/micro/will-it-scale/futex2
     34331 ~ 5%      +4.7%      35960 ~ 4%  TOTAL numa-meminfo.node1.Slab

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
    683581 ~ 0%      -9.3%     620065 ~ 1%  lkp-snb01/micro/will-it-scale/sched_yield
    683581 ~ 0%      -9.3%     620065 ~ 1%  TOTAL softirqs.TIMER

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
 4.902e+09 ~ 0%      +9.9%   5.39e+09 ~ 0%  lkp-snb01/micro/will-it-scale/sched_yield
 4.902e+09 ~ 0%      +9.9%   5.39e+09 ~ 0%  TOTAL cpuidle.C7-SNB.time

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
      3900 ~ 0%    +349.4%      17527 ~ 2%  lkp-nex05/micro/will-it-scale/futex2
      3930 ~ 1%    +258.6%      14091 ~20%  lkp-nex05/micro/will-it-scale/signal1
    143678 ~42%  +4.8e+05%   6.93e+08 ~ 0%  lkp-snb01/micro/will-it-scale/sched_yield
    151509 ~40%  +4.6e+05%   6.93e+08 ~ 0%  TOTAL time.involuntary_context_switches

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
       884 ~ 1%      +8.3%        957 ~ 1%  lkp-nex05/micro/will-it-scale/futex2
       883 ~ 0%      +9.4%        967 ~ 2%  lkp-nex05/micro/will-it-scale/signal1
      2405 ~25%  +2.1e+05%    5129828 ~ 5%  lkp-snb01/micro/will-it-scale/sched_yield
      4173 ~15%  +1.2e+05%    5131753 ~ 5%  TOTAL vmstat.system.cs

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
       250 ~ 4%     +29.1%        323 ~ 8%  lkp-snb01/micro/will-it-scale/sched_yield
       250 ~ 4%     +29.1%        323 ~ 8%  TOTAL time.user_time

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
      2819 ~ 0%      -7.9%       2597 ~ 0%  lkp-nex05/micro/will-it-scale/futex2
      2811 ~ 0%      -5.9%       2644 ~ 1%  lkp-nex05/micro/will-it-scale/signal1
      1267 ~ 0%     -22.9%        978 ~ 2%  lkp-snb01/micro/will-it-scale/sched_yield
      6898 ~ 0%      -9.8%       6219 ~ 1%  TOTAL time.system_time

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
       905 ~ 0%      -7.9%        833 ~ 0%  lkp-nex05/micro/will-it-scale/futex2
       902 ~ 0%      -5.7%        850 ~ 1%  lkp-nex05/micro/will-it-scale/signal1
       489 ~ 0%     -14.3%        419 ~ 0%  lkp-snb01/micro/will-it-scale/sched_yield
      2296 ~ 0%      -8.4%       2103 ~ 0%  TOTAL time.percent_of_cpu_this_job_got

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
     45.10 ~ 0%      -4.8%      42.94 ~ 0%  lkp-nex05/micro/will-it-scale/futex2
     45.04 ~ 0%      -5.1%      42.73 ~ 1%  lkp-nex05/micro/will-it-scale/signal1
     50.62 ~ 0%     -10.0%      45.56 ~ 0%  lkp-snb01/micro/will-it-scale/sched_yield
    140.76 ~ 0%      -6.8%     131.22 ~ 0%  TOTAL turbostat.%c0

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
      2380 ~ 2%     +15.7%       2753 ~13%  lkp-nex05/micro/will-it-scale/signal1
      2380 ~ 2%     +15.7%       2753 ~13%  TOTAL boottime.idle

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
      7975 ~ 0%      -6.2%       7480 ~ 0%  lkp-nex05/micro/will-it-scale/futex2
      8022 ~ 0%      -6.9%       7465 ~ 0%  lkp-nex05/micro/will-it-scale/signal1
     15997 ~ 0%      -6.6%      14946 ~ 0%  TOTAL vmstat.system.in

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
     42.69 ~ 2%     +15.0%      49.08 ~14%  lkp-nex05/micro/will-it-scale/signal1
     42.69 ~ 2%     +15.0%      49.08 ~14%  TOTAL boottime.boot

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
       121 ~ 0%      -2.2%        119 ~ 0%  lkp-snb01/micro/will-it-scale/sched_yield
       121 ~ 0%      -2.2%        119 ~ 0%  TOTAL turbostat.Cor_W

bc575710efe937e  598143917dc5ecf11f0764de4  
---------------  -------------------------  
       148 ~ 0%      -1.8%        145 ~ 0%  lkp-snb01/micro/will-it-scale/sched_yield
       148 ~ 0%      -1.8%        145 ~ 0%  TOTAL turbostat.Pkg_W


                                  time.system_time

   2850 ++------------------------------------------------------------------+
        |                                                                   |
   2800 *+.*..*..*..*..*..*..*..*..*..*..*.*..*..*..*..*..*                 |
        |                                                                   |
        |                                                                   |
   2750 ++                                                                  |
        |                                                             O     |
   2700 ++                                                                  |
        |                                                                   |
   2650 O+                                                               O  |
        |        O        O                                     O           O
        |     O              O             O              O  O              |
   2600 ++          O              O          O     O                       |
        |  O                    O     O  O       O     O           O        |
   2550 ++-------------O----------------------------------------------------+


                         time.percent_of_cpu_this_job_got

   910 ++-------------------------------------------------------------------+
       *..*..*..*..*..*..*..*..*..*..*..*..*..*..  .*..  .*                 |
   900 ++                                        *.    *.                   |
   890 ++                                                                   |
       |                                                                    |
   880 ++                                                             O     |
   870 ++                                                                   |
       |                                                                    |
   860 ++                                                                O  |
   850 O+                                                                   |
       |        O        O  O              O                 O  O           O
   840 ++    O     O              O           O     O     O                 |
   830 ++ O                                      O     O                    |
       |                       O     O  O                          O        |
   820 ++-------------O-----------------------------------------------------+


                          time.involuntary_context_switches

   20000 ++-------------O---------------------------------------------------+
         |                      O     O  O                         O        |
   18000 ++ O  O     O                            O     O                   |
   16000 ++                        O           O     O     O O              |
         |        O       O  O              O                   O           O
   14000 O+                                                              O  |
   12000 ++                                                                 |
         |                                                                  |
   10000 ++                                                           O     |
    8000 ++                                                                 |
         |                                                                  |
    6000 ++                                                                 |
    4000 *+.     .*..  .*.  .*..*..              .*..  .*..                 |
         |  *..*.    *.   *.       *..*..*..*..*.    *.    *                |
    2000 ++-----------------------------------------------------------------+


                                    turbostat.%c0

   45.5 ++------------------------------------------------------------------+
        *..*..*..*..*..*..*..*..*..*..*..*.*..*..   *..                     |
     45 ++                                        ..   *..*                 |
        |                                        *                          |
   44.5 ++                                                                  |
        |                                                                   |
     44 ++                                                                  |
        |                                                                   |
   43.5 ++                                                                  |
        |     O     O                                     O        O  O     |
     43 O+ O                       O                                        |
        |                 O           O  O O  O  O  O  O     O           O  |
   42.5 ++       O     O                                                    |
        |                       O                                           O
     42 ++-------------------O----------------------------------O-----------+


                                  vmstat.system.in

   8100 ++------------------------------------------------------------------+
        *..*..     .*..*..*..*..*..  .*..*.*..*..  .*..  .*                 |
   8000 ++    *..*.                *.            *.    *.                   |
   7900 ++                                                                  |
        |                                                                   |
   7800 ++                                                                  |
        |                                                                   |
   7700 ++                                                                  |
        |                                                                   |
   7600 O+          O              O                      O                 |
   7500 ++ O  O  O                    O                            O  O     |
        |                 O              O O  O  O  O  O     O           O  |
   7400 ++             O        O                                           O
        |                    O                                  O           |
   7300 ++------------------------------------------------------------------+

Thanks,
Fengguang
