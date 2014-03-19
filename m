Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbaCSCV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 22:21:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:32521 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758094AbaCSCVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 22:21:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,682,1389772800"; 
   d="scan'208";a="494778727"
Date: Wed, 19 Mar 2014 10:21:21 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [map_pages] 66431c4de99: -55.4% proc-vmstat.pgfault
Message-ID: <20140319022121.GA14115@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,

FYI, we noticed decreased page faults and increased mapped pages on

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit 66431c4de9921a9b3c7f3556bada4285912aedb7 ("mm: implement ->map_pages for page cache")

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
    591248 ~ 0%     -56.1%     259664 ~ 0%  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
   5090162 ~ 0%     -55.4%    2272005 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
   5681411 ~ 0%     -55.4%    2531670 ~ 0%  TOTAL proc-vmstat.pgfault

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
      1413 ~ 0%     +95.2%       2759 ~ 1%  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
      1458 ~ 0%     +94.4%       2835 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      2872 ~ 0%     +94.8%       5594 ~ 1%  TOTAL time.maximum_resident_set_size

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
      4332 ~ 0%     +48.9%       6449 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      4332 ~ 0%     +48.9%       6449 ~ 0%  TOTAL numa-meminfo.node1.Mapped

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
      1082 ~ 0%     +48.9%       1612 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      1082 ~ 0%     +48.9%       1612 ~ 0%  TOTAL numa-vmstat.node1.nr_mapped

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
      4349 ~ 0%     +48.6%       6465 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      4349 ~ 0%     +48.6%       6465 ~ 0%  TOTAL numa-meminfo.node0.Mapped

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
      1087 ~ 0%     +48.7%       1616 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      1087 ~ 0%     +48.7%       1616 ~ 0%  TOTAL numa-vmstat.node0.nr_mapped

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
      7426 ~ 0%     +45.1%      10773 ~ 0%  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
      8682 ~ 0%     +48.7%      12911 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     16108 ~ 0%     +47.0%      23684 ~ 0%  TOTAL meminfo.Mapped

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
      1852 ~ 0%     +45.4%       2693 ~ 0%  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
      2170 ~ 0%     +48.7%       3227 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      4022 ~ 0%     +47.2%       5921 ~ 0%  TOTAL proc-vmstat.nr_mapped

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
      0.93 ~ 4%     +24.2%       1.15 ~ 5%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      0.93 ~ 4%     +24.2%       1.15 ~ 5%  TOTAL perf-profile.cpu-cycles.vfs_write.sys_write.system_call_fastpath.write

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
      1968 ~ 0%     +17.5%       2313 ~ 1%  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
      1968 ~ 0%     +17.5%       2313 ~ 1%  TOTAL proc-vmstat.pgactivate

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
      3.34 ~ 1%     -10.7%       2.98 ~ 2%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
      3.34 ~ 1%     -10.7%       2.98 ~ 2%  TOTAL perf-profile.cpu-cycles.ext4_mark_iloc_dirty.ext4_mark_inode_dirty.ext4_dirty_inode.__mark_inode_dirty.generic_write_end

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
      3258 ~ 0%     -59.1%       1331 ~ 0%  lkp-t410/micro/netperf/120s-200%-TCP_MAERTS
    162827 ~ 0%     -59.3%      66299 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
    166085 ~ 0%     -59.3%      67630 ~ 0%  TOTAL time.minor_page_faults

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
   5093318 ~ 0%     -55.7%    2257903 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
   5093318 ~ 0%     -55.7%    2257903 ~ 0%  TOTAL perf-stat.minor-faults

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
   5092110 ~ 0%     -55.7%    2257193 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
   5092110 ~ 0%     -55.7%    2257193 ~ 0%  TOTAL perf-stat.page-faults

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
 3.698e+11 ~ 0%     -11.3%   3.28e+11 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 3.698e+11 ~ 0%     -11.3%   3.28e+11 ~ 0%  TOTAL perf-stat.L1-icache-load-misses

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
     45.26 ~ 3%      +8.4%      49.05 ~ 3%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
     45.26 ~ 3%      +8.4%      49.05 ~ 3%  TOTAL iostat.sdd.wrqm/s

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
 1.824e+10 ~ 0%      -5.3%  1.727e+10 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 1.824e+10 ~ 0%      -5.3%  1.727e+10 ~ 0%  TOTAL perf-stat.branch-misses

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
 2.802e+12 ~ 0%      -4.7%   2.67e+12 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 2.802e+12 ~ 0%      -4.7%   2.67e+12 ~ 0%  TOTAL perf-stat.L1-icache-loads

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
 7.246e+08 ~ 2%      -4.5%  6.922e+08 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 7.246e+08 ~ 2%      -4.5%  6.922e+08 ~ 1%  TOTAL perf-stat.iTLB-load-misses

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
 3.314e+09 ~ 1%      -4.8%  3.154e+09 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 3.314e+09 ~ 1%      -4.8%  3.154e+09 ~ 1%  TOTAL perf-stat.LLC-load-misses

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
 3.324e+09 ~ 1%      -4.4%  3.179e+09 ~ 0%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 3.324e+09 ~ 1%      -4.4%  3.179e+09 ~ 0%  TOTAL perf-stat.node-loads

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
 3.554e+08 ~ 3%      +5.7%  3.755e+08 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 3.554e+08 ~ 3%      +5.7%  3.755e+08 ~ 1%  TOTAL perf-stat.node-store-misses

