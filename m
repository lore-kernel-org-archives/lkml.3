Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaA2I0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:26:34 -0500
Received: from mga03.intel.com ([143.182.124.21]:16248 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964AbaA2I0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 03:26:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,741,1384329600"; 
   d="scan'208";a="466467552"
Date: Wed, 29 Jan 2014 16:26:27 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: Re: [slub shrink] 0f6934bf16: +191.9% vmstat.system.cs
Message-ID: <20140129082627.GA20695@localhost>
References: <20140116030744.GA19349@localhost>
 <52D82F13.9070309@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D82F13.9070309@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

I got more complete results for

        https://github.com/hansendc/linux.git slub-reshrink-for-Fengguang-20140113,

It looks mostly good.  There are regressions in

- netperf.Throughput_Mbps
- dbench.throughput-MB/sec
- xfstests.generic.256.seconds

However the others are all improvements. 


9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
      5766 ~42%     -79.3%       1196 ~ 8%  TOTAL fileio.request_latency_max_ms
        11 ~44%     -73.5%          3 ~27%  TOTAL xfstests.generic.275.seconds
       132 ~37%     -56.8%         57 ~10%  TOTAL xfstests.xfs.229.seconds
        13 ~47%     -60.0%          5 ~ 8%  TOTAL xfstests.xfs.206.seconds
    513.33 ~ 9%      +8.2%     555.35 ~ 0%  TOTAL pigz.throughput
        44 ~ 9%     +29.3%         57 ~16%  TOTAL xfstests.generic.256.seconds
     32321 ~ 7%     +14.4%      36987 ~ 9%  TOTAL fileio.requests_per_sec
     15.26 ~ 3%     +19.7%      18.26 ~ 4%  TOTAL oltp.request_latency_max_ms
     64742 ~ 6%     -10.1%      58179 ~ 4%  TOTAL netperf.Throughput_Mbps
        98 ~ 0%      +2.7%        101 ~ 0%  TOTAL ebizzy.throughput.per_thread.max
    167137 ~ 4%      +5.7%     176639 ~ 1%  TOTAL netperf.Throughput_tps
   2276278 ~ 1%      +0.2%    2279724 ~ 1%  TOTAL aim7.2000.jobs-per-min
     11213 ~ 0%      +2.1%      11454 ~ 0%  TOTAL ebizzy.throughput
    908470 ~ 0%      +0.3%     911314 ~ 0%  TOTAL hackbench.throughput
      8228 ~ 0%      -1.1%       8142 ~ 0%  TOTAL dbench.throughput-MB/sec
    161604 ~ 5%     +11.0%     179405 ~ 4%  TOTAL iostat.md0.wkB/s

Per test case numbers:

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
      5766 ~42%     -79.3%       1196 ~ 8%  kbuildx/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndrw-sync
      5766 ~42%     -79.3%       1196 ~ 8%  TOTAL fileio.request_latency_max_ms

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
        11 ~44%     -73.5%          3 ~27%  vpx/micro/xfstests/4HDD-btrfs-generic-mid
        11 ~44%     -73.5%          3 ~27%  TOTAL xfstests.generic.275.seconds

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
       132 ~37%     -56.8%         57 ~10%  vpx/micro/xfstests/4HDD-xfs-xfs
       132 ~37%     -56.8%         57 ~10%  TOTAL xfstests.xfs.229.seconds

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
        13 ~47%     -60.0%          5 ~ 8%  vpx/micro/xfstests/4HDD-xfs-xfs
        13 ~47%     -60.0%          5 ~ 8%  TOTAL xfstests.xfs.206.seconds

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
    464.80 ~ 7%      +5.6%     490.73 ~ 0%  grantley/micro/pigz/100%
     48.53 ~24%     +33.1%      64.62 ~ 6%  kbuildx/micro/pigz/100%
    513.33 ~ 9%      +8.2%     555.35 ~ 0%  TOTAL pigz.throughput

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
        18 ~10%     +41.8%         26 ~28%  vpx/micro/xfstests/4HDD-ext4-generic-mid
        26 ~ 9%     +20.5%         31 ~ 5%  vpx/micro/xfstests/4HDD-xfs-generic-mid
        44 ~ 9%     +29.3%         57 ~16%  TOTAL xfstests.generic.256.seconds

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
       156 ~ 0%      -1.7%        153 ~ 0%  kbuildx/sysbench/fileio/600s-100%-1HDD-btrfs-64G-1024-rndrw-sync
     10766 ~ 5%      +8.5%      11677 ~ 6%  kbuildx/sysbench/fileio/600s-100%-1HDD-btrfs-64G-1024-seqrewr-sync
     10368 ~15%     +30.8%      13560 ~13%  kbuildx/sysbench/fileio/600s-100%-1HDD-btrfs-64G-1024-seqwr-sync
       124 ~ 3%     +36.2%        169 ~11%  kbuildx/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndrd-sync
       943 ~ 2%     +84.0%       1736 ~40%  kbuildx/sysbench/fileio/600s-100%-1HDD-ext4-64G-1024-rndwr-sync
      9962 ~ 0%      -2.7%       9689 ~ 1%  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrd-sync
     32321 ~ 7%     +14.4%      36987 ~ 9%  TOTAL fileio.requests_per_sec

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
     15.26 ~ 3%     +19.7%      18.26 ~ 4%  nhm-white/sysbench/oltp/600s-100%-1000000
     15.26 ~ 3%     +19.7%      18.26 ~ 4%  TOTAL oltp.request_latency_max_ms

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
      7715 ~ 9%     -22.2%       6002 ~16%  kbuildx/micro/netperf/120s-200%-TCP_MAERTS
     17374 ~11%     -16.0%      14591 ~ 6%  kbuildx/micro/netperf/120s-200%-TCP_SENDFILE
      1650 ~ 0%      -0.7%       1639 ~ 0%  lkp-a04/micro/netperf/120s-200%-TCP_SENDFILE
       559 ~ 0%      -1.3%        552 ~ 0%  lkp-a04/micro/netperf/120s-200%-TCP_STREAM
      1803 ~18%     -45.9%        975 ~ 4%  lkp-nex04/micro/netperf/120s-200%-TCP_MAERTS
      5789 ~ 1%      -4.1%       5551 ~ 0%  lkp-nex04/micro/netperf/120s-200%-TCP_SENDFILE
      3779 ~ 4%     -16.2%       3168 ~ 2%  lkp-sb03/micro/netperf/120s-200%-TCP_MAERTS
      9067 ~ 1%      +2.6%       9299 ~ 0%  lkp-sb03/micro/netperf/120s-200%-TCP_SENDFILE
      3815 ~14%     -29.2%       2699 ~ 6%  lkp-sbx04/micro/netperf/120s-200%-TCP_MAERTS
      7911 ~ 1%      +7.5%       8507 ~ 0%  lkp-sbx04/micro/netperf/120s-200%-TCP_SENDFILE
      3215 ~ 0%      -2.1%       3149 ~ 1%  lkp-t410/micro/netperf/120s-200%-TCP_SENDFILE
      2061 ~ 0%      -0.8%       2044 ~ 0%  lkp-t410/micro/netperf/120s-200%-TCP_STREAM
     64742 ~ 6%     -10.1%      58179 ~ 4%  TOTAL netperf.Throughput_Mbps

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
        98 ~ 0%      +2.7%        101 ~ 0%  lkp-nex04/micro/ebizzy/200%-100-10
        98 ~ 0%      +2.7%        101 ~ 0%  TOTAL ebizzy.throughput.per_thread.max

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
     26638 ~27%     +27.2%      33873 ~ 7%  kbuildx/micro/netperf/120s-200%-TCP_RR
       945 ~ 0%      -0.8%        937 ~ 0%  lkp-a04/micro/netperf/120s-200%-TCP_CRR
      5622 ~ 0%      +1.8%       5723 ~ 0%  lkp-a04/micro/netperf/120s-200%-TCP_RR
      6984 ~ 0%      -1.4%       6887 ~ 0%  lkp-a04/micro/netperf/120s-200%-UDP_RR
     20449 ~ 0%      -3.4%      19746 ~ 0%  lkp-nex04/micro/netperf/120s-200%-TCP_RR
     10584 ~ 1%      +3.9%      10998 ~ 1%  lkp-nex04/micro/netperf/120s-200%-UDP_RR
      5161 ~ 0%      +1.0%       5212 ~ 0%  lkp-sb03/micro/netperf/120s-200%-TCP_CRR
     30302 ~ 0%      +5.0%      31831 ~ 0%  lkp-sb03/micro/netperf/120s-200%-TCP_RR
      4425 ~ 0%      +0.8%       4462 ~ 0%  lkp-sbx04/micro/netperf/120s-200%-TCP_CRR
     28254 ~ 0%      +4.9%      29631 ~ 0%  lkp-sbx04/micro/netperf/120s-200%-TCP_RR
      2060 ~ 0%      -0.8%       2044 ~ 0%  lkp-t410/micro/netperf/120s-200%-TCP_CRR
     11493 ~ 0%      -2.7%      11181 ~ 0%  lkp-t410/micro/netperf/120s-200%-TCP_RR
     14217 ~ 0%      -0.8%      14110 ~ 0%  lkp-t410/micro/netperf/120s-200%-UDP_RR
    167137 ~ 4%      +5.7%     176639 ~ 1%  TOTAL netperf.Throughput_tps

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
    116376 ~ 0%      +2.4%     119126 ~ 0%  lkp-ne04/micro/aim7/brk_test
     22916 ~ 0%      -0.9%      22700 ~ 0%  lkp-ne04/micro/aim7/fork_test
    615267 ~ 3%      +3.2%     634727 ~ 3%  lkp-ne04/micro/aim7/misc_rtns_1
    293454 ~ 0%      -0.6%     291796 ~ 0%  lkp-snb01/micro/aim7/dbase
    309821 ~ 0%      -0.4%     308453 ~ 0%  lkp-snb01/micro/aim7/shared
     69669 ~ 0%      +1.5%      70711 ~ 0%  nhm-white/micro/aim7/brk_test
    120211 ~ 2%      -8.7%     109778 ~ 4%  nhm-white/micro/aim7/creat-clo
     77083 ~ 0%      +0.8%      77709 ~ 0%  nhm-white/micro/aim7/exec_test
    371798 ~ 0%      -2.9%     360987 ~ 1%  nhm-white/micro/aim7/link_test
     90481 ~ 0%      +0.4%      90805 ~ 0%  nhm-white/micro/aim7/shell_rtns_1
    189196 ~ 0%      +2.0%     192926 ~ 0%  nhm-white/micro/aim7/signal_test
   2276278 ~ 1%      +0.2%    2279724 ~ 1%  TOTAL aim7.2000.jobs-per-min

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
     11213 ~ 0%      +2.1%      11454 ~ 0%  lkp-nex04/micro/ebizzy/200%-100-10
     11213 ~ 0%      +2.1%      11454 ~ 0%  TOTAL ebizzy.throughput

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
    172715 ~ 0%      +0.9%     174317 ~ 0%  lkp-snb01/micro/hackbench/0-___nr_node-1__-0-___nr_cpu-1__-1600%-threads-pipe
    157456 ~ 0%      -1.3%     155387 ~ 0%  lkp-snb01/micro/hackbench/1600%-process-socket
    172416 ~ 0%      +1.5%     175030 ~ 0%  lkp-snb01/micro/hackbench/1600%-threads-pipe
    161696 ~ 0%      -0.2%     161303 ~ 0%  lkp-snb01/micro/hackbench/1600%-threads-socket
     83983 ~ 0%      +1.8%      85523 ~ 1%  xps2/micro/hackbench/1600%-process-pipe
     41791 ~ 0%      -0.7%      41520 ~ 0%  xps2/micro/hackbench/1600%-process-socket
     77821 ~ 0%      +1.1%      78657 ~ 0%  xps2/micro/hackbench/1600%-threads-pipe
     40588 ~ 0%      -2.5%      39575 ~ 0%  xps2/micro/hackbench/1600%-threads-socket
    908470 ~ 0%      +0.3%     911314 ~ 0%  TOTAL hackbench.throughput

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
      8228 ~ 0%      -1.1%       8142 ~ 0%  nhm8/micro/dbench/100%
      8228 ~ 0%      -1.1%       8142 ~ 0%  TOTAL dbench.throughput-MB/sec

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
    161604 ~ 5%     +11.0%     179405 ~ 4%  kbuildx/micro/dd-write/4HDD-RAID0-cfq-ext4-1dd
    161604 ~ 5%     +11.0%     179405 ~ 4%  TOTAL iostat.md0.wkB/s

Thanks,
Fengguang
