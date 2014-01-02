Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249AbaABGNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 01:13:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:33068 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbaABGNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 01:13:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,589,1384329600"; 
   d="scan'208";a="452586309"
Date: Thu, 2 Jan 2014 14:12:42 +0800
From: fengguang.wu@intel.com
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: perf-stat changes after "Use hrtimers for event multiplexing"
Message-ID: <20140102061242.GB29352@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

We noticed many perf-stat changes between commit 9e6302056f ("perf: Use
hrtimers for event multiplexing") and its parent commit ab573844e.
Are these expected changes?

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
    152917         +842.9%    1441897       TOTAL interrupts.0:IO-APIC-edge.timer
    545996         +478.0%    3155637       TOTAL interrupts.LOC
    182281          +12.3%     204718       TOTAL softirqs.SCHED
 1.986e+08          -96.4%    7105919       TOTAL perf-stat.node-store-misses
 107241719          -99.7%     317525       TOTAL perf-stat.node-prefetch-misses
 1.938e+08          -90.7%   17930426       TOTAL perf-stat.node-load-misses
      2590         +247.8%       9009       TOTAL vmstat.system.in
 4.549e+12         +158.3%  1.175e+13       TOTAL perf-stat.stalled-cycles-backend
 6.807e+12         +149.1%  1.696e+13       TOTAL perf-stat.stalled-cycles-frontend
 1.753e+08          -50.8%   86339289       TOTAL perf-stat.node-prefetches
 8.326e+11          +45.0%  1.207e+12       TOTAL perf-stat.cpu-cycles
  37932143          +32.2%   50146025       TOTAL perf-stat.iTLB-load-misses
 4.738e+11          +30.1%  6.165e+11       TOTAL perf-stat.iTLB-loads
  2.56e+11          +30.1%   3.33e+11       TOTAL perf-stat.L1-icache-loads
 4.951e+11          +24.6%  6.169e+11       TOTAL perf-stat.instructions
  7.85e+08           +7.5%  8.439e+08       TOTAL perf-stat.LLC-prefetch-misses
 1.891e+12          +22.8%  2.322e+12       TOTAL perf-stat.ref-cycles
 4.344e+08          -20.3%  3.462e+08       TOTAL perf-stat.node-loads
 2.836e+11          +17.4%  3.328e+11       TOTAL perf-stat.branch-loads
 9.506e+10          +24.5%  1.183e+11       TOTAL perf-stat.branch-load-misses
 2.803e+11          +18.4%  3.319e+11       TOTAL perf-stat.branch-instructions
 7.988e+10          +20.9%  9.658e+10       TOTAL perf-stat.bus-cycles
 2.041e+09          +22.2%  2.495e+09       TOTAL perf-stat.branch-misses
    229145          -17.3%     189601       TOTAL perf-stat.cpu-migrations
 1.782e+11          +17.9%    2.1e+11       TOTAL perf-stat.dTLB-loads
 4.702e+08          -14.8%  4.006e+08       TOTAL perf-stat.LLC-load-misses
 1.418e+11          +17.4%  1.666e+11       TOTAL perf-stat.L1-dcache-loads
 1.838e+09          +16.1%  2.133e+09       TOTAL perf-stat.LLC-stores
 2.428e+09          +11.3%  2.702e+09       TOTAL perf-stat.LLC-loads
 2.788e+11           +8.6%  3.029e+11       TOTAL perf-stat.dTLB-stores
  8.66e+08          +10.8%  9.594e+08       TOTAL perf-stat.LLC-prefetches
 1.117e+09          +10.5%  1.234e+09       TOTAL perf-stat.dTLB-store-misses
 1.705e+09           +5.3%  1.796e+09       TOTAL perf-stat.L1-dcache-store-misses
 5.671e+09           +6.1%  6.015e+09       TOTAL perf-stat.L1-dcache-load-misses
 8.794e+10           +3.6%  9.109e+10       TOTAL perf-stat.L1-dcache-stores
  3.46e+09           +4.6%  3.618e+09       TOTAL perf-stat.cache-references
 8.696e+08           +1.8%  8.849e+08       TOTAL perf-stat.cache-misses
   1613129           +2.6%    1655724       TOTAL perf-stat.context-switches

All of the changes happen in one of our test box, which has a DX58SO
baseboard and 4-core CPU. The boot dmesg and kconfig are attached.
We can test more boxes if necessary.

Below is the more detailed list of changes.

ab573844e3058ee  9e6302056f8029f438e853432 <= commits being compared
---------------  -------------------------
     81917 ~ 1%    +773.9%     715856 ~ 6%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd <= test box, case and params
     71000 ~ 1%    +922.6%     726041 ~18%  fat/micro/dd-write/1HDD-cfq-ext4-100dd  <= test box, case and params
           ^^^^stddev                 ^^^^stddev
    152917         +842.9%    1441897       TOTAL interrupts.0:IO-APIC-edge.timer   <= metric for this chunk of compares
    ~~~~~~         ~~~~~~~    ~~~~~~~ value1, percent of change, value2

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
    280034 ~ 1%    +466.0%    1584966 ~ 2%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
    265962 ~ 1%    +490.6%    1570671 ~ 6%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
    545996         +478.0%    3155637       TOTAL interrupts.LOC

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
     90939 ~ 2%     +13.6%     103315 ~ 3%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
     91342 ~ 0%     +11.0%     101402 ~ 0%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
    182281          +12.3%     204718       TOTAL softirqs.SCHED

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
  93997892 ~31%     -93.8%    5850557 ~37%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
 1.046e+08 ~ 7%     -98.8%    1255361 ~138%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 1.986e+08          -96.4%    7105919       TOTAL perf-stat.node-store-misses

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
  58318221 ~10%    -100.0%      18569 ~130%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
  48923497 ~15%     -99.4%     298955 ~193%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 107241719          -99.7%     317525       TOTAL perf-stat.node-prefetch-misses

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
  83665740 ~ 6%     -82.0%   15059253 ~144%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
 1.102e+08 ~ 7%     -97.4%    2871173 ~41%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 1.938e+08          -90.7%   17930426       TOTAL perf-stat.node-load-misses

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
      1529 ~ 2%    +208.9%       4724 ~ 2%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
      1061 ~ 3%    +303.9%       4285 ~ 8%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
      2590         +247.8%       9009       TOTAL vmstat.system.in

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 2.891e+12 ~ 1%    +146.6%   7.13e+12 ~ 2%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
 1.658e+12 ~ 3%    +178.6%   4.62e+12 ~ 7%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 4.549e+12         +158.3%  1.175e+13       TOTAL perf-stat.stalled-cycles-backend

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 4.371e+12 ~ 1%    +140.0%  1.049e+13 ~ 2%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
 2.436e+12 ~ 3%    +165.5%  6.467e+12 ~ 7%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 6.807e+12         +149.1%  1.696e+13       TOTAL perf-stat.stalled-cycles-frontend

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 1.753e+08 ~ 2%     -50.8%   86339289 ~ 2%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 1.753e+08          -50.8%   86339289       TOTAL perf-stat.node-prefetches

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 8.326e+11 ~ 6%     +45.0%  1.207e+12 ~ 7%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 8.326e+11          +45.0%  1.207e+12       TOTAL perf-stat.cpu-cycles

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
  19697591 ~ 2%     +32.9%   26168712 ~ 0%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
  18234552 ~ 3%     +31.5%   23977313 ~ 4%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
  37932143          +32.2%   50146025       TOTAL perf-stat.iTLB-load-misses

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 4.738e+11 ~ 5%     +30.1%  6.165e+11 ~ 7%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 4.738e+11          +30.1%  6.165e+11       TOTAL perf-stat.iTLB-loads

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
  2.56e+11 ~ 5%     +30.1%   3.33e+11 ~ 7%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
  2.56e+11          +30.1%   3.33e+11       TOTAL perf-stat.L1-icache-loads

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 4.951e+11 ~10%     +24.6%  6.169e+11 ~ 6%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 4.951e+11          +24.6%  6.169e+11       TOTAL perf-stat.instructions

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 6.504e+08 ~ 7%     +16.1%  7.548e+08 ~ 4%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
 1.345e+08 ~10%     -33.8%   89058216 ~ 4%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
  7.85e+08           +7.5%  8.439e+08       TOTAL perf-stat.LLC-prefetch-misses

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 1.055e+12 ~ 1%      +5.8%  1.116e+12 ~ 1%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
 8.363e+11 ~ 5%     +44.2%  1.206e+12 ~ 6%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 1.891e+12          +22.8%  2.322e+12       TOTAL perf-stat.ref-cycles

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 2.241e+08 ~ 3%     -18.6%  1.826e+08 ~ 2%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
 2.103e+08 ~ 1%     -22.2%  1.636e+08 ~ 3%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 4.344e+08          -20.3%  3.462e+08       TOTAL perf-stat.node-loads

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 1.856e+11 ~ 0%      +4.4%  1.938e+11 ~ 1%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
 9.797e+10 ~12%     +41.9%   1.39e+11 ~ 9%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 2.836e+11          +17.4%  3.328e+11       TOTAL perf-stat.branch-loads

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 9.506e+10 ~ 6%     +24.5%  1.183e+11 ~ 5%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 9.506e+10          +24.5%  1.183e+11       TOTAL perf-stat.branch-load-misses

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 1.824e+11 ~ 0%      +4.9%  1.914e+11 ~ 0%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
 9.791e+10 ~ 6%     +43.5%  1.405e+11 ~ 9%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 2.803e+11          +18.4%  3.319e+11       TOTAL perf-stat.branch-instructions

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 4.411e+10 ~ 1%      +5.1%  4.636e+10 ~ 0%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
 3.576e+10 ~ 5%     +40.4%  5.022e+10 ~ 6%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 7.988e+10          +20.9%  9.658e+10       TOTAL perf-stat.bus-cycles

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 2.041e+09 ~ 0%     +22.2%  2.495e+09 ~ 1%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 2.041e+09          +22.2%  2.495e+09       TOTAL perf-stat.branch-misses

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
    113694 ~ 1%     -15.1%      96524 ~ 2%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
    115451 ~ 2%     -19.4%      93077 ~ 2%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
    229145          -17.3%     189601       TOTAL perf-stat.cpu-migrations

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 1.782e+11 ~ 4%     +17.9%    2.1e+11 ~ 3%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 1.782e+11          +17.9%    2.1e+11       TOTAL perf-stat.dTLB-loads

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 2.345e+08 ~ 3%      -9.5%  2.123e+08 ~ 3%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
 2.357e+08 ~ 4%     -20.1%  1.883e+08 ~ 1%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 4.702e+08          -14.8%  4.006e+08       TOTAL perf-stat.LLC-load-misses

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 1.418e+11 ~ 2%     +17.4%  1.666e+11 ~ 3%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 1.418e+11          +17.4%  1.666e+11       TOTAL perf-stat.L1-dcache-loads

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 1.838e+09 ~ 3%     +16.1%  2.133e+09 ~ 1%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 1.838e+09          +16.1%  2.133e+09       TOTAL perf-stat.LLC-stores

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 1.275e+09 ~ 2%      +8.3%   1.38e+09 ~ 1%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
 1.153e+09 ~ 2%     +14.6%  1.322e+09 ~ 2%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 2.428e+09          +11.3%  2.702e+09       TOTAL perf-stat.LLC-loads

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 1.698e+11 ~ 1%      +4.4%  1.773e+11 ~ 0%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
  1.09e+11 ~ 2%     +15.2%  1.256e+11 ~ 2%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 2.788e+11           +8.6%  3.029e+11       TOTAL perf-stat.dTLB-stores

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
  8.66e+08 ~ 3%     +10.8%  9.594e+08 ~ 0%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
  8.66e+08          +10.8%  9.594e+08       TOTAL perf-stat.LLC-prefetches

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 1.117e+09 ~ 2%     +10.5%  1.234e+09 ~ 4%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 1.117e+09          +10.5%  1.234e+09       TOTAL perf-stat.dTLB-store-misses

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 1.705e+09 ~ 1%      +5.3%  1.796e+09 ~ 2%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 1.705e+09           +5.3%  1.796e+09       TOTAL perf-stat.L1-dcache-store-misses

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 5.671e+09 ~ 2%      +6.1%  6.015e+09 ~ 2%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 5.671e+09           +6.1%  6.015e+09       TOTAL perf-stat.L1-dcache-load-misses

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 8.794e+10 ~ 0%      +3.6%  9.109e+10 ~ 2%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
 8.794e+10           +3.6%  9.109e+10       TOTAL perf-stat.L1-dcache-stores

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
  3.46e+09 ~ 1%      +4.6%  3.618e+09 ~ 1%  fat/micro/dd-write/1HDD-cfq-ext4-100dd
  3.46e+09           +4.6%  3.618e+09       TOTAL perf-stat.cache-references

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
 8.696e+08 ~ 0%      +1.8%  8.849e+08 ~ 0%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
 8.696e+08           +1.8%  8.849e+08       TOTAL perf-stat.cache-misses

ab573844e3058ee  9e6302056f8029f438e853432
---------------  -------------------------
   1613129 ~ 2%      +2.6%    1655724 ~ 1%  fat/micro/dd-write/1HDD-cfq-btrfs-100dd
   1613129           +2.6%    1655724       TOTAL perf-stat.context-switches


                           perf-stat.stalled-cycles-frontend

   1.2e+13 ++---------------------------------------------------------------+
           |                O      O                                        |
   1.1e+13 ++ O      O   O                             O      O      O   O  |
     1e+13 O+     O             O     O   O  O   O  O      O      O         O
           |                                                                |
     9e+12 ++                                                               |
     8e+12 ++                                                               |
           |                                                                |
     7e+12 ++                                                               |
     6e+12 ++                                                               |
           |                                                                |
     5e+12 ++                                                               |
     4e+12 *+.  ..*..*...*..*...*..*..*...*..*...*..*..*...*..*...*..*...*..*
           |  *.                                                            |
     3e+12 ++---------------------------------------------------------------+


                           perf-stat.stalled-cycles-backend

   7.5e+12 ++---------------O------O--------------------------O------O------+
     7e+12 ++ O      O   O      O     O             O  O                 O  |
           O      O                       O  O   O         O      O         O
   6.5e+12 ++                                                               |
     6e+12 ++                                                               |
           |                                                                |
   5.5e+12 ++                                                               |
     5e+12 ++                                                               |
   4.5e+12 ++                                                               |
           |                                                                |
     4e+12 ++                                                               |
   3.5e+12 ++                                                               |
           |               .*...  .*..         ..*..                        |
     3e+12 *+.  ..*..*...*.     *.    *...*..*.     *..*...*..*...*..*...*..*
   2.5e+12 ++-*-------------------------------------------------------------+


                                  vmstat.system.in

   5500 ++------------------------------------------------------------------+
        |                 O      O                                          |
   5000 O+     O   O         O       O  O      O              O      O  O   |
   4500 ++  O         O                     O      O   O  O      O          O
        |                                                                   |
   4000 ++                                                                  |
   3500 ++                                                                  |
        |                                                                   |
   3000 ++                                                                  |
   2500 ++                                                                  |
        |                                                                   |
   2000 ++                                                                  |
   1500 *+..*..*...  .*...*..*...  ..*..*...*..*...*...*..*...*..*...  .*...*
        |          *.            *.                                  *.     |
   1000 ++------------------------------------------------------------------+


                           perf-stat.node-prefetch-misses

   9e+07 ++-----------------------------------------------------------------+
         |                 *                                                |
   8e+07 ++               : +                             *..               |
   7e+07 *+     *.       :   +                           :   .              |
         | ..  +  ..     :    *..      ..*..   .*..      :    *         *...*
   6e+07 ++   +         :        .  .*.      ..         :      +      ..    |
   5e+07 ++  *      *..*          *.        *      *...*        +  ..*      |
         |                                                       *.         |
   4e+07 ++                                                                 |
   3e+07 ++                                                                 |
         |                                                                  |
   2e+07 ++                                                                 |
   1e+07 ++                                                                 |
         |                                                                  |
       0 O+--O--O---O--O---O--O---O--O---O--O---O--O---O--O---O--O---O------+


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc6-02692-gd62d788 (kbuild@inn) (gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP Thu Jan 2 13:22:50 CST 2014
[    0.000000] Command line: user=lkp job=/lkp/scheduled/fat/cyclic_dd-write-1hdd-1HDD-cfq-ext4-1dd-HEAD.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/d62d788bb0b95abda6bc28f666fa8c582c750d66/vmlinuz-3.13.0-rc6-02692-gd62d788 kconfig=x86_64-lkp commit=d62d788bb0b95abda6bc28f666fa8c582c750d66 modules_initrd=/kernel/x86_64-lkp/d62d788bb0b95abda6bc28f666fa8c582c750d66/modules.cgz max_uptime=1200 RESULT_ROOT=/lkp/result/fat/micro/dd-write/1HDD-cfq-ext4-1dd/x86_64-lkp/d62d788bb0b95abda6bc28f666fa8c582c750d66/0 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::fat::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009cbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009cc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000ccde2fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ccde3000-0x00000000ccffafff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000ccffb000-0x00000000cf6bcfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf6bd000-0x00000000cf6befff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cf6bf000-0x00000000cf713fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf714000-0x00000000cf7befff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cf7bf000-0x00000000cf7e6fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf7e7000-0x00000000cf7fefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cf7ff000-0x00000000cf7fffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cf800000-0x00000000cfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fcffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffe00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000012fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.5 present.
[    0.000000] DMI:                  /DX58SO, BIOS SOX5810J.86A.2127.2008.0914.1638 09/14/2008
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x130000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-DFFFF write-protect
[    0.000000]   E0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FF0000000 write-back
[    0.000000]   3 base 100000000 mask FE0000000 write-back
[    0.000000]   4 base 120000000 mask FF0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcf800 max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] Scan for SMP in [mem 0x0009cc00-0x0009cfff]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0265a000, 0x0265afff] PGTABLE
[    0.000000] BRK [0x0265b000, 0x0265bfff] PGTABLE
[    0.000000] BRK [0x0265c000, 0x0265cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12fe00000-0x12fffffff]
[    0.000000]  [mem 0x12fe00000-0x12fffffff] page 2M
[    0.000000] BRK [0x0265d000, 0x0265dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12c000000-0x12fdfffff]
[    0.000000]  [mem 0x12c000000-0x12fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x12bffffff]
[    0.000000]  [mem 0x100000000-0x12bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xccde2fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xccbfffff] page 2M
[    0.000000]  [mem 0xccc00000-0xccde2fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xccffb000-0xcf6bcfff]
[    0.000000]  [mem 0xccffb000-0xccffffff] page 4k
[    0.000000]  [mem 0xcd000000-0xcf5fffff] page 2M
[    0.000000]  [mem 0xcf600000-0xcf6bcfff] page 4k
[    0.000000] BRK [0x0265e000, 0x0265efff] PGTABLE
[    0.000000] BRK [0x0265f000, 0x0265ffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xcf6bf000-0xcf713fff]
[    0.000000]  [mem 0xcf6bf000-0xcf713fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xcf7bf000-0xcf7e6fff]
[    0.000000]  [mem 0xcf7bf000-0xcf7e6fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xcf7ff000-0xcf7fffff]
[    0.000000]  [mem 0xcf7ff000-0xcf7fffff] page 4k
[    0.000000] RAMDISK: [mem 0x6e146000-0x7fff2fff]
[    0.000000] ACPI: RSDP 00000000000fe020 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 00000000cf7fe120 00006C (v01 INTEL  DX58SO   0000084F      01000013)
[    0.000000] ACPI: FACP 00000000cf7fd000 0000F4 (v03 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI BIOS Warning (bug): Optional FADT field Pm2ControlBlock has zero address or length: 0x0000000000000450/0x0 (20131115/tbfadt-603)
[    0.000000] ACPI BIOS Warning (bug): Invalid length for FADT/Pm2ControlBlock: 0, using default 8 (20131115/tbfadt-653)
[    0.000000] ACPI: DSDT 00000000cf7f8000 0043CE (v02 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: FACS 00000000cf726000 000040
[    0.000000] ACPI: APIC 00000000cf7f7000 000138 (v02 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: WDDT 00000000cf7f6000 000040 (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: MCFG 00000000cf7f5000 00003C (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: ASF! 00000000cf7f4000 0000AC (v32 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: SSDT 00000000cf7ea000 0070AC (v01 INTEL  SSDT  PM 0000084F MSFT 0100000D)
[    0.000000] ACPI: DMAR 00000000cf7e7000 000140 (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: WDTT 00000000cf7f2000 00020C (v01 INTEL  DX58SO   0000084F MSFT 0100000D)
[    0.000000] ACPI: ASPT 00000000cf7f3000 000034 (v04 INTEL  PerfTune 0000084F MSFT 0100000D)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000012fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x12fffffff]
[    0.000000]   NODE_DATA [mem 0x12fff7000-0x12fffbfff]
[    0.000000]  [ffffea0000000000-ffffea0004bfffff] PMD -> [ffff88012b600000-ffff88012f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x12fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009bfff]
[    0.000000]   node   0: [mem 0x00100000-0xccde2fff]
[    0.000000]   node   0: [mem 0xccffb000-0xcf6bcfff]
[    0.000000]   node   0: [mem 0xcf6bf000-0xcf713fff]
[    0.000000]   node   0: [mem 0xcf7bf000-0xcf7e6fff]
[    0.000000]   node   0: [mem 0xcf7ff000-0xcf7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x12fffffff]
[    0.000000] On node 0 totalpages: 1045694
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13205 pages used for memmap
[    0.000000]   DMA32 zone: 845091 pages, LIFO batch:31
[    0.000000]   Normal zone: 3072 pages used for memmap
[    0.000000]   Normal zone: 196608 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x10] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x12] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x14] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x16] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x11] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x15] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x17] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x09] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0a] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0b] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0c] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0d] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0e] high level lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x0f] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 8, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 8, APIC INT 09
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 8, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 8, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 8, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 8, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 8, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 8, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 8, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 8, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 8, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 8, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 8, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 8, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 8, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] smpboot: Allowing 16 CPUs, 8 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009c000-0x0009cfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xccde3000-0xccffafff]
[    0.000000] PM: Registered nosave memory: [mem 0xcf6bd000-0xcf6befff]
[    0.000000] PM: Registered nosave memory: [mem 0xcf714000-0xcf7befff]
[    0.000000] PM: Registered nosave memory: [mem 0xcf7e7000-0xcf7fefff]
[    0.000000] PM: Registered nosave memory: [mem 0xcf800000-0xcfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xd0000000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfcffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfd000000-0xffdfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffe00000-0xffffffff]
[    0.000000] e820: [mem 0xd0000000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:16 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88012fc00000 s81024 r8192 d21376 u131072
[    0.000000] pcpu-alloc: s81024 r8192 d21376 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1029332
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=lkp job=/lkp/scheduled/fat/cyclic_dd-write-1hdd-1HDD-cfq-ext4-1dd-HEAD.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/d62d788bb0b95abda6bc28f666fa8c582c750d66/vmlinuz-3.13.0-rc6-02692-gd62d788 kconfig=x86_64-lkp commit=d62d788bb0b95abda6bc28f666fa8c582c750d66 modules_initrd=/kernel/x86_64-lkp/d62d788bb0b95abda6bc28f666fa8c582c750d66/modules.cgz max_uptime=1200 RESULT_ROOT=/lkp/result/fat/micro/dd-write/1HDD-cfq-ext4-1dd/x86_64-lkp/d62d788bb0b95abda6bc28f666fa8c582c750d66/0 initrd=/kernel-tests/initrd/lkp-rootfs.cgz root=/dev/ram0 ip=::::fat::dhcp oops=panic earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled panic=10 load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 3732620K/4182776K available (10304K kernel code, 1235K rwdata, 4144K rodata, 1428K init, 1736K bss, 450156K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=16.
[    0.000000] NR_IRQS:33024 nr_irqs:808 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 16777216 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3200.215 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 6400.43 BogoMIPS (lpj=12800860)
[    0.000464] pid_max: default: 32768 minimum: 301
[    0.000928] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.002086] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.002750] Mount-cache hash table entries: 256
[    0.003123] Initializing cgroup subsys memory
[    0.003323] Initializing cgroup subsys devices
[    0.003520] Initializing cgroup subsys freezer
[    0.003717] Initializing cgroup subsys blkio
[    0.003908] Initializing cgroup subsys perf_event
[    0.004116] Initializing cgroup subsys hugetlb
[    0.004444] CPU: Physical Processor ID: 0
[    0.004741] CPU: Processor Core ID: 1
[    0.005027] mce: CPU supports 9 MCE banks
[    0.005330] CPU0: Thermal LVT vector (0xfa) already installed
[    0.005696] Last level iTLB entries: 4KB 512, 2MB 7, 4MB 7
[    0.005696] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.005696] tlb_flushall_shift: 6
[    0.006686] Freeing SMP alternatives memory: 44K (ffffffff8249b000 - ffffffff824a6000)
[    0.008278] ACPI: Core revision 20131115
[    0.011826] ACPI: All ACPI Tables successfully acquired
[    0.012243] ftrace: allocating 39679 entries in 155 pages
[    0.026517] Getting VERSION: 60015
[    0.026792] Getting VERSION: 60015
[    0.027066] Getting ID: 2000000
[    0.027330] Getting ID: 2000000
[    0.027594] Switched APIC routing to physical flat.
[    0.027922] masked ExtINT on CPU#0
[    0.028403] ENABLING IO-APIC IRQs
[    0.028673] init IO_APIC IRQs
[    0.028930]  apic 8 pin 0 not connected
[    0.029221] IOAPIC[0]: Set routing entry (8-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:2)
[    0.029779] IOAPIC[0]: Set routing entry (8-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:2)
[    0.030336] IOAPIC[0]: Set routing entry (8-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:2)
[    0.030893] IOAPIC[0]: Set routing entry (8-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:2)
[    0.031450] IOAPIC[0]: Set routing entry (8-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:2)
[    0.032007] IOAPIC[0]: Set routing entry (8-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:2)
[    0.032564] IOAPIC[0]: Set routing entry (8-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:2)
[    0.033121] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:2)
[    0.033685] IOAPIC[0]: Set routing entry (8-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:2)
[    0.034242] IOAPIC[0]: Set routing entry (8-10 -> 0x3a -> IRQ 10 Mode:0 Active:0 Dest:2)
[    0.034805] IOAPIC[0]: Set routing entry (8-11 -> 0x3b -> IRQ 11 Mode:0 Active:0 Dest:2)
[    0.035368] IOAPIC[0]: Set routing entry (8-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:2)
[    0.035932] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:2)
[    0.036496] IOAPIC[0]: Set routing entry (8-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:2)
[    0.037059] IOAPIC[0]: Set routing entry (8-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:2)
[    0.037624]  apic 8 pin 16 not connected
[    0.037918]  apic 8 pin 17 not connected
[    0.038211]  apic 8 pin 18 not connected
[    0.038504]  apic 8 pin 19 not connected
[    0.038797]  apic 8 pin 20 not connected
[    0.039091]  apic 8 pin 21 not connected
[    0.039385]  apic 8 pin 22 not connected
[    0.039677]  apic 8 pin 23 not connected
[    0.040104] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.080160] smpboot: CPU0: Genuine Intel(R) CPU             000  @ 3.20GHz (fam: 06, model: 1a, stepping: 04)
[    0.080889] Using local APIC timer interrupts.
[    0.080889] calibrating APIC timer ...
[    0.185504] ... lapic delta = 833407
[    0.185784] ... PM-Timer delta = 357974
[    0.186073] ... PM-Timer result ok
[    0.186347] ..... delta 833407
[    0.186608] ..... mult: 35794558
[    0.186876] ..... calibration result: 533380
[    0.187181] ..... CPU clock speed is 3200.1146 MHz.
[    0.187508] ..... host bus clock speed is 133.1380 MHz.
[    0.187863] Performance Events: PEBS fmt1+, 16-deep LBR, Nehalem events, Intel PMU driver.
[    0.188566] perf_event_intel: CPU erratum AAJ80 worked around
[    0.188927] ... version:                3
[    0.189223] ... bit width:              48
[    0.189521] ... generic registers:      4
[    0.189817] ... value mask:             0000ffffffffffff
[    0.190160] ... max period:             000000007fffffff
[    0.190503] ... fixed-purpose events:   3
[    0.190799] ... event mask:             000000070000000f
[    0.192449] x86: Booting SMP configuration:
[    0.204016] masked ExtINT on CPU#1
[    0.204168] CPU1: Thermal LVT vector (0xfa) already installed
[    0.217464] masked ExtINT on CPU#2
[    0.217616] CPU2: Thermal LVT vector (0xfa) already installed
[    0.230916] masked ExtINT on CPU#3
[    0.231068] CPU3: Thermal LVT vector (0xfa) already installed
[    0.244367] masked ExtINT on CPU#4
[    0.244518] CPU4: Thermal LVT vector (0xfa) already installed
[    0.257810] masked ExtINT on CPU#5
[    0.257965] CPU5: Thermal LVT vector (0xfa) already installed
[    0.271367] masked ExtINT on CPU#6
[    0.271518] CPU6: Thermal LVT vector (0xfa) already installed
[    0.284914] masked ExtINT on CPU#7
[    0.285065] CPU7: Thermal LVT vector (0xfa) already installed
[    0.192752] .... node  #0, CPUs:        #1  #2  #3  #4  #5  #6  #7
[    0.287340] x86: Booted up 1 node, 8 CPUs
[    0.287792] smpboot: Total of 8 processors activated (51203.44 BogoMIPS)
[    0.293104] devtmpfs: initialized
[    0.295932] PM: Registering ACPI NVS region [mem 0xccde3000-0xccffafff] (2195456 bytes)
[    0.296538] PM: Registering ACPI NVS region [mem 0xcf714000-0xcf7befff] (700416 bytes)
[    0.298149] xor: measuring software checksum speed
[    0.335866]    prefetch64-sse: 12920.000 MB/sec
[    0.375868]    generic_sse: 11402.000 MB/sec
[    0.376174] xor: using function: prefetch64-sse (12920.000 MB/sec)
[    0.376554] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.377006] NET: Registered protocol family 16
[    0.377839] cpuidle: using governor ladder
[    0.378138] cpuidle: using governor menu
[    0.378770] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.379313] ACPI: bus type PCI registered
[    0.379609] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.380070] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.380680] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.384769] PCI: Using configuration type 1 for base access
[    0.392742] bio: create slab <bio-0> at 0
[    0.459880] raid6: sse2x1    7764 MB/s
[    0.527882] raid6: sse2x2    9270 MB/s
[    0.595879] raid6: sse2x4   10457 MB/s
[    0.596167] raid6: using algorithm sse2x4 (10457 MB/s)
[    0.596505] raid6: using ssse3x2 recovery algorithm
[    0.596874] ACPI: Added _OSI(Module Device)
[    0.597177] ACPI: Added _OSI(Processor Device)
[    0.597490] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.597811] ACPI: Added _OSI(Processor Aggregator Device)
[    0.604978] ACPI: Interpreter enabled
[    0.605268] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20131115/hwxface-580)
[    0.605946] ACPI: (supports S0 S1 S3 S4 S5)
[    0.606250] ACPI: Using IOAPIC for interrupt routing
[    0.606616] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.607291] ACPI: No dock devices found.
[    0.612573] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3d])
[    0.612952] acpi PNP0A03:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.613519] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.614412] ACPI: \_SB_.PCI0.APIC: can't evaluate _ADR (0x5)
[    0.614816] ACPI: \_SB_.PCI0.HPET: can't evaluate _ADR (0x5)
[    0.615173] PCI host bridge to bus 0000:00
[    0.615473] pci_bus 0000:00: root bus resource [bus 00-3d]
[    0.615823] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.616203] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.616581] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.616982] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000cbfff]
[    0.617384] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfedfffff]
[    0.617785] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xf7ffffff]
[    0.618193] pci 0000:00:00.0: [8086:3405] type 00 class 0x060000
[    0.618677] pci 0000:00:01.0: [8086:3408] type 01 class 0x060400
[    0.619087] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.619506] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.619910] pci 0000:00:03.0: [8086:340a] type 01 class 0x060400
[    0.620323] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.620742] pci 0000:00:03.0: System wakeup disabled by ACPI
[    0.621144] pci 0000:00:07.0: [8086:340e] type 01 class 0x060400
[    0.621553] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.621970] pci 0000:00:07.0: System wakeup disabled by ACPI
[    0.622371] pci 0000:00:10.0: [8086:3425] type 00 class 0x080000
[    0.622845] pci 0000:00:10.1: [8086:3426] type 00 class 0x080000
[    0.623315] pci 0000:00:14.0: [8086:342e] type 00 class 0x080000
[    0.623789] pci 0000:00:14.1: [8086:3422] type 00 class 0x080000
[    0.624277] pci 0000:00:14.2: [8086:3423] type 00 class 0x080000
[    0.624752] pci 0000:00:14.3: [8086:3438] type 00 class 0x080000
[    0.625224] pci 0000:00:19.0: [8086:10cc] type 00 class 0x020000
[    0.625609] pci 0000:00:19.0: reg 0x10: [mem 0xe0300000-0xe031ffff]
[    0.625995] pci 0000:00:19.0: reg 0x14: [mem 0xe0323000-0xe0323fff]
[    0.626380] pci 0000:00:19.0: reg 0x18: [io  0x2100-0x211f]
[    0.626783] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.627200] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.627599] pci 0000:00:1a.0: [8086:3a37] type 00 class 0x0c0300
[    0.628009] pci 0000:00:1a.0: reg 0x20: [io  0x20e0-0x20ff]
[    0.628453] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.628854] pci 0000:00:1a.1: [8086:3a38] type 00 class 0x0c0300
[    0.629262] pci 0000:00:1a.1: reg 0x20: [io  0x20c0-0x20df]
[    0.629703] pci 0000:00:1a.1: System wakeup disabled by ACPI
[    0.630105] pci 0000:00:1a.2: [8086:3a39] type 00 class 0x0c0300
[    0.630512] pci 0000:00:1a.2: reg 0x20: [io  0x20a0-0x20bf]
[    0.630954] pci 0000:00:1a.2: System wakeup disabled by ACPI
[    0.631361] pci 0000:00:1a.7: [8086:3a3c] type 00 class 0x0c0320
[    0.631747] pci 0000:00:1a.7: reg 0x10: [mem 0xe0322000-0xe03223ff]
[    0.632205] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.632642] pci 0000:00:1a.7: System wakeup disabled by ACPI
[    0.633055] pci 0000:00:1b.0: [8086:3a3e] type 00 class 0x040300
[    0.633438] pci 0000:00:1b.0: reg 0x10: [mem 0xf7f00000-0xf7f03fff 64bit]
[    0.633897] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.634331] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.634735] pci 0000:00:1c.0: [8086:3a40] type 01 class 0x060400
[    0.638128] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.638548] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.638948] pci 0000:00:1c.1: [8086:3a42] type 01 class 0x060400
[    0.639378] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.639798] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.640206] pci 0000:00:1c.4: [8086:3a48] type 01 class 0x060400
[    0.640637] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.641059] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.641461] pci 0000:00:1d.0: [8086:3a34] type 00 class 0x0c0300
[    0.641868] pci 0000:00:1d.0: reg 0x20: [io  0x2080-0x209f]
[    0.642308] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.642708] pci 0000:00:1d.1: [8086:3a35] type 00 class 0x0c0300
[    0.643115] pci 0000:00:1d.1: reg 0x20: [io  0x2060-0x207f]
[    0.643558] pci 0000:00:1d.1: System wakeup disabled by ACPI
[    0.643964] pci 0000:00:1d.2: [8086:3a36] type 00 class 0x0c0300
[    0.644371] pci 0000:00:1d.2: reg 0x20: [io  0x2040-0x205f]
[    0.644811] pci 0000:00:1d.2: System wakeup disabled by ACPI
[    0.645218] pci 0000:00:1d.7: [8086:3a3a] type 00 class 0x0c0320
[    0.645603] pci 0000:00:1d.7: reg 0x10: [mem 0xe0321000-0xe03213ff]
[    0.646055] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.646490] pci 0000:00:1d.7: System wakeup disabled by ACPI
[    0.646890] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.647342] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.647743] pci 0000:00:1f.0: [8086:3a16] type 00 class 0x060100
[    0.648190] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.648560] pci 0000:00:1f.0: address space collision: [io  0x0400-0x047f] conflicts with ACPI CPU throttle [??? 0x00000410-0x00000415 flags 0x80000000]
[    0.649328] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    0.649741] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
[    0.650284] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0810 (mask 007f)
[    0.650937] pci 0000:00:1f.2: [8086:3a22] type 00 class 0x010601
[    0.651321] pci 0000:00:1f.2: reg 0x10: [io  0x2128-0x212f]
[    0.651681] pci 0000:00:1f.2: reg 0x14: [io  0x2134-0x2137]
[    0.652042] pci 0000:00:1f.2: reg 0x18: [io  0x2120-0x2127]
[    0.652402] pci 0000:00:1f.2: reg 0x1c: [io  0x2130-0x2133]
[    0.652760] pci 0000:00:1f.2: reg 0x20: [io  0x2020-0x203f]
[    0.653119] pci 0000:00:1f.2: reg 0x24: [mem 0xe0320000-0xe03207ff]
[    0.653534] pci 0000:00:1f.2: PME# supported from D3hot
[    0.653957] pci 0000:00:1f.3: [8086:3a30] type 00 class 0x0c0500
[    0.654339] pci 0000:00:1f.3: reg 0x10: [mem 0xf7f04000-0xf7f040ff 64bit]
[    0.654755] pci 0000:00:1f.3: reg 0x20: [io  0x2000-0x201f]
[    0.655244] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.655635] pci 0000:02:00.0: [5333:9043] type 00 class 0x030000
[    0.656017] pci 0000:02:00.0: reg 0x10: [mem 0xe0200000-0xe027ffff]
[    0.656402] pci 0000:02:00.0: reg 0x14: [mem 0xd0000000-0xdfffffff pref]
[    0.656823] pci 0000:02:00.0: reg 0x30: [mem 0xffff0000-0xffffffff pref]
[    0.657244] pci 0000:02:00.0: supports D1 D2
[    0.657607] pci 0000:02:00.1: [5333:903f] type 00 class 0x040300
[    0.657986] pci 0000:02:00.1: reg 0x10: [mem 0xe0280000-0xe0283fff]
[    0.658421] pci 0000:02:00.1: supports D1 D2
[    0.663891] pci 0000:00:03.0: PCI bridge to [bus 02]
[    0.664227] pci 0000:00:03.0:   bridge window [mem 0xe0200000-0xe02fffff]
[    0.664630] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.665232] pci 0000:00:07.0: PCI bridge to [bus 03]
[    0.665627] pci 0000:00:1c.0: PCI bridge to [bus 04]
[    0.665963] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.666338] pci 0000:00:1c.0:   bridge window [mem 0xe0400000-0xe05fffff]
[    0.666742] pci 0000:00:1c.0:   bridge window [mem 0xe0600000-0xe07fffff 64bit pref]
[    0.667352] pci 0000:00:1c.1: PCI bridge to [bus 05]
[    0.667688] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    0.668068] pci 0000:00:1c.1:   bridge window [mem 0xe0800000-0xe09fffff]
[    0.668473] pci 0000:00:1c.1:   bridge window [mem 0xe0a00000-0xe0bfffff 64bit pref]
[    0.669108] pci 0000:06:00.0: [11ab:6121] type 00 class 0x01018f
[    0.669498] pci 0000:06:00.0: reg 0x10: [io  0x1018-0x101f]
[    0.669865] pci 0000:06:00.0: reg 0x14: [io  0x1024-0x1027]
[    0.670231] pci 0000:06:00.0: reg 0x18: [io  0x1010-0x1017]
[    0.670598] pci 0000:06:00.0: reg 0x1c: [io  0x1020-0x1023]
[    0.670965] pci 0000:06:00.0: reg 0x20: [io  0x1000-0x100f]
[    0.671332] pci 0000:06:00.0: reg 0x24: [mem 0xe0100000-0xe01003ff]
[    0.671791] pci 0000:06:00.0: supports D1
[    0.672092] pci 0000:06:00.0: PME# supported from D0 D1 D3hot
[    0.679897] pci 0000:00:1c.4: PCI bridge to [bus 06]
[    0.680231] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    0.680607] pci 0000:00:1c.4:   bridge window [mem 0xe0100000-0xe01fffff]
[    0.681010] pci 0000:00:1c.4:   bridge window [mem 0xe0c00000-0xe0dfffff 64bit pref]
[    0.681616] pci 0000:07:03.0: [104c:8023] type 00 class 0x0c0010
[    0.682003] pci 0000:07:03.0: reg 0x10: [mem 0xe0004000-0xe00047ff]
[    0.682391] pci 0000:07:03.0: reg 0x14: [mem 0xe0000000-0xe0003fff]
[    0.682833] pci 0000:07:03.0: supports D1 D2
[    0.683140] pci 0000:07:03.0: PME# supported from D0 D1 D2 D3hot
[    0.683584] pci 0000:00:1e.0: PCI bridge to [bus 07] (subtractive decode)
[    0.683990] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.684393] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.684950] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.685507] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.686089] pci 0000:00:1e.0:   bridge window [mem 0x000c4000-0x000cbfff] (subtractive decode)
[    0.686672] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfedfffff] (subtractive decode)
[    0.687255] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xf7ffffff] (subtractive decode)
[    0.687930] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.689052] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.690172] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.691293] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.692417] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.693536] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.694659] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.695778] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.697289] ACPI: Enabled 2 GPEs in block 00 to 3F
[    0.697686] ACPI: \_SB_.PCI0: notify handler is installed
[    0.698057] Found 1 acpi root devices
[    0.698450] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.699014] vgaarb: loaded
[    0.699263] vgaarb: bridge control possible 0000:02:00.0
[    0.699696] SCSI subsystem initialized
[    0.700063] libata version 3.00 loaded.
[    0.700422] ACPI: bus type USB registered
[    0.700760] usbcore: registered new interface driver usbfs
[    0.701131] usbcore: registered new interface driver hub
[    0.701504] usbcore: registered new device driver usb
[    0.701905] pps_core: LinuxPPS API ver. 1 registered
[    0.702237] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.702854] PTP clock support registered
[    0.703233] EDAC MC: Ver: 3.0.0
[    0.703623] PCI: Using ACPI for IRQ routing
[    0.705166] PCI: Discovered peer bus 3f
[    0.705457] PCI: root bus 3f: using default resources
[    0.705791] PCI: Probing PCI hardware (bus 3f)
[    0.706137] PCI host bridge to bus 0000:3f
[    0.706438] pci_bus 0000:3f: root bus resource [io  0x0000-0xffff]
[    0.706816] pci_bus 0000:3f: root bus resource [mem 0x00000000-0xfffffffff]
[    0.707221] pci_bus 0000:3f: No busn resource found for root bus, will use [bus 3f-ff]
[    0.707782] pci 0000:3f:00.0: [8086:2c41] type 00 class 0x060000
[    0.708214] pci 0000:3f:00.1: [8086:2c01] type 00 class 0x060000
[    0.708632] pci 0000:3f:02.0: [8086:2c10] type 00 class 0x060000
[    0.709045] pci 0000:3f:02.1: [8086:2c11] type 00 class 0x060000
[    0.709460] pci 0000:3f:03.0: [8086:2c18] type 00 class 0x060000
[    0.709872] pci 0000:3f:03.1: [8086:2c19] type 00 class 0x060000
[    0.710285] pci 0000:3f:03.4: [8086:2c1c] type 00 class 0x060000
[    0.710697] pci 0000:3f:04.0: [8086:2c20] type 00 class 0x060000
[    0.711110] pci 0000:3f:04.1: [8086:2c21] type 00 class 0x060000
[    0.711522] pci 0000:3f:04.2: [8086:2c22] type 00 class 0x060000
[    0.711940] pci 0000:3f:04.3: [8086:2c23] type 00 class 0x060000
[    0.712357] pci 0000:3f:05.0: [8086:2c28] type 00 class 0x060000
[    0.712770] pci 0000:3f:05.1: [8086:2c29] type 00 class 0x060000
[    0.713183] pci 0000:3f:05.2: [8086:2c2a] type 00 class 0x060000
[    0.713595] pci 0000:3f:05.3: [8086:2c2b] type 00 class 0x060000
[    0.714012] pci 0000:3f:06.0: [8086:2c30] type 00 class 0x060000
[    0.714425] pci 0000:3f:06.1: [8086:2c31] type 00 class 0x060000
[    0.714839] pci 0000:3f:06.2: [8086:2c32] type 00 class 0x060000
[    0.715253] pci 0000:3f:06.3: [8086:2c33] type 00 class 0x060000
[    0.715673] pci_bus 0000:3f: busn_res: [bus 3f-ff] end is updated to 3f
[    0.716072] PCI: pci_cache_line_size set to 64 bytes
[    0.716476] e820: reserve RAM buffer [mem 0x0009cc00-0x0009ffff]
[    0.716847] e820: reserve RAM buffer [mem 0xccde3000-0xcfffffff]
[    0.717219] e820: reserve RAM buffer [mem 0xcf6bd000-0xcfffffff]
[    0.717590] e820: reserve RAM buffer [mem 0xcf714000-0xcfffffff]
[    0.717961] e820: reserve RAM buffer [mem 0xcf7e7000-0xcfffffff]
[    0.718333] e820: reserve RAM buffer [mem 0xcf800000-0xcfffffff]
[    0.719231] hpet clockevent registered
[    0.719521] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.719936] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.720443] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.722999] Switched to clocksource hpet
[    0.729308] pnp: PnP ACPI init
[    0.729585] ACPI: bus type PNP registered
[    0.730006] pnp 00:00: [dma 4]
[    0.730313] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.730714] IOAPIC[0]: Set routing entry (8-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:2)
[    0.734308] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.734707] IOAPIC[0]: Set routing entry (8-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:2)
[    0.735328] pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.735761] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.736226] system 00:04: [io  0x0500-0x053f] has been reserved
[    0.736594] system 00:04: [io  0x0400-0x047f] could not be reserved
[    0.736974] system 00:04: [io  0x0680-0x06ff] has been reserved
[    0.737342] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.737827] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.738498] pnp 00:06: Plug and Play ACPI device, IDs PNP0003 (active)
[    0.738922] pnp: PnP ACPI: found 7 devices
[    0.739226] ACPI: bus type PNP unregistered
[    0.747662] pci 0000:02:00.0: no compatible bridge window for [mem 0xffff0000-0xffffffff pref]
[    0.748286] pci 0000:00:1f.0: BAR 13: [io  0x0400-0x047f] has bogus alignment
[    0.748698] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.749039] pci 0000:02:00.0: BAR 6: assigned [mem 0xe0290000-0xe029ffff pref]
[    0.749571] pci 0000:00:03.0: PCI bridge to [bus 02]
[    0.749905] pci 0000:00:03.0:   bridge window [mem 0xe0200000-0xe02fffff]
[    0.750305] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.750859] pci 0000:00:07.0: PCI bridge to [bus 03]
[    0.751199] pci 0000:00:1c.0: PCI bridge to [bus 04]
[    0.751533] pci 0000:00:1c.0:   bridge window [io  0x3000-0x3fff]
[    0.751909] pci 0000:00:1c.0:   bridge window [mem 0xe0400000-0xe05fffff]
[    0.752309] pci 0000:00:1c.0:   bridge window [mem 0xe0600000-0xe07fffff 64bit pref]
[    0.752862] pci 0000:00:1c.1: PCI bridge to [bus 05]
[    0.753195] pci 0000:00:1c.1:   bridge window [io  0x4000-0x4fff]
[    0.753571] pci 0000:00:1c.1:   bridge window [mem 0xe0800000-0xe09fffff]
[    0.753971] pci 0000:00:1c.1:   bridge window [mem 0xe0a00000-0xe0bfffff 64bit pref]
[    0.754525] pci 0000:00:1c.4: PCI bridge to [bus 06]
[    0.754858] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    0.755237] pci 0000:00:1c.4:   bridge window [mem 0xe0100000-0xe01fffff]
[    0.755637] pci 0000:00:1c.4:   bridge window [mem 0xe0c00000-0xe0dfffff 64bit pref]
[    0.756191] pci 0000:00:1e.0: PCI bridge to [bus 07]
[    0.756525] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xe00fffff]
[    0.756930] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.757285] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.757639] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.758019] pci_bus 0000:00: resource 7 [mem 0x000c4000-0x000cbfff]
[    0.758399] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfedfffff]
[    0.758779] pci_bus 0000:00: resource 9 [mem 0xd0000000-0xf7ffffff]
[    0.759163] pci_bus 0000:02: resource 1 [mem 0xe0200000-0xe02fffff]
[    0.759543] pci_bus 0000:02: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.760075] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
[    0.760430] pci_bus 0000:04: resource 1 [mem 0xe0400000-0xe05fffff]
[    0.760811] pci_bus 0000:04: resource 2 [mem 0xe0600000-0xe07fffff 64bit pref]
[    0.761344] pci_bus 0000:05: resource 0 [io  0x4000-0x4fff]
[    0.761699] pci_bus 0000:05: resource 1 [mem 0xe0800000-0xe09fffff]
[    0.762079] pci_bus 0000:05: resource 2 [mem 0xe0a00000-0xe0bfffff 64bit pref]
[    0.762613] pci_bus 0000:06: resource 0 [io  0x1000-0x1fff]
[    0.762969] pci_bus 0000:06: resource 1 [mem 0xe0100000-0xe01fffff]
[    0.763352] pci_bus 0000:06: resource 2 [mem 0xe0c00000-0xe0dfffff 64bit pref]
[    0.763886] pci_bus 0000:07: resource 1 [mem 0xe0000000-0xe00fffff]
[    0.764266] pci_bus 0000:07: resource 4 [io  0x0000-0x0cf7]
[    0.764622] pci_bus 0000:07: resource 5 [io  0x0d00-0xffff]
[    0.764977] pci_bus 0000:07: resource 6 [mem 0x000a0000-0x000bffff]
[    0.765357] pci_bus 0000:07: resource 7 [mem 0x000c4000-0x000cbfff]
[    0.765738] pci_bus 0000:07: resource 8 [mem 0xfed40000-0xfedfffff]
[    0.766118] pci_bus 0000:07: resource 9 [mem 0xd0000000-0xf7ffffff]
[    0.766500] pci_bus 0000:3f: resource 4 [io  0x0000-0xffff]
[    0.766856] pci_bus 0000:3f: resource 5 [mem 0x00000000-0xfffffffff]
[    0.767267] NET: Registered protocol family 2
[    0.767690] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.768298] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.768780] TCP: Hash tables configured (established 32768 bind 32768)
[    0.769187] TCP: reno registered
[    0.769461] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.769844] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.770291] NET: Registered protocol family 1
[    0.770669] RPC: Registered named UNIX socket transport module.
[    0.771041] RPC: Registered udp transport module.
[    0.771364] RPC: Registered tcp transport module.
[    0.771686] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.772367] IOAPIC[0]: Set routing entry (8-16 -> 0x41 -> IRQ 16 Mode:1 Active:1 Dest:2)
[    0.773462] IOAPIC[0]: Set routing entry (8-21 -> 0x51 -> IRQ 21 Mode:1 Active:1 Dest:2)
[    0.774553] IOAPIC[0]: Set routing entry (8-19 -> 0x61 -> IRQ 19 Mode:1 Active:1 Dest:2)
[    0.775651] IOAPIC[0]: Set routing entry (8-18 -> 0x71 -> IRQ 18 Mode:1 Active:1 Dest:2)
[    0.776749] IOAPIC[0]: Set routing entry (8-23 -> 0x81 -> IRQ 23 Mode:1 Active:1 Dest:2)
[    0.779174] pci 0000:02:00.0: Boot video device
[    0.779513] PCI: CLS 64 bytes, default 64
[    0.779837] Trying to unpack rootfs image as initramfs...
[    5.615121] Freeing initrd memory: 293556K (ffff88006e146000 - ffff88007fff3000)
[    5.615673] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    5.616061] software IO TLB [mem 0xc8de3000-0xccde3000] (64MB) mapped at [ffff8800c8de3000-ffff8800ccde2fff]
[    5.617126] kvm: VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL does not work properly. Using workaround
[    5.618071] Scanning for low memory corruption every 60 seconds
[    5.619133] sha1_ssse3: Using SSSE3 optimized SHA-1 implementation
[    5.619544] PCLMULQDQ-NI instructions are not detected.
[    5.619886] AVX or AES-NI instructions are not detected.
[    5.620230] AVX instructions are not detected.
[    5.620542] AVX instructions are not detected.
[    5.620854] AVX instructions are not detected.
[    5.621166] AVX instructions are not detected.
[    5.642876] bounce pool size: 64 pages
[    5.643170] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    5.647695] VFS: Disk quotas dquot_6.5.2
[    5.648057] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    5.649607] NFS: Registering the id_resolver key type
[    5.649947] Key type id_resolver registered
[    5.650251] Key type id_legacy registered
[    5.650549] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    5.650948] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    5.651622] ROMFS MTD (C) 2007 Red Hat, Inc.
[    5.652033] fuse init (API version 7.22)
[    5.652514] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    5.653844] bio: create slab <bio-1> at 1
[    5.654408] Btrfs loaded
[    5.654658] msgmni has been set to 7863
[    5.656393] NET: Registered protocol family 38
[    5.656708] Key type asymmetric registered
[    5.657091] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 250)
[    5.657667] io scheduler noop registered
[    5.657961] io scheduler deadline registered
[    5.658272] io scheduler cfq registered (default)
[    5.659846] IOAPIC[0]: Set routing entry (8-17 -> 0x91 -> IRQ 17 Mode:1 Active:1 Dest:2)
[    5.660430] pcieport 0000:00:1c.0: irq 40 for MSI/MSI-X
[    5.661264] pcieport 0000:00:1c.1: irq 41 for MSI/MSI-X
[    5.661954] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
[    5.662494] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.662943] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    5.663342] intel_idle: MWAIT substates: 0x1120
[    5.663666] intel_idle: v0.4 model 0x1A
[    5.663956] intel_idle: lapic_timer_reliable_states 0x2
[    5.664566] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    5.665136] ACPI: Sleep Button [SLPB]
[    5.665490] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    5.666030] ACPI: Power Button [PWRF]
[    5.666487] GHES: HEST is not enabled!
[    5.666983] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    5.923375] serial8250: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 921600) is a NS16550A
[    5.924620] Non-volatile memory driver v1.3
[    5.926919] brd: module loaded
[    5.928233] loop: module loaded
[    5.928565] lkdtm: No crash points registered, enable through debugfs
[    5.929023] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \IGPO 1 (20131115/utaddress-251)
[    5.929782] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.930720] Loading iSCSI transport class v2.0-870.
[    5.931606] Adaptec aacraid driver 1.2-0[30200]-ms
[    5.932036] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    5.932521] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.06.00.08-k.
[    5.933225] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
[    5.933813] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
[    5.934262] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    5.934867] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    5.935520] RocketRAID 3xxx/4xxx Controller driver v1.8
[    5.936304] ahci 0000:00:1f.2: version 3.0
[    5.936914] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    5.937301] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    5.937869] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    5.980139] scsi0 : ahci
[    5.980548] scsi1 : ahci
[    5.980946] scsi2 : ahci
[    5.981349] scsi3 : ahci
[    5.981756] scsi4 : ahci
[    5.982161] scsi5 : ahci
[    5.982487] ata1: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320100 irq 43
[    5.983025] ata2: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320180 irq 43
[    5.983619] ata3: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320200 irq 43
[    5.984158] ata4: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320280 irq 43
[    5.984696] ata5: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320300 irq 43
[    5.985234] ata6: SATA max UDMA/133 abar m2048@0xe0320000 port 0xe0320380 irq 43
[    5.985826] ahci 0000:06:00.0: Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.
[    5.986477] ahci 0000:06:00.0: controller can't do NCQ, turning off CAP_NCQ
[    5.986883] ahci 0000:06:00.0: controller can't do PMP, turning off CAP_PMP
[    5.987323] ahci 0000:06:00.0: masking port_map 0x7 -> 0x3
[    5.987684] ahci 0000:06:00.0: SSS flag set, parallel bus scan disabled
[    5.988115] ahci 0000:06:00.0: AHCI 0001.0000 32 slots 3 ports 3 Gbps 0x3 impl IDE mode
[    5.988677] ahci 0000:06:00.0: flags: 64bit stag led slum part 
[    5.989685] scsi6 : ahci
[    5.990031] scsi7 : ahci
[    5.990374] scsi8 : ahci
[    5.990714] ata7: SATA max UDMA/133 abar m1024@0xe0100000 port 0xe0100100 irq 16
[    5.991292] ata8: SATA max UDMA/133 abar m1024@0xe0100000 port 0xe0100180 irq 16
[    5.991829] ata9: DUMMY
[    5.992975] tun: Universal TUN/TAP device driver, 1.6
[    5.993311] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    5.993874] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
[    5.994343] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    5.994691] Copyright (c) 2007 Atheros Corporation.
[    5.995212] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    5.995642] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.com>
[    5.995642]   http://www.scyld.com/network/drivers.html
[    5.996652] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
[    5.997242] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    5.997615] e100: Copyright(c) 1999-2006 Intel Corporation
[    5.998071] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-NAPI
[    5.998479] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    5.998943] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    5.999414] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    6.000053] IOAPIC[0]: Set routing entry (8-20 -> 0xe1 -> IRQ 20 Mode:1 Active:1 Dest:2)
[    6.000666] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    6.001289] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    6.195357] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 00:1c:c0:79:88:54
[    6.195918] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    6.196342] e1000e 0000:00:19.0 eth0: MAC: 7, PHY: 8, PBA No: FFFFFF-0FF
[    6.196963] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.5-k
[    6.197369] igb: Copyright (c) 2007-2013 Intel Corporation.
[    6.197939] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 3.15.1-k
[    6.198491] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    6.199052] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    6.199473] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    6.200105] sky2: driver version 1.30
[    6.201485] usbcore: registered new interface driver catc
[    6.201897] usbcore: registered new interface driver kaweth
[    6.202251] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Ethernet driver
[    6.202857] usbcore: registered new interface driver pegasus
[    6.203363] usbcore: registered new interface driver rtl8150
[    6.203857] usbcore: registered new interface driver asix
[    6.204343] usbcore: registered new interface driver ax88179_178a
[    6.204842] usbcore: registered new interface driver cdc_ether
[    6.205343] usbcore: registered new interface driver r815x
[    6.205832] usbcore: registered new interface driver cdc_eem
[    6.206333] usbcore: registered new interface driver dm9601
[    6.206812] usbcore: registered new interface driver smsc75xx
[    6.207337] usbcore: registered new interface driver smsc95xx
[    6.207823] usbcore: registered new interface driver gl620a
[    6.208304] usbcore: registered new interface driver net1080
[    6.208790] usbcore: registered new interface driver plusb
[    6.209267] usbcore: registered new interface driver rndis_host
[    6.209760] usbcore: registered new interface driver cdc_subset
[    6.210251] usbcore: registered new interface driver zaurus
[    6.210731] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    6.211439] usbcore: registered new interface driver int51x1
[    6.211933] usbcore: registered new interface driver ipheth
[    6.212414] usbcore: registered new interface driver sierra_net
[    6.212905] usbcore: registered new interface driver cdc_ncm
[    6.213263] Fusion MPT base driver 3.04.20
[    6.213563] Copyright (c) 1999-2008 LSI Corporation
[    6.213895] Fusion MPT SPI Host driver 3.04.20
[    6.214355] Fusion MPT FC Host driver 3.04.20
[    6.214809] Fusion MPT SAS Host driver 3.04.20
[    6.215262] Fusion MPT misc device (ioctl) driver 3.04.20
[    6.215793] mptctl: Registered with Fusion MPT base driver
[    6.216144] mptctl: /dev/mptctl @ (major,minor=10,220)
[    6.216749] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.217141] ehci-pci: EHCI PCI platform driver
[    6.217745] ehci-pci 0000:00:1a.7: EHCI Host Controller
[    6.218186] ehci-pci 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    6.218736] ehci-pci 0000:00:1a.7: debug port 1
[    6.222964] ehci-pci 0000:00:1a.7: cache line size of 64 is not supported
[    6.223379] ehci-pci 0000:00:1a.7: irq 18, io mem 0xe0322000
[    6.235245] ehci-pci 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    6.236154] hub 1-0:1.0: USB hub found
[    6.236448] hub 1-0:1.0: 6 ports detected
[    6.237128] ehci-pci 0000:00:1d.7: EHCI Host Controller
[    6.237704] ehci-pci 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    6.238254] ehci-pci 0000:00:1d.7: debug port 1
[    6.242465] ehci-pci 0000:00:1d.7: cache line size of 64 is not supported
[    6.242876] ehci-pci 0000:00:1d.7: irq 23, io mem 0xe0321000
[    6.255275] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.256169] hub 2-0:1.0: USB hub found
[    6.256462] hub 2-0:1.0: 6 ports detected
[    6.257052] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.257430] ohci-pci: OHCI PCI platform driver
[    6.257938] uhci_hcd: USB Universal Host Controller Interface driver
[    6.258599] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    6.259224] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    6.259786] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000020e0
[    6.260581] hub 3-0:1.0: USB hub found
[    6.260873] hub 3-0:1.0: 2 ports detected
[    6.261500] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    6.262077] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    6.262644] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000020c0
[    6.263454] hub 4-0:1.0: USB hub found
[    6.263746] hub 4-0:1.0: 2 ports detected
[    6.264375] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    6.264877] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    6.265443] uhci_hcd 0000:00:1a.2: irq 19, io base 0x000020a0
[    6.266106] hub 5-0:1.0: USB hub found
[    6.266399] hub 5-0:1.0: 2 ports detected
[    6.267024] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.267742] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    6.268303] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002080
[    6.269224] hub 6-0:1.0: USB hub found
[    6.269526] hub 6-0:1.0: 2 ports detected
[    6.270164] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.270782] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    6.271365] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
[    6.272398] hub 7-0:1.0: USB hub found
[    6.272701] hub 7-0:1.0: 2 ports detected
[    6.273339] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.273953] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    6.274521] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
[    6.275526] hub 8-0:1.0: USB hub found
[    6.275829] hub 8-0:1.0: 2 ports detected
[    6.276639] usbcore: registered new interface driver usb-storage
[    6.277192] usbcore: registered new interface driver ums-alauda
[    6.277746] usbcore: registered new interface driver ums-datafab
[    6.278276] usbcore: registered new interface driver ums-freecom
[    6.278804] usbcore: registered new interface driver ums-isd200
[    6.279373] usbcore: registered new interface driver ums-jumpshot
[    6.279884] usbcore: registered new interface driver ums-sddr09
[    6.280409] usbcore: registered new interface driver ums-sddr55
[    6.280932] usbcore: registered new interface driver ums-usbat
[    6.281459] usbcore: registered new interface driver usbtest
[    6.282195] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    6.285795] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.286131] serio: i8042 AUX port at 0x60,0x64 irq 12
[    6.286971] mousedev: PS/2 mouse device common for all mice
[    6.288205] rtc_cmos 00:01: RTC can wake from S4
[    6.288700] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    6.289096] rtc_cmos 00:01: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    6.289752] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    6.293195] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0460)
[    6.294046] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    6.294569] iTCO_vendor_support: vendor-support=0
[    6.295102] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[    6.295798] md: linear personality registered for level -1
[    6.296148] md: raid0 personality registered for level 0
[    6.296493] md: raid1 personality registered for level 1
[    6.296837] md: raid10 personality registered for level 10
[    6.297270] md: raid6 personality registered for level 6
[    6.297624] md: raid5 personality registered for level 5
[    6.297968] md: raid4 personality registered for level 4
[    6.298312] md: multipath personality registered for level -4
[    6.298672] md: faulty personality registered for level -5
[    6.300041] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    6.301071] device-mapper: multipath: version 1.6.0 loaded
[    6.301428] device-mapper: multipath round-robin: version 1.0.0 loaded
[    6.301829] device-mapper: cache-policy-mq: version 1.1.0 loaded
[    6.302198] device-mapper: cache cleaner: version 1.0.0 loaded
[    6.303060] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    6.303713] ata5: SATA link down (SStatus 0 SControl 300)
[    6.304085] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.304489] ata6: SATA link down (SStatus 0 SControl 300)
[    6.305244] usbcore: registered new interface driver usbhid
[    6.305599] usbhid: USB HID core driver
[    6.305990] TCP: bic registered
[    6.306256] Initializing XFRM netlink socket
[    6.306733] NET: Registered protocol family 10
[    6.307184] sit: IPv6 over IPv4 tunneling driver
[    6.307214] ata3: SATA link down (SStatus 0 SControl 300)
[    6.307230] ata4: SATA link down (SStatus 0 SControl 300)
[    6.308382] NET: Registered protocol family 17
[    6.308706] 8021q: 802.1Q VLAN Support v1.8
[    6.309294] sctp: Hash tables configured (established 65536 bind 65536)
[    6.309825] Key type dns_resolver registered
[    6.310887] 
[    6.310887] printing PIC contents
[    6.311247] ata7: SATA link down (SStatus 0 SControl 300)
[    6.311708] ... PIC  IMR: ffff
[    6.311971] ... PIC  IRR: 0c29
[    6.312238] ... PIC  ISR: 0000
[    6.312502] ... PIC ELCR: 0e20
[    6.312770] printing local APIC contents on CPU#0/2:
[    6.313105] ... APIC ID:      02000000 (2)
[    6.313407] ... APIC VERSION: 00060015
[    6.313696] ... APIC TASKPRI: 00000000 (00)
[    6.314001] ... APIC PROCPRI: 00000000
[    6.314290] ... APIC LDR: 01000000
[    6.314567] ... APIC DFR: ffffffff
[    6.314843] ... APIC SPIV: 000001ff
[    6.315123] ... APIC ISR field:
[    6.315391] 0000000000000000000000000000000000000000000000000000000000000000
[    6.316071] ... APIC TMR field:
[    6.316339] 0000000000000000000000020002000000000002000000000000000000000000
[    6.317018] ... APIC IRR field:
[    6.317285] 0000000000010000000000000000000000000000000000000000000000008000
[    6.317967] ... APIC ESR: 00000000
[    6.318244] ... APIC ICR: 000000ef
[    6.318521] ... APIC ICR2: 05000000
[    6.318801] ... APIC LVTT: 000000ef
[    6.319080] ... APIC LVTPC: 00000400
[    6.319362] ... APIC LVT0: 00010700
[    6.319641] ... APIC LVT1: 00000400
[    6.319920] ... APIC LVTERR: 000000fe
[    6.320205] ... APIC TMICT: 00004f03
[    6.320487] ... APIC TMCCT: 00000000
[    6.320769] ... APIC TDCR: 00000003
[    6.321048] 
[    6.321254] number of MP IRQ sources: 15.
[    6.321553] number of IO-APIC #8 registers: 24.
[    6.321869] testing the IO APIC.......................
[    6.322212] IO APIC #8......
[    6.322467] .... register #00: 08000000
[    6.322757] .......    : physical APIC id: 08
[    6.323067] .......    : Delivery Type: 0
[    6.323368] .......    : LTS          : 0
[    6.323665] .... register #01: 00170020
[    6.323955] .......     : max redirection entries: 17
[    6.324289] .......     : PRQ implemented: 0
[    6.324595] .......     : IO APIC version: 20
[    6.324904] .... IRQ redirection table:
[    6.325198] 1    0    0   0   0    0    0    00
[    6.325516] 0    0    0   0   0    0    0    31
[    6.325835] 0    0    0   0   0    0    0    30
[    6.326153] 1    0    0   0   0    0    0    33
[    6.326472] 1    0    0   0   0    0    0    34
[    6.326790] 1    0    0   0   0    0    0    35
[    6.327109] 1    0    0   0   0    0    0    36
[    6.327432] 1    0    0   0   0    0    0    37
[    6.327751] 0    0    0   0   0    0    0    38
[    6.328069] 0    1    0   0   0    0    0    39
[    6.328388] 1    0    0   0   0    0    0    3A
[    6.328706] 1    0    0   0   0    0    0    3B
[    6.329024] 0    0    0   0   0    0    0    3C
[    6.329342] 1    0    0   0   0    0    0    3D
[    6.329660] 1    0    0   0   0    0    0    3E
[    6.329979] 1    0    0   0   0    0    0    3F
[    6.330296] 0    1    0   1   0    0    0    41
[    6.330615] 1    1    0   1   0    0    0    91
[    6.330933] 0    1    0   1   0    0    0    71
[    6.331267] 0    1    0   1   0    0    0    61
[    6.331586] 1    1    0   1   0    0    0    E1
[    6.331905] 0    1    0   1   0    0    0    51
[    6.332223] 1    0    0   0   0    0    0    00
[    6.332543] 0    1    0   1   0    0    0    81
[    6.332859] IRQ to pin mappings:
[    6.333128] IRQ0 -> 0:2
[    6.333433] IRQ1 -> 0:1
[    6.333738] IRQ3 -> 0:3
[    6.334042] IRQ4 -> 0:4
[    6.334347] IRQ5 -> 0:5
[    6.334652] IRQ6 -> 0:6
[    6.334958] IRQ7 -> 0:7
[    6.335268] IRQ8 -> 0:8
[    6.335574] IRQ9 -> 0:9
[    6.335880] IRQ10 -> 0:10
[    6.336192] IRQ11 -> 0:11
[    6.336504] IRQ12 -> 0:12
[    6.336815] IRQ13 -> 0:13
[    6.337127] IRQ14 -> 0:14
[    6.337440] IRQ15 -> 0:15
[    6.337752] IRQ16 -> 0:16
[    6.338064] IRQ17 -> 0:17
[    6.338376] IRQ18 -> 0:18
[    6.338687] IRQ19 -> 0:19
[    6.338999] IRQ20 -> 0:20
[    6.339317] IRQ21 -> 0:21
[    6.339629] IRQ23 -> 0:23
[    6.339940] .................................... done.
[    6.340435] registered taskstats version 1
[    6.342719] rtc_cmos 00:01: setting system clock to 2014-01-02 13:28:18 UTC (1388669298)
[    6.343312] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    6.343682] EDD information not available.
[    6.441649] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    6.543287] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    6.543698] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    6.615257] tsc: Refined TSC clocksource calibration: 3200.113 MHz
[    6.622193] ata1.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
[    6.622555] ata1.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.639325] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    6.680503] ata1.00: configured for UDMA/133
[    6.681021] scsi 0:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[    6.682430] sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    6.682867] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.683735] sd 0:0:0:0: [sda] Write Protect is off
[    6.684070] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.684544] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.732164] ata2.00: ATAPI: PLEXTOR DVDR   PX-712A, 1.07, max UDMA/33
[    6.732559] ata2.00: applying bridge limits
[    6.735749]  sda: sda1 sda2 sda3 sda4 < sda5 >
[    6.738446] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.763461] ata2.00: configured for UDMA/33
[    6.765101] scsi 1:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-712A   1.07 PQ: 0 ANSI: 5
[    6.766700] scsi 1:0:0:0: Attached scsi generic sg1 type 5
[    6.863326] usb 3-1: new low-speed USB device number 2 using uhci_hcd
[    7.087375] ata8: SATA link down (SStatus 0 SControl 300)
[    7.193988] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.0/input/input5
[    7.195044] hid-generic 0003:0557:2220.0001: input: USB HID v1.10 Keyboard [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-1/input0
[    7.235997] input: ATEN ATEN  CS-1758/54 as /devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1:1.1/input/input6
[    7.237464] hid-generic 0003:0557:2220.0002: input: USB HID v1.10 Mouse [ATEN ATEN  CS-1758/54] on usb-0000:00:1a.0-1/input1
[    7.615516] Switched to clocksource tsc
[    8.748181] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
[    8.751439] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    8.767395] Sending DHCP requests .., OK
[   11.851556] IP-Config: Got DHCP answer from 192.168.1.1, my address is 192.168.1.121
[   11.852183] IP-Config: Complete:
[   11.852454]      device=eth0, hwaddr=00:1c:c0:79:88:54, ipaddr=192.168.1.121, mask=255.255.255.0, gw=192.168.1.1
[   11.856073]      host=fat, domain=lkp.intel.com, nis-domain=(none)
[   11.856450]      bootserver=192.168.1.1, rootserver=192.168.1.1, rootpath=
[   11.856729]      nameserver0=192.168.1.1
[   11.857213] PM: Hibernation image not present or could not be loaded.
[   11.859112] Freeing unused kernel memory: 1428K (ffffffff82336000 - ffffffff8249b000)
[   11.859699] Write protecting the kernel read-only data: 18432k
[   11.864560] Freeing unused kernel memory: 1972K (ffff880001a13000 - ffff880001c00000)
[   11.868778] Freeing unused kernel memory: 2000K (ffff88000200c000 - ffff880002200000)
[   12.040071] microcode: CPU0 sig=0x106a4, pf=0x2, revision=0x6
[   12.040430] platform microcode: Direct firmware load failed with error -2
[   12.040807] platform microcode: Falling back to user helper
[   12.046242] microcode: CPU1 sig=0x106a4, pf=0x2, revision=0x6
[   12.046631] platform microcode: Direct firmware load failed with error -2
[   12.046633] platform microcode: Falling back to user helper
[   12.049586] microcode: CPU2 sig=0x106a4, pf=0x2, revision=0x6
[   12.050077] platform microcode: Direct firmware load failed with error -2
[   12.050479] platform microcode: Falling back to user helper
[   12.053296] microcode: CPU3 sig=0x106a4, pf=0x2, revision=0x6
[   12.053680] platform microcode: Direct firmware load failed with error -2
[   12.054087] platform microcode: Falling back to user helper
[   12.056745] microcode: CPU4 sig=0x106a4, pf=0x2, revision=0x6
[   12.057122] platform microcode: Direct firmware load failed with error -2
[   12.057522] platform microcode: Falling back to user helper
[   12.060188] microcode: CPU5 sig=0x106a4, pf=0x2, revision=0x6
[   12.060567] platform microcode: Direct firmware load failed with error -2
[   12.060967] platform microcode: Falling back to user helper
[   12.063708] microcode: CPU6 sig=0x106a4, pf=0x2, revision=0x6
[   12.064087] platform microcode: Direct firmware load failed with error -2
[   12.064488] platform microcode: Falling back to user helper
[   12.067081] microcode: CPU7 sig=0x106a4, pf=0x2, revision=0x6
[   12.067458] platform microcode: Direct firmware load failed with error -2
[   12.067859] platform microcode: Falling back to user helper
[   12.070486] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   12.885629] random: vgscan urandom read with 98 bits of entropy available

