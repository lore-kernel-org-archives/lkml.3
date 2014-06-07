Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaFGGxT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 02:53:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:64282 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbaFGGxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 02:53:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,993,1392192000"; 
   d="scan'208";a="524445267"
Message-ID: <5392B6DC.6040502@intel.com>
Date: Sat, 07 Jun 2014 14:53:16 +0800
From: Jet Chen <jet.chen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Eivind Sarto <eivindsarto@gmail.com>
CC: NeilBrown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: [raid5] cf170f3fa45: +4.8% vmstat.io.bo
Content-Type: multipart/mixed;
 boundary="------------030901080405080605080103"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030901080405080605080103
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Eivind,

FYI, we noticed the below changes on

git://neil.brown.name/md for-next
commit cf170f3fa451350e431314e1a0a52014fda4b2d6 ("raid5: avoid release list until last reference of the stripe")

test case: lkp-st02/dd-write/11HDD-RAID5-cfq-xfs-10dd

8b32bf5e37328c0  cf170f3fa451350e431314e1a
---------------  -------------------------
    486996 ~ 0%      +4.8%     510428 ~ 0%  TOTAL vmstat.io.bo
     17643 ~ 1%     -17.3%      14599 ~ 0%  TOTAL vmstat.system.in
     11633 ~ 4%     -56.7%       5039 ~ 0%  TOTAL vmstat.system.cs
       109 ~ 1%      +6.5%        116 ~ 1%  TOTAL iostat.sdb.rrqm/s
       109 ~ 2%      +5.1%        114 ~ 1%  TOTAL iostat.sdc.rrqm/s
       110 ~ 2%      +5.5%        117 ~ 0%  TOTAL iostat.sdj.rrqm/s
     12077 ~ 0%      +4.8%      12660 ~ 0%  TOTAL iostat.sde.wrqm/s
     48775 ~ 0%      +4.8%      51125 ~ 0%  TOTAL iostat.sde.wkB/s
     12077 ~ 0%      +4.8%      12659 ~ 0%  TOTAL iostat.sdb.wrqm/s
     12076 ~ 0%      +4.8%      12659 ~ 0%  TOTAL iostat.sdd.wrqm/s
     12077 ~ 0%      +4.8%      12660 ~ 0%  TOTAL iostat.sdf.wrqm/s
     48775 ~ 0%      +4.8%      51121 ~ 0%  TOTAL iostat.sdb.wkB/s
     12078 ~ 0%      +4.8%      12659 ~ 0%  TOTAL iostat.sdj.wrqm/s
     12078 ~ 0%      +4.8%      12660 ~ 0%  TOTAL iostat.sdi.wrqm/s
     12076 ~ 0%      +4.8%      12658 ~ 0%  TOTAL iostat.sdg.wrqm/s
     48774 ~ 0%      +4.8%      51122 ~ 0%  TOTAL iostat.sdd.wkB/s
     48776 ~ 0%      +4.8%      51128 ~ 0%  TOTAL iostat.sdf.wkB/s
     48780 ~ 0%      +4.8%      51121 ~ 0%  TOTAL iostat.sdj.wkB/s
     48779 ~ 0%      +4.8%      51128 ~ 0%  TOTAL iostat.sdi.wkB/s
     48773 ~ 0%      +4.8%      51119 ~ 0%  TOTAL iostat.sdg.wkB/s
    486971 ~ 0%      +4.8%     510409 ~ 0%  TOTAL iostat.md0.wkB/s
     12076 ~ 0%      +4.8%      12657 ~ 0%  TOTAL iostat.sdc.wrqm/s
     12077 ~ 0%      +4.8%      12659 ~ 0%  TOTAL iostat.sdh.wrqm/s
      1910 ~ 0%      +4.8%       2001 ~ 0%  TOTAL iostat.md0.w/s
       110 ~ 2%      +6.5%        117 ~ 1%  TOTAL iostat.sdk.rrqm/s
     12077 ~ 0%      +4.8%      12659 ~ 0%  TOTAL iostat.sdk.wrqm/s
     48772 ~ 0%      +4.8%      51115 ~ 0%  TOTAL iostat.sdc.wkB/s
     48776 ~ 0%      +4.8%      51121 ~ 0%  TOTAL iostat.sdh.wkB/s
     48777 ~ 0%      +4.8%      51121 ~ 0%  TOTAL iostat.sdk.wkB/s
       109 ~ 2%      +3.3%        113 ~ 1%  TOTAL iostat.sde.rrqm/s
  4.28e+09 ~ 0%      -4.1%  4.104e+09 ~ 0%  TOTAL perf-stat.cache-misses
 8.654e+10 ~ 0%      +4.7%  9.058e+10 ~ 0%  TOTAL perf-stat.L1-dcache-store-misses
 3.549e+09 ~ 1%      +3.7%  3.682e+09 ~ 0%  TOTAL perf-stat.L1-dcache-prefetches
 6.764e+11 ~ 0%      +3.7%  7.011e+11 ~ 0%  TOTAL perf-stat.dTLB-stores
 6.759e+11 ~ 0%      +3.7%  7.011e+11 ~ 0%  TOTAL perf-stat.L1-dcache-stores
 4.731e+10 ~ 0%      +3.6%  4.903e+10 ~ 0%  TOTAL perf-stat.L1-dcache-load-misses
 3.017e+12 ~ 0%      +3.5%  3.121e+12 ~ 0%  TOTAL perf-stat.instructions
 1.118e+12 ~ 0%      +3.3%  1.156e+12 ~ 0%  TOTAL perf-stat.dTLB-loads
 1.117e+12 ~ 0%      +3.2%  1.152e+12 ~ 0%  TOTAL perf-stat.L1-dcache-loads
 3.022e+12 ~ 0%      +3.2%  3.119e+12 ~ 0%  TOTAL perf-stat.iTLB-loads
 5.613e+11 ~ 0%      +3.2%  5.794e+11 ~ 0%  TOTAL perf-stat.branch-instructions
  5.62e+11 ~ 0%      +3.1%  5.793e+11 ~ 0%  TOTAL perf-stat.branch-loads
 1.343e+09 ~ 0%      +2.6%  1.378e+09 ~ 0%  TOTAL perf-stat.LLC-store-misses
 2.073e+10 ~ 0%      +2.9%  2.133e+10 ~ 1%  TOTAL perf-stat.LLC-loads
 4.854e+10 ~ 0%      +1.6%  4.931e+10 ~ 0%  TOTAL perf-stat.cache-references
 1.167e+10 ~ 0%      +1.4%  1.183e+10 ~ 0%  TOTAL perf-stat.L1-icache-load-misses
   7068624 ~ 4%     -56.4%    3078966 ~ 0%  TOTAL perf-stat.context-switches
 2.214e+09 ~ 1%      -7.8%  2.041e+09 ~ 1%  TOTAL perf-stat.LLC-load-misses
    131433 ~ 0%     -18.9%     106597 ~ 1%  TOTAL perf-stat.cpu-migrations


