Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682AbaA1Wum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:50:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38146 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaA1Wuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:50:40 -0500
Date: Tue, 28 Jan 2014 15:50:39 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Block IO driver changes for 3.14
Message-ID: <20140128225039.GG25989@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the block driver pull request for 3.14. It contains:

- bcache update from Kent Overstreet.

- Two bcache fixes from Nicholas Swenson.

- cciss pci init error fix from Andrew.

- Underflow fix in the parallel IDE pg_write code from Dan Carpenter.
  I'm sure the 1 (or 0) users of that are now happy.

- Two PCI related fixes for sx8 from Jingoo Han.

- Floppy init fix for first block read from Jiri Kosina.

- pktcdvd error return miss fix from Julia Lawall.

- Removal of IRQF_SHARED from the SEGA Dreamcast CD-ROM code from
  Michael Opdenacker.

- Comment typo fix for the loop driver from Olaf Hering.

- Potential oops fix for null_blk from Raghavendra K T.

- Two fixes from Sam Bradshaw (Micron) for the mtip32xx driver, fixing
  an OOM problem and a problem with handling security locked conditions.


Please pull!


  git://git.kernel.dk/linux-block.git for-3.14/drivers


----------------------------------------------------------------
Andrew Morton (1):
      drivers/block/cciss.c:cciss_init_one(): use proper errnos

Christoph Lameter (1):
      block: Replace __this_cpu_ptr with raw_cpu_ptr

Dan Carpenter (1):
      drivers/block/paride/pg.c: underflow bug in pg_write()

Geert Uytterhoeven (1):
      mg_disk: Spelling s/finised/finished/

Jens Axboe (2):
      Merge branch 'for-3.14/core' into for-3.14/drivers
      Merge branch 'for-jens' of git://git.kernel.org/.../jikos/linux-block into for-3.14/drivers

Jingoo Han (2):
      drivers/block/sx8.c: use module_pci_driver()
      drivers/block/sx8.c: remove unnecessary pci_set_drvdata()

Jiri Kosina (1):
      floppy: bail out in open() if drive is not responding to block0 read

Julia Lawall (1):
      pktcdvd: fix error return code

Kent Overstreet (32):
      bcache: Data corruption fix
      bcache: Minor journal fix
      bcache: Performance fix for when journal entry is full
      bcache: Minor btree cache fix
      bcache: Don't touch bucket gen for dirty ptrs
      bcache: Zero less memory
      bcache: kill closure locking usage
      bcache: kill closure locking code
      bcache: Rework allocator reserves
      bcache: Do bkey_put() in btree_split() error path
      bcache/md: Use raid stripe size
      bcache: Trivial error handling fix
      bcache: kill index()
      bcache: Btree verify code improvements
      bcache: Use a mempool for mergesort temporary space
      bcache: Remove/fix some header dependencies
      bcache: Make bch_keylist_realloc() take u64s, not nptrs
      bcache: Bkey indexing renaming
      bcache: Split out sort_extent_cmp()
      bcache: Add struct bset_sort_state
      bcache: Rename/shuffle various code around
      bcache: Abstract out stuff needed for sorting
      bcache: Add struct btree_keys
      bcache: Add bch_btree_keys_u64s_remaining()
      bcache: Refactor bset_tree sysfs stats
      bcache: Convert btree_iter to struct btree_keys
      bcache: Convert debug code to btree_keys
      bcache: Convert sorting to btree_keys
      bcache: Move insert_fixup() to btree_keys_ops
      bcache: Improve bucket_prio() calculation
      bcache: Don't return -EINTR when insert finished
      bcache: Fix auxiliary search trees for key size > cacheline size

Michael Opdenacker (1):
      drivers/cdrom/gdrom.c: remove deprecated IRQF_DISABLED

Nicholas Swenson (2):
      bcache: update bch_bkey_try_merge
      bcache: Add bch_bkey_equal_header()

Olaf Hering (1):
      drivers/block/loop.c: fix comment typo in loop_config_discard

Raghavendra K T (1):
      null_blk: Null pointer deference problem in alloc_page_buffers

Sam Bradshaw (2):
      mtip32xx: Make SGL container per-command to eliminate high order dma allocation
      mtip32xx: Correctly handle security locked condition

 block/blk-settings.c              |   4 +
 drivers/block/cciss.c             |   4 +-
 drivers/block/floppy.c            |  36 +-
 drivers/block/loop.c              |   2 +-
 drivers/block/mg_disk.c           |   2 +-
 drivers/block/mtip32xx/mtip32xx.c | 250 +++++++----
 drivers/block/mtip32xx/mtip32xx.h |  14 +-
 drivers/block/null_blk.c          |   5 +
 drivers/block/paride/pg.c         |   2 +-
 drivers/block/pktcdvd.c           |   4 +-
 drivers/block/sx8.c               |  16 +-
 drivers/cdrom/gdrom.c             |   4 +-
 drivers/md/bcache/Makefile        |   5 +-
 drivers/md/bcache/alloc.c         |  89 ++--
 drivers/md/bcache/bcache.h        |  82 ++--
 drivers/md/bcache/bset.c          | 904 +++++++++++++++++++++-----------------
 drivers/md/bcache/bset.h          | 440 +++++++++++++------
 drivers/md/bcache/btree.c         | 676 +++++++++++-----------------
 drivers/md/bcache/btree.h         |  62 +--
 drivers/md/bcache/closure.c       |  90 +---
 drivers/md/bcache/closure.h       | 355 +++++----------
 drivers/md/bcache/debug.c         | 247 +++--------
 drivers/md/bcache/debug.h         |  27 +-
 drivers/md/bcache/extents.c       | 616 ++++++++++++++++++++++++++
 drivers/md/bcache/extents.h       |  13 +
 drivers/md/bcache/journal.c       |  75 ++--
 drivers/md/bcache/journal.h       |   1 +
 drivers/md/bcache/movinggc.c      |   2 +-
 drivers/md/bcache/request.c       |  72 ++-
 drivers/md/bcache/request.h       |  21 +-
 drivers/md/bcache/super.c         | 103 +++--
 drivers/md/bcache/sysfs.c         |  79 ++--
 drivers/md/bcache/util.h          |   8 +
 drivers/md/raid5.c                |   1 +
 fs/buffer.c                       |   2 +-
 include/linux/blkdev.h            |   1 +
 include/trace/events/bcache.h     |  10 +-
 include/uapi/linux/bcache.h       |   3 +-
 include/uapi/linux/fd.h           |   3 +-
 39 files changed, 2435 insertions(+), 1895 deletions(-)
 create mode 100644 drivers/md/bcache/extents.c
 create mode 100644 drivers/md/bcache/extents.h

-- 
Jens Axboe

