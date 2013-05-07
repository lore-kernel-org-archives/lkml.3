Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab3EGTRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 15:17:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54893 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3EGTRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 15:17:10 -0400
Date: Tue, 7 May 2013 20:17:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] more vfs.git stuff
Message-ID: <20130507191708.GQ25399@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of fixes + getting rid of __blkdev_put() return value.
Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
Shortlog:
Al Viro (4):
      hfs: SMP race on directory close()
      mtd_blktrans_ops->release() should return void
      block_device_operations->release() should return void
      make blkdev_put() return void

Geert Uytterhoeven (1):
      proc: Use PDE attribute setting accessor functions

Diffstat:
 arch/arm/mach-msm/last_radio_log.c  |    2 +-
 arch/cris/kernel/profile.c          |    2 +-
 arch/um/drivers/ubd_kern.c          |    5 ++---
 arch/xtensa/platforms/iss/simdisk.c |    3 +--
 drivers/block/amiflop.c             |    3 +--
 drivers/block/aoe/aoeblk.c          |    6 ++----
 drivers/block/ataflop.c             |    5 ++---
 drivers/block/cciss.c               |    5 ++---
 drivers/block/cpqarray.c            |    6 ++----
 drivers/block/drbd/drbd_main.c      |    5 ++---
 drivers/block/floppy.c              |    4 +---
 drivers/block/loop.c                |    6 ++----
 drivers/block/paride/pcd.c          |    3 +--
 drivers/block/paride/pd.c           |    4 +---
 drivers/block/paride/pf.c           |    9 ++++-----
 drivers/block/pktcdvd.c             |    4 +---
 drivers/block/rbd.c                 |    4 +---
 drivers/block/swim.c                |    4 +---
 drivers/block/swim3.c               |    5 ++---
 drivers/block/xen-blkfront.c        |    3 +--
 drivers/block/xsysace.c             |    3 +--
 drivers/block/z2ram.c               |    6 ++----
 drivers/cdrom/gdrom.c               |    3 +--
 drivers/ide/ide-cd.c                |    4 +---
 drivers/ide/ide-gd.c                |    4 +---
 drivers/ide/ide-tape.c              |    4 +---
 drivers/md/dm.c                     |    4 +---
 drivers/md/md.c                     |    4 +---
 drivers/memstick/core/mspro_block.c |    8 +++-----
 drivers/message/i2o/i2o_block.c     |    8 ++------
 drivers/mmc/card/block.c            |    3 +--
 drivers/mtd/mtd_blkdevs.c           |    9 ++++-----
 drivers/mtd/mtdblock.c              |    4 +---
 drivers/mtd/sm_ftl.c                |    3 +--
 drivers/s390/block/dasd.c           |   18 +++++++-----------
 drivers/s390/block/dcssblk.c        |   12 ++++--------
 drivers/s390/block/scm_blk.c        |    3 +--
 drivers/scsi/sd.c                   |    3 +--
 drivers/scsi/sr.c                   |    3 +--
 fs/block_dev.c                      |   16 +++++++---------
 fs/ext3/super.c                     |   11 ++++-------
 fs/ext4/super.c                     |   11 ++++-------
 fs/hfs/dir.c                        |    2 ++
 fs/nfs/blocklayout/blocklayout.h    |    2 +-
 fs/nfs/blocklayout/blocklayoutdev.c |    4 ++--
 fs/nfs/blocklayout/blocklayoutdm.c  |    8 +-------
 fs/reiserfs/journal.c               |   16 +++-------------
 include/linux/blkdev.h              |    2 +-
 include/linux/fs.h                  |    2 +-
 include/linux/mtd/blktrans.h        |    2 +-
 50 files changed, 93 insertions(+), 177 deletions(-)
