Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab3LVAap (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 19:30:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:20119 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab3LVAao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 19:30:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,529,1384329600"; 
   d="scan'208";a="448173065"
Date: Sun, 22 Dec 2013 08:30:38 +0800
From: fengguang.wu@intel.com
To: Alex Shi <alex.shi@linaro.org>
Cc: Yuanhan Liu <yuanhan.liu@intel.com>, "Huang, Ying" <ying.huang@intel.com>,
        lkp@01.org, LKML <linux-kernel@vger.kernel.org>
Subject: [sched] perf-stat.cpu-migrations changes in dd write test
Message-ID: <20131222003038.GA8932@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex,

We noticed some perf-stat.cpu-migrations changes by your commit

6eb8b571283e64e96ca1a91aad085f9e08f857f0 is the first bad commit
commit 6eb8b571283e64e96ca1a91aad085f9e08f857f0
Author: Alex Shi <alex.shi@linaro.org>
Date:   Tue Nov 19 20:29:51 2013 +0800

    sched: remove rq->cpu_load[load_idx] array
    
    Since load_idx effect removed in load balance, we don't need the
    load_idx decays in scheduler. that will save some process in sched_tick
    and others places.
    
    Signed-off-by: Alex Shi <alex.shi@linaro.org>


Here are the changed stats comparing to its parent commit:

1de157d718f6494       6eb8b571283e64e96ca1  
---------------  -------------------------  
     37779 ~40%    +115.2%      81288 ~50%  kbuildx/micro/dd-write/4HDD-JBOD-cfq-ext4-10dd
     37779         +115.2%      81288       TOTAL proc-vmstat.pgscan_direct_normal

kbuildx/micro/dd-write/4HDD-JBOD-cfq-ext4-10dd: proc-vmstat.pgscan_direct_normal

   160000 ++----------------------------------------------------------------+
          |                                                                 |
   140000 ++                                                                O
          |                                                                 |
   120000 ++                                                                |
          |                O                                                |
   100000 ++                                                                |
          |                                                                 |
    80000 ++                               O                                |
          |                                                               ..*
    60000 ++                                                          ....  |
          |                                                       ....      |
    40000 *+...............                                 O ....          |
          O                *...............         ........*.              |
    20000 ++-------------------------------*--------------------------------+


1de157d718f6494       6eb8b571283e64e96ca1  
---------------  -------------------------  
    121579 ~ 6%     -50.8%      59852 ~13%  kbuildx/micro/dd-write/4HDD-JBOD-cfq-ext4-10dd
    121579          -50.8%      59852       TOTAL softirqs.SCHED

            kbuildx/micro/dd-write/4HDD-JBOD-cfq-ext4-10dd: softirqs.SCHED

   140000 ++----------------------------------------------------------------+
   130000 ++           ....*...........                 ....*.......        |
          |    ........                ....     ........            ......  |
   120000 *+...                            *....                          ..|
   110000 ++                                                                *
          |                                                                 |
   100000 ++                                                                |
    90000 ++                                                                |
    80000 ++                                                                |
          |                                                                 |
    70000 ++                               O                O               |
    60000 ++               O                                                |
          |                                                                 O
    50000 O+                                                                |
    40000 ++----------------------------------------------------------------+


1de157d718f6494       6eb8b571283e64e96ca1  
---------------  -------------------------  
      5636 ~ 4%     -22.1%       4392 ~17%  kbuildx/micro/dd-write/4HDD-JBOD-cfq-ext4-10dd
      5636          -22.1%       4392       TOTAL proc-vmstat.nr_tlb_remote_flush

 kbuildx/micro/dd-write/4HDD-JBOD-cfq-ext4-10dd: proc-vmstat.nr_tlb_remote_flush

   6500 ++------------------------------------------------------------------+
        |                                                                   |
   6000 ++       ........*............                                      |
        *........                     ....                                  |
   5500 ++               O                *................*................|
        |                                                                   *
   5000 ++                                O                                 |
        |                                                                   |
   4500 ++                                                 O                |
        |                                                                   |
   4000 ++                                                                  |
        |                                                                   O
   3500 O+                                                                  |
        |                                                                   |
   3000 ++------------------------------------------------------------------+


1de157d718f6494       6eb8b571283e64e96ca1  
---------------  -------------------------  
      5679 ~ 4%     -21.9%       4437 ~17%  kbuildx/micro/dd-write/4HDD-JBOD-cfq-ext4-10dd
      5679          -21.9%       4437       TOTAL proc-vmstat.nr_tlb_remote_flush_received



   6500 ++------------------------------------------------------------------+
        |                                                                   |
   6000 ++       ........*........                                          |
        *........                 ......                                    |
        |                               ..         ........*................|
   5500 ++               O                *........                         *
        |                                                                   |
   5000 ++                                O                                 |
        |                                                                   |
   4500 ++                                                 O                |
        |                                                                   |
        |                                                                   |
   4000 ++                                                                  |
        |                                                                   O
   3500 O+------------------------------------------------------------------+


1de157d718f6494       6eb8b571283e64e96ca1  
---------------  -------------------------  
       167 ~11%     +19.4%        200 ~ 4%  kbuildx/micro/dd-write/4HDD-JBOD-cfq-ext4-10dd
       167          +19.4%        200       TOTAL uptime.idle

            kbuildx/micro/dd-write/4HDD-JBOD-cfq-ext4-10dd: uptime.idle

   220 ++-------------------------------------------------------------------+
       |                                                                    O
   210 ++                                                                   |
   200 O+                                 O                                 |
       |              ..*.....                             O                |
   190 ++         ....  O     ...                                           |
   180 ++     ....               ....                                       |
       |  ....                       ....                                   |
   170 *+.                               .                                 .*
   160 ++                                 *......                      .... |
       |                                         ....               ...     |
   150 ++                                            ....        ...        |
   140 ++                                                ..  ....           |
       |                                                   *.               |
   130 ++-------------------------------------------------------------------+


1de157d718f6494       6eb8b571283e64e96ca1  
---------------  -------------------------  
    154781 ~ 5%     -66.8%      51449 ~ 8%  kbuildx/micro/dd-write/4HDD-JBOD-cfq-ext4-10dd
    154781          -66.8%      51449       TOTAL perf-stat.cpu-migrations

       kbuildx/micro/dd-write/4HDD-JBOD-cfq-ext4-10dd: perf-stat.cpu-migrations

   180000 ++----------------------------------------------------------------+
          |            ....*...........                                     |
   160000 ++   ........                ....         ........*...............|
          *....                            *........                        *
   140000 ++                                                                |
          |                                                                 |
   120000 ++                                                                |
          |                                                                 |
   100000 ++                                                                |
          |                                                                 |
    80000 ++                                                                |
          |                                                                 |
    60000 ++                                                O               |
          |                O               O                                O
    40000 O+----------------------------------------------------------------+


1de157d718f6494       6eb8b571283e64e96ca1  
---------------  -------------------------  
      1943 ~ 3%      -7.8%       1792 ~ 4%  kbuildx/micro/dd-write/4HDD-JBOD-cfq-ext4-10dd
      1943           -7.8%       1792       TOTAL vmstat.system.cs

          kbuildx/micro/dd-write/4HDD-JBOD-cfq-ext4-10dd: vmstat.system.cs

   2050 ++------------------------------------------------------------------+
        |                         ........*................*.....           |
   2000 ++              .*........                               ...        |
   1950 ++          ....                                            ...     |
        |        ...                                                   .... |
   1900 ++    ...                                                          .|
   1850 ++....                            O                O                *
        *.                                                                  |
   1800 ++               O                                                  O
   1750 ++                                                                  |
        |                                                                   |
   1700 ++                                                                  |
   1650 O+                                                                  |
        |                                                                   |
   1600 ++------------------------------------------------------------------+


1de157d718f6494       6eb8b571283e64e96ca1  
---------------  -------------------------  
   1216177 ~ 3%      -9.4%    1101605 ~ 7%  kbuildx/micro/dd-write/4HDD-JBOD-cfq-ext4-10dd
   1216177           -9.4%    1101605       TOTAL perf-stat.context-switches

      kbuildx/micro/dd-write/4HDD-JBOD-cfq-ext4-10dd: perf-stat.context-switches

    1.3e+06 ++--------------------------------------------------------------+
            |             ..*...............                                |
   1.25e+06 ++      ......                  *...............*.......        |
            |  .....                                                ......  |
    1.2e+06 *+.                             O                             ..|
   1.15e+06 ++                                              O               *
            |               O                                               |
    1.1e+06 ++                                                              |
            |                                                               O
   1.05e+06 ++                                                              |
      1e+06 ++                                                              |
            |                                                               |
     950000 O+                                                              |
            |                                                               |
     900000 ++--------------------------------------------------------------+