--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=x86_64-lkp

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.12.0 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_FHANDLE is not set
# CONFIG_AUDIT is not set

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
CONFIG_NO_HZ_IDLE=y
# CONFIG_NO_HZ_FULL is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
# CONFIG_RCU_USER_QS is not set
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
# CONFIG_RCU_FANOUT_EXACT is not set
CONFIG_RCU_FAST_NO_HZ=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_ARCH_USES_NUMA_PROT_NONE=y
# CONFIG_NUMA_BALANCING_DEFAULT_ENABLED is not set
CONFIG_NUMA_BALANCING=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
CONFIG_MEMCG_KMEM=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_BLK_CGROUP=y
# CONFIG_DEBUG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
# CONFIG_SCHED_AUTOGROUP is not set
CONFIG_MM_OWNER=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
# CONFIG_EMBEDDED is not set
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
# CONFIG_JUMP_LABEL is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_VSMP is not set
# CONFIG_X86_INTEL_LPSS is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
# CONFIG_CALGARY_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_MAXSMP is not set
CONFIG_NR_CPUS=512
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
# CONFIG_X86_MCE_AMD is not set
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_I8K=m
CONFIG_MICROCODE=m
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_MICROCODE_INTEL_LIB=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
# CONFIG_MOVABLE_NODE is not set
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_CMA is not set
# CONFIG_ZBUD is not set
# CONFIG_MEM_SOFT_DIRTY is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_AUTOSLEEP=y
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_PM_TRACE_RTC is not set
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=m
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
# CONFIG_ACPI_HOTPLUG_MEMORY is not set
# CONFIG_ACPI_SBS is not set
CONFIG_ACPI_HED=y
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_BGRT is not set
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=y
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_GOV_COMMON=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# x86 CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
# CONFIG_X86_AMD_FREQ_SENSITIVITY is not set
CONFIG_X86_SPEEDSTEP_CENTRINO=m
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
CONFIG_INTEL_IDLE=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
# CONFIG_PCIEAER_INJECT is not set
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set
# CONFIG_RAPIDIO is not set
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_BINFMT_SCRIPT=y
# CONFIG_HAVE_AOUT is not set
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_KEYS_COMPAT=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=m
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
# CONFIG_IP_FIB_TRIE_STATS is not set
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
CONFIG_NET_IP_TUNNEL=y
CONFIG_IP_MROUTE=y
# CONFIG_IP_MROUTE_MULTIPLE_TABLES is not set
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
# CONFIG_TCP_CONG_CUBIC is not set
# CONFIG_TCP_CONG_WESTWOOD is not set
# CONFIG_TCP_CONG_HTCP is not set
# CONFIG_TCP_CONG_HSTCP is not set
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
# CONFIG_TCP_CONG_ILLINOIS is not set
CONFIG_DEFAULT_BIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="bic"
# CONFIG_TCP_MD5SIG is not set
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
# CONFIG_INET6_AH is not set
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
# CONFIG_IPV6_MIP6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
# CONFIG_NET_SCTPPROBE is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_COOKIE_HMAC_SHA1 is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
# CONFIG_BRIDGE is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
# CONFIG_VSOCKETS is not set
# CONFIG_NETLINK_MMAP is not set
# CONFIG_NETLINK_DIAG is not set
# CONFIG_NET_MPLS_GSO is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_NETPRIO_CGROUP is not set
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
# CONFIG_BPF_JIT is not set
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_TCPPROBE is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
# CONFIG_CFG80211 is not set
# CONFIG_LIB80211 is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set
# CONFIG_NFC is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
# CONFIG_DMA_SHARED_BUFFER is not set

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_BLK_DEV_RSXX is not set

