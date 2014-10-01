Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaJAI5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 04:57:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbaJAI5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 04:57:42 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 00/96] 3.12.30-stable review
Date: Wed,  1 Oct 2014 10:57:39 +0200
Message-Id: <cover.1412147522.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.12.30 release.
There are 96 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

This one is special. First, it is rounded (30). Second, most of the
patches are performance improvements. They are coming from SUSE
Enterprise Linux and all are backed by proper testing and performance
measurements. All this patchset was prepared and sent by Mel Gorman
with a support of other patchers from SUSE. Thanks to all of them.

As this is special, I am gicing a whole week for responses. So
responses should be made by Wed Oct  8 09:12:02 CEST 2014.  Anything
received after that time might be too late.

The whole patch series can be found in one patch at:
	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.30-rc1.xz
and the diffstat can be found below.

thanks,
js

===============


Al Viro (1):
  callers of iov_copy_from_user_atomic() don't need pagecache_disable()

Bob Liu (2):
  mm: thp: cleanup: mv alloc_hugepage to better place
  mm: thp: khugepaged: add policy for finding target node

Christoph Lameter (1):
  vmscan: reclaim_clean_pages_from_list() must use mod_zone_page_state()

Damien Ramonda (1):
  readahead: fix sequential read cache miss detection

Dan Streetman (4):
  swap: change swap_info singly-linked list to list_head
  lib/plist: add helper functions
  lib/plist: add plist_requeue
  swap: change swap_list_head to plist, add swap_avail_head

Dave Chinner (1):
  fs/superblock: unregister sb shrinker before ->kill_sb()

David Rientjes (9):
  mm, compaction: avoid isolating pinned pages
  mm, compaction: determine isolation mode only once
  mm, compaction: ignore pageblock skip when manually invoking
    compaction
  mm, migration: add destination page freeing callback
  mm, compaction: return failed migration target pages back to freelist
  mm, compaction: add per-zone migration pfn cache for async compaction
  mm, compaction: embed migration mode in compact_control
  mm, compaction: terminate async compaction when rescheduling
  mm, thp: only collapse hugepages to nodes with affinity for
    zone_reclaim_mode

Davidlohr Bueso (1):
  mm: per-thread vma caching

Fabian Frederick (1):
  mm/readahead.c: inline ra_submit

Han Pingtian (1):
  mm: prevent setting of a value less than 0 to min_free_kbytes

Heesub Shin (1):
  mm/compaction: clean up unused code lines

Hugh Dickins (4):
  mm: fix bad rss-counter if remap_file_pages raced migration
  mm: fix direct reclaim writeback regression
  shmem: fix init_page_accessed use to stop !PageLRU bug
  mm/memory.c: use entry = ACCESS_ONCE(*pte) in handle_pte_fault()

Jens Axboe (1):
  mm/filemap.c: avoid always dirtying mapping->flags on O_DIRECT

Jerome Marchand (2):
  mm: make copy_pte_range static again
  memcg, vmscan: Fix forced scan of anonymous pages

Jianyu Zhan (1):
  mm/swap.c: clean up *lru_cache_add* functions

Johannes Weiner (5):
  lib: radix-tree: add radix_tree_delete_item()
  mm: shmem: save one radix tree lookup when truncating swapped pages
  mm: filemap: move radix tree hole searching here
  mm + fs: prepare for non-page entries in page cache radix trees
  mm: madvise: fix MADV_WILLNEED on shmem swapouts

Joonsoo Kim (7):
  slab: correct pfmemalloc check
  mm/compaction: disallow high-order page for migration target
  mm/compaction: do not call suitable_migration_target() on every page
  mm/compaction: change the timing to check to drop the spinlock
  mm/compaction: check pageblock suitability once per pageblock
  mm/compaction: clean-up code on success of ballon isolation
  vmalloc: use rcu list iterator to reduce vmap_area_lock contention

KOSAKI Motohiro (2):
  mm: get rid of unnecessary overhead of trace_mm_page_alloc_extfrag()
  mm: __rmqueue_fallback() should respect pageblock type

Linus Torvalds (1):
  mm: don't pointlessly use BUG_ON() for sanity check

