Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab3GVTJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 15:09:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50736 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932676Ab3GVTJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 15:09:16 -0400
Date: Mon, 22 Jul 2013 13:09:14 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Block IO driver bits for 3.11
Message-ID: <20130722190914.GC32755@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

As I mentioned in the core block pull request, due to real life
circumstances the driver pull request would be late. Now it looks like
-rc2 late... On the plus side, apart form the rsxx update, these are all
things that I could argue could go in later in the cycle as they are
fixes and not features. So even though things are late, it's not ALL
bad.

The pull request contains:

- Updates to bcache, all bug fixes, from Kent.

- A pile of drbd bug fixes (no big features this time!).

- xen blk front/back fixes.

- rsxx driver updates, some of them deferred form 3.10. So should be
  well cooked by now.

Please pull!


  git://git.kernel.dk/linux-block.git for-3.11/drivers

----------------------------------------------------------------

Andreas Gruenbacher (2):
      drbd: Do not sleep inside rcu
      drbd: Fix rcu_read_lock balance on error path

Dan Carpenter (1):
      bcache: check for allocation failures

Gabriel de Perthuis (4):
      bcache: Warn when a device is already registered.
      bcache: Send a uevent with a cached device's UUID
      bcache: Send label uevents
      bcache: Refresh usage docs

Jan Beulich (1):
      xen/io/ring.h: new macro to detect whether there are too many requests on the ring

Jens Axboe (4):
      Merge branch 'stable/for-jens-3.10' of git://git.kernel.org/.../konrad/xen into for-3.11/drivers
      Merge tag 'v3.10-rc7' into for-3.11/drivers
      Merge branch 'bcache-for-3.11' of git://evilpiepirate.org/~kent/linux-bcache into for-3.11/drivers
      Merge branch 'bcache-for-3.11' of git://evilpiepirate.org/~kent/linux-bcache into for-3.11/drivers

Kent Overstreet (21):
      bcache: fix a spurious gcc complaint, use scnprintf
      bcache: Convert allocator thread to kthread
      bcache: Refactor btree io
      bcache: Fix/revamp tracepoints
      bcache: Rip out pkey()/pbtree()
      bcache: Improve lazy sorting
      bcache: Initialize sectors_dirty when attaching
      bcache: Track dirty data by stripe
      bcache: Write out full stripes
      bcache: FUA fixes
      bcache: Document shrinker reserve better
      bcache: Delete fuzz tester
      bcache: Update email address
      bcache: Use standard utility code
      bcache: Fix a dumb race
      bcache: Advertise that flushes are supported
      bcache: Fix a sysfs splat on shutdown
      bcache: Shutdown fix
      bcache: Journal replay fix
      bcache: Fix GC_SECTORS_USED() calculation
      bcache: Allocation kthread fixes

Konrad Rzeszutek Wilk (4):
      xen-blkfront: Introduce a 'max' module parameter to alter the amount of indirect segments.
      xen-blkback/sysfs: Move the parameters for the persistent grant features
      xen/blkback: Check device permissions before allowing OP_DISCARD
      xen/blkback: Check for insane amounts of request on the ring (v6).

Kumar Amit Mehta (1):
      md: bcache: io.c: fix a potential NULL pointer dereference

Masanari Iida (1):
      doc: Fix typo in documentation/bcache.txt

Philip J Kelleher (11):
      rsxx: Individual workqueues for interruptible events.
      rsxx: Restructured DMA cancel scheme.
      rsxx: Fixes soft-lockup issues during DMAs.
      rsxx: Allow block size to be determined by configuration.
      rsxx: Adding in sync_start module paramenter.
      rsxx: Changing the adapter name to the official name.
      rsxx: Fixes DLPAR add kernel panic if partition still mounted.
      rsxx: Adapter address space sanity check.
      rsxx: Adding EEH check inside cregs timeout.
      rsxx: Fixes incorrect stats calculation.
      rsxx: Adding in debugfs entries.

Philipp Reisner (3):
      drbd: Ignore the exit code of a fence-peer handler if it returns too late
      drbd: Constants should be UPPERCASE
      drbd: Allow online change of al-stripes and al-stripe-size