c9161c06019b342  66431c4de9921a9b3c7f3556b  
---------------  -------------------------  
 8.409e+12 ~ 0%      -2.5%  8.196e+12 ~ 1%  lkp-ws02/micro/dd-write/11HDD-JBOD-cfq-ext4-10dd
 8.409e+12 ~ 0%      -2.5%  8.196e+12 ~ 1%  TOTAL perf-stat.cpu-cycles

Legend:
	~XX%    - stddev percent
	[+-]XX% - change percent


                                time.minor_page_faults

   170000 ++----------------------------------------------------------------+
   160000 *+*.*..*.*.*.*.*..*.*.*.*.*..*.*.*.*.*..*.*.*.*.*..*.*.*.*.*..*.*.*
          |                                                                 |
   150000 ++                                                                |
   140000 ++                                                                |
   130000 ++                                                                |
   120000 ++                                                                |
          |                                                                 |
   110000 ++                                                                |
   100000 ++                                                                |
    90000 ++                                                                |
    80000 ++                                                                |
          |                                                                 |
    70000 O+O O  O O O O O  O O O O O  O O O O O  O O O O O  O              |
    60000 ++----------------------------------------------------------------+


                                 perf-stat.page-faults

   5.5e+06 ++---------------------------------------------------------------+
           |                                                                |
     5e+06 *+*.*..*.*.*.*.*.*..*.*.*.*.*.*..*.*.*.*.*.*..*.*.*.*.*.*..*.*.*.*
           |                                                                |
   4.5e+06 ++                                                               |
           |                                                                |
     4e+06 ++                                                               |
           |                                                                |
   3.5e+06 ++                                                               |
           |                                                                |
     3e+06 ++                                                               |
           |                                                                |
   2.5e+06 ++                                                               |
           O O O  O O O O O O  O O O O O O  O O O O O O  O O O              |
     2e+06 ++---------------------------------------------------------------+


                                perf-stat.minor-faults

   5.5e+06 ++---------------------------------------------------------------+
           |                                                                |
     5e+06 *+*.*..*.*.*.*.*.*..*.*.*.*.*.*..*.*.*.*.*.*..*.*.*.*.*.*..*.*.*.*
           |                                                                |
   4.5e+06 ++                                                               |
           |                                                                |
     4e+06 ++                                                               |
           |                                                                |
   3.5e+06 ++                                                               |
           |                                                                |
     3e+06 ++                                                               |
           |                                                                |
   2.5e+06 ++                                                               |
           O O O  O O O O O O  O O O O O O  O O O O O O  O O O              |
     2e+06 ++---------------------------------------------------------------+


	[*] bisect-good sample
	[O] bisect-bad  sample

Thanks,
Fengguang