Mel Gorman (30):
  mm, x86: Account for TLB flushes only when debugging
  x86/mm: Clean up inconsistencies when flushing TLB ranges
  x86/mm: Eliminate redundant page table walk during TLB range flushing
  mm: compaction: trace compaction begin and end
  mm: optimize put_mems_allowed() usage
  mm: vmscan: use proportional scanning during direct reclaim and full
    scan at DEF_PRIORITY
  mm: page_alloc: do not update zlc unless the zlc is active
  mm: page_alloc: do not treat a zone that cannot be used for dirty
    pages as "full"
  include/linux/jump_label.h: expose the reference count
  mm: page_alloc: use jump labels to avoid checking number_of_cpusets
  mm: page_alloc: calculate classzone_idx once from the zonelist ref
  mm: page_alloc: only check the zone id check if pages are buddies
  mm: page_alloc: only check the alloc flags and gfp_mask for dirty once
  mm: page_alloc: take the ALLOC_NO_WATERMARK check out of the fast path
  mm: page_alloc: use unsigned int for order in more places
  mm: page_alloc: reduce number of times page_to_pfn is called
  mm: page_alloc: convert hot/cold parameter and immediate callers to
    bool
  mm: page_alloc: lookup pageblock migratetype with IRQs enabled during
    free
  mm: shmem: avoid atomic operation during shmem_getpage_gfp
  mm: do not use atomic operations when releasing pages
  mm: do not use unnecessary atomic operations when adding pages to the
    LRU
  fs: buffer: do not use unnecessary atomic operations when discarding
    buffers
  mm: non-atomically mark page accessed during page cache allocation
    where possible
  mm: avoid unnecessary atomic operations during end_page_writeback()
  mm: pagemap: avoid unnecessary overhead when tracepoints are
    deactivated
  mm: rearrange zone fields into read-only, page alloc, statistics and
    page reclaim lines
  mm: move zone->pages_scanned into a vmstat counter
  mm: vmscan: only update per-cpu thresholds for online CPU
  mm: page_alloc: abort fair zone allocation policy when remotes nodes
    are encountered
  mm: page_alloc: reduce cost of the fair zone allocation policy

Michal Hocko (1):
  mm: exclude memoryless nodes from zone_reclaim

Nishanth Aravamudan (1):
  hugetlb: ensure hugepage access is denied if hugepages are not
    supported

Raghavendra K T (1):
  mm/readahead.c: fix readahead failure for memoryless NUMA nodes and
    limit readahead pages

Sasha Levin (1):
  mm: remove read_cache_page_async()

Shaohua Li (2):
  swap: add a simple detector for inappropriate swapin readahead
  x86/mm: In the PTE swapout page reclaim case clear the accessed bit
    instead of flushing the TLB

Tim Chen (1):
  fs/superblock: avoid locking counting inodes and dentries before
    reclaiming them

Vladimir Davydov (4):
  mm: vmscan: shrink all slab objects if tight on memory
  mm: vmscan: call NUMA-unaware shrinkers irrespective of nodemask
  mm: vmscan: respect NUMA policy mask when shrinking slab on direct
    reclaim
  mm: vmscan: shrink_slab: rename max_pass -> freeable

Vlastimil Babka (8):
  mm: compaction: encapsulate defer reset logic
  mm: compaction: do not mark unmovable pageblocks as skipped in async
    compaction
  mm: compaction: reset scanner positions immediately when they meet
  mm/compaction: cleanup isolate_freepages()
  mm/compaction: do not count migratepages when unnecessary
  mm/compaction: avoid rescanning pageblocks in isolate_freepages
  mm, compaction: properly signal and act upon lock and need_sched()
    contention
  mm/page_alloc: prevent MIGRATE_RESERVE pages from being misplaced