Legend:
	~XX%    - stddev percent
	[+-]XX% - change percent

Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Jet


--------------030901080405080605080103
Content-Type: text/plain; charset=UTF-8;
 name="reproduce"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="reproduce"

mdadm -q --create /dev/md0 --chunk=256 --level=raid5 --raid-devices=11 --force --assume-clean /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1
echo 1 > /sys/kernel/debug/tracing/events/writeback/balance_dirty_pages/enable
echo 1 > /sys/kernel/debug/tracing/events/writeback/bdi_dirty_ratelimit/enable
echo 1 > /sys/kernel/debug/tracing/events/writeback/global_dirty_state/enable
echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_single_inode/enable
mkfs -t xfs /dev/md0
mount -t xfs -o nobarrier,inode64 /dev/md0 /fs/md0
dd  if=/dev/zero of=/fs/md0/zero-1 status=none &
dd  if=/dev/zero of=/fs/md0/zero-2 status=none &
dd  if=/dev/zero of=/fs/md0/zero-3 status=none &
dd  if=/dev/zero of=/fs/md0/zero-4 status=none &
dd  if=/dev/zero of=/fs/md0/zero-5 status=none &
dd  if=/dev/zero of=/fs/md0/zero-6 status=none &
dd  if=/dev/zero of=/fs/md0/zero-7 status=none &
dd  if=/dev/zero of=/fs/md0/zero-8 status=none &
dd  if=/dev/zero of=/fs/md0/zero-9 status=none &
dd  if=/dev/zero of=/fs/md0/zero-10 status=none &
sleep 600
killall -9 dd


--------------030901080405080605080103--
