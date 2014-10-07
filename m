Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbaJGXgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:36:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602AbaJGXTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:19:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 00/37] 3.14.21-stable review
Date: Tue,  7 Oct 2014 16:19:17 -0700
Message-Id: <20141007231827.043235686@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.21 release.
There are 37 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Oct  9 23:18:16 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.21-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.21-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    mm: don't pointlessly use BUG_ON() for sanity check

Davidlohr Bueso <davidlohr@hp.com>
    mm: per-thread vma caching

Christoph Lameter <cl@linux.com>
    vmscan: reclaim_clean_pages_from_list() must use mod_zone_page_state()

Vladimir Davydov <vdavydov@parallels.com>
    mm: vmscan: shrink_slab: rename max_pass -> freeable

Vladimir Davydov <vdavydov@parallels.com>
    mm: vmscan: respect NUMA policy mask when shrinking slab on direct reclaim

Jens Axboe <axboe@fb.com>
    mm/filemap.c: avoid always dirtying mapping->flags on O_DIRECT

Mel Gorman <mgorman@suse.de>
    mm: optimize put_mems_allowed() usage

Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
    mm/readahead.c: fix readahead failure for memoryless NUMA nodes and limit readahead pages

David Rientjes <rientjes@google.com>
    mm, compaction: ignore pageblock skip when manually invoking compaction

David Rientjes <rientjes@google.com>
    mm, compaction: determine isolation mode only once

Joonsoo Kim <iamjoonsoo.kim@lge.com>
    mm/compaction: clean-up code on success of ballon isolation

Joonsoo Kim <iamjoonsoo.kim@lge.com>
    mm/compaction: check pageblock suitability once per pageblock

Joonsoo Kim <iamjoonsoo.kim@lge.com>
    mm/compaction: change the timing to check to drop the spinlock

Lars Ellenberg <lars.ellenberg@linbit.com>
    drbd: fix regression 'out of mem, failed to invoke fence-peer helper'

Joonsoo Kim <iamjoonsoo.kim@lge.com>
    mm/compaction: do not call suitable_migration_target() on every page

Joonsoo Kim <iamjoonsoo.kim@lge.com>
    mm/compaction: disallow high-order page for migration target

David Rientjes <rientjes@google.com>
    mm, compaction: avoid isolating pinned pages

Dan Streetman <ddstreet@ieee.org>
    swap: change swap_list_head to plist, add swap_avail_head

Dan Streetman <ddstreet@ieee.org>
    lib/plist: add plist_requeue

Dan Streetman <ddstreet@ieee.org>
    lib/plist: add helper functions

Dan Streetman <ddstreet@ieee.org>
    swap: change swap_info singly-linked list to list_head

Michal Hocko <mhocko@suse.cz>
    mm: exclude memoryless nodes from zone_reclaim

Andrew Hunter <ahh@google.com>
    jiffies: Fix timeval conversion to jiffies

Hans Verkuil <hans.verkuil@cisco.com>
    media: vb2: fix VBI/poll regression

Mel Gorman <mgorman@suse.de>
    mm: numa: Do not mark PTEs pte_numa when splitting huge pages

Waiman Long <Waiman.Long@hp.com>
    mm, thp: move invariant bug check out of loop in __split_huge_page_map

Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
    hugetlb: ensure hugepage access is denied if hugepages are not supported

Pavel Shilovsky <pshilovsky@samba.org>
    CIFS: Fix SMB2 readdir error handling

Steven Rostedt (Red Hat) <rostedt@goodmis.org>
    ring-buffer: Fix infinite spin in reading buffer

Josh Triplett <josh@joshtriplett.org>
    init/Kconfig: Fix HAVE_FUTEX_CMPXCHG to not break up the EXPERT menu

Steve French <smfrench@gmail.com>
    Fix problem recognizing symlinks

Chris Wilson <chris@chris-wilson.co.uk>
    drm/i915: Flush the PTEs after updating them before suspend

NeilBrown <neilb@suse.de>
    md/raid5: disable 'DISCARD' by default due to safety concerns.

Arnd Bergmann <arnd@arndb.de>
    cpufreq: integrator: fix integrator_cpufreq_remove return type

Mel Gorman <mgorman@suse.de>
    mm: migrate: Close race between migration completion and mprotect

Peter Zijlstra <peterz@infradead.org>
    perf: fix perf bug in fork()

Jan Kara <jack@suse.cz>
    udf: Avoid infinite loop when processing indirect ICBs


-------------

Diffstat:

 Makefile                                 |   4 +-
 arch/unicore32/include/asm/mmu_context.h |   4 +-
 drivers/block/drbd/drbd_nl.c             |   6 +
 drivers/cpufreq/integrator-cpufreq.c     |   4 +-
 drivers/gpu/drm/i915/i915_gem_gtt.c      |  14 +-
 drivers/md/raid5.c                       |  18 ++-
 drivers/media/v4l2-core/videobuf2-core.c |  15 ++-
 fs/cifs/cifsglob.h                       |   2 +
 fs/cifs/file.c                           |   2 +-
 fs/cifs/readdir.c                        |   2 +-
 fs/cifs/smb1ops.c                        |   9 +-
 fs/cifs/smb2maperror.c                   |   4 +-
 fs/cifs/smb2ops.c                        |   9 ++
 fs/cifs/smb2pdu.c                        |   9 +-
 fs/exec.c                                |   5 +-
 fs/hugetlbfs/inode.c                     |   5 +
 fs/proc/task_mmu.c                       |   3 +-
 fs/udf/inode.c                           |  35 +++--
 include/linux/cpuset.h                   |  27 ++--
 include/linux/hugetlb.h                  |  10 ++
 include/linux/jiffies.h                  |  12 --
 include/linux/mm_types.h                 |   4 +-
 include/linux/plist.h                    |  45 +++++++
 include/linux/sched.h                    |   7 +
 include/linux/swap.h                     |   8 +-
 include/linux/swapfile.h                 |   2 +-
 include/linux/vmacache.h                 |  38 ++++++
 include/media/videobuf2-core.h           |   4 +
 init/Kconfig                             |   1 +
 kernel/cpuset.c                          |   2 +-
 kernel/debug/debug_core.c                |  14 +-
 kernel/events/core.c                     |   4 +-
 kernel/fork.c                            |  12 +-
 kernel/time.c                            |  54 ++++----
 kernel/trace/ring_buffer.c               |   2 +-
 lib/plist.c                              |  52 +++++++
 mm/Makefile                              |   2 +-
 mm/compaction.c                          |  94 +++++++------
 mm/filemap.c                             |  10 +-
 mm/frontswap.c                           |  13 +-
 mm/huge_memory.c                         |  11 +-
 mm/hugetlb.c                             |  17 ++-
 mm/mempolicy.c                           |  12 +-
 mm/migrate.c                             |   5 +-
 mm/mmap.c                                |  55 ++++----
 mm/nommu.c                               |  24 ++--
 mm/page_alloc.c                          |  13 +-
 mm/readahead.c                           |   4 +-
 mm/slab.c                                |   4 +-
 mm/slub.c                                |  16 +--
 mm/swapfile.c                            | 224 ++++++++++++++++---------------
 mm/vmacache.c                            | 114 ++++++++++++++++
 mm/vmscan.c                              |  32 ++---
 53 files changed, 750 insertions(+), 348 deletions(-)


