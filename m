Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbaCDNNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:13:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:52117 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757081AbaCDNNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:13:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,585,1389772800"; 
   d="scan'208";a="485772067"
Date: Tue, 4 Mar 2014 21:13:14 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [sched/balance] 7eb745ea4b5: +27.8% vmstat.system.cs
Message-ID: <20140304131314.GA28854@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

FYI, we noticed the below changes on

https://github.com/alexshi/power-scheduling.git single-balance
commit 7eb745ea4b5328e9e8d369c0c4bbf03bfe838100 ("sched/balance: task moving")

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     44799 ~45%     -82.9%       7665 ~28%  lkp-snb01/micro/aim7/mem_rtns_1
     44799 ~45%     -82.9%       7665 ~28%  TOTAL sched_debug.cfs_rq[29]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     67614 ~24%     -87.7%       8306 ~26%  lkp-snb01/micro/aim7/mem_rtns_1
     67614 ~24%     -87.7%       8306 ~26%  TOTAL sched_debug.cfs_rq[29]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
        65 ~24%     -88.3%          7 ~28%  lkp-snb01/micro/aim7/mem_rtns_1
        65 ~24%     -88.3%          7 ~28%  TOTAL sched_debug.cfs_rq[29]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     67588 ~24%     -87.8%       8277 ~26%  lkp-snb01/micro/aim7/mem_rtns_1
     67588 ~24%     -87.8%       8277 ~26%  TOTAL sched_debug.cpu#29.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
        65 ~24%     -88.7%          7 ~31%  lkp-snb01/micro/aim7/mem_rtns_1
        65 ~24%     -88.7%          7 ~31%  TOTAL sched_debug.cpu#29.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
        77 ~39%     -90.2%          7 ~28%  lkp-snb01/micro/aim7/mem_rtns_1
        53 ~39%     -77.2%         12 ~14%  lkp-snb01/micro/aim7/string_rtns
       131 ~39%     -84.9%         19 ~19%  TOTAL sched_debug.cfs_rq[17]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
        77 ~39%     -90.2%          7 ~28%  lkp-snb01/micro/aim7/mem_rtns_1
        53 ~39%     -77.2%         12 ~14%  lkp-snb01/micro/aim7/string_rtns
       131 ~39%     -84.9%         19 ~19%  TOTAL sched_debug.cpu#17.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     79974 ~39%     -90.0%       8037 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
     55674 ~38%     -76.5%      13059 ~12%  lkp-snb01/micro/aim7/string_rtns
    135649 ~39%     -84.4%      21096 ~17%  TOTAL sched_debug.cfs_rq[17]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     79967 ~39%     -90.0%       8022 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
     55674 ~38%     -76.6%      13054 ~12%  lkp-snb01/micro/aim7/string_rtns
    135642 ~39%     -84.5%      21076 ~17%  TOTAL sched_debug.cpu#17.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
       409 ~44%    +214.0%       1284 ~15%  lkp-snb01/micro/aim7/string_rtns
       409 ~44%    +214.0%       1284 ~15%  TOTAL sched_debug.cfs_rq[16]:/.blocked_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3912 ~15%     -62.5%       1467 ~45%  lkp-snb01/micro/aim7/string_rtns
      3912 ~15%     -62.5%       1467 ~45%  TOTAL sched_debug.cfs_rq[2]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3915 ~15%     -62.4%       1470 ~45%  lkp-snb01/micro/aim7/string_rtns
      3915 ~15%     -62.4%       1470 ~45%  TOTAL sched_debug.cfs_rq[2]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2487 ~29%     -67.2%        817 ~27%  lkp-snb01/micro/aim7/mem_rtns_1
      2918 ~15%     -68.5%        918 ~25%  lkp-snb01/micro/aim7/string_rtns
      5406 ~22%     -67.9%       1735 ~26%  TOTAL sched_debug.cfs_rq[6]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1809 ~18%     -66.0%        614 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
      2531 ~11%     -69.2%        778 ~21%  lkp-snb01/micro/aim7/string_rtns
      4341 ~14%     -67.9%       1393 ~22%  TOTAL sched_debug.cfs_rq[6]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1811 ~18%     -65.9%        617 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
      2534 ~11%     -69.2%        781 ~21%  lkp-snb01/micro/aim7/string_rtns
      4346 ~14%     -67.8%       1399 ~22%  TOTAL sched_debug.cfs_rq[6]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     23916 ~25%     -50.7%      11782 ~14%  lkp-snb01/micro/aim7/string_rtns
     23916 ~25%     -50.7%      11782 ~14%  TOTAL sched_debug.cfs_rq[28]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2262 ~20%     -58.5%        937 ~23%  lkp-snb01/micro/aim7/mem_rtns_1
      3969 ~42%     -74.4%       1014 ~22%  lkp-snb01/micro/aim7/string_rtns
      6231 ~34%     -68.7%       1952 ~23%  TOTAL sched_debug.cfs_rq[4]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
       724 ~48%     +58.4%       1147 ~14%  lkp-snb01/micro/aim7/mem_rtns_1
       724 ~48%     +58.4%       1147 ~14%  TOTAL sched_debug.cfs_rq[8]:/.blocked_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
       574 ~47%    +128.1%       1311 ~29%  lkp-snb01/micro/aim7/mem_rtns_1
       574 ~47%    +128.1%       1311 ~29%  TOTAL sched_debug.cfs_rq[2]:/.blocked_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1676 ~15%     -58.0%        704 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      3339 ~41%     -74.7%        845 ~21%  lkp-snb01/micro/aim7/string_rtns
      5015 ~33%     -69.1%       1550 ~21%  TOTAL sched_debug.cfs_rq[4]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1678 ~15%     -57.9%        706 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      3342 ~41%     -74.6%        849 ~21%  lkp-snb01/micro/aim7/string_rtns
      5020 ~32%     -69.0%       1555 ~21%  TOTAL sched_debug.cfs_rq[4]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
       636 ~47%     +99.8%       1271 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
       636 ~47%     +99.8%       1271 ~25%  TOTAL sched_debug.cfs_rq[6]:/.blocked_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2255 ~23%     -63.0%        833 ~35%  lkp-snb01/micro/aim7/mem_rtns_1
      2594 ~18%     -66.5%        867 ~13%  lkp-snb01/micro/aim7/string_rtns
      4849 ~20%     -64.9%       1701 ~24%  TOTAL sched_debug.cfs_rq[7]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1590 ~22%     -60.8%        623 ~28%  lkp-snb01/micro/aim7/mem_rtns_1
      2235 ~14%     -66.8%        742 ~12%  lkp-snb01/micro/aim7/string_rtns
      3825 ~17%     -64.3%       1365 ~19%  TOTAL sched_debug.cfs_rq[7]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1592 ~22%     -60.7%        625 ~28%  lkp-snb01/micro/aim7/mem_rtns_1
      2238 ~14%     -66.7%        745 ~12%  lkp-snb01/micro/aim7/string_rtns
      3830 ~17%     -64.2%       1371 ~19%  TOTAL sched_debug.cfs_rq[7]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
       603 ~43%    +122.6%       1342 ~26%  lkp-snb01/micro/aim7/mem_rtns_1
       603 ~43%    +122.6%       1342 ~26%  TOTAL sched_debug.cfs_rq[3]:/.blocked_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
       603 ~35%    +139.0%       1441 ~17%  lkp-snb01/micro/aim7/string_rtns
       603 ~35%    +139.0%       1441 ~17%  TOTAL sched_debug.cfs_rq[18]:/.blocked_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2844 ~46%     -68.8%        888 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
      2918 ~21%     -66.0%        993 ~19%  lkp-snb01/micro/aim7/string_rtns
      5763 ~34%     -67.3%       1881 ~22%  TOTAL sched_debug.cfs_rq[5]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
       672 ~41%    +136.5%       1591 ~24%  lkp-snb01/micro/aim7/string_rtns
       672 ~41%    +136.5%       1591 ~24%  TOTAL sched_debug.cfs_rq[30]:/.blocked_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1535 ~12%     -54.6%        696 ~27%  lkp-snb01/micro/aim7/mem_rtns_1
      2553 ~11%     -63.8%        923 ~20%  lkp-snb01/micro/aim7/string_rtns
      4088 ~12%     -60.4%       1619 ~23%  TOTAL sched_debug.cfs_rq[9]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1537 ~12%     -54.5%        699 ~27%  lkp-snb01/micro/aim7/mem_rtns_1
      2555 ~11%     -63.8%        926 ~20%  lkp-snb01/micro/aim7/string_rtns
      4093 ~11%     -60.3%       1625 ~23%  TOTAL sched_debug.cfs_rq[9]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2428 ~ 9%     -58.8%       1000 ~26%  lkp-snb01/micro/aim7/string_rtns
      2428 ~ 9%     -58.8%       1000 ~26%  TOTAL sched_debug.cfs_rq[14]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2431 ~ 9%     -58.7%       1003 ~26%  lkp-snb01/micro/aim7/string_rtns
      2431 ~ 9%     -58.7%       1003 ~26%  TOTAL sched_debug.cfs_rq[14]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1689 ~44%     -62.4%        635 ~24%  lkp-snb01/micro/aim7/mem_rtns_1
      2409 ~19%     -65.2%        837 ~15%  lkp-snb01/micro/aim7/string_rtns
      4099 ~30%     -64.0%       1473 ~19%  TOTAL sched_debug.cfs_rq[5]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     34189 ~21%     -62.7%      12741 ~11%  lkp-snb01/micro/aim7/string_rtns
     34189 ~21%     -62.7%      12741 ~11%  TOTAL sched_debug.cpu#28.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1691 ~44%     -62.3%        637 ~24%  lkp-snb01/micro/aim7/mem_rtns_1
      2412 ~19%     -65.1%        841 ~15%  lkp-snb01/micro/aim7/string_rtns
      4104 ~29%     -64.0%       1478 ~19%  TOTAL sched_debug.cfs_rq[5]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     34194 ~21%     -62.7%      12746 ~11%  lkp-snb01/micro/aim7/string_rtns
     34194 ~21%     -62.7%      12746 ~11%  TOTAL sched_debug.cfs_rq[28]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
        32 ~21%     -64.0%         11 ~13%  lkp-snb01/micro/aim7/string_rtns
        32 ~21%     -64.0%         11 ~13%  TOTAL sched_debug.cpu#28.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
        32 ~21%     -64.0%         11 ~13%  lkp-snb01/micro/aim7/string_rtns
        32 ~21%     -64.0%         11 ~13%  TOTAL sched_debug.cfs_rq[28]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1986 ~18%     -54.4%        906 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
      3244 ~29%     -65.1%       1131 ~17%  lkp-snb01/micro/aim7/string_rtns
      5231 ~25%     -61.0%       2037 ~17%  TOTAL sched_debug.cfs_rq[24]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2774 ~ 6%     -55.9%       1223 ~28%  lkp-snb01/micro/aim7/string_rtns
      2774 ~ 6%     -55.9%       1223 ~28%  TOTAL sched_debug.cfs_rq[14]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1372 ~19%     -52.6%        650 ~11%  lkp-snb01/micro/aim7/mem_rtns_1
      2659 ~29%     -65.5%        916 ~18%  lkp-snb01/micro/aim7/string_rtns
      4032 ~25%     -61.1%       1566 ~15%  TOTAL sched_debug.cfs_rq[24]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1374 ~19%     -52.5%        652 ~11%  lkp-snb01/micro/aim7/mem_rtns_1
      2662 ~29%     -65.5%        919 ~18%  lkp-snb01/micro/aim7/string_rtns
      4037 ~25%     -61.1%       1572 ~15%  TOTAL sched_debug.cfs_rq[24]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
       615 ~24%    +141.7%       1486 ~19%  lkp-snb01/micro/aim7/string_rtns
       615 ~24%    +141.7%       1486 ~19%  TOTAL sched_debug.cfs_rq[26]:/.blocked_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2989 ~31%     -57.5%       1270 ~19%  lkp-snb01/micro/aim7/string_rtns
      2989 ~31%     -57.5%       1270 ~19%  TOTAL sched_debug.cfs_rq[22]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2992 ~31%     -57.5%       1273 ~19%  lkp-snb01/micro/aim7/string_rtns
      2992 ~31%     -57.5%       1273 ~19%  TOTAL sched_debug.cfs_rq[22]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2043 ~14%     -51.3%        996 ~29%  lkp-snb01/micro/aim7/mem_rtns_1
      3086 ~ 7%     -64.1%       1107 ~21%  lkp-snb01/micro/aim7/string_rtns
      5129 ~10%     -59.0%       2103 ~25%  TOTAL sched_debug.cfs_rq[9]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1271 ~16%     -44.3%        708 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
      2773 ~ 6%     -57.6%       1175 ~13%  lkp-snb01/micro/aim7/string_rtns
      4044 ~ 9%     -53.4%       1883 ~14%  TOTAL sched_debug.cfs_rq[13]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1273 ~16%     -44.2%        710 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
      2775 ~ 6%     -57.6%       1178 ~13%  lkp-snb01/micro/aim7/string_rtns
      4049 ~ 9%     -53.3%       1888 ~14%  TOTAL sched_debug.cfs_rq[13]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      7170 ~ 9%    +130.0%      16493 ~ 5%  lkp-snb01/micro/aim7/mem_rtns_1
      7699 ~ 3%    +118.4%      16811 ~ 8%  lkp-snb01/micro/aim7/string_rtns
     14869 ~ 6%    +124.0%      33305 ~ 7%  TOTAL interrupts.RES

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1415 ~ 4%     -45.3%        773 ~11%  lkp-snb01/micro/aim7/mem_rtns_1
      2491 ~ 7%     -55.2%       1117 ~28%  lkp-snb01/micro/aim7/string_rtns
      3907 ~ 6%     -51.6%       1891 ~21%  TOTAL sched_debug.cfs_rq[31]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1417 ~ 4%     -45.3%        775 ~11%  lkp-snb01/micro/aim7/mem_rtns_1
      2494 ~ 7%     -55.1%       1120 ~27%  lkp-snb01/micro/aim7/string_rtns
      3912 ~ 6%     -51.5%       1896 ~21%  TOTAL sched_debug.cfs_rq[31]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1798 ~19%     -44.6%        996 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
      3306 ~ 5%     -55.6%       1469 ~13%  lkp-snb01/micro/aim7/string_rtns
      5105 ~10%     -51.7%       2465 ~17%  TOTAL sched_debug.cfs_rq[13]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         6 ~ 7%     +93.8%         12 ~14%  lkp-snb01/micro/aim7/string_rtns
         6 ~ 7%     +93.8%         12 ~14%  TOTAL sched_debug.cfs_rq[1]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         6 ~ 7%     +93.8%         12 ~14%  lkp-snb01/micro/aim7/string_rtns
         6 ~ 7%     +93.8%         12 ~14%  TOTAL sched_debug.cpu#1.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         6 ~24%     +84.8%         12 ~14%  lkp-snb01/micro/aim7/string_rtns
         6 ~24%     +84.8%         12 ~14%  TOTAL sched_debug.cfs_rq[13]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         6 ~24%     +84.8%         12 ~14%  lkp-snb01/micro/aim7/string_rtns
         6 ~24%     +84.8%         12 ~14%  TOTAL sched_debug.cpu#13.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
       608 ~39%    +120.2%       1339 ~29%  lkp-snb01/micro/aim7/mem_rtns_1
       608 ~39%    +120.2%       1339 ~29%  TOTAL sched_debug.cfs_rq[10]:/.blocked_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1353 ~20%     -45.5%        737 ~38%  lkp-snb01/micro/aim7/mem_rtns_1
      2346 ~13%     -45.9%       1268 ~48%  lkp-snb01/micro/aim7/string_rtns
      3699 ~16%     -45.8%       2006 ~44%  TOTAL sched_debug.cfs_rq[1]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1671 ~22%     +77.5%       2966 ~37%  lkp-snb01/micro/aim7/mem_rtns_1
      1671 ~22%     +77.5%       2966 ~37%  TOTAL sched_debug.cfs_rq[25]:/.blocked_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1355 ~20%     -45.4%        740 ~37%  lkp-snb01/micro/aim7/mem_rtns_1
      2348 ~13%     -45.9%       1271 ~48%  lkp-snb01/micro/aim7/string_rtns
      3704 ~16%     -45.7%       2011 ~44%  TOTAL sched_debug.cfs_rq[1]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3499 ~34%     -51.9%       1685 ~24%  lkp-snb01/micro/aim7/string_rtns
      3499 ~34%     -51.9%       1685 ~24%  TOTAL sched_debug.cfs_rq[22]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2027 ~14%     -43.7%       1142 ~13%  lkp-snb01/micro/aim7/mem_rtns_1
      2934 ~11%     -51.4%       1425 ~29%  lkp-snb01/micro/aim7/string_rtns
      4961 ~12%     -48.3%       2567 ~22%  TOTAL sched_debug.cfs_rq[31]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2108 ~27%     -51.2%       1028 ~41%  lkp-snb01/micro/aim7/mem_rtns_1
      2108 ~27%     -51.2%       1028 ~41%  TOTAL sched_debug.cfs_rq[1]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2045 ~19%     -53.2%        957 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
      3378 ~11%     -53.6%       1567 ~19%  lkp-snb01/micro/aim7/string_rtns
      5423 ~14%     -53.5%       2524 ~18%  TOTAL sched_debug.cfs_rq[12]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1806 ~16%     -44.1%       1008 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
      2698 ~13%     -50.1%       1346 ~29%  lkp-snb01/micro/aim7/string_rtns
      4504 ~14%     -47.7%       2355 ~23%  TOTAL sched_debug.cfs_rq[16]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1487 ~19%     -51.9%        715 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
      2801 ~13%     -55.8%       1236 ~16%  lkp-snb01/micro/aim7/string_rtns
      4289 ~15%     -54.5%       1952 ~16%  TOTAL sched_debug.cfs_rq[12]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1490 ~19%     -51.8%        717 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
      2803 ~13%     -55.8%       1239 ~16%  lkp-snb01/micro/aim7/string_rtns
      4294 ~15%     -54.4%       1957 ~16%  TOTAL sched_debug.cfs_rq[12]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~37%    +100.0%          7 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~12%     +81.8%         12 ~13%  lkp-snb01/micro/aim7/string_rtns
        10 ~21%     +88.2%         19 ~14%  TOTAL sched_debug.cpu#7.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~23%    +118.8%          7 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~12%     +78.1%         11 ~15%  lkp-snb01/micro/aim7/string_rtns
         9 ~16%     +91.7%         18 ~19%  TOTAL sched_debug.cpu#31.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~23%    +118.8%          7 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~12%     +78.1%         11 ~15%  lkp-snb01/micro/aim7/string_rtns
         9 ~16%     +91.7%         18 ~19%  TOTAL sched_debug.cfs_rq[31]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~37%    +100.0%          7 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~12%     +81.8%         12 ~13%  lkp-snb01/micro/aim7/string_rtns
        10 ~21%     +88.2%         19 ~14%  TOTAL sched_debug.cfs_rq[7]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1189 ~20%     -39.3%        722 ~14%  lkp-snb01/micro/aim7/mem_rtns_1
      2281 ~15%     -53.4%       1063 ~25%  lkp-snb01/micro/aim7/string_rtns
      3470 ~17%     -48.5%       1786 ~21%  TOTAL sched_debug.cfs_rq[16]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1191 ~20%     -39.2%        724 ~14%  lkp-snb01/micro/aim7/mem_rtns_1
      2284 ~15%     -53.3%       1067 ~25%  lkp-snb01/micro/aim7/string_rtns
      3475 ~17%     -48.4%       1791 ~21%  TOTAL sched_debug.cfs_rq[16]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1509 ~29%     -53.0%        709 ~29%  lkp-snb01/micro/aim7/mem_rtns_1
      2492 ~ 9%     -55.9%       1098 ~22%  lkp-snb01/micro/aim7/string_rtns
      4001 ~16%     -54.8%       1808 ~24%  TOTAL sched_debug.cfs_rq[8]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1511 ~29%     -52.9%        711 ~29%  lkp-snb01/micro/aim7/mem_rtns_1
      2495 ~ 9%     -55.9%       1101 ~22%  lkp-snb01/micro/aim7/string_rtns
      4006 ~16%     -54.7%       1813 ~24%  TOTAL sched_debug.cfs_rq[8]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1547 ~11%     -44.0%        867 ~14%  lkp-snb01/micro/aim7/mem_rtns_1
      1547 ~11%     -44.0%        867 ~14%  TOTAL sched_debug.cfs_rq[21]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2116 ~20%     -46.6%       1129 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
      2928 ~ 7%     -52.8%       1383 ~18%  lkp-snb01/micro/aim7/string_rtns
      5045 ~13%     -50.2%       2513 ~17%  TOTAL sched_debug.cfs_rq[23]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1549 ~11%     -43.9%        869 ~14%  lkp-snb01/micro/aim7/mem_rtns_1
      1549 ~11%     -43.9%        869 ~14%  TOTAL sched_debug.cfs_rq[21]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1327 ~15%     -44.2%        741 ~35%  lkp-snb01/micro/aim7/mem_rtns_1
      2429 ~10%     -58.0%       1020 ~14%  lkp-snb01/micro/aim7/string_rtns
      3757 ~12%     -53.1%       1761 ~23%  TOTAL sched_debug.cfs_rq[15]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1329 ~15%     -44.1%        743 ~35%  lkp-snb01/micro/aim7/mem_rtns_1
      2432 ~10%     -57.9%       1023 ~14%  lkp-snb01/micro/aim7/string_rtns
      3762 ~12%     -53.0%       1767 ~23%  TOTAL sched_debug.cfs_rq[15]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1822 ~16%     -41.8%       1061 ~44%  lkp-snb01/micro/aim7/mem_rtns_1
      2780 ~ 9%     -54.6%       1262 ~16%  lkp-snb01/micro/aim7/string_rtns
      4603 ~12%     -49.5%       2323 ~29%  TOTAL sched_debug.cfs_rq[15]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1498 ~ 4%     -41.2%        880 ~18%  lkp-snb01/micro/aim7/mem_rtns_1
      2601 ~14%     -58.0%       1092 ~13%  lkp-snb01/micro/aim7/string_rtns
      4099 ~10%     -51.9%       1972 ~15%  TOTAL sched_debug.cfs_rq[30]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1500 ~ 4%     -41.2%        883 ~17%  lkp-snb01/micro/aim7/mem_rtns_1
      2604 ~14%     -57.9%       1095 ~13%  lkp-snb01/micro/aim7/string_rtns
      4105 ~10%     -51.8%       1978 ~15%  TOTAL sched_debug.cfs_rq[30]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         4 ~27%     +80.0%          7 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~23%    +100.0%         12 ~17%  lkp-snb01/micro/aim7/string_rtns
        10 ~25%     +92.0%         19 ~16%  TOTAL sched_debug.cpu#9.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         4 ~27%     +80.0%          7 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~23%    +100.0%         12 ~17%  lkp-snb01/micro/aim7/string_rtns
        10 ~25%     +92.0%         19 ~16%  TOTAL sched_debug.cfs_rq[9]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~22%    +100.0%          7 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~15%     +93.5%         12 ~17%  lkp-snb01/micro/aim7/string_rtns
         9 ~18%     +95.9%         19 ~16%  TOTAL sched_debug.cfs_rq[14]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~23%    +111.8%          7 ~23%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~15%     +87.5%         12 ~12%  lkp-snb01/micro/aim7/string_rtns
         9 ~18%     +95.9%         19 ~17%  TOTAL sched_debug.cpu#18.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~19%     +94.7%          7 ~20%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~12%     +93.5%         12 ~17%  lkp-snb01/micro/aim7/string_rtns
        10 ~14%     +94.0%         19 ~18%  TOTAL sched_debug.cfs_rq[10]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~22%    +100.0%          7 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~15%     +93.5%         12 ~17%  lkp-snb01/micro/aim7/string_rtns
         9 ~18%     +95.9%         19 ~16%  TOTAL sched_debug.cpu#14.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~22%    +100.0%          7 ~20%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~18%    +100.0%         12 ~10%  lkp-snb01/micro/aim7/string_rtns
         9 ~20%    +100.0%         19 ~14%  TOTAL sched_debug.cfs_rq[6]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~23%    +111.8%          7 ~23%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~15%     +87.5%         12 ~12%  lkp-snb01/micro/aim7/string_rtns
         9 ~18%     +95.9%         19 ~17%  TOTAL sched_debug.cfs_rq[18]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~22%    +100.0%          7 ~20%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~18%    +100.0%         12 ~10%  lkp-snb01/micro/aim7/string_rtns
         9 ~20%    +100.0%         19 ~14%  TOTAL sched_debug.cpu#6.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~19%     +94.7%          7 ~20%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~12%     +93.5%         12 ~17%  lkp-snb01/micro/aim7/string_rtns
        10 ~14%     +94.0%         19 ~18%  TOTAL sched_debug.cpu#10.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1908 ~15%     -49.4%        966 ~13%  lkp-snb01/micro/aim7/mem_rtns_1
      3233 ~27%     -51.9%       1556 ~17%  lkp-snb01/micro/aim7/string_rtns
      5142 ~22%     -50.9%       2522 ~15%  TOTAL sched_debug.cfs_rq[20]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1910 ~15%     -49.3%        968 ~13%  lkp-snb01/micro/aim7/mem_rtns_1
      3236 ~27%     -51.8%       1559 ~17%  lkp-snb01/micro/aim7/string_rtns
      5147 ~22%     -50.9%       2527 ~15%  TOTAL sched_debug.cfs_rq[20]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4371 ~32%     +95.0%       8525 ~14%  lkp-snb01/micro/aim7/mem_rtns_1
      7224 ~19%     +82.7%      13195 ~12%  lkp-snb01/micro/aim7/string_rtns
     11595 ~24%     +87.3%      21721 ~13%  TOTAL sched_debug.cfs_rq[24]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      5001 ~27%     +64.0%       8202 ~13%  lkp-snb01/micro/aim7/mem_rtns_1
      6445 ~11%    +105.9%      13272 ~13%  lkp-snb01/micro/aim7/string_rtns
     11446 ~18%     +87.6%      21475 ~13%  TOTAL sched_debug.cfs_rq[2]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
       628 ~39%     +84.1%       1156 ~19%  lkp-snb01/micro/aim7/string_rtns
       628 ~39%     +84.1%       1156 ~19%  TOTAL sched_debug.cfs_rq[21]:/.blocked_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      7268 ~ 3%     +80.6%      13127 ~13%  lkp-snb01/micro/aim7/string_rtns
      7268 ~ 3%     +80.6%      13127 ~13%  TOTAL sched_debug.cfs_rq[1]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      7268 ~ 3%     +80.6%      13127 ~13%  lkp-snb01/micro/aim7/string_rtns
      7268 ~ 3%     +80.6%      13127 ~13%  TOTAL sched_debug.cpu#1.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3457 ~35%    +107.9%       7188 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
      6773 ~24%     +77.9%      12048 ~15%  lkp-snb01/micro/aim7/string_rtns
     10231 ~28%     +88.0%      19237 ~18%  TOTAL sched_debug.cfs_rq[24]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2554 ~12%     -48.6%       1314 ~13%  lkp-snb01/micro/aim7/mem_rtns_1
      2554 ~12%     -48.6%       1314 ~13%  TOTAL sched_debug.cfs_rq[21]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3994 ~18%     +98.0%       7909 ~23%  lkp-snb01/micro/aim7/mem_rtns_1
      7048 ~14%     +78.7%      12598 ~12%  lkp-snb01/micro/aim7/string_rtns
     11042 ~15%     +85.7%      20507 ~16%  TOTAL sched_debug.cpu#18.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3987 ~18%     +98.3%       7909 ~23%  lkp-snb01/micro/aim7/mem_rtns_1
      7057 ~13%     +78.5%      12598 ~12%  lkp-snb01/micro/aim7/string_rtns
     11045 ~15%     +85.7%      20507 ~16%  TOTAL sched_debug.cfs_rq[18]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1471 ~20%     -45.5%        801 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
      2366 ~ 8%     -54.7%       1072 ~12%  lkp-snb01/micro/aim7/string_rtns
      3837 ~12%     -51.1%       1874 ~14%  TOTAL sched_debug.cfs_rq[23]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1473 ~20%     -45.4%        804 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
      2369 ~ 8%     -54.6%       1075 ~12%  lkp-snb01/micro/aim7/string_rtns
      3842 ~12%     -51.1%       1879 ~14%  TOTAL sched_debug.cfs_rq[23]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      7224 ~22%     +66.6%      12034 ~15%  lkp-snb01/micro/aim7/string_rtns
      7224 ~22%     +66.6%      12034 ~15%  TOTAL sched_debug.cfs_rq[13]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      7294 ~15%     +78.9%      13050 ~13%  lkp-snb01/micro/aim7/string_rtns
      7294 ~15%     +78.9%      13050 ~13%  TOTAL sched_debug.cfs_rq[30]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2777 ~24%     -48.2%       1438 ~15%  lkp-snb01/micro/aim7/mem_rtns_1
      4123 ~30%     -49.9%       2066 ~22%  lkp-snb01/micro/aim7/string_rtns
      6900 ~27%     -49.2%       3504 ~19%  TOTAL sched_debug.cfs_rq[20]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4768 ~22%     +71.7%       8185 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
      6755 ~15%     +89.3%      12786 ~13%  lkp-snb01/micro/aim7/string_rtns
     11523 ~18%     +82.0%      20971 ~14%  TOTAL sched_debug.cfs_rq[9]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         4 ~22%     +75.0%          7 ~20%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~15%     +84.4%         11 ~12%  lkp-snb01/micro/aim7/string_rtns
        10 ~18%     +80.8%         18 ~15%  TOTAL sched_debug.cfs_rq[23]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         4 ~22%     +80.0%          7 ~23%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~12%     +93.5%         12 ~18%  lkp-snb01/micro/aim7/string_rtns
        10 ~16%     +88.2%         19 ~20%  TOTAL sched_debug.cfs_rq[15]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~28%    +105.6%          7 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~15%     +84.4%         11 ~12%  lkp-snb01/micro/aim7/string_rtns
        10 ~20%     +92.0%         19 ~17%  TOTAL sched_debug.cfs_rq[21]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~45%    +131.2%          7 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~23%     +87.5%         12 ~13%  lkp-snb01/micro/aim7/string_rtns
         9 ~30%    +102.1%         19 ~18%  TOTAL sched_debug.cfs_rq[24]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~28%    +105.6%          7 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~15%     +84.4%         11 ~12%  lkp-snb01/micro/aim7/string_rtns
        10 ~20%     +92.0%         19 ~17%  TOTAL sched_debug.cpu#21.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~22%    +100.0%          7 ~23%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~ 7%     +87.5%         12 ~13%  lkp-snb01/micro/aim7/string_rtns
        10 ~12%     +92.0%         19 ~17%  TOTAL sched_debug.cpu#16.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         4 ~22%     +85.0%          7 ~20%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~14%     +76.5%         12 ~13%  lkp-snb01/micro/aim7/string_rtns
        10 ~17%     +79.6%         19 ~16%  TOTAL sched_debug.cpu#11.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         4 ~22%     +80.0%          7 ~23%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~12%     +93.5%         12 ~18%  lkp-snb01/micro/aim7/string_rtns
        10 ~16%     +88.2%         19 ~20%  TOTAL sched_debug.cpu#15.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~45%    +131.2%          7 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~23%     +87.5%         12 ~13%  lkp-snb01/micro/aim7/string_rtns
         9 ~30%    +102.1%         19 ~18%  TOTAL sched_debug.cpu#24.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~35%    +105.9%          7 ~20%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~20%     +78.8%         11 ~14%  lkp-snb01/micro/aim7/string_rtns
        10 ~25%     +88.0%         18 ~16%  TOTAL sched_debug.cpu#22.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~35%    +111.8%          7 ~23%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~20%     +78.8%         11 ~14%  lkp-snb01/micro/aim7/string_rtns
        10 ~25%     +90.0%         19 ~18%  TOTAL sched_debug.cfs_rq[22]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~22%    +100.0%          7 ~23%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~ 7%     +87.5%         12 ~13%  lkp-snb01/micro/aim7/string_rtns
        10 ~12%     +92.0%         19 ~17%  TOTAL sched_debug.cfs_rq[16]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         4 ~22%     +75.0%          7 ~20%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~15%     +84.4%         11 ~12%  lkp-snb01/micro/aim7/string_rtns
        10 ~18%     +80.8%         18 ~15%  TOTAL sched_debug.cpu#23.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         4 ~22%     +85.0%          7 ~20%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~14%     +76.5%         12 ~13%  lkp-snb01/micro/aim7/string_rtns
        10 ~17%     +79.6%         19 ~16%  TOTAL sched_debug.cfs_rq[11]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~34%     +94.7%          7 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~10%     +93.3%         11 ~12%  lkp-snb01/micro/aim7/string_rtns
         9 ~19%     +93.9%         19 ~17%  TOTAL sched_debug.cfs_rq[20]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      7562 ~19%     +74.4%      13186 ~13%  lkp-snb01/micro/aim7/string_rtns
      7562 ~19%     +74.4%      13186 ~13%  TOTAL sched_debug.cfs_rq[13]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4492 ~20%     +80.0%       8085 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
      6708 ~15%     +97.0%      13218 ~12%  lkp-snb01/micro/aim7/string_rtns
     11201 ~17%     +90.2%      21303 ~13%  TOTAL sched_debug.cfs_rq[6]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         7 ~15%     +71.4%         12 ~14%  lkp-snb01/micro/aim7/string_rtns
         7 ~15%     +71.4%         12 ~14%  TOTAL sched_debug.cfs_rq[12]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         7 ~15%     +71.4%         12 ~14%  lkp-snb01/micro/aim7/string_rtns
         7 ~15%     +71.4%         12 ~14%  TOTAL sched_debug.cpu#12.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2056 ~14%     -40.0%       1234 ~23%  lkp-snb01/micro/aim7/mem_rtns_1
      2550 ~ 2%     -36.5%       1620 ~12%  lkp-snb01/micro/aim7/string_rtns
      4607 ~ 8%     -38.0%       2855 ~17%  TOTAL sched_debug.cfs_rq[27]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2058 ~14%     -39.9%       1237 ~23%  lkp-snb01/micro/aim7/mem_rtns_1
      2553 ~ 2%     -36.4%       1623 ~12%  lkp-snb01/micro/aim7/string_rtns
      4611 ~ 8%     -38.0%       2860 ~17%  TOTAL sched_debug.cfs_rq[27]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4120 ~18%     +90.6%       7852 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      7112 ~ 7%     +79.0%      12732 ~13%  lkp-snb01/micro/aim7/string_rtns
     11232 ~11%     +83.3%      20585 ~16%  TOTAL sched_debug.cfs_rq[16]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4120 ~18%     +90.6%       7852 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      7117 ~ 7%     +78.8%      12727 ~13%  lkp-snb01/micro/aim7/string_rtns
     11237 ~11%     +83.1%      20579 ~16%  TOTAL sched_debug.cpu#16.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4123 ~20%     +91.8%       7907 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
      7086 ~15%     +81.8%      12882 ~15%  lkp-snb01/micro/aim7/string_rtns
     11209 ~17%     +85.5%      20790 ~15%  TOTAL sched_debug.cfs_rq[14]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4123 ~20%     +91.8%       7907 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
      7081 ~15%     +82.0%      12888 ~15%  lkp-snb01/micro/aim7/string_rtns
     11204 ~17%     +85.6%      20796 ~15%  TOTAL sched_debug.cpu#14.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4481 ~18%     +77.4%       7950 ~17%  lkp-snb01/micro/aim7/mem_rtns_1
      6917 ~ 7%     +89.9%      13135 ~12%  lkp-snb01/micro/aim7/string_rtns
     11399 ~11%     +85.0%      21086 ~14%  TOTAL sched_debug.cfs_rq[5]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3822 ~34%    +107.7%       7940 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      7226 ~22%     +78.4%      12889 ~13%  lkp-snb01/micro/aim7/string_rtns
     11049 ~26%     +88.5%      20829 ~16%  TOTAL sched_debug.cpu#24.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3822 ~34%    +107.7%       7940 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      7226 ~22%     +78.4%      12894 ~13%  lkp-snb01/micro/aim7/string_rtns
     11049 ~26%     +88.6%      20835 ~16%  TOTAL sched_debug.cfs_rq[24]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4576 ~15%     +68.9%       7728 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
      6959 ~10%     +84.8%      12863 ~15%  lkp-snb01/micro/aim7/string_rtns
     11535 ~12%     +78.5%      20591 ~18%  TOTAL sched_debug.cfs_rq[15]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4576 ~15%     +68.9%       7728 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
      6959 ~10%     +84.8%      12863 ~15%  lkp-snb01/micro/aim7/string_rtns
     11535 ~12%     +78.5%      20591 ~18%  TOTAL sched_debug.cpu#15.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      7494 ~13%     +76.0%      13187 ~12%  lkp-snb01/micro/aim7/string_rtns
      7494 ~13%     +76.0%      13187 ~12%  TOTAL sched_debug.cfs_rq[12]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2187 ~37%     -55.2%        980 ~34%  lkp-snb01/micro/aim7/mem_rtns_1
      2895 ~ 8%     -53.2%       1354 ~23%  lkp-snb01/micro/aim7/string_rtns
      5083 ~20%     -54.1%       2334 ~27%  TOTAL sched_debug.cfs_rq[8]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2211 ~13%     -42.9%       1263 ~19%  lkp-snb01/micro/aim7/mem_rtns_1
      3079 ~14%     -55.2%       1379 ~13%  lkp-snb01/micro/aim7/string_rtns
      5290 ~14%     -50.0%       2643 ~16%  TOTAL sched_debug.cfs_rq[30]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4452 ~13%     +80.3%       8029 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      6955 ~12%     +85.1%      12873 ~15%  lkp-snb01/micro/aim7/string_rtns
     11408 ~12%     +83.2%      20902 ~17%  TOTAL sched_debug.cpu#10.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      7019 ~17%     +70.5%      11966 ~16%  lkp-snb01/micro/aim7/string_rtns
      7019 ~17%     +70.5%      11966 ~16%  TOTAL sched_debug.cfs_rq[12]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~25%     +84.2%          7 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~12%    +100.0%         12 ~15%  lkp-snb01/micro/aim7/string_rtns
        10 ~17%     +94.0%         19 ~18%  TOTAL sched_debug.cpu#5.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         4 ~27%     +75.0%          7 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~21%     +82.4%         12 ~14%  lkp-snb01/micro/aim7/string_rtns
        10 ~23%     +79.6%         19 ~18%  TOTAL sched_debug.cfs_rq[4]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~25%     +84.2%          7 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~12%    +100.0%         12 ~15%  lkp-snb01/micro/aim7/string_rtns
        10 ~17%     +94.0%         19 ~18%  TOTAL sched_debug.cfs_rq[5]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         4 ~27%     +75.0%          7 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~21%     +82.4%         12 ~14%  lkp-snb01/micro/aim7/string_rtns
        10 ~23%     +79.6%         19 ~18%  TOTAL sched_debug.cpu#4.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         4 ~27%     +75.0%          7 ~18%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~21%    +103.3%         12 ~14%  lkp-snb01/micro/aim7/string_rtns
        10 ~23%     +92.0%         19 ~15%  TOTAL sched_debug.cfs_rq[2]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         4 ~27%     +75.0%          7 ~18%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~21%    +103.3%         12 ~14%  lkp-snb01/micro/aim7/string_rtns
        10 ~23%     +92.0%         19 ~15%  TOTAL sched_debug.cpu#2.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4446 ~13%     +80.6%       8029 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      6955 ~12%     +85.0%      12867 ~15%  lkp-snb01/micro/aim7/string_rtns
     11401 ~12%     +83.3%      20897 ~17%  TOTAL sched_debug.cfs_rq[10]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3716 ~22%    +112.0%       7879 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
      7183 ~14%     +71.2%      12294 ~13%  lkp-snb01/micro/aim7/string_rtns
     10899 ~17%     +85.1%      20173 ~17%  TOTAL sched_debug.cfs_rq[31]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3716 ~22%    +111.8%       7871 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
      7183 ~14%     +71.2%      12294 ~13%  lkp-snb01/micro/aim7/string_rtns
     10899 ~17%     +85.0%      20165 ~17%  TOTAL sched_debug.cpu#31.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3512 ~24%    +105.3%       7211 ~23%  lkp-snb01/micro/aim7/mem_rtns_1
      6718 ~13%     +70.0%      11419 ~13%  lkp-snb01/micro/aim7/string_rtns
     10231 ~17%     +82.1%      18631 ~17%  TOTAL sched_debug.cfs_rq[31]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4165 ~18%     +81.0%       7540 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      6871 ~10%     +91.4%      13148 ~13%  lkp-snb01/micro/aim7/string_rtns
     11036 ~13%     +87.5%      20689 ~16%  TOTAL sched_debug.cpu#5.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4158 ~18%     +81.3%       7540 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      6871 ~10%     +91.4%      13148 ~13%  lkp-snb01/micro/aim7/string_rtns
     11029 ~13%     +87.6%      20689 ~16%  TOTAL sched_debug.cfs_rq[5]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4479 ~21%     +85.9%       8326 ~15%  lkp-snb01/micro/aim7/mem_rtns_1
      7063 ~12%     +84.6%      13040 ~13%  lkp-snb01/micro/aim7/string_rtns
     11543 ~16%     +85.1%      21366 ~14%  TOTAL sched_debug.cfs_rq[14]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4349 ~28%     +75.4%       7630 ~17%  lkp-snb01/micro/aim7/mem_rtns_1
      7321 ~10%     +76.6%      12933 ~13%  lkp-snb01/micro/aim7/string_rtns
     11671 ~16%     +76.2%      20563 ~15%  TOTAL sched_debug.cfs_rq[7]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4349 ~28%     +75.4%       7630 ~17%  lkp-snb01/micro/aim7/mem_rtns_1
      7321 ~10%     +76.6%      12933 ~13%  lkp-snb01/micro/aim7/string_rtns
     11671 ~16%     +76.2%      20563 ~15%  TOTAL sched_debug.cpu#7.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3859 ~22%     +87.7%       7242 ~18%  lkp-snb01/micro/aim7/mem_rtns_1
      6656 ~17%     +78.8%      11901 ~15%  lkp-snb01/micro/aim7/string_rtns
     10515 ~19%     +82.1%      19143 ~16%  TOTAL sched_debug.cfs_rq[14]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4525 ~23%     +75.5%       7941 ~14%  lkp-snb01/micro/aim7/mem_rtns_1
      6693 ~18%     +87.7%      12564 ~15%  lkp-snb01/micro/aim7/string_rtns
     11219 ~20%     +82.8%      20505 ~14%  TOTAL sched_debug.cfs_rq[9]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4525 ~23%     +75.5%       7941 ~14%  lkp-snb01/micro/aim7/mem_rtns_1
      6693 ~18%     +87.8%      12569 ~15%  lkp-snb01/micro/aim7/string_rtns
     11219 ~20%     +82.8%      20510 ~14%  TOTAL sched_debug.cpu#9.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~34%     +94.7%          7 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~10%     +90.0%         11 ~13%  lkp-snb01/micro/aim7/string_rtns
         9 ~19%     +91.8%         18 ~17%  TOTAL sched_debug.cpu#20.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4527 ~32%     +78.1%       8064 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      7186 ~20%     +70.8%      12276 ~12%  lkp-snb01/micro/aim7/string_rtns
     11713 ~25%     +73.6%      20340 ~15%  TOTAL sched_debug.cpu#30.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4527 ~32%     +78.3%       8071 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      7186 ~20%     +70.8%      12276 ~12%  lkp-snb01/micro/aim7/string_rtns
     11713 ~25%     +73.7%      20347 ~15%  TOTAL sched_debug.cfs_rq[30]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4095 ~31%     +89.4%       7757 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
      7211 ~20%     +74.9%      12610 ~14%  lkp-snb01/micro/aim7/string_rtns
     11307 ~24%     +80.1%      20367 ~17%  TOTAL sched_debug.cfs_rq[22]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4095 ~31%     +89.2%       7749 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
      7216 ~20%     +74.7%      12609 ~14%  lkp-snb01/micro/aim7/string_rtns
     11312 ~24%     +80.0%      20359 ~17%  TOTAL sched_debug.cpu#22.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4320 ~18%     +80.6%       7803 ~20%  lkp-snb01/micro/aim7/mem_rtns_1
      7069 ~12%     +80.1%      12729 ~10%  lkp-snb01/micro/aim7/string_rtns
     11390 ~14%     +80.3%      20532 ~14%  TOTAL sched_debug.cfs_rq[23]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      7532 ~17%     +68.8%      12712 ~14%  lkp-snb01/micro/aim7/string_rtns
      7532 ~17%     +68.8%      12712 ~14%  TOTAL sched_debug.cpu#12.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4156 ~17%     +83.6%       7631 ~18%  lkp-snb01/micro/aim7/mem_rtns_1
      6837 ~17%     +92.9%      13191 ~ 9%  lkp-snb01/micro/aim7/string_rtns
     10993 ~17%     +89.4%      20823 ~12%  TOTAL sched_debug.cfs_rq[6]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4156 ~17%     +83.8%       7639 ~18%  lkp-snb01/micro/aim7/mem_rtns_1
      6837 ~17%     +92.9%      13191 ~ 9%  lkp-snb01/micro/aim7/string_rtns
     10993 ~17%     +89.5%      20831 ~12%  TOTAL sched_debug.cpu#6.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4731 ~26%     +62.1%       7668 ~17%  lkp-snb01/micro/aim7/mem_rtns_1
      6556 ~16%    +100.4%      13141 ~13%  lkp-snb01/micro/aim7/string_rtns
     11288 ~20%     +84.4%      20810 ~14%  TOTAL sched_debug.cpu#2.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4731 ~26%     +62.1%       7668 ~17%  lkp-snb01/micro/aim7/mem_rtns_1
      6561 ~16%    +100.2%      13136 ~13%  lkp-snb01/micro/aim7/string_rtns
     11293 ~20%     +84.2%      20804 ~14%  TOTAL sched_debug.cfs_rq[2]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4151 ~13%     +72.2%       7150 ~27%  lkp-snb01/micro/aim7/mem_rtns_1
      6331 ~14%     +88.5%      11936 ~15%  lkp-snb01/micro/aim7/string_rtns
     10482 ~14%     +82.1%      19087 ~20%  TOTAL sched_debug.cfs_rq[10]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4320 ~18%     +80.6%       7803 ~20%  lkp-snb01/micro/aim7/mem_rtns_1
      7069 ~12%     +80.0%      12724 ~10%  lkp-snb01/micro/aim7/string_rtns
     11390 ~14%     +80.2%      20527 ~14%  TOTAL sched_debug.cpu#23.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      7532 ~17%     +68.8%      12712 ~14%  lkp-snb01/micro/aim7/string_rtns
      7532 ~17%     +68.8%      12712 ~14%  TOTAL sched_debug.cfs_rq[12]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3981 ~28%     +99.9%       7959 ~24%  lkp-snb01/micro/aim7/mem_rtns_1
      7077 ~14%     +76.6%      12497 ~11%  lkp-snb01/micro/aim7/string_rtns
     11058 ~19%     +85.0%      20456 ~16%  TOTAL sched_debug.cpu#21.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3981 ~28%     +99.9%       7959 ~24%  lkp-snb01/micro/aim7/mem_rtns_1
      7082 ~14%     +76.5%      12497 ~11%  lkp-snb01/micro/aim7/string_rtns
     11063 ~19%     +84.9%      20456 ~17%  TOTAL sched_debug.cfs_rq[21]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4730 ~15%     +81.4%       8578 ~17%  lkp-snb01/micro/aim7/mem_rtns_1
      7321 ~10%     +80.7%      13231 ~12%  lkp-snb01/micro/aim7/string_rtns
     12051 ~12%     +81.0%      21810 ~14%  TOTAL sched_debug.cfs_rq[18]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4243 ~17%     +66.3%       7057 ~24%  lkp-snb01/micro/aim7/mem_rtns_1
      6558 ~11%     +82.0%      11938 ~16%  lkp-snb01/micro/aim7/string_rtns
     10801 ~14%     +75.9%      18995 ~19%  TOTAL sched_debug.cfs_rq[15]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4806 ~27%     +76.1%       8464 ~13%  lkp-snb01/micro/aim7/mem_rtns_1
      6820 ~12%     +91.4%      13053 ~11%  lkp-snb01/micro/aim7/string_rtns
     11627 ~18%     +85.1%      21517 ~12%  TOTAL sched_debug.cfs_rq[22]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4581 ~21%     +68.2%       7704 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
      7362 ~23%     +77.9%      13100 ~12%  lkp-snb01/micro/aim7/string_rtns
     11943 ~22%     +74.2%      20804 ~16%  TOTAL sched_debug.cpu#4.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4574 ~21%     +68.4%       7704 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
      7367 ~23%     +77.8%      13100 ~12%  lkp-snb01/micro/aim7/string_rtns
     11942 ~22%     +74.2%      20804 ~16%  TOTAL sched_debug.cfs_rq[4]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3856 ~18%     +76.8%       6818 ~23%  lkp-snb01/micro/aim7/mem_rtns_1
      6450 ~11%     +89.1%      12198 ~13%  lkp-snb01/micro/aim7/string_rtns
     10307 ~14%     +84.5%      19017 ~17%  TOTAL sched_debug.cfs_rq[5]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4407 ~28%     +55.9%       6869 ~20%  lkp-snb01/micro/aim7/mem_rtns_1
      6087 ~15%    +102.2%      12310 ~14%  lkp-snb01/micro/aim7/string_rtns
     10494 ~21%     +82.8%      19179 ~16%  TOTAL sched_debug.cfs_rq[2]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3934 ~14%    +100.2%       7874 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
      7300 ~10%     +73.4%      12659 ~15%  lkp-snb01/micro/aim7/string_rtns
     11234 ~11%     +82.8%      20534 ~19%  TOTAL sched_debug.cfs_rq[26]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3934 ~14%    +100.6%       7890 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
      7310 ~10%     +73.2%      12665 ~15%  lkp-snb01/micro/aim7/string_rtns
     11244 ~11%     +82.8%      20555 ~19%  TOTAL sched_debug.cpu#26.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4771 ~16%     +78.4%       8513 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      6796 ~10%     +90.3%      12934 ~13%  lkp-snb01/micro/aim7/string_rtns
     11568 ~13%     +85.4%      21447 ~16%  TOTAL sched_debug.cfs_rq[10]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4459 ~20%     +83.9%       8201 ~13%  lkp-snb01/micro/aim7/mem_rtns_1
      7193 ~15%     +80.0%      12947 ~12%  lkp-snb01/micro/aim7/string_rtns
     11652 ~17%     +81.5%      21149 ~12%  TOTAL sched_debug.cfs_rq[0]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3838 ~19%     +77.3%       6804 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
      6368 ~18%     +92.1%      12230 ~13%  lkp-snb01/micro/aim7/string_rtns
     10206 ~18%     +86.5%      19035 ~16%  TOTAL sched_debug.cfs_rq[6]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~25%     +78.9%          6 ~17%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~14%     +79.4%         12 ~15%  lkp-snb01/micro/aim7/string_rtns
        10 ~18%     +79.2%         19 ~15%  TOTAL sched_debug.cpu#3.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~28%    +105.6%          7 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
         3 ~28%    +105.6%          7 ~25%  TOTAL sched_debug.cpu#27.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~22%    +100.0%          7 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~20%     +84.8%         12 ~15%  lkp-snb01/micro/aim7/string_rtns
        10 ~21%     +90.2%         19 ~18%  TOTAL sched_debug.cfs_rq[0]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~25%     +78.9%          6 ~17%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~14%     +79.4%         12 ~15%  lkp-snb01/micro/aim7/string_rtns
        10 ~18%     +79.2%         19 ~15%  TOTAL sched_debug.cfs_rq[3]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~22%    +100.0%          7 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~20%     +84.8%         12 ~15%  lkp-snb01/micro/aim7/string_rtns
        10 ~21%     +90.2%         19 ~18%  TOTAL sched_debug.cpu#0.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~28%    +105.6%          7 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
         3 ~28%    +105.6%          7 ~25%  TOTAL sched_debug.cfs_rq[27]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4622 ~20%     +71.8%       7944 ~20%  lkp-snb01/micro/aim7/mem_rtns_1
      7408 ~15%     +72.0%      12744 ~14%  lkp-snb01/micro/aim7/string_rtns
     12031 ~17%     +72.0%      20688 ~16%  TOTAL sched_debug.cfs_rq[11]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4622 ~20%     +71.8%       7944 ~20%  lkp-snb01/micro/aim7/mem_rtns_1
      7403 ~15%     +72.1%      12744 ~14%  lkp-snb01/micro/aim7/string_rtns
     12026 ~17%     +72.0%      20688 ~16%  TOTAL sched_debug.cpu#11.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3837 ~20%     +83.2%       7028 ~23%  lkp-snb01/micro/aim7/mem_rtns_1
      6692 ~10%     +77.6%      11884 ~14%  lkp-snb01/micro/aim7/string_rtns
     10529 ~14%     +79.6%      18913 ~17%  TOTAL sched_debug.cfs_rq[16]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3863 ~33%     +82.2%       7039 ~24%  lkp-snb01/micro/aim7/mem_rtns_1
      6398 ~16%     +83.5%      11739 ~13%  lkp-snb01/micro/aim7/string_rtns
     10261 ~23%     +83.0%      18778 ~17%  TOTAL sched_debug.cfs_rq[22]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4517 ~21%     +94.2%       8773 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
      7232 ~ 7%     +76.4%      12760 ~10%  lkp-snb01/micro/aim7/string_rtns
     11749 ~13%     +83.3%      21533 ~13%  TOTAL sched_debug.cfs_rq[31]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4108 ~24%     +71.4%       7041 ~19%  lkp-snb01/micro/aim7/mem_rtns_1
      6375 ~20%     +85.1%      11801 ~16%  lkp-snb01/micro/aim7/string_rtns
     10483 ~21%     +79.7%      18843 ~17%  TOTAL sched_debug.cfs_rq[9]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3768 ~19%     +90.2%       7169 ~26%  lkp-snb01/micro/aim7/mem_rtns_1
      6718 ~14%     +75.3%      11777 ~13%  lkp-snb01/micro/aim7/string_rtns
     10486 ~16%     +80.7%      18946 ~18%  TOTAL sched_debug.cfs_rq[18]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4944 ~25%     +70.6%       8434 ~18%  lkp-snb01/micro/aim7/mem_rtns_1
      6707 ~ 7%     +93.5%      12978 ~11%  lkp-snb01/micro/aim7/string_rtns
     11652 ~14%     +83.8%      21412 ~14%  TOTAL sched_debug.cfs_rq[20]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4247 ~34%     +73.2%       7356 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
      6616 ~20%     +72.9%      11436 ~14%  lkp-snb01/micro/aim7/string_rtns
     10863 ~25%     +73.0%      18792 ~17%  TOTAL sched_debug.cfs_rq[30]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~34%    +100.0%          7 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~24%     +75.8%         11 ~11%  lkp-snb01/micro/aim7/string_rtns
        10 ~28%     +84.6%         19 ~15%  TOTAL sched_debug.cfs_rq[30]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~34%    +100.0%          7 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~24%     +75.8%         11 ~11%  lkp-snb01/micro/aim7/string_rtns
        10 ~28%     +84.6%         19 ~15%  TOTAL sched_debug.cpu#30.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~23%    +111.8%          7 ~30%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~ 7%     +78.8%         11 ~17%  lkp-snb01/micro/aim7/string_rtns
        10 ~12%     +90.0%         19 ~22%  TOTAL sched_debug.cfs_rq[26]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~23%    +111.8%          7 ~30%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~ 7%     +78.8%         11 ~17%  lkp-snb01/micro/aim7/string_rtns
        10 ~12%     +90.0%         19 ~22%  TOTAL sched_debug.cpu#26.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4819 ~25%     +68.9%       8138 ~13%  lkp-snb01/micro/aim7/mem_rtns_1
      7443 ~ 9%     +77.1%      13184 ~13%  lkp-snb01/micro/aim7/string_rtns
     12263 ~16%     +73.9%      21323 ~13%  TOTAL sched_debug.cfs_rq[3]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4217 ~20%     +91.1%       8059 ~24%  lkp-snb01/micro/aim7/mem_rtns_1
      4217 ~20%     +91.1%       8059 ~24%  TOTAL sched_debug.cpu#27.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4217 ~20%     +91.1%       8059 ~24%  lkp-snb01/micro/aim7/mem_rtns_1
      4217 ~20%     +91.1%       8059 ~24%  TOTAL sched_debug.cfs_rq[27]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4742 ~22%     +82.3%       8643 ~18%  lkp-snb01/micro/aim7/mem_rtns_1
      7371 ~11%     +75.6%      12945 ~10%  lkp-snb01/micro/aim7/string_rtns
     12113 ~16%     +78.2%      21589 ~13%  TOTAL sched_debug.cfs_rq[21]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3786 ~29%     +88.6%       7141 ~28%  lkp-snb01/micro/aim7/mem_rtns_1
      6739 ~14%     +74.7%      11777 ~12%  lkp-snb01/micro/aim7/string_rtns
     10526 ~20%     +79.7%      18919 ~18%  TOTAL sched_debug.cfs_rq[21]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4936 ~26%     +61.1%       7954 ~17%  lkp-snb01/micro/aim7/mem_rtns_1
      7400 ~ 7%     +77.5%      13136 ~12%  lkp-snb01/micro/aim7/string_rtns
     12336 ~14%     +71.0%      21091 ~14%  TOTAL sched_debug.cfs_rq[7]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         6 ~15%     +81.8%         12 ~13%  lkp-snb01/micro/aim7/string_rtns
         6 ~15%     +81.8%         12 ~13%  TOTAL sched_debug.cpu#25.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         6 ~15%     +81.8%         12 ~13%  lkp-snb01/micro/aim7/string_rtns
         6 ~15%     +81.8%         12 ~13%  TOTAL sched_debug.cfs_rq[25]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         6 ~15%     +81.8%         12 ~13%  lkp-snb01/micro/aim7/string_rtns
         6 ~15%     +81.8%         12 ~13%  TOTAL sched_debug.cpu#8.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         6 ~15%     +81.8%         12 ~13%  lkp-snb01/micro/aim7/string_rtns
         6 ~15%     +81.8%         12 ~13%  TOTAL sched_debug.cfs_rq[8]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      6969 ~ 9%     +75.5%      12234 ~14%  lkp-snb01/micro/aim7/string_rtns
      6969 ~ 9%     +75.5%      12234 ~14%  TOTAL sched_debug.cfs_rq[7]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3740 ~18%     +94.0%       7255 ~27%  lkp-snb01/micro/aim7/mem_rtns_1
      6846 ~ 9%     +72.6%      11817 ~17%  lkp-snb01/micro/aim7/string_rtns
     10586 ~12%     +80.2%      19073 ~21%  TOTAL sched_debug.cfs_rq[26]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4541 ~26%     +75.4%       7965 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      6730 ~ 8%     +85.7%      12496 ~11%  lkp-snb01/micro/aim7/string_rtns
     11271 ~15%     +81.5%      20461 ~15%  TOTAL sched_debug.cfs_rq[20]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4127 ~21%     +88.3%       7772 ~20%  lkp-snb01/micro/aim7/mem_rtns_1
      7150 ~19%     +82.4%      13038 ~12%  lkp-snb01/micro/aim7/string_rtns
     11277 ~20%     +84.5%      20810 ~15%  TOTAL sched_debug.cfs_rq[0]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4134 ~21%     +88.0%       7772 ~20%  lkp-snb01/micro/aim7/mem_rtns_1
      7150 ~19%     +82.4%      13038 ~12%  lkp-snb01/micro/aim7/string_rtns
     11284 ~20%     +84.4%      20810 ~15%  TOTAL sched_debug.cpu#0.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4541 ~26%     +75.4%       7965 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      6730 ~ 8%     +85.6%      12490 ~11%  lkp-snb01/micro/aim7/string_rtns
     11271 ~15%     +81.5%      20455 ~15%  TOTAL sched_debug.cpu#20.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4941 ~16%     +67.3%       8265 ~15%  lkp-snb01/micro/aim7/mem_rtns_1
      6934 ~ 7%     +90.2%      13185 ~13%  lkp-snb01/micro/aim7/string_rtns
     11875 ~10%     +80.6%      21451 ~13%  TOTAL sched_debug.cfs_rq[15]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      5004 ~18%     +70.7%       8542 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
      7040 ~11%     +89.5%      13341 ~10%  lkp-snb01/micro/aim7/string_rtns
     12044 ~14%     +81.7%      21884 ~12%  TOTAL sched_debug.cfs_rq[23]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      5778 ~31%     +34.8%       7787 ~15%  lkp-snb01/micro/aim7/mem_rtns_1
      7493 ~22%     +70.7%      12791 ~14%  lkp-snb01/micro/aim7/string_rtns
     13272 ~26%     +55.1%      20579 ~14%  TOTAL sched_debug.cfs_rq[13]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4666 ~25%     +76.1%       8215 ~15%  lkp-snb01/micro/aim7/mem_rtns_1
      7316 ~18%     +79.1%      13102 ~13%  lkp-snb01/micro/aim7/string_rtns
     11983 ~20%     +77.9%      21317 ~14%  TOTAL sched_debug.cfs_rq[4]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      5778 ~31%     +34.8%       7787 ~15%  lkp-snb01/micro/aim7/mem_rtns_1
      7493 ~22%     +70.6%      12780 ~14%  lkp-snb01/micro/aim7/string_rtns
     13272 ~26%     +55.0%      20568 ~14%  TOTAL sched_debug.cpu#13.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      5927 ~15%     +71.6%      10173 ~15%  lkp-snb01/micro/aim7/mem_rtns_1
      8563 ~14%     +68.6%      14433 ~15%  lkp-snb01/micro/aim7/string_rtns
     14490 ~14%     +69.8%      24606 ~15%  TOTAL sched_debug.cfs_rq[25]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4403 ~19%     +62.2%       7142 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      6878 ~15%     +75.0%      12038 ~15%  lkp-snb01/micro/aim7/string_rtns
     11282 ~16%     +70.0%      19181 ~17%  TOTAL sched_debug.cfs_rq[11]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4004 ~20%     +76.9%       7084 ~23%  lkp-snb01/micro/aim7/mem_rtns_1
      6568 ~15%     +82.3%      11975 ~11%  lkp-snb01/micro/aim7/string_rtns
     10573 ~17%     +80.3%      19059 ~16%  TOTAL sched_debug.cfs_rq[23]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4127 ~24%     +68.1%       6937 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
      6876 ~22%     +76.2%      12115 ~14%  lkp-snb01/micro/aim7/string_rtns
     11004 ~23%     +73.1%      19052 ~17%  TOTAL sched_debug.cfs_rq[4]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4620 ~20%     +76.8%       8166 ~15%  lkp-snb01/micro/aim7/mem_rtns_1
      7102 ~ 9%     +85.6%      13182 ~12%  lkp-snb01/micro/aim7/string_rtns
     11722 ~14%     +82.1%      21349 ~13%  TOTAL sched_debug.cfs_rq[16]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3304 ~19%     -39.2%       2010 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      3241 ~ 4%     -33.4%       2157 ~13%  lkp-snb01/micro/aim7/string_rtns
      6545 ~12%     -36.3%       4168 ~17%  TOTAL sched_debug.cfs_rq[27]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4459 ~23%     +69.3%       7551 ~18%  lkp-snb01/micro/aim7/mem_rtns_1
      7515 ~ 8%     +73.7%      13050 ~14%  lkp-snb01/micro/aim7/string_rtns
     11974 ~13%     +72.0%      20601 ~15%  TOTAL sched_debug.cfs_rq[3]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4459 ~23%     +69.2%       7543 ~18%  lkp-snb01/micro/aim7/mem_rtns_1
      7515 ~ 8%     +73.7%      13050 ~14%  lkp-snb01/micro/aim7/string_rtns
     11974 ~13%     +72.0%      20593 ~15%  TOTAL sched_debug.cpu#3.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4204 ~27%     +70.5%       7165 ~24%  lkp-snb01/micro/aim7/mem_rtns_1
      6301 ~10%     +86.0%      11722 ~12%  lkp-snb01/micro/aim7/string_rtns
     10505 ~17%     +79.8%      18888 ~17%  TOTAL sched_debug.cfs_rq[20]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4935 ~21%     +76.3%       8699 ~16%  lkp-snb01/micro/aim7/mem_rtns_1
      4935 ~21%     +76.3%       8699 ~16%  TOTAL sched_debug.cfs_rq[27]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
       314 ~16%     +48.6%        467 ~13%  lkp-snb01/micro/aim7/string_rtns
       314 ~16%     +48.6%        467 ~13%  TOTAL vmstat.procs.r

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4365 ~20%     +76.5%       7704 ~24%  lkp-snb01/micro/aim7/mem_rtns_1
      7006 ~14%     +81.8%      12738 ~12%  lkp-snb01/micro/aim7/string_rtns
     11371 ~16%     +79.8%      20442 ~17%  TOTAL sched_debug.cpu#19.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4365 ~20%     +76.5%       7704 ~24%  lkp-snb01/micro/aim7/mem_rtns_1
      7011 ~14%     +81.6%      12732 ~12%  lkp-snb01/micro/aim7/string_rtns
     11376 ~16%     +79.6%      20436 ~17%  TOTAL sched_debug.cfs_rq[19]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3858 ~22%     +79.2%       6916 ~23%  lkp-snb01/micro/aim7/mem_rtns_1
      6793 ~19%     +78.4%      12118 ~13%  lkp-snb01/micro/aim7/string_rtns
     10652 ~20%     +78.7%      19035 ~17%  TOTAL sched_debug.cfs_rq[0]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4886 ~18%     +80.8%       8831 ~17%  lkp-snb01/micro/aim7/mem_rtns_1
      7463 ~ 8%     +78.4%      13313 ~13%  lkp-snb01/micro/aim7/string_rtns
     12349 ~12%     +79.3%      22145 ~14%  TOTAL sched_debug.cfs_rq[26]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1.66 ~12%     +41.6%       2.35 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      1.66 ~12%     +41.6%       2.35 ~21%  TOTAL sched_debug.cfs_rq[21]:/.spread

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4244 ~15%     +69.4%       7192 ~26%  lkp-snb01/micro/aim7/mem_rtns_1
      6971 ~17%     +74.5%      12163 ~15%  lkp-snb01/micro/aim7/string_rtns
     11216 ~16%     +72.6%      19355 ~19%  TOTAL sched_debug.cfs_rq[25]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4950 ~20%     +67.5%       8291 ~18%  lkp-snb01/micro/aim7/mem_rtns_1
      7075 ~10%     +87.8%      13289 ~13%  lkp-snb01/micro/aim7/string_rtns
     12026 ~14%     +79.5%      21581 ~15%  TOTAL sched_debug.cfs_rq[19]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4005 ~21%     +82.8%       7323 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
      4005 ~21%     +82.8%       7323 ~25%  TOTAL sched_debug.cfs_rq[27]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~25%     +89.5%          7 ~26%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~15%     +81.8%         12 ~13%  lkp-snb01/micro/aim7/string_rtns
        10 ~19%     +84.6%         19 ~18%  TOTAL sched_debug.cpu#19.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
         3 ~25%     +89.5%          7 ~26%  lkp-snb01/micro/aim7/mem_rtns_1
         6 ~15%     +81.8%         12 ~13%  lkp-snb01/micro/aim7/string_rtns
        10 ~19%     +84.6%         19 ~18%  TOTAL sched_debug.cfs_rq[19]:/.nr_running

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      5811 ~15%     +40.4%       8160 ~15%  lkp-snb01/micro/aim7/mem_rtns_1
      7241 ~ 4%     +83.0%      13253 ~12%  lkp-snb01/micro/aim7/string_rtns
     13052 ~ 9%     +64.1%      21413 ~13%  TOTAL sched_debug.cfs_rq[1]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      5543 ~19%     +48.9%       8253 ~18%  lkp-snb01/micro/aim7/mem_rtns_1
      7408 ~ 9%     +75.2%      12977 ~13%  lkp-snb01/micro/aim7/string_rtns
     12951 ~13%     +63.9%      21231 ~15%  TOTAL sched_debug.cfs_rq[8]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4190 ~26%     +62.0%       6786 ~21%  lkp-snb01/micro/aim7/mem_rtns_1
      6978 ~13%     +74.3%      12163 ~14%  lkp-snb01/micro/aim7/string_rtns
     11168 ~18%     +69.7%      18949 ~16%  TOTAL sched_debug.cfs_rq[3]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4084 ~22%     +68.8%       6893 ~26%  lkp-snb01/micro/aim7/mem_rtns_1
      6630 ~14%     +80.2%      11951 ~13%  lkp-snb01/micro/aim7/string_rtns
     10715 ~17%     +75.9%      18844 ~18%  TOTAL sched_debug.cfs_rq[19]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4748 ~16%     +67.3%       7942 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
      7379 ~16%     +72.8%      12753 ~14%  lkp-snb01/micro/aim7/string_rtns
     12127 ~16%     +70.6%      20695 ~18%  TOTAL sched_debug.cfs_rq[25]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4748 ~16%     +67.1%       7935 ~25%  lkp-snb01/micro/aim7/mem_rtns_1
      7379 ~16%     +72.7%      12742 ~14%  lkp-snb01/micro/aim7/string_rtns
     12127 ~16%     +70.5%      20677 ~18%  TOTAL sched_debug.cpu#25.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      5198 ~18%     +62.2%       8434 ~17%  lkp-snb01/micro/aim7/mem_rtns_1
      7330 ~12%     +79.2%      13134 ~14%  lkp-snb01/micro/aim7/string_rtns
     12528 ~15%     +72.2%      21568 ~15%  TOTAL sched_debug.cfs_rq[11]:/.tg_load_contrib

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      5121 ~16%     +51.9%       7780 ~18%  lkp-snb01/micro/aim7/mem_rtns_1
      7504 ~13%     +71.3%      12857 ~13%  lkp-snb01/micro/aim7/string_rtns
     12625 ~14%     +63.5%      20637 ~15%  TOTAL sched_debug.cpu#8.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      5121 ~16%     +51.9%       7780 ~18%  lkp-snb01/micro/aim7/mem_rtns_1
      7504 ~13%     +71.4%      12863 ~13%  lkp-snb01/micro/aim7/string_rtns
     12625 ~14%     +63.5%      20643 ~15%  TOTAL sched_debug.cfs_rq[8]:/.load

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      5161 ~15%     +31.8%       6802 ~22%  lkp-snb01/micro/aim7/mem_rtns_1
      6938 ~ 5%     +76.6%      12254 ~14%  lkp-snb01/micro/aim7/string_rtns
     12099 ~10%     +57.5%      19056 ~17%  TOTAL sched_debug.cfs_rq[1]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
        37 ~17%     +53.4%         58 ~10%  lkp-snb01/micro/aim7/mem_rtns_1
        37 ~17%     +53.4%         58 ~10%  TOTAL sched_debug.cpu#17.nr_uninterruptible

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4804 ~17%     +47.8%       7101 ~20%  lkp-snb01/micro/aim7/mem_rtns_1
      7090 ~12%     +70.4%      12079 ~14%  lkp-snb01/micro/aim7/string_rtns
     11894 ~14%     +61.3%      19181 ~16%  TOTAL sched_debug.cfs_rq[8]:/.runnable_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    333840 ~18%     +31.0%     437347 ~10%  lkp-snb01/micro/aim7/string_rtns
    333840 ~18%     +31.0%     437347 ~10%  TOTAL sched_debug.cfs_rq[31]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    333607 ~18%     +31.9%     439964 ~11%  lkp-snb01/micro/aim7/string_rtns
    333607 ~18%     +31.9%     439964 ~11%  TOTAL sched_debug.cfs_rq[30]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    326203 ~17%     +38.2%     450874 ~11%  lkp-snb01/micro/aim7/string_rtns
    326203 ~17%     +38.2%     450874 ~11%  TOTAL sched_debug.cfs_rq[4]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    325845 ~17%     +38.6%     451484 ~11%  lkp-snb01/micro/aim7/string_rtns
    325845 ~17%     +38.6%     451484 ~11%  TOTAL sched_debug.cfs_rq[0]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    326195 ~17%     +38.4%     451377 ~11%  lkp-snb01/micro/aim7/string_rtns
    326195 ~17%     +38.4%     451377 ~11%  TOTAL sched_debug.cfs_rq[1]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    333203 ~18%     +33.3%     444195 ~11%  lkp-snb01/micro/aim7/string_rtns
    333203 ~18%     +33.3%     444195 ~11%  TOTAL sched_debug.cfs_rq[27]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    326221 ~17%     +38.3%     451185 ~11%  lkp-snb01/micro/aim7/string_rtns
    326221 ~17%     +38.3%     451185 ~11%  TOTAL sched_debug.cfs_rq[2]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    333436 ~18%     +33.2%     444044 ~11%  lkp-snb01/micro/aim7/string_rtns
    333436 ~18%     +33.2%     444044 ~11%  TOTAL sched_debug.cfs_rq[28]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    329340 ~17%     +36.1%     448332 ~10%  lkp-snb01/micro/aim7/string_rtns
    329340 ~17%     +36.1%     448332 ~10%  TOTAL sched_debug.cfs_rq[14]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    333702 ~18%     +32.1%     440857 ~11%  lkp-snb01/micro/aim7/string_rtns
    333702 ~18%     +32.1%     440857 ~11%  TOTAL sched_debug.cfs_rq[29]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    326299 ~17%     +38.2%     451040 ~11%  lkp-snb01/micro/aim7/string_rtns
    326299 ~17%     +38.2%     451040 ~11%  TOTAL sched_debug.cfs_rq[3]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    326846 ~17%     +36.1%     444688 ~12%  lkp-snb01/micro/aim7/string_rtns
    326846 ~17%     +36.1%     444688 ~12%  TOTAL sched_debug.cfs_rq[9]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    326435 ~17%     +37.7%     449481 ~11%  lkp-snb01/micro/aim7/string_rtns
    326435 ~17%     +37.7%     449481 ~11%  TOTAL sched_debug.cfs_rq[6]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    326410 ~17%     +37.7%     449406 ~11%  lkp-snb01/micro/aim7/string_rtns
    326410 ~17%     +37.7%     449406 ~11%  TOTAL sched_debug.cfs_rq[7]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    326421 ~17%     +37.8%     449723 ~11%  lkp-snb01/micro/aim7/string_rtns
    326421 ~17%     +37.8%     449723 ~11%  TOTAL sched_debug.cfs_rq[8]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    326267 ~17%     +38.0%     450401 ~11%  lkp-snb01/micro/aim7/string_rtns
    326267 ~17%     +38.0%     450401 ~11%  TOTAL sched_debug.cfs_rq[5]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    329328 ~17%     +36.5%     449616 ~11%  lkp-snb01/micro/aim7/string_rtns
    329328 ~17%     +36.5%     449616 ~11%  TOTAL sched_debug.cfs_rq[13]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    333416 ~18%     +34.6%     448622 ~11%  lkp-snb01/micro/aim7/string_rtns
    333416 ~18%     +34.6%     448622 ~11%  TOTAL sched_debug.cfs_rq[26]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    328975 ~17%     +36.4%     448571 ~11%  lkp-snb01/micro/aim7/string_rtns
    328975 ~17%     +36.4%     448571 ~11%  TOTAL sched_debug.cfs_rq[12]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    328153 ~17%     +36.9%     449282 ~11%  lkp-snb01/micro/aim7/string_rtns
    328153 ~17%     +36.9%     449282 ~11%  TOTAL sched_debug.cfs_rq[11]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    326967 ~17%     +36.3%     445690 ~12%  lkp-snb01/micro/aim7/string_rtns
    326967 ~17%     +36.3%     445690 ~12%  TOTAL sched_debug.cfs_rq[10]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    333421 ~18%     +34.8%     449547 ~11%  lkp-snb01/micro/aim7/string_rtns
    333421 ~18%     +34.8%     449547 ~11%  TOTAL sched_debug.cfs_rq[25]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    332599 ~18%     +35.4%     450220 ~10%  lkp-snb01/micro/aim7/string_rtns
    332599 ~18%     +35.4%     450220 ~10%  TOTAL sched_debug.cfs_rq[23]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    332751 ~18%     +35.1%     449412 ~10%  lkp-snb01/micro/aim7/string_rtns
    332751 ~18%     +35.1%     449412 ~10%  TOTAL sched_debug.cfs_rq[24]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    330828 ~17%     +35.0%     446489 ~10%  lkp-snb01/micro/aim7/string_rtns
    330828 ~17%     +35.0%     446489 ~10%  TOTAL sched_debug.cfs_rq[18]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    329651 ~17%     +35.5%     446715 ~10%  lkp-snb01/micro/aim7/string_rtns
    329651 ~17%     +35.5%     446715 ~10%  TOTAL sched_debug.cfs_rq[15]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    330480 ~17%     +35.2%     446946 ~10%  lkp-snb01/micro/aim7/string_rtns
    330480 ~17%     +35.2%     446946 ~10%  TOTAL sched_debug.cfs_rq[17]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    330087 ~17%     +35.4%     446913 ~10%  lkp-snb01/micro/aim7/string_rtns
    330087 ~17%     +35.4%     446913 ~10%  TOTAL sched_debug.cfs_rq[16]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    332065 ~18%     +34.9%     447945 ~10%  lkp-snb01/micro/aim7/string_rtns
    332065 ~18%     +34.9%     447945 ~10%  TOTAL sched_debug.cfs_rq[22]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2.36 ~38%     +55.6%       3.68 ~ 7%  lkp-snb01/micro/aim7/string_rtns
      2.36 ~38%     +55.6%       3.68 ~ 7%  TOTAL turbostat.%pc6

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    331610 ~17%     +34.7%     446605 ~10%  lkp-snb01/micro/aim7/string_rtns
    331610 ~17%     +34.7%     446605 ~10%  TOTAL sched_debug.cfs_rq[21]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2732 ~15%     +30.3%       3558 ~15%  lkp-snb01/micro/aim7/mem_rtns_1
      2732 ~15%     +30.3%       3558 ~15%  TOTAL sched_debug.cpu#19.nr_switches

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    331044 ~17%     +34.9%     446554 ~10%  lkp-snb01/micro/aim7/string_rtns
    331044 ~17%     +34.9%     446554 ~10%  TOTAL sched_debug.cfs_rq[19]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    331232 ~17%     +34.5%     445362 ~10%  lkp-snb01/micro/aim7/string_rtns
    331232 ~17%     +34.5%     445362 ~10%  TOTAL sched_debug.cfs_rq[20]:/.tg_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2.03 ~19%     +38.4%       2.80 ~18%  lkp-snb01/micro/aim7/mem_rtns_1
      2.03 ~19%     +38.4%       2.80 ~18%  TOTAL sched_debug.cfs_rq[6]:/.spread

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1.97 ~11%     +42.9%       2.81 ~18%  lkp-snb01/micro/aim7/mem_rtns_1
      1.97 ~11%     +42.9%       2.81 ~18%  TOTAL sched_debug.cfs_rq[7]:/.spread

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      9284 ~ 6%     +37.0%      12715 ~15%  lkp-snb01/micro/aim7/mem_rtns_1
      7505 ~ 6%     +25.4%       9408 ~11%  lkp-snb01/micro/aim7/string_rtns
     16789 ~ 6%     +31.8%      22123 ~13%  TOTAL sched_debug.cfs_rq[17]:/.blocked_load_avg

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2244 ~ 9%     +22.9%       2758 ~ 6%  lkp-snb01/micro/aim7/mem_rtns_1
      2244 ~ 9%     +22.9%       2758 ~ 6%  TOTAL sched_debug.cpu#22.nr_switches

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1836 ~ 9%     +24.2%       2281 ~ 5%  lkp-snb01/micro/aim7/mem_rtns_1
      3161 ~ 3%     +21.6%       3844 ~ 1%  lkp-snb01/micro/aim7/string_rtns
      4998 ~ 5%     +22.6%       6125 ~ 2%  TOTAL sched_debug.cpu#24.nr_switches

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2284 ~13%     +19.1%       2721 ~ 4%  lkp-snb01/micro/aim7/mem_rtns_1
      2284 ~13%     +19.1%       2721 ~ 4%  TOTAL sched_debug.cpu#21.nr_switches

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1378 ~16%     -25.0%       1033 ~11%  lkp-snb01/micro/aim7/mem_rtns_1
      1378 ~16%     -25.0%       1033 ~11%  TOTAL sched_debug.cfs_rq[28]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1380 ~16%     -25.0%       1035 ~11%  lkp-snb01/micro/aim7/mem_rtns_1
      1380 ~16%     -25.0%       1035 ~11%  TOTAL sched_debug.cfs_rq[28]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     10921 ~ 3%     -27.9%       7876 ~33%  lkp-snb01/micro/aim7/string_rtns
     10921 ~ 3%     -27.9%       7876 ~33%  TOTAL sched_debug.cfs_rq[10]:/.MIN_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     10924 ~ 3%     -27.9%       7879 ~33%  lkp-snb01/micro/aim7/string_rtns
     10924 ~ 3%     -27.9%       7879 ~33%  TOTAL sched_debug.cfs_rq[10]:/.max_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     16643 ~ 8%     -12.6%      14553 ~10%  lkp-snb01/micro/aim7/mem_rtns_1
     16643 ~ 8%     -12.6%      14553 ~10%  TOTAL sched_debug.cfs_rq[18]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2136 ~13%     -24.8%       1607 ~ 6%  lkp-snb01/micro/aim7/mem_rtns_1
      2136 ~13%     -24.8%       1607 ~ 6%  TOTAL sched_debug.cfs_rq[28]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2017 ~11%     +29.8%       2618 ~ 6%  lkp-snb01/micro/aim7/mem_rtns_1
      3333 ~ 4%     +21.1%       4035 ~ 6%  lkp-snb01/micro/aim7/string_rtns
      5350 ~ 7%     +24.4%       6654 ~ 6%  TOTAL sched_debug.cpu#15.nr_switches

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      6679 ~ 9%     +15.4%       7708 ~ 8%  lkp-snb01/micro/aim7/string_rtns
      6679 ~ 9%     +15.4%       7708 ~ 8%  TOTAL sched_debug.cpu#0.nr_switches

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2022 ~ 8%     +14.5%       2314 ~ 3%  lkp-snb01/micro/aim7/mem_rtns_1
      3283 ~ 5%     +21.7%       3994 ~ 5%  lkp-snb01/micro/aim7/string_rtns
      5305 ~ 6%     +18.9%       6309 ~ 4%  TOTAL sched_debug.cpu#23.nr_switches

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1847 ~11%     +23.7%       2285 ~ 2%  lkp-snb01/micro/aim7/mem_rtns_1
      3275 ~ 4%     +18.5%       3881 ~ 3%  lkp-snb01/micro/aim7/string_rtns
      5123 ~ 7%     +20.4%       6167 ~ 3%  TOTAL sched_debug.cpu#31.nr_switches

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     29310 ~10%     +25.6%      36808 ~ 5%  lkp-snb01/micro/aim7/mem_rtns_1
     29310 ~10%     +25.6%      36808 ~ 5%  TOTAL numa-vmstat.node0.nr_active_anon

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     29349 ~10%     +25.6%      36859 ~ 5%  lkp-snb01/micro/aim7/mem_rtns_1
     29349 ~10%     +25.6%      36859 ~ 5%  TOTAL numa-vmstat.node0.nr_anon_pages

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    118584 ~10%     +25.4%     148734 ~ 5%  lkp-snb01/micro/aim7/mem_rtns_1
    118584 ~10%     +25.4%     148734 ~ 5%  TOTAL numa-meminfo.node0.Active(anon)

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    118777 ~10%     +25.4%     148959 ~ 5%  lkp-snb01/micro/aim7/mem_rtns_1
    118777 ~10%     +25.4%     148959 ~ 5%  TOTAL numa-meminfo.node0.AnonPages

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      1946 ~ 3%     +19.1%       2318 ~ 6%  lkp-snb01/micro/aim7/mem_rtns_1
      3288 ~ 2%     +18.6%       3901 ~ 5%  lkp-snb01/micro/aim7/string_rtns
      5234 ~ 3%     +18.8%       6219 ~ 5%  TOTAL sched_debug.cpu#16.nr_switches

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3625 ~ 6%     +16.8%       4235 ~ 5%  lkp-snb01/micro/aim7/string_rtns
      3625 ~ 6%     +16.8%       4235 ~ 5%  TOTAL sched_debug.cpu#14.nr_switches

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     15491 ~ 1%     -25.9%      11481 ~32%  lkp-snb01/micro/aim7/string_rtns
     15491 ~ 1%     -25.9%      11481 ~32%  TOTAL sched_debug.cfs_rq[10]:/.min_vruntime

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3948 ~ 7%     +18.0%       4661 ~ 3%  lkp-snb01/micro/aim7/mem_rtns_1
      3948 ~ 7%     +18.0%       4661 ~ 3%  TOTAL sched_debug.cpu#2.nr_switches

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4693 ~ 6%     +17.7%       5523 ~15%  lkp-snb01/micro/aim7/mem_rtns_1
      4693 ~ 6%     +17.7%       5523 ~15%  TOTAL sched_debug.cpu#8.nr_switches

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3772 ~10%     +19.5%       4509 ~ 8%  lkp-snb01/micro/aim7/string_rtns
      3772 ~10%     +19.5%       4509 ~ 8%  TOTAL sched_debug.cpu#6.nr_switches

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2.81 ~ 6%     +14.5%       3.21 ~ 8%  lkp-snb01/micro/aim7/string_rtns
      2.81 ~ 6%     +14.5%       3.21 ~ 8%  TOTAL sched_debug.cfs_rq[15]:/.spread

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     72853 ~ 2%     +18.9%      86640 ~ 1%  lkp-snb01/micro/aim7/mem_rtns_1
     25433 ~ 1%      +9.3%      27785 ~ 1%  lkp-snb01/micro/aim7/string_rtns
     98286 ~ 2%     +16.4%     114426 ~ 1%  TOTAL proc-vmstat.nr_anon_pages

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     72973 ~ 2%     +18.9%      86770 ~ 1%  lkp-snb01/micro/aim7/mem_rtns_1
     25568 ~ 1%      +9.3%      27936 ~ 1%  lkp-snb01/micro/aim7/string_rtns
     98541 ~ 2%     +16.4%     114706 ~ 1%  TOTAL proc-vmstat.nr_active_anon

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      3425 ~ 2%     +14.6%       3926 ~ 1%  lkp-snb01/micro/aim7/string_rtns
      3425 ~ 2%     +14.6%       3926 ~ 1%  TOTAL sched_debug.cpu#30.nr_switches

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    290184 ~ 2%     +18.8%     344793 ~ 2%  lkp-snb01/micro/aim7/mem_rtns_1
    101206 ~ 1%      +9.6%     110954 ~ 2%  lkp-snb01/micro/aim7/string_rtns
    391391 ~ 2%     +16.4%     455747 ~ 2%  TOTAL meminfo.AnonPages

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    290692 ~ 2%     +18.8%     345334 ~ 2%  lkp-snb01/micro/aim7/mem_rtns_1
    101757 ~ 1%      +9.6%     111563 ~ 2%  lkp-snb01/micro/aim7/string_rtns
    392449 ~ 2%     +16.4%     456898 ~ 2%  TOTAL meminfo.Active(anon)

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     64270 ~ 5%      +9.9%      70606 ~ 1%  lkp-snb01/micro/aim7/string_rtns
     64270 ~ 5%      +9.9%      70606 ~ 1%  TOTAL numa-meminfo.node1.AnonPages

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4001 ~ 4%     +13.6%       4545 ~ 6%  lkp-snb01/micro/aim7/string_rtns
      4001 ~ 4%     +13.6%       4545 ~ 6%  TOTAL sched_debug.cpu#27.nr_switches

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4002 ~ 3%     -10.4%       3586 ~ 4%  lkp-snb01/micro/aim7/mem_rtns_1
      4747 ~ 4%     -10.5%       4247 ~ 3%  lkp-snb01/micro/aim7/string_rtns
      8750 ~ 4%     -10.5%       7834 ~ 3%  TOTAL sched_debug.cpu#12.curr->pid

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     65135 ~ 5%      +9.5%      71327 ~ 1%  lkp-snb01/micro/aim7/string_rtns
     65135 ~ 5%      +9.5%      71327 ~ 1%  TOTAL numa-meminfo.node1.Active(anon)

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    411079 ~ 1%     +13.3%     465658 ~ 1%  lkp-snb01/micro/aim7/mem_rtns_1
    411079 ~ 1%     +13.3%     465658 ~ 1%  TOTAL meminfo.Active

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2921 ~ 5%      -9.0%       2659 ~ 7%  lkp-snb01/micro/aim7/mem_rtns_1
      2921 ~ 5%      -9.0%       2659 ~ 7%  TOTAL proc-vmstat.nr_alloc_batch

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     15956 ~ 5%      +9.9%      17540 ~ 2%  lkp-snb01/micro/aim7/string_rtns
     15956 ~ 5%      +9.9%      17540 ~ 2%  TOTAL numa-vmstat.node1.nr_anon_pages

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4417 ~ 1%      -7.9%       4069 ~ 4%  lkp-snb01/micro/aim7/string_rtns
      4417 ~ 1%      -7.9%       4069 ~ 4%  TOTAL sched_debug.cpu#8.curr->pid

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     16169 ~ 5%      +9.6%      17715 ~ 2%  lkp-snb01/micro/aim7/string_rtns
     16169 ~ 5%      +9.6%      17715 ~ 2%  TOTAL numa-vmstat.node1.nr_active_anon

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     10921 ~ 4%    +100.2%      21866 ~ 5%  lkp-snb01/micro/aim7/mem_rtns_1
     14698 ~ 2%     +70.8%      25105 ~ 6%  lkp-snb01/micro/aim7/string_rtns
     25619 ~ 3%     +83.3%      46971 ~ 6%  TOTAL time.voluntary_context_switches

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
    108350 ~ 8%     +36.1%     147414 ~ 2%  lkp-snb01/micro/aim7/mem_rtns_1
    203874 ~ 4%     +25.6%     256056 ~ 2%  lkp-snb01/micro/aim7/string_rtns
    312225 ~ 5%     +29.2%     403471 ~ 2%  TOTAL time.involuntary_context_switches

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      4340 ~ 5%     +32.7%       5757 ~ 1%  lkp-snb01/micro/aim7/mem_rtns_1
      5348 ~ 3%     +23.9%       6629 ~ 1%  lkp-snb01/micro/aim7/string_rtns
      9689 ~ 4%     +27.8%      12387 ~ 1%  TOTAL vmstat.system.cs

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      5493 ~ 0%      +4.5%       5743 ~ 0%  lkp-snb01/micro/aim7/mem_rtns_1
      6164 ~ 0%      +3.8%       6398 ~ 0%  lkp-snb01/micro/aim7/string_rtns
     11658 ~ 0%      +4.1%      12141 ~ 0%  TOTAL vmstat.system.in

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
       687 ~ 0%      +1.4%        697 ~ 0%  lkp-snb01/micro/aim7/mem_rtns_1
       687 ~ 0%      +1.4%        697 ~ 0%  TOTAL time.user_time

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
     66.56 ~ 0%      +0.8%      67.08 ~ 0%  lkp-snb01/micro/aim7/mem_rtns_1
     76.23 ~ 0%      +0.3%      76.50 ~ 0%  lkp-snb01/micro/aim7/string_rtns
    142.79 ~ 0%      +0.5%     143.58 ~ 0%  TOTAL turbostat.%c0

6fba979e9beda66  7eb745ea4b5328e9e8d369c0c  
---------------  -------------------------  
      2147 ~ 0%      +0.8%       2165 ~ 0%  lkp-snb01/micro/aim7/mem_rtns_1
      2458 ~ 0%      +0.3%       2466 ~ 0%  lkp-snb01/micro/aim7/string_rtns
      4605 ~ 0%      +0.6%       4631 ~ 0%  TOTAL time.percent_of_cpu_this_job_got




                           time.voluntary_context_switches

   28000 ++-----------------------------------------------------------O-----+
         |                                                                  |
   26000 ++                           O     O                     O         |
   24000 ++           O  O         O     O     O      O     O            O  O
         O  O  O   O                              O      O     O            |
   22000 ++                 O  O                                            |
         |                                                                  |
   20000 ++                                 *..*                            |
         |                                 :    :                           |
   18000 ++                                :    :                           |
   16000 ++                               :      :                          |
         *..*..  ..*..  .*..   *...*..*.. :      :               .*...      |
   14000 ++    *.     *.     ..          *        *...  .*..*..*.     *     |
         |                  *                         *.                    |
   12000 ++-----------------------------------------------------------------+



Thanks,
Fengguang