#
# Misc devices
#
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
# CONFIG_ATMEL_SSC is not set
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
# CONFIG_ISL29003 is not set
# CONFIG_ISL29020 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_SENSORS_BH1780 is not set
# CONFIG_SENSORS_BH1770 is not set
# CONFIG_SENSORS_APDS990X is not set
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_PCH_PHUB is not set
# CONFIG_USB_SWITCH_FSA9480 is not set
# CONFIG_SRAM is not set
# CONFIG_C2PORT is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_LEGACY is not set
# CONFIG_EEPROM_MAX6875 is not set
# CONFIG_EEPROM_93CX6 is not set
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_SENSORS_LIS3_I2C is not set

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
# CONFIG_INTEL_MEI is not set
# CONFIG_INTEL_MEI_ME is not set
# CONFIG_VMWARE_VMCI is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_ISCSI_BOOT_SYSFS is not set
# CONFIG_SCSI_CXGB3_ISCSI is not set
# CONFIG_SCSI_CXGB4_ISCSI is not set
# CONFIG_SCSI_BNX2_ISCSI is not set
# CONFIG_SCSI_BNX2X_FCOE is not set
# CONFIG_BE2ISCSI is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_HPSA is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_3W_SAS is not set
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=4
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_MVUMI is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_SCSI_ESAS2R is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
# CONFIG_SCSI_MPT2SAS_LOGGING is not set
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
# CONFIG_SCSI_MPT3SAS_LOGGING is not set
# CONFIG_SCSI_UFSHCD is not set
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
# CONFIG_SCSI_FLASHPOINT is not set
# CONFIG_VMWARE_PVSCSI is not set
# CONFIG_LIBFC is not set
# CONFIG_LIBFCOE is not set
# CONFIG_FCOE is not set
# CONFIG_FCOE_FNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_PMCRAID is not set
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=y
# CONFIG_SCSI_CHELSIO_FCOE is not set
# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
# CONFIG_SATA_HIGHBANK is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_RCAR is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_PATA_ACPI is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_AUTODETECT is not set
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BCACHE=y
# CONFIG_BCACHE_DEBUG is not set
# CONFIG_BCACHE_EDEBUG is not set
# CONFIG_BCACHE_CLOSURES_DEBUG is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_BUFIO=y
CONFIG_DM_BIO_PRISON=y
CONFIG_DM_PERSISTENT_DATA=y
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
# CONFIG_DM_THIN_PROVISIONING is not set
CONFIG_DM_CACHE=y
CONFIG_DM_CACHE_MQ=y
CONFIG_DM_CACHE_CLEANER=y
CONFIG_DM_MIRROR=y
# CONFIG_DM_RAID is not set
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
CONFIG_DM_DELAY=y
# CONFIG_DM_UEVENT is not set
CONFIG_DM_FLAKEY=y
# CONFIG_DM_VERITY is not set
# CONFIG_DM_SWITCH is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_CTL=y
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
# CONFIG_NET_FC is not set
# CONFIG_NET_TEAM is not set
# CONFIG_MACVLAN is not set
# CONFIG_VXLAN is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
CONFIG_TUN=y
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
# CONFIG_NLMON is not set
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#
CONFIG_VHOST_NET=y
CONFIG_VHOST_RING=y
CONFIG_VHOST=y

