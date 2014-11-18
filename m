Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaKRIhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:37:37 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:43462 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbaKRIhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:37:34 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz
Subject: [PATCHSET block/for-next] writeback: prepare for cgroup writeback support
Date: Tue, 18 Nov 2014 03:37:18 -0500
Message-Id: <1416299848-22112-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset contains the following 10 prepatory patches for cgroup
writeback support.  None of these patches introduces behavior changes.

 0001-writeback-move-backing_dev_info-state-into-bdi_write.patch
 0002-writeback-move-backing_dev_info-bdi_stat-into-bdi_wr.patch
 0003-writeback-move-bandwidth-related-fields-from-backing.patch
 0004-writeback-move-backing_dev_info-wb_lock-and-worklist.patch
 0005-writeback-move-lingering-dirty-IO-lists-transfer-fro.patch
 0006-writeback-reorganize-mm-backing-dev.c.patch
 0007-writeback-separate-out-include-linux-backing-dev-def.patch
 0008-writeback-cosmetic-change-in-account_page_dirtied.patch
 0009-writeback-add-gfp-to-wb_init.patch
 0010-writeback-move-inode_to_bdi-to-include-linux-backing.patch

0001-0005 move writeback related fields from bdi (backing_dev_info) to
wb (bdi_writeback).  Currently, one bdi embeds one wb and the
separation between the two is blurry.  bdi's lock protects wb's fields
and fields which are closely related are scattered across the two.
These five patches move all fields which are used during writeback
into wb.

0006-0010 are misc prep patches.  They're all rather trivial and each
is self-explanatory.

This patchset is on top of the current block/for-next eb494facbee2
("5748c0fce0fd40c87d164d6bee61") and is available in the following git
branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-cgroup-writeback-wb-prep

diffstat follows.  Thanks.

 block/blk-core.c                 |    1 
 block/blk-integrity.c            |    1 
 block/blk-sysfs.c                |    1 
 block/bounce.c                   |    1 
 block/genhd.c                    |    1 
 drivers/block/drbd/drbd_int.h    |    1 
 drivers/block/drbd/drbd_main.c   |   10 -
 drivers/block/pktcdvd.c          |    1 
 drivers/char/raw.c               |    1 
 drivers/md/bcache/request.c      |    1 
 drivers/md/dm.c                  |    2 
 drivers/md/dm.h                  |    1 
 drivers/md/md.h                  |    1 
 drivers/md/raid1.c               |    4 
 drivers/md/raid10.c              |    2 
 drivers/mtd/devices/block2mtd.c  |    1 
 fs/block_dev.c                   |    1 
 fs/ext4/extents.c                |    1 
 fs/ext4/mballoc.c                |    1 
 fs/f2fs/node.c                   |    2 
 fs/f2fs/segment.h                |    1 
 fs/fs-writeback.c                |  121 ++++++---------
 fs/fuse/file.c                   |   12 -
 fs/gfs2/super.c                  |    2 
 fs/hfs/super.c                   |    1 
 fs/hfsplus/super.c               |    1 
 fs/nfs/filelayout/filelayout.c   |    5 
 fs/nfs/write.c                   |   11 -
 fs/reiserfs/super.c              |    1 
 fs/ufs/super.c                   |    1 
 include/linux/backing-dev-defs.h |  105 +++++++++++++
 include/linux/backing-dev.h      |  174 +++++-----------------
 include/linux/blkdev.h           |    2 
 include/linux/writeback.h        |   19 +-
 include/trace/events/writeback.h |    8 -
 mm/backing-dev.c                 |  306 +++++++++++++++++++--------------------
 mm/filemap.c                     |    2 
 mm/madvise.c                     |    1 
 mm/page-writeback.c              |  304 +++++++++++++++++++-------------------
 mm/truncate.c                    |    4 
 40 files changed, 570 insertions(+), 546 deletions(-)

--
tejun
