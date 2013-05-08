Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab3EHOyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:54:23 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47877
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756361Ab3EHOyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:54:21 -0400
Date: Wed, 8 May 2013 16:53:50 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Block driver changes for 3.10
Message-ID: <20130508145350.GO7800@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Below are the block driver related changes for 3.10. It might look big
in volume, but when categorized, not a lot of drivers are touched. The
pull request contains:

- mtip32xx fixes from Micron.

- A slew of drbd updates, this time in a nicer series.

- bcache, a flash/ssd caching framework from Kent.

- Fixes for cciss.


Please pull!


  git://git.kernel.dk/linux-block.git for-3.10/drivers


----------------------------------------------------------------

Alexey Khoroshilov (1):
      drbd: add module_put() on error path in drbd_proc_open()

Asai Thambi S P (3):
      mtip32xx: fix a smatch warning
      mtip32xx: mtip32xx: Disable TRIM support
      mtip32xx: Workaround for unaligned writes

Geert Uytterhoeven (1):
      bcache: Add missing #include <linux/prefetch.h>

George Spelvin (1):
      idr: document exit conditions on idr_for_each_entry better

Jens Axboe (3):
      Merge branch 'bcache-for-upstream' of http://evilpiepirate.org/git/linux-bcache into for-3.10/drivers
      aoe: get rid of cached bv variable in bufinit()
      Merge branch 'bcache-for-upstream' of http://evilpiepirate.org/git/linux-bcache into for-3.10/drivers

Jingoo Han (1):
      drivers/block/mg_disk.c: add CONFIG_PM_SLEEP to suspend/resume functions

Kent Overstreet (23):
      Revert "rw_semaphore: remove up/down_read_non_owner"
      Export get_random_int()
      Export blk_fill_rwbs()
      Export __lockdep_no_validate__
      bcache: A block layer cache
      bcache: Build fixes from test robot
      bcache: Style/checkpatch fixes
      bcache: Fix for the build fixes
      bcache: Don't export utility code, prefix with bch_
      bcache: Sparse fixes
      bcache: Use WARN_ONCE() instead of __WARN()
      bcache: Documentation updates
      bcache: Fix a minor memory leak on device teardown
      bcache: Fix a format string overflow
      bcache: Disable broken btree fuzz tester
      bcache: Take data offset from the bdev superblock.
      bcache: Set ra_pages based on backing device's ra_pages
      bcache: Hack around stuff that clones up to bi_max_vecs
      bcache: Correctly check against BIO_MAX_PAGES
      bcache: Fix merge_bvec_fn usage for when it modifies the bvm
      bcache: Make sure blocksize isn't smaller than device blocksize
      bcache: Allocator cleanup/fixes
      bcache: Use bd_link_disk_holder()

Lars Ellenberg (23):
      drbd: cleanup bogus assert message
      drbd: cleanup ondisk meta data layout calculations and defines
      drbd: prepare for new striped layout of activity log
      drbd: use the cached meta_dev_idx
      drbd: mechanically rename la_size to la_size_sect
      drbd: read meta data early, base on-disk offsets on super block
      drbd: Clarify when activity log I/O is delegated to the worker thread
      drbd: drbd_al_being_io: short circuit to reduce latency
      drbd: split __drbd_make_request in before and after drbd_al_begin_io
      drbd: prepare to queue write requests on a submit worker
      drbd: split drbd_al_begin_io into fastpath, prepare, and commit
      drbd: split out some helper functions to drbd_al_begin_io
      drbd: queue writes on submitter thread, unless they pass the activity log fastpath
      lru_cache: introduce lc_get_cumulative()
      drbd: consolidate as many updates as possible into one AL transaction
      drbd: move start io accounting before activity log transaction
      drbd: try hard to max out the updates per AL transaction
      drbd: adjust upper limit for activity log extents
      drbd: only fail empty flushes if no good data is reachable
      drbd: fix memory leak
      drbd: validate resync_after dependency on attach already
      drbd: fix drbd epoch write count for ahead/behind mode
      drbd: fix if(); found by kbuild test robot

Mike Miller (2):
      cciss: add cciss_allow_hpsa module parameter
      cciss: bug fix to prevent cciss from loading in kdump crash kernel

