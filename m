Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbaBGMd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:33:26 -0500
Received: from mga14.intel.com ([143.182.124.37]:45074 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaBGMdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 07:33:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,800,1384329600"; 
   d="scan'208";a="471340603"
Date: Fri, 7 Feb 2014 20:33:15 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dirk Brandewie <dirk.j.brandewie@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [intel_pstate] fcb6a15c: -34.4% aim7 jobs-per-min and -17.0%
 will-it-scale/page_fault1 Pkg_W
Message-ID: <20140207123315.GA3448@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Dirk,

FYI, we notice dropped power and performance numbers on commit
fcb6a15c2e7e76d493e6f91ea889ab40e1c643a4 ("intel_pstate: Take core C0
time into account for core busy calculation").
    

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      6.53 ~ 4%     -12.0%       5.75 ~ 2%  lkp-sb03/micro/netperf/120s-200%-SCTP_STREAM
    147.93 ~ 0%     -23.3%     113.40 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
    154.46 ~ 0%     -22.9%     119.15 ~ 0%  TOTAL turbostat.Cor_W

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       203 ~ 0%     -17.0%        169 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
       203 ~ 0%     -17.0%        169 ~ 0%  TOTAL turbostat.Pkg_W

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    572540 ~ 1%     -30.2%     399351 ~ 1%  grantley/micro/aim7/disk_src
    317151 ~ 1%     -42.0%     183863 ~ 0%  grantley/micro/aim7/shell_rtns_1
    889692 ~ 1%     -34.4%     583214 ~ 1%  TOTAL aim7.2000.jobs-per-min

More details are attached.

                                  time.user_time

   600 ++-------------------------------------------------------------------+
       O         O    O                               O           O         |
   500 ++O  O O    O    O  O O  O O  O O  O O O  O O    O  O O  O    O O  O O
       |                                                                    |
       |                                                                    |
   400 ++                                                                   |
       |                                                                    |
   300 ++                                                                   |
       |                                                                    |
   200 ++                                                                   |
       |                                                                    |
       |                                                                    |
   100 ++                                                                   |
       |                                                                    |
     0 *+*--*-*--*-*--*-*--*-*--*-*--*-*--*-*-*--*--------------------------+


                                  time.system_time

   1200 ++------------------------------------------------------------------+
        |                                                                   |
   1000 O+O  O O  O O  O O O  O O  O O  O O O  O O  O O  O O O  O O  O O  O O
        |                                                                   |
        |                                                                   |
    800 ++                                                                  |
        |                                                                   |
    600 ++                                                                  |
        |                                                                   |
    400 ++                                                                  |
        |                                                                   |
        |                                                                   |
    200 ++                                                                  |
        *.*..*.*..*.*..*.*.*..*.*..*.*..*.*.*..*.*                          |
      0 ++------------------------------------------------------------------+


                          time.percent_of_cpu_this_job_got

   2500 O+O--O-O--O------O------O--O----O-O-O--O-O--O-O-----------O---------+
        |           O  O   O  O      O                   O O O  O    O O  O O
        |                                                                   |
   2000 ++                                                                  |
        |                                                                   |
        |                                                                   |
   1500 ++                                                                  |
        |                                                                   |
   1000 ++                                                                  |
        |                                                                   |
        |                                                                   |
    500 ++                                                                  |
        |                                                                   |
        *.*..*.*..*.*..*.*.*..*.*..*.*..*.*.*..*.*                          |
      0 ++------------------------------------------------------------------+


                                 time.elapsed_time

   70 ++----------------------------O---------------------------------------+
      |                   O  O                                              |
   65 O+ O    O O  O O  O         O    O O  O O  O    O O  O O  O O  O O  O O
      |    O                   O                   O                        |
   60 ++                                                                    |
      |                                                                     |
   55 ++                                                                    |
      |                                                                     |
   50 ++                                                                    |
      |                                                                     |
   45 ++                                                                    |
      |                                                                     |
   40 ++     .*.            .*.            .*.                              |
      *..*.*.   *..*.*..*.*.   *..*.*..*.*.   *..*                          |
   35 ++--------------------------------------------------------------------+


                                aim7.2000.jobs-per-min

   340000 ++----------------------------------------------------------------+
          |.*..        .*..          .*.. .*    *.*                         |
   320000 *+   *. .*..*    *.*.  .*.*    *  + ..                            |
   300000 ++     *             *.            *                              |
          |                                                                 |
   280000 ++                                                                |
          |                                                                 |
   260000 ++                                                                |
          |                                                                 |
   240000 ++                                                                |
   220000 ++                                                                |
          |                                                                 |
   200000 ++                                                                |
          O O  O O         O      O   O           O O                       |
   180000 ++-------O--O-O----O-O----O----O-O-O--O------O-O--O-O-O--O-O-O--O-O

Thanks,
Fengguang

--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=fcb6a15c2e7e76d493e6f91ea889ab40e1c643a4

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    572540 ~ 1%     -30.2%     399351 ~ 1%  grantley/micro/aim7/disk_src
    317151 ~ 1%     -42.0%     183863 ~ 0%  grantley/micro/aim7/shell_rtns_1
    889692 ~ 1%     -34.4%     583214 ~ 1%  TOTAL aim7.2000.jobs-per-min

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     37508 ~49%     -78.6%       8028 ~14%  grantley/micro/aim7/disk_src
     37508 ~49%     -78.6%       8028 ~14%  TOTAL numa-meminfo.node0.PageTables

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9357 ~49%     -78.6%       2003 ~14%  grantley/micro/aim7/disk_src
      9357 ~49%     -78.6%       2003 ~14%  TOTAL numa-vmstat.node0.nr_page_table_pages

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10243 ~47%     -79.6%       2089 ~19%  grantley/micro/aim7/disk_src
     14172 ~24%     -55.2%       6342 ~17%  grantley/micro/aim7/shell_rtns_1
     24415 ~33%     -65.5%       8432 ~17%  TOTAL sched_debug.cfs_rq[43]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10475 ~46%     -78.3%       2272 ~15%  grantley/micro/aim7/disk_src
     14857 ~23%     -52.9%       6994 ~15%  grantley/micro/aim7/shell_rtns_1
     25333 ~32%     -63.4%       9267 ~15%  TOTAL sched_debug.cfs_rq[43]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       792 ~ 9%     -72.5%        218 ~ 5%  lkp-sb03/micro/netperf/120s-200%-SCTP_STREAM
       792 ~ 9%     -72.5%        218 ~ 5%  TOTAL cpuidle.C3-SNB.usage

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2193 ~45%     +42.5%       3125 ~22%  grantley/micro/aim7/shell_rtns_1
      2193 ~45%     +42.5%       3125 ~22%  TOTAL numa-vmstat.node1.nr_kernel_stack

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     13469 ~40%     +50.8%      20312 ~23%  grantley/micro/aim7/shell_rtns_1
     13469 ~40%     +50.8%      20312 ~23%  TOTAL numa-vmstat.node1.nr_page_table_pages

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     53900 ~40%     +50.8%      81290 ~23%  grantley/micro/aim7/shell_rtns_1
     53900 ~40%     +50.8%      81290 ~23%  TOTAL numa-meminfo.node1.PageTables

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     26256 ~37%     -63.7%       9537 ~13%  grantley/micro/aim7/disk_src
     26256 ~37%     -63.7%       9537 ~13%  TOTAL sched_debug.cfs_rq[43]:/.spread0

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
        49 ~27%    +107.0%        102 ~35%  grantley/micro/aim7/shell_rtns_1
        49 ~27%    +107.0%        102 ~35%  TOTAL numa-vmstat.node1.nr_unstable

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    490054 ~31%     -63.6%     178531 ~10%  lkp-sb03/micro/netperf/120s-200%-SCTP_STREAM
    490054 ~31%     -63.6%     178531 ~10%  TOTAL cpuidle.C3-SNB.time

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
        69 ~33%    +181.8%        195 ~15%  grantley/micro/aim7/shell_rtns_1
        69 ~33%    +181.8%        195 ~15%  TOTAL numa-vmstat.node0.nr_written

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       100 ~10%    +106.0%        206 ~24%  grantley/micro/aim7/shell_rtns_1
       100 ~10%    +106.0%        206 ~24%  TOTAL proc-vmstat.nr_unstable

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       763 ~28%     +72.9%       1319 ~13%  grantley/micro/aim7/disk_src
     44561 ~ 4%     -44.2%      24865 ~ 4%  grantley/micro/aim7/shell_rtns_1
       443 ~12%     -73.9%        115 ~ 8%  lkp-sb03/micro/netperf/120s-200%-SCTP_STREAM
       301 ~ 6%     -35.8%        193 ~ 7%  lkp-sbx04/micro/will-it-scale/page_fault1
     46069 ~ 5%     -42.5%      26495 ~ 5%  TOTAL proc-vmstat.nr_tlb_remote_flush

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       401 ~10%    +105.6%        825 ~23%  grantley/micro/aim7/shell_rtns_1
       401 ~10%    +105.6%        825 ~23%  TOTAL meminfo.NFS_Unstable

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       532 ~49%     -51.7%        257 ~42%  grantley/micro/aim7/disk_src
     10002 ~ 2%     -41.9%       5809 ~ 3%  grantley/micro/aim7/shell_rtns_1
     10534 ~ 4%     -42.4%       6066 ~ 5%  TOTAL sched_debug.cfs_rq[16]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    122510 ~ 3%     -51.7%      59177 ~ 5%  grantley/micro/aim7/shell_rtns_1
    122510 ~ 3%     -51.7%      59177 ~ 5%  TOTAL interrupts.TLB

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1043 ~28%    +174.6%       2866 ~ 7%  grantley/micro/aim7/disk_src
     42550 ~ 1%     +27.7%      54342 ~ 2%  grantley/micro/aim7/shell_rtns_1
     43593 ~ 2%     +31.2%      57209 ~ 2%  TOTAL sched_debug.cfs_rq[22]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       165 ~44%     +73.4%        286 ~25%  grantley/micro/aim7/disk_src
       165 ~44%     +73.4%        286 ~25%  TOTAL sched_debug.cpu#30.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1062 ~10%     -63.5%        387 ~ 9%  lkp-sb03/micro/netperf/120s-200%-SCTP_STREAM
      6611 ~15%     -27.5%       4791 ~12%  lkp-sbx04/micro/will-it-scale/page_fault1
      7673 ~14%     -32.5%       5178 ~11%  TOTAL cpuidle.C1E-SNB.usage

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      7345 ~37%    +109.4%      15383 ~28%  grantley/micro/aim7/shell_rtns_1
      7345 ~37%    +109.4%      15383 ~28%  TOTAL sched_debug.cfs_rq[45]:/.spread0

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
        11 ~20%    +121.8%         26 ~18%  lkp-sb03/micro/netperf/120s-200%-SCTP_STREAM
        51 ~25%     -60.0%         20 ~42%  lkp-sbx04/micro/will-it-scale/page_fault1
        62 ~24%     -25.6%         46 ~29%  TOTAL cpuidle.C6-SNB.usage

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1565 ~47%    +170.2%       4231 ~29%  grantley/micro/aim7/disk_src
     44329 ~ 3%     +27.7%      56586 ~ 1%  grantley/micro/aim7/shell_rtns_1
     45895 ~ 4%     +32.5%      60818 ~ 3%  TOTAL sched_debug.cfs_rq[4]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      5632 ~49%     +59.2%       8968 ~25%  grantley/micro/aim7/shell_rtns_1
      5632 ~49%     +59.2%       8968 ~25%  TOTAL sched_debug.cfs_rq[26]:/.max_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      5631 ~49%     +59.2%       8968 ~25%  grantley/micro/aim7/shell_rtns_1
      5631 ~49%     +59.2%       8968 ~25%  TOTAL sched_debug.cfs_rq[26]:/.MIN_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9741 ~ 8%     -49.9%       4884 ~ 2%  grantley/micro/aim7/shell_rtns_1
      9741 ~ 8%     -49.9%       4884 ~ 2%  TOTAL sched_debug.cfs_rq[28]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1054 ~32%    +146.8%       2601 ~ 9%  grantley/micro/aim7/disk_src
     41262 ~ 2%     +27.5%      52606 ~ 2%  grantley/micro/aim7/shell_rtns_1
     42316 ~ 2%     +30.5%      55207 ~ 2%  TOTAL sched_debug.cfs_rq[27]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3627 ~31%     +63.0%       5912 ~ 4%  grantley/micro/aim7/disk_src
      5732 ~21%     +83.0%      10490 ~ 2%  grantley/micro/aim7/shell_rtns_1
      9359 ~25%     +75.2%      16403 ~ 3%  TOTAL sched_debug.cpu#3.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48835 ~10%     +56.9%      76631 ~ 3%  grantley/micro/aim7/disk_src
     75842 ~31%    +193.8%     222813 ~ 6%  grantley/micro/aim7/shell_rtns_1
    124677 ~23%    +140.2%     299444 ~ 5%  TOTAL cpuidle.C6-HSW.usage

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48073 ~ 8%     +36.0%      65364 ~ 2%  grantley/micro/aim7/shell_rtns_1
     48073 ~ 8%     +36.0%      65364 ~ 2%  TOTAL sched_debug.cfs_rq[3]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     92009 ~11%     +78.6%     164350 ~ 6%  grantley/micro/aim7/disk_src
    309711 ~ 1%    +104.8%     634181 ~ 0%  grantley/micro/aim7/shell_rtns_1
    401720 ~ 3%     +98.8%     798531 ~ 2%  TOTAL interrupts.LOC

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       461 ~17%    +111.7%        977 ~ 8%  grantley/micro/aim7/shell_rtns_1
       461 ~17%    +111.7%        977 ~ 8%  TOTAL proc-vmstat.nr_written

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
        50 ~20%    +101.6%        100 ~13%  grantley/micro/aim7/shell_rtns_1
        50 ~20%    +101.6%        100 ~13%  TOTAL numa-vmstat.node0.nr_unstable

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    226409 ~32%     +54.3%     349339 ~18%  grantley/micro/aim7/disk_src
    455688 ~23%     -55.5%     202650 ~25%  grantley/micro/aim7/shell_rtns_1
    682098 ~26%     -19.1%     551989 ~21%  TOTAL cpuidle.C1-HSW.usage

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10257 ~ 8%     -47.9%       5348 ~ 2%  grantley/micro/aim7/shell_rtns_1
     10257 ~ 8%     -47.9%       5348 ~ 2%  TOTAL sched_debug.cfs_rq[28]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1109 ~25%    +163.6%       2924 ~12%  grantley/micro/aim7/disk_src
     41742 ~ 2%     +28.1%      53487 ~ 1%  grantley/micro/aim7/shell_rtns_1
     42851 ~ 2%     +31.6%      56411 ~ 2%  TOTAL sched_debug.cfs_rq[25]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
        11 ~40%    +112.6%         23 ~32%  grantley/micro/aim7/disk_src
        11 ~40%    +112.6%         23 ~32%  TOTAL sched_debug.cpu#8.nr_uninterruptible

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1098 ~37%    +141.3%       2651 ~ 6%  grantley/micro/aim7/disk_src
     42803 ~ 4%     +27.1%      54401 ~ 3%  grantley/micro/aim7/shell_rtns_1
     43902 ~ 5%     +30.0%      57053 ~ 3%  TOTAL sched_debug.cfs_rq[23]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9656 ~ 4%     -47.5%       5071 ~ 2%  grantley/micro/aim7/shell_rtns_1
      9656 ~ 4%     -47.5%       5071 ~ 2%  TOTAL sched_debug.cfs_rq[24]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1127 ~27%    +134.1%       2639 ~ 6%  grantley/micro/aim7/disk_src
     44405 ~ 3%     +24.4%      55235 ~ 3%  grantley/micro/aim7/shell_rtns_1
     45533 ~ 3%     +27.1%      57875 ~ 3%  TOTAL sched_debug.cfs_rq[15]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       560 ~37%     +92.0%       1075 ~15%  grantley/micro/aim7/disk_src
     10106 ~ 3%     -42.4%       5822 ~ 4%  grantley/micro/aim7/shell_rtns_1
     10666 ~ 5%     -35.3%       6898 ~ 6%  TOTAL sched_debug.cfs_rq[31]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10678 ~ 5%     -45.7%       5796 ~ 3%  grantley/micro/aim7/shell_rtns_1
     10678 ~ 5%     -45.7%       5796 ~ 3%  TOTAL sched_debug.cfs_rq[35]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8700 ~ 3%     -46.1%       4687 ~ 2%  grantley/micro/aim7/shell_rtns_1
      8700 ~ 3%     -46.1%       4687 ~ 2%  TOTAL sched_debug.cfs_rq[49]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       816 ~25%    +132.5%       1898 ~12%  grantley/micro/aim7/disk_src
     53580 ~ 3%     +24.5%      66720 ~ 1%  grantley/micro/aim7/shell_rtns_1
     54396 ~ 4%     +26.1%      68619 ~ 1%  TOTAL sched_debug.cfs_rq[53]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     54327 ~ 3%     +26.1%      68520 ~ 3%  grantley/micro/aim7/shell_rtns_1
     54327 ~ 3%     +26.1%      68520 ~ 3%  TOTAL sched_debug.cfs_rq[38]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3394 ~32%     +54.0%       5226 ~22%  grantley/micro/aim7/disk_src
      5128 ~15%     +72.1%       8826 ~ 8%  grantley/micro/aim7/shell_rtns_1
      8522 ~21%     +64.9%      14052 ~13%  TOTAL sched_debug.cpu#4.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9241 ~ 2%     -45.8%       5004 ~ 5%  grantley/micro/aim7/shell_rtns_1
      9241 ~ 2%     -45.8%       5004 ~ 5%  TOTAL sched_debug.cfs_rq[25]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9907 ~ 4%     -45.6%       5387 ~ 2%  grantley/micro/aim7/shell_rtns_1
      9907 ~ 4%     -45.6%       5387 ~ 2%  TOTAL sched_debug.cfs_rq[17]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9841 ~ 4%     -46.1%       5303 ~ 3%  grantley/micro/aim7/shell_rtns_1
      9841 ~ 4%     -46.1%       5303 ~ 3%  TOTAL sched_debug.cfs_rq[15]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9621 ~ 7%     -42.1%       5567 ~14%  grantley/micro/aim7/shell_rtns_1
      9621 ~ 7%     -42.1%       5567 ~14%  TOTAL sched_debug.cfs_rq[46]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8660 ~ 2%     -45.5%       4719 ~ 1%  grantley/micro/aim7/shell_rtns_1
      8660 ~ 2%     -45.5%       4719 ~ 1%  TOTAL sched_debug.cfs_rq[51]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9510 ~ 2%     -45.0%       5227 ~ 2%  grantley/micro/aim7/shell_rtns_1
      9510 ~ 2%     -45.0%       5227 ~ 2%  TOTAL sched_debug.cfs_rq[21]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8770 ~ 3%     -45.1%       4819 ~ 2%  grantley/micro/aim7/shell_rtns_1
      8770 ~ 3%     -45.1%       4819 ~ 2%  TOTAL sched_debug.cfs_rq[26]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9333 ~ 2%     -45.0%       5132 ~ 2%  grantley/micro/aim7/shell_rtns_1
      9333 ~ 2%     -45.0%       5132 ~ 2%  TOTAL sched_debug.cfs_rq[23]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9724 ~ 3%     -45.9%       5259 ~ 3%  grantley/micro/aim7/shell_rtns_1
      9724 ~ 3%     -45.9%       5259 ~ 3%  TOTAL sched_debug.cfs_rq[18]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8396 ~ 4%     -46.4%       4504 ~ 3%  grantley/micro/aim7/shell_rtns_1
      8396 ~ 4%     -46.4%       4504 ~ 3%  TOTAL sched_debug.cfs_rq[53]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3625 ~46%     +98.8%       7210 ~20%  grantley/micro/aim7/shell_rtns_1
      3625 ~46%     +98.8%       7210 ~20%  TOTAL sched_debug.cfs_rq[39]:/.spread0

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8593 ~ 4%     -45.1%       4714 ~ 4%  grantley/micro/aim7/shell_rtns_1
      8593 ~ 4%     -45.1%       4714 ~ 4%  TOTAL sched_debug.cfs_rq[52]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1141 ~24%    +143.4%       2778 ~ 8%  grantley/micro/aim7/disk_src
     41826 ~ 2%     +29.2%      54020 ~ 1%  grantley/micro/aim7/shell_rtns_1
     42968 ~ 3%     +32.2%      56799 ~ 1%  TOTAL sched_debug.cfs_rq[11]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10081 ~ 4%     -45.2%       5529 ~ 3%  grantley/micro/aim7/shell_rtns_1
     10081 ~ 4%     -45.2%       5529 ~ 3%  TOTAL sched_debug.cfs_rq[24]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1040 ~26%    +144.0%       2539 ~ 8%  grantley/micro/aim7/disk_src
     41096 ~ 1%     +27.7%      52482 ~ 1%  grantley/micro/aim7/shell_rtns_1
     42137 ~ 2%     +30.6%      55021 ~ 2%  TOTAL sched_debug.cfs_rq[26]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       647 ~37%     +86.6%       1207 ~14%  grantley/micro/aim7/disk_src
     10749 ~ 3%     -39.8%       6472 ~ 4%  grantley/micro/aim7/shell_rtns_1
     11396 ~ 5%     -32.6%       7680 ~ 6%  TOTAL sched_debug.cfs_rq[31]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9649 ~ 3%     -44.9%       5320 ~ 2%  grantley/micro/aim7/shell_rtns_1
      9649 ~ 3%     -44.9%       5320 ~ 2%  TOTAL sched_debug.cfs_rq[20]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9937 ~ 5%     -45.2%       5441 ~ 4%  grantley/micro/aim7/shell_rtns_1
      9937 ~ 5%     -45.2%       5441 ~ 4%  TOTAL sched_debug.cfs_rq[12]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8968 ~ 4%     -44.7%       4961 ~ 5%  grantley/micro/aim7/shell_rtns_1
      8968 ~ 4%     -44.7%       4961 ~ 5%  TOTAL sched_debug.cfs_rq[27]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10480 ~ 6%     -45.7%       5685 ~ 2%  grantley/micro/aim7/shell_rtns_1
     10480 ~ 6%     -45.7%       5685 ~ 2%  TOTAL sched_debug.cfs_rq[29]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9221 ~ 3%     -42.6%       5290 ~ 3%  grantley/micro/aim7/shell_rtns_1
      9221 ~ 3%     -42.6%       5290 ~ 3%  TOTAL sched_debug.cfs_rq[26]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1129 ~29%    +131.7%       2617 ~ 7%  grantley/micro/aim7/disk_src
     41608 ~ 1%     +27.0%      52852 ~ 2%  grantley/micro/aim7/shell_rtns_1
     42738 ~ 2%     +29.8%      55470 ~ 2%  TOTAL sched_debug.cfs_rq[13]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10466 ~ 3%     -43.9%       5867 ~ 1%  grantley/micro/aim7/shell_rtns_1
     10466 ~ 3%     -43.9%       5867 ~ 1%  TOTAL sched_debug.cfs_rq[9]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9618 ~ 4%     -44.4%       5351 ~ 2%  grantley/micro/aim7/shell_rtns_1
      9618 ~ 4%     -44.4%       5351 ~ 2%  TOTAL sched_debug.cfs_rq[19]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       741 ~40%     -40.4%        441 ~39%  grantley/micro/aim7/disk_src
     10798 ~ 2%     -42.5%       6211 ~ 5%  grantley/micro/aim7/shell_rtns_1
     11539 ~ 5%     -42.3%       6653 ~ 7%  TOTAL sched_debug.cfs_rq[3]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8236 ~ 3%     -44.6%       4566 ~ 3%  grantley/micro/aim7/shell_rtns_1
      8236 ~ 3%     -44.6%       4566 ~ 3%  TOTAL sched_debug.cfs_rq[55]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       624 ~45%     -45.8%        338 ~40%  grantley/micro/aim7/disk_src
     10524 ~ 2%     -39.0%       6417 ~ 4%  grantley/micro/aim7/shell_rtns_1
     11148 ~ 4%     -39.4%       6755 ~ 6%  TOTAL sched_debug.cfs_rq[16]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     61787 ~11%     +31.2%      81064 ~ 6%  grantley/micro/aim7/shell_rtns_1
     61787 ~11%     +31.2%      81064 ~ 6%  TOTAL sched_debug.cfs_rq[44]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9932 ~ 4%     -43.6%       5606 ~ 2%  grantley/micro/aim7/shell_rtns_1
      9932 ~ 4%     -43.6%       5606 ~ 2%  TOTAL sched_debug.cfs_rq[14]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     11274 ~ 5%     -42.9%       6435 ~ 3%  grantley/micro/aim7/shell_rtns_1
     11274 ~ 5%     -42.9%       6435 ~ 3%  TOTAL sched_debug.cfs_rq[35]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1116 ~20%    +118.1%       2435 ~ 5%  grantley/micro/aim7/disk_src
     42169 ~ 1%     +29.8%      54721 ~ 2%  grantley/micro/aim7/shell_rtns_1
     43286 ~ 2%     +32.0%      57157 ~ 2%  TOTAL sched_debug.cfs_rq[10]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8770 ~ 3%     -38.5%       5396 ~17%  grantley/micro/aim7/shell_rtns_1
      8770 ~ 3%     -38.5%       5396 ~17%  TOTAL sched_debug.cfs_rq[47]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9516 ~ 4%     -43.3%       5400 ~ 1%  grantley/micro/aim7/shell_rtns_1
      9516 ~ 4%     -43.3%       5400 ~ 1%  TOTAL sched_debug.cfs_rq[40]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10305 ~ 3%     -43.5%       5823 ~ 3%  grantley/micro/aim7/shell_rtns_1
     10305 ~ 3%     -43.5%       5823 ~ 3%  TOTAL sched_debug.cfs_rq[15]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1100 ~26%    +124.4%       2469 ~ 3%  grantley/micro/aim7/disk_src
     42434 ~ 2%     +26.7%      53769 ~ 2%  grantley/micro/aim7/shell_rtns_1
     43534 ~ 3%     +29.2%      56239 ~ 2%  TOTAL sched_debug.cfs_rq[9]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9813 ~ 2%     -43.3%       5560 ~ 2%  grantley/micro/aim7/shell_rtns_1
      9813 ~ 2%     -43.3%       5560 ~ 2%  TOTAL sched_debug.cfs_rq[23]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9797 ~ 3%     -43.0%       5582 ~ 2%  grantley/micro/aim7/shell_rtns_1
      9797 ~ 3%     -43.0%       5582 ~ 2%  TOTAL sched_debug.cfs_rq[37]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8275 ~ 3%     -43.7%       4661 ~ 4%  grantley/micro/aim7/shell_rtns_1
      8275 ~ 3%     -43.7%       4661 ~ 4%  TOTAL sched_debug.cfs_rq[54]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10213 ~ 3%     -43.6%       5759 ~ 3%  grantley/micro/aim7/shell_rtns_1
     10213 ~ 3%     -43.6%       5759 ~ 3%  TOTAL sched_debug.cfs_rq[18]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10277 ~ 4%     -42.5%       5909 ~ 3%  grantley/micro/aim7/shell_rtns_1
     10277 ~ 4%     -42.5%       5909 ~ 3%  TOTAL sched_debug.cfs_rq[32]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10348 ~ 4%     -43.1%       5890 ~ 2%  grantley/micro/aim7/shell_rtns_1
     10348 ~ 4%     -43.1%       5890 ~ 2%  TOTAL sched_debug.cfs_rq[17]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9706 ~ 2%     -43.5%       5488 ~ 5%  grantley/micro/aim7/shell_rtns_1
      9706 ~ 2%     -43.5%       5488 ~ 5%  TOTAL sched_debug.cfs_rq[25]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10294 ~ 4%     -43.3%       5833 ~ 3%  grantley/micro/aim7/shell_rtns_1
     10294 ~ 4%     -43.3%       5833 ~ 3%  TOTAL sched_debug.cfs_rq[11]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9506 ~ 3%     -43.5%       5371 ~ 3%  grantley/micro/aim7/shell_rtns_1
      9506 ~ 3%     -43.5%       5371 ~ 3%  TOTAL sched_debug.cfs_rq[41]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       869 ~33%    +111.4%       1837 ~ 8%  grantley/micro/aim7/disk_src
     53579 ~ 3%     +23.8%      66337 ~ 0%  grantley/micro/aim7/shell_rtns_1
     54448 ~ 3%     +25.2%      68175 ~ 1%  TOTAL sched_debug.cfs_rq[54]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9978 ~ 2%     -42.8%       5710 ~ 2%  grantley/micro/aim7/shell_rtns_1
      9978 ~ 2%     -42.8%       5710 ~ 2%  TOTAL sched_debug.cfs_rq[21]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     11119 ~ 6%     -43.4%       6290 ~ 2%  grantley/micro/aim7/shell_rtns_1
     11119 ~ 6%     -43.4%       6290 ~ 2%  TOTAL sched_debug.cfs_rq[29]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10824 ~ 2%     -42.0%       6273 ~ 3%  grantley/micro/aim7/shell_rtns_1
     10824 ~ 2%     -42.0%       6273 ~ 3%  TOTAL sched_debug.cfs_rq[1]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10194 ~ 6%     -39.0%       6215 ~13%  grantley/micro/aim7/shell_rtns_1
     10194 ~ 6%     -39.0%       6215 ~13%  TOTAL sched_debug.cfs_rq[46]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10749 ~ 2%     -42.8%       6153 ~ 2%  grantley/micro/aim7/shell_rtns_1
     10749 ~ 2%     -42.8%       6153 ~ 2%  TOTAL sched_debug.cfs_rq[6]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10067 ~ 4%     -42.4%       5800 ~ 1%  grantley/micro/aim7/shell_rtns_1
     10067 ~ 4%     -42.4%       5800 ~ 1%  TOTAL sched_debug.cfs_rq[19]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8908 ~ 3%     -42.8%       5093 ~ 2%  grantley/micro/aim7/shell_rtns_1
      8908 ~ 3%     -42.8%       5093 ~ 2%  TOTAL sched_debug.cfs_rq[44]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9289 ~ 3%     -44.0%       5198 ~ 6%  grantley/micro/aim7/shell_rtns_1
      9289 ~ 3%     -44.0%       5198 ~ 6%  TOTAL sched_debug.cfs_rq[22]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10207 ~ 3%     -39.1%       6216 ~ 9%  grantley/micro/aim7/shell_rtns_1
     10207 ~ 3%     -39.1%       6216 ~ 9%  TOTAL sched_debug.cfs_rq[34]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9377 ~ 4%     -42.2%       5422 ~ 4%  grantley/micro/aim7/shell_rtns_1
      9377 ~ 4%     -42.2%       5422 ~ 4%  TOTAL sched_debug.cfs_rq[27]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10786 ~ 3%     -43.5%       6091 ~ 4%  grantley/micro/aim7/shell_rtns_1
     10786 ~ 3%     -43.5%       6091 ~ 4%  TOTAL sched_debug.cfs_rq[2]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8933 ~ 4%     -42.3%       5156 ~ 4%  grantley/micro/aim7/shell_rtns_1
      8933 ~ 4%     -42.3%       5156 ~ 4%  TOTAL sched_debug.cfs_rq[48]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9281 ~ 3%     -42.9%       5299 ~ 1%  grantley/micro/aim7/shell_rtns_1
      9281 ~ 3%     -42.9%       5299 ~ 1%  TOTAL sched_debug.cfs_rq[49]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10928 ~ 3%     -41.8%       6365 ~ 1%  grantley/micro/aim7/shell_rtns_1
     10928 ~ 3%     -41.8%       6365 ~ 1%  TOTAL sched_debug.cfs_rq[9]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       865 ~31%     +93.7%       1676 ~15%  grantley/micro/aim7/disk_src
     53735 ~ 4%     +22.7%      65941 ~ 2%  grantley/micro/aim7/shell_rtns_1
     54601 ~ 4%     +23.8%      67618 ~ 2%  TOTAL sched_debug.cfs_rq[40]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8758 ~ 7%     -45.0%       4814 ~ 3%  grantley/micro/aim7/shell_rtns_1
      8758 ~ 7%     -45.0%       4814 ~ 3%  TOTAL sched_debug.cfs_rq[50]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       841 ~27%    +117.7%       1831 ~18%  grantley/micro/aim7/disk_src
     52702 ~ 4%     +27.0%      66951 ~ 1%  grantley/micro/aim7/shell_rtns_1
     53543 ~ 4%     +28.5%      68782 ~ 2%  TOTAL sched_debug.cfs_rq[42]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9218 ~ 4%     -36.9%       5820 ~13%  grantley/micro/aim7/shell_rtns_1
      9218 ~ 4%     -36.9%       5820 ~13%  TOTAL sched_debug.cfs_rq[45]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     43647 ~ 3%     +26.9%      55382 ~ 2%  grantley/micro/aim7/shell_rtns_1
     43647 ~ 3%     +26.9%      55382 ~ 2%  TOTAL sched_debug.cfs_rq[19]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10371 ~ 4%     -42.9%       5922 ~ 4%  grantley/micro/aim7/shell_rtns_1
     10371 ~ 4%     -42.9%       5922 ~ 4%  TOTAL sched_debug.cfs_rq[12]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9674 ~ 3%     -42.1%       5604 ~ 2%  grantley/micro/aim7/shell_rtns_1
      9674 ~ 3%     -42.1%       5604 ~ 2%  TOTAL sched_debug.cfs_rq[38]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9185 ~ 2%     -41.8%       5344 ~ 0%  grantley/micro/aim7/shell_rtns_1
      9185 ~ 2%     -41.8%       5344 ~ 0%  TOTAL sched_debug.cfs_rq[51]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10829 ~ 3%     -42.0%       6283 ~ 2%  grantley/micro/aim7/shell_rtns_1
     10829 ~ 3%     -42.0%       6283 ~ 2%  TOTAL sched_debug.cfs_rq[4]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10088 ~ 3%     -42.3%       5818 ~ 1%  grantley/micro/aim7/shell_rtns_1
     10088 ~ 3%     -42.3%       5818 ~ 1%  TOTAL sched_debug.cfs_rq[20]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10753 ~ 4%     -41.5%       6294 ~ 3%  grantley/micro/aim7/shell_rtns_1
     10753 ~ 4%     -41.5%       6294 ~ 3%  TOTAL sched_debug.cfs_rq[11]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9558 ~ 2%     -41.4%       5604 ~ 2%  grantley/micro/aim7/shell_rtns_1
      9558 ~ 2%     -41.4%       5604 ~ 2%  TOTAL sched_debug.cfs_rq[39]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     42760 ~ 2%     +26.2%      53954 ~ 1%  grantley/micro/aim7/shell_rtns_1
     42760 ~ 2%     +26.2%      53954 ~ 1%  TOTAL sched_debug.cfs_rq[21]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9696 ~ 3%     -41.7%       5649 ~ 2%  grantley/micro/aim7/shell_rtns_1
      9696 ~ 3%     -41.7%       5649 ~ 2%  TOTAL sched_debug.cfs_rq[36]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4576 ~ 8%     +67.7%       7676 ~ 0%  grantley/micro/aim7/shell_rtns_1
      4576 ~ 8%     +67.7%       7676 ~ 0%  TOTAL sched_debug.cpu#29.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       875 ~28%    +119.7%       1924 ~37%  grantley/micro/aim7/disk_src
     53907 ~ 4%     +26.3%      68062 ~ 1%  grantley/micro/aim7/shell_rtns_1
     54783 ~ 4%     +27.8%      69987 ~ 2%  TOTAL sched_debug.cfs_rq[39]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10477 ~ 2%     -41.4%       6138 ~ 1%  grantley/micro/aim7/shell_rtns_1
     10477 ~ 2%     -41.4%       6138 ~ 1%  TOTAL sched_debug.cfs_rq[7]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10821 ~ 5%     -42.7%       6204 ~ 3%  grantley/micro/aim7/shell_rtns_1
     10821 ~ 5%     -42.7%       6204 ~ 3%  TOTAL sched_debug.cfs_rq[5]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9134 ~ 4%     -42.1%       5292 ~ 4%  grantley/micro/aim7/shell_rtns_1
      9134 ~ 4%     -42.1%       5292 ~ 4%  TOTAL sched_debug.cfs_rq[52]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10349 ~ 4%     -41.1%       6094 ~ 1%  grantley/micro/aim7/shell_rtns_1
     10349 ~ 4%     -41.1%       6094 ~ 1%  TOTAL sched_debug.cfs_rq[14]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1445 ~31%    +132.0%       3353 ~18%  grantley/micro/aim7/disk_src
     43797 ~ 3%     +28.0%      56073 ~ 2%  grantley/micro/aim7/shell_rtns_1
     45242 ~ 3%     +31.4%      59427 ~ 3%  TOTAL sched_debug.cfs_rq[5]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    581065 ~ 1%     -41.3%     341239 ~ 0%  grantley/micro/aim7/shell_rtns_1
    581065 ~ 1%     -41.3%     341239 ~ 0%  TOTAL sched_debug.cfs_rq[25]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10444 ~ 3%     -41.8%       6081 ~ 3%  grantley/micro/aim7/shell_rtns_1
     10444 ~ 3%     -41.8%       6081 ~ 3%  TOTAL sched_debug.cfs_rq[8]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    583507 ~ 1%     -41.2%     343371 ~ 0%  grantley/micro/aim7/shell_rtns_1
    583507 ~ 1%     -41.2%     343371 ~ 0%  TOTAL sched_debug.cfs_rq[24]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    586517 ~ 1%     -41.1%     345269 ~ 0%  grantley/micro/aim7/shell_rtns_1
    586517 ~ 1%     -41.1%     345269 ~ 0%  TOTAL sched_debug.cfs_rq[23]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      7151 ~33%     +91.1%      13666 ~19%  grantley/micro/aim7/disk_src
     44200 ~ 5%     +19.2%      52683 ~ 3%  grantley/micro/aim7/shell_rtns_1
     51352 ~ 9%     +29.2%      66350 ~ 6%  TOTAL sched_debug.cpu#15.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9279 ~ 7%     -41.2%       5457 ~ 3%  grantley/micro/aim7/shell_rtns_1
      9279 ~ 7%     -41.2%       5457 ~ 3%  TOTAL sched_debug.cfs_rq[50]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    588993 ~ 1%     -41.1%     347181 ~ 0%  grantley/micro/aim7/shell_rtns_1
    588993 ~ 1%     -41.1%     347181 ~ 0%  TOTAL sched_debug.cfs_rq[22]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8916 ~ 4%     -42.5%       5130 ~ 3%  grantley/micro/aim7/shell_rtns_1
      8916 ~ 4%     -42.5%       5130 ~ 3%  TOTAL sched_debug.cfs_rq[53]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     42514 ~ 1%     +26.2%      53669 ~ 1%  grantley/micro/aim7/shell_rtns_1
     42514 ~ 1%     +26.2%      53669 ~ 1%  TOTAL sched_debug.cfs_rq[8]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       143 ~24%    +102.5%        291 ~15%  grantley/micro/aim7/shell_rtns_1
       143 ~24%    +102.5%        291 ~15%  TOTAL numa-vmstat.node0.nr_dirtied

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     11387 ~ 3%     -40.7%       6749 ~ 4%  grantley/micro/aim7/shell_rtns_1
     11387 ~ 3%     -40.7%       6749 ~ 4%  TOTAL sched_debug.cfs_rq[2]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
   6632415 ~15%     +56.8%   10402525 ~ 9%  grantley/micro/aim7/disk_src
 1.239e+08 ~25%    +121.5%  2.744e+08 ~ 4%  grantley/micro/aim7/shell_rtns_1
 1.305e+08 ~24%    +118.2%  2.848e+08 ~ 4%  TOTAL cpuidle.C3-HSW.time

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    611785 ~ 1%     -40.5%     363776 ~ 0%  grantley/micro/aim7/shell_rtns_1
    611785 ~ 1%     -40.5%     363776 ~ 0%  TOTAL sched_debug.cfs_rq[14]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10064 ~ 5%     -42.5%       5783 ~ 3%  grantley/micro/aim7/shell_rtns_1
     10064 ~ 5%     -42.5%       5783 ~ 3%  TOTAL sched_debug.cfs_rq[13]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    615228 ~ 1%     -40.5%     366112 ~ 0%  grantley/micro/aim7/shell_rtns_1
    615228 ~ 1%     -40.5%     366112 ~ 0%  TOTAL sched_debug.cfs_rq[13]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9835 ~ 3%     -34.4%       6448 ~12%  grantley/micro/aim7/shell_rtns_1
      9835 ~ 3%     -34.4%       6448 ~12%  TOTAL sched_debug.cfs_rq[45]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    618480 ~ 1%     -40.4%     368610 ~ 0%  grantley/micro/aim7/shell_rtns_1
    618480 ~ 1%     -40.4%     368610 ~ 0%  TOTAL sched_debug.cfs_rq[12]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    621495 ~ 1%     -40.3%     370965 ~ 0%  grantley/micro/aim7/shell_rtns_1
    621495 ~ 1%     -40.3%     370965 ~ 0%  TOTAL sched_debug.cfs_rq[11]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8822 ~ 3%     -40.2%       5274 ~ 2%  grantley/micro/aim7/shell_rtns_1
      8822 ~ 3%     -40.2%       5274 ~ 2%  TOTAL sched_debug.cfs_rq[54]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9938 ~ 3%     -41.0%       5864 ~ 3%  grantley/micro/aim7/shell_rtns_1
      9938 ~ 3%     -41.0%       5864 ~ 3%  TOTAL sched_debug.cfs_rq[33]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10066 ~ 4%     -40.2%       6017 ~ 2%  grantley/micro/aim7/shell_rtns_1
     10066 ~ 4%     -40.2%       6017 ~ 2%  TOTAL sched_debug.cfs_rq[40]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9504 ~ 3%     -39.9%       5715 ~ 1%  grantley/micro/aim7/shell_rtns_1
      9504 ~ 3%     -39.9%       5715 ~ 1%  TOTAL sched_debug.cfs_rq[44]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3578 ~45%    +120.9%       7904 ~45%  grantley/micro/aim7/disk_src
     57631 ~ 4%     +32.3%      76241 ~ 5%  grantley/micro/aim7/shell_rtns_1
     61209 ~ 7%     +37.5%      84145 ~ 9%  TOTAL sched_debug.cfs_rq[45]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    624600 ~ 1%     -40.1%     373907 ~ 0%  grantley/micro/aim7/shell_rtns_1
    624600 ~ 1%     -40.1%     373907 ~ 0%  TOTAL sched_debug.cfs_rq[10]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8953 ~ 2%     -38.6%       5501 ~ 3%  grantley/micro/aim7/shell_rtns_1
      8953 ~ 2%     -38.6%       5501 ~ 3%  TOTAL sched_debug.cfs_rq[42]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     11243 ~ 2%     -40.4%       6705 ~ 1%  grantley/micro/aim7/shell_rtns_1
     11243 ~ 2%     -40.4%       6705 ~ 1%  TOTAL sched_debug.cfs_rq[6]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2540 ~16%     +49.1%       3788 ~ 7%  grantley/micro/aim7/disk_src
      4707 ~ 9%     +99.1%       9371 ~ 8%  grantley/micro/aim7/shell_rtns_1
      7247 ~12%     +81.6%      13159 ~ 8%  TOTAL sched_debug.cpu#30.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     11479 ~ 2%     -38.7%       7034 ~ 3%  grantley/micro/aim7/shell_rtns_1
     11479 ~ 2%     -38.7%       7034 ~ 3%  TOTAL sched_debug.cfs_rq[1]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10236 ~ 3%     -39.0%       6239 ~ 2%  grantley/micro/aim7/shell_rtns_1
     10236 ~ 3%     -39.0%       6239 ~ 2%  TOTAL sched_debug.cfs_rq[38]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9731 ~ 3%     -41.2%       5719 ~ 4%  grantley/micro/aim7/shell_rtns_1
      9731 ~ 3%     -41.2%       5719 ~ 4%  TOTAL sched_debug.cfs_rq[22]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10790 ~ 3%     -36.4%       6865 ~ 8%  grantley/micro/aim7/shell_rtns_1
     10790 ~ 3%     -36.4%       6865 ~ 8%  TOTAL sched_debug.cfs_rq[34]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10815 ~ 4%     -40.0%       6488 ~ 3%  grantley/micro/aim7/shell_rtns_1
     10815 ~ 4%     -40.0%       6488 ~ 3%  TOTAL sched_debug.cfs_rq[0]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10228 ~ 2%     -40.2%       6114 ~ 5%  grantley/micro/aim7/shell_rtns_1
     10228 ~ 2%     -40.2%       6114 ~ 5%  TOTAL sched_debug.cfs_rq[10]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10532 ~ 5%     -40.4%       6276 ~ 2%  grantley/micro/aim7/shell_rtns_1
     10532 ~ 5%     -40.4%       6276 ~ 2%  TOTAL sched_debug.cfs_rq[13]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2843 ~17%     +47.6%       4197 ~11%  grantley/micro/aim7/disk_src
      4657 ~ 5%     +79.6%       8365 ~ 3%  grantley/micro/aim7/shell_rtns_1
      7500 ~ 9%     +67.5%      12563 ~ 5%  TOTAL sched_debug.cpu#5.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10813 ~ 4%     -39.1%       6583 ~ 3%  grantley/micro/aim7/shell_rtns_1
     10813 ~ 4%     -39.1%       6583 ~ 3%  TOTAL sched_debug.cfs_rq[32]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     56942 ~19%     -36.3%      36271 ~11%  grantley/micro/aim7/disk_src
     56942 ~19%     -36.3%      36271 ~11%  TOTAL numa-meminfo.node0.Active(anon)

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     14214 ~19%     -36.3%       9058 ~11%  grantley/micro/aim7/disk_src
     14214 ~19%     -36.3%       9058 ~11%  TOTAL numa-vmstat.node0.nr_active_anon

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     11328 ~ 2%     -39.5%       6848 ~ 4%  grantley/micro/aim7/shell_rtns_1
     11328 ~ 2%     -39.5%       6848 ~ 4%  TOTAL sched_debug.cfs_rq[3]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     11417 ~ 3%     -39.4%       6914 ~ 2%  grantley/micro/aim7/shell_rtns_1
     11417 ~ 3%     -39.4%       6914 ~ 2%  TOTAL sched_debug.cfs_rq[4]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10974 ~ 2%     -39.4%       6655 ~ 1%  grantley/micro/aim7/shell_rtns_1
     10974 ~ 2%     -39.4%       6655 ~ 1%  TOTAL sched_debug.cfs_rq[7]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10059 ~ 3%     -40.2%       6016 ~ 3%  grantley/micro/aim7/shell_rtns_1
     10059 ~ 3%     -40.2%       6016 ~ 3%  TOTAL sched_debug.cfs_rq[41]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    638378 ~ 1%     -39.6%     385849 ~ 0%  grantley/micro/aim7/shell_rtns_1
    638378 ~ 1%     -39.6%     385849 ~ 0%  TOTAL sched_debug.cfs_rq[6]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     11363 ~ 5%     -40.4%       6768 ~ 3%  grantley/micro/aim7/shell_rtns_1
     11363 ~ 5%     -40.4%       6768 ~ 3%  TOTAL sched_debug.cfs_rq[5]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10358 ~ 3%     -39.7%       6244 ~ 1%  grantley/micro/aim7/shell_rtns_1
     10358 ~ 3%     -39.7%       6244 ~ 1%  TOTAL sched_debug.cfs_rq[37]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9367 ~ 2%     -35.2%       6074 ~15%  grantley/micro/aim7/shell_rtns_1
      9367 ~ 2%     -35.2%       6074 ~15%  TOTAL sched_debug.cfs_rq[47]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8748 ~ 4%     -40.5%       5209 ~ 3%  grantley/micro/aim7/shell_rtns_1
      8748 ~ 4%     -40.5%       5209 ~ 3%  TOTAL sched_debug.cfs_rq[55]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     54993 ~ 3%     +23.8%      68062 ~ 3%  grantley/micro/aim7/shell_rtns_1
     54993 ~ 3%     +23.8%      68062 ~ 3%  TOTAL sched_debug.cfs_rq[36]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    642148 ~ 1%     -39.3%     389878 ~ 0%  grantley/micro/aim7/shell_rtns_1
    642148 ~ 1%     -39.3%     389878 ~ 0%  TOTAL sched_debug.cfs_rq[5]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     14118 ~19%     -36.2%       9013 ~11%  grantley/micro/aim7/disk_src
     14118 ~19%     -36.2%       9013 ~11%  TOTAL numa-vmstat.node0.nr_anon_pages

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     56570 ~19%     -36.2%      36093 ~11%  grantley/micro/aim7/disk_src
     56570 ~19%     -36.2%      36093 ~11%  TOTAL numa-meminfo.node0.AnonPages

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    713419 ~ 2%     -37.4%     446568 ~ 5%  grantley/micro/aim7/shell_rtns_1
    713419 ~ 2%     -37.4%     446568 ~ 5%  TOTAL cpuidle.C1E-HSW.usage

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9485 ~ 3%     -38.6%       5821 ~ 4%  grantley/micro/aim7/shell_rtns_1
      9485 ~ 3%     -38.6%       5821 ~ 4%  TOTAL sched_debug.cfs_rq[48]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     86840 ~ 6%     +67.0%     145010 ~ 0%  grantley/micro/aim7/shell_rtns_1
     86840 ~ 6%     +67.0%     145010 ~ 0%  TOTAL softirqs.SCHED

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10923 ~ 3%     -39.5%       6611 ~ 2%  grantley/micro/aim7/shell_rtns_1
     10923 ~ 3%     -39.5%       6611 ~ 2%  TOTAL sched_debug.cfs_rq[8]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10134 ~ 3%     -38.0%       6284 ~ 3%  grantley/micro/aim7/shell_rtns_1
     10134 ~ 3%     -38.0%       6284 ~ 3%  TOTAL sched_debug.cfs_rq[39]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    646036 ~ 1%     -39.0%     393902 ~ 0%  grantley/micro/aim7/shell_rtns_1
    646036 ~ 1%     -39.0%     393902 ~ 0%  TOTAL sched_debug.cfs_rq[4]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       876 ~29%     +89.0%       1657 ~19%  grantley/micro/aim7/disk_src
     53020 ~ 3%     +26.6%      67099 ~ 2%  grantley/micro/aim7/shell_rtns_1
     53896 ~ 4%     +27.6%      68756 ~ 2%  TOTAL sched_debug.cfs_rq[41]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    582056 ~ 0%     -38.3%     359393 ~ 1%  lkp-sbx04/micro/will-it-scale/page_fault1
    582056 ~ 0%     -38.3%     359393 ~ 1%  TOTAL cpuidle.C7-SNB.usage

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
  1.49e+08 ~14%     +77.5%  2.645e+08 ~ 6%  grantley/micro/aim7/disk_src
  70644551 ~ 9%     -31.6%   48296914 ~18%  grantley/micro/aim7/shell_rtns_1
 2.197e+08 ~13%     +42.4%  3.128e+08 ~ 8%  TOTAL cpuidle.C1-HSW.time

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1341 ~30%    +108.8%       2800 ~14%  grantley/micro/aim7/disk_src
     43131 ~ 3%     +27.1%      54802 ~ 1%  grantley/micro/aim7/shell_rtns_1
     44473 ~ 4%     +29.5%      57602 ~ 2%  TOTAL sched_debug.cfs_rq[7]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       850 ~27%    +112.9%       1809 ~ 8%  grantley/micro/aim7/disk_src
     53531 ~ 4%     +24.2%      66500 ~ 1%  grantley/micro/aim7/shell_rtns_1
     54381 ~ 4%     +25.6%      68310 ~ 1%  TOTAL sched_debug.cfs_rq[55]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    650031 ~ 1%     -38.8%     398052 ~ 0%  grantley/micro/aim7/shell_rtns_1
    650031 ~ 1%     -38.8%     398052 ~ 0%  TOTAL sched_debug.cfs_rq[3]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10272 ~ 3%     -38.8%       6286 ~ 2%  grantley/micro/aim7/shell_rtns_1
     10272 ~ 3%     -38.8%       6286 ~ 2%  TOTAL sched_debug.cfs_rq[36]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10665 ~ 2%     -37.9%       6618 ~ 5%  grantley/micro/aim7/shell_rtns_1
     10665 ~ 2%     -37.9%       6618 ~ 5%  TOTAL sched_debug.cfs_rq[10]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    654255 ~ 1%     -38.6%     401913 ~ 0%  grantley/micro/aim7/shell_rtns_1
    654255 ~ 1%     -38.6%     401913 ~ 0%  TOTAL sched_debug.cfs_rq[2]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    658375 ~ 1%     -38.4%     405385 ~ 0%  grantley/micro/aim7/shell_rtns_1
    658375 ~ 1%     -38.4%     405385 ~ 0%  TOTAL sched_debug.cfs_rq[1]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      5665 ~33%     +80.1%      10201 ~22%  grantley/micro/aim7/disk_src
     42657 ~ 4%     +19.9%      51131 ~ 2%  grantley/micro/aim7/shell_rtns_1
     48323 ~ 7%     +26.9%      61332 ~ 5%  TOTAL sched_debug.cpu#44.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    662459 ~ 1%     -38.3%     408666 ~ 0%  grantley/micro/aim7/shell_rtns_1
    662459 ~ 1%     -38.3%     408666 ~ 0%  TOTAL sched_debug.cfs_rq[0]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1038 ~26%    +136.3%       2454 ~ 8%  grantley/micro/aim7/disk_src
     41609 ~ 2%     +29.5%      53896 ~ 2%  grantley/micro/aim7/shell_rtns_1
     42648 ~ 2%     +32.1%      56350 ~ 2%  TOTAL sched_debug.cfs_rq[12]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      7862 ~39%     +79.0%      14075 ~12%  grantley/micro/aim7/disk_src
     45696 ~ 6%     +18.9%      54336 ~ 4%  grantley/micro/aim7/shell_rtns_1
     53558 ~10%     +27.7%      68412 ~ 6%  TOTAL sched_debug.cpu#4.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     11487 ~ 3%     -37.3%       7197 ~ 3%  grantley/micro/aim7/shell_rtns_1
     11487 ~ 3%     -37.3%       7197 ~ 3%  TOTAL sched_debug.cfs_rq[0]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9515 ~ 2%     -35.5%       6139 ~ 3%  grantley/micro/aim7/shell_rtns_1
      9515 ~ 2%     -35.5%       6139 ~ 3%  TOTAL sched_debug.cfs_rq[42]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1453 ~42%     +82.8%       2656 ~ 6%  grantley/micro/aim7/disk_src
     45410 ~ 2%     +25.4%      56950 ~ 1%  grantley/micro/aim7/shell_rtns_1
     46863 ~ 3%     +27.2%      59607 ~ 1%  TOTAL sched_debug.cfs_rq[1]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       168 ~19%     +45.7%        244 ~18%  grantley/micro/aim7/shell_rtns_1
       168 ~19%     +45.7%        244 ~18%  TOTAL numa-vmstat.node1.nr_dirtied

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     10506 ~ 3%     -38.2%       6491 ~ 3%  grantley/micro/aim7/shell_rtns_1
     10506 ~ 3%     -38.2%       6491 ~ 3%  TOTAL sched_debug.cfs_rq[33]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     43937 ~ 4%     +21.1%      53206 ~ 2%  grantley/micro/aim7/shell_rtns_1
     43937 ~ 4%     +21.1%      53206 ~ 2%  TOTAL sched_debug.cfs_rq[14]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1347 ~48%     +88.7%       2543 ~ 9%  grantley/micro/aim7/disk_src
     42619 ~ 2%     +24.8%      53210 ~ 2%  grantley/micro/aim7/shell_rtns_1
     43966 ~ 4%     +26.8%      55753 ~ 2%  TOTAL sched_debug.cfs_rq[24]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2657 ~10%     +33.0%       3534 ~ 4%  grantley/micro/aim7/disk_src
      4611 ~ 4%     +75.2%       8080 ~ 0%  grantley/micro/aim7/shell_rtns_1
      7268 ~ 7%     +59.8%      11615 ~ 1%  TOTAL sched_debug.cpu#1.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1782 ~36%     +64.1%       2924 ~11%  grantley/micro/aim7/disk_src
     44678 ~ 3%     +23.9%      55365 ~ 1%  grantley/micro/aim7/shell_rtns_1
     46460 ~ 4%     +25.5%      58289 ~ 2%  TOTAL sched_debug.cfs_rq[17]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     42944 ~ 1%     +27.7%      54847 ~ 1%  grantley/micro/aim7/shell_rtns_1
     42944 ~ 1%     +27.7%      54847 ~ 1%  TOTAL sched_debug.cfs_rq[6]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2189 ~ 9%     +34.0%       2933 ~ 6%  grantley/micro/aim7/disk_src
      4294 ~ 3%     +78.6%       7667 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6483 ~ 5%     +63.5%      10601 ~ 2%  TOTAL sched_debug.cpu#45.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2.35 ~ 5%     -48.5%       1.21 ~ 0%  lkp-sb03/micro/netperf/120s-200%-SCTP_STREAM
      2.89 ~ 0%     -14.8%       2.46 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
      5.24 ~ 2%     -29.9%       3.67 ~ 0%  TOTAL turbostat.GHz

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4602 ~24%     +91.3%       8805 ~13%  grantley/micro/aim7/disk_src
     42434 ~ 3%     +17.6%      49903 ~ 4%  grantley/micro/aim7/shell_rtns_1
     47036 ~ 5%     +24.8%      58708 ~ 6%  TOTAL sched_debug.cpu#9.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       390 ~18%     +51.1%        590 ~10%  grantley/micro/aim7/shell_rtns_1
       390 ~18%     +51.1%        590 ~10%  TOTAL sched_debug.cpu#32.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3214 ~20%     +84.9%       5944 ~27%  grantley/micro/aim7/disk_src
     39958 ~ 2%     +16.5%      46569 ~ 3%  grantley/micro/aim7/shell_rtns_1
     43173 ~ 3%     +21.6%      52514 ~ 6%  TOTAL sched_debug.cpu#40.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2457 ~ 8%     +41.3%       3471 ~13%  grantley/micro/aim7/disk_src
      4426 ~ 3%     +81.3%       8025 ~ 3%  grantley/micro/aim7/shell_rtns_1
      6883 ~ 5%     +67.0%      11497 ~ 6%  TOTAL sched_debug.cpu#13.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3444 ~25%     +72.6%       5943 ~23%  grantley/micro/aim7/disk_src
     41210 ~ 3%     +16.6%      48053 ~ 3%  grantley/micro/aim7/shell_rtns_1
     44655 ~ 5%     +20.9%      53996 ~ 5%  TOTAL sched_debug.cpu#36.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2110 ~ 8%     +33.2%       2810 ~ 8%  grantley/micro/aim7/disk_src
      4217 ~ 3%     +82.2%       7683 ~ 1%  grantley/micro/aim7/shell_rtns_1
      6327 ~ 4%     +65.8%      10494 ~ 3%  TOTAL sched_debug.cpu#38.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       263 ~ 1%     +36.0%        358 ~ 2%  grantley/micro/aim7/disk_src
       615 ~ 4%     +75.6%       1081 ~ 0%  grantley/micro/aim7/shell_rtns_1
       879 ~ 3%     +63.8%       1439 ~ 1%  TOTAL proc-vmstat.nr_dirtied

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2238 ~ 8%     +30.5%       2920 ~ 9%  grantley/micro/aim7/disk_src
      4326 ~ 3%     +81.5%       7852 ~ 3%  grantley/micro/aim7/shell_rtns_1
      6565 ~ 5%     +64.1%      10772 ~ 4%  TOTAL sched_debug.cpu#33.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2470 ~ 8%     +38.0%       3410 ~ 6%  grantley/micro/aim7/disk_src
      4497 ~ 2%     +79.3%       8062 ~ 3%  grantley/micro/aim7/shell_rtns_1
      6968 ~ 4%     +64.6%      11473 ~ 4%  TOTAL sched_debug.cpu#8.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     49340 ~25%     +62.9%      80397 ~ 3%  grantley/micro/aim7/disk_src
     76975 ~ 6%     +16.3%      89539 ~ 2%  grantley/micro/aim7/shell_rtns_1
    126316 ~13%     +34.5%     169937 ~ 3%  TOTAL numa-meminfo.node1.Active(anon)

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     12319 ~25%     +62.9%      20063 ~ 3%  grantley/micro/aim7/disk_src
     19238 ~ 6%     +16.3%      22369 ~ 2%  grantley/micro/aim7/shell_rtns_1
     31557 ~13%     +34.5%      42432 ~ 3%  TOTAL numa-vmstat.node1.nr_active_anon

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2119 ~ 8%     +32.0%       2796 ~ 9%  grantley/micro/aim7/disk_src
      4226 ~ 3%     +80.7%       7638 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6346 ~ 4%     +64.4%      10434 ~ 2%  TOTAL sched_debug.cpu#37.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48995 ~24%     +63.2%      79979 ~ 3%  grantley/micro/aim7/disk_src
     66965 ~ 6%     +14.6%      76721 ~ 2%  grantley/micro/aim7/shell_rtns_1
    115960 ~14%     +35.1%     156700 ~ 3%  TOTAL numa-meminfo.node1.AnonPages

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     54888 ~ 3%     +26.3%      69314 ~ 1%  grantley/micro/aim7/shell_rtns_1
     54888 ~ 3%     +26.3%      69314 ~ 1%  TOTAL sched_debug.cfs_rq[37]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     12232 ~24%     +63.1%      19953 ~ 3%  grantley/micro/aim7/disk_src
     16733 ~ 6%     +14.7%      19188 ~ 3%  grantley/micro/aim7/shell_rtns_1
     28965 ~14%     +35.1%      39141 ~ 3%  TOTAL numa-vmstat.node1.nr_anon_pages

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2732 ~18%     +26.5%       3457 ~ 7%  grantley/micro/aim7/disk_src
      4478 ~ 4%     +80.5%       8083 ~ 2%  grantley/micro/aim7/shell_rtns_1
      7211 ~ 9%     +60.0%      11540 ~ 3%  TOTAL sched_debug.cpu#7.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2446 ~ 7%     +35.7%       3319 ~ 6%  grantley/micro/aim7/disk_src
      4436 ~ 3%     +81.9%       8072 ~ 6%  grantley/micro/aim7/shell_rtns_1
      6883 ~ 4%     +65.5%      11392 ~ 6%  TOTAL sched_debug.cpu#11.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     60599 ~24%     +38.1%      83676 ~ 2%  grantley/micro/aim7/disk_src
     69388 ~23%     +26.2%      87539 ~14%  grantley/micro/aim7/shell_rtns_1
    129987 ~24%     +31.7%     171216 ~ 8%  TOTAL numa-meminfo.node1.SUnreclaim

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2015 ~ 8%     +34.3%       2707 ~ 7%  grantley/micro/aim7/disk_src
      4113 ~ 3%     +82.1%       7489 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6129 ~ 5%     +66.4%      10197 ~ 2%  TOTAL sched_debug.cpu#52.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2458 ~ 7%     +35.5%       3331 ~ 7%  grantley/micro/aim7/disk_src
      4450 ~ 3%     +78.8%       7956 ~ 1%  grantley/micro/aim7/shell_rtns_1
      6908 ~ 4%     +63.4%      11287 ~ 3%  TOTAL sched_debug.cpu#10.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15140 ~24%     +38.1%      20903 ~ 2%  grantley/micro/aim7/disk_src
     17341 ~23%     +26.2%      21878 ~14%  grantley/micro/aim7/shell_rtns_1
     32482 ~24%     +31.7%      42781 ~ 8%  TOTAL numa-vmstat.node1.nr_slab_unreclaimable

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1987 ~ 9%     +36.0%       2702 ~ 6%  grantley/micro/aim7/disk_src
      4104 ~ 3%     +82.1%       7476 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6092 ~ 5%     +67.1%      10178 ~ 2%  TOTAL sched_debug.cpu#53.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4944 ~26%     +77.2%       8761 ~11%  grantley/micro/aim7/disk_src
     42872 ~ 4%     +15.6%      49573 ~ 3%  grantley/micro/aim7/shell_rtns_1
     47816 ~ 6%     +22.0%      58334 ~ 4%  TOTAL sched_debug.cpu#23.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2051 ~ 8%     +34.0%       2748 ~ 9%  grantley/micro/aim7/disk_src
      4176 ~ 3%     +81.7%       7589 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6228 ~ 5%     +66.0%      10337 ~ 2%  TOTAL sched_debug.cpu#42.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     44749 ~ 3%     +24.7%      55808 ~ 4%  grantley/micro/aim7/shell_rtns_1
     44749 ~ 3%     +24.7%      55808 ~ 4%  TOTAL sched_debug.cfs_rq[2]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2144 ~ 8%     +32.1%       2832 ~ 8%  grantley/micro/aim7/disk_src
      4253 ~ 3%     +80.7%       7686 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6397 ~ 5%     +64.4%      10519 ~ 2%  TOTAL sched_debug.cpu#36.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2255 ~ 7%     +31.6%       2968 ~ 6%  grantley/micro/aim7/disk_src
      4355 ~ 3%     +77.9%       7748 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6610 ~ 4%     +62.1%      10716 ~ 1%  TOTAL sched_debug.cpu#44.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2068 ~ 7%     +31.8%       2726 ~ 7%  grantley/micro/aim7/disk_src
      4123 ~ 3%     +81.9%       7498 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6191 ~ 4%     +65.1%      10224 ~ 2%  TOTAL sched_debug.cpu#51.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2695 ~16%     +25.3%       3377 ~ 5%  grantley/micro/aim7/disk_src
      4614 ~ 5%     +75.8%       8111 ~ 4%  grantley/micro/aim7/shell_rtns_1
      7309 ~ 9%     +57.2%      11488 ~ 4%  TOTAL sched_debug.cpu#14.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2448 ~ 8%     +36.8%       3349 ~ 7%  grantley/micro/aim7/disk_src
      4532 ~ 5%     +72.6%       7824 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6980 ~ 6%     +60.1%      11173 ~ 2%  TOTAL sched_debug.cpu#12.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1980 ~ 9%     +34.4%       2661 ~ 6%  grantley/micro/aim7/disk_src
      4094 ~ 3%     +82.0%       7452 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6074 ~ 5%     +66.5%      10114 ~ 2%  TOTAL sched_debug.cpu#55.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1987 ~ 9%     +34.7%       2678 ~ 7%  grantley/micro/aim7/disk_src
      4097 ~ 3%     +82.2%       7463 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6084 ~ 5%     +66.7%      10142 ~ 2%  TOTAL sched_debug.cpu#54.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2051 ~ 9%     +33.6%       2741 ~ 7%  grantley/micro/aim7/disk_src
      4179 ~ 4%     +79.9%       7519 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6231 ~ 6%     +64.6%      10260 ~ 2%  TOTAL sched_debug.cpu#49.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3238 ~25%     +66.6%       5397 ~24%  grantley/micro/aim7/disk_src
     39772 ~ 2%     +17.7%      46810 ~ 4%  grantley/micro/aim7/shell_rtns_1
     43011 ~ 4%     +21.4%      52208 ~ 6%  TOTAL sched_debug.cpu#41.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2028 ~ 9%     +33.7%       2712 ~ 7%  grantley/micro/aim7/disk_src
      4144 ~ 3%     +81.2%       7508 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6173 ~ 5%     +65.6%      10221 ~ 2%  TOTAL sched_debug.cpu#50.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2083 ~ 8%     +30.8%       2725 ~ 9%  grantley/micro/aim7/disk_src
      4188 ~ 3%     +81.4%       7597 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6272 ~ 4%     +64.6%      10323 ~ 2%  TOTAL sched_debug.cpu#41.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2093 ~ 8%     +32.0%       2764 ~ 8%  grantley/micro/aim7/disk_src
      4201 ~ 3%     +80.9%       7599 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6294 ~ 4%     +64.6%      10363 ~ 2%  TOTAL sched_debug.cpu#40.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8009 ~49%     +83.1%      14667 ~ 8%  grantley/micro/aim7/disk_src
     45557 ~10%     +27.4%      58038 ~ 6%  grantley/micro/aim7/shell_rtns_1
     53566 ~16%     +35.7%      72705 ~ 6%  TOTAL sched_debug.cpu#30.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2346 ~ 9%     +35.6%       3182 ~ 6%  grantley/micro/aim7/disk_src
      4374 ~ 4%     +74.7%       7641 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6720 ~ 6%     +61.1%      10824 ~ 2%  TOTAL sched_debug.cpu#26.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2446 ~ 7%     +32.1%       3231 ~ 7%  grantley/micro/aim7/disk_src
      4336 ~ 3%     +75.9%       7629 ~ 1%  grantley/micro/aim7/shell_rtns_1
      6782 ~ 4%     +60.1%      10860 ~ 3%  TOTAL sched_debug.cpu#23.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2472 ~ 7%     +35.3%       3343 ~ 5%  grantley/micro/aim7/disk_src
      4466 ~ 3%     +78.1%       7952 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6938 ~ 4%     +62.8%      11296 ~ 2%  TOTAL sched_debug.cpu#9.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2075 ~ 9%     +33.8%       2777 ~ 6%  grantley/micro/aim7/disk_src
      4206 ~ 2%     +79.7%       7557 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6281 ~ 4%     +64.5%      10335 ~ 2%  TOTAL sched_debug.cpu#48.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       905 ~24%    +104.1%       1847 ~13%  grantley/micro/aim7/disk_src
     54948 ~ 3%     +23.7%      67989 ~ 1%  grantley/micro/aim7/shell_rtns_1
     55853 ~ 3%     +25.0%      69836 ~ 1%  TOTAL sched_debug.cfs_rq[52]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2335 ~ 7%     +35.1%       3156 ~ 6%  grantley/micro/aim7/disk_src
      4377 ~ 4%     +74.5%       7638 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6713 ~ 5%     +60.8%      10795 ~ 2%  TOTAL sched_debug.cpu#27.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     52226 ~21%     -19.4%      42104 ~11%  grantley/micro/aim7/disk_src
    565725 ~ 1%     -41.6%     330427 ~ 0%  grantley/micro/aim7/shell_rtns_1
    617951 ~ 2%     -39.7%     372531 ~ 1%  TOTAL sched_debug.cfs_rq[31]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     51420 ~20%     -18.9%      41718 ~11%  grantley/micro/aim7/disk_src
    548811 ~ 1%     -41.7%     320062 ~ 0%  grantley/micro/aim7/shell_rtns_1
    600231 ~ 2%     -39.7%     361781 ~ 1%  TOTAL sched_debug.cfs_rq[39]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2163 ~ 8%     +30.6%       2826 ~ 8%  grantley/micro/aim7/disk_src
      4284 ~ 3%     +79.1%       7673 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6448 ~ 5%     +62.8%      10499 ~ 2%  TOTAL sched_debug.cpu#35.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2369 ~12%     +33.5%       3163 ~ 6%  grantley/micro/aim7/disk_src
      4472 ~ 4%     +70.5%       7626 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6841 ~ 7%     +57.7%      10789 ~ 2%  TOTAL sched_debug.cpu#28.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     52371 ~21%     -19.0%      42429 ~11%  grantley/micro/aim7/disk_src
    568037 ~ 1%     -41.5%     332170 ~ 0%  grantley/micro/aim7/shell_rtns_1
    620408 ~ 2%     -39.6%     374600 ~ 1%  TOTAL sched_debug.cfs_rq[30]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2101 ~ 8%     +31.8%       2769 ~ 9%  grantley/micro/aim7/disk_src
      4212 ~ 3%     +80.8%       7617 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6313 ~ 5%     +64.5%      10387 ~ 2%  TOTAL sched_debug.cpu#39.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3523 ~27%     +56.0%       5496 ~22%  grantley/micro/aim7/disk_src
     41026 ~ 2%     +18.0%      48422 ~ 4%  grantley/micro/aim7/shell_rtns_1
     44549 ~ 4%     +21.0%      53918 ~ 6%  TOTAL sched_debug.cpu#38.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
   3464361 ~30%     -45.9%    1875624 ~35%  lkp-sbx04/micro/will-it-scale/page_fault1
   3464361 ~30%     -45.9%    1875624 ~35%  TOTAL cpuidle.C1E-SNB.time

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4711 ~27%     +83.7%       8656 ~17%  grantley/micro/aim7/disk_src
     41625 ~ 2%     +16.7%      48587 ~ 4%  grantley/micro/aim7/shell_rtns_1
     46337 ~ 5%     +23.5%      57243 ~ 6%  TOTAL sched_debug.cpu#12.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2398 ~ 7%     +33.1%       3192 ~ 6%  grantley/micro/aim7/disk_src
      4378 ~ 4%     +74.8%       7651 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6776 ~ 5%     +60.0%      10844 ~ 2%  TOTAL sched_debug.cpu#25.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     51460 ~20%     -18.8%      41791 ~11%  grantley/micro/aim7/disk_src
    550817 ~ 1%     -41.7%     321207 ~ 0%  grantley/micro/aim7/shell_rtns_1
    602277 ~ 2%     -39.7%     362998 ~ 1%  TOTAL sched_debug.cfs_rq[38]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     51612 ~20%     -18.7%      41964 ~12%  grantley/micro/aim7/disk_src
    553079 ~ 1%     -41.7%     322566 ~ 0%  grantley/micro/aim7/shell_rtns_1
    604691 ~ 2%     -39.7%     364530 ~ 1%  TOTAL sched_debug.cfs_rq[37]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4661 ~24%     +87.6%       8745 ~10%  grantley/micro/aim7/disk_src
     41220 ~ 3%     +18.1%      48682 ~ 4%  grantley/micro/aim7/shell_rtns_1
     45881 ~ 5%     +25.2%      57428 ~ 5%  TOTAL sched_debug.cpu#13.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     51570 ~20%     -18.7%      41951 ~12%  grantley/micro/aim7/disk_src
    555218 ~ 1%     -41.7%     323608 ~ 0%  grantley/micro/aim7/shell_rtns_1
    606789 ~ 2%     -39.8%     365559 ~ 1%  TOTAL sched_debug.cfs_rq[36]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2678 ~11%     +30.6%       3497 ~ 7%  grantley/micro/aim7/disk_src
      4634 ~ 5%     +75.1%       8113 ~ 2%  grantley/micro/aim7/shell_rtns_1
      7312 ~ 7%     +58.8%      11610 ~ 3%  TOTAL sched_debug.cpu#6.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     51860 ~21%     -19.2%      41923 ~11%  grantley/micro/aim7/disk_src
    558852 ~ 1%     -41.6%     326434 ~ 0%  grantley/micro/aim7/shell_rtns_1
    610713 ~ 2%     -39.7%     368358 ~ 2%  TOTAL sched_debug.cfs_rq[34]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2215 ~ 9%     +28.1%       2838 ~ 8%  grantley/micro/aim7/disk_src
      4303 ~ 3%     +80.0%       7744 ~ 1%  grantley/micro/aim7/shell_rtns_1
      6519 ~ 5%     +62.3%      10582 ~ 3%  TOTAL sched_debug.cpu#34.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2426 ~ 8%     +36.3%       3306 ~ 7%  grantley/micro/aim7/disk_src
      4412 ~ 3%     +73.5%       7653 ~ 2%  grantley/micro/aim7/shell_rtns_1
      6838 ~ 4%     +60.3%      10959 ~ 3%  TOTAL sched_debug.cpu#22.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     51595 ~20%     -18.7%      41950 ~12%  grantley/micro/aim7/disk_src
    557039 ~ 1%     -41.7%     324956 ~ 0%  grantley/micro/aim7/shell_rtns_1
    608635 ~ 2%     -39.7%     366907 ~ 1%  TOTAL sched_debug.cfs_rq[35]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2315 ~31%     +20.5%       2789 ~ 6%  grantley/micro/aim7/disk_src
      4271 ~ 3%     +78.9%       7641 ~ 1%  grantley/micro/aim7/shell_rtns_1
      6587 ~13%     +58.4%      10431 ~ 2%  TOTAL sched_debug.cpu#47.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     50277 ~19%     -18.4%      41009 ~10%  grantley/micro/aim7/disk_src
    531503 ~ 1%     -41.9%     309068 ~ 0%  grantley/micro/aim7/shell_rtns_1
    581781 ~ 3%     -39.8%     350077 ~ 1%  TOTAL sched_debug.cfs_rq[48]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     51900 ~21%     -19.1%      42011 ~11%  grantley/micro/aim7/disk_src
    561365 ~ 1%     -41.7%     327391 ~ 0%  grantley/micro/aim7/shell_rtns_1
    613265 ~ 2%     -39.8%     369402 ~ 1%  TOTAL sched_debug.cfs_rq[33]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     51270 ~20%     -18.8%      41635 ~11%  grantley/micro/aim7/disk_src
    546860 ~ 1%     -41.7%     318968 ~ 0%  grantley/micro/aim7/shell_rtns_1
    598131 ~ 2%     -39.7%     360603 ~ 1%  TOTAL sched_debug.cfs_rq[40]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2523 ~ 9%     +29.3%       3263 ~ 9%  grantley/micro/aim7/disk_src
      4348 ~ 3%     +77.5%       7716 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6871 ~ 5%     +59.8%      10980 ~ 3%  TOTAL sched_debug.cpu#24.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     51924 ~21%     -19.1%      42020 ~12%  grantley/micro/aim7/disk_src
    563463 ~ 1%     -41.6%     329268 ~ 0%  grantley/micro/aim7/shell_rtns_1
    615387 ~ 2%     -39.7%     371288 ~ 1%  TOTAL sched_debug.cfs_rq[32]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2507 ~11%     +33.3%       3342 ~ 6%  grantley/micro/aim7/disk_src
      4762 ~14%     +63.6%       7791 ~ 1%  grantley/micro/aim7/shell_rtns_1
      7269 ~13%     +53.2%      11134 ~ 3%  TOTAL sched_debug.cpu#20.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     50488 ~20%     -18.6%      41098 ~10%  grantley/micro/aim7/disk_src
    532999 ~ 1%     -41.8%     310065 ~ 0%  grantley/micro/aim7/shell_rtns_1
    583488 ~ 3%     -39.8%     351164 ~ 1%  TOTAL sched_debug.cfs_rq[47]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4823 ~23%     +78.9%       8630 ~10%  grantley/micro/aim7/disk_src
     41460 ~ 3%     +18.7%      49201 ~ 3%  grantley/micro/aim7/shell_rtns_1
     46284 ~ 5%     +25.0%      57832 ~ 4%  TOTAL sched_debug.cpu#25.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     51267 ~20%     -19.0%      41525 ~11%  grantley/micro/aim7/disk_src
    543310 ~ 1%     -41.8%     316166 ~ 0%  grantley/micro/aim7/shell_rtns_1
    594577 ~ 3%     -39.8%     357691 ~ 1%  TOTAL sched_debug.cfs_rq[42]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     51267 ~20%     -19.0%      41524 ~11%  grantley/micro/aim7/disk_src
    545325 ~ 1%     -41.7%     317660 ~ 0%  grantley/micro/aim7/shell_rtns_1
    596592 ~ 2%     -39.8%     359184 ~ 1%  TOTAL sched_debug.cfs_rq[41]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     50682 ~20%     -18.6%      41280 ~10%  grantley/micro/aim7/disk_src
    534974 ~ 1%     -41.8%     311436 ~ 0%  grantley/micro/aim7/shell_rtns_1
    585656 ~ 3%     -39.8%     352716 ~ 1%  TOTAL sched_debug.cfs_rq[46]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2276 ~ 9%     +28.5%       2924 ~ 8%  grantley/micro/aim7/disk_src
      4349 ~ 3%     +80.3%       7843 ~ 2%  grantley/micro/aim7/shell_rtns_1
      6625 ~ 5%     +62.5%      10767 ~ 3%  TOTAL sched_debug.cpu#32.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      6218 ~34%     +77.1%      11015 ~13%  grantley/micro/aim7/disk_src
     44197 ~ 4%     +21.4%      53654 ~ 5%  grantley/micro/aim7/shell_rtns_1
     50415 ~ 8%     +28.3%      64669 ~ 6%  TOTAL sched_debug.cpu#19.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2741 ~ 8%     +41.6%       3882 ~15%  grantley/micro/aim7/disk_src
      5065 ~13%     +64.6%       8336 ~ 7%  grantley/micro/aim7/shell_rtns_1
      7806 ~11%     +56.5%      12218 ~10%  TOTAL sched_debug.cpu#18.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     52566 ~21%     -18.1%      43045 ~11%  grantley/micro/aim7/disk_src
    570627 ~ 1%     -41.5%     334065 ~ 0%  grantley/micro/aim7/shell_rtns_1
    623194 ~ 2%     -39.5%     377111 ~ 1%  TOTAL sched_debug.cfs_rq[29]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     50700 ~20%     -18.5%      41328 ~11%  grantley/micro/aim7/disk_src
    539290 ~ 1%     -41.9%     313562 ~ 0%  grantley/micro/aim7/shell_rtns_1
    589991 ~ 2%     -39.8%     354890 ~ 1%  TOTAL sched_debug.cfs_rq[44]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     50694 ~20%     -18.5%      41307 ~10%  grantley/micro/aim7/disk_src
    537139 ~ 1%     -41.9%     312253 ~ 0%  grantley/micro/aim7/shell_rtns_1
    587833 ~ 2%     -39.9%     353560 ~ 1%  TOTAL sched_debug.cfs_rq[45]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2187 ~11%     +29.4%       2829 ~ 8%  grantley/micro/aim7/disk_src
      4266 ~ 3%     +78.8%       7630 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6454 ~ 6%     +62.1%      10459 ~ 2%  TOTAL sched_debug.cpu#46.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     35245 ~15%     +36.0%      47948 ~ 4%  grantley/micro/aim7/shell_rtns_1
     35245 ~15%     +36.0%      47948 ~ 4%  TOTAL sched_debug.cpu#32.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     50117 ~19%     -18.1%      41042 ~10%  grantley/micro/aim7/disk_src
    527965 ~ 1%     -41.8%     307115 ~ 0%  grantley/micro/aim7/shell_rtns_1
    578082 ~ 3%     -39.8%     348157 ~ 1%  TOTAL sched_debug.cfs_rq[50]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     50234 ~19%     -18.4%      40997 ~10%  grantley/micro/aim7/disk_src
    529979 ~ 1%     -41.9%     308163 ~ 0%  grantley/micro/aim7/shell_rtns_1
    580213 ~ 3%     -39.8%     349160 ~ 1%  TOTAL sched_debug.cfs_rq[49]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     50938 ~20%     -18.6%      41470 ~11%  grantley/micro/aim7/disk_src
    541043 ~ 1%     -41.8%     314722 ~ 0%  grantley/micro/aim7/shell_rtns_1
    591982 ~ 2%     -39.8%     356193 ~ 1%  TOTAL sched_debug.cfs_rq[43]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     49942 ~20%     -18.0%      40975 ~10%  grantley/micro/aim7/disk_src
    524509 ~ 1%     -41.8%     305249 ~ 0%  grantley/micro/aim7/shell_rtns_1
    574452 ~ 3%     -39.7%     346224 ~ 1%  TOTAL sched_debug.cfs_rq[52]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      5117 ~23%     +75.6%       8985 ~20%  grantley/micro/aim7/disk_src
     42834 ~ 4%     +17.2%      50211 ~ 3%  grantley/micro/aim7/shell_rtns_1
     47951 ~ 6%     +23.5%      59197 ~ 6%  TOTAL sched_debug.cpu#8.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     50123 ~19%     -18.3%      40968 ~10%  grantley/micro/aim7/disk_src
    526206 ~ 1%     -41.9%     305829 ~ 0%  grantley/micro/aim7/shell_rtns_1
    576330 ~ 3%     -39.8%     346798 ~ 1%  TOTAL sched_debug.cfs_rq[51]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2639 ~ 9%     +42.4%       3757 ~18%  grantley/micro/aim7/disk_src
      4743 ~ 7%     +74.8%       8290 ~ 8%  grantley/micro/aim7/shell_rtns_1
      7382 ~ 8%     +63.2%      12048 ~11%  TOTAL sched_debug.cpu#19.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     52525 ~21%     -18.0%      43069 ~11%  grantley/micro/aim7/disk_src
    573084 ~ 1%     -41.4%     336056 ~ 0%  grantley/micro/aim7/shell_rtns_1
    625609 ~ 2%     -39.4%     379125 ~ 1%  TOTAL sched_debug.cfs_rq[28]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2447 ~ 8%     +32.8%       3250 ~ 5%  grantley/micro/aim7/disk_src
      4524 ~ 2%     +70.6%       7719 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6971 ~ 4%     +57.3%      10969 ~ 2%  TOTAL sched_debug.cpu#21.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     49896 ~20%     -17.9%      40964 ~10%  grantley/micro/aim7/disk_src
    523029 ~ 1%     -41.8%     304456 ~ 0%  grantley/micro/aim7/shell_rtns_1
    572925 ~ 3%     -39.7%     345420 ~ 1%  TOTAL sched_debug.cfs_rq[53]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     49804 ~20%     -17.7%      41011 ~10%  grantley/micro/aim7/disk_src
    521266 ~ 1%     -41.7%     303973 ~ 0%  grantley/micro/aim7/shell_rtns_1
    571071 ~ 3%     -39.6%     344984 ~ 1%  TOTAL sched_debug.cfs_rq[54]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2369 ~11%     +32.0%       3128 ~ 8%  grantley/micro/aim7/disk_src
      4482 ~ 5%     +77.0%       7933 ~ 1%  grantley/micro/aim7/shell_rtns_1
      6852 ~ 7%     +61.4%      11061 ~ 3%  TOTAL sched_debug.cpu#31.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       145 ~43%     +76.2%        256 ~20%  grantley/micro/aim7/disk_src
       533 ~10%     +19.3%        637 ~ 7%  grantley/micro/aim7/shell_rtns_1
       679 ~17%     +31.5%        893 ~11%  TOTAL sched_debug.cpu#30.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     49749 ~19%     -17.6%      40977 ~10%  grantley/micro/aim7/disk_src
    519677 ~ 1%     -41.6%     303361 ~ 0%  grantley/micro/aim7/shell_rtns_1
    569426 ~ 3%     -39.5%     344339 ~ 1%  TOTAL sched_debug.cfs_rq[55]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     53433 ~22%     -18.5%      43536 ~12%  grantley/micro/aim7/disk_src
    591976 ~ 1%     -41.1%     348942 ~ 0%  grantley/micro/aim7/shell_rtns_1
    645409 ~ 2%     -39.2%     392478 ~ 2%  TOTAL sched_debug.cfs_rq[21]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     52538 ~21%     -18.0%      43094 ~11%  grantley/micro/aim7/disk_src
    575237 ~ 1%     -41.3%     337748 ~ 0%  grantley/micro/aim7/shell_rtns_1
    627776 ~ 2%     -39.3%     380842 ~ 1%  TOTAL sched_debug.cfs_rq[27]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     52499 ~21%     -17.9%      43102 ~11%  grantley/micro/aim7/disk_src
    578125 ~ 1%     -41.3%     339143 ~ 0%  grantley/micro/aim7/shell_rtns_1
    630624 ~ 2%     -39.4%     382245 ~ 1%  TOTAL sched_debug.cfs_rq[26]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2825 ~ 8%     +21.5%       3432 ~ 6%  grantley/micro/aim7/disk_src
      4773 ~ 4%     +67.4%       7991 ~ 1%  grantley/micro/aim7/shell_rtns_1
      7598 ~ 6%     +50.3%      11424 ~ 2%  TOTAL sched_debug.cpu#2.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     53416 ~22%     -18.4%      43594 ~12%  grantley/micro/aim7/disk_src
    594714 ~ 1%     -41.0%     351061 ~ 0%  grantley/micro/aim7/shell_rtns_1
    648130 ~ 2%     -39.1%     394656 ~ 1%  TOTAL sched_debug.cfs_rq[20]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     53902 ~23%     -18.9%      43721 ~12%  grantley/micro/aim7/disk_src
    603344 ~ 1%     -40.8%     357185 ~ 0%  grantley/micro/aim7/shell_rtns_1
    657246 ~ 3%     -39.0%     400906 ~ 1%  TOTAL sched_debug.cfs_rq[17]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     54015 ~23%     -19.2%      43642 ~12%  grantley/micro/aim7/disk_src
    606307 ~ 1%     -40.7%     359681 ~ 0%  grantley/micro/aim7/shell_rtns_1
    660323 ~ 3%     -38.9%     403324 ~ 1%  TOTAL sched_debug.cfs_rq[16]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    118109 ~10%     +27.7%     150878 ~ 7%  grantley/micro/aim7/disk_src
    226808 ~ 2%     +72.7%     391613 ~ 0%  grantley/micro/aim7/shell_rtns_1
    344918 ~ 5%     +57.3%     542491 ~ 2%  TOTAL softirqs.TIMER

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     53611 ~22%     -18.6%      43637 ~11%  grantley/micro/aim7/disk_src
    597435 ~ 1%     -40.9%     353159 ~ 0%  grantley/micro/aim7/shell_rtns_1
    651046 ~ 3%     -39.1%     396797 ~ 1%  TOTAL sched_debug.cfs_rq[19]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4596 ~25%     +81.9%       8360 ~13%  grantley/micro/aim7/disk_src
     42432 ~ 2%     +17.6%      49911 ~ 4%  grantley/micro/aim7/shell_rtns_1
     47029 ~ 5%     +23.9%      58272 ~ 5%  TOTAL sched_debug.cpu#10.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     53580 ~22%     -18.6%      43598 ~11%  grantley/micro/aim7/disk_src
    600384 ~ 1%     -40.8%     355440 ~ 0%  grantley/micro/aim7/shell_rtns_1
    653965 ~ 3%     -39.0%     399039 ~ 1%  TOTAL sched_debug.cfs_rq[18]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2371 ~10%     +31.9%       3128 ~ 9%  grantley/micro/aim7/disk_src
      4412 ~ 4%     +72.3%       7601 ~ 0%  grantley/micro/aim7/shell_rtns_1
      6783 ~ 6%     +58.2%      10729 ~ 3%  TOTAL sched_debug.cpu#0.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     54185 ~23%     -19.6%      43580 ~12%  grantley/micro/aim7/disk_src
    608940 ~ 1%     -40.6%     361659 ~ 0%  grantley/micro/aim7/shell_rtns_1
    663126 ~ 3%     -38.9%     405239 ~ 1%  TOTAL sched_debug.cfs_rq[15]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2509 ~ 7%     +33.9%       3359 ~ 8%  grantley/micro/aim7/disk_src
      4621 ~ 5%     +68.0%       7765 ~ 0%  grantley/micro/aim7/shell_rtns_1
      7130 ~ 6%     +56.0%      11124 ~ 2%  TOTAL sched_debug.cpu#15.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      6519 ~21%     +50.2%       9791 ~10%  grantley/micro/aim7/disk_src
     50250 ~ 3%     +21.0%      60806 ~ 1%  grantley/micro/aim7/shell_rtns_1
     56770 ~ 5%     +24.4%      70597 ~ 2%  TOTAL sched_debug.cfs_rq[0]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     55153 ~25%     -20.3%      43982 ~12%  grantley/micro/aim7/disk_src
    634828 ~ 1%     -39.7%     382754 ~ 0%  grantley/micro/aim7/shell_rtns_1
    689981 ~ 3%     -38.2%     426737 ~ 1%  TOTAL sched_debug.cfs_rq[7]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3598 ~26%     +65.5%       5955 ~21%  grantley/micro/aim7/disk_src
     41761 ~ 3%     +17.3%      49001 ~ 4%  grantley/micro/aim7/shell_rtns_1
     45359 ~ 5%     +21.2%      54956 ~ 5%  TOTAL sched_debug.cpu#35.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3208 ~33%     +89.6%       6083 ~16%  grantley/micro/aim7/disk_src
     39931 ~ 2%     +17.2%      46781 ~ 2%  grantley/micro/aim7/shell_rtns_1
     43139 ~ 5%     +22.5%      52865 ~ 4%  TOTAL sched_debug.cpu#53.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     47077 ~ 5%     -40.7%      27911 ~ 4%  grantley/micro/aim7/shell_rtns_1
      1468 ~25%     -34.8%        956 ~ 8%  lkp-sb03/micro/netperf/120s-200%-SCTP_STREAM
      4234 ~46%     -45.7%       2300 ~ 5%  lkp-sbx04/micro/will-it-scale/page_fault1
     52780 ~ 9%     -40.9%      31168 ~ 4%  TOTAL proc-vmstat.nr_tlb_remote_flush_received

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    181564 ~29%     +49.1%     270775 ~16%  grantley/micro/aim7/disk_src
    300510 ~ 0%     -28.8%     214044 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
    482075 ~11%      +0.6%     484819 ~ 9%  TOTAL interrupts.RES

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     55058 ~24%     -20.0%      44045 ~12%  grantley/micro/aim7/disk_src
    631564 ~ 1%     -39.8%     380196 ~ 0%  grantley/micro/aim7/shell_rtns_1
    686622 ~ 3%     -38.2%     424242 ~ 1%  TOTAL sched_debug.cfs_rq[8]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     54902 ~24%     -19.7%      44088 ~12%  grantley/micro/aim7/disk_src
    628297 ~ 1%     -40.1%     376661 ~ 0%  grantley/micro/aim7/shell_rtns_1
    683200 ~ 3%     -38.4%     420750 ~ 1%  TOTAL sched_debug.cfs_rq[9]:/.tg_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4098 ~22%     +48.4%       6083 ~21%  grantley/micro/aim7/disk_src
     41612 ~ 2%     +17.7%      48995 ~ 4%  grantley/micro/aim7/shell_rtns_1
     45710 ~ 4%     +20.5%      55079 ~ 6%  TOTAL sched_debug.cpu#34.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      7778 ~25%     +44.1%      11211 ~11%  grantley/micro/aim7/disk_src
      7778 ~25%     +44.1%      11211 ~11%  TOTAL sched_debug.cpu#1.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
        71 ~38%     +57.6%        112 ~27%  grantley/micro/aim7/disk_src
       372 ~17%     +21.8%        454 ~ 7%  grantley/micro/aim7/shell_rtns_1
       443 ~21%     +27.6%        566 ~11%  TOTAL sched_debug.cfs_rq[15]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3329 ~20%     +57.6%       5247 ~23%  grantley/micro/aim7/disk_src
     41350 ~ 3%     +17.4%      48525 ~ 4%  grantley/micro/aim7/shell_rtns_1
     44679 ~ 4%     +20.4%      53772 ~ 6%  TOTAL sched_debug.cpu#37.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      5557 ~26%     +64.1%       9121 ~14%  grantley/micro/aim7/disk_src
     43273 ~ 4%     +18.2%      51140 ~ 4%  grantley/micro/aim7/shell_rtns_1
     48831 ~ 7%     +23.4%      60261 ~ 6%  TOTAL sched_debug.cpu#6.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4323 ~26%     +93.4%       8362 ~13%  grantley/micro/aim7/disk_src
     41508 ~ 2%     +15.7%      48033 ~ 2%  grantley/micro/aim7/shell_rtns_1
     45832 ~ 4%     +23.0%      56396 ~ 4%  TOTAL sched_debug.cpu#27.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      5208 ~48%     +61.0%       8384 ~17%  grantley/micro/aim7/disk_src
     42168 ~ 5%     +13.6%      47885 ~ 4%  grantley/micro/aim7/shell_rtns_1
     47377 ~10%     +18.8%      56269 ~ 6%  TOTAL sched_debug.cpu#28.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3357 ~28%     +70.0%       5706 ~19%  grantley/micro/aim7/disk_src
     41107 ~ 2%     +16.1%      47746 ~ 3%  grantley/micro/aim7/shell_rtns_1
     44464 ~ 4%     +20.2%      53452 ~ 5%  TOTAL sched_debug.cpu#52.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      5327 ~27%     +66.2%       8855 ~15%  grantley/micro/aim7/disk_src
     43058 ~ 5%     +19.3%      51354 ~ 3%  grantley/micro/aim7/shell_rtns_1
     48386 ~ 7%     +24.4%      60209 ~ 5%  TOTAL sched_debug.cpu#7.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
 1.288e+10 ~ 0%     -30.6%  8.942e+09 ~ 1%  lkp-sbx04/micro/will-it-scale/page_fault1
 1.288e+10 ~ 0%     -30.6%  8.942e+09 ~ 1%  TOTAL cpuidle.C7-SNB.time

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3354 ~30%     +71.6%       5755 ~16%  grantley/micro/aim7/disk_src
     39821 ~ 2%     +16.3%      46329 ~ 3%  grantley/micro/aim7/shell_rtns_1
     43176 ~ 4%     +20.6%      52085 ~ 4%  TOTAL sched_debug.cpu#54.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3843 ~31%     +64.8%       6332 ~16%  grantley/micro/aim7/disk_src
     41542 ~ 2%     +17.5%      48820 ~ 3%  grantley/micro/aim7/shell_rtns_1
     45385 ~ 5%     +21.5%      55153 ~ 5%  TOTAL sched_debug.cpu#48.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      5207 ~26%     +65.4%       8613 ~16%  grantley/micro/aim7/disk_src
     42345 ~ 3%     +16.3%      49256 ~ 4%  grantley/micro/aim7/shell_rtns_1
     47552 ~ 5%     +21.7%      57869 ~ 6%  TOTAL sched_debug.cpu#24.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      6925 ~30%     +61.1%      11155 ~15%  grantley/micro/aim7/disk_src
     43658 ~ 2%     +21.6%      53093 ~ 5%  grantley/micro/aim7/shell_rtns_1
     50583 ~ 6%     +27.0%      64248 ~ 7%  TOTAL sched_debug.cpu#5.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3024 ~15%     +17.8%       3560 ~ 5%  grantley/micro/aim7/disk_src
      5100 ~ 8%     +64.2%       8374 ~ 0%  grantley/micro/aim7/shell_rtns_1
      8124 ~11%     +46.9%      11935 ~ 2%  TOTAL sched_debug.cpu#43.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       105 ~37%     +42.2%        149 ~13%  grantley/micro/aim7/disk_src
       105 ~37%     +42.2%        149 ~13%  TOTAL sched_debug.cpu#15.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4393 ~27%     +74.7%       7675 ~19%  grantley/micro/aim7/disk_src
     42235 ~ 2%     +19.1%      50291 ~ 4%  grantley/micro/aim7/shell_rtns_1
     46628 ~ 5%     +24.3%      57967 ~ 6%  TOTAL sched_debug.cpu#45.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3519 ~31%     +72.5%       6070 ~12%  grantley/micro/aim7/disk_src
     41599 ~ 3%     +15.6%      48074 ~ 3%  grantley/micro/aim7/shell_rtns_1
     45119 ~ 5%     +20.0%      54144 ~ 4%  TOTAL sched_debug.cpu#51.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      6932 ~25%     +76.7%      12250 ~15%  grantley/micro/aim7/disk_src
     45886 ~ 4%     +18.3%      54267 ~ 4%  grantley/micro/aim7/shell_rtns_1
     52818 ~ 7%     +25.9%      66518 ~ 6%  TOTAL sched_debug.cpu#18.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      5230 ~29%     +78.5%       9333 ~19%  grantley/micro/aim7/disk_src
     43192 ~ 5%     +15.5%      49866 ~ 4%  grantley/micro/aim7/shell_rtns_1
     48422 ~ 7%     +22.3%      59199 ~ 6%  TOTAL sched_debug.cpu#21.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4563 ~24%     +42.7%       6511 ~14%  grantley/micro/aim7/disk_src
     42013 ~ 2%     +17.7%      49467 ~ 3%  grantley/micro/aim7/shell_rtns_1
     46576 ~ 4%     +20.2%      55979 ~ 4%  TOTAL sched_debug.cpu#32.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1907 ~41%     +55.4%       2963 ~ 6%  grantley/micro/aim7/disk_src
     43782 ~ 2%     +29.3%      56612 ~ 1%  grantley/micro/aim7/shell_rtns_1
     45689 ~ 4%     +30.4%      59575 ~ 1%  TOTAL sched_debug.cfs_rq[18]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4523 ~25%     +88.3%       8515 ~13%  grantley/micro/aim7/disk_src
     41354 ~ 3%     +21.2%      50125 ~ 5%  grantley/micro/aim7/shell_rtns_1
     45877 ~ 5%     +27.8%      58641 ~ 6%  TOTAL sched_debug.cpu#11.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       128 ~38%     +60.8%        206 ~21%  grantley/micro/aim7/disk_src
       545 ~ 8%     +19.2%        649 ~ 4%  grantley/micro/aim7/shell_rtns_1
       673 ~13%     +27.1%        855 ~ 8%  TOTAL sched_debug.cpu#30.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     41905 ~ 3%     +17.1%      49059 ~ 5%  grantley/micro/aim7/shell_rtns_1
     41905 ~ 3%     +17.1%      49059 ~ 5%  TOTAL sched_debug.cpu#47.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      5191 ~26%     +64.6%       8543 ~17%  grantley/micro/aim7/disk_src
     42708 ~ 4%     +16.8%      49872 ~ 3%  grantley/micro/aim7/shell_rtns_1
     47900 ~ 6%     +22.0%      58415 ~ 5%  TOTAL sched_debug.cpu#22.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3232 ~34%     +82.3%       5892 ~18%  grantley/micro/aim7/disk_src
     39946 ~ 2%     +15.6%      46166 ~ 3%  grantley/micro/aim7/shell_rtns_1
     43179 ~ 4%     +20.6%      52058 ~ 5%  TOTAL sched_debug.cpu#55.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     27425 ~20%     +41.3%      38751 ~ 8%  grantley/micro/aim7/shell_rtns_1
     27425 ~20%     +41.3%      38751 ~ 8%  TOTAL sched_debug.cpu#7.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       483 ~15%     +32.8%        642 ~11%  grantley/micro/aim7/shell_rtns_1
       483 ~15%     +32.8%        642 ~11%  TOTAL sched_debug.cpu#46.nr_uninterruptible

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       257 ~19%     +60.5%        413 ~ 4%  grantley/micro/aim7/disk_src
       553 ~ 6%     +15.8%        640 ~ 1%  grantley/micro/aim7/shell_rtns_1
       810 ~10%     +30.0%       1054 ~ 2%  TOTAL sched_debug.cfs_rq[28]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     11917 ~19%     +59.9%      19052 ~ 4%  grantley/micro/aim7/disk_src
     25346 ~ 6%     +16.1%      29428 ~ 1%  grantley/micro/aim7/shell_rtns_1
     37263 ~10%     +30.1%      48480 ~ 2%  TOTAL sched_debug.cfs_rq[28]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     74648 ~25%     +34.4%     100320 ~ 6%  grantley/micro/aim7/shell_rtns_1
     74648 ~25%     +34.4%     100320 ~ 6%  TOTAL sched_debug.cfs_rq[30]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       325 ~19%     +38.3%        450 ~ 9%  grantley/micro/aim7/shell_rtns_1
       325 ~19%     +38.3%        450 ~ 9%  TOTAL sched_debug.cfs_rq[14]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       138 ~ 8%     +44.3%        199 ~10%  grantley/micro/aim7/shell_rtns_1
       138 ~ 8%     +44.3%        199 ~10%  TOTAL proc-vmstat.nr_dirty

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4286 ~25%     +67.7%       7187 ~ 7%  grantley/micro/aim7/disk_src
     42314 ~ 2%     +17.6%      49761 ~ 4%  grantley/micro/aim7/shell_rtns_1
     46600 ~ 4%     +22.2%      56949 ~ 4%  TOTAL sched_debug.cpu#46.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       103 ~33%     +41.3%        146 ~ 4%  grantley/micro/aim7/disk_src
       103 ~33%     +41.3%        146 ~ 4%  TOTAL sched_debug.cpu#28.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     52078 ~29%     -36.2%      33211 ~10%  grantley/micro/aim7/disk_src
  28680256 ~ 0%      -9.6%   25928839 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
  28732334 ~ 0%      -9.6%   25962051 ~ 0%  TOTAL proc-vmstat.pgalloc_dma32

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     31785 ~19%     +35.3%      43021 ~10%  grantley/micro/aim7/shell_rtns_1
     31785 ~19%     +35.3%      43021 ~10%  TOTAL sched_debug.cpu#5.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     55808 ~ 3%     +23.2%      68779 ~ 1%  grantley/micro/aim7/shell_rtns_1
     55808 ~ 3%     +23.2%      68779 ~ 1%  TOTAL sched_debug.cfs_rq[48]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      5342 ~30%     +81.2%       9678 ~33%  grantley/micro/aim7/shell_rtns_1
      5342 ~30%     +81.2%       9678 ~33%  TOTAL sched_debug.cfs_rq[34]:/.spread0

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       471 ~13%     +29.5%        611 ~ 6%  grantley/micro/aim7/shell_rtns_1
       471 ~13%     +29.5%        611 ~ 6%  TOTAL sched_debug.cfs_rq[41]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      5530 ~13%     +47.4%       8152 ~ 0%  grantley/micro/aim7/shell_rtns_1
      5530 ~13%     +47.4%       8152 ~ 0%  TOTAL sched_debug.cpu#17.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4197 ~22%     +49.8%       6287 ~19%  grantley/micro/aim7/disk_src
     41791 ~ 3%     +19.9%      50127 ~ 5%  grantley/micro/aim7/shell_rtns_1
     45988 ~ 5%     +22.7%      56414 ~ 7%  TOTAL sched_debug.cpu#33.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       318 ~11%     +34.3%        427 ~ 6%  grantley/micro/aim7/disk_src
       516 ~ 4%     +24.6%        643 ~ 1%  grantley/micro/aim7/shell_rtns_1
       835 ~ 6%     +28.3%       1071 ~ 3%  TOTAL sched_debug.cfs_rq[25]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3717 ~33%     +56.6%       5822 ~14%  grantley/micro/aim7/disk_src
     41540 ~ 3%     +16.0%      48183 ~ 3%  grantley/micro/aim7/shell_rtns_1
     45257 ~ 5%     +19.3%      54005 ~ 4%  TOTAL sched_debug.cpu#50.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     14674 ~11%     +34.8%      19782 ~ 6%  grantley/micro/aim7/disk_src
     23719 ~ 4%     +24.7%      29587 ~ 1%  grantley/micro/aim7/shell_rtns_1
     38393 ~ 7%     +28.6%      49369 ~ 3%  TOTAL sched_debug.cfs_rq[25]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      8307 ~15%     +59.5%      13249 ~15%  grantley/micro/aim7/disk_src
     45416 ~ 2%     +15.6%      52513 ~ 3%  grantley/micro/aim7/shell_rtns_1
     53723 ~ 4%     +22.4%      65762 ~ 6%  TOTAL sched_debug.cpu#0.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      0.58 ~ 7%     +30.1%       0.76 ~ 7%  lkp-sb03/micro/netperf/120s-200%-SCTP_STREAM
      0.58 ~ 7%     +30.1%       0.76 ~ 7%  TOTAL turbostat.%c1

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       706 ~17%     +30.9%        924 ~10%  grantley/micro/aim7/shell_rtns_1
       706 ~17%     +30.9%        924 ~10%  TOTAL sched_debug.cpu#30.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      3958 ~34%     +59.1%       6295 ~17%  grantley/micro/aim7/disk_src
     40918 ~ 2%     +16.4%      47645 ~ 2%  grantley/micro/aim7/shell_rtns_1
     44876 ~ 5%     +20.2%      53940 ~ 4%  TOTAL sched_debug.cpu#49.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       405 ~31%     +28.6%        521 ~14%  grantley/micro/aim7/disk_src
       673 ~16%     +19.1%        802 ~ 7%  grantley/micro/aim7/shell_rtns_1
      1079 ~22%     +22.7%       1324 ~ 9%  TOTAL sched_debug.cpu#5.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       497 ~12%     +28.7%        641 ~ 6%  grantley/micro/aim7/shell_rtns_1
       497 ~12%     +28.7%        641 ~ 6%  TOTAL sched_debug.cfs_rq[39]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       320 ~11%     +31.6%        421 ~ 5%  grantley/micro/aim7/disk_src
       519 ~ 3%     +25.1%        650 ~ 0%  grantley/micro/aim7/shell_rtns_1
       840 ~ 7%     +27.6%       1071 ~ 2%  TOTAL sched_debug.cfs_rq[26]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       448 ~14%     +36.6%        613 ~10%  grantley/micro/aim7/shell_rtns_1
       448 ~14%     +36.6%        613 ~10%  TOTAL sched_debug.cpu#44.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     14796 ~12%     +31.4%      19447 ~ 5%  grantley/micro/aim7/disk_src
     23852 ~ 3%     +25.3%      29889 ~ 0%  grantley/micro/aim7/shell_rtns_1
     38649 ~ 7%     +27.7%      49336 ~ 2%  TOTAL sched_debug.cfs_rq[26]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       632 ~14%     +32.5%        837 ~ 5%  grantley/micro/aim7/shell_rtns_1
       632 ~14%     +32.5%        837 ~ 5%  TOTAL sched_debug.cfs_rq[55]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4768 ~22%     +55.9%       7433 ~13%  grantley/micro/aim7/disk_src
     42555 ~ 2%     +16.3%      49487 ~ 3%  grantley/micro/aim7/shell_rtns_1
     47323 ~ 4%     +20.3%      56920 ~ 4%  TOTAL sched_debug.cpu#31.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       465 ~ 9%     +25.7%        585 ~ 5%  grantley/micro/aim7/shell_rtns_1
       465 ~ 9%     +25.7%        585 ~ 5%  TOTAL sched_debug.cpu#52.nr_uninterruptible

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4766 ~27%     +84.1%       8773 ~11%  grantley/micro/aim7/disk_src
     41267 ~ 2%     +16.7%      48174 ~ 3%  grantley/micro/aim7/shell_rtns_1
     46034 ~ 5%     +23.7%      56947 ~ 4%  TOTAL sched_debug.cpu#26.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       467 ~ 9%     +26.2%        590 ~ 4%  grantley/micro/aim7/shell_rtns_1
       467 ~ 9%     +26.2%        590 ~ 4%  TOTAL sched_debug.cpu#8.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9383 ~30%     +65.6%      15537 ~ 8%  grantley/micro/aim7/disk_src
     47414 ~ 5%     +19.5%      56667 ~ 5%  grantley/micro/aim7/shell_rtns_1
     56798 ~ 9%     +27.1%      72205 ~ 5%  TOTAL sched_debug.cpu#3.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       354 ~22%     +25.3%        443 ~12%  grantley/micro/aim7/shell_rtns_1
       354 ~22%     +25.3%        443 ~12%  TOTAL sched_debug.cfs_rq[21]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       419 ~18%     +34.3%        563 ~10%  grantley/micro/aim7/shell_rtns_1
       419 ~18%     +34.3%        563 ~10%  TOTAL sched_debug.cfs_rq[3]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       463 ~10%     +25.3%        581 ~ 7%  grantley/micro/aim7/shell_rtns_1
       463 ~10%     +25.3%        581 ~ 7%  TOTAL sched_debug.cpu#8.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       729 ~15%     +28.9%        941 ~10%  grantley/micro/aim7/shell_rtns_1
       729 ~15%     +28.9%        941 ~10%  TOTAL sched_debug.cfs_rq[1]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9418 ~21%     +37.5%      12946 ~ 9%  grantley/micro/aim7/disk_src
     47127 ~ 3%     +13.5%      53505 ~ 4%  grantley/micro/aim7/shell_rtns_1
     56545 ~ 6%     +17.5%      66451 ~ 5%  TOTAL sched_debug.cpu#17.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       469 ~ 8%     +26.3%        592 ~ 2%  grantley/micro/aim7/shell_rtns_1
       469 ~ 8%     +26.3%        592 ~ 2%  TOTAL sched_debug.cpu#8.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       682 ~ 9%     +32.7%        905 ~ 4%  grantley/micro/aim7/shell_rtns_1
       682 ~ 9%     +32.7%        905 ~ 4%  TOTAL sched_debug.cpu#50.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       697 ~10%     +31.1%        914 ~ 4%  grantley/micro/aim7/shell_rtns_1
       697 ~10%     +31.1%        914 ~ 4%  TOTAL sched_debug.cfs_rq[50]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     28347 ~20%     +37.2%      38888 ~ 1%  grantley/micro/aim7/shell_rtns_1
     28347 ~20%     +37.2%      38888 ~ 1%  TOTAL sched_debug.cpu#20.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       431 ~10%     +28.8%        556 ~ 7%  grantley/micro/aim7/shell_rtns_1
       431 ~10%     +28.8%        556 ~ 7%  TOTAL sched_debug.cpu#32.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       700 ~19%     +33.7%        937 ~ 9%  grantley/micro/aim7/shell_rtns_1
       700 ~19%     +33.7%        937 ~ 9%  TOTAL sched_debug.cfs_rq[30]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       448 ~14%     +33.4%        598 ~ 4%  grantley/micro/aim7/shell_rtns_1
       448 ~14%     +33.4%        598 ~ 4%  TOTAL sched_debug.cfs_rq[55]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       464 ~ 8%     +25.9%        584 ~ 2%  grantley/micro/aim7/shell_rtns_1
       464 ~ 8%     +25.9%        584 ~ 2%  TOTAL sched_debug.cpu#11.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     36254 ~10%     +30.2%      47220 ~ 5%  grantley/micro/aim7/shell_rtns_1
     36254 ~10%     +30.2%      47220 ~ 5%  TOTAL sched_debug.cpu#38.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      6370 ~15%     +33.8%       8525 ~15%  grantley/micro/aim7/disk_src
     42554 ~ 2%     +14.9%      48882 ~ 4%  grantley/micro/aim7/shell_rtns_1
     48925 ~ 4%     +17.3%      57407 ~ 6%  TOTAL sched_debug.cpu#14.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       335 ~12%     +32.7%        444 ~ 1%  grantley/micro/aim7/disk_src
       538 ~ 3%     +23.2%        663 ~ 1%  grantley/micro/aim7/shell_rtns_1
       873 ~ 7%     +26.8%       1108 ~ 1%  TOTAL sched_debug.cfs_rq[17]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15501 ~13%     +32.3%      20503 ~ 1%  grantley/micro/aim7/disk_src
     24727 ~ 3%     +23.1%      30432 ~ 1%  grantley/micro/aim7/shell_rtns_1
     40229 ~ 7%     +26.6%      50936 ~ 1%  TOTAL sched_debug.cfs_rq[17]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15096 ~13%     +21.9%      18399 ~ 5%  grantley/micro/aim7/disk_src
     30642 ~ 3%     +23.7%      37891 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45738 ~ 6%     +23.1%      56291 ~ 2%  TOTAL sched_debug.cfs_rq[7]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15082 ~13%     +21.9%      18392 ~ 5%  grantley/micro/aim7/disk_src
     30610 ~ 3%     +23.7%      37866 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45693 ~ 6%     +23.1%      56259 ~ 2%  TOTAL sched_debug.cfs_rq[5]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15070 ~13%     +22.0%      18387 ~ 5%  grantley/micro/aim7/disk_src
     30590 ~ 3%     +23.7%      37846 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45660 ~ 6%     +23.2%      56234 ~ 2%  TOTAL sched_debug.cfs_rq[4]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15092 ~13%     +21.9%      18403 ~ 5%  grantley/micro/aim7/disk_src
     30630 ~ 3%     +23.7%      37886 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45723 ~ 6%     +23.1%      56290 ~ 2%  TOTAL sched_debug.cfs_rq[6]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15105 ~13%     +21.9%      18418 ~ 5%  grantley/micro/aim7/disk_src
     30648 ~ 2%     +23.6%      37876 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45753 ~ 6%     +23.0%      56295 ~ 2%  TOTAL sched_debug.cfs_rq[8]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       635 ~11%     +31.3%        834 ~ 9%  grantley/micro/aim7/shell_rtns_1
       635 ~11%     +31.3%        834 ~ 9%  TOTAL sched_debug.cpu#33.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       490 ~ 7%     +26.8%        622 ~ 3%  grantley/micro/aim7/shell_rtns_1
       490 ~ 7%     +26.8%        622 ~ 3%  TOTAL sched_debug.cpu#3.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       318 ~15%     +27.2%        405 ~ 2%  grantley/micro/aim7/disk_src
       520 ~ 4%     +23.4%        642 ~ 1%  grantley/micro/aim7/shell_rtns_1
       839 ~ 8%     +24.8%       1047 ~ 1%  TOTAL sched_debug.cfs_rq[24]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15130 ~13%     +22.1%      18472 ~ 5%  grantley/micro/aim7/disk_src
     30665 ~ 2%     +23.4%      37838 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45796 ~ 6%     +23.0%      56310 ~ 2%  TOTAL sched_debug.cfs_rq[11]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4658 ~33%     +53.0%       7126 ~18%  grantley/micro/aim7/shell_rtns_1
      4658 ~33%     +53.0%       7126 ~18%  TOTAL sched_debug.cfs_rq[52]:/.spread0

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15047 ~13%     +22.1%      18376 ~ 5%  grantley/micro/aim7/disk_src
     30569 ~ 3%     +23.7%      37811 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45617 ~ 6%     +23.2%      56187 ~ 2%  TOTAL sched_debug.cfs_rq[3]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15138 ~13%     +22.2%      18501 ~ 5%  grantley/micro/aim7/disk_src
     30666 ~ 2%     +23.3%      37812 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45804 ~ 6%     +22.9%      56314 ~ 2%  TOTAL sched_debug.cfs_rq[12]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15046 ~13%     +22.1%      18370 ~ 5%  grantley/micro/aim7/disk_src
     30537 ~ 3%     +23.6%      37754 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45584 ~ 6%     +23.1%      56125 ~ 2%  TOTAL sched_debug.cfs_rq[2]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15257 ~11%     +26.0%      19219 ~ 8%  grantley/micro/aim7/disk_src
     23652 ~ 4%     +26.0%      29793 ~ 1%  grantley/micro/aim7/shell_rtns_1
     38909 ~ 7%     +26.0%      49012 ~ 4%  TOTAL sched_debug.cfs_rq[13]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15020 ~13%     +22.1%      18340 ~ 5%  grantley/micro/aim7/disk_src
     30467 ~ 3%     +23.3%      37568 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45488 ~ 6%     +22.9%      55909 ~ 2%  TOTAL sched_debug.cfs_rq[0]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15131 ~13%     +22.0%      18466 ~ 5%  grantley/micro/aim7/disk_src
     30662 ~ 2%     +23.4%      37844 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45794 ~ 6%     +23.0%      56310 ~ 2%  TOTAL sched_debug.cfs_rq[10]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       736 ~19%     +17.6%        866 ~ 7%  grantley/micro/aim7/shell_rtns_1
       736 ~19%     +17.6%        866 ~ 7%  TOTAL sched_debug.cpu#3.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15112 ~13%     +22.0%      18438 ~ 5%  grantley/micro/aim7/disk_src
     30655 ~ 2%     +23.5%      37859 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45767 ~ 6%     +23.0%      56298 ~ 2%  TOTAL sched_debug.cfs_rq[9]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     27188 ~ 5%     +24.6%      33881 ~ 2%  grantley/micro/aim7/shell_rtns_1
     27188 ~ 5%     +24.6%      33881 ~ 2%  TOTAL sched_debug.cfs_rq[30]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15142 ~13%     +22.4%      18528 ~ 5%  grantley/micro/aim7/disk_src
     30669 ~ 2%     +23.2%      37789 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45812 ~ 6%     +22.9%      56318 ~ 2%  TOTAL sched_debug.cfs_rq[13]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15031 ~13%     +22.0%      18337 ~ 5%  grantley/micro/aim7/disk_src
     30499 ~ 3%     +23.5%      37674 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45530 ~ 6%     +23.0%      56011 ~ 2%  TOTAL sched_debug.cfs_rq[1]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     52586 ~ 5%     +28.6%      67611 ~ 0%  grantley/micro/aim7/shell_rtns_1
     52586 ~ 5%     +28.6%      67611 ~ 0%  TOTAL sched_debug.cfs_rq[16]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     23637 ~ 4%     +26.7%      29949 ~ 1%  grantley/micro/aim7/shell_rtns_1
     23637 ~ 4%     +26.7%      29949 ~ 1%  TOTAL sched_debug.cfs_rq[8]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     42689 ~ 2%     +29.5%      55274 ~ 1%  grantley/micro/aim7/shell_rtns_1
     42689 ~ 2%     +29.5%      55274 ~ 1%  TOTAL sched_debug.cfs_rq[20]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     37871 ~13%     +24.1%      47017 ~ 9%  grantley/micro/aim7/shell_rtns_1
     37871 ~13%     +24.1%      47017 ~ 9%  TOTAL sched_debug.cpu#1.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       331 ~11%     +25.8%        416 ~ 7%  grantley/micro/aim7/disk_src
       515 ~ 4%     +25.7%        648 ~ 1%  grantley/micro/aim7/shell_rtns_1
       847 ~ 7%     +25.7%       1065 ~ 3%  TOTAL sched_debug.cfs_rq[13]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
        74 ~45%     +44.3%        107 ~15%  grantley/micro/aim7/disk_src
       470 ~15%     +33.8%        630 ~ 5%  grantley/micro/aim7/shell_rtns_1
       545 ~19%     +35.3%        737 ~ 7%  TOTAL sched_debug.cfs_rq[32]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       344 ~23%     +33.5%        460 ~ 8%  grantley/micro/aim7/shell_rtns_1
       344 ~23%     +33.5%        460 ~ 8%  TOTAL sched_debug.cfs_rq[10]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       457 ~10%     +21.2%        554 ~ 5%  grantley/micro/aim7/shell_rtns_1
       457 ~10%     +21.2%        554 ~ 5%  TOTAL sched_debug.cpu#11.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     14500 ~15%     +33.3%      19332 ~ 2%  grantley/micro/aim7/disk_src
     23806 ~ 4%     +23.3%      29362 ~ 1%  grantley/micro/aim7/shell_rtns_1
     38307 ~ 8%     +27.1%      48695 ~ 1%  TOTAL sched_debug.cfs_rq[27]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       516 ~ 4%     +26.4%        652 ~ 1%  grantley/micro/aim7/shell_rtns_1
       516 ~ 4%     +26.4%        652 ~ 1%  TOTAL sched_debug.cfs_rq[8]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     14774 ~15%     +26.5%      18689 ~ 2%  grantley/micro/aim7/disk_src
     23855 ~ 4%     +23.7%      29504 ~ 1%  grantley/micro/aim7/shell_rtns_1
     38630 ~ 8%     +24.8%      48193 ~ 1%  TOTAL sched_debug.cfs_rq[24]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15166 ~13%     +22.3%      18551 ~ 5%  grantley/micro/aim7/disk_src
     30672 ~ 2%     +23.1%      37743 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45838 ~ 6%     +22.8%      56295 ~ 2%  TOTAL sched_debug.cfs_rq[15]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15173 ~13%     +22.3%      18559 ~ 5%  grantley/micro/aim7/disk_src
     30666 ~ 2%     +23.0%      37713 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45840 ~ 6%     +22.8%      56272 ~ 2%  TOTAL sched_debug.cfs_rq[16]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       405 ~31%     +27.0%        515 ~14%  grantley/micro/aim7/disk_src
       681 ~14%     +18.3%        805 ~ 5%  grantley/micro/aim7/shell_rtns_1
      1086 ~20%     +21.5%       1320 ~ 8%  TOTAL sched_debug.cfs_rq[5]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15161 ~13%     +22.2%      18525 ~ 5%  grantley/micro/aim7/disk_src
     30668 ~ 2%     +23.1%      37768 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45830 ~ 6%     +22.8%      56293 ~ 2%  TOTAL sched_debug.cfs_rq[14]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       489 ~ 7%     +26.3%        617 ~ 1%  grantley/micro/aim7/shell_rtns_1
       489 ~ 7%     +26.3%        617 ~ 1%  TOTAL sched_debug.cpu#3.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     34369 ~17%     +28.3%      44090 ~11%  grantley/micro/aim7/shell_rtns_1
     34369 ~17%     +28.3%      44090 ~11%  TOTAL sched_debug.cpu#52.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       592 ~ 5%     +24.4%        737 ~ 2%  grantley/micro/aim7/shell_rtns_1
       592 ~ 5%     +24.4%        737 ~ 2%  TOTAL sched_debug.cfs_rq[30]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       462 ~ 9%     +24.9%        577 ~ 3%  grantley/micro/aim7/shell_rtns_1
       462 ~ 9%     +24.9%        577 ~ 3%  TOTAL sched_debug.cpu#11.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       703 ~12%     +29.7%        912 ~12%  grantley/micro/aim7/shell_rtns_1
       703 ~12%     +29.7%        912 ~12%  TOTAL sched_debug.cpu#1.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15198 ~13%     +22.3%      18585 ~ 5%  grantley/micro/aim7/disk_src
     30672 ~ 2%     +22.8%      37656 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45870 ~ 6%     +22.6%      56241 ~ 2%  TOTAL sched_debug.cfs_rq[18]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     23833 ~ 4%     +26.2%      30079 ~ 0%  grantley/micro/aim7/shell_rtns_1
     23833 ~ 4%     +26.2%      30079 ~ 0%  TOTAL sched_debug.cfs_rq[6]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       317 ~15%     +36.1%        432 ~ 3%  grantley/micro/aim7/disk_src
       519 ~ 4%     +24.2%        645 ~ 1%  grantley/micro/aim7/shell_rtns_1
       837 ~ 8%     +28.7%       1077 ~ 2%  TOTAL sched_debug.cfs_rq[23]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       402 ~11%     +31.5%        529 ~18%  grantley/micro/aim7/shell_rtns_1
       402 ~11%     +31.5%        529 ~18%  TOTAL sched_debug.cpu#42.nr_uninterruptible

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15184 ~13%     +22.2%      18553 ~ 5%  grantley/micro/aim7/disk_src
     30670 ~ 2%     +22.9%      37687 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45855 ~ 6%     +22.7%      56241 ~ 2%  TOTAL sched_debug.cfs_rq[17]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15204 ~13%     +22.4%      18610 ~ 5%  grantley/micro/aim7/disk_src
     30673 ~ 2%     +22.7%      37639 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45877 ~ 6%     +22.6%      56249 ~ 2%  TOTAL sched_debug.cfs_rq[19]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     14684 ~15%     +36.0%      19976 ~ 4%  grantley/micro/aim7/disk_src
     23792 ~ 4%     +24.5%      29624 ~ 1%  grantley/micro/aim7/shell_rtns_1
     38476 ~ 8%     +28.9%      49600 ~ 2%  TOTAL sched_debug.cfs_rq[23]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15263 ~13%     +21.8%      18585 ~ 5%  grantley/micro/aim7/disk_src
     30657 ~ 2%     +22.3%      37503 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45921 ~ 6%     +22.1%      56089 ~ 2%  TOTAL sched_debug.cfs_rq[25]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     34254 ~18%     +34.9%      46221 ~ 5%  grantley/micro/aim7/shell_rtns_1
     34254 ~18%     +34.9%      46221 ~ 5%  TOTAL sched_debug.cpu#55.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       519 ~ 4%     +25.9%        654 ~ 0%  grantley/micro/aim7/shell_rtns_1
       519 ~ 4%     +25.9%        654 ~ 0%  TOTAL sched_debug.cfs_rq[6]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15197 ~13%     +22.4%      18604 ~ 5%  grantley/micro/aim7/disk_src
     30665 ~ 2%     +22.7%      37621 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45863 ~ 6%     +22.6%      56226 ~ 2%  TOTAL sched_debug.cfs_rq[20]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15209 ~13%     +22.4%      18617 ~ 5%  grantley/micro/aim7/disk_src
     30668 ~ 2%     +22.6%      37597 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45877 ~ 6%     +22.5%      56214 ~ 2%  TOTAL sched_debug.cfs_rq[21]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       456 ~12%     +33.2%        607 ~ 5%  grantley/micro/aim7/shell_rtns_1
       456 ~12%     +33.2%        607 ~ 5%  TOTAL sched_debug.cfs_rq[48]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15289 ~13%     +21.6%      18595 ~ 5%  grantley/micro/aim7/disk_src
     30649 ~ 2%     +22.1%      37438 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45938 ~ 6%     +22.0%      56033 ~ 2%  TOTAL sched_debug.cfs_rq[28]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15268 ~13%     +21.9%      18618 ~ 5%  grantley/micro/aim7/disk_src
     30654 ~ 2%     +22.2%      37456 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45923 ~ 6%     +22.1%      56074 ~ 2%  TOTAL sched_debug.cfs_rq[27]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       500 ~10%     +26.8%        634 ~10%  grantley/micro/aim7/shell_rtns_1
       500 ~10%     +26.8%        634 ~10%  TOTAL sched_debug.cfs_rq[47]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15253 ~13%     +22.0%      18604 ~ 5%  grantley/micro/aim7/disk_src
     30658 ~ 2%     +22.5%      37550 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45912 ~ 6%     +22.3%      56154 ~ 2%  TOTAL sched_debug.cfs_rq[23]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15262 ~13%     +21.6%      18566 ~ 5%  grantley/micro/aim7/disk_src
     30660 ~ 2%     +22.4%      37524 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45923 ~ 6%     +22.1%      56090 ~ 2%  TOTAL sched_debug.cfs_rq[24]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15236 ~13%     +22.0%      18592 ~ 5%  grantley/micro/aim7/disk_src
     30661 ~ 2%     +22.5%      37571 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45898 ~ 6%     +22.4%      56164 ~ 2%  TOTAL sched_debug.cfs_rq[22]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     14514 ~14%     +28.6%      18661 ~ 4%  grantley/micro/aim7/disk_src
     23918 ~ 4%     +24.1%      29688 ~ 1%  grantley/micro/aim7/shell_rtns_1
     38432 ~ 7%     +25.8%      48349 ~ 2%  TOTAL sched_debug.cfs_rq[22]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15268 ~13%     +21.8%      18590 ~ 5%  grantley/micro/aim7/disk_src
     30655 ~ 2%     +22.2%      37468 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45923 ~ 6%     +22.1%      56058 ~ 2%  TOTAL sched_debug.cfs_rq[26]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       314 ~15%     +33.6%        419 ~ 2%  grantley/micro/aim7/disk_src
       519 ~ 4%     +22.9%        638 ~ 1%  grantley/micro/aim7/shell_rtns_1
       833 ~ 8%     +26.9%       1058 ~ 1%  TOTAL sched_debug.cfs_rq[27]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15416 ~14%     +22.9%      18943 ~ 6%  grantley/micro/aim7/disk_src
     23720 ~ 5%     +26.4%      29978 ~ 1%  grantley/micro/aim7/shell_rtns_1
     39137 ~ 8%     +25.0%      48922 ~ 3%  TOTAL sched_debug.cfs_rq[9]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       407 ~14%     +27.6%        519 ~ 9%  grantley/micro/aim7/shell_rtns_1
       407 ~14%     +27.6%        519 ~ 9%  TOTAL sched_debug.cpu#40.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       474 ~15%     +27.3%        604 ~ 7%  grantley/micro/aim7/shell_rtns_1
       474 ~15%     +27.3%        604 ~ 7%  TOTAL sched_debug.cpu#34.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       495 ~ 8%     +27.1%        629 ~ 3%  grantley/micro/aim7/shell_rtns_1
       495 ~ 8%     +27.1%        629 ~ 3%  TOTAL sched_debug.cpu#3.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       457 ~ 8%     +22.7%        561 ~ 2%  grantley/micro/aim7/shell_rtns_1
       457 ~ 8%     +22.7%        561 ~ 2%  TOTAL sched_debug.cpu#25.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       470 ~ 7%     +24.9%        588 ~ 3%  grantley/micro/aim7/shell_rtns_1
       470 ~ 7%     +24.9%        588 ~ 3%  TOTAL sched_debug.cpu#9.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
   4406990 ~10%     -16.6%    3676633 ~ 0%  grantley/micro/aim7/disk_src
   4408101 ~11%     -16.8%    3666787 ~ 0%  grantley/micro/aim7/shell_rtns_1
   8815091 ~10%     -16.7%    7343420 ~ 0%  TOTAL meminfo.DirectMap2M

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     23628 ~ 4%     +26.3%      29848 ~ 1%  grantley/micro/aim7/shell_rtns_1
     23628 ~ 4%     +26.3%      29848 ~ 1%  TOTAL sched_debug.cfs_rq[11]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15323 ~13%     +22.0%      18689 ~ 5%  grantley/micro/aim7/disk_src
     30666 ~ 2%     +21.9%      37394 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45989 ~ 6%     +21.9%      56084 ~ 2%  TOTAL sched_debug.cfs_rq[31]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15281 ~13%     +21.7%      18598 ~ 5%  grantley/micro/aim7/disk_src
     30649 ~ 2%     +22.1%      37422 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45930 ~ 6%     +22.0%      56020 ~ 2%  TOTAL sched_debug.cfs_rq[29]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15308 ~13%     +21.9%      18660 ~ 5%  grantley/micro/aim7/disk_src
     30662 ~ 2%     +22.0%      37403 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45970 ~ 6%     +22.0%      56063 ~ 2%  TOTAL sched_debug.cfs_rq[30]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       501 ~ 9%     +26.8%        636 ~ 3%  grantley/micro/aim7/shell_rtns_1
       501 ~ 9%     +26.8%        636 ~ 3%  TOTAL sched_debug.cpu#3.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15329 ~13%     +21.9%      18685 ~ 5%  grantley/micro/aim7/disk_src
     30664 ~ 2%     +21.9%      37373 ~ 0%  grantley/micro/aim7/shell_rtns_1
     45993 ~ 6%     +21.9%      56058 ~ 2%  TOTAL sched_debug.cfs_rq[32]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     57.69 ~ 3%     +19.0%      68.65 ~ 2%  grantley/micro/aim7/disk_src
     74.94 ~ 2%     +39.2%     104.33 ~ 0%  grantley/micro/aim7/shell_rtns_1
    132.63 ~ 3%     +30.4%     172.98 ~ 1%  TOTAL uptime.boot

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       443 ~ 7%     +28.1%        567 ~ 4%  grantley/micro/aim7/shell_rtns_1
       443 ~ 7%     +28.1%        567 ~ 4%  TOTAL sched_debug.cpu#41.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       333 ~14%     +23.0%        410 ~ 6%  grantley/micro/aim7/disk_src
       517 ~ 5%     +26.1%        653 ~ 1%  grantley/micro/aim7/shell_rtns_1
       851 ~ 8%     +24.9%       1063 ~ 3%  TOTAL sched_debug.cfs_rq[9]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       333 ~12%     +33.8%        446 ~ 9%  grantley/micro/aim7/shell_rtns_1
       333 ~12%     +33.8%        446 ~ 9%  TOTAL sched_debug.cfs_rq[20]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       313 ~14%     +28.8%        403 ~ 4%  grantley/micro/aim7/disk_src
       521 ~ 4%     +23.8%        645 ~ 1%  grantley/micro/aim7/shell_rtns_1
       835 ~ 7%     +25.7%       1049 ~ 2%  TOTAL sched_debug.cfs_rq[22]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       643 ~ 8%     +30.2%        837 ~10%  grantley/micro/aim7/shell_rtns_1
       643 ~ 8%     +30.2%        837 ~10%  TOTAL sched_debug.cfs_rq[33]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15340 ~13%     +21.8%      18676 ~ 5%  grantley/micro/aim7/disk_src
     30665 ~ 2%     +21.8%      37357 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46005 ~ 6%     +21.8%      56034 ~ 2%  TOTAL sched_debug.cfs_rq[33]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       642 ~13%     +29.8%        834 ~ 4%  grantley/micro/aim7/shell_rtns_1
       642 ~13%     +29.8%        834 ~ 4%  TOTAL sched_debug.cpu#55.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
   1022996 ~22%     -25.4%     763495 ~ 7%  grantley/micro/aim7/disk_src
   1022996 ~22%     -25.4%     763495 ~ 7%  TOTAL proc-vmstat.pgfree

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      6107 ~27%     +59.3%       9727 ~ 9%  grantley/micro/aim7/disk_src
     43525 ~ 3%     +16.9%      50892 ~ 5%  grantley/micro/aim7/shell_rtns_1
     49632 ~ 6%     +22.1%      60620 ~ 6%  TOTAL sched_debug.cpu#20.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       472 ~ 8%     +23.8%        585 ~ 3%  grantley/micro/aim7/shell_rtns_1
       472 ~ 8%     +23.8%        585 ~ 3%  TOTAL sched_debug.cpu#7.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15377 ~13%     +21.3%      18655 ~ 5%  grantley/micro/aim7/disk_src
     30665 ~ 2%     +21.7%      37331 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46043 ~ 6%     +21.6%      55986 ~ 2%  TOTAL sched_debug.cfs_rq[35]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     35300 ~15%     +26.7%      44715 ~ 9%  grantley/micro/aim7/shell_rtns_1
     35300 ~15%     +26.7%      44715 ~ 9%  TOTAL sched_debug.cpu#48.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       503 ~ 5%     +24.5%        626 ~ 2%  grantley/micro/aim7/shell_rtns_1
       503 ~ 5%     +24.5%        626 ~ 2%  TOTAL sched_debug.cpu#1.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       714 ~12%     +25.2%        895 ~ 6%  grantley/micro/aim7/shell_rtns_1
       714 ~12%     +25.2%        895 ~ 6%  TOTAL sched_debug.cfs_rq[17]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15347 ~13%     +21.5%      18651 ~ 5%  grantley/micro/aim7/disk_src
     30665 ~ 2%     +21.7%      37333 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46013 ~ 6%     +21.7%      55984 ~ 2%  TOTAL sched_debug.cfs_rq[34]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15361 ~13%     +21.6%      18674 ~ 5%  grantley/micro/aim7/disk_src
     30665 ~ 2%     +21.7%      37320 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46027 ~ 6%     +21.7%      55995 ~ 2%  TOTAL sched_debug.cfs_rq[36]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       503 ~13%     +22.9%        619 ~ 3%  grantley/micro/aim7/shell_rtns_1
       503 ~13%     +22.9%        619 ~ 3%  TOTAL sched_debug.cpu#4.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       516 ~ 4%     +25.9%        650 ~ 1%  grantley/micro/aim7/shell_rtns_1
       516 ~ 4%     +25.9%        650 ~ 1%  TOTAL sched_debug.cfs_rq[11]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15383 ~13%     +21.6%      18700 ~ 5%  grantley/micro/aim7/disk_src
     30666 ~ 2%     +21.6%      37279 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46049 ~ 6%     +21.6%      55980 ~ 2%  TOTAL sched_debug.cfs_rq[38]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15373 ~13%     +21.5%      18682 ~ 5%  grantley/micro/aim7/disk_src
     30666 ~ 2%     +21.6%      37300 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46039 ~ 6%     +21.6%      55983 ~ 2%  TOTAL sched_debug.cfs_rq[37]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15374 ~13%     +21.5%      18677 ~ 5%  grantley/micro/aim7/disk_src
     30669 ~ 2%     +21.5%      37269 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46043 ~ 6%     +21.5%      55947 ~ 2%  TOTAL sched_debug.cfs_rq[39]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       448 ~13%     +24.2%        557 ~ 9%  grantley/micro/aim7/shell_rtns_1
       448 ~13%     +24.2%        557 ~ 9%  TOTAL sched_debug.cpu#8.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       514 ~ 6%     +23.8%        637 ~ 3%  grantley/micro/aim7/shell_rtns_1
       514 ~ 6%     +23.8%        637 ~ 3%  TOTAL sched_debug.cpu#1.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       674 ~11%     +21.8%        821 ~ 4%  grantley/micro/aim7/shell_rtns_1
       674 ~11%     +21.8%        821 ~ 4%  TOTAL sched_debug.cpu#39.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       460 ~16%     +17.0%        539 ~ 6%  grantley/micro/aim7/shell_rtns_1
       460 ~16%     +17.0%        539 ~ 6%  TOTAL sched_debug.cfs_rq[52]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       482 ~ 7%     +23.4%        595 ~ 1%  grantley/micro/aim7/shell_rtns_1
       482 ~ 7%     +23.4%        595 ~ 1%  TOTAL sched_debug.cpu#6.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15379 ~13%     +21.3%      18657 ~ 5%  grantley/micro/aim7/disk_src
     30672 ~ 2%     +21.5%      37253 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46052 ~ 6%     +21.4%      55910 ~ 2%  TOTAL sched_debug.cfs_rq[40]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       500 ~ 7%     +23.5%        618 ~ 2%  grantley/micro/aim7/shell_rtns_1
       500 ~ 7%     +23.5%        618 ~ 2%  TOTAL sched_debug.cpu#2.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15377 ~13%     +21.4%      18666 ~ 5%  grantley/micro/aim7/disk_src
     30677 ~ 2%     +21.4%      37243 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46054 ~ 6%     +21.4%      55909 ~ 2%  TOTAL sched_debug.cfs_rq[41]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       482 ~ 7%     +23.8%        597 ~ 1%  grantley/micro/aim7/shell_rtns_1
       482 ~ 7%     +23.8%        597 ~ 1%  TOTAL sched_debug.cpu#6.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     36408 ~12%     +19.6%      43545 ~11%  grantley/micro/aim7/shell_rtns_1
     36408 ~12%     +19.6%      43545 ~11%  TOTAL sched_debug.cpu#51.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15372 ~13%     +21.3%      18654 ~ 5%  grantley/micro/aim7/disk_src
     30676 ~ 2%     +21.3%      37221 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46048 ~ 5%     +21.3%      55875 ~ 2%  TOTAL sched_debug.cfs_rq[42]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     29627 ~19%     +21.2%      35900 ~ 9%  grantley/micro/aim7/shell_rtns_1
     29627 ~19%     +21.2%      35900 ~ 9%  TOTAL sched_debug.cpu#27.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       430 ~15%     +33.4%        574 ~ 8%  grantley/micro/aim7/shell_rtns_1
       430 ~15%     +33.4%        574 ~ 8%  TOTAL sched_debug.cpu#41.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      5598 ~18%     +38.0%       7726 ~ 0%  grantley/micro/aim7/shell_rtns_1
      5598 ~18%     +38.0%       7726 ~ 0%  TOTAL sched_debug.cpu#16.nr_load_updates

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       324 ~12%     +29.7%        421 ~ 6%  grantley/micro/aim7/disk_src
       526 ~ 4%     +24.0%        652 ~ 1%  grantley/micro/aim7/shell_rtns_1
       851 ~ 7%     +26.2%       1074 ~ 3%  TOTAL sched_debug.cfs_rq[19]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15396 ~12%     +21.1%      18645 ~ 5%  grantley/micro/aim7/disk_src
     30702 ~ 2%     +21.2%      37213 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46099 ~ 5%     +21.2%      55858 ~ 2%  TOTAL sched_debug.cfs_rq[43]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       506 ~ 6%     +24.4%        629 ~ 1%  grantley/micro/aim7/shell_rtns_1
       506 ~ 6%     +24.4%        629 ~ 1%  TOTAL sched_debug.cpu#1.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15269 ~14%     +28.2%      19581 ~ 3%  grantley/micro/aim7/disk_src
     23853 ~ 3%     +24.6%      29725 ~ 1%  grantley/micro/aim7/shell_rtns_1
     39123 ~ 8%     +26.0%      49306 ~ 2%  TOTAL sched_debug.cfs_rq[21]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       449 ~ 9%     +23.4%        554 ~ 8%  grantley/micro/aim7/shell_rtns_1
       449 ~ 9%     +23.4%        554 ~ 8%  TOTAL sched_debug.cpu#36.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       442 ~11%     +23.4%        546 ~ 7%  grantley/micro/aim7/shell_rtns_1
       442 ~11%     +23.4%        546 ~ 7%  TOTAL sched_debug.cpu#51.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       330 ~14%     +28.5%        425 ~ 3%  grantley/micro/aim7/disk_src
       520 ~ 3%     +24.3%        646 ~ 1%  grantley/micro/aim7/shell_rtns_1
       851 ~ 8%     +25.9%       1072 ~ 2%  TOTAL sched_debug.cfs_rq[21]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     56400 ~ 4%     +24.6%      70300 ~ 3%  grantley/micro/aim7/shell_rtns_1
     56400 ~ 4%     +24.6%      70300 ~ 3%  TOTAL sched_debug.cfs_rq[33]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9005 ~20%     +30.2%      11722 ~11%  grantley/micro/aim7/disk_src
     26088 ~ 2%     +21.2%      31623 ~ 2%  grantley/micro/aim7/shell_rtns_1
     35094 ~ 6%     +23.5%      43346 ~ 4%  TOTAL sched_debug.cfs_rq[52]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       473 ~ 7%     +25.0%        591 ~ 7%  grantley/micro/aim7/shell_rtns_1
       473 ~ 7%     +25.0%        591 ~ 7%  TOTAL sched_debug.cfs_rq[33]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       484 ~ 7%     +21.8%        590 ~ 1%  grantley/micro/aim7/shell_rtns_1
       484 ~ 7%     +21.8%        590 ~ 1%  TOTAL sched_debug.cpu#6.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       504 ~ 7%     +23.5%        623 ~ 3%  grantley/micro/aim7/shell_rtns_1
       504 ~ 7%     +23.5%        623 ~ 3%  TOTAL sched_debug.cpu#2.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15829 ~15%     +25.7%      19903 ~ 5%  grantley/micro/aim7/disk_src
     24931 ~ 3%     +24.2%      30962 ~ 0%  grantley/micro/aim7/shell_rtns_1
     40761 ~ 7%     +24.8%      50865 ~ 2%  TOTAL sched_debug.cfs_rq[0]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15005 ~12%     +29.7%      19457 ~ 6%  grantley/micro/aim7/disk_src
     24160 ~ 4%     +24.3%      30019 ~ 1%  grantley/micro/aim7/shell_rtns_1
     39165 ~ 7%     +26.3%      49476 ~ 3%  TOTAL sched_debug.cfs_rq[19]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       521 ~12%     +28.6%        671 ~ 7%  grantley/micro/aim7/shell_rtns_1
       521 ~12%     +28.6%        671 ~ 7%  TOTAL sched_debug.cfs_rq[1]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       329 ~28%     +34.8%        444 ~13%  grantley/micro/aim7/disk_src
       329 ~28%     +34.8%        444 ~13%  TOTAL sched_debug.cpu#15.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       329 ~28%     +34.8%        444 ~13%  grantley/micro/aim7/disk_src
       329 ~28%     +34.8%        444 ~13%  TOTAL sched_debug.cfs_rq[15]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       523 ~13%     +23.6%        647 ~ 8%  grantley/micro/aim7/shell_rtns_1
       523 ~13%     +23.6%        647 ~ 8%  TOTAL sched_debug.cpu#2.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     24542 ~ 3%     +25.1%      30705 ~ 1%  grantley/micro/aim7/shell_rtns_1
     24542 ~ 3%     +25.1%      30705 ~ 1%  TOTAL sched_debug.cfs_rq[3]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       468 ~ 9%     +26.9%        594 ~ 2%  grantley/micro/aim7/shell_rtns_1
       468 ~ 9%     +26.9%        594 ~ 2%  TOTAL sched_debug.cpu#10.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       507 ~13%     +26.1%        640 ~ 7%  grantley/micro/aim7/shell_rtns_1
       507 ~13%     +26.1%        640 ~ 7%  TOTAL sched_debug.cpu#3.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       342 ~15%     +25.9%        431 ~ 5%  grantley/micro/aim7/disk_src
       544 ~ 3%     +24.0%        674 ~ 0%  grantley/micro/aim7/shell_rtns_1
       886 ~ 7%     +24.7%       1106 ~ 2%  TOTAL sched_debug.cfs_rq[0]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
        13 ~12%     +29.0%         17 ~ 6%  grantley/micro/aim7/disk_src
        34 ~ 5%     +24.9%         43 ~ 3%  grantley/micro/aim7/shell_rtns_1
        48 ~ 7%     +26.0%         61 ~ 4%  TOTAL vmstat.procs.r

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15416 ~12%     +20.8%      18622 ~ 6%  grantley/micro/aim7/disk_src
     30706 ~ 2%     +21.2%      37206 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46123 ~ 5%     +21.0%      55828 ~ 2%  TOTAL sched_debug.cfs_rq[44]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     25138 ~14%     +45.4%      36546 ~12%  grantley/micro/aim7/shell_rtns_1
     25138 ~14%     +45.4%      36546 ~12%  TOTAL sched_debug.cpu#11.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       336 ~ 9%     +22.4%        412 ~ 7%  grantley/micro/aim7/disk_src
       520 ~ 4%     +24.8%        649 ~ 1%  grantley/micro/aim7/shell_rtns_1
       857 ~ 6%     +23.9%       1062 ~ 4%  TOTAL sched_debug.cfs_rq[7]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     23673 ~ 4%     +24.6%      29494 ~ 1%  grantley/micro/aim7/shell_rtns_1
     23673 ~ 4%     +24.6%      29494 ~ 1%  TOTAL sched_debug.cfs_rq[12]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       532 ~ 7%     +22.3%        651 ~ 6%  grantley/micro/aim7/shell_rtns_1
       532 ~ 7%     +22.3%        651 ~ 6%  TOTAL sched_debug.cpu#1.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       412 ~17%     +28.2%        528 ~ 6%  grantley/micro/aim7/shell_rtns_1
       412 ~17%     +28.2%        528 ~ 6%  TOTAL sched_debug.cpu#8.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15426 ~12%     +20.7%      18622 ~ 6%  grantley/micro/aim7/disk_src
     30702 ~ 2%     +21.2%      37199 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46128 ~ 5%     +21.0%      55822 ~ 2%  TOTAL sched_debug.cfs_rq[45]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15424 ~13%     +20.8%      18631 ~ 6%  grantley/micro/aim7/disk_src
     30701 ~ 2%     +21.2%      37203 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46126 ~ 5%     +21.0%      55834 ~ 2%  TOTAL sched_debug.cfs_rq[46]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       659 ~11%     +29.0%        850 ~ 7%  grantley/micro/aim7/shell_rtns_1
       659 ~11%     +29.0%        850 ~ 7%  TOTAL sched_debug.cpu#36.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       333 ~11%     +23.5%        411 ~ 8%  grantley/micro/aim7/disk_src
       535 ~ 3%     +24.8%        668 ~ 1%  grantley/micro/aim7/shell_rtns_1
       868 ~ 6%     +24.3%       1080 ~ 4%  TOTAL sched_debug.cfs_rq[1]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       519 ~15%     +19.2%        618 ~ 5%  grantley/micro/aim7/shell_rtns_1
       519 ~15%     +19.2%        618 ~ 5%  TOTAL sched_debug.cpu#4.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     25244 ~ 4%     +27.0%      32053 ~ 0%  grantley/micro/aim7/shell_rtns_1
     25244 ~ 4%     +27.0%      32053 ~ 0%  TOTAL sched_debug.cfs_rq[16]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15478 ~13%     +20.8%      18699 ~ 6%  grantley/micro/aim7/disk_src
     30696 ~ 2%     +21.1%      37173 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46175 ~ 5%     +21.0%      55872 ~ 2%  TOTAL sched_debug.cfs_rq[51]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15548 ~ 9%     +22.1%      18984 ~ 7%  grantley/micro/aim7/disk_src
     23852 ~ 4%     +25.1%      29836 ~ 1%  grantley/micro/aim7/shell_rtns_1
     39401 ~ 6%     +23.9%      48821 ~ 4%  TOTAL sched_debug.cfs_rq[7]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15437 ~12%     +20.9%      18662 ~ 6%  grantley/micro/aim7/disk_src
     30697 ~ 2%     +21.1%      37183 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46134 ~ 5%     +21.0%      55845 ~ 2%  TOTAL sched_debug.cfs_rq[48]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15445 ~13%     +20.9%      18669 ~ 6%  grantley/micro/aim7/disk_src
     30699 ~ 2%     +21.1%      37178 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46145 ~ 5%     +21.0%      55848 ~ 2%  TOTAL sched_debug.cfs_rq[49]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       466 ~11%     +25.4%        585 ~ 2%  grantley/micro/aim7/shell_rtns_1
       466 ~11%     +25.4%        585 ~ 2%  TOTAL sched_debug.cpu#10.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15426 ~11%     +22.9%      18960 ~ 8%  grantley/micro/aim7/disk_src
     24548 ~ 3%     +25.2%      30723 ~ 1%  grantley/micro/aim7/shell_rtns_1
     39974 ~ 6%     +24.3%      49683 ~ 4%  TOTAL sched_debug.cfs_rq[1]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       455 ~ 6%     +20.6%        549 ~ 2%  grantley/micro/aim7/shell_rtns_1
       455 ~ 6%     +20.6%        549 ~ 2%  TOTAL sched_debug.cpu#24.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15437 ~13%     +20.8%      18643 ~ 6%  grantley/micro/aim7/disk_src
     30700 ~ 2%     +21.2%      37199 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46138 ~ 5%     +21.0%      55842 ~ 2%  TOTAL sched_debug.cfs_rq[47]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       424 ~ 6%     +22.5%        519 ~ 4%  grantley/micro/aim7/shell_rtns_1
       424 ~ 6%     +22.5%        519 ~ 4%  TOTAL sched_debug.cpu#40.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       194 ~20%     +30.2%        253 ~11%  grantley/micro/aim7/disk_src
       567 ~ 2%     +21.0%        687 ~ 1%  grantley/micro/aim7/shell_rtns_1
       762 ~ 6%     +23.4%        941 ~ 4%  TOTAL sched_debug.cfs_rq[52]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15465 ~12%     +20.9%      18706 ~ 5%  grantley/micro/aim7/disk_src
     30703 ~ 2%     +21.0%      37161 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46169 ~ 5%     +21.0%      55867 ~ 2%  TOTAL sched_debug.cfs_rq[52]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15469 ~12%     +20.9%      18703 ~ 5%  grantley/micro/aim7/disk_src
     30701 ~ 2%     +21.0%      37150 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46170 ~ 5%     +21.0%      55853 ~ 2%  TOTAL sched_debug.cfs_rq[54]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     35660 ~13%     +28.9%      45953 ~ 6%  grantley/micro/aim7/shell_rtns_1
     35660 ~13%     +28.9%      45953 ~ 6%  TOTAL sched_debug.cpu#50.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       482 ~ 7%     +23.4%        594 ~ 3%  grantley/micro/aim7/shell_rtns_1
       482 ~ 7%     +23.4%        594 ~ 3%  TOTAL sched_debug.cpu#5.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15471 ~13%     +20.8%      18681 ~ 6%  grantley/micro/aim7/disk_src
     30695 ~ 2%     +21.1%      37170 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46166 ~ 5%     +21.0%      55851 ~ 2%  TOTAL sched_debug.cfs_rq[50]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15469 ~12%     +20.9%      18703 ~ 5%  grantley/micro/aim7/disk_src
     30705 ~ 2%     +21.0%      37159 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46174 ~ 5%     +21.0%      55862 ~ 2%  TOTAL sched_debug.cfs_rq[53]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       664 ~ 6%     +24.7%        828 ~ 8%  grantley/micro/aim7/shell_rtns_1
       664 ~ 6%     +24.7%        828 ~ 8%  TOTAL sched_debug.cfs_rq[37]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       679 ~10%     +24.1%        844 ~ 4%  grantley/micro/aim7/shell_rtns_1
       679 ~10%     +24.1%        844 ~ 4%  TOTAL sched_debug.cfs_rq[39]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       666 ~ 6%     +27.7%        851 ~11%  grantley/micro/aim7/shell_rtns_1
       666 ~ 6%     +27.7%        851 ~11%  TOTAL sched_debug.cfs_rq[48]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    983555 ~21%     -24.3%     744493 ~ 7%  grantley/micro/aim7/disk_src
    983555 ~21%     -24.3%     744493 ~ 7%  TOTAL proc-vmstat.pgalloc_normal

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       470 ~ 8%     +24.8%        587 ~ 4%  grantley/micro/aim7/shell_rtns_1
       470 ~ 8%     +24.8%        587 ~ 4%  TOTAL sched_debug.cpu#9.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       327 ~11%     +22.0%        400 ~ 9%  grantley/micro/aim7/disk_src
       526 ~ 4%     +24.0%        653 ~ 1%  grantley/micro/aim7/shell_rtns_1
       854 ~ 6%     +23.2%       1053 ~ 4%  TOTAL sched_debug.cfs_rq[5]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15470 ~12%     +21.0%      18711 ~ 5%  grantley/micro/aim7/disk_src
     30697 ~ 2%     +21.0%      37140 ~ 0%  grantley/micro/aim7/shell_rtns_1
     46167 ~ 5%     +21.0%      55851 ~ 2%  TOTAL sched_debug.cfs_rq[55]:/.tg->runnable_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       720 ~13%     +24.8%        898 ~ 7%  grantley/micro/aim7/shell_rtns_1
       720 ~13%     +24.8%        898 ~ 7%  TOTAL sched_debug.cpu#17.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       464 ~ 8%     +21.6%        565 ~ 1%  grantley/micro/aim7/shell_rtns_1
       464 ~ 8%     +21.6%        565 ~ 1%  TOTAL sched_debug.cpu#22.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       661 ~13%     +20.2%        795 ~ 7%  grantley/micro/aim7/shell_rtns_1
       661 ~13%     +20.2%        795 ~ 7%  TOTAL sched_debug.cpu#35.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15161 ~11%     +21.9%      18484 ~ 9%  grantley/micro/aim7/disk_src
     24153 ~ 4%     +24.5%      30072 ~ 1%  grantley/micro/aim7/shell_rtns_1
     39315 ~ 6%     +23.5%      48557 ~ 4%  TOTAL sched_debug.cfs_rq[5]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       509 ~ 8%     +23.0%        626 ~ 3%  grantley/micro/aim7/shell_rtns_1
       509 ~ 8%     +23.0%        626 ~ 3%  TOTAL sched_debug.cpu#2.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       326 ~13%     +28.4%        419 ~ 5%  grantley/micro/aim7/disk_src
       539 ~ 3%     +22.9%        662 ~ 1%  grantley/micro/aim7/shell_rtns_1
       865 ~ 7%     +25.0%       1082 ~ 3%  TOTAL sched_debug.cfs_rq[15]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       550 ~ 4%     +26.5%        696 ~ 0%  grantley/micro/aim7/shell_rtns_1
       550 ~ 4%     +26.5%        696 ~ 0%  TOTAL sched_debug.cfs_rq[16]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15076 ~13%     +28.6%      19387 ~ 5%  grantley/micro/aim7/disk_src
     24713 ~ 3%     +23.3%      30473 ~ 1%  grantley/micro/aim7/shell_rtns_1
     39790 ~ 7%     +25.3%      49861 ~ 3%  TOTAL sched_debug.cfs_rq[15]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       480 ~ 6%     +23.1%        591 ~ 2%  grantley/micro/aim7/shell_rtns_1
       480 ~ 6%     +23.1%        591 ~ 2%  TOTAL sched_debug.cpu#5.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       468 ~14%     +23.7%        578 ~ 5%  grantley/micro/aim7/shell_rtns_1
       468 ~14%     +23.7%        578 ~ 5%  TOTAL sched_debug.cpu#49.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       336 ~13%     +24.6%        419 ~ 9%  grantley/micro/aim7/disk_src
       538 ~ 3%     +22.4%        659 ~ 1%  grantley/micro/aim7/shell_rtns_1
       875 ~ 7%     +23.3%       1078 ~ 4%  TOTAL sched_debug.cfs_rq[2]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       643 ~13%     +30.6%        840 ~ 8%  grantley/micro/aim7/shell_rtns_1
       643 ~13%     +30.6%        840 ~ 8%  TOTAL sched_debug.cpu#22.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       510 ~ 8%     +27.8%        651 ~ 1%  grantley/micro/aim7/shell_rtns_1
       510 ~ 8%     +27.8%        651 ~ 1%  TOTAL sched_debug.cpu#16.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       662 ~13%     +21.5%        805 ~ 3%  grantley/micro/aim7/shell_rtns_1
       662 ~13%     +21.5%        805 ~ 3%  TOTAL sched_debug.cpu#32.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       109 ~35%     +33.2%        145 ~ 6%  grantley/micro/aim7/disk_src
       109 ~35%     +33.2%        145 ~ 6%  TOTAL sched_debug.cpu#28.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       496 ~10%     +23.9%        614 ~ 1%  grantley/micro/aim7/shell_rtns_1
       496 ~10%     +23.9%        614 ~ 1%  TOTAL sched_debug.cpu#4.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       580 ~15%     +29.4%        750 ~10%  grantley/micro/aim7/shell_rtns_1
       580 ~15%     +29.4%        750 ~10%  TOTAL sched_debug.cfs_rq[13]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       515 ~ 9%     +22.6%        631 ~ 4%  grantley/micro/aim7/shell_rtns_1
       515 ~ 9%     +22.6%        631 ~ 4%  TOTAL sched_debug.cpu#2.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     37526 ~ 7%     +25.2%      46979 ~ 3%  grantley/micro/aim7/shell_rtns_1
     37526 ~ 7%     +25.2%      46979 ~ 3%  TOTAL sched_debug.cpu#39.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     37476 ~12%     +19.8%      44901 ~ 4%  grantley/micro/aim7/shell_rtns_1
     37476 ~12%     +19.8%      44901 ~ 4%  TOTAL sched_debug.cpu#33.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     27674 ~20%     +33.9%      37046 ~16%  grantley/micro/aim7/shell_rtns_1
     27674 ~20%     +33.9%      37046 ~16%  TOTAL sched_debug.cpu#14.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    134955 ~13%     +12.7%     152054 ~10%  grantley/micro/aim7/shell_rtns_1
    134955 ~13%     +12.7%     152054 ~10%  TOTAL numa-meminfo.node1.Active

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       514 ~12%     +23.9%        637 ~10%  grantley/micro/aim7/shell_rtns_1
       514 ~12%     +23.9%        637 ~10%  TOTAL sched_debug.cpu#30.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15540 ~ 9%     +23.9%      19257 ~ 5%  grantley/micro/aim7/disk_src
     23947 ~ 3%     +23.8%      29651 ~ 1%  grantley/micro/aim7/shell_rtns_1
     39488 ~ 6%     +23.9%      48908 ~ 2%  TOTAL sched_debug.cfs_rq[20]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15550 ~13%     +24.3%      19324 ~ 9%  grantley/micro/aim7/disk_src
     24662 ~ 3%     +22.9%      30300 ~ 1%  grantley/micro/aim7/shell_rtns_1
     40212 ~ 7%     +23.4%      49624 ~ 4%  TOTAL sched_debug.cfs_rq[2]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     27700 ~13%     +29.4%      35846 ~ 6%  grantley/micro/aim7/shell_rtns_1
     27700 ~13%     +29.4%      35846 ~ 6%  TOTAL sched_debug.cpu#9.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       467 ~ 7%     +22.7%        573 ~ 2%  grantley/micro/aim7/shell_rtns_1
       467 ~ 7%     +22.7%        573 ~ 2%  TOTAL sched_debug.cpu#13.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       336 ~ 9%     +23.9%        417 ~ 5%  grantley/micro/aim7/disk_src
       521 ~ 3%     +23.5%        644 ~ 1%  grantley/micro/aim7/shell_rtns_1
       858 ~ 6%     +23.7%       1061 ~ 2%  TOTAL sched_debug.cfs_rq[20]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       469 ~10%     +28.2%        602 ~ 6%  grantley/micro/aim7/shell_rtns_1
       469 ~10%     +28.2%        602 ~ 6%  TOTAL sched_debug.cfs_rq[50]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     36158 ~14%     +22.0%      44123 ~ 7%  grantley/micro/aim7/shell_rtns_1
     36158 ~14%     +22.0%      44123 ~ 7%  TOTAL sched_debug.cpu#30.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       653 ~13%     +23.8%        809 ~ 7%  grantley/micro/aim7/shell_rtns_1
       653 ~13%     +23.8%        809 ~ 7%  TOTAL sched_debug.cfs_rq[20]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     14797 ~17%     +23.1%      18211 ~ 7%  grantley/micro/aim7/disk_src
     24359 ~ 4%     +21.7%      29646 ~ 1%  grantley/micro/aim7/shell_rtns_1
     39157 ~ 9%     +22.2%      47857 ~ 3%  TOTAL sched_debug.cfs_rq[14]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       376 ~14%     +22.0%        459 ~ 7%  grantley/micro/aim7/shell_rtns_1
       376 ~14%     +22.0%        459 ~ 7%  TOTAL sched_debug.cpu#25.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       447 ~ 8%     +25.0%        559 ~ 5%  grantley/micro/aim7/shell_rtns_1
       447 ~ 8%     +25.0%        559 ~ 5%  TOTAL sched_debug.cpu#49.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       464 ~ 6%     +23.2%        571 ~ 0%  grantley/micro/aim7/shell_rtns_1
       464 ~ 6%     +23.2%        571 ~ 0%  TOTAL sched_debug.cpu#12.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       455 ~17%     +29.7%        591 ~ 6%  grantley/micro/aim7/shell_rtns_1
       455 ~17%     +29.7%        591 ~ 6%  TOTAL sched_debug.cpu#31.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       336 ~12%     +21.6%        409 ~ 7%  grantley/micro/aim7/disk_src
       530 ~ 4%     +25.4%        665 ~ 1%  grantley/micro/aim7/shell_rtns_1
       867 ~ 7%     +23.9%       1074 ~ 3%  TOTAL sched_debug.cfs_rq[4]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    338015 ~18%     +18.6%     400750 ~ 6%  grantley/micro/aim7/disk_src
  12254821 ~ 1%     +15.9%   14200752 ~ 0%  grantley/micro/aim7/shell_rtns_1
  12592836 ~ 2%     +16.0%   14601502 ~ 1%  TOTAL numa-vmstat.node0.numa_local

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       462 ~ 6%     +22.4%        566 ~ 2%  grantley/micro/aim7/shell_rtns_1
       462 ~ 6%     +22.4%        566 ~ 2%  TOTAL sched_debug.cpu#20.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       510 ~ 5%     +22.2%        624 ~ 0%  grantley/micro/aim7/shell_rtns_1
       510 ~ 5%     +22.2%        624 ~ 0%  TOTAL sched_debug.cpu#0.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       439 ~ 6%     +20.5%        529 ~ 7%  grantley/micro/aim7/shell_rtns_1
       439 ~ 6%     +20.5%        529 ~ 7%  TOTAL sched_debug.cpu#53.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     37099 ~11%     +23.4%      45772 ~ 9%  grantley/micro/aim7/shell_rtns_1
     37099 ~11%     +23.4%      45772 ~ 9%  TOTAL sched_debug.cpu#44.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       483 ~ 8%     +21.1%        584 ~ 2%  grantley/micro/aim7/shell_rtns_1
       483 ~ 8%     +21.1%        584 ~ 2%  TOTAL sched_debug.cpu#17.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       330 ~15%     +24.9%        413 ~ 9%  grantley/micro/aim7/disk_src
       515 ~ 4%     +24.6%        642 ~ 0%  grantley/micro/aim7/shell_rtns_1
       846 ~ 8%     +24.7%       1055 ~ 4%  TOTAL sched_debug.cfs_rq[12]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       358 ~18%     +29.9%        465 ~14%  grantley/micro/aim7/shell_rtns_1
       358 ~18%     +29.9%        465 ~14%  TOTAL sched_debug.cfs_rq[22]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15550 ~12%     +21.2%      18854 ~ 7%  grantley/micro/aim7/disk_src
     24334 ~ 3%     +25.7%      30580 ~ 1%  grantley/micro/aim7/shell_rtns_1
     39884 ~ 7%     +23.9%      49434 ~ 3%  TOTAL sched_debug.cfs_rq[4]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       461 ~13%     +22.3%        564 ~ 2%  grantley/micro/aim7/shell_rtns_1
       461 ~13%     +22.3%        564 ~ 2%  TOTAL sched_debug.cpu#10.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       480 ~ 7%     +19.0%        571 ~ 2%  grantley/micro/aim7/shell_rtns_1
       480 ~ 7%     +19.0%        571 ~ 2%  TOTAL sched_debug.cpu#14.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       321 ~16%     +23.0%        394 ~ 7%  grantley/micro/aim7/disk_src
       531 ~ 4%     +21.1%        644 ~ 1%  grantley/micro/aim7/shell_rtns_1
       852 ~ 9%     +21.8%       1039 ~ 3%  TOTAL sched_debug.cfs_rq[14]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       651 ~13%     +22.7%        799 ~ 7%  grantley/micro/aim7/shell_rtns_1
       651 ~13%     +22.7%        799 ~ 7%  TOTAL sched_debug.cpu#20.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       470 ~10%     +23.2%        579 ~ 4%  grantley/micro/aim7/shell_rtns_1
       470 ~10%     +23.2%        579 ~ 4%  TOTAL sched_debug.cpu#9.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       459 ~ 9%     +23.1%        565 ~ 5%  grantley/micro/aim7/shell_rtns_1
       459 ~ 9%     +23.1%        565 ~ 5%  TOTAL sched_debug.cpu#34.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     57331 ~ 2%     +25.5%      71977 ~ 6%  grantley/micro/aim7/shell_rtns_1
     57331 ~ 2%     +25.5%      71977 ~ 6%  TOTAL sched_debug.cfs_rq[47]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       468 ~ 6%     +22.4%        573 ~ 3%  grantley/micro/aim7/shell_rtns_1
       468 ~ 6%     +22.4%        573 ~ 3%  TOTAL sched_debug.cpu#19.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       491 ~ 8%     +24.3%        611 ~ 1%  grantley/micro/aim7/shell_rtns_1
       491 ~ 8%     +24.3%        611 ~ 1%  TOTAL sched_debug.cpu#4.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     26145 ~ 1%     +23.3%      32240 ~ 1%  grantley/micro/aim7/shell_rtns_1
     26145 ~ 1%     +23.3%      32240 ~ 1%  TOTAL sched_debug.cfs_rq[54]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       488 ~ 7%     +22.4%        598 ~ 4%  grantley/micro/aim7/shell_rtns_1
       488 ~ 7%     +22.4%        598 ~ 4%  TOTAL sched_debug.cpu#5.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     25867 ~ 1%     +22.2%      31609 ~ 0%  grantley/micro/aim7/shell_rtns_1
     25867 ~ 1%     +22.2%      31609 ~ 0%  TOTAL sched_debug.cfs_rq[38]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       697 ~14%     +22.4%        853 ~ 9%  grantley/micro/aim7/shell_rtns_1
       697 ~14%     +22.4%        853 ~ 9%  TOTAL sched_debug.cpu#54.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     26011 ~ 1%     +22.8%      31936 ~ 1%  grantley/micro/aim7/shell_rtns_1
     26011 ~ 1%     +22.8%      31936 ~ 1%  TOTAL sched_debug.cfs_rq[33]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       653 ~13%     +26.3%        824 ~ 5%  grantley/micro/aim7/shell_rtns_1
       653 ~13%     +26.3%        824 ~ 5%  TOTAL sched_debug.cfs_rq[41]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       661 ~10%     +27.2%        841 ~11%  grantley/micro/aim7/shell_rtns_1
       661 ~10%     +27.2%        841 ~11%  TOTAL sched_debug.cpu#48.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       667 ~13%     +21.1%        808 ~ 4%  grantley/micro/aim7/shell_rtns_1
       667 ~13%     +21.1%        808 ~ 4%  TOTAL sched_debug.cfs_rq[32]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       677 ~13%     +18.9%        805 ~ 7%  grantley/micro/aim7/shell_rtns_1
       677 ~13%     +18.9%        805 ~ 7%  TOTAL sched_debug.cfs_rq[35]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     25968 ~ 1%     +21.9%      31648 ~ 0%  grantley/micro/aim7/shell_rtns_1
     25968 ~ 1%     +21.9%      31648 ~ 0%  TOTAL sched_debug.cfs_rq[40]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       566 ~ 2%     +21.7%        689 ~ 0%  grantley/micro/aim7/shell_rtns_1
       566 ~ 2%     +21.7%        689 ~ 0%  TOTAL sched_debug.cfs_rq[40]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       570 ~ 1%     +23.0%        701 ~ 0%  grantley/micro/aim7/shell_rtns_1
       570 ~ 1%     +23.0%        701 ~ 0%  TOTAL sched_debug.cfs_rq[54]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       502 ~ 8%     +26.2%        633 ~ 1%  grantley/micro/aim7/shell_rtns_1
       502 ~ 8%     +26.2%        633 ~ 1%  TOTAL sched_debug.cpu#16.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       567 ~ 1%     +22.3%        694 ~ 1%  grantley/micro/aim7/shell_rtns_1
       567 ~ 1%     +22.3%        694 ~ 1%  TOTAL sched_debug.cfs_rq[33]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     25831 ~ 2%     +22.3%      31588 ~ 0%  grantley/micro/aim7/shell_rtns_1
     25831 ~ 2%     +22.3%      31588 ~ 0%  TOTAL sched_debug.cfs_rq[36]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     26123 ~ 2%     +22.9%      32117 ~ 1%  grantley/micro/aim7/shell_rtns_1
     26123 ~ 2%     +22.9%      32117 ~ 1%  TOTAL sched_debug.cfs_rq[55]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       637 ~13%     +25.8%        802 ~ 6%  grantley/micro/aim7/shell_rtns_1
       637 ~13%     +25.8%        802 ~ 6%  TOTAL sched_debug.cpu#41.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     26018 ~ 1%     +22.7%      31921 ~ 0%  grantley/micro/aim7/shell_rtns_1
     26018 ~ 1%     +22.7%      31921 ~ 0%  TOTAL sched_debug.cfs_rq[50]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     55620 ~ 4%     +26.8%      70526 ~ 4%  grantley/micro/aim7/shell_rtns_1
     55620 ~ 4%     +26.8%      70526 ~ 4%  TOTAL sched_debug.cfs_rq[34]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       461 ~ 7%     +21.0%        558 ~ 0%  grantley/micro/aim7/shell_rtns_1
       461 ~ 7%     +21.0%        558 ~ 0%  TOTAL sched_debug.cpu#26.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       569 ~ 2%     +22.7%        698 ~ 1%  grantley/micro/aim7/shell_rtns_1
       569 ~ 2%     +22.7%        698 ~ 1%  TOTAL sched_debug.cfs_rq[55]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     36923 ~14%     +25.9%      46482 ~ 5%  grantley/micro/aim7/shell_rtns_1
     36923 ~14%     +25.9%      46482 ~ 5%  TOTAL sched_debug.cpu#36.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     26027 ~ 1%     +22.9%      31996 ~ 1%  grantley/micro/aim7/shell_rtns_1
     26027 ~ 1%     +22.9%      31996 ~ 1%  TOTAL sched_debug.cfs_rq[51]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     25975 ~ 1%     +21.8%      31640 ~ 0%  grantley/micro/aim7/shell_rtns_1
     25975 ~ 1%     +21.8%      31640 ~ 0%  TOTAL sched_debug.cfs_rq[41]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       567 ~ 1%     +22.1%        693 ~ 0%  grantley/micro/aim7/shell_rtns_1
       567 ~ 1%     +22.1%        693 ~ 0%  TOTAL sched_debug.cfs_rq[50]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       564 ~ 1%     +21.9%        687 ~ 0%  grantley/micro/aim7/shell_rtns_1
       564 ~ 1%     +21.9%        687 ~ 0%  TOTAL sched_debug.cfs_rq[38]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       564 ~ 1%     +21.8%        687 ~ 0%  grantley/micro/aim7/shell_rtns_1
       564 ~ 1%     +21.8%        687 ~ 0%  TOTAL sched_debug.cfs_rq[36]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       410 ~ 7%     +24.1%        509 ~ 8%  grantley/micro/aim7/shell_rtns_1
       410 ~ 7%     +24.1%        509 ~ 8%  TOTAL sched_debug.cpu#37.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       504 ~ 9%     +19.9%        605 ~ 3%  grantley/micro/aim7/shell_rtns_1
       504 ~ 9%     +19.9%        605 ~ 3%  TOTAL sched_debug.cfs_rq[34]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       565 ~ 1%     +21.7%        688 ~ 0%  grantley/micro/aim7/shell_rtns_1
       565 ~ 1%     +21.7%        688 ~ 0%  TOTAL sched_debug.cfs_rq[41]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15351 ~11%     +27.1%      19517 ~ 2%  grantley/micro/aim7/disk_src
     24554 ~ 4%     +22.2%      30017 ~ 0%  grantley/micro/aim7/shell_rtns_1
     39906 ~ 7%     +24.1%      49535 ~ 1%  TOTAL sched_debug.cfs_rq[18]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     60067 ~ 9%     +21.5%      72968 ~ 3%  grantley/micro/aim7/shell_rtns_1
     60067 ~ 9%     +21.5%      72968 ~ 3%  TOTAL sched_debug.cfs_rq[31]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       473 ~ 8%     +22.5%        579 ~ 4%  grantley/micro/aim7/shell_rtns_1
       473 ~ 8%     +22.5%        579 ~ 4%  TOTAL sched_debug.cpu#7.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       446 ~ 9%     +26.0%        562 ~ 8%  grantley/micro/aim7/shell_rtns_1
       446 ~ 9%     +26.0%        562 ~ 8%  TOTAL sched_debug.cfs_rq[51]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     15168 ~11%     +17.8%      17867 ~ 4%  grantley/micro/aim7/disk_src
     23764 ~ 4%     +26.0%      29951 ~ 1%  grantley/micro/aim7/shell_rtns_1
     38933 ~ 7%     +22.8%      47818 ~ 2%  TOTAL sched_debug.cfs_rq[10]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       463 ~ 7%     +18.8%        551 ~ 4%  grantley/micro/aim7/shell_rtns_1
       463 ~ 7%     +18.8%        551 ~ 4%  TOTAL sched_debug.cpu#19.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       567 ~16%     +29.5%        734 ~ 6%  grantley/micro/aim7/shell_rtns_1
       567 ~16%     +29.5%        734 ~ 6%  TOTAL sched_debug.cpu#13.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       513 ~ 6%     +21.5%        623 ~ 1%  grantley/micro/aim7/shell_rtns_1
       513 ~ 6%     +21.5%        623 ~ 1%  TOTAL sched_debug.cpu#0.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       674 ~ 7%     +20.3%        811 ~ 9%  grantley/micro/aim7/shell_rtns_1
       674 ~ 7%     +20.3%        811 ~ 9%  TOTAL sched_debug.cpu#37.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       437 ~ 8%     +22.0%        533 ~ 6%  grantley/micro/aim7/shell_rtns_1
       437 ~ 8%     +22.0%        533 ~ 6%  TOTAL sched_debug.cpu#48.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       646 ~10%     +31.5%        850 ~ 9%  grantley/micro/aim7/shell_rtns_1
       646 ~10%     +31.5%        850 ~ 9%  TOTAL sched_debug.cfs_rq[22]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       465 ~ 8%     +18.7%        551 ~ 2%  grantley/micro/aim7/shell_rtns_1
       465 ~ 8%     +18.7%        551 ~ 2%  TOTAL sched_debug.cpu#23.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       758 ~ 7%     +20.2%        911 ~ 7%  grantley/micro/aim7/shell_rtns_1
       758 ~ 7%     +20.2%        911 ~ 7%  TOTAL sched_debug.cpu#44.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       436 ~17%     +26.3%        551 ~11%  grantley/micro/aim7/shell_rtns_1
       436 ~17%     +26.3%        551 ~11%  TOTAL sched_debug.cpu#16.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       560 ~13%     +17.1%        656 ~ 8%  grantley/micro/aim7/shell_rtns_1
       560 ~13%     +17.1%        656 ~ 8%  TOTAL sched_debug.cfs_rq[0]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       517 ~ 4%     +19.9%        620 ~ 3%  grantley/micro/aim7/shell_rtns_1
       517 ~ 4%     +19.9%        620 ~ 3%  TOTAL sched_debug.cpu#32.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       478 ~ 7%     +19.1%        569 ~ 2%  grantley/micro/aim7/shell_rtns_1
       478 ~ 7%     +19.1%        569 ~ 2%  TOTAL sched_debug.cpu#18.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       347 ~12%     +21.5%        422 ~ 7%  grantley/micro/aim7/disk_src
       534 ~ 3%     +25.0%        667 ~ 1%  grantley/micro/aim7/shell_rtns_1
       881 ~ 7%     +23.6%       1090 ~ 3%  TOTAL sched_debug.cfs_rq[3]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       328 ~11%     +18.1%        387 ~ 4%  grantley/micro/aim7/disk_src
       518 ~ 4%     +25.6%        651 ~ 1%  grantley/micro/aim7/shell_rtns_1
       847 ~ 7%     +22.6%       1039 ~ 2%  TOTAL sched_debug.cfs_rq[10]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       566 ~ 2%     +22.0%        691 ~ 0%  grantley/micro/aim7/shell_rtns_1
       566 ~ 2%     +22.0%        691 ~ 0%  TOTAL sched_debug.cfs_rq[32]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     25977 ~ 2%     +22.3%      31760 ~ 0%  grantley/micro/aim7/shell_rtns_1
     25977 ~ 2%     +22.3%      31760 ~ 0%  TOTAL sched_debug.cfs_rq[32]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       567 ~ 1%     +22.5%        695 ~ 1%  grantley/micro/aim7/shell_rtns_1
       567 ~ 1%     +22.5%        695 ~ 1%  TOTAL sched_debug.cfs_rq[51]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       455 ~ 7%     +17.1%        533 ~ 3%  grantley/micro/aim7/shell_rtns_1
       455 ~ 7%     +17.1%        533 ~ 3%  TOTAL sched_debug.cpu#40.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       332 ~11%     +27.3%        423 ~ 2%  grantley/micro/aim7/disk_src
       535 ~ 4%     +22.0%        653 ~ 0%  grantley/micro/aim7/shell_rtns_1
       867 ~ 7%     +24.0%       1076 ~ 1%  TOTAL sched_debug.cfs_rq[18]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       569 ~ 2%     +21.4%        691 ~ 0%  grantley/micro/aim7/shell_rtns_1
       569 ~ 2%     +21.4%        691 ~ 0%  TOTAL sched_debug.cfs_rq[45]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       466 ~ 6%     +21.1%        565 ~ 2%  grantley/micro/aim7/shell_rtns_1
       466 ~ 6%     +21.1%        565 ~ 2%  TOTAL sched_debug.cpu#21.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       464 ~ 8%     +20.1%        558 ~ 3%  grantley/micro/aim7/shell_rtns_1
       464 ~ 8%     +20.1%        558 ~ 3%  TOTAL sched_debug.cpu#13.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       562 ~ 1%     +21.7%        684 ~ 0%  grantley/micro/aim7/shell_rtns_1
       562 ~ 1%     +21.7%        684 ~ 0%  TOTAL sched_debug.cfs_rq[37]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       452 ~ 6%     +20.6%        545 ~ 6%  grantley/micro/aim7/shell_rtns_1
       452 ~ 6%     +20.6%        545 ~ 6%  TOTAL sched_debug.cpu#51.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     26117 ~ 2%     +21.9%      31827 ~ 0%  grantley/micro/aim7/shell_rtns_1
     26117 ~ 2%     +21.9%      31827 ~ 0%  TOTAL sched_debug.cfs_rq[45]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       490 ~ 5%     +16.1%        569 ~ 3%  grantley/micro/aim7/shell_rtns_1
       490 ~ 5%     +16.1%        569 ~ 3%  TOTAL sched_debug.cpu#50.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     55118 ~ 3%     +23.4%      68040 ~ 0%  grantley/micro/aim7/shell_rtns_1
     55118 ~ 3%     +23.4%      68040 ~ 0%  TOTAL sched_debug.cfs_rq[51]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     26000 ~ 1%     +21.5%      31598 ~ 0%  grantley/micro/aim7/shell_rtns_1
     26000 ~ 1%     +21.5%      31598 ~ 0%  TOTAL sched_debug.cfs_rq[39]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       452 ~ 7%     +19.2%        539 ~ 2%  grantley/micro/aim7/shell_rtns_1
       452 ~ 7%     +19.2%        539 ~ 2%  TOTAL sched_debug.cpu#27.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     25825 ~ 1%     +21.7%      31434 ~ 0%  grantley/micro/aim7/shell_rtns_1
     25825 ~ 1%     +21.7%      31434 ~ 0%  TOTAL sched_debug.cfs_rq[37]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       567 ~ 1%     +21.2%        687 ~ 0%  grantley/micro/aim7/shell_rtns_1
       567 ~ 1%     +21.2%        687 ~ 0%  TOTAL sched_debug.cfs_rq[39]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     25905 ~ 2%     +21.3%      31434 ~ 1%  grantley/micro/aim7/shell_rtns_1
     25905 ~ 2%     +21.3%      31434 ~ 1%  TOTAL sched_debug.cfs_rq[35]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     26144 ~ 2%     +21.6%      31804 ~ 0%  grantley/micro/aim7/shell_rtns_1
     26144 ~ 2%     +21.6%      31804 ~ 0%  TOTAL sched_debug.cfs_rq[49]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     55463 ~ 3%     +23.1%      68256 ~ 1%  grantley/micro/aim7/shell_rtns_1
     55463 ~ 3%     +23.1%      68256 ~ 1%  TOTAL sched_debug.cfs_rq[50]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       470 ~ 8%     +17.3%        552 ~ 3%  grantley/micro/aim7/shell_rtns_1
       470 ~ 8%     +17.3%        552 ~ 3%  TOTAL sched_debug.cpu#14.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       569 ~ 2%     +21.3%        691 ~ 0%  grantley/micro/aim7/shell_rtns_1
       569 ~ 2%     +21.3%        691 ~ 0%  TOTAL sched_debug.cfs_rq[49]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     26488 ~ 2%     +21.8%      32273 ~ 0%  grantley/micro/aim7/shell_rtns_1
     26488 ~ 2%     +21.8%      32273 ~ 0%  TOTAL sched_debug.cfs_rq[31]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       565 ~ 2%     +21.0%        684 ~ 1%  grantley/micro/aim7/shell_rtns_1
       565 ~ 2%     +21.0%        684 ~ 1%  TOTAL sched_debug.cfs_rq[35]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      5520 ~41%     +43.5%       7920 ~11%  grantley/micro/aim7/shell_rtns_1
      5520 ~41%     +43.5%       7920 ~11%  TOTAL sched_debug.cfs_rq[48]:/.spread0

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       765 ~ 7%     +19.4%        914 ~ 7%  grantley/micro/aim7/shell_rtns_1
       765 ~ 7%     +19.4%        914 ~ 7%  TOTAL sched_debug.cfs_rq[44]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       568 ~ 2%     +20.5%        684 ~ 0%  grantley/micro/aim7/shell_rtns_1
       568 ~ 2%     +20.5%        684 ~ 0%  TOTAL sched_debug.cfs_rq[53]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       530 ~ 4%     +19.5%        633 ~ 1%  grantley/micro/aim7/shell_rtns_1
       530 ~ 4%     +19.5%        633 ~ 1%  TOTAL sched_debug.cpu#31.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       513 ~ 4%     +17.6%        604 ~ 1%  grantley/micro/aim7/shell_rtns_1
       513 ~ 4%     +17.6%        604 ~ 1%  TOTAL sched_debug.cpu#50.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     55022 ~ 5%     +22.9%      67631 ~ 1%  grantley/micro/aim7/shell_rtns_1
     55022 ~ 5%     +22.9%      67631 ~ 1%  TOTAL sched_debug.cfs_rq[49]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       464 ~ 4%     +19.7%        555 ~ 2%  grantley/micro/aim7/shell_rtns_1
       464 ~ 4%     +19.7%        555 ~ 2%  TOTAL sched_debug.cpu#12.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       471 ~ 7%     +20.1%        566 ~ 2%  grantley/micro/aim7/shell_rtns_1
       471 ~ 7%     +20.1%        566 ~ 2%  TOTAL sched_debug.cpu#55.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       565 ~ 2%     +22.1%        690 ~ 1%  grantley/micro/aim7/shell_rtns_1
       565 ~ 2%     +22.1%        690 ~ 1%  TOTAL sched_debug.cfs_rq[42]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       577 ~ 2%     +21.8%        702 ~ 0%  grantley/micro/aim7/shell_rtns_1
       577 ~ 2%     +21.8%        702 ~ 0%  TOTAL sched_debug.cfs_rq[31]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       660 ~ 7%     +26.8%        837 ~ 8%  grantley/micro/aim7/shell_rtns_1
       660 ~ 7%     +26.8%        837 ~ 8%  TOTAL sched_debug.cpu#31.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     26063 ~ 2%     +20.9%      31513 ~ 0%  grantley/micro/aim7/shell_rtns_1
     26063 ~ 2%     +20.9%      31513 ~ 0%  TOTAL sched_debug.cfs_rq[53]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     26250 ~ 1%     +20.7%      31687 ~ 0%  grantley/micro/aim7/shell_rtns_1
     26250 ~ 1%     +20.7%      31687 ~ 0%  TOTAL sched_debug.cfs_rq[48]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     25964 ~ 2%     +22.3%      31744 ~ 1%  grantley/micro/aim7/shell_rtns_1
     25964 ~ 2%     +22.3%      31744 ~ 1%  TOTAL sched_debug.cfs_rq[42]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       463 ~ 6%     +20.4%        558 ~ 3%  grantley/micro/aim7/shell_rtns_1
       463 ~ 6%     +20.4%        558 ~ 3%  TOTAL sched_debug.cpu#41.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     28424 ~13%     +26.5%      35944 ~ 7%  grantley/micro/aim7/shell_rtns_1
     28424 ~13%     +26.5%      35944 ~ 7%  TOTAL sched_debug.cpu#10.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       510 ~ 4%     +16.9%        597 ~ 3%  grantley/micro/aim7/shell_rtns_1
       510 ~ 4%     +16.9%        597 ~ 3%  TOTAL sched_debug.cpu#52.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       444 ~ 8%     +19.9%        532 ~ 3%  grantley/micro/aim7/shell_rtns_1
       444 ~ 8%     +19.9%        532 ~ 3%  TOTAL sched_debug.cpu#25.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     26615 ~ 1%     +20.2%      31997 ~ 0%  grantley/micro/aim7/shell_rtns_1
     26615 ~ 1%     +20.2%      31997 ~ 0%  TOTAL sched_debug.cfs_rq[47]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     37802 ~11%     +19.2%      45066 ~ 9%  grantley/micro/aim7/shell_rtns_1
     37802 ~11%     +19.2%      45066 ~ 9%  TOTAL sched_debug.cpu#42.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       487 ~ 8%     +23.8%        604 ~ 1%  grantley/micro/aim7/shell_rtns_1
       487 ~ 8%     +23.8%        604 ~ 1%  TOTAL sched_debug.cpu#16.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     57399 ~ 4%     +22.5%      70300 ~ 3%  grantley/micro/aim7/shell_rtns_1
     57399 ~ 4%     +22.5%      70300 ~ 3%  TOTAL sched_debug.cfs_rq[32]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     57023 ~ 4%     +20.9%      68954 ~ 2%  grantley/micro/aim7/shell_rtns_1
     57023 ~ 4%     +20.9%      68954 ~ 2%  TOTAL sched_debug.cfs_rq[35]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     26494 ~ 1%     +19.8%      31750 ~ 0%  grantley/micro/aim7/shell_rtns_1
     26494 ~ 1%     +19.8%      31750 ~ 0%  TOTAL sched_debug.cfs_rq[34]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       709 ~15%     +18.6%        841 ~ 6%  grantley/micro/aim7/shell_rtns_1
       709 ~15%     +18.6%        841 ~ 6%  TOTAL sched_debug.cpu#18.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       496 ~ 5%     +18.3%        587 ~ 5%  grantley/micro/aim7/shell_rtns_1
       496 ~ 5%     +18.3%        587 ~ 5%  TOTAL sched_debug.cpu#32.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     26364 ~ 1%     +21.0%      31899 ~ 0%  grantley/micro/aim7/shell_rtns_1
     26364 ~ 1%     +21.0%      31899 ~ 0%  TOTAL sched_debug.cfs_rq[46]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      4829 ~40%     +48.6%       7178 ~10%  grantley/micro/aim7/shell_rtns_1
      4829 ~40%     +48.6%       7178 ~10%  TOTAL sched_debug.cfs_rq[51]:/.spread0

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       464 ~ 5%     +17.1%        543 ~ 5%  grantley/micro/aim7/shell_rtns_1
       464 ~ 5%     +17.1%        543 ~ 5%  TOTAL sched_debug.cpu#50.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       490 ~ 6%     +15.4%        565 ~ 2%  grantley/micro/aim7/shell_rtns_1
       490 ~ 6%     +15.4%        565 ~ 2%  TOTAL sched_debug.cpu#40.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48137 ~ 4%     +14.4%      55088 ~ 1%  grantley/micro/aim7/disk_src
     56733 ~ 3%     +27.1%      72105 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104871 ~ 3%     +21.3%     127194 ~ 1%  TOTAL sched_debug.cpu#6.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       491 ~ 9%     +21.6%        598 ~ 9%  grantley/micro/aim7/shell_rtns_1
       491 ~ 9%     +21.6%        598 ~ 9%  TOTAL sched_debug.cpu#47.nr_uninterruptible

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48123 ~ 3%     +14.4%      55049 ~ 1%  grantley/micro/aim7/disk_src
     56734 ~ 3%     +27.1%      72100 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104857 ~ 3%     +21.3%     127149 ~ 1%  TOTAL sched_debug.cpu#10.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48125 ~ 3%     +14.4%      55041 ~ 1%  grantley/micro/aim7/disk_src
     56729 ~ 3%     +27.1%      72096 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104854 ~ 3%     +21.3%     127137 ~ 1%  TOTAL sched_debug.cpu#9.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48126 ~ 3%     +14.4%      55037 ~ 1%  grantley/micro/aim7/disk_src
     56724 ~ 3%     +27.1%      72082 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104851 ~ 3%     +21.2%     127120 ~ 1%  TOTAL sched_debug.cpu#0.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48180 ~ 4%     +14.4%      55095 ~ 1%  grantley/micro/aim7/disk_src
     56745 ~ 3%     +27.1%      72103 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104925 ~ 3%     +21.2%     127198 ~ 1%  TOTAL sched_debug.cpu#5.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48129 ~ 3%     +14.4%      55044 ~ 1%  grantley/micro/aim7/disk_src
     56734 ~ 3%     +27.1%      72098 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104864 ~ 3%     +21.2%     127143 ~ 1%  TOTAL sched_debug.cpu#11.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48132 ~ 3%     +14.4%      55046 ~ 1%  grantley/micro/aim7/disk_src
     56736 ~ 3%     +27.1%      72099 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104869 ~ 3%     +21.2%     127145 ~ 1%  TOTAL sched_debug.cpu#12.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48151 ~ 3%     +14.4%      55086 ~ 1%  grantley/micro/aim7/disk_src
     56751 ~ 3%     +27.1%      72119 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104903 ~ 3%     +21.3%     127205 ~ 1%  TOTAL sched_debug.cpu#23.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       578 ~ 2%     +19.5%        691 ~ 0%  grantley/micro/aim7/shell_rtns_1
       578 ~ 2%     +19.5%        691 ~ 0%  TOTAL sched_debug.cfs_rq[34]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       572 ~ 1%     +20.6%        690 ~ 0%  grantley/micro/aim7/shell_rtns_1
       572 ~ 1%     +20.6%        690 ~ 0%  TOTAL sched_debug.cfs_rq[48]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       405 ~24%     +17.6%        476 ~10%  grantley/micro/aim7/disk_src
       405 ~24%     +17.6%        476 ~10%  TOTAL sched_debug.cpu#21.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48129 ~ 3%     +14.4%      55047 ~ 1%  grantley/micro/aim7/disk_src
     56735 ~ 3%     +27.1%      72103 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104865 ~ 3%     +21.3%     127150 ~ 1%  TOTAL sched_debug.cpu#14.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48115 ~ 3%     +14.4%      55026 ~ 1%  grantley/micro/aim7/disk_src
     56717 ~ 3%     +27.1%      72079 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104833 ~ 3%     +21.2%     127106 ~ 1%  TOTAL sched_debug.cpu#1.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48132 ~ 3%     +14.4%      55046 ~ 1%  grantley/micro/aim7/disk_src
     56733 ~ 3%     +27.1%      72100 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104865 ~ 3%     +21.2%     127147 ~ 1%  TOTAL sched_debug.cpu#13.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48130 ~ 3%     +14.4%      55053 ~ 1%  grantley/micro/aim7/disk_src
     56735 ~ 3%     +27.1%      72104 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104865 ~ 3%     +21.3%     127157 ~ 1%  TOTAL sched_debug.cpu#15.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48160 ~ 3%     +14.4%      55081 ~ 1%  grantley/micro/aim7/disk_src
     56757 ~ 3%     +27.1%      72123 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104918 ~ 3%     +21.2%     127205 ~ 1%  TOTAL sched_debug.cpu#28.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48158 ~ 3%     +14.3%      55051 ~ 1%  grantley/micro/aim7/disk_src
     56751 ~ 3%     +27.1%      72105 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104910 ~ 3%     +21.2%     127157 ~ 1%  TOTAL sched_debug.cpu#16.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48157 ~ 3%     +14.4%      55077 ~ 1%  grantley/micro/aim7/disk_src
     56755 ~ 3%     +27.1%      72117 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104912 ~ 3%     +21.2%     127194 ~ 1%  TOTAL sched_debug.cpu#21.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48189 ~ 3%     +14.3%      55089 ~ 1%  grantley/micro/aim7/disk_src
     56760 ~ 3%     +27.1%      72118 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104949 ~ 3%     +21.2%     127208 ~ 1%  TOTAL sched_debug.cpu#19.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48219 ~ 3%     +14.3%      55119 ~ 1%  grantley/micro/aim7/disk_src
     56784 ~ 3%     +27.1%      72150 ~ 0%  grantley/micro/aim7/shell_rtns_1
    105003 ~ 3%     +21.2%     127269 ~ 1%  TOTAL sched_debug.cpu#50.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48222 ~ 3%     +14.3%      55120 ~ 1%  grantley/micro/aim7/disk_src
     56784 ~ 3%     +27.1%      72150 ~ 0%  grantley/micro/aim7/shell_rtns_1
    105006 ~ 3%     +21.2%     127271 ~ 1%  TOTAL sched_debug.cpu#51.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48223 ~ 3%     +14.3%      55121 ~ 1%  grantley/micro/aim7/disk_src
     56786 ~ 3%     +27.1%      72154 ~ 0%  grantley/micro/aim7/shell_rtns_1
    105009 ~ 3%     +21.2%     127276 ~ 1%  TOTAL sched_debug.cpu#55.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48184 ~ 3%     +14.3%      55093 ~ 1%  grantley/micro/aim7/disk_src
     56755 ~ 3%     +27.0%      72094 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104940 ~ 3%     +21.2%     127188 ~ 1%  TOTAL sched_debug.cpu#3.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48223 ~ 3%     +14.3%      55120 ~ 1%  grantley/micro/aim7/disk_src
     56786 ~ 3%     +27.1%      72153 ~ 0%  grantley/micro/aim7/shell_rtns_1
    105009 ~ 3%     +21.2%     127274 ~ 1%  TOTAL sched_debug.cpu#54.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48220 ~ 3%     +14.3%      55121 ~ 1%  grantley/micro/aim7/disk_src
     56784 ~ 3%     +27.1%      72148 ~ 0%  grantley/micro/aim7/shell_rtns_1
    105004 ~ 3%     +21.2%     127269 ~ 1%  TOTAL sched_debug.cpu#47.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48220 ~ 3%     +14.3%      55118 ~ 1%  grantley/micro/aim7/disk_src
     56782 ~ 3%     +27.1%      72146 ~ 0%  grantley/micro/aim7/shell_rtns_1
    105003 ~ 3%     +21.2%     127264 ~ 1%  TOTAL sched_debug.cpu#45.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48222 ~ 3%     +14.3%      55120 ~ 1%  grantley/micro/aim7/disk_src
     56785 ~ 3%     +27.1%      72151 ~ 0%  grantley/micro/aim7/shell_rtns_1
    105007 ~ 3%     +21.2%     127272 ~ 1%  TOTAL sched_debug.cpu#52.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48223 ~ 3%     +14.3%      55120 ~ 1%  grantley/micro/aim7/disk_src
     56785 ~ 3%     +27.1%      72152 ~ 0%  grantley/micro/aim7/shell_rtns_1
    105008 ~ 3%     +21.2%     127273 ~ 1%  TOTAL sched_debug.cpu#53.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48219 ~ 3%     +14.3%      55121 ~ 1%  grantley/micro/aim7/disk_src
     56785 ~ 3%     +27.1%      72149 ~ 0%  grantley/micro/aim7/shell_rtns_1
    105005 ~ 3%     +21.2%     127270 ~ 1%  TOTAL sched_debug.cpu#48.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48219 ~ 3%     +14.3%      55119 ~ 1%  grantley/micro/aim7/disk_src
     56785 ~ 3%     +27.1%      72149 ~ 0%  grantley/micro/aim7/shell_rtns_1
    105005 ~ 3%     +21.2%     127269 ~ 1%  TOTAL sched_debug.cpu#49.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48221 ~ 3%     +14.3%      55119 ~ 1%  grantley/micro/aim7/disk_src
     56785 ~ 3%     +27.1%      72147 ~ 0%  grantley/micro/aim7/shell_rtns_1
    105006 ~ 3%     +21.2%     127266 ~ 1%  TOTAL sched_debug.cpu#46.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48225 ~ 3%     +14.3%      55118 ~ 1%  grantley/micro/aim7/disk_src
     56782 ~ 3%     +27.1%      72146 ~ 0%  grantley/micro/aim7/shell_rtns_1
    105007 ~ 3%     +21.2%     127265 ~ 1%  TOTAL sched_debug.cpu#44.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48155 ~ 3%     +14.4%      55075 ~ 1%  grantley/micro/aim7/disk_src
     56754 ~ 3%     +27.1%      72120 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104910 ~ 3%     +21.2%     127196 ~ 1%  TOTAL sched_debug.cpu#24.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48152 ~ 3%     +14.4%      55076 ~ 1%  grantley/micro/aim7/disk_src
     56755 ~ 3%     +27.1%      72122 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104908 ~ 3%     +21.2%     127199 ~ 1%  TOTAL sched_debug.cpu#27.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48149 ~ 3%     +14.4%      55076 ~ 1%  grantley/micro/aim7/disk_src
     56755 ~ 3%     +27.1%      72121 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104904 ~ 3%     +21.3%     127197 ~ 1%  TOTAL sched_debug.cpu#25.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48152 ~ 3%     +14.4%      55076 ~ 1%  grantley/micro/aim7/disk_src
     56755 ~ 3%     +27.1%      72122 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104907 ~ 3%     +21.2%     127198 ~ 1%  TOTAL sched_debug.cpu#26.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48143 ~ 4%     +14.3%      55046 ~ 1%  grantley/micro/aim7/disk_src
     56729 ~ 3%     +27.1%      72094 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104872 ~ 3%     +21.2%     127141 ~ 1%  TOTAL sched_debug.cpu#8.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48202 ~ 3%     +14.3%      55085 ~ 1%  grantley/micro/aim7/disk_src
     56768 ~ 3%     +27.0%      72121 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104971 ~ 3%     +21.2%     127207 ~ 1%  TOTAL sched_debug.cpu#17.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       448 ~ 9%     +22.3%        548 ~ 7%  grantley/micro/aim7/shell_rtns_1
       448 ~ 9%     +22.3%        548 ~ 7%  TOTAL sched_debug.cpu#33.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48185 ~ 3%     +14.4%      55115 ~ 1%  grantley/micro/aim7/disk_src
     56772 ~ 3%     +27.1%      72141 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104957 ~ 3%     +21.2%     127257 ~ 1%  TOTAL sched_debug.cpu#42.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48184 ~ 3%     +14.4%      55115 ~ 1%  grantley/micro/aim7/disk_src
     56772 ~ 3%     +27.1%      72140 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104957 ~ 3%     +21.2%     127255 ~ 1%  TOTAL sched_debug.cpu#41.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48181 ~ 3%     +14.4%      55115 ~ 1%  grantley/micro/aim7/disk_src
     56771 ~ 3%     +27.1%      72139 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104953 ~ 3%     +21.2%     127254 ~ 1%  TOTAL sched_debug.cpu#40.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48225 ~ 3%     +14.3%      55123 ~ 1%  grantley/micro/aim7/disk_src
     56784 ~ 3%     +27.1%      72145 ~ 0%  grantley/micro/aim7/shell_rtns_1
    105010 ~ 3%     +21.2%     127268 ~ 1%  TOTAL sched_debug.cpu#43.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48200 ~ 4%     +14.3%      55116 ~ 1%  grantley/micro/aim7/disk_src
     56774 ~ 3%     +27.1%      72135 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104975 ~ 3%     +21.2%     127251 ~ 1%  TOTAL sched_debug.cpu#30.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48181 ~ 3%     +14.4%      55113 ~ 1%  grantley/micro/aim7/disk_src
     56771 ~ 3%     +27.1%      72138 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104952 ~ 3%     +21.2%     127252 ~ 1%  TOTAL sched_debug.cpu#39.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48201 ~ 3%     +14.3%      55108 ~ 1%  grantley/micro/aim7/disk_src
     56774 ~ 3%     +27.1%      72133 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104975 ~ 3%     +21.2%     127241 ~ 1%  TOTAL sched_debug.cpu#32.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48180 ~ 3%     +14.4%      55112 ~ 1%  grantley/micro/aim7/disk_src
     56770 ~ 3%     +27.1%      72136 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104951 ~ 3%     +21.2%     127248 ~ 1%  TOTAL sched_debug.cpu#35.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48206 ~ 3%     +14.3%      55113 ~ 1%  grantley/micro/aim7/disk_src
     56777 ~ 3%     +27.1%      72136 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104983 ~ 3%     +21.2%     127249 ~ 1%  TOTAL sched_debug.cpu#33.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48181 ~ 3%     +14.4%      55113 ~ 1%  grantley/micro/aim7/disk_src
     56770 ~ 3%     +27.1%      72139 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104951 ~ 3%     +21.2%     127252 ~ 1%  TOTAL sched_debug.cpu#36.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48181 ~ 3%     +14.4%      55117 ~ 1%  grantley/micro/aim7/disk_src
     56772 ~ 3%     +27.1%      72137 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104953 ~ 3%     +21.2%     127255 ~ 1%  TOTAL sched_debug.cpu#37.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48151 ~ 3%     +14.3%      55060 ~ 1%  grantley/micro/aim7/disk_src
     56736 ~ 3%     +27.1%      72103 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104887 ~ 3%     +21.2%     127163 ~ 1%  TOTAL sched_debug.cpu#7.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48191 ~ 3%     +14.4%      55113 ~ 1%  grantley/micro/aim7/disk_src
     56771 ~ 3%     +27.1%      72135 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104962 ~ 3%     +21.2%     127248 ~ 1%  TOTAL sched_debug.cpu#34.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48190 ~ 4%     +14.4%      55107 ~ 1%  grantley/micro/aim7/disk_src
     56768 ~ 3%     +27.1%      72132 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104958 ~ 3%     +21.2%     127239 ~ 1%  TOTAL sched_debug.cpu#31.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48181 ~ 3%     +14.4%      55113 ~ 1%  grantley/micro/aim7/disk_src
     56770 ~ 3%     +27.1%      72138 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104952 ~ 3%     +21.2%     127251 ~ 1%  TOTAL sched_debug.cpu#38.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48215 ~ 3%     +14.3%      55105 ~ 1%  grantley/micro/aim7/disk_src
     56762 ~ 3%     +27.0%      72103 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104977 ~ 3%     +21.2%     127209 ~ 1%  TOTAL sched_debug.cpu_clk

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48215 ~ 3%     +14.3%      55105 ~ 1%  grantley/micro/aim7/disk_src
     56762 ~ 3%     +27.0%      72103 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104977 ~ 3%     +21.2%     127209 ~ 1%  TOTAL sched_debug.sched_clk

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48190 ~ 3%     +14.3%      55095 ~ 1%  grantley/micro/aim7/disk_src
     56758 ~ 3%     +27.0%      72107 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104949 ~ 3%     +21.2%     127202 ~ 1%  TOTAL sched_debug.cpu#4.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48190 ~ 3%     +14.3%      55085 ~ 1%  grantley/micro/aim7/disk_src
     56763 ~ 3%     +27.1%      72124 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104953 ~ 3%     +21.2%     127210 ~ 1%  TOTAL sched_debug.cpu#29.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48175 ~ 3%     +14.3%      55088 ~ 1%  grantley/micro/aim7/disk_src
     56755 ~ 3%     +27.1%      72121 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104931 ~ 3%     +21.2%     127209 ~ 1%  TOTAL sched_debug.cpu#20.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48209 ~ 3%     +14.3%      55088 ~ 1%  grantley/micro/aim7/disk_src
     56764 ~ 3%     +27.1%      72120 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104974 ~ 3%     +21.2%     127208 ~ 1%  TOTAL sched_debug.cpu#18.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48167 ~ 3%     +14.2%      55026 ~ 1%  grantley/micro/aim7/disk_src
     56738 ~ 3%     +27.1%      72086 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104906 ~ 3%     +21.2%     127113 ~ 1%  TOTAL sched_debug.cpu#2.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48165 ~ 3%     +14.4%      55087 ~ 1%  grantley/micro/aim7/disk_src
     56756 ~ 3%     +27.1%      72118 ~ 0%  grantley/micro/aim7/shell_rtns_1
    104922 ~ 3%     +21.2%     127205 ~ 1%  TOTAL sched_debug.cpu#22.clock

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       447 ~11%     +21.9%        545 ~ 2%  grantley/micro/aim7/shell_rtns_1
       447 ~11%     +21.9%        545 ~ 2%  TOTAL sched_debug.cpu#54.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       515 ~ 5%     +17.0%        602 ~ 2%  grantley/micro/aim7/shell_rtns_1
       515 ~ 5%     +17.0%        602 ~ 2%  TOTAL sched_debug.cpu#40.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       599 ~12%     +26.9%        760 ~11%  grantley/micro/aim7/shell_rtns_1
       599 ~12%     +26.9%        760 ~11%  TOTAL sched_debug.cfs_rq[9]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       586 ~13%     +25.3%        734 ~ 7%  grantley/micro/aim7/shell_rtns_1
       586 ~13%     +25.3%        734 ~ 7%  TOTAL sched_debug.cpu#11.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       586 ~14%     +31.9%        773 ~10%  grantley/micro/aim7/shell_rtns_1
       586 ~14%     +31.9%        773 ~10%  TOTAL sched_debug.cpu#9.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       580 ~ 1%     +19.7%        694 ~ 0%  grantley/micro/aim7/shell_rtns_1
       580 ~ 1%     +19.7%        694 ~ 0%  TOTAL sched_debug.cfs_rq[47]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     34859 ~12%     +28.6%      44825 ~12%  grantley/micro/aim7/shell_rtns_1
     34859 ~12%     +28.6%      44825 ~12%  TOTAL sched_debug.cpu#3.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       708 ~13%     +21.5%        860 ~10%  grantley/micro/aim7/shell_rtns_1
       708 ~13%     +21.5%        860 ~10%  TOTAL sched_debug.cfs_rq[54]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     34896 ~11%     +24.4%      43425 ~11%  grantley/micro/aim7/shell_rtns_1
     34896 ~11%     +24.4%      43425 ~11%  TOTAL sched_debug.cpu#41.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       574 ~ 1%     +20.7%        693 ~ 0%  grantley/micro/aim7/shell_rtns_1
       574 ~ 1%     +20.7%        693 ~ 0%  TOTAL sched_debug.cfs_rq[46]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       502 ~10%     +21.8%        611 ~ 6%  grantley/micro/aim7/shell_rtns_1
       502 ~10%     +21.8%        611 ~ 6%  TOTAL sched_debug.cfs_rq[35]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       521 ~ 6%     +19.8%        625 ~ 2%  grantley/micro/aim7/shell_rtns_1
       521 ~ 6%     +19.8%        625 ~ 2%  TOTAL sched_debug.cpu#0.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       513 ~ 4%     +17.9%        605 ~ 1%  grantley/micro/aim7/shell_rtns_1
       513 ~ 4%     +17.9%        605 ~ 1%  TOTAL sched_debug.cpu#54.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       505 ~ 3%     +18.7%        599 ~ 3%  grantley/micro/aim7/shell_rtns_1
       505 ~ 3%     +18.7%        599 ~ 3%  TOTAL sched_debug.cpu#51.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    485411 ~16%     +29.9%     630775 ~ 2%  grantley/micro/aim7/shell_rtns_1
    485411 ~16%     +29.9%     630775 ~ 2%  TOTAL cpuidle.C3-HSW.usage

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       513 ~ 5%     +17.2%        601 ~ 2%  grantley/micro/aim7/shell_rtns_1
       513 ~ 5%     +17.2%        601 ~ 2%  TOTAL sched_debug.cpu#31.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       455 ~ 9%     +18.4%        540 ~ 2%  grantley/micro/aim7/shell_rtns_1
       455 ~ 9%     +18.4%        540 ~ 2%  TOTAL sched_debug.cpu#22.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
 7.157e+08 ~ 5%     +23.9%  8.866e+08 ~ 3%  grantley/micro/aim7/disk_src
 7.157e+08 ~ 5%     +23.9%  8.866e+08 ~ 3%  TOTAL cpuidle.C6-HSW.time

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       424 ~11%     +22.1%        518 ~ 4%  grantley/micro/aim7/shell_rtns_1
       424 ~11%     +22.1%        518 ~ 4%  TOTAL sched_debug.cpu#35.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       342 ~17%     +28.7%        441 ~10%  grantley/micro/aim7/shell_rtns_1
       342 ~17%     +28.7%        441 ~10%  TOTAL sched_debug.cfs_rq[17]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       597 ~13%     +23.6%        738 ~ 6%  grantley/micro/aim7/shell_rtns_1
       597 ~13%     +23.6%        738 ~ 6%  TOTAL sched_debug.cfs_rq[11]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       661 ~13%     +17.5%        777 ~10%  grantley/micro/aim7/shell_rtns_1
       661 ~13%     +17.5%        777 ~10%  TOTAL sched_debug.cfs_rq[21]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       496 ~ 6%     +20.1%        596 ~ 3%  grantley/micro/aim7/shell_rtns_1
       496 ~ 6%     +20.1%        596 ~ 3%  TOTAL sched_debug.cpu#15.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       466 ~ 7%     +19.9%        559 ~ 6%  grantley/micro/aim7/shell_rtns_1
       466 ~ 7%     +19.9%        559 ~ 6%  TOTAL sched_debug.cpu#32.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       492 ~12%     +22.1%        601 ~11%  grantley/micro/aim7/shell_rtns_1
       492 ~12%     +22.1%        601 ~11%  TOTAL sched_debug.cfs_rq[37]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     46910 ~ 4%     +13.6%      53298 ~ 2%  grantley/micro/aim7/disk_src
     55689 ~ 2%     +27.7%      71121 ~ 0%  grantley/micro/aim7/shell_rtns_1
    102600 ~ 3%     +21.3%     124419 ~ 1%  TOTAL sched_debug.ktime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       464 ~10%     +21.7%        565 ~ 5%  grantley/micro/aim7/shell_rtns_1
       464 ~10%     +21.7%        565 ~ 5%  TOTAL sched_debug.cpu#16.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       514 ~ 3%     +17.0%        601 ~ 1%  grantley/micro/aim7/shell_rtns_1
       514 ~ 3%     +17.0%        601 ~ 1%  TOTAL sched_debug.cpu#37.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       524 ~ 4%     +17.2%        614 ~ 2%  grantley/micro/aim7/shell_rtns_1
       524 ~ 4%     +17.2%        614 ~ 2%  TOTAL sched_debug.cpu#33.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       495 ~ 6%     +17.0%        579 ~ 2%  grantley/micro/aim7/shell_rtns_1
       495 ~ 6%     +17.0%        579 ~ 2%  TOTAL sched_debug.cpu#55.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       445 ~ 8%     +16.9%        520 ~ 3%  grantley/micro/aim7/shell_rtns_1
       445 ~ 8%     +16.9%        520 ~ 3%  TOTAL sched_debug.cpu#24.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       488 ~ 8%     +16.1%        566 ~ 4%  grantley/micro/aim7/shell_rtns_1
       488 ~ 8%     +16.1%        566 ~ 4%  TOTAL sched_debug.cpu#31.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     33850 ~17%     +23.4%      41757 ~ 8%  grantley/micro/aim7/shell_rtns_1
     33850 ~17%     +23.4%      41757 ~ 8%  TOTAL sched_debug.cpu#4.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       402 ~13%     +25.0%        503 ~14%  grantley/micro/aim7/shell_rtns_1
       402 ~13%     +25.0%        503 ~14%  TOTAL sched_debug.cpu#37.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       674 ~10%     +25.1%        844 ~ 6%  grantley/micro/aim7/shell_rtns_1
       674 ~10%     +25.1%        844 ~ 6%  TOTAL sched_debug.cfs_rq[36]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1436 ~ 0%     +18.5%       1703 ~ 0%  grantley/micro/aim7/disk_src
      1436 ~ 0%     +18.5%       1703 ~ 0%  TOTAL slabinfo.kmalloc-4096.active_objs

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       464 ~ 9%     +25.2%        581 ~ 7%  grantley/micro/aim7/shell_rtns_1
       464 ~ 9%     +25.2%        581 ~ 7%  TOTAL sched_debug.cpu#44.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       450 ~ 8%     +19.2%        536 ~ 6%  grantley/micro/aim7/shell_rtns_1
       450 ~ 8%     +19.2%        536 ~ 6%  TOTAL sched_debug.cpu#52.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     30044 ~16%     +20.9%      36321 ~ 5%  grantley/micro/aim7/shell_rtns_1
     30044 ~16%     +20.9%      36321 ~ 5%  TOTAL sched_debug.cpu#26.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       518 ~ 4%     +16.1%        601 ~ 0%  grantley/micro/aim7/shell_rtns_1
       518 ~ 4%     +16.1%        601 ~ 0%  TOTAL sched_debug.cpu#46.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       447 ~ 6%     +18.1%        528 ~ 5%  grantley/micro/aim7/shell_rtns_1
       447 ~ 6%     +18.1%        528 ~ 5%  TOTAL sched_debug.cpu#37.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     37857 ~15%     +16.8%      44214 ~11%  grantley/micro/aim7/shell_rtns_1
     37857 ~15%     +16.8%      44214 ~11%  TOTAL sched_debug.cpu#45.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       412 ~18%     +29.3%        533 ~ 5%  grantley/micro/aim7/shell_rtns_1
       412 ~18%     +29.3%        533 ~ 5%  TOTAL sched_debug.cpu#35.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       471 ~ 8%     +15.3%        543 ~ 2%  grantley/micro/aim7/shell_rtns_1
       471 ~ 8%     +15.3%        543 ~ 2%  TOTAL sched_debug.cpu#18.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       488 ~ 8%     +21.6%        593 ~ 6%  grantley/micro/aim7/shell_rtns_1
       488 ~ 8%     +21.6%        593 ~ 6%  TOTAL sched_debug.cfs_rq[42]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       480 ~ 6%     +16.5%        559 ~ 3%  grantley/micro/aim7/shell_rtns_1
       480 ~ 6%     +16.5%        559 ~ 3%  TOTAL sched_debug.cpu#34.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     38478 ~10%     +19.2%      45878 ~ 4%  grantley/micro/aim7/shell_rtns_1
     38478 ~10%     +19.2%      45878 ~ 4%  TOTAL sched_debug.cpu#43.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       479 ~ 4%     +18.3%        567 ~ 5%  grantley/micro/aim7/shell_rtns_1
       479 ~ 4%     +18.3%        567 ~ 5%  TOTAL sched_debug.cpu#51.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2586 ~20%     +29.8%       3357 ~ 8%  grantley/micro/aim7/disk_src
     30919 ~11%     +20.9%      37386 ~ 8%  grantley/micro/aim7/shell_rtns_1
     33506 ~12%     +21.6%      40743 ~ 8%  TOTAL sched_debug.cpu#17.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       435 ~ 7%     +16.7%        507 ~ 3%  grantley/micro/aim7/shell_rtns_1
       435 ~ 7%     +16.7%        507 ~ 3%  TOTAL sched_debug.cpu#27.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       457 ~ 3%     +16.1%        530 ~ 5%  grantley/micro/aim7/shell_rtns_1
       457 ~ 3%     +16.1%        530 ~ 5%  TOTAL sched_debug.cpu#53.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       514 ~ 3%     +17.9%        606 ~ 2%  grantley/micro/aim7/shell_rtns_1
       514 ~ 3%     +17.9%        606 ~ 2%  TOTAL sched_debug.cpu#45.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      5904 ~ 5%      -9.5%       5345 ~ 4%  grantley/micro/aim7/shell_rtns_1
      5904 ~ 5%      -9.5%       5345 ~ 4%  TOTAL slabinfo.proc_inode_cache.active_objs

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       454 ~ 6%     +18.3%        537 ~ 2%  grantley/micro/aim7/shell_rtns_1
       454 ~ 6%     +18.3%        537 ~ 2%  TOTAL sched_debug.cpu#20.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       671 ~ 9%     +26.2%        847 ~ 8%  grantley/micro/aim7/shell_rtns_1
       671 ~ 9%     +26.2%        847 ~ 8%  TOTAL sched_debug.cfs_rq[31]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       450 ~ 6%     +17.6%        530 ~ 5%  grantley/micro/aim7/shell_rtns_1
       450 ~ 6%     +17.6%        530 ~ 5%  TOTAL sched_debug.cpu#39.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       645 ~ 5%     +20.8%        780 ~ 9%  grantley/micro/aim7/shell_rtns_1
       645 ~ 5%     +20.8%        780 ~ 9%  TOTAL sched_debug.cpu#23.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       627 ~13%     +18.6%        744 ~ 7%  grantley/micro/aim7/shell_rtns_1
       627 ~13%     +18.6%        744 ~ 7%  TOTAL sched_debug.cfs_rq[24]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       516 ~ 5%     +16.8%        603 ~ 2%  grantley/micro/aim7/shell_rtns_1
       516 ~ 5%     +16.8%        603 ~ 2%  TOTAL sched_debug.cpu#55.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     37672 ~13%     +19.7%      45108 ~ 6%  grantley/micro/aim7/shell_rtns_1
     37672 ~13%     +19.7%      45108 ~ 6%  TOTAL sched_debug.cpu#53.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       514 ~ 4%     +17.2%        602 ~ 1%  grantley/micro/aim7/shell_rtns_1
       514 ~ 4%     +17.2%        602 ~ 1%  TOTAL sched_debug.cpu#41.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       487 ~ 5%     +15.7%        563 ~ 2%  grantley/micro/aim7/shell_rtns_1
       487 ~ 5%     +15.7%        563 ~ 2%  TOTAL sched_debug.cpu#37.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       490 ~ 5%     +16.7%        572 ~ 2%  grantley/micro/aim7/shell_rtns_1
       490 ~ 5%     +16.7%        572 ~ 2%  TOTAL sched_debug.cpu#41.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       463 ~ 6%     +19.8%        555 ~ 5%  grantley/micro/aim7/shell_rtns_1
       463 ~ 6%     +19.8%        555 ~ 5%  TOTAL sched_debug.cpu#49.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       656 ~14%     +21.3%        795 ~ 9%  grantley/micro/aim7/shell_rtns_1
       656 ~14%     +21.3%        795 ~ 9%  TOTAL sched_debug.cfs_rq[26]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     27030 ~ 2%     +19.1%      32185 ~ 1%  grantley/micro/aim7/shell_rtns_1
     27030 ~ 2%     +19.1%      32185 ~ 1%  TOTAL sched_debug.cfs_rq[44]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       435 ~18%     +26.0%        548 ~ 6%  grantley/micro/aim7/shell_rtns_1
       435 ~18%     +26.0%        548 ~ 6%  TOTAL sched_debug.cpu#54.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1495 ~ 1%     +17.4%       1755 ~ 0%  grantley/micro/aim7/disk_src
      1495 ~ 1%     +17.4%       1755 ~ 0%  TOTAL slabinfo.kmalloc-4096.num_objs

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     39492 ~12%     +17.8%      46541 ~ 8%  grantley/micro/aim7/shell_rtns_1
     39492 ~12%     +17.8%      46541 ~ 8%  TOTAL sched_debug.cpu#34.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     26842 ~ 4%     +16.8%      31343 ~ 0%  grantley/micro/aim7/shell_rtns_1
     26842 ~ 4%     +16.8%      31343 ~ 0%  TOTAL sched_debug.cfs_rq[29]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       453 ~ 7%     +16.9%        530 ~ 2%  grantley/micro/aim7/shell_rtns_1
       453 ~ 7%     +16.9%        530 ~ 2%  TOTAL sched_debug.cpu#26.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       465 ~ 7%     +17.3%        545 ~ 4%  grantley/micro/aim7/shell_rtns_1
       465 ~ 7%     +17.3%        545 ~ 4%  TOTAL sched_debug.cpu#46.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       549 ~ 6%     +20.8%        663 ~ 2%  grantley/micro/aim7/shell_rtns_1
       549 ~ 6%     +20.8%        663 ~ 2%  TOTAL sched_debug.cpu#30.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       477 ~ 8%     +16.6%        556 ~ 2%  grantley/micro/aim7/shell_rtns_1
       477 ~ 8%     +16.6%        556 ~ 2%  TOTAL sched_debug.cpu#17.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     58979 ~ 6%     +24.6%      73504 ~ 6%  grantley/micro/aim7/shell_rtns_1
     58979 ~ 6%     +24.6%      73504 ~ 6%  TOTAL sched_debug.cfs_rq[46]:/.min_vruntime

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       584 ~ 4%     +16.6%        681 ~ 0%  grantley/micro/aim7/shell_rtns_1
       584 ~ 4%     +16.6%        681 ~ 0%  TOTAL sched_debug.cfs_rq[29]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       509 ~ 2%     +16.0%        591 ~ 2%  grantley/micro/aim7/shell_rtns_1
       509 ~ 2%     +16.0%        591 ~ 2%  TOTAL sched_debug.cpu#53.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       588 ~ 2%     +18.9%        700 ~ 1%  grantley/micro/aim7/shell_rtns_1
       588 ~ 2%     +18.9%        700 ~ 1%  TOTAL sched_debug.cfs_rq[44]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     36451 ~11%     +24.0%      45200 ~ 7%  grantley/micro/aim7/shell_rtns_1
     36451 ~11%     +24.0%      45200 ~ 7%  TOTAL sched_debug.cpu#37.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       476 ~ 3%     +15.2%        548 ~ 2%  grantley/micro/aim7/shell_rtns_1
       476 ~ 3%     +15.2%        548 ~ 2%  TOTAL sched_debug.cpu#46.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       537 ~ 4%     +15.2%        619 ~ 2%  grantley/micro/aim7/shell_rtns_1
       537 ~ 4%     +15.2%        619 ~ 2%  TOTAL sched_debug.cpu#44.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       464 ~11%     +19.3%        554 ~ 5%  grantley/micro/aim7/shell_rtns_1
       464 ~11%     +19.3%        554 ~ 5%  TOTAL sched_debug.cpu#31.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     39653 ~ 2%     +17.7%      46657 ~ 4%  grantley/micro/aim7/shell_rtns_1
     39653 ~ 2%     +17.7%      46657 ~ 4%  TOTAL sched_debug.cpu#42.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       459 ~ 7%     +16.2%        533 ~ 3%  grantley/micro/aim7/shell_rtns_1
       459 ~ 7%     +16.2%        533 ~ 3%  TOTAL sched_debug.cpu#36.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       384 ~19%     +18.5%        455 ~ 8%  grantley/micro/aim7/shell_rtns_1
       384 ~19%     +18.5%        455 ~ 8%  TOTAL sched_debug.cpu#18.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       707 ~ 8%     +15.6%        818 ~ 4%  grantley/micro/aim7/shell_rtns_1
       707 ~ 8%     +15.6%        818 ~ 4%  TOTAL sched_debug.cpu#45.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       418 ~10%     +17.3%        490 ~ 5%  grantley/micro/aim7/shell_rtns_1
       418 ~10%     +17.3%        490 ~ 5%  TOTAL sched_debug.cpu#25.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       453 ~ 8%     +13.6%        515 ~ 5%  grantley/micro/aim7/shell_rtns_1
       453 ~ 8%     +13.6%        515 ~ 5%  TOTAL sched_debug.cpu#19.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       449 ~ 8%     +17.0%        525 ~ 5%  grantley/micro/aim7/shell_rtns_1
       449 ~ 8%     +17.0%        525 ~ 5%  TOTAL sched_debug.cpu#39.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       408 ~11%     +19.1%        487 ~ 6%  grantley/micro/aim7/shell_rtns_1
       408 ~11%     +19.1%        487 ~ 6%  TOTAL sched_debug.cfs_rq[6]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     40294 ~ 2%     +19.7%      48250 ~ 4%  grantley/micro/aim7/shell_rtns_1
     40294 ~ 2%     +19.7%      48250 ~ 4%  TOTAL sched_debug.cpu#39.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       490 ~ 5%     +14.9%        563 ~ 5%  grantley/micro/aim7/shell_rtns_1
       490 ~ 5%     +14.9%        563 ~ 5%  TOTAL sched_debug.cpu#52.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       687 ~11%     +19.1%        818 ~ 8%  grantley/micro/aim7/shell_rtns_1
       687 ~11%     +19.1%        818 ~ 8%  TOTAL sched_debug.cpu#52.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       456 ~ 9%     +14.6%        523 ~ 3%  grantley/micro/aim7/shell_rtns_1
       456 ~ 9%     +14.6%        523 ~ 3%  TOTAL sched_debug.cpu#35.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       526 ~ 5%     +14.3%        601 ~ 1%  grantley/micro/aim7/shell_rtns_1
       526 ~ 5%     +14.3%        601 ~ 1%  TOTAL sched_debug.cpu#36.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     13305 ~30%     -34.4%       8729 ~12%  grantley/micro/aim7/shell_rtns_1
     13305 ~30%     -34.4%       8729 ~12%  TOTAL sched_debug.cfs_rq[30]:/.blocked_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       494 ~ 7%     +19.6%        590 ~10%  grantley/micro/aim7/shell_rtns_1
       494 ~ 7%     +19.6%        590 ~10%  TOTAL sched_debug.cfs_rq[38]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       637 ~13%     +17.2%        747 ~ 9%  grantley/micro/aim7/shell_rtns_1
       637 ~13%     +17.2%        747 ~ 9%  TOTAL sched_debug.cfs_rq[14]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       472 ~ 9%     +19.8%        566 ~ 6%  grantley/micro/aim7/shell_rtns_1
       472 ~ 9%     +19.8%        566 ~ 6%  TOTAL sched_debug.cpu#7.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     41028 ~12%     +16.9%      47970 ~ 4%  grantley/micro/aim7/shell_rtns_1
     41028 ~12%     +16.9%      47970 ~ 4%  TOTAL sched_debug.cpu#0.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       524 ~ 3%     +15.1%        603 ~ 2%  grantley/micro/aim7/shell_rtns_1
       524 ~ 3%     +15.1%        603 ~ 2%  TOTAL sched_debug.cpu#47.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       483 ~ 8%     +23.3%        596 ~10%  grantley/micro/aim7/shell_rtns_1
       483 ~ 8%     +23.3%        596 ~10%  TOTAL sched_debug.cfs_rq[36]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       529 ~ 3%     +15.7%        612 ~ 1%  grantley/micro/aim7/shell_rtns_1
       529 ~ 3%     +15.7%        612 ~ 1%  TOTAL sched_debug.cpu#34.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       458 ~ 4%     +17.1%        537 ~ 5%  grantley/micro/aim7/shell_rtns_1
       458 ~ 4%     +17.1%        537 ~ 5%  TOTAL sched_debug.cpu#33.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       483 ~ 2%     +14.7%        555 ~ 3%  grantley/micro/aim7/shell_rtns_1
       483 ~ 2%     +14.7%        555 ~ 3%  TOTAL sched_debug.cpu#53.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       517 ~ 4%     +16.9%        605 ~ 2%  grantley/micro/aim7/shell_rtns_1
       517 ~ 4%     +16.9%        605 ~ 2%  TOTAL sched_debug.cpu#49.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       458 ~ 7%     +17.2%        537 ~ 2%  grantley/micro/aim7/shell_rtns_1
       458 ~ 7%     +17.2%        537 ~ 2%  TOTAL sched_debug.cpu#21.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2447 ~20%     +26.1%       3085 ~ 7%  grantley/micro/aim7/disk_src
     32689 ~15%     +17.4%      38364 ~ 6%  grantley/micro/aim7/shell_rtns_1
     35137 ~16%     +18.0%      41450 ~ 6%  TOTAL sched_debug.cpu#6.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       471 ~12%     +17.8%        555 ~ 4%  grantley/micro/aim7/shell_rtns_1
       471 ~12%     +17.8%        555 ~ 4%  TOTAL sched_debug.cpu#9.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       464 ~ 7%     +19.3%        554 ~ 2%  grantley/micro/aim7/shell_rtns_1
       464 ~ 7%     +19.3%        554 ~ 2%  TOTAL sched_debug.cpu#54.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      7741 ~16%     +23.4%       9555 ~ 6%  grantley/micro/aim7/disk_src
     45551 ~ 5%     +10.9%      50504 ~ 4%  grantley/micro/aim7/shell_rtns_1
     53292 ~ 6%     +12.7%      60059 ~ 4%  TOTAL sched_debug.cpu#2.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       491 ~ 6%     +16.8%        574 ~ 4%  grantley/micro/aim7/shell_rtns_1
       491 ~ 6%     +16.8%        574 ~ 4%  TOTAL sched_debug.cpu#44.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
  12327772 ~ 1%     +15.3%   14209139 ~ 0%  grantley/micro/aim7/shell_rtns_1
  12327772 ~ 1%     +15.3%   14209139 ~ 0%  TOTAL numa-vmstat.node0.numa_hit

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       458 ~ 7%     +22.9%        563 ~ 6%  grantley/micro/aim7/shell_rtns_1
       458 ~ 7%     +22.9%        563 ~ 6%  TOTAL sched_debug.cpu#55.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
  11943430 ~ 1%     +14.8%   13715837 ~ 0%  grantley/micro/aim7/shell_rtns_1
  11943430 ~ 1%     +14.8%   13715837 ~ 0%  TOTAL proc-vmstat.nr_tlb_local_flush_one

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       493 ~ 7%     +17.7%        581 ~ 4%  grantley/micro/aim7/shell_rtns_1
       493 ~ 7%     +17.7%        581 ~ 4%  TOTAL sched_debug.cpu#15.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    447520 ~ 1%     +14.9%     514074 ~ 0%  grantley/micro/aim7/shell_rtns_1
    447520 ~ 1%     +14.9%     514074 ~ 0%  TOTAL proc-vmstat.nr_tlb_local_flush_all

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       651 ~ 5%     +20.8%        786 ~ 9%  grantley/micro/aim7/shell_rtns_1
       651 ~ 5%     +20.8%        786 ~ 9%  TOTAL sched_debug.cfs_rq[23]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       498 ~ 4%     +14.2%        569 ~ 1%  grantley/micro/aim7/shell_rtns_1
       498 ~ 4%     +14.2%        569 ~ 1%  TOTAL sched_debug.cpu#46.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       536 ~ 7%     +17.7%        632 ~ 5%  grantley/micro/aim7/shell_rtns_1
       536 ~ 7%     +17.7%        632 ~ 5%  TOTAL sched_debug.cpu#0.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       517 ~ 4%     +14.2%        590 ~ 1%  grantley/micro/aim7/shell_rtns_1
       517 ~ 4%     +14.2%        590 ~ 1%  TOTAL sched_debug.cpu#48.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     28985 ~ 3%     +14.5%      33202 ~ 1%  grantley/micro/aim7/shell_rtns_1
     28985 ~ 3%     +14.5%      33202 ~ 1%  TOTAL sched_debug.cfs_rq[43]:/.avg->runnable_avg_sum

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       518 ~ 5%     +15.6%        599 ~ 1%  grantley/micro/aim7/shell_rtns_1
       518 ~ 5%     +15.6%        599 ~ 1%  TOTAL sched_debug.cpu#35.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       525 ~ 3%     +12.4%        590 ~ 1%  grantley/micro/aim7/shell_rtns_1
       525 ~ 3%     +12.4%        590 ~ 1%  TOTAL sched_debug.cpu#38.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       467 ~ 6%     +15.8%        541 ~ 6%  grantley/micro/aim7/shell_rtns_1
       467 ~ 6%     +15.8%        541 ~ 6%  TOTAL sched_debug.cpu#52.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       524 ~ 3%     +14.6%        600 ~ 2%  grantley/micro/aim7/shell_rtns_1
       524 ~ 3%     +14.6%        600 ~ 2%  TOTAL sched_debug.cpu#39.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       490 ~ 5%     +17.4%        576 ~ 2%  grantley/micro/aim7/shell_rtns_1
       490 ~ 5%     +17.4%        576 ~ 2%  TOTAL sched_debug.cpu#54.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       702 ~11%     +17.3%        824 ~ 8%  grantley/micro/aim7/shell_rtns_1
       702 ~11%     +17.3%        824 ~ 8%  TOTAL sched_debug.cpu#25.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       631 ~ 3%     +14.3%        721 ~ 1%  grantley/micro/aim7/shell_rtns_1
       631 ~ 3%     +14.3%        721 ~ 1%  TOTAL sched_debug.cfs_rq[43]:/.tg_runnable_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       490 ~ 8%     +16.7%        572 ~ 3%  grantley/micro/aim7/shell_rtns_1
       490 ~ 8%     +16.7%        572 ~ 3%  TOTAL sched_debug.cpu#6.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       474 ~ 5%     +13.4%        538 ~ 3%  grantley/micro/aim7/shell_rtns_1
       474 ~ 5%     +13.4%        538 ~ 3%  TOTAL sched_debug.cpu#39.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       452 ~10%     +11.2%        503 ~ 2%  grantley/micro/aim7/shell_rtns_1
       452 ~10%     +11.2%        503 ~ 2%  TOTAL sched_debug.cpu#18.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       505 ~ 4%     +14.2%        576 ~ 2%  grantley/micro/aim7/shell_rtns_1
       505 ~ 4%     +14.2%        576 ~ 2%  TOTAL sched_debug.cpu#33.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       396 ~12%     +15.4%        457 ~ 4%  grantley/micro/aim7/shell_rtns_1
       396 ~12%     +15.4%        457 ~ 4%  TOTAL sched_debug.cpu#24.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       459 ~ 5%     +16.3%        534 ~ 3%  grantley/micro/aim7/shell_rtns_1
       459 ~ 5%     +16.3%        534 ~ 3%  TOTAL sched_debug.cpu#48.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
        50 ~ 3%     -13.5%         44 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
        50 ~ 3%     -13.5%         44 ~ 0%  TOTAL turbostat.CTMP

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
        50 ~ 3%     -13.5%         44 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
        50 ~ 3%     -13.5%         44 ~ 0%  TOTAL turbostat.PTMP

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2583 ~14%     +16.6%       3012 ~ 8%  grantley/micro/aim7/disk_src
      2583 ~14%     +16.6%       3012 ~ 8%  TOTAL sched_debug.cpu#8.curr->pid

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       480 ~ 6%     +11.3%        535 ~ 1%  grantley/micro/aim7/shell_rtns_1
       480 ~ 6%     +11.3%        535 ~ 1%  TOTAL sched_debug.cpu#36.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
  12306441 ~ 1%     +14.6%   14105941 ~ 0%  grantley/micro/aim7/shell_rtns_1
  12306441 ~ 1%     +14.6%   14105941 ~ 0%  TOTAL numa-vmstat.node1.numa_hit

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       672 ~ 9%     +14.6%        770 ~ 6%  grantley/micro/aim7/shell_rtns_1
       672 ~ 9%     +14.6%        770 ~ 6%  TOTAL sched_debug.cpu#40.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       417 ~12%     +10.6%        461 ~ 4%  grantley/micro/aim7/shell_rtns_1
       417 ~12%     +10.6%        461 ~ 4%  TOTAL sched_debug.cpu#18.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      2921 ~ 3%     +13.2%       3306 ~ 1%  grantley/micro/aim7/shell_rtns_1
      2921 ~ 3%     +13.2%       3306 ~ 1%  TOTAL uptime.idle

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       492 ~ 4%     +16.5%        574 ~ 4%  grantley/micro/aim7/shell_rtns_1
       492 ~ 4%     +16.5%        574 ~ 4%  TOTAL sched_debug.cpu#49.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      5953 ~ 5%      -8.2%       5464 ~ 3%  grantley/micro/aim7/shell_rtns_1
      5953 ~ 5%      -8.2%       5464 ~ 3%  TOTAL slabinfo.proc_inode_cache.num_objs

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     29492 ~ 4%     +13.8%      33554 ~ 4%  grantley/micro/aim7/shell_rtns_1
     29492 ~ 4%     +13.8%      33554 ~ 4%  TOTAL proc-vmstat.nr_page_table_pages

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       507 ~ 6%     +11.2%        564 ~ 1%  grantley/micro/aim7/shell_rtns_1
       507 ~ 6%     +11.2%        564 ~ 1%  TOTAL sched_debug.cpu#36.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       423 ~12%     +21.7%        515 ~ 4%  grantley/micro/aim7/shell_rtns_1
       423 ~12%     +21.7%        515 ~ 4%  TOTAL sched_debug.cpu#38.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    118070 ~ 4%     +13.8%     134357 ~ 4%  grantley/micro/aim7/shell_rtns_1
    118070 ~ 4%     +13.8%     134357 ~ 4%  TOTAL meminfo.PageTables

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       495 ~ 9%     +15.6%        572 ~10%  grantley/micro/aim7/shell_rtns_1
       495 ~ 9%     +15.6%        572 ~10%  TOTAL sched_debug.cfs_rq[54]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       439 ~ 5%     +12.5%        494 ~ 3%  grantley/micro/aim7/shell_rtns_1
       439 ~ 5%     +12.5%        494 ~ 3%  TOTAL sched_debug.cpu#20.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       450 ~ 8%     +18.9%        535 ~ 7%  grantley/micro/aim7/shell_rtns_1
       450 ~ 8%     +18.9%        535 ~ 7%  TOTAL sched_debug.cpu#50.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       493 ~ 6%     +13.1%        557 ~ 2%  grantley/micro/aim7/shell_rtns_1
       493 ~ 6%     +13.1%        557 ~ 2%  TOTAL sched_debug.cpu#35.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       520 ~ 4%     +13.5%        591 ~ 3%  grantley/micro/aim7/shell_rtns_1
       520 ~ 4%     +13.5%        591 ~ 3%  TOTAL sched_debug.cpu#44.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
  12254990 ~ 1%     +14.2%   13989904 ~ 0%  grantley/micro/aim7/shell_rtns_1
  12254990 ~ 1%     +14.2%   13989904 ~ 0%  TOTAL numa-vmstat.node1.numa_local

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       650 ~14%     +20.3%        782 ~ 9%  grantley/micro/aim7/shell_rtns_1
       650 ~14%     +20.3%        782 ~ 9%  TOTAL sched_debug.cpu#26.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       522 ~ 4%     +15.1%        601 ~ 2%  grantley/micro/aim7/shell_rtns_1
       522 ~ 4%     +15.1%        601 ~ 2%  TOTAL sched_debug.cpu#42.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       458 ~16%     +22.1%        559 ~ 5%  grantley/micro/aim7/shell_rtns_1
       458 ~16%     +22.1%        559 ~ 5%  TOTAL sched_debug.cfs_rq[4]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       503 ~ 8%     +17.5%        591 ~ 5%  grantley/micro/aim7/shell_rtns_1
       503 ~ 8%     +17.5%        591 ~ 5%  TOTAL sched_debug.cpu#5.cpu_load[1]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       492 ~ 4%     +14.6%        565 ~ 3%  grantley/micro/aim7/shell_rtns_1
       492 ~ 4%     +14.6%        565 ~ 3%  TOTAL sched_debug.cpu#45.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       468 ~ 7%     +13.8%        533 ~ 5%  grantley/micro/aim7/shell_rtns_1
       468 ~ 7%     +13.8%        533 ~ 5%  TOTAL sched_debug.cpu#45.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       616 ~14%     +20.2%        741 ~ 9%  grantley/micro/aim7/shell_rtns_1
       616 ~14%     +20.2%        741 ~ 9%  TOTAL sched_debug.cpu#14.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       731 ~ 7%     +12.8%        824 ~ 5%  grantley/micro/aim7/shell_rtns_1
       731 ~ 7%     +12.8%        824 ~ 5%  TOTAL sched_debug.cfs_rq[45]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       476 ~13%     +20.8%        575 ~ 7%  grantley/micro/aim7/shell_rtns_1
       476 ~13%     +20.8%        575 ~ 7%  TOTAL sched_debug.cfs_rq[40]:/.runnable_load_avg

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       462 ~ 4%     +13.6%        525 ~ 2%  grantley/micro/aim7/shell_rtns_1
       462 ~ 4%     +13.6%        525 ~ 2%  TOTAL sched_debug.cpu#12.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       492 ~ 4%     +13.1%        556 ~ 2%  grantley/micro/aim7/shell_rtns_1
       492 ~ 4%     +13.1%        556 ~ 2%  TOTAL sched_debug.cpu#48.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
 1.093e+08 ~ 0%     -10.4%   97876809 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
 1.093e+08 ~ 0%     -10.4%   97876809 ~ 0%  TOTAL numa-numastat.node2.numa_hit

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
 1.093e+08 ~ 0%     -10.4%   97876808 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
 1.093e+08 ~ 0%     -10.4%   97876808 ~ 0%  TOTAL numa-numastat.node2.local_node

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     48415 ~ 4%     +11.3%      53902 ~ 4%  grantley/micro/aim7/shell_rtns_1
     48415 ~ 4%     +11.3%      53902 ~ 4%  TOTAL sched_debug.cpu#43.nr_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     13922 ~29%     -32.2%       9446 ~11%  grantley/micro/aim7/shell_rtns_1
     13922 ~29%     -32.2%       9446 ~11%  TOTAL sched_debug.cfs_rq[30]:/.tg_load_contrib

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       705 ~ 9%     +16.5%        821 ~ 8%  grantley/micro/aim7/shell_rtns_1
       705 ~ 9%     +16.5%        821 ~ 8%  TOTAL sched_debug.cfs_rq[52]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9702 ~ 1%     +11.4%      10809 ~ 1%  grantley/micro/aim7/shell_rtns_1
      9702 ~ 1%     +11.4%      10809 ~ 1%  TOTAL slabinfo.mm_struct.active_objs

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      9777 ~ 1%     +11.5%      10899 ~ 1%  grantley/micro/aim7/shell_rtns_1
      9777 ~ 1%     +11.5%      10899 ~ 1%  TOTAL slabinfo.mm_struct.num_objs

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       622 ~13%     +17.0%        728 ~ 6%  grantley/micro/aim7/shell_rtns_1
       622 ~13%     +17.0%        728 ~ 6%  TOTAL sched_debug.cpu#24.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       719 ~14%     +18.2%        850 ~ 5%  grantley/micro/aim7/shell_rtns_1
       719 ~14%     +18.2%        850 ~ 5%  TOTAL sched_debug.cfs_rq[18]:/.load

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       503 ~ 4%     +12.2%        565 ~ 2%  grantley/micro/aim7/shell_rtns_1
       503 ~ 4%     +12.2%        565 ~ 2%  TOTAL sched_debug.cpu#39.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       458 ~10%     +23.3%        565 ~13%  grantley/micro/aim7/shell_rtns_1
       458 ~10%     +23.3%        565 ~13%  TOTAL sched_debug.cpu#55.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       480 ~ 4%     +13.3%        544 ~ 3%  grantley/micro/aim7/shell_rtns_1
       480 ~ 4%     +13.3%        544 ~ 3%  TOTAL sched_debug.cpu#33.cpu_load[2]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       504 ~ 4%     +12.3%        567 ~ 3%  grantley/micro/aim7/shell_rtns_1
       504 ~ 4%     +12.3%        567 ~ 3%  TOTAL sched_debug.cpu#47.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       510 ~ 4%     +14.1%        582 ~ 2%  grantley/micro/aim7/shell_rtns_1
       510 ~ 4%     +14.1%        582 ~ 2%  TOTAL sched_debug.cpu#34.cpu_load[3]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       449 ~18%     +21.1%        544 ~ 8%  grantley/micro/aim7/shell_rtns_1
       449 ~18%     +21.1%        544 ~ 8%  TOTAL sched_debug.cpu#47.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       496 ~12%     +11.7%        554 ~ 6%  grantley/micro/aim7/shell_rtns_1
       496 ~12%     +11.7%        554 ~ 6%  TOTAL sched_debug.cpu#6.cpu_load[0]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
  79369234 ~ 0%     -10.0%   71457102 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
  79369234 ~ 0%     -10.0%   71457102 ~ 0%  TOTAL numa-numastat.node3.numa_hit

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
  79369234 ~ 0%     -10.0%   71457102 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
  79369234 ~ 0%     -10.0%   71457102 ~ 0%  TOTAL numa-numastat.node3.local_node

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       575 ~ 4%     +10.6%        636 ~ 1%  grantley/micro/aim7/shell_rtns_1
       575 ~ 4%     +10.6%        636 ~ 1%  TOTAL sched_debug.cpu#43.cpu_load[4]

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
 1.427e+08 ~ 0%      -9.5%  1.291e+08 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
 1.427e+08 ~ 0%      -9.5%  1.291e+08 ~ 0%  TOTAL numa-numastat.node1.numa_hit

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
 1.427e+08 ~ 0%      -9.5%  1.291e+08 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
 1.427e+08 ~ 0%      -9.5%  1.291e+08 ~ 0%  TOTAL numa-numastat.node1.local_node

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
   2924010 ~ 1%     +10.5%    3229764 ~ 0%  grantley/micro/aim7/shell_rtns_1
   2924010 ~ 1%     +10.5%    3229764 ~ 0%  TOTAL meminfo.Committed_AS

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     12078 ~ 2%     +10.9%      13393 ~ 1%  grantley/micro/aim7/shell_rtns_1
     12078 ~ 2%     +10.9%      13393 ~ 1%  TOTAL slabinfo.files_cache.active_objs

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    157683 ~ 0%     +10.7%     174574 ~ 0%  grantley/micro/aim7/shell_rtns_1
    157683 ~ 0%     +10.7%     174574 ~ 0%  TOTAL meminfo.Active(anon)

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     39407 ~ 1%     +10.7%      43619 ~ 0%  grantley/micro/aim7/shell_rtns_1
     39407 ~ 1%     +10.7%      43619 ~ 0%  TOTAL proc-vmstat.nr_active_anon

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     12174 ~ 2%     +11.0%      13512 ~ 1%  grantley/micro/aim7/shell_rtns_1
     12174 ~ 2%     +11.0%      13512 ~ 1%  TOTAL slabinfo.files_cache.num_objs

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    295.87 ~14%     +77.4%     524.87 ~ 8%  grantley/micro/aim7/disk_src
     50.06 ~ 2%   +1976.2%    1039.33 ~ 0%  grantley/micro/aim7/shell_rtns_1
   1802.12 ~ 0%      -9.0%    1639.20 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
   2148.05 ~ 2%     +49.1%    3203.40 ~ 2%  TOTAL time.system_time

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     18.14 ~ 2%     +64.9%      29.91 ~ 1%  grantley/micro/aim7/disk_src
      7.42 ~ 3%   +7035.9%     529.77 ~ 0%  grantley/micro/aim7/shell_rtns_1
     60.92 ~ 9%     -14.2%      52.27 ~ 4%  lkp-sbx04/micro/will-it-scale/page_fault1
     86.49 ~ 7%    +607.6%     611.95 ~ 1%  TOTAL time.user_time

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1476 ~12%     +23.7%       1826 ~ 6%  grantley/micro/aim7/disk_src
       150 ~ 1%   +1491.6%       2393 ~ 0%  grantley/micro/aim7/shell_rtns_1
       598 ~ 0%      -9.4%        542 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
      2225 ~ 8%    +114.0%       4762 ~ 3%  TOTAL time.percent_of_cpu_this_job_got

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      7712 ~30%     +55.3%      11976 ~16%  grantley/micro/aim7/disk_src
      7712 ~30%     +55.3%      11976 ~16%  TOTAL time.involuntary_context_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    340221 ~29%     +49.6%     508802 ~16%  grantley/micro/aim7/disk_src
    217154 ~ 1%     -31.8%     148054 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
    557376 ~18%     +17.8%     656856 ~12%  TOTAL time.voluntary_context_switches

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
    153391 ~ 4%     -38.0%      95040 ~ 3%  grantley/micro/aim7/shell_rtns_1
      3171 ~ 0%     -23.0%       2443 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
    156562 ~ 4%     -37.7%      97483 ~ 3%  TOTAL vmstat.system.cs

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     21.21 ~ 1%     +43.0%      30.33 ~ 1%  grantley/micro/aim7/disk_src
     38.10 ~ 1%     +72.0%      65.53 ~ 0%  grantley/micro/aim7/shell_rtns_1
    310.99 ~ 0%      +0.2%     311.68 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
    370.30 ~ 0%     +10.1%     407.54 ~ 0%  TOTAL time.elapsed_time

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      0.35 ~ 2%     +73.3%       0.61 ~ 3%  lkp-sb03/micro/netperf/120s-200%-SCTP_STREAM
     35.36 ~ 0%      -4.0%      33.96 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
     35.72 ~ 0%      -3.2%      34.57 ~ 0%  TOTAL turbostat.%c0

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
 1.384e+08 ~ 0%     -25.6%  1.029e+08 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
 1.384e+08 ~ 0%     -25.6%  1.029e+08 ~ 0%  TOTAL time.minor_page_faults

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     18.38 ~ 1%     +23.5%      22.70 ~ 1%  lkp-sb03/micro/netperf/120s-200%-SCTP_STREAM
     18.38 ~ 1%     +23.5%      22.70 ~ 1%  TOTAL boottime.dhcp

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      6.53 ~ 4%     -12.0%       5.75 ~ 2%  lkp-sb03/micro/netperf/120s-200%-SCTP_STREAM
    147.93 ~ 0%     -23.3%     113.40 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
    154.46 ~ 0%     -22.9%     119.15 ~ 0%  TOTAL turbostat.Cor_W

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
       203 ~ 0%     -17.0%        169 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
       203 ~ 0%     -17.0%        169 ~ 0%  TOTAL turbostat.Pkg_W

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
      1681 ~ 4%      +5.5%       1774 ~ 1%  grantley/micro/aim7/shell_rtns_1
       781 ~ 3%     +22.7%        958 ~ 2%  lkp-sb03/micro/netperf/120s-200%-SCTP_STREAM
      2462 ~ 4%     +11.0%       2733 ~ 2%  TOTAL boottime.idle

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     27981 ~11%     -20.4%      22282 ~ 5%  grantley/micro/aim7/shell_rtns_1
      7241 ~ 0%      -7.0%       6735 ~ 0%  lkp-sbx04/micro/will-it-scale/page_fault1
     35223 ~ 9%     -17.6%      29017 ~ 4%  TOTAL vmstat.system.in

      v3.14-rc1  fcb6a15c2e7e76d493e6f91ea  
---------------  -------------------------  
     35.43 ~ 3%      +5.4%      37.35 ~ 1%  grantley/micro/aim7/shell_rtns_1
     29.46 ~ 2%     +19.0%      35.05 ~ 2%  lkp-sb03/micro/netperf/120s-200%-SCTP_STREAM
     64.89 ~ 3%     +11.6%      72.40 ~ 1%  TOTAL boottime.boot


--y0ulUmNC+osPPQO6--
