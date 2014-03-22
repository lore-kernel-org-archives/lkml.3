Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbaCVL4d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 07:56:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:49865 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbaCVL4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 07:56:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,709,1389772800"; 
   d="scan'208";a="497389103"
Date: Sat, 22 Mar 2014 19:56:36 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [rcuwalk] e2a728c2785: -29.4% aim7.2000.jobs-per-min, +71%
 turbostat.Pkg_W
Message-ID: <20140322115636.GA14400@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

We noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git untested-mnt_hash
commit e2a728c2785d6aab45d1a6d2c61e986d385c30bf ("rcuwalk: recheck mount_lock after mountpoint crossing attempts")

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    395126 ~ 1%     -34.2%     259849 ~ 2%  grantley/micro/aim7/disk_src
    190311 ~ 1%     -37.9%     118138 ~ 2%  grantley/micro/aim7/shell_rtns_1
    383828 ~ 0%      -2.4%     374511 ~ 0%  grantley/micro/aim7/string_rtns
    157829 ~ 0%     -72.6%      43187 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
   1127096 ~ 1%     -29.4%     795687 ~ 1%  TOTAL aim7.2000.jobs-per-min

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      2980 ~ 0%     -46.7%       1587 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
      2980 ~ 0%     -46.7%       1587 ~ 2%  TOTAL netperf.Throughput_tps

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     12683 ~23%     -87.3%       1614 ~46%  lkp-wsx01/micro/aim7/shell_rtns_1
     12683 ~23%     -87.3%       1614 ~46%  TOTAL numa-vmstat.node3.nr_kernel_stack

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     22502 ~31%     -95.6%        999 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
     22502 ~31%     -95.6%        999 ~ 1%  TOTAL slabinfo.kmalloc-192.num_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      2167 ~22%     -83.1%        365 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
      2167 ~22%     -83.1%        365 ~ 0%  TOTAL slabinfo.signal_cache.active_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     13718 ~27%     -88.2%       1621 ~46%  lkp-wsx01/micro/aim7/shell_rtns_1
     13718 ~27%     -88.2%       1621 ~46%  TOTAL numa-vmstat.node2.nr_kernel_stack

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     14796 ~21%     -90.1%       1464 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
     14796 ~21%     -90.1%       1464 ~ 1%  TOTAL slabinfo.dentry.num_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     14796 ~21%     -90.1%       1464 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
     14796 ~21%     -90.1%       1464 ~ 1%  TOTAL slabinfo.dentry.active_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    621458 ~21%     -90.1%      61513 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
    621458 ~21%     -90.1%      61513 ~ 1%  TOTAL slabinfo.dentry.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
 2.641e+08 ~ 4%     -99.0%    2722154 ~26%  grantley/micro/aim7/disk_src
  51149646 ~10%     -94.5%    2826487 ~25%  grantley/micro/aim7/shell_rtns_1
 3.153e+08 ~ 5%     -98.2%    5548642 ~26%  TOTAL cpuidle.C1-HSW.time

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    329548 ~13%     -99.7%       1143 ~13%  grantley/micro/aim7/disk_src
    225362 ~15%     -98.8%       2708 ~33%  grantley/micro/aim7/shell_rtns_1
    554911 ~14%     -99.3%       3851 ~27%  TOTAL cpuidle.C1-HSW.usage

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    105147 ~21%     -87.0%      13701 ~44%  lkp-wsx01/micro/aim7/shell_rtns_1
    105147 ~21%     -87.0%      13701 ~44%  TOTAL numa-meminfo.node0.KernelStack

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    611075 ~21%     -89.9%      61509 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
    611075 ~21%     -89.9%      61509 ~ 1%  TOTAL slabinfo.dentry.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
       747 ~ 5%   +1722.9%      13617 ~ 9%  lkp-wsx01/micro/aim7/shell_rtns_1
       747 ~ 5%   +1722.9%      13617 ~ 9%  TOTAL interrupts.IWI

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     78043 ~ 3%     -80.3%      15409 ~ 8%  grantley/micro/aim7/disk_src
    183980 ~16%     -94.3%      10524 ~ 8%  grantley/micro/aim7/shell_rtns_1
    262024 ~12%     -90.1%      25934 ~ 8%  TOTAL cpuidle.C6-HSW.usage

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      2167 ~22%     -83.1%        365 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
      2167 ~22%     -83.1%        365 ~ 0%  TOTAL slabinfo.signal_cache.num_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     60879 ~ 6%     -99.5%        291 ~18%  grantley/micro/aim7/shell_rtns_1
     60879 ~ 6%     -99.5%        291 ~18%  TOTAL interrupts.TLB

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     13175 ~21%     -87.0%       1712 ~44%  lkp-wsx01/micro/aim7/shell_rtns_1
     13175 ~21%     -87.0%       1712 ~44%  TOTAL numa-vmstat.node0.nr_kernel_stack

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
 1.471e+08 ~ 2%     -99.3%    1006392 ~37%  grantley/micro/aim7/shell_rtns_1
 1.471e+08 ~ 2%     -99.3%    1006392 ~37%  TOTAL cpuidle.C1E-HSW.time

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     22502 ~31%     -95.6%        999 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
     22502 ~31%     -95.6%        999 ~ 1%  TOTAL slabinfo.kmalloc-192.active_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      6789 ~ 7%     -89.7%        699 ~27%  lkp-wsx01/micro/aim7/shell_rtns_1
      6789 ~ 7%     -89.7%        699 ~27%  TOTAL cpuidle.C1E-NHM.usage

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     29.35 ~ 2%     -92.4%       2.24 ~13%  grantley/micro/aim7/disk_src
     15.12 ~ 5%     -98.3%       0.26 ~10%  grantley/micro/aim7/shell_rtns_1
      0.50 ~10%     -90.5%       0.05 ~ 8%  lkp-wsx01/micro/aim7/shell_rtns_1
     44.97 ~ 3%     -94.3%       2.55 ~12%  TOTAL turbostat.%c1

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      0.00           +Inf%      11.52 ~ 1%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
      0.00           +Inf%      11.52 ~ 1%  TOTAL perf-profile.cpu-cycles._raw_spin_lock.__d_lookup.lookup_fast.do_last.path_openat

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
         4 ~35%    -100.0%          0 ~ 0%  grantley/micro/aim7/disk_src
        23 ~ 9%    -100.0%          0 ~ 0%  grantley/micro/aim7/shell_rtns_1
        27 ~13%    -100.0%          0 ~ 0%  TOTAL cpuidle.POLL.usage

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    102041 ~23%     -87.3%      12959 ~46%  lkp-wsx01/micro/aim7/shell_rtns_1
    102041 ~23%     -87.3%      12959 ~46%  TOTAL numa-meminfo.node3.KernelStack

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      0.00           +Inf%      11.26 ~ 3%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
      0.00           +Inf%      11.26 ~ 3%  TOTAL perf-profile.cpu-cycles._raw_spin_lock.lockref_put_or_lock.dput.__fput.____fput

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    110293 ~27%     -88.2%      13026 ~46%  lkp-wsx01/micro/aim7/shell_rtns_1
    110293 ~27%     -88.2%      13026 ~46%  TOTAL numa-meminfo.node2.KernelStack

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
        89 ~49%    -100.0%          0 ~ 0%  grantley/micro/aim7/disk_src
       663 ~18%    -100.0%          0 ~ 0%  grantley/micro/aim7/shell_rtns_1
       752 ~22%    -100.0%          0 ~ 0%  TOTAL cpuidle.POLL.time

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      0.00           +Inf%      11.07 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
      0.00           +Inf%      11.07 ~ 2%  TOTAL perf-profile.cpu-cycles._raw_spin_lock.lockref_get.path_get.do_dentry_open.finish_open

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
   1384473 ~29%     -95.3%      65064 ~40%  lkp-wsx01/micro/aim7/shell_rtns_1
   1384473 ~29%     -95.3%      65064 ~40%  TOTAL cpuidle.C1-NHM.time

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      4501 ~20%     -87.2%        576 ~36%  lkp-wsx01/micro/aim7/shell_rtns_1
      4501 ~20%     -87.2%        576 ~36%  TOTAL cpuidle.C1-NHM.usage

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
   2471092 ~11%     -97.5%      62093 ~17%  lkp-wsx01/micro/aim7/shell_rtns_1
   2471092 ~11%     -97.5%      62093 ~17%  TOTAL cpuidle.C1E-NHM.time

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      0.00           +Inf%      11.14 ~ 3%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
      0.00           +Inf%      11.14 ~ 3%  TOTAL perf-profile.cpu-cycles._raw_spin_lock.lockref_put_or_lock.dput.path_put.terminate_walk

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      0.23 ~26%     -73.3%       0.06 ~34%  lkp-wsx01/micro/aim7/shell_rtns_1
      0.23 ~26%     -73.3%       0.06 ~34%  TOTAL turbostat.%c3

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      1363 ~15%     -75.0%        340 ~25%  grantley/micro/aim7/disk_src
    481021 ~ 7%     -99.6%       1963 ~28%  grantley/micro/aim7/shell_rtns_1
    482385 ~ 7%     -99.5%       2304 ~27%  TOTAL cpuidle.C1E-HSW.usage

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      6977 ~11%     -75.9%       1681 ~ 6%  grantley/micro/aim7/disk_src
    592870 ~ 5%     -99.4%       3369 ~ 7%  grantley/micro/aim7/shell_rtns_1
    599848 ~ 5%     -99.2%       5050 ~ 7%  TOTAL cpuidle.C3-HSW.usage

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
        17 ~ 7%    +534.5%        110 ~ 4%  grantley/micro/aim7/disk_src
        44 ~ 2%    +409.5%        225 ~ 4%  grantley/micro/aim7/shell_rtns_1
       209 ~ 4%    +207.4%        642 ~ 7%  lkp-wsx01/micro/aim7/shell_rtns_1
       270 ~ 4%    +261.4%        978 ~ 6%  TOTAL vmstat.procs.r

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
 2.456e+08 ~12%     -97.3%    6594906 ~45%  grantley/micro/aim7/shell_rtns_1
 2.456e+08 ~12%     -97.3%    6594906 ~45%  TOTAL cpuidle.C3-HSW.time

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     49244 ~28%     -72.9%      13365 ~28%  lkp-wsx01/micro/aim7/shell_rtns_1
     49244 ~28%     -72.9%      13365 ~28%  TOTAL numa-vmstat.node2.nr_slab_unreclaimable

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    196740 ~28%     -72.8%      53475 ~28%  lkp-wsx01/micro/aim7/shell_rtns_1
    196740 ~28%     -72.8%      53475 ~28%  TOTAL numa-meminfo.node2.SUnreclaim

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     14776 ~45%     +84.6%      27283 ~26%  grantley/micro/aim7/shell_rtns_1
    108458 ~20%     -85.1%      16153 ~45%  lkp-wsx01/micro/aim7/shell_rtns_1
    123234 ~23%     -64.8%      43437 ~33%  TOTAL numa-meminfo.node1.KernelStack

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      1837 ~44%     +84.7%       3393 ~26%  grantley/micro/aim7/shell_rtns_1
     13576 ~21%     -85.2%       2005 ~45%  lkp-wsx01/micro/aim7/shell_rtns_1
     15413 ~24%     -65.0%       5399 ~33%  TOTAL numa-vmstat.node1.nr_kernel_stack

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    237898 ~26%     -71.8%      66988 ~22%  lkp-wsx01/micro/aim7/shell_rtns_1
    237898 ~26%     -71.8%      66988 ~22%  TOTAL numa-meminfo.node2.Slab

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    187410 ~20%     -71.6%      53204 ~27%  lkp-wsx01/micro/aim7/shell_rtns_1
    187410 ~20%     -71.6%      53204 ~27%  TOTAL numa-meminfo.node0.SUnreclaim

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    182221 ~22%     -73.1%      49066 ~26%  lkp-wsx01/micro/aim7/shell_rtns_1
    182221 ~22%     -73.1%      49066 ~26%  TOTAL numa-meminfo.node3.SUnreclaim

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     47071 ~21%     -71.8%      13297 ~27%  lkp-wsx01/micro/aim7/shell_rtns_1
     47071 ~21%     -71.8%      13297 ~27%  TOTAL numa-vmstat.node0.nr_slab_unreclaimable

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     45606 ~23%     -73.1%      12282 ~26%  lkp-wsx01/micro/aim7/shell_rtns_1
     45606 ~23%     -73.1%      12282 ~26%  TOTAL numa-vmstat.node3.nr_slab_unreclaimable

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     12.07 ~ 0%     -72.4%       3.33 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
     12.07 ~ 0%     -72.4%       3.33 ~ 0%  TOTAL turbostat.%pc3

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    221908 ~21%     -72.2%      61632 ~18%  lkp-wsx01/micro/aim7/shell_rtns_1
    221908 ~21%     -72.2%      61632 ~18%  TOTAL numa-meminfo.node3.Slab

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     48292 ~42%    +146.4%     119010 ~20%  grantley/micro/aim7/shell_rtns_1
     48292 ~42%    +146.4%     119010 ~20%  TOTAL numa-meminfo.node1.PageTables

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     12086 ~43%    +145.2%      29636 ~20%  grantley/micro/aim7/shell_rtns_1
     12086 ~43%    +145.2%      29636 ~20%  TOTAL numa-vmstat.node1.nr_page_table_pages

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     68877 ~ 7%    +326.1%     293515 ~ 2%  grantley/micro/aim7/shell_rtns_1
     55620 ~ 7%    +181.2%     156385 ~ 8%  lkp-wsx01/micro/aim7/shell_rtns_1
    124498 ~ 7%    +261.4%     449901 ~ 4%  TOTAL numa-meminfo.node1.AnonPages

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     17237 ~ 8%    +324.2%      73111 ~ 1%  grantley/micro/aim7/shell_rtns_1
     13979 ~ 6%    +178.0%      38857 ~ 8%  lkp-wsx01/micro/aim7/shell_rtns_1
     31217 ~ 7%    +258.7%     111968 ~ 4%  TOTAL numa-vmstat.node1.nr_anon_pages

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      2113 ~22%     -74.4%        541 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
      2113 ~22%     -74.4%        541 ~ 1%  TOTAL slabinfo.kmalloc-512.active_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      2113 ~22%     -74.4%        541 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
      2113 ~22%     -74.4%        541 ~ 1%  TOTAL slabinfo.kmalloc-512.num_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     67631 ~22%     -74.3%      17348 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
     67631 ~22%     -74.3%      17348 ~ 1%  TOTAL slabinfo.kmalloc-512.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
  11810487 ~ 0%     -45.3%    6462482 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
    104283 ~11%   +1972.4%    2161157 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
  11914771 ~ 0%     -27.6%    8623639 ~ 1%  TOTAL softirqs.RCU

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     37047 ~ 2%    +297.1%     147122 ~ 1%  grantley/micro/aim7/shell_rtns_1
     58696 ~ 2%    +168.3%     157481 ~ 3%  lkp-wsx01/micro/aim7/shell_rtns_1
     95744 ~ 2%    +218.1%     304603 ~ 2%  TOTAL proc-vmstat.nr_anon_pages

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    148067 ~ 2%    +296.6%     587309 ~ 1%  grantley/micro/aim7/shell_rtns_1
    235601 ~ 3%    +167.1%     629209 ~ 3%  lkp-wsx01/micro/aim7/shell_rtns_1
    383669 ~ 3%    +217.1%    1216518 ~ 2%  TOTAL meminfo.AnonPages

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     79144 ~ 5%    +271.8%     294233 ~ 2%  grantley/micro/aim7/shell_rtns_1
     53935 ~ 5%    +185.7%     154092 ~ 7%  lkp-wsx01/micro/aim7/shell_rtns_1
    133079 ~ 5%    +236.9%     448326 ~ 4%  TOTAL numa-meminfo.node0.AnonPages

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    226257 ~19%     -70.2%      67410 ~21%  lkp-wsx01/micro/aim7/shell_rtns_1
    226257 ~19%     -70.2%      67410 ~21%  TOTAL numa-meminfo.node0.Slab

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    261563 ~11%     -76.5%      61519 ~ 2%  grantley/micro/aim7/disk_src
    885837 ~ 7%     -64.4%     315615 ~ 1%  grantley/micro/aim7/shell_rtns_1
    820916 ~ 0%     -63.8%     297218 ~ 3%  lkp-wsx01/micro/aim7/shell_rtns_1
   1968316 ~ 5%     -65.7%     674354 ~ 2%  TOTAL interrupts.RES

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     19813 ~ 5%    +269.8%      73278 ~ 2%  grantley/micro/aim7/shell_rtns_1
     13492 ~ 5%    +183.7%      38281 ~ 8%  lkp-wsx01/micro/aim7/shell_rtns_1
     33305 ~ 5%    +235.0%     111559 ~ 4%  TOTAL numa-vmstat.node0.nr_anon_pages

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     59995 ~19%     -71.5%      17106 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
     59995 ~19%     -71.5%      17106 ~ 1%  TOTAL slabinfo.kmalloc-512.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      4976 ~ 1%     +31.5%       6543 ~ 1%  grantley/micro/aim7/shell_rtns_1
     54140 ~22%     -86.8%       7124 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
     59117 ~20%     -76.9%      13667 ~ 1%  TOTAL proc-vmstat.nr_kernel_stack

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     39796 ~ 1%     +31.4%      52278 ~ 1%  grantley/micro/aim7/shell_rtns_1
    421773 ~21%     -86.5%      56891 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
    461569 ~19%     -76.3%     109169 ~ 0%  TOTAL meminfo.KernelStack

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      5546 ~ 0%     +27.8%       7087 ~ 1%  grantley/micro/aim7/shell_rtns_1
     56799 ~20%     -86.3%       7771 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
     62346 ~19%     -76.2%      14858 ~ 1%  TOTAL slabinfo.task_struct.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
       421 ~ 0%     +28.6%        542 ~ 2%  grantley/micro/aim7/shell_rtns_1
      4445 ~23%     -86.6%        597 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
      4867 ~21%     -76.6%       1140 ~ 1%  TOTAL slabinfo.task_struct.active_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
       421 ~ 0%     +28.6%        542 ~ 2%  grantley/micro/aim7/shell_rtns_1
      4445 ~23%     -86.6%        597 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
      4867 ~21%     -76.6%       1140 ~ 1%  TOTAL slabinfo.task_struct.num_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      5913 ~ 0%     +28.6%       7602 ~ 2%  grantley/micro/aim7/shell_rtns_1
     62245 ~23%     -86.5%       8377 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
     68159 ~21%     -76.6%      15979 ~ 1%  TOTAL slabinfo.task_struct.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     39568 ~16%     -69.6%      12020 ~ 8%  lkp-wsx01/micro/aim7/shell_rtns_1
     39568 ~16%     -69.6%      12020 ~ 8%  TOTAL numa-meminfo.node1.SReclaimable

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      8738 ~ 4%     +23.6%      10799 ~ 8%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
     29194 ~ 7%     -93.8%       1816 ~ 9%  lkp-wsx01/micro/aim7/shell_rtns_1
     37932 ~ 6%     -66.7%      12615 ~ 9%  TOTAL cpuidle.C3-NHM.usage

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      9912 ~17%     -69.7%       3006 ~ 8%  lkp-wsx01/micro/aim7/shell_rtns_1
      9912 ~17%     -69.7%       3006 ~ 8%  TOTAL numa-vmstat.node1.nr_slab_reclaimable

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      7566 ~ 0%     +14.9%       8690 ~ 0%  grantley/micro/aim7/shell_rtns_1
     65043 ~22%     -83.1%      10981 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
     72609 ~20%     -72.9%      19671 ~ 0%  TOTAL slabinfo.signal_cache.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      7387 ~ 0%     +12.6%       8317 ~ 1%  grantley/micro/aim7/shell_rtns_1
     57956 ~20%     -81.5%      10709 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
     65343 ~18%     -70.9%      19027 ~ 0%  TOTAL slabinfo.signal_cache.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     29054 ~ 1%     +12.8%      32759 ~ 1%  grantley/micro/aim7/shell_rtns_1
    945145 ~31%     -95.6%      41976 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
    974200 ~30%     -92.3%      74735 ~ 1%  TOTAL slabinfo.kmalloc-192.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     28807 ~ 1%     +12.5%      32395 ~ 1%  grantley/micro/aim7/shell_rtns_1
    767784 ~25%     -94.6%      41733 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
    796591 ~24%     -90.7%      74128 ~ 1%  TOTAL slabinfo.kmalloc-192.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     81548 ~ 7%    +262.4%     295506 ~ 2%  grantley/micro/aim7/shell_rtns_1
     62798 ~ 5%    +158.3%     162214 ~ 7%  lkp-wsx01/micro/aim7/shell_rtns_1
    144346 ~ 6%    +217.1%     457721 ~ 4%  TOTAL numa-meminfo.node1.Active(anon)

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    167493 ~ 2%    +197.0%     497489 ~ 3%  grantley/micro/aim7/disk_src
    618837 ~ 0%    +107.6%    1284825 ~ 3%  grantley/micro/aim7/shell_rtns_1
   1315045 ~ 0%    +307.5%    5358867 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
   2101375 ~ 0%    +239.8%    7141181 ~ 1%  TOTAL interrupts.LOC

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     20438 ~ 7%    +260.2%      73615 ~ 2%  grantley/micro/aim7/shell_rtns_1
     15775 ~ 5%    +155.3%      40280 ~ 7%  lkp-wsx01/micro/aim7/shell_rtns_1
     36214 ~ 6%    +214.5%     113896 ~ 3%  TOTAL numa-vmstat.node1.nr_active_anon

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
         6 ~12%     -67.7%          2 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
         6 ~12%     -67.7%          2 ~ 0%  TOTAL vmstat.procs.b

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     39686 ~17%     -68.3%      12565 ~10%  lkp-wsx01/micro/aim7/shell_rtns_1
     39686 ~17%     -68.3%      12565 ~10%  TOTAL numa-meminfo.node3.SReclaimable

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     43467 ~ 2%    +240.7%     148081 ~ 1%  grantley/micro/aim7/shell_rtns_1
     65784 ~ 2%    +149.9%     164370 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
    109251 ~ 2%    +186.0%     312452 ~ 1%  TOTAL proc-vmstat.nr_active_anon

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    173786 ~ 2%    +240.2%     591203 ~ 1%  grantley/micro/aim7/shell_rtns_1
    264074 ~ 3%    +148.6%     656365 ~ 2%  lkp-wsx01/micro/aim7/shell_rtns_1
    437861 ~ 3%    +184.9%    1247568 ~ 1%  TOTAL meminfo.Active(anon)

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      9907 ~17%     -68.3%       3142 ~10%  lkp-wsx01/micro/aim7/shell_rtns_1
      9907 ~17%     -68.3%       3142 ~10%  TOTAL numa-vmstat.node3.nr_slab_reclaimable

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     92198 ~ 5%    +221.2%     296102 ~ 2%  grantley/micro/aim7/shell_rtns_1
     61041 ~ 5%    +162.3%     160107 ~ 6%  lkp-wsx01/micro/aim7/shell_rtns_1
    153239 ~ 5%    +197.7%     456209 ~ 4%  TOTAL numa-meminfo.node0.Active(anon)

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     23075 ~ 4%    +219.5%      73730 ~ 2%  grantley/micro/aim7/shell_rtns_1
     15290 ~ 4%    +160.4%      39823 ~ 7%  lkp-wsx01/micro/aim7/shell_rtns_1
     38366 ~ 4%    +196.0%     113553 ~ 4%  TOTAL numa-vmstat.node0.nr_active_anon

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     16972 ~19%     +46.5%      24858 ~17%  grantley/micro/aim7/shell_rtns_1
     48753 ~22%     -70.2%      14535 ~29%  lkp-wsx01/micro/aim7/shell_rtns_1
     65726 ~21%     -40.1%      39393 ~21%  TOTAL numa-vmstat.node1.nr_slab_unreclaimable

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     67859 ~19%     +46.7%      99577 ~17%  grantley/micro/aim7/shell_rtns_1
    194381 ~20%     -70.1%      58177 ~29%  lkp-wsx01/micro/aim7/shell_rtns_1
    262240 ~20%     -39.8%     157755 ~21%  TOTAL numa-meminfo.node1.SUnreclaim

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     40297 ~16%     -67.5%      13103 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
     40297 ~16%     -67.5%      13103 ~ 0%  TOTAL proc-vmstat.nr_slab_reclaimable

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     41157 ~18%     -67.2%      13512 ~ 3%  lkp-wsx01/micro/aim7/shell_rtns_1
     41157 ~18%     -67.2%      13512 ~ 3%  TOTAL numa-meminfo.node2.SReclaimable

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    158286 ~16%     -66.9%      52413 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
    158286 ~16%     -66.9%      52413 ~ 0%  TOTAL meminfo.SReclaimable

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     10262 ~18%     -67.1%       3379 ~ 3%  lkp-wsx01/micro/aim7/shell_rtns_1
     10262 ~18%     -67.1%       3379 ~ 3%  TOTAL numa-vmstat.node2.nr_slab_reclaimable

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     58257 ~ 9%    +153.6%     147736 ~ 4%  lkp-wsx01/micro/aim7/shell_rtns_1
     58257 ~ 9%    +153.6%     147736 ~ 4%  TOTAL numa-meminfo.node3.AnonPages

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     14539 ~10%    +152.1%      36647 ~ 5%  lkp-wsx01/micro/aim7/shell_rtns_1
     14539 ~10%    +152.1%      36647 ~ 5%  TOTAL numa-vmstat.node3.nr_anon_pages

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
       344 ~ 1%     +51.2%        520 ~ 1%  grantley/micro/aim7/shell_rtns_1
      1694 ~ 0%     -34.2%       1114 ~ 1%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
     25043 ~24%     -96.2%        947 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
     27082 ~23%     -90.5%       2582 ~ 1%  TOTAL slabinfo.kmalloc-256.num_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
       344 ~ 1%     +51.2%        520 ~ 1%  grantley/micro/aim7/shell_rtns_1
      1694 ~ 0%     -34.2%       1114 ~ 1%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
     25043 ~24%     -96.2%        947 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
     27082 ~23%     -90.5%       2582 ~ 1%  TOTAL slabinfo.kmalloc-256.active_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
  25230572 ~13%     -60.3%   10024021 ~28%  lkp-wsx01/micro/aim7/shell_rtns_1
  25230572 ~13%     -60.3%   10024021 ~28%  TOTAL cpuidle.C3-NHM.time

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      1947 ~20%     -65.8%        666 ~ 2%  lkp-wsx01/micro/aim7/shell_rtns_1
      1947 ~20%     -65.8%        666 ~ 2%  TOTAL slabinfo.task_delay_info.num_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      1947 ~20%     -65.8%        666 ~ 2%  lkp-wsx01/micro/aim7/shell_rtns_1
      1947 ~20%     -65.8%        666 ~ 2%  TOTAL slabinfo.task_delay_info.active_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     38847 ~16%     -63.4%      14205 ~11%  lkp-wsx01/micro/aim7/shell_rtns_1
     38847 ~16%     -63.4%      14205 ~11%  TOTAL numa-meminfo.node0.SReclaimable

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     91396 ~14%     +33.6%     122065 ~14%  grantley/micro/aim7/shell_rtns_1
    233950 ~19%     -70.0%      70199 ~23%  lkp-wsx01/micro/aim7/shell_rtns_1
    325346 ~18%     -40.9%     192264 ~17%  TOTAL numa-meminfo.node1.Slab

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      9737 ~16%     -63.5%       3552 ~11%  lkp-wsx01/micro/aim7/shell_rtns_1
      9737 ~16%     -63.5%       3552 ~11%  TOTAL numa-vmstat.node0.nr_slab_reclaimable

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    155695 ~ 7%    +112.3%     330467 ~ 2%  grantley/micro/aim7/disk_src
    376752 ~ 3%     +91.2%     720465 ~ 3%  grantley/micro/aim7/shell_rtns_1
    770510 ~ 0%    +263.9%    2803548 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
   1302957 ~ 2%    +195.8%    3854480 ~ 1%  TOTAL softirqs.TIMER

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      2222 ~20%     -63.8%        803 ~ 2%  lkp-wsx01/micro/aim7/shell_rtns_1
      2222 ~20%     -63.8%        803 ~ 2%  TOTAL slabinfo.kmalloc-128.num_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      2222 ~20%     -63.8%        803 ~ 2%  lkp-wsx01/micro/aim7/shell_rtns_1
      2222 ~20%     -63.8%        803 ~ 2%  TOTAL slabinfo.kmalloc-128.active_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     64952 ~ 8%    +136.5%     153601 ~ 3%  lkp-wsx01/micro/aim7/shell_rtns_1
     64952 ~ 8%    +136.5%     153601 ~ 3%  TOTAL numa-meminfo.node3.Active(anon)

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     16208 ~10%    +135.4%      38150 ~ 4%  lkp-wsx01/micro/aim7/shell_rtns_1
     16208 ~10%    +135.4%      38150 ~ 4%  TOTAL numa-vmstat.node3.nr_active_anon

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     63205 ~ 7%    +159.4%     163952 ~ 7%  lkp-wsx01/micro/aim7/shell_rtns_1
     63205 ~ 7%    +159.4%     163952 ~ 7%  TOTAL numa-meminfo.node2.AnonPages

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     15772 ~ 7%    +158.6%      40789 ~ 7%  lkp-wsx01/micro/aim7/shell_rtns_1
     15772 ~ 7%    +158.6%      40789 ~ 7%  TOTAL numa-vmstat.node2.nr_anon_pages

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     70170 ~ 7%    +142.4%     170060 ~ 6%  lkp-wsx01/micro/aim7/shell_rtns_1
     70170 ~ 7%    +142.4%     170060 ~ 6%  TOTAL numa-meminfo.node2.Active(anon)

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     17497 ~ 7%    +141.5%      42251 ~ 7%  lkp-wsx01/micro/aim7/shell_rtns_1
     17497 ~ 7%    +141.5%      42251 ~ 7%  TOTAL numa-vmstat.node2.nr_active_anon

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
       106 ~ 1%    +132.1%        247 ~ 1%  grantley/micro/aim7/shell_rtns_1
       106 ~ 1%    +132.1%        247 ~ 1%  TOTAL slabinfo.kmalloc-2048.num_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
       106 ~ 1%    +132.1%        247 ~ 1%  grantley/micro/aim7/shell_rtns_1
       106 ~ 1%    +132.1%        247 ~ 1%  TOTAL slabinfo.kmalloc-2048.active_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     22067 ~ 1%     +51.1%      33353 ~ 1%  grantley/micro/aim7/shell_rtns_1
     19012 ~ 3%     +17.8%      22391 ~ 2%  grantley/micro/aim7/string_rtns
     54244 ~ 0%     -34.2%      35682 ~ 1%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
    801391 ~24%     -96.2%      30328 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
    896715 ~22%     -86.4%     121755 ~ 1%  TOTAL slabinfo.kmalloc-256.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     21569 ~ 1%     +45.1%      31294 ~ 0%  grantley/micro/aim7/shell_rtns_1
     18498 ~ 4%     +18.6%      21944 ~ 2%  grantley/micro/aim7/string_rtns
     51514 ~ 0%     -33.2%      34432 ~ 1%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
    768564 ~23%     -96.4%      27463 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
    860146 ~21%     -86.6%     115134 ~ 1%  TOTAL slabinfo.kmalloc-256.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     37.03 ~ 2%     -39.6%      22.37 ~ 2%  grantley/micro/aim7/disk_src
     16.41 ~ 2%     -32.5%      11.08 ~13%  grantley/micro/aim7/shell_rtns_1
     13.89 ~ 0%     -72.3%       3.84 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
     67.33 ~ 1%     -44.6%      37.28 ~ 5%  TOTAL turbostat.%c6

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    297496 ~ 1%    +140.4%     715256 ~ 1%  grantley/micro/aim7/shell_rtns_1
    387686 ~ 2%    +101.3%     780606 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
    685183 ~ 2%    +118.3%    1495862 ~ 1%  TOTAL meminfo.Active

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     38432 ~ 0%     +25.0%      48053 ~ 1%  grantley/micro/aim7/shell_rtns_1
    192752 ~22%     -71.9%      54240 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
    231185 ~18%     -55.8%     102293 ~ 0%  TOTAL proc-vmstat.nr_slab_unreclaimable

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    153710 ~ 0%     +25.0%     192073 ~ 1%  grantley/micro/aim7/shell_rtns_1
    758954 ~21%     -71.4%     216825 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
    912664 ~17%     -55.2%     408898 ~ 0%  TOTAL meminfo.SUnreclaim

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    156138 ~ 7%    +133.3%     364305 ~ 4%  grantley/micro/aim7/shell_rtns_1
     92594 ~ 7%    +110.9%     195235 ~ 6%  lkp-wsx01/micro/aim7/shell_rtns_1
    248732 ~ 7%    +125.0%     559540 ~ 5%  TOTAL numa-meminfo.node0.Active

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    201870 ~ 0%     +19.1%     240499 ~ 1%  grantley/micro/aim7/shell_rtns_1
    917241 ~20%     -70.6%     269238 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
   1119112 ~16%     -54.5%     509738 ~ 0%  TOTAL meminfo.Slab

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     99503 ~10%    +104.9%     203904 ~ 6%  lkp-wsx01/micro/aim7/shell_rtns_1
     99503 ~10%    +104.9%     203904 ~ 6%  TOTAL numa-meminfo.node2.Active

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      0.98 ~ 2%     -49.2%       0.50 ~ 1%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
      0.98 ~ 2%     -49.2%       0.50 ~ 1%  TOTAL perf-profile.cpu-cycles.__netif_receive_skb_core.__netif_receive_skb.process_backlog.net_rx_action.__do_softirq

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     19601 ~ 8%     -49.0%       9998 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
     19601 ~ 8%     -49.0%       9998 ~ 1%  TOTAL slabinfo.proc_inode_cache.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    141315 ~ 8%    +148.6%     351337 ~ 5%  grantley/micro/aim7/shell_rtns_1
     54643 ~ 2%     +15.0%      62849 ~ 9%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
     93629 ~ 6%    +100.9%     188139 ~ 5%  lkp-wsx01/micro/aim7/shell_rtns_1
    289588 ~ 6%    +108.0%     602326 ~ 6%  TOTAL numa-meminfo.node1.Active

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
       383 ~ 8%     -49.0%        195 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
       383 ~ 8%     -49.0%        195 ~ 1%  TOTAL slabinfo.proc_inode_cache.active_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
       383 ~ 8%     -49.0%        195 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
       383 ~ 8%     -49.0%        195 ~ 1%  TOTAL slabinfo.proc_inode_cache.num_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
  23349636 ~ 0%     -46.8%   12414509 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
  23349636 ~ 0%     -46.8%   12414509 ~ 2%  TOTAL numa-numastat.node0.numa_hit

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
  23341368 ~ 0%     -46.8%   12407894 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
  23341368 ~ 0%     -46.8%   12407894 ~ 2%  TOTAL numa-numastat.node0.local_node

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     19297 ~ 7%     -48.3%       9968 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
     19297 ~ 7%     -48.3%       9968 ~ 1%  TOTAL slabinfo.proc_inode_cache.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     15533 ~ 2%     +16.3%      18062 ~ 2%  grantley/micro/aim7/shell_rtns_1
     70112 ~20%     -65.7%      24021 ~ 2%  lkp-wsx01/micro/aim7/shell_rtns_1
     85646 ~17%     -50.9%      42084 ~ 2%  TOTAL slabinfo.task_delay_info.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
 2.288e+08 ~ 0%     -46.7%  1.219e+08 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
 2.288e+08 ~ 0%     -46.7%  1.219e+08 ~ 2%  TOTAL softirqs.NET_RX

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
  46960527 ~ 0%     -46.7%   25048760 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
  46960527 ~ 0%     -46.7%   25048760 ~ 2%  TOTAL proc-vmstat.numa_local

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
  46972931 ~ 0%     -46.6%   25060337 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
  46972931 ~ 0%     -46.6%   25060337 ~ 2%  TOTAL proc-vmstat.numa_hit

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     18061 ~ 2%     +24.8%      22546 ~ 0%  grantley/micro/aim7/shell_rtns_1
     71113 ~20%     -63.8%      25727 ~ 2%  lkp-wsx01/micro/aim7/shell_rtns_1
     89174 ~16%     -45.9%      48273 ~ 1%  TOTAL slabinfo.kmalloc-128.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
  12107352 ~ 0%     -45.9%    6544676 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
  12107352 ~ 0%     -45.9%    6544676 ~ 2%  TOTAL numa-vmstat.node0.numa_local

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
  11933610 ~ 1%     -47.4%    6272905 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
  11933610 ~ 1%     -47.4%    6272905 ~ 2%  TOTAL numa-numastat.node3.local_node

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
  11933610 ~ 1%     -47.4%    6275386 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
  11933610 ~ 1%     -47.4%    6275386 ~ 2%  TOTAL numa-numastat.node3.numa_hit

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
  12186795 ~ 0%     -45.6%    6623695 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
  12186795 ~ 0%     -45.6%    6623695 ~ 2%  TOTAL numa-vmstat.node0.numa_hit

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     96797 ~ 9%     +88.9%     182812 ~ 4%  lkp-wsx01/micro/aim7/shell_rtns_1
     96797 ~ 9%     +88.9%     182812 ~ 4%  TOTAL numa-meminfo.node3.Active

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
       109 ~18%    +101.8%        220 ~ 7%  lkp-wsx01/micro/aim7/shell_rtns_1
       109 ~18%    +101.8%        220 ~ 7%  TOTAL proc-vmstat.nr_written

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
   6193291 ~ 1%     -46.3%    3325216 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
   6193291 ~ 1%     -46.3%    3325216 ~ 2%  TOTAL numa-vmstat.node3.numa_local

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
  11692936 ~ 0%     -45.6%    6363752 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
  11692936 ~ 0%     -45.6%    6363752 ~ 2%  TOTAL numa-numastat.node1.numa_hit

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
  11688802 ~ 0%     -45.6%    6361271 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
  11688802 ~ 0%     -45.6%    6361271 ~ 2%  TOTAL numa-numastat.node1.local_node

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     18059 ~ 2%     +24.8%      22543 ~ 0%  grantley/micro/aim7/shell_rtns_1
     65016 ~17%     -60.6%      25621 ~ 2%  lkp-wsx01/micro/aim7/shell_rtns_1
     83076 ~14%     -42.0%      48164 ~ 1%  TOTAL slabinfo.kmalloc-128.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     15521 ~ 2%     +16.3%      18047 ~ 2%  grantley/micro/aim7/shell_rtns_1
     64124 ~17%     -62.6%      23975 ~ 2%  lkp-wsx01/micro/aim7/shell_rtns_1
     79646 ~14%     -47.2%      42023 ~ 2%  TOTAL slabinfo.task_delay_info.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      1.48 ~ 1%     +67.1%       2.47 ~ 0%  grantley/micro/aim7/disk_src
      1.26 ~ 0%     +97.9%       2.49 ~ 0%  grantley/micro/aim7/shell_rtns_1
      2.74 ~ 0%     +81.3%       4.96 ~ 0%  TOTAL turbostat.GHz

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
   6305179 ~ 1%     -45.5%    3437625 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
   6305179 ~ 1%     -45.5%    3437625 ~ 2%  TOTAL numa-vmstat.node3.numa_hit

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
   6159931 ~ 0%     -44.2%    3438297 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
   6159931 ~ 0%     -44.2%    3438297 ~ 2%  TOTAL numa-vmstat.node1.numa_local

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     70.05 ~ 2%     +22.7%      85.95 ~ 1%  grantley/micro/aim7/disk_src
    101.86 ~ 2%     +39.8%     142.38 ~ 3%  grantley/micro/aim7/shell_rtns_1
    114.60 ~ 1%    +176.7%     317.06 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
    286.50 ~ 1%     +90.4%     545.39 ~ 1%  TOTAL uptime.boot

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
   6195618 ~ 0%     -43.9%    3473661 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
   6195618 ~ 0%     -43.9%    3473661 ~ 2%  TOTAL numa-vmstat.node1.numa_hit

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      1712 ~ 1%    +131.6%       3965 ~ 1%  grantley/micro/aim7/shell_rtns_1
      3936 ~ 5%     +28.8%       5072 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
      5649 ~ 3%     +60.0%       9038 ~ 0%  TOTAL slabinfo.kmalloc-2048.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      1712 ~ 1%    +126.1%       3871 ~ 1%  grantley/micro/aim7/shell_rtns_1
      3863 ~ 4%     +27.6%       4927 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
      5575 ~ 3%     +57.8%       8798 ~ 0%  TOTAL slabinfo.kmalloc-2048.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
       141 ~ 2%     +70.4%        241 ~10%  lkp-wsx01/micro/aim7/shell_rtns_1
       141 ~ 2%     +70.4%        241 ~10%  TOTAL proc-vmstat.nr_dirtied

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     39027 ~ 3%     -25.8%      28971 ~ 8%  grantley/micro/aim7/disk_src
    747148 ~ 0%     -49.1%     380461 ~ 3%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
    786176 ~ 0%     -47.9%     409432 ~ 3%  TOTAL proc-vmstat.pgalloc_dma32

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     29324 ~ 7%    +101.1%      58978 ~33%  lkp-wsx01/micro/aim7/shell_rtns_1
     29324 ~ 7%    +101.1%      58978 ~33%  TOTAL numa-meminfo.node3.PageTables

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    128910 ~ 3%     +77.2%     228459 ~ 4%  grantley/micro/aim7/shell_rtns_1
    167288 ~ 3%     +50.7%     252075 ~ 2%  lkp-wsx01/micro/aim7/shell_rtns_1
    296199 ~ 3%     +62.2%     480534 ~ 3%  TOTAL meminfo.PageTables

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     32256 ~ 3%     +77.2%      57162 ~ 4%  grantley/micro/aim7/shell_rtns_1
     41618 ~ 3%     +51.7%      63117 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
     73874 ~ 3%     +62.8%     120279 ~ 3%  TOTAL proc-vmstat.nr_page_table_pages

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    792183 ~ 6%     -25.4%     590643 ~ 3%  grantley/micro/aim7/disk_src
  47655459 ~ 0%     -47.1%   25213633 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
  48447643 ~ 0%     -46.7%   25804277 ~ 2%  TOTAL proc-vmstat.pgfree

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    750656 ~ 6%     -25.6%     558315 ~ 2%  grantley/micro/aim7/disk_src
  46948168 ~ 0%     -47.0%   24871573 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
  47698824 ~ 0%     -46.7%   25429888 ~ 2%  TOTAL proc-vmstat.pgalloc_normal

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      7321 ~ 8%    +100.4%      14674 ~33%  lkp-wsx01/micro/aim7/shell_rtns_1
      7321 ~ 8%    +100.4%      14674 ~33%  TOTAL numa-vmstat.node3.nr_page_table_pages

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    106318 ~ 0%     +61.5%     171693 ~ 1%  grantley/micro/aim7/shell_rtns_1
    121177 ~ 0%     +56.6%     189713 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
    227495 ~ 0%     +58.9%     361407 ~ 1%  TOTAL slabinfo.vm_area_struct.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      2415 ~ 0%     +61.5%       3901 ~ 1%  grantley/micro/aim7/shell_rtns_1
      2753 ~ 0%     +56.6%       4311 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
      5169 ~ 0%     +58.9%       8213 ~ 1%  TOTAL slabinfo.vm_area_struct.active_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      2415 ~ 0%     +61.5%       3901 ~ 1%  grantley/micro/aim7/shell_rtns_1
      2753 ~ 0%     +56.6%       4311 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
      5169 ~ 0%     +58.9%       8213 ~ 1%  TOTAL slabinfo.vm_area_struct.num_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    103648 ~ 0%     +57.3%     163005 ~ 1%  grantley/micro/aim7/shell_rtns_1
    116417 ~ 0%     +53.1%     178269 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
    220065 ~ 0%     +55.1%     341274 ~ 1%  TOTAL slabinfo.vm_area_struct.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    134901 ~ 9%     -32.7%      90833 ~10%  grantley/micro/aim7/shell_rtns_1
    129125 ~12%     +35.8%     175345 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
    264026 ~10%      +0.8%     266179 ~ 4%  TOTAL softirqs.SCHED

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
   1045365 ~ 3%      +9.8%    1147876 ~ 1%  grantley/micro/aim7/disk_src
  47284865 ~ 0%     -45.1%   25940066 ~ 1%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
  48330231 ~ 0%     -44.0%   27087942 ~ 1%  TOTAL proc-vmstat.pgfault

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      9.72 ~11%     -35.5%       6.27 ~ 6%  grantley/micro/aim7/disk_src
      4.37 ~12%     -32.5%       2.95 ~14%  grantley/micro/aim7/shell_rtns_1
     14.09 ~11%     -34.5%       9.22 ~ 8%  TOTAL turbostat.%pc2

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
 8.932e+08 ~ 3%     -27.8%  6.451e+08 ~ 2%  grantley/micro/aim7/disk_src
 8.932e+08 ~ 3%     -27.8%  6.451e+08 ~ 2%  TOTAL cpuidle.C6-HSW.time

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    967729 ~ 6%     +37.0%    1326099 ~ 5%  grantley/micro/aim7/shell_rtns_1
    961879 ~ 8%     -13.4%     832924 ~ 9%  lkp-wsx01/micro/aim7/shell_rtns_1
   1929609 ~ 7%     +11.9%    2159024 ~ 7%  TOTAL numa-meminfo.node1.MemUsed

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     68903 ~ 0%     +37.7%      94913 ~ 1%  grantley/micro/aim7/shell_rtns_1
     85573 ~ 0%     +24.9%     106849 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
    154477 ~ 0%     +30.6%     201762 ~ 1%  TOTAL slabinfo.anon_vma.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      1076 ~ 0%     +37.8%       1482 ~ 1%  grantley/micro/aim7/shell_rtns_1
      1336 ~ 0%     +24.9%       1669 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
      2412 ~ 0%     +30.6%       3151 ~ 1%  TOTAL slabinfo.anon_vma.active_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      1076 ~ 0%     +37.8%       1482 ~ 1%  grantley/micro/aim7/shell_rtns_1
      1336 ~ 0%     +24.9%       1669 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
      2412 ~ 0%     +30.6%       3151 ~ 1%  TOTAL slabinfo.anon_vma.num_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     67802 ~ 0%     +35.4%      91804 ~ 1%  grantley/micro/aim7/shell_rtns_1
     84473 ~ 0%     +24.1%     104836 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
    152275 ~ 0%     +29.1%     196641 ~ 1%  TOTAL slabinfo.anon_vma.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
       376 ~ 0%     +27.7%        480 ~ 2%  grantley/micro/aim7/shell_rtns_1
       376 ~ 0%     +27.7%        480 ~ 2%  TOTAL slabinfo.sighand_cache.active_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
       376 ~ 0%     +27.7%        480 ~ 2%  grantley/micro/aim7/shell_rtns_1
       376 ~ 0%     +27.7%        480 ~ 2%  TOTAL slabinfo.sighand_cache.num_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      5645 ~ 0%     +27.7%       7208 ~ 2%  grantley/micro/aim7/shell_rtns_1
      6652 ~ 0%     +22.4%       8144 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
     12298 ~ 0%     +24.8%      15353 ~ 1%  TOTAL slabinfo.sighand_cache.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      5467 ~ 0%     +24.0%       6779 ~ 1%  grantley/micro/aim7/shell_rtns_1
      6439 ~ 0%     +22.9%       7916 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
     11906 ~ 0%     +23.4%      14696 ~ 0%  TOTAL slabinfo.sighand_cache.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      1268 ~ 0%     +25.8%       1596 ~ 1%  grantley/micro/aim7/shell_rtns_1
      1702 ~ 0%     +19.6%       2036 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
      2971 ~ 0%     +22.2%       3632 ~ 1%  TOTAL slabinfo.kmalloc-4096.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    177148 ~ 0%     +24.0%     219595 ~ 1%  grantley/micro/aim7/shell_rtns_1
     91649 ~ 0%     -15.8%      77156 ~ 1%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
    268798 ~ 0%     +10.4%     296751 ~ 1%  TOTAL slabinfo.kmalloc-64.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      1234 ~ 0%     +23.0%       1518 ~ 1%  grantley/micro/aim7/shell_rtns_1
      1619 ~ 0%     +20.2%       1945 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
      2853 ~ 0%     +21.4%       3464 ~ 1%  TOTAL slabinfo.kmalloc-4096.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     13333 ~ 2%     +12.7%      15030 ~ 3%  grantley/micro/aim7/shell_rtns_1
     16521 ~ 3%     +29.3%      21358 ~ 3%  lkp-wsx01/micro/aim7/shell_rtns_1
     29855 ~ 2%     +21.9%      36388 ~ 3%  TOTAL slabinfo.files_cache.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     13225 ~ 2%     +12.9%      14927 ~ 3%  grantley/micro/aim7/shell_rtns_1
     16377 ~ 3%     +28.6%      21062 ~ 3%  lkp-wsx01/micro/aim7/shell_rtns_1
     29602 ~ 3%     +21.6%      35990 ~ 3%  TOTAL slabinfo.files_cache.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      3259 ~ 2%     -15.9%       2742 ~ 1%  grantley/micro/aim7/disk_src
      3231 ~ 2%     -14.9%       2750 ~ 4%  grantley/micro/aim7/shell_rtns_1
      6491 ~ 2%     -15.4%       5492 ~ 3%  TOTAL uptime.idle

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      2873 ~ 0%     +26.5%       3635 ~ 1%  grantley/micro/aim7/shell_rtns_1
      1437 ~ 0%     -15.5%       1214 ~ 1%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
      4215 ~ 8%     -13.2%       3658 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
      8526 ~ 4%      -0.2%       8508 ~ 1%  TOTAL slabinfo.kmalloc-64.num_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      2873 ~ 0%     +26.5%       3635 ~ 1%  grantley/micro/aim7/shell_rtns_1
      1437 ~ 0%     -15.5%       1214 ~ 1%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
      4215 ~ 8%     -13.2%       3658 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
      8526 ~ 4%      -0.2%       8508 ~ 1%  TOTAL slabinfo.kmalloc-64.active_slabs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    183945 ~ 0%     +26.5%     232676 ~ 1%  grantley/micro/aim7/shell_rtns_1
     92013 ~ 0%     -15.5%      77762 ~ 1%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
    269789 ~ 8%     -13.2%     234207 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
    545748 ~ 4%      -0.2%     544645 ~ 1%  TOTAL slabinfo.kmalloc-64.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
   1018345 ~ 5%     +23.8%    1261207 ~ 5%  grantley/micro/aim7/shell_rtns_1
   1018345 ~ 5%     +23.8%    1261207 ~ 5%  TOTAL numa-meminfo.node0.MemUsed

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
   3220038 ~ 0%     +12.8%    3632740 ~ 1%  grantley/micro/aim7/shell_rtns_1
   3297201 ~ 0%     +19.3%    3932415 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
   6517239 ~ 0%     +16.1%    7565155 ~ 1%  TOTAL meminfo.Committed_AS

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
        48 ~ 1%     +14.6%         55 ~ 1%  grantley/micro/aim7/disk_src
        49 ~ 1%     +18.1%         58 ~ 1%  grantley/micro/aim7/shell_rtns_1
        97 ~ 1%     +16.4%        113 ~ 1%  TOTAL turbostat.CTMP

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
        52 ~ 0%     +14.6%         59 ~ 0%  grantley/micro/aim7/disk_src
        55 ~ 0%     +14.4%         63 ~ 1%  grantley/micro/aim7/shell_rtns_1
       107 ~ 0%     +14.5%        123 ~ 1%  TOTAL turbostat.PTMP

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      2434 ~ 5%     +11.7%       2720 ~ 6%  grantley/micro/aim7/shell_rtns_1
      2434 ~ 5%     +11.7%       2720 ~ 6%  TOTAL slabinfo.shmem_inode_cache.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      2434 ~ 5%     +11.7%       2720 ~ 6%  grantley/micro/aim7/shell_rtns_1
      2434 ~ 5%     +11.7%       2720 ~ 6%  TOTAL slabinfo.shmem_inode_cache.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      1.77 ~ 4%     -13.7%       1.53 ~ 3%  grantley/micro/aim7/shell_rtns_1
      1.77 ~ 4%     -13.7%       1.53 ~ 3%  TOTAL perf-profile.cpu-cycles.find_busiest_group.load_balance.idle_balance.__schedule.schedule

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     14312 ~ 1%     +14.4%      16371 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
     14312 ~ 1%     +14.4%      16371 ~ 1%  TOTAL slabinfo.mm_struct.active_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     14544 ~ 1%     +14.2%      16612 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
     14544 ~ 1%     +14.2%      16612 ~ 1%  TOTAL slabinfo.mm_struct.num_objs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      3396 ~ 4%     -10.4%       3044 ~ 5%  grantley/micro/aim7/shell_rtns_1
      3396 ~ 4%     -10.4%       3044 ~ 5%  TOTAL proc-vmstat.nr_alloc_batch

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     22328 ~ 4%     -11.1%      19845 ~ 2%  lkp-wsx01/micro/aim7/shell_rtns_1
     22328 ~ 4%     -11.1%      19845 ~ 2%  TOTAL cpuidle.C6-NHM.usage

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    529.92 ~ 4%    +268.2%    1951.04 ~ 3%  grantley/micro/aim7/disk_src
   1003.41 ~ 0%    +279.2%    3805.01 ~ 0%  grantley/micro/aim7/shell_rtns_1
     19.77 ~ 6%    +182.6%      55.87 ~17%  grantley/micro/aim7/string_rtns
   3497.24 ~ 0%    +461.8%   19645.76 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
   5050.34 ~ 0%    +404.1%   25457.68 ~ 1%  TOTAL time.system_time

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     11497 ~11%   +1707.3%     207797 ~ 3%  grantley/micro/aim7/disk_src
    942233 ~ 3%      +4.7%     986308 ~ 0%  grantley/micro/aim7/shell_rtns_1
   1131925 ~ 0%    +270.9%    4197966 ~ 4%  lkp-wsx01/micro/aim7/shell_rtns_1
   2085656 ~ 2%    +158.5%    5392071 ~ 3%  TOTAL time.involuntary_context_switches

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     32036 ~12%     -72.8%       8706 ~ 2%  grantley/micro/aim7/disk_src
     99971 ~ 3%     -70.5%      29537 ~ 3%  grantley/micro/aim7/shell_rtns_1
   1440638 ~ 0%     -46.5%     770986 ~ 2%  lkp-nex05/micro/netperf/120s-200%-TCP_CRR
     47859 ~ 0%     -48.0%      24882 ~ 3%  lkp-wsx01/micro/aim7/shell_rtns_1
   1620504 ~ 0%     -48.5%     834112 ~ 2%  TOTAL vmstat.system.cs

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
    487467 ~12%     -81.6%      89693 ~ 2%  grantley/micro/aim7/disk_src
   2644894 ~ 3%     -41.1%    1558409 ~ 0%  grantley/micro/aim7/shell_rtns_1
   2110723 ~ 0%     -17.9%    1731995 ~ 1%  lkp-wsx01/micro/aim7/shell_rtns_1
   5243086 ~ 3%     -35.5%    3380098 ~ 1%  TOTAL time.voluntary_context_switches

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     30.65 ~ 1%     +51.7%      46.48 ~ 2%  grantley/micro/aim7/disk_src
     63.36 ~ 2%     +62.5%     102.94 ~ 4%  grantley/micro/aim7/shell_rtns_1
     31.54 ~ 0%      +2.5%      32.32 ~ 0%  grantley/micro/aim7/string_rtns
     76.30 ~ 0%    +264.6%     278.15 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
    201.85 ~ 1%    +127.8%     459.89 ~ 1%  TOTAL time.elapsed_time

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      1824 ~ 3%    +132.3%       4239 ~ 0%  grantley/micro/aim7/disk_src
      2423 ~ 1%     +64.9%       3995 ~ 3%  grantley/micro/aim7/shell_rtns_1
      5433 ~ 0%     +34.7%       7318 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
      9681 ~ 1%     +60.6%      15552 ~ 1%  TOTAL time.percent_of_cpu_this_job_got

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     75.03 ~ 0%     +75.4%     131.59 ~ 1%  grantley/micro/aim7/disk_src
     92.96 ~ 0%     +67.5%     155.70 ~ 1%  grantley/micro/aim7/shell_rtns_1
    167.99 ~ 0%     +71.0%     287.29 ~ 1%  TOTAL turbostat.Pkg_W

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     32.68 ~ 3%    +129.8%      75.08 ~ 0%  grantley/micro/aim7/disk_src
     68.19 ~ 0%     +29.8%      88.50 ~ 1%  grantley/micro/aim7/shell_rtns_1
     85.38 ~ 0%     +12.5%      96.05 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
    186.25 ~ 0%     +39.4%     259.63 ~ 0%  TOTAL turbostat.%c0

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     29.50 ~ 0%     -31.5%      20.20 ~ 1%  grantley/micro/aim7/disk_src
    531.64 ~ 0%     -43.2%     302.22 ~ 1%  grantley/micro/aim7/shell_rtns_1
    648.67 ~ 0%      +9.8%     712.26 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
   1209.81 ~ 0%     -14.5%    1034.68 ~ 0%  TOTAL time.user_time

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
     14538 ~ 7%     -15.6%      12271 ~ 0%  grantley/micro/aim7/disk_src
     24511 ~ 5%     -36.3%      15617 ~ 2%  grantley/micro/aim7/shell_rtns_1
     27643 ~ 0%     -26.4%      20346 ~ 0%  lkp-wsx01/micro/aim7/shell_rtns_1
     66693 ~ 4%     -27.7%      48234 ~ 0%  TOTAL vmstat.system.in