#
# Distributed Switch Architecture drivers
#
# CONFIG_NET_DSA_MV88E6XXX is not set
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
# CONFIG_NET_DSA_MV88E6123_61_65 is not set
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
CONFIG_NET_VENDOR_ADAPTEC=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=y
CONFIG_PCNET32=y
# CONFIG_PCMCIA_NMCLAN is not set
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
CONFIG_ATL1=y
CONFIG_ATL1E=y
CONFIG_ATL1C=y
# CONFIG_ALX is not set
CONFIG_NET_CADENCE=y
# CONFIG_ARM_AT91_ETHER is not set
# CONFIG_MACB is not set
CONFIG_NET_VENDOR_BROADCOM=y
# CONFIG_B44 is not set
CONFIG_BNX2=y
# CONFIG_CNIC is not set
CONFIG_TIGON3=y
# CONFIG_BNX2X is not set
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
# CONFIG_NET_CALXEDA_XGMAC is not set
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
# CONFIG_CHELSIO_T3 is not set
# CONFIG_CHELSIO_T4 is not set
# CONFIG_CHELSIO_T4VF is not set
CONFIG_NET_VENDOR_CISCO=y
# CONFIG_ENIC is not set
# CONFIG_DNET is not set
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=y
CONFIG_WINBOND_840=y
CONFIG_DM9102=y
CONFIG_ULI526X=y
# CONFIG_PCMCIA_XIRCOM is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DL2K=y
# CONFIG_SUNDANCE is not set
CONFIG_NET_VENDOR_EMULEX=y
# CONFIG_BE2NET is not set
CONFIG_NET_VENDOR_EXAR=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_FUJITSU=y
# CONFIG_PCMCIA_FMVJ18X is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
# CONFIG_IGBVF is not set
CONFIG_IXGB=y
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
# CONFIG_IXGBEVF is not set
# CONFIG_I40E is not set
CONFIG_NET_VENDOR_I825XX=y
# CONFIG_IP1000 is not set
# CONFIG_JME is not set
CONFIG_NET_VENDOR_MARVELL=y
# CONFIG_MVMDIO is not set
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
# CONFIG_SKGE_GENESIS is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
CONFIG_NET_VENDOR_MELLANOX=y
# CONFIG_MLX4_EN is not set
# CONFIG_MLX4_CORE is not set
# CONFIG_MLX5_CORE is not set
CONFIG_NET_VENDOR_MICREL=y
# CONFIG_KS8851_MLL is not set
# CONFIG_KSZ884X_PCI is not set
CONFIG_NET_VENDOR_MYRI=y
# CONFIG_MYRI10GE is not set
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
# CONFIG_NATSEMI is not set
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
# CONFIG_PCMCIA_AXNET is not set
CONFIG_NE2K_PCI=y
# CONFIG_PCMCIA_PCNET is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
CONFIG_NET_VENDOR_OKI=y
# CONFIG_PCH_GBE is not set
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
# CONFIG_QLA3XXX is not set
# CONFIG_QLCNIC is not set
# CONFIG_QLGE is not set
# CONFIG_NETXEN_NIC is not set
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_8139CP=y
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
# CONFIG_8139TOO_8129 is not set
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
# CONFIG_SH_ETH is not set
CONFIG_NET_VENDOR_RDC=y
# CONFIG_R6040 is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_NET_VENDOR_SILAN=y
# CONFIG_SC92031 is not set
CONFIG_NET_VENDOR_SIS=y
CONFIG_SIS900=y
# CONFIG_SIS190 is not set
# CONFIG_SFC is not set
CONFIG_NET_VENDOR_SMSC=y
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_EPIC100 is not set
# CONFIG_SMSC911X is not set
# CONFIG_SMSC9420 is not set
CONFIG_NET_VENDOR_STMICRO=y
# CONFIG_STMMAC_ETH is not set
CONFIG_NET_VENDOR_SUN=y
# CONFIG_HAPPYMEAL is not set
# CONFIG_SUNGEM is not set
# CONFIG_CASSINI is not set
# CONFIG_NIU is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TLAN is not set
CONFIG_NET_VENDOR_VIA=y
CONFIG_VIA_RHINE=y
# CONFIG_VIA_RHINE_MMIO is not set
CONFIG_VIA_VELOCITY=y
CONFIG_NET_VENDOR_WIZNET=y
# CONFIG_WIZNET_W5100 is not set
# CONFIG_WIZNET_W5300 is not set
CONFIG_NET_VENDOR_XIRCOM=y
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AT803X_PHY is not set
# CONFIG_AMD_PHY is not set
# CONFIG_MARVELL_PHY is not set
# CONFIG_DAVICOM_PHY is not set
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=y
# CONFIG_BCM87XX_PHY is not set
# CONFIG_ICPLUS_PHY is not set
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
# CONFIG_STE10XP is not set
# CONFIG_LSI_ET1011C_PHY is not set
# CONFIG_MICREL_PHY is not set
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
# CONFIG_USB_RTL8152 is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=y
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SR9700 is not set
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_HOSTAP is not set
# CONFIG_WL_TI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_ELANTECH is not set
# CONFIG_MOUSE_PS2_SENTELIC is not set
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_CYAPA is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_MMA8450 is not set
# CONFIG_INPUT_MPU3050 is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_UINPUT is not set
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_SERIO_ARC_PS2 is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
# CONFIG_CYCLADES is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_SYNCLINK is not set
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
# CONFIG_NOZOMI is not set
# CONFIG_ISI is not set
# CONFIG_N_HDLC is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_ST_ASC is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_IPWIRELESS is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_ISMT is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
# CONFIG_PPS_CLIENT_LDISC is not set
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
# CONFIG_PTP_1588_CLOCK_PCH is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_RESET is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_HTU21 is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IBMAEM is not set
# CONFIG_SENSORS_IBMPEX is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95234 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_MAX16065 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6642 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_MAX6697 is not set
# CONFIG_SENSORS_MCP3021 is not set
# CONFIG_SENSORS_NCT6775 is not set
# CONFIG_SENSORS_NTC_THERMISTOR is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH56XX_COMMON is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_SCH5636 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
# CONFIG_THERMAL_GOV_FAIR_SHARE is not set
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CPU_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set
# CONFIG_INTEL_POWERCLAMP is not set
CONFIG_X86_PKG_TEMP_THERMAL=m

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=y
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
# CONFIG_IT8712F_WDT is not set
# CONFIG_IT87_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC_SCH311X_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_VIA_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83697UG_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_CROS_EC is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
CONFIG_LPC_ICH=y
# CONFIG_LPC_SCH is not set
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_VIPERBOARD is not set
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_STMPE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TPS65217 is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
# CONFIG_MFD_VX855 is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set
# CONFIG_FB is not set
# CONFIG_EXYNOS_VIDEO is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
# CONFIG_HIDRAW is not set
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=y
# CONFIG_HID_APPLEIR is not set
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELECOM is not set
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_HOLTEK is not set
# CONFIG_HID_HUION is not set
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LENOVO_TPKBD is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
CONFIG_LOGIWHEELS_FF=y
# CONFIG_HID_MAGICMOUSE is not set
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
# CONFIG_PANTHERLORD_FF is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_PRIMAX is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_SAITEK is not set
CONFIG_HID_SAMSUNG=y
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_STEELSERIES is not set
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_SMARTJOYPLUS=y
# CONFIG_SMARTJOYPLUS_FF is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
# CONFIG_ZEROPLUS_FF is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
# CONFIG_USB_FUSBH200_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_CHIPIDEA is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_EZUSB_FX2 is not set
# CONFIG_USB_HSIC_USB3503 is not set

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_AM335X_PHY_USB is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_ISP1301 is not set
# CONFIG_USB_RCAR_PHY is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_GHES=y
CONFIG_EDAC_E752X=y
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
# CONFIG_EDAC_SBRIDGE is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF2127 is not set
# CONFIG_RTC_DRV_PCF8523 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set
# CONFIG_RTC_DRV_EM3027 is not set
# CONFIG_RTC_DRV_RV3029C2 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set
# CONFIG_RTC_DRV_DS2404 is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MOXART is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
# CONFIG_STAGING is not set
CONFIG_X86_PLATFORM_DEVICES=y
# CONFIG_ACERHDF is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_CHROMEOS_LAPTOP is not set
# CONFIG_FUJITSU_TABLET is not set
# CONFIG_HP_ACCEL is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
# CONFIG_ACPI_WMI is not set
# CONFIG_TOPSTAR_LAPTOP is not set
# CONFIG_TOSHIBA_BT_RFKILL is not set
# CONFIG_ACPI_CMPC is not set
# CONFIG_INTEL_IPS is not set
# CONFIG_IBM_RTL is not set
# CONFIG_XO15_EBOOK is not set
# CONFIG_SAMSUNG_Q10 is not set
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_PVPANIC is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# CONFIG_MAILBOX is not set
CONFIG_IOMMU_SUPPORT=y
# CONFIG_AMD_IOMMU is not set
# CONFIG_INTEL_IOMMU is not set
# CONFIG_IRQ_REMAP is not set

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
# CONFIG_NTB is not set
# CONFIG_VME_BUS is not set
# CONFIG_PWM is not set
# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=y
CONFIG_DCDBAS=y
CONFIG_DMIID=y
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
# CONFIG_EFI_VARS is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_WARN is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
# CONFIG_FANOTIFY is not set
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_LOGFS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
# CONFIG_PSTORE_CONSOLE is not set
# CONFIG_PSTORE_FTRACE is not set
# CONFIG_PSTORE_RAM is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
# CONFIG_EFIVAR_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V2=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
# CONFIG_NFS_V4_2 is not set
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
# CONFIG_NFSD_FAULT_INJECTION is not set
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_SUNRPC_DEBUG is not set
# CONFIG_CEPH_FS is not set
CONFIG_CIFS=y
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
# CONFIG_CIFS_UPCALL is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_ACL is not set
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
# CONFIG_CIFS_SMB2 is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
# CONFIG_NLS_MAC_ICELAND is not set
# CONFIG_NLS_MAC_INUIT is not set
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_DYNAMIC_DEBUG=y

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
# CONFIG_LOCKUP_DETECTOR is not set
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_ATOMIC_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_SPARSE_RCU_POINTER=y
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
# CONFIG_MMIOTRACE_TEST is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_STRING_HELPERS is not set
# CONFIG_TEST_KSTRTOX is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_STRICT_DEVMEM is not set
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_SET_MODULE_RONX=y
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_ENCRYPTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=y
CONFIG_CRYPTO_GLUE_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
CONFIG_CRYPTO_CRC32=y
CONFIG_CRYPTO_CRC32_PCLMUL=y
CONFIG_CRYPTO_CRCT10DIF=y
# CONFIG_CRYPTO_CRCT10DIF_PCLMUL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
# CONFIG_CRYPTO_SHA256_SSSE3 is not set
# CONFIG_CRYPTO_SHA512_SSSE3 is not set
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
CONFIG_CRYPTO_BLOWFISH_X86_64=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAMELLIA_X86_64=y
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=y
# CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
CONFIG_CRYPTO_CAST_COMMON=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST5_AVX_X86_64=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_CAST6_AVX_X86_64=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_X86_64=y
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=y
CONFIG_CRYPTO_SERPENT_AVX_X86_64=y
# CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_X86_64=y
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=y
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
CONFIG_PUBLIC_KEY_ALGO_RSA=y
# CONFIG_X509_CERTIFICATE_PARSER is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
# CONFIG_KVM_AMD is not set
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_CMPXCHG_LOCKREF=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
# CONFIG_CRC8 is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
# CONFIG_AVERAGE is not set
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
# CONFIG_DDR is not set
CONFIG_MPILIB=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y

--vGgW1X5XWziG23Ko--
