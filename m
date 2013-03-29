Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3C2Pif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 11:38:35 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52497
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756123Ab3C2Pie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 11:38:34 -0400
Date: Fri, 29 Mar 2013 09:38:31 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] block fixes for 3.9-rc
Message-ID: <20130329153831.GQ19488@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Collection of fixes that have been queued up since the merge window
opened, hence postponed until later in the cycle. The pull request
contains:

- A bunch of fixes for the xen blk front/back driver.

- A round of fixes for the new IBM RamSan driver, fixing various nasty
  issues.

- Fixes for multiple drives from Wei Yongjun, bad handling of return
  values and wrong pointer math.

- A fix for loop properly killing partitions when being detached.

Please pull! As per usual, it's tagged and signed.


  git://git.kernel.dk/linux-block.git for-linus


----------------------------------------------------------------
Alice Ferrazzi (1):
      Block: blk-flush: Fixed indent code style

Chen Gang (1):
      xen/xen-blkback: preq.dev is used without initialized

David Vrabel (1):
      xen/blkback: correctly respond to unknown, non-native requests

Jan Beulich (1):
      xen-blkback: fix dispatch_rw_block_io() error path

Jens Axboe (2):
      rsxx: fix missing unlock on error return in rsxx_eeh_remap_dmas()
      Merge branch 'stable/for-jens-3.9' of git://git.kernel.org/.../konrad/xen into for-linus

Mihnea Dobrescu-Balaur (1):
      xen-blkfront: replace kmalloc and then memcpy with kmemdup

Philip J Kelleher (8):
      block: IBM RamSan 70/80 trivial changes.
      block: IBM RamSan 70/80 fixes inconsistent locking.
      block: IBM RamSan 70/80 branding changes.
      block: IBM RamSan 70/80 error message bug fix.
      Adding in EEH support to the IBM FlashSystem 70/80 device driver
      block: removes dynamic allocation on stack
      rsxx: enable error return of rsxx_eeh_save_issued_dmas()
      rsxx: remove unused variable

Phillip Susi (1):
      loop: cleanup partitions when detaching loop device

Roger Pau Monne (5):
      xen-blkback: fix foreach_grant_safe to handle empty lists
      xen-blkfront: switch from llist to list
      xen-blkback: don't store dev_bus_addr
      xen-blkfront: pre-allocate pages for requests
      xen-blkfront: remove frame list from blk_shadow

Wei Yongjun (4):
      mtip32xx: fix error return code in mtip_pci_probe()
      loop: fix error return code in loop_add()
      cciss: fix invalid use of sizeof in cciss_find_cfgtables()
      mg_disk: fix error return code in mg_probe()

Zoltan Kiss (1):
      xen/blkback: Change statistics counter types to unsigned

 MAINTAINERS                         |   12 +-
 block/blk-flush.c                   |    2 +-
 block/partition-generic.c           |    1 +
 drivers/block/Kconfig               |    4 +-
 drivers/block/cciss.c               |    2 +-
 drivers/block/loop.c                |   22 +++-
 drivers/block/mg_disk.c             |    4 +-
 drivers/block/mtip32xx/mtip32xx.c   |    4 +-
 drivers/block/rsxx/Makefile         |    2 +-
 drivers/block/rsxx/config.c         |    8 +-
 drivers/block/rsxx/core.c           |  237 ++++++++++++++++++++++++++++++++--
 drivers/block/rsxx/cregs.c          |  112 ++++++++++------
 drivers/block/rsxx/dma.c            |  239 ++++++++++++++++++++++++-----------
 drivers/block/rsxx/rsxx.h           |    6 +-
 drivers/block/rsxx/rsxx_cfg.h       |    2 +-
 drivers/block/rsxx/rsxx_priv.h      |   34 ++++-
 drivers/block/xen-blkback/blkback.c |   68 +++++-----
 drivers/block/xen-blkback/common.h  |   40 ++++--
 drivers/block/xen-blkback/xenbus.c  |   14 +-
 drivers/block/xen-blkfront.c        |  154 +++++++++++++---------
 include/xen/interface/io/blkif.h    |   10 ++
 21 files changed, 716 insertions(+), 261 deletions(-)

-- 
Jens Axboe