887843961c4b468  e2a728c2785d6aab45d1a6d2c  
---------------  -------------------------  
      3.86 ~ 7%     +55.3%       5.99 ~ 3%  grantley/micro/aim7/disk_src
      7.45 ~ 5%     +18.6%       8.83 ~ 4%  grantley/micro/aim7/shell_rtns_1
     11.31 ~ 6%     +31.1%      14.82 ~ 4%  TOTAL turbostat.RAM_W


Legend:
	~XX%    - stddev percent
	[+-]XX% - change percent


                                  time.system_time

   20000 O+----O---O-----O--O--O---O--------O--O--O---O--O--O--O--O---O--O--O
         |  O         O               O  O                                  |
   18000 ++                                                                 |
   16000 ++                                                                 |
         |                                                                  |
   14000 ++                                                                 |
   12000 ++                                                                 |
         |                                                                  |
   10000 ++                                                                 |
    8000 ++                                                                 |
         |                                                                  |
    6000 ++                                                                 |
    4000 ++                                                                 |
         *..*..*...*..*..*..*..*...*..*..*..*..*..*...*..*..*               |
    2000 ++-----------------------------------------------------------------+


                          time.percent_of_cpu_this_job_got

   7500 ++------------------------------------------------------------------+
        O  O  O   O  O  O  O   O  O     O   O  O  O  O   O  O  O  O   O  O  O
        |                            O                                      |
   7000 ++                                                                  |
        |                                                                   |
        |                                                                   |
   6500 ++                                                                  |
        |                                                                   |
   6000 ++                                                                  |
        |                                                                   |
        |                                                                   |
   5500 ++                                    .*..         .*               |
        *..*..*...*..*..   *...*..*..*..*...*.    *..*...*.                 |
        |                ..                                                 |
   5000 ++--------------*---------------------------------------------------+


                                 time.elapsed_time

   300 ++-------------------------------------------------------------------+
       O      O  O  O  O   O  O  O         O  O   O  O  O   O  O  O  O   O  O
       |  O                          O  O                                   |
   250 ++                                                                   |
       |                                                                    |
       |                                                                    |
   200 ++                                                                   |
       |                                                                    |
   150 ++                                                                   |
       |                                                                    |
       |                                                                    |
   100 ++                                                                   |
       | .*...  .*..*..*...     .*...  .*..                                 |
       *.     *.           *..*.     *.    *..*...*..*..*...*               |
    50 ++-------------------------------------------------------------------+


                           time.involuntary_context_switches

     5e+06 ++---------------------------------------------------------------+
           |                                                                |
   4.5e+06 O+                    O  O                    O   O           O  |
     4e+06 ++    O     O  O   O        O  O  O  O  O  O         O  O        O
           |  O     O                                                 O     |
   3.5e+06 ++                                                               |
           |                                                                |
     3e+06 ++                                                               |
           |                                                                |
   2.5e+06 ++                                                               |
     2e+06 ++                                                               |
           |                                                                |
   1.5e+06 ++                                                               |
           |                       .*..  .*..*..                            |
     1e+06 *+-*--*--*--*--*---*--*-----*--------*--*--*--*---*--------------+


                                aim7.2000.jobs-per-min

   160000 *+----*--*------*--*--*-----*------*--*--*--*--*--*---------------+
          |  *.        *.          *.    *.                                 |
   140000 ++                                                                |
          |                                                                 |
          |                                                                 |
   120000 ++                                                                |
          |                                                                 |
   100000 ++                                                                |
          |                                                                 |
    80000 ++                                                                |
          |                                                                 |
          |                                                                 |
    60000 ++                                                                |
          |  O                        O  O                                  |
    40000 O+----O--O---O--O--O--O--O---------O--O--O--O--O--O--O---O--O--O--O


                                   turbostat.%c0

   98 ++--------------------------------------------------------------------+
      |                                                           O      O  |
   96 O+ O   O  O  O   O  O  O   O  O  O   O  O  O   O  O  O   O     O      O
   94 ++                                                                    |
      |                                                                     |
   92 ++                                                                    |
   90 ++                                                                    |
      |                                                                     |
   88 ++                                                                    |
   86 ++                                                                    |
      *..*...*..*..*      *..*...*..*..*...*..*..*...*..*..*                |
   84 ++            +    :                                                  |
   82 ++             +   :                                                  |
      |               + :                                                   |
   80 ++---------------*----------------------------------------------------+


                                  vmstat.system.cs

   55000 ++-----------------------------------------------------------------+
         |                                 .*..                             |
   50000 ++                             .*.                                 |
         *..*..*...*..*..  .*..*...*..*.       *..*...*..*..*               |
   45000 ++              *.                                                 |
         |                                                                  |
   40000 ++                                                                 |
         |                                                                  |
   35000 ++                                                                 |
         |                                                                  |
   30000 ++                                                                 |
         |                     O                                            |
   25000 O+ O  O   O  O  O  O      O  O  O  O  O  O   O  O  O  O  O      O  O
         |                                                            O     |
   20000 ++-----------------------------------------------------------------+


	[*] bisect-good sample
	[O] bisect-bad  sample

Thanks,
Fengguang
