Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaIGXEJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 19:04:09 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:51141 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaIGXEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 19:04:07 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHSET block/for-3.18] block, bdi: various cleanups
Date: Mon,  8 Sep 2014 08:03:55 +0900
Message-Id: <1410131041-1881-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset contains the following six bdi related cleanup patches.
Each patch should be fairly self-explanatory.

 0001-block-bdi-an-active-gendisk-always-has-a-request_que.patch
 0002-bdi-remove-unused-stuff.patch
 0003-bdi-remove-bdi-wb_lock-locking-around-bdi-dev-cleari.patch
 0004-bdi-make-backing_dev_info-wb.dwork-canceling-stricte.patch
 0005-bdi-explain-the-dirty-list-transferring-in-bdi_destr.patch
 0006-bdi-reimplement-bdev_inode_switch_bdi.patch

The patchset is on top of 7d1311b93e58 ("Linux 3.17-rc1") and also
available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-bdi-cleanups

diffstat follows.  Thanks.

 block/blk-core.c            |   10 +++-------
 block/compat_ioctl.c        |    4 ----
 block/ioctl.c               |    4 ----
 fs/block_dev.c              |   34 +++++++++++-----------------------
 fs/btrfs/disk-io.c          |    2 +-
 fs/xfs/xfs_buf.c            |    2 --
 include/linux/backing-dev.h |    4 ----
 include/linux/blkdev.h      |    2 +-
 mm/backing-dev.c            |   40 ++++++++++++++++------------------------
 9 files changed, 32 insertions(+), 70 deletions(-)

--
tejun
