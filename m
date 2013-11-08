Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab3KHRtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 12:49:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55504 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab3KHRtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 12:49:01 -0500
Date: Fri, 8 Nov 2013 10:49:00 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] block drivers updates for 3.13
Message-ID: <20131108174900.GB3195@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the block driver pull request for 3.13. As with the core pull
request just sent out, this was rebased on top of the core branch again
after the immutable series was pulled. This also means that bcache gets
to sit the initial pull over. I will send a second driver pull request
in the merge window to get those fixes in, once they have been rebased
and tested on top of the non-immutable stack.

This pull request contains:

- Add support for the sTec Kronos pci-e flash card from sTec. Also has
  various cleanups for this driver, from myself, Bart, Mike Snizter, and
  Wei Yongjun.

- Add surprise removal support for the micron mtip32xx driver from
  Micron.

- Floppy documentation fix from Ben Harris.

- debugfs bug fix for pktcdvd from Dan Carpenter.

- Fix for the mtip32xx driver stack usage in the debugfs path,
  dynamically allocating those buffers instead. From David Milburn.

- Disable cpqarray in Kconfig. The plan is to remove it on request of
  HP, but lets disable it for a few revisions just to see if anyone
  yells.

- drbd fixes from Lars Ellenberg and Philipp Reisner.

- Elevator switch fix for the s390 block driver from Heiko Carstens.

- loop crash fix on IO to unassigned device from Mikulas Patocka.

- A series of bug fixes for the IBM rsxx pci-e flash driver from Philip
  J Kelleher.

- cciss probe fix from Stephen Cameron.

- Xen block front/back fixes from Roger Pau Monne and Vegard Nossum.


Please pull!


  git://git.kernel.dk/linux-block.git for-3.13/drivers

for you to fetch changes up to f7cb20f03dc6dff1b19942cf3dda6d154c86f29b:

  floppy: Correct documentation of driver options when used as a module. (2013-11-08 09:10:31 -0700)

----------------------------------------------------------------
Akhil Bhansali (2):
      Add support for sTec's pci-e flash card Kronos
      skd: Fix checkpatch ERRORS and removed unused functions

Asai Thambi S P (1):
      mtip32xx: Add SRSI support

Bartlomiej Zolnierkiewicz (11):
      skd: fix unregister_blkdev() placement
      skd: fix error paths in skd_init()
      skd: fix error messages in skd_init()
      skd: register block device only if some devices are present
      skd: remove SCSI subsystem specific includes
      skd: use <asm/unaligned.h>
      skd: remove redundant skdev->pdev assignment from skd_pci_probe()
      skd: remove SKD_OMIT_FROM_SRC_DIST ifdefs
      skd: cleanup skd_do_inq_page_da()
      skd: reorder construct/destruct code
      skd: fix formatting in skd_s1120.h

Ben Harris (1):
      floppy: Correct documentation of driver options when used as a module.

Dan Carpenter (1):
      pktcdvd: debugfs functions return NULL on error

David Milburn (1):
      mtip32xx: dynamically allocate buffer in debugfs functions

Heiko Carstens (1):
      s390/dasd: hold request queue sysfs lock when calling elevator_init()

Jens Axboe (3):
      block: disable cpqarray in Kconfig
      skd: rip out bio path
      skd: cleanup the skd_*() function block wrapping

Lars Ellenberg (3):
      drbd: fix NULL pointer deref in module init error path
      drbd: fix decoding of bitmap vli rle for device sizes > 64 TB
      drbd: avoid to shrink max_bio_size due to peer re-configuration

Michael Opdenacker (1):
      mg_disk: remove deprecated IRQF_DISABLED

Mike Snitzer (1):
      skd: more removal of bio-based code

Mikulas Patocka (1):
      loop: fix crash when using unassigned loop device

Philip J Kelleher (5):
      rsxx: Handling failed pci_map_page on PowerPC and double free.
      rsxx: Moving pci_map_page to prevent overflow.
      rsxx: Kernel Panic caused by mapping Discards
      rsxx: Disallow discards from being unmapped.
      rsxx: Fix possible kernel panic with invalid config.

Philipp Reisner (2):
      drbd: Fix an connection drop issue after enabling allow-two-primaries
      drbd: Fix adding of new minors with freshly created meta data

Roger Pau Monne (3):
      xen-blkfront: revoke foreign access for grants not mapped by the backend
      xen-blkfront: improve aproximation of required grants per request
      xen-blkfront: restore the non-persistent data path

Stephen M. Cameron (1):
      cciss: return 0 from driver probe function on success, not 1

Vegard Nossum (1):
      xen/blkback: fix reference counting

Wei Yongjun (1):
      skd: fix error return code in skd_pci_probe()

rchinthekindi (1):
      skd: Replaced custom debug PRINTKs with pr_debug

 Documentation/blockdev/floppy.txt   |    6 +-
 drivers/block/Kconfig               |   12 +-
 drivers/block/Makefile              |    2 +
 drivers/block/cciss.c               |    2 +-
 drivers/block/drbd/drbd_int.h       |    3 +-
 drivers/block/drbd/drbd_main.c      |   19 +-
 drivers/block/drbd/drbd_nl.c        |    6 +-
 drivers/block/drbd/drbd_receiver.c  |   45 +-
 drivers/block/drbd/drbd_req.c       |    3 +
 drivers/block/loop.c                |   15 +-
 drivers/block/mg_disk.c             |    2 +-
 drivers/block/mtip32xx/mtip32xx.c   |  500 ++--
 drivers/block/mtip32xx/mtip32xx.h   |   18 +-
 drivers/block/pktcdvd.c             |   22 +-
 drivers/block/rsxx/core.c           |    8 +-
 drivers/block/rsxx/dev.c            |    8 +-
 drivers/block/rsxx/dma.c            |  119 +-
 drivers/block/rsxx/rsxx_priv.h      |   11 +-
 drivers/block/skd_main.c            | 5432 +++++++++++++++++++++++++++++++++++
 drivers/block/skd_s1120.h           |  330 +++
 drivers/block/xen-blkback/blkback.c |    3 +-
 drivers/block/xen-blkfront.c        |  159 +-
 drivers/s390/block/dasd.c           |    8 +-
 23 files changed, 6369 insertions(+), 364 deletions(-)
 create mode 100644 drivers/block/skd_main.c
 create mode 100644 drivers/block/skd_s1120.h

-- 
Jens Axboe

