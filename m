Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbaCDB7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 20:59:01 -0500
Received: from mga14.intel.com ([143.182.124.37]:31858 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241AbaCDB7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 20:59:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,582,1389772800"; 
   d="scan'208";a="485512582"
Date: Tue, 4 Mar 2014 09:58:45 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Alex Shi <alex.shi@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [sched/balance] 815296e0446: -71.2% cpuidle.C3-SNB.time
Message-ID: <20140304015845.GA12265@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex,

FYI, we noticed the below changes on commit

https://github.com/alexshi/power-scheduling.git single-balance
815296e0446ff6c405ef647082024ce3d8183e10 ("sched: unify imbalance bias for target group")

test case: lkp-snb01/micro/aim7/compute

bf0607d57b0b3ef  815296e0446ff6c405ef64708  
---------------  -------------------------  
    465050 ~ 9%     -71.2%     134141 ~16%   cpuidle.C3-SNB.time
     10109 ~33%     -63.0%       3743 ~25%   sched_debug.cfs_rq[20]:/.min_vruntime
      7163 ~31%     -63.2%       2638 ~22%   sched_debug.cfs_rq[20]:/.MIN_vruntime
      7166 ~31%     -63.1%       2641 ~22%   sched_debug.cfs_rq[20]:/.max_vruntime
      1722 ~10%     -34.7%       1124 ~27%   sched_debug.cfs_rq[13]:/.MIN_vruntime
      1725 ~10%     -34.6%       1127 ~27%   sched_debug.cfs_rq[13]:/.max_vruntime
      7774 ~18%     +47.0%      11430 ~22%   sched_debug.cfs_rq[9]:/.runnable_load_avg
      8117 ~18%     +47.2%      11946 ~20%   sched_debug.cfs_rq[9]:/.load
      8106 ~18%     +47.4%      11946 ~20%   sched_debug.cpu#9.load
      7787 ~18%     +47.1%      11457 ~22%   sched_debug.cpu#9.cpu_load
      7319 ~23%     +42.4%      10420 ~21%   sched_debug.cpu#30.cpu_load
      7287 ~23%     +42.8%      10404 ~21%   sched_debug.cfs_rq[30]:/.runnable_load_avg
      7757 ~19%     +58.1%      12268 ~31%   sched_debug.cfs_rq[26]:/.tg_load_contrib
      7821 ~21%     +52.2%      11904 ~24%   sched_debug.cpu#11.cpu_load
      7956 ~18%     +49.0%      11856 ~24%   sched_debug.cfs_rq[11]:/.runnable_load_avg
      1722 ~16%     -42.6%        989 ~24%   sched_debug.cfs_rq[6]:/.MIN_vruntime
      1726 ~16%     -42.5%        991 ~24%   sched_debug.cfs_rq[6]:/.max_vruntime
      8357 ~15%     +44.4%      12068 ~19%   sched_debug.cfs_rq[9]:/.tg_load_contrib
      8513 ~15%     +48.6%      12648 ~22%   sched_debug.cfs_rq[11]:/.tg_load_contrib
      2050 ~19%     -34.7%       1339 ~24%   sched_debug.cfs_rq[6]:/.min_vruntime
      7278 ~16%     +46.6%      10667 ~21%   sched_debug.cpu#25.cpu_load
         7 ~20%     +48.6%         11 ~19%   sched_debug.cpu#9.nr_running
         7 ~20%     +48.6%         11 ~19%   sched_debug.cfs_rq[9]:/.nr_running
      7285 ~16%     +46.0%      10639 ~21%   sched_debug.cfs_rq[25]:/.runnable_load_avg
      8495 ~18%     +35.5%      11513 ~19%   sched_debug.cpu#14.load
      8489 ~18%     +35.6%      11513 ~19%   sched_debug.cfs_rq[14]:/.load
      7985 ~24%     +37.9%      11015 ~19%   sched_debug.cpu#12.cpu_load
      7983 ~25%     +38.3%      11043 ~20%   sched_debug.cfs_rq[12]:/.runnable_load_avg
      7123 ~15%     +52.4%      10853 ~22%   sched_debug.cfs_rq[24]:/.load
      1671 ~10%     -36.6%       1059 ~24%   sched_debug.cfs_rq[7]:/.MIN_vruntime
      7128 ~15%     +52.2%      10853 ~22%   sched_debug.cpu#24.load
      1674 ~10%     -36.6%       1062 ~24%   sched_debug.cfs_rq[7]:/.max_vruntime
      7997 ~13%     +48.2%      11852 ~20%   sched_debug.cfs_rq[8]:/.tg_load_contrib
      2039 ~15%     -31.0%       1408 ~19%   sched_debug.cfs_rq[7]:/.min_vruntime
      8556 ~22%     +38.2%      11821 ~18%   sched_debug.cfs_rq[12]:/.tg_load_contrib
       952 ~12%     +59.6%       1520 ~ 6%   cpuidle.C1E-SNB.usage
      7553 ~14%     +49.0%      11253 ~21%   sched_debug.cfs_rq[24]:/.tg_load_contrib
      2013 ~11%     -27.5%       1459 ~17%   sched_debug.cfs_rq[13]:/.min_vruntime
       431 ~21%     +68.8%        727 ~26%   sched_debug.cfs_rq[6]:/.blocked_load_avg
      8512 ~10%     +31.5%      11197 ~14%   sched_debug.cfs_rq[16]:/.tg_load_contrib
      9269 ~18%     +21.2%      11234 ~12%   sched_debug.cfs_rq[6]:/.tg_load_contrib
      7816 ~ 9%     +29.7%      10139 ~15%   sched_debug.cpu#22.cpu_load
      8023 ~ 5%     +38.9%      11146 ~12%   sched_debug.cfs_rq[7]:/.runnable_load_avg
      8054 ~ 6%     +38.5%      11156 ~11%   sched_debug.cpu#7.cpu_load
      2255 ~35%     -44.4%       1253 ~28%   sched_debug.cfs_rq[3]:/.MIN_vruntime
      3.46 ~ 9%     -24.4%       2.61 ~ 9%   sched_debug.cfs_rq[6]:/.spread
      2258 ~34%     -44.4%       1256 ~28%   sched_debug.cfs_rq[3]:/.max_vruntime
      7752 ~ 9%     +30.2%      10091 ~15%   sched_debug.cfs_rq[22]:/.runnable_load_avg
      8579 ~ 6%     +37.4%      11791 ~11%   sched_debug.cfs_rq[7]:/.tg_load_contrib
      9337 ~18%     +17.7%      10992 ~13%   sched_debug.cpu#6.load
      9337 ~18%     +17.7%      10992 ~13%   sched_debug.cfs_rq[6]:/.load
      8499 ~ 6%     +37.1%      11654 ~10%   sched_debug.cpu#7.load
      8499 ~ 6%     +37.1%      11654 ~10%   sched_debug.cfs_rq[7]:/.load
         7 ~ 5%     +38.5%         10 ~10%   sched_debug.cpu#7.nr_running
         7 ~ 5%     +38.5%         10 ~10%   sched_debug.cfs_rq[7]:/.nr_running
        45 ~23%     -38.4%         28 ~33%   sched_debug.cpu#13.nr_uninterruptible
    122137 ~10%     +15.0%     140407 ~11%   numa-vmstat.node1.nr_active_anon
    121019 ~10%     +14.8%     138944 ~11%   numa-vmstat.node1.nr_anon_pages
    545505 ~ 9%     +14.4%     623974 ~11%   numa-meminfo.node1.Active
      4788 ~ 6%     +24.6%       5967 ~12%   sched_debug.cpu#19.nr_switches
   1183156 ~10%      +7.8%    1276020 ~10%   numa-meminfo.node1.MemUsed
      8845 ~ 8%     +27.6%      11285 ~ 7%   sched_debug.cfs_rq[23]:/.tg_load_contrib
      8338 ~ 8%     +43.9%      11997 ~20%   sched_debug.cpu#23.load
      8322 ~ 8%     +44.2%      11997 ~20%   sched_debug.cfs_rq[23]:/.load
         7 ~10%     +51.4%         11 ~22%   sched_debug.cfs_rq[23]:/.nr_running
         7 ~10%     +51.4%         11 ~22%   sched_debug.cpu#23.nr_running
      5982 ~11%     -18.4%       4878 ~ 5%   sched_debug.cpu#20.nr_switches
      5145 ~ 4%     -15.7%       4335 ~ 7%   sched_debug.cpu#13.nr_switches
     10354 ~15%     +24.9%      12936 ~ 9%   sched_debug.cfs_rq[25]:/.tg_load_contrib
      3.20 ~ 4%     -15.2%       2.72 ~ 3%   sched_debug.cfs_rq[23]:/.spread
      6547 ~ 7%     -15.9%       5509 ~ 5%   slabinfo.shmem_inode_cache.num_objs
    250366 ~ 3%     +12.9%     282665 ~ 4%   proc-vmstat.nr_active_anon
    248251 ~ 3%     +12.6%     279447 ~ 4%   proc-vmstat.nr_anon_pages
   1011621 ~ 2%     +11.6%    1128719 ~ 4%   meminfo.Active(anon)
      6506 ~ 7%     -15.4%       5507 ~ 5%   slabinfo.shmem_inode_cache.active_objs
   1003281 ~ 2%     +11.2%    1116144 ~ 3%   meminfo.AnonPages
      4011 ~ 4%     +10.3%       4424 ~ 6%   sched_debug.cpu#7.nr_switches
   1132480 ~ 2%     +10.3%    1249495 ~ 3%   meminfo.Active
      6293 ~ 4%      +8.9%       6852 ~ 5%   slabinfo.kmalloc-128.active_objs
      3.29 ~ 6%      -8.4%       3.01 ~ 7%   sched_debug.cfs_rq[27]:/.spread
      4272 ~ 2%      -8.0%       3928 ~ 3%   sched_debug.cpu#8.curr->pid
      6421 ~ 3%      +7.3%       6891 ~ 4%   slabinfo.kmalloc-128.num_objs
     14672 ~ 1%     +19.0%      17462 ~ 3%   time.voluntary_context_switches
      6073 ~ 2%      +5.2%       6387 ~ 3%   vmstat.system.cs
     22.49 ~ 0%      +0.7%      22.65 ~ 0%   boottime.dhcp

                           time.voluntary_context_switches

   22000 ++-----------------------------------------------------------------+
         O           O                                                      |
   21000 ++                  O  O                 O     O                   |
   20000 ++    O  O                O  O  O                                  |
         |  O             O                    O     O                      |
   19000 ++             O                   O                               |
         |                                                               O  |
   18000 ++                                                O                O
         |                                                   O     O        |
   17000 ++                                                           O     |
   16000 ++                                                     O           |
         |                                                                  |
   15000 ++                  *..            *..                             |
         *..*..*..*..*..*. ..   *..*..*.. ..   *..*..*..*                   |
   14000 ++---------------*--------------*----------------------------------+

Thanks,
Fengguang