Roger Pau Monne (12):
      xen-blkback: print stats about persistent grants
      xen-blkback: use balloon pages for all mappings
      xen-blkback: implement LRU mechanism for persistent grants
      xen-blkback: move pending handles list from blkbk to pending_req
      xen-blkback: make the queue of free requests per backend
      xen-blkback: expand map/unmap functions
      xen-block: implement indirect descriptors
      xen-blkback: allocate list of pending reqs in small chunks
      xen-blkfront: use a different scatterlist for each request
      xen-blkback: workaround compiler bug in gcc 4.1
      xen-blkfront: set blk_queue_max_hw_sectors correctly
      xen-blkback: check the number of iovecs before allocating a bios

Stefan Bader (1):
      xen/blkback: Use physical sector size for setup

Wei Yongjun (1):
      drbd: fix error return code in drbd_init()

 Documentation/ABI/testing/sysfs-driver-xen-blkback |   17 +
 .../ABI/testing/sysfs-driver-xen-blkfront          |   10 +
 Documentation/bcache.txt                           |   47 +-
 Documentation/cgroups/blkio-controller.txt         |   29 +-
 MAINTAINERS                                        |    4 +-
 block/blk-cgroup.c                                 |  105 +-
 block/blk-cgroup.h                                 |   38 +-
 block/blk-throttle.c                               | 1064 ++++++++++++++------
 drivers/block/Kconfig                              |    4 +-
 drivers/block/drbd/drbd_actlog.c                   |   21 +
 drivers/block/drbd/drbd_int.h                      |   15 +-
 drivers/block/drbd/drbd_main.c                     |   61 +-
 drivers/block/drbd/drbd_nl.c                       |  185 +++-
 drivers/block/drbd/drbd_receiver.c                 |   12 +-
 drivers/block/drbd/drbd_state.c                    |    4 +-
 drivers/block/rsxx/core.c                          |  359 ++++++-
 drivers/block/rsxx/cregs.c                         |   14 +
 drivers/block/rsxx/dev.c                           |   33 +-
 drivers/block/rsxx/dma.c                           |  185 ++--
 drivers/block/rsxx/rsxx_priv.h                     |   10 +-
 drivers/block/xen-blkback/blkback.c                |  872 ++++++++++------
 drivers/block/xen-blkback/common.h                 |  147 ++-
 drivers/block/xen-blkback/xenbus.c                 |   85 ++
 drivers/block/xen-blkfront.c                       |  532 ++++++++--
 drivers/md/bcache/alloc.c                          |   46 +-
 drivers/md/bcache/bcache.h                         |   61 +-
 drivers/md/bcache/bset.c                           |   56 +-
 drivers/md/bcache/bset.h                           |    4 +
 drivers/md/bcache/btree.c                          |  451 ++++-----
 drivers/md/bcache/btree.h                          |   35 +-
 drivers/md/bcache/closure.c                        |    6 +-
 drivers/md/bcache/debug.c                          |  178 +---
 drivers/md/bcache/debug.h                          |   11 +-
 drivers/md/bcache/io.c                             |   68 +-
 drivers/md/bcache/journal.c                        |   25 +-
 drivers/md/bcache/movinggc.c                       |   24 +-
 drivers/md/bcache/request.c                        |  197 ++--
 drivers/md/bcache/request.h                        |    2 +-
 drivers/md/bcache/super.c                          |  171 +++-
 drivers/md/bcache/sysfs.c                          |   68 +-
 drivers/md/bcache/trace.c                          |   47 +-
 drivers/md/bcache/util.c                           |   17 -
 drivers/md/bcache/util.h                           |    6 -
 drivers/md/bcache/writeback.c                      |  133 ++-
 drivers/md/bcache/writeback.h                      |   64 ++
 include/linux/cgroup.h                             |    2 +
 include/linux/drbd.h                               |    6 +-
 include/linux/drbd_genl.h                          |    2 +
 include/linux/drbd_limits.h                        |    9 +
 include/trace/events/bcache.h                      |  381 +++++--
 include/xen/interface/io/blkif.h                   |   53 +
 include/xen/interface/io/ring.h                    |    5 +
 52 files changed, 4025 insertions(+), 1956 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-xen-blkback
 create mode 100644 Documentation/ABI/testing/sysfs-driver-xen-blkfront
 create mode 100644 drivers/md/bcache/writeback.h

-- 
Jens Axboe

