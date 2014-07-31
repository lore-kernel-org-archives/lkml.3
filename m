Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbaGaFuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 01:50:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:13495 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaGaFuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 01:50:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,769,1400050800"; 
   d="scan'208";a="578044563"
Date: Thu, 31 Jul 2014 13:50:35 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [LKP] [mm] b72fd1470c9: -41.7%
 perf-profile.cpu-cycles.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc.pagecache_get_page
Message-ID: <20140731055035.GB19742@aaronlu.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
commit b72fd1470c9735f53485d089aa918dc327a86077 ("mm: rearrange zone fields into read-only, page alloc, statistics and page reclaim lines")

test case: lkp-st02/dd-write/5m-11HDD-JBOD-cfq-xfs-10dd

e28c951ff01a805  b72fd1470c9735f53485d089a  
---------------  -------------------------  
      1.06 ~ 6%     -41.7%       0.62 ~ 3%  TOTAL perf-profile.cpu-cycles.get_page_from_freelist.__alloc_pages_nodemask.alloc_pages_current.__page_cache_alloc.pagecache_get_page
      1.34 ~ 2%     -19.8%       1.07 ~ 2%  TOTAL perf-profile.cpu-cycles.__block_write_begin.xfs_vm_write_begin.generic_perform_write.xfs_file_buffered_aio_write.xfs_file_write_iter
      1.19 ~ 5%     -12.1%       1.05 ~ 4%  TOTAL perf-profile.cpu-cycles.copy_from_user_atomic_iovec.iov_iter_copy_from_user_atomic.generic_perform_write.xfs_file_buffered_aio_write.xfs_file_write_iter
      2.78 ~ 1%     -16.3%       2.32 ~ 4%  TOTAL perf-profile.cpu-cycles.__clear_user.read_zero.read_zero.vfs_read.sys_read
  2.96e+09 ~ 4%      -5.2%  2.806e+09 ~ 0%  TOTAL perf-stat.cache-misses
  3.86e+12 ~ 5%      -5.2%  3.658e+12 ~ 1%  TOTAL perf-stat.ref-cycles

Legend:
	~XX%    - stddev percent
	[+-]XX% - change percent



Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Aaron

--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

echo 1 > /sys/kernel/debug/tracing/events/writeback/balance_dirty_pages/enable
echo 1 > /sys/kernel/debug/tracing/events/writeback/bdi_dirty_ratelimit/enable
echo 1 > /sys/kernel/debug/tracing/events/writeback/global_dirty_state/enable
echo 1 > /sys/kernel/debug/tracing/events/writeback/writeback_single_inode/enable
mkfs -t xfs /dev/sdb1
mkfs -t xfs /dev/sdj1
mkfs -t xfs /dev/sdh1
mkfs -t xfs /dev/sde1
mkfs -t xfs /dev/sdc1
mkfs -t xfs /dev/sdk1
mkfs -t xfs /dev/sdd1
mkfs -t xfs /dev/sdf1
mkfs -t xfs /dev/sdg1
mkfs -t xfs /dev/sdi1
mkfs -t xfs /dev/sdl1
mount -t xfs -o nobarrier,inode64 /dev/sdb1 /fs/sdb1
mount -t xfs -o nobarrier,inode64 /dev/sdc1 /fs/sdc1
mount -t xfs -o nobarrier,inode64 /dev/sdd1 /fs/sdd1
mount -t xfs -o nobarrier,inode64 /dev/sde1 /fs/sde1
mount -t xfs -o nobarrier,inode64 /dev/sdf1 /fs/sdf1
mount -t xfs -o nobarrier,inode64 /dev/sdg1 /fs/sdg1
mount -t xfs -o nobarrier,inode64 /dev/sdh1 /fs/sdh1
mount -t xfs -o nobarrier,inode64 /dev/sdi1 /fs/sdi1
mount -t xfs -o nobarrier,inode64 /dev/sdj1 /fs/sdj1
mount -t xfs -o nobarrier,inode64 /dev/sdk1 /fs/sdk1
mount -t xfs -o nobarrier,inode64 /dev/sdl1 /fs/sdl1
dd  if=/dev/zero of=/fs/sdb1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdd1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-1 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdd1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-2 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdd1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-3 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdd1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-4 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdd1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-5 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdd1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-6 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdd1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-7 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdd1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-8 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdd1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-9 status=noxfer &
dd  if=/dev/zero of=/fs/sdb1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdc1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdd1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sde1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdf1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdg1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdh1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdi1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdj1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdk1/zero-10 status=noxfer &
dd  if=/dev/zero of=/fs/sdl1/zero-10 status=noxfer &
sleep 298
killall -9 dd

--ftEhullJWpWg/VHq--
