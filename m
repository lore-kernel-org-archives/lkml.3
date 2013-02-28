Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab3B1Oqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:46:50 -0500
Received: from dkim2.fusionio.com ([66.114.96.54]:38244 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab3B1Oqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:44 -0500
X-ASG-Debug-ID: 1362062413-03d6a5664a594f0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Date: Thu, 28 Feb 2013 15:40:09 +0100
From: Jens Axboe <jaxboe@fusionio.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block driver bits for 3.9
Message-ID: <20130228144009.GD4727@kernel.dk>
X-ASG-Orig-Subj: [GIT PULL] Block driver bits for 3.9
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1362062413
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0016 1.0000 -2.0107
X-Barracuda-Spam-Score: -2.01
X-Barracuda-Spam-Status: No, SCORE=-2.01 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.123854
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

After the block IO core bits are in, please grab the driver updates from
below as well. It contains:

- Fix ancient regression in dac960. Nobody must be using that anymore...

- Some good fixes from Guo Ghao for loop, fixing both potential oopses
  and deadlocks.

- Improve mtip32xx for NUMA systems, by being a bit more clever in
  distributing work.

- Add IBM RamSan 70/80 driver. A second round of fixes for that is
  pending, that will come in through for-linus during the 3.9 cycle as
  per usual.

- A few xen-blk{back,front} fixes from Konrad and Roger.

- Other minor fixes and improvements.


Please pull!

  git://git.kernel.dk/linux-block.git for-3.9/drivers



Asai Thambi S P (2):
      mtip32xx: Add workqueue and NUMA support
      mtip32xx: add trim support

Dan Carpenter (1):
      dac960: return success instead of -ENOTTY

Fengguang Wu (2):
      drivers/block/mtip32xx/mtip32xx.c:4029:1: sparse: symbol 'mtip_workq_sdbf0' was not declared. Should it be static?
      drivers/block/mtip32xx/mtip32xx.c:1726:5: sparse: symbol 'mtip_send_trim' was not declared. Should it be static?

Guo Chao (5):
      loopdev: fix a deadlock
      loopdev: update block device size in loop_set_status()
      loopdev: move common code into loop_figure_size()
      loopdev: remove an user triggerable oops
      loopdev: ignore negative offset when calculate loop device size

Heiko Carstens (1):
      drivers/block/mtip32xx: add missing GENERIC_HARDIRQS dependency

Jan Beulich (1):
      xen-blkback: do not leak mode property

Jens Axboe (3):
      rsxx: add slab.h include to dma.c
      Merge branch 'delete-xt-disk' of git://git.kernel.org/.../paulg/linux into for-3.9/drivers
      Merge branch 'stable/for-jens-3.9' of git://git.kernel.org/.../konrad/xen into for-3.9/drivers

Konrad Rzeszutek Wilk (2):
      xen/blkback: Don't trust the handle from the frontend.
      xen-blkfront: drop the use of llist_for_each_entry_safe

Paul Gortmaker (1):
      block: delete super ancient PC-XT driver for 1980's hardware

Philip J Kelleher (1):
      block: IBM RamSan 70/80 driver fixes

Roger Pau Monne (1):
      xen-blkback: use balloon pages for persistent grants

Stephen Rothwell (1):
      block: remove new __devinit/exit annotations on ramsam driver

josh.h.morris@us.ibm.com (1):
      block: IBM RamSan 70/80 device driver

 MAINTAINERS                         |    6 +
 drivers/block/DAC960.c              |    1 +
 drivers/block/Kconfig               |   23 +-
 drivers/block/Makefile              |    3 +-
 drivers/block/loop.c                |   61 +-
 drivers/block/mtip32xx/Kconfig      |    2 +-
 drivers/block/mtip32xx/mtip32xx.c   |  431 +++++++++++---
 drivers/block/mtip32xx/mtip32xx.h   |   48 +-
 drivers/block/rsxx/Makefile         |    2 +
 drivers/block/rsxx/config.c         |  213 +++++++
 drivers/block/rsxx/core.c           |  649 ++++++++++++++++++++
 drivers/block/rsxx/cregs.c          |  758 +++++++++++++++++++++++
 drivers/block/rsxx/dev.c            |  367 ++++++++++++
 drivers/block/rsxx/dma.c            |  998 +++++++++++++++++++++++++++++++
 drivers/block/rsxx/rsxx.h           |   45 ++
 drivers/block/rsxx/rsxx_cfg.h       |   72 +++
 drivers/block/rsxx/rsxx_priv.h      |  399 +++++++++++++
 drivers/block/xd.c                  | 1123 -----------------------------------
 drivers/block/xd.h                  |  134 -----
 drivers/block/xen-blkback/blkback.c |    7 +-
 drivers/block/xen-blkback/xenbus.c  |   49 +-
 drivers/block/xen-blkfront.c        |   13 +-
 include/linux/llist.h               |   25 -
 23 files changed, 3986 insertions(+), 1443 deletions(-)
 create mode 100644 drivers/block/rsxx/Makefile
 create mode 100644 drivers/block/rsxx/config.c
 create mode 100644 drivers/block/rsxx/core.c
 create mode 100644 drivers/block/rsxx/cregs.c
 create mode 100644 drivers/block/rsxx/dev.c
 create mode 100644 drivers/block/rsxx/dma.c
 create mode 100644 drivers/block/rsxx/rsxx.h
 create mode 100644 drivers/block/rsxx/rsxx_cfg.h
 create mode 100644 drivers/block/rsxx/rsxx_priv.h
 delete mode 100644 drivers/block/xd.c
 delete mode 100644 drivers/block/xd.h

-- 
Jens Axboe