Philipp Reisner (10):
      drbd: reset ap_in_flight counter for new connections
      drbd: abort start of resync early, if it raced with connection breakage
      drbd: move invalidating the whole bitmap out of after_state ch()
      drbd: fix effective error returned when refusing an invalidate
      drbd: drop now useless duplicate state request from invalidate
      drbd: fix spurious warning about bitmap being locked from detach
      drbd: Fix disconnect to keep the peer disk state if connection breaks during operation
      drbd: Fix build error when CONFIG_CRYPTO_HMAC is not set
      drbd: fix for deadlock when using automatic split-brain-recovery
      drbd: use sched_setscheduler()

 Documentation/ABI/testing/sysfs-block-bcache |  156 ++
 Documentation/bcache.txt                     |  431 +++++
 MAINTAINERS                                  |    7 +
 drivers/block/aoe/aoecmd.c                   |    6 +-
 drivers/block/cciss.c                        |   22 +-
 drivers/block/drbd/drbd_actlog.c             |  246 ++-
 drivers/block/drbd/drbd_bitmap.c             |   13 +-
 drivers/block/drbd/drbd_int.h                |  179 +-
 drivers/block/drbd/drbd_main.c               |  251 ++-
 drivers/block/drbd/drbd_nl.c                 |  200 +-
 drivers/block/drbd/drbd_proc.c               |   10 +-
 drivers/block/drbd/drbd_receiver.c           |   16 +-
 drivers/block/drbd/drbd_req.c                |  192 +-
 drivers/block/drbd/drbd_req.h                |    8 +
 drivers/block/drbd/drbd_state.c              |   28 +-
 drivers/block/drbd/drbd_strings.c            |    1 +
 drivers/block/drbd/drbd_worker.c             |   24 +-
 drivers/block/mg_disk.c                      |    2 +
 drivers/block/mtip32xx/mtip32xx.c            |   79 +-
 drivers/block/mtip32xx/mtip32xx.h            |   11 +
 drivers/char/random.c                        |    1 +
 drivers/md/Kconfig                           |    2 +
 drivers/md/Makefile                          |    1 +
 drivers/md/bcache/Kconfig                    |   42 +
 drivers/md/bcache/Makefile                   |    7 +
 drivers/md/bcache/alloc.c                    |  599 ++++++
 drivers/md/bcache/bcache.h                   | 1259 +++++++++++++
 drivers/md/bcache/bset.c                     | 1192 ++++++++++++
 drivers/md/bcache/bset.h                     |  379 ++++
 drivers/md/bcache/btree.c                    | 2503 ++++++++++++++++++++++++++
 drivers/md/bcache/btree.h                    |  405 +++++
 drivers/md/bcache/closure.c                  |  345 ++++
 drivers/md/bcache/closure.h                  |  672 +++++++
 drivers/md/bcache/debug.c                    |  565 ++++++
 drivers/md/bcache/debug.h                    |   54 +
 drivers/md/bcache/io.c                       |  397 ++++
 drivers/md/bcache/journal.c                  |  787 ++++++++
 drivers/md/bcache/journal.h                  |  215 +++
 drivers/md/bcache/movinggc.c                 |  254 +++
 drivers/md/bcache/request.c                  | 1411 +++++++++++++++
 drivers/md/bcache/request.h                  |   62 +
 drivers/md/bcache/stats.c                    |  246 +++
 drivers/md/bcache/stats.h                    |   58 +
 drivers/md/bcache/super.c                    | 1987 ++++++++++++++++++++
 drivers/md/bcache/sysfs.c                    |  817 +++++++++
 drivers/md/bcache/sysfs.h                    |  110 ++
 drivers/md/bcache/trace.c                    |   26 +
 drivers/md/bcache/util.c                     |  377 ++++
 drivers/md/bcache/util.h                     |  589 ++++++
 drivers/md/bcache/writeback.c                |  414 +++++
 include/linux/cgroup_subsys.h                |    6 +
 include/linux/drbd.h                         |    5 +-
 include/linux/drbd_limits.h                  |   11 +-
 include/linux/idr.h                          |   10 +-
 include/linux/lru_cache.h                    |    1 +
 include/linux/rwsem.h                        |   10 +
 include/linux/sched.h                        |    4 +
 include/trace/events/bcache.h                |  271 +++
 kernel/fork.c                                |    4 +
 kernel/lockdep.c                             |    1 +
 kernel/rwsem.c                               |   16 +
 kernel/trace/blktrace.c                      |    1 +
 lib/lru_cache.c                              |   56 +-
 63 files changed, 17682 insertions(+), 372 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-block-bcache
 create mode 100644 Documentation/bcache.txt
 create mode 100644 drivers/md/bcache/Kconfig
 create mode 100644 drivers/md/bcache/Makefile
 create mode 100644 drivers/md/bcache/alloc.c
 create mode 100644 drivers/md/bcache/bcache.h
 create mode 100644 drivers/md/bcache/bset.c
 create mode 100644 drivers/md/bcache/bset.h
 create mode 100644 drivers/md/bcache/btree.c
 create mode 100644 drivers/md/bcache/btree.h
 create mode 100644 drivers/md/bcache/closure.c
 create mode 100644 drivers/md/bcache/closure.h
 create mode 100644 drivers/md/bcache/debug.c
 create mode 100644 drivers/md/bcache/debug.h
 create mode 100644 drivers/md/bcache/io.c
 create mode 100644 drivers/md/bcache/journal.c
 create mode 100644 drivers/md/bcache/journal.h
 create mode 100644 drivers/md/bcache/movinggc.c
 create mode 100644 drivers/md/bcache/request.c
 create mode 100644 drivers/md/bcache/request.h
 create mode 100644 drivers/md/bcache/stats.c
 create mode 100644 drivers/md/bcache/stats.h
 create mode 100644 drivers/md/bcache/super.c
 create mode 100644 drivers/md/bcache/sysfs.c
 create mode 100644 drivers/md/bcache/sysfs.h
 create mode 100644 drivers/md/bcache/trace.c
 create mode 100644 drivers/md/bcache/util.c
 create mode 100644 drivers/md/bcache/util.h
 create mode 100644 drivers/md/bcache/writeback.c
 create mode 100644 include/trace/events/bcache.h

-- 
Jens Axboe