Yasuaki Ishimatsu (1):
  mm: get rid of unnecessary pageblock scanning in
    setup_zone_migrate_reserve

 arch/tile/mm/homecache.c                 |   2 +-
 arch/unicore32/include/asm/mmu_context.h |   4 +-
 arch/x86/include/asm/tlbflush.h          |   6 +-
 arch/x86/kernel/cpu/mtrr/generic.c       |   4 +-
 arch/x86/mm/pgtable.c                    |  21 +-
 arch/x86/mm/tlb.c                        |  52 +---
 fs/btrfs/compression.c                   |   2 +-
 fs/btrfs/extent_io.c                     |  15 +-
 fs/btrfs/file.c                          |  10 +-
 fs/buffer.c                              |  28 +-
 fs/cramfs/inode.c                        |   3 +-
 fs/exec.c                                |   5 +-
 fs/ext4/mballoc.c                        |  14 +-
 fs/f2fs/checkpoint.c                     |   1 -
 fs/f2fs/node.c                           |   2 -
 fs/fuse/dev.c                            |   2 +-
 fs/fuse/file.c                           |   4 -
 fs/gfs2/aops.c                           |   1 -
 fs/gfs2/meta_io.c                        |   4 +-
 fs/hugetlbfs/inode.c                     |   5 +
 fs/jffs2/fs.c                            |   2 +-
 fs/nfs/blocklayout/blocklayout.c         |   2 +-
 fs/ntfs/attrib.c                         |   1 -
 fs/ntfs/file.c                           |   1 -
 fs/proc/task_mmu.c                       |   3 +-
 fs/super.c                               |  16 +-
 include/linux/compaction.h               |  20 +-
 include/linux/cpuset.h                   |  56 ++--
 include/linux/gfp.h                      |   4 +-
 include/linux/huge_mm.h                  |   4 -
 include/linux/hugetlb.h                  |  10 +
 include/linux/jump_label.h               |  20 +-
 include/linux/migrate.h                  |  11 +-
 include/linux/mm.h                       |  11 +-
 include/linux/mm_types.h                 |   4 +-
 include/linux/mmzone.h                   | 233 ++++++++-------
 include/linux/page-flags.h               |   6 +-
 include/linux/pageblock-flags.h          |  33 +--
 include/linux/pagemap.h                  | 131 +++++++--
 include/linux/pagevec.h                  |   5 +
 include/linux/plist.h                    |  45 +++
 include/linux/radix-tree.h               |   5 +-
 include/linux/sched.h                    |   7 +
 include/linux/shmem_fs.h                 |   1 +
 include/linux/swap.h                     |  30 +-
 include/linux/swapfile.h                 |   2 +-
 include/linux/vm_event_item.h            |   4 +-
 include/linux/vmacache.h                 |  38 +++
 include/linux/vmstat.h                   |   8 +
 include/trace/events/compaction.h        |  67 ++++-
 include/trace/events/kmem.h              |  10 +-
 include/trace/events/pagemap.h           |  16 +-
 kernel/cpuset.c                          |  16 +-
 kernel/debug/debug_core.c                |  14 +-
 kernel/fork.c                            |   7 +-
 lib/plist.c                              |  52 ++++
 lib/radix-tree.c                         | 106 ++-----
 mm/Makefile                              |   2 +-
 mm/compaction.c                          | 347 +++++++++++++----------
 mm/filemap.c                             | 470 +++++++++++++++++++++----------
 mm/fremap.c                              |  28 +-
 mm/frontswap.c                           |  13 +-
 mm/huge_memory.c                         |  93 ++++--
 mm/hugetlb.c                             |  17 +-
 mm/internal.h                            |  22 +-
 mm/madvise.c                             |   2 +-
 mm/memory-failure.c                      |   4 +-
 mm/memory.c                              |   4 +-
 mm/memory_hotplug.c                      |   2 +-
 mm/mempolicy.c                           |  16 +-
 mm/migrate.c                             |  56 ++--
 mm/mincore.c                             |  20 +-
 mm/mmap.c                                |  55 ++--
 mm/nommu.c                               |  24 +-
 mm/page_alloc.c                          | 423 ++++++++++++++++------------
 mm/readahead.c                           |  37 +--
 mm/shmem.c                               | 133 +++------
 mm/slab.c                                |  12 +-
 mm/slub.c                                |  16 +-
 mm/swap.c                                | 101 ++++++-
 mm/swap_state.c                          |  65 ++++-
 mm/swapfile.c                            | 224 ++++++++-------
 mm/truncate.c                            |  74 ++++-
 mm/vmacache.c                            | 114 ++++++++
 mm/vmalloc.c                             |   6 +-
 mm/vmscan.c                              | 144 ++++++----
 mm/vmstat.c                              |  13 +-
 87 files changed, 2366 insertions(+), 1357 deletions(-)
 create mode 100644 include/linux/vmacache.h
 create mode 100644 mm/vmacache.c

-- 
2.1.0

