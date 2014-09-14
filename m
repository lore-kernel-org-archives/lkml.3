Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaINKSw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 06:18:52 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:58462 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaINKSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 06:18:47 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-nilfs <linux-nilfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Andreas Rohner <andreas.rohner@gmx.net>
Subject: [PATCH 0/1] nilfs2: fix device cache flush in nilfs_sync_fs()
Date: Sun, 14 Sep 2014 19:11:43 +0900
Message-Id: <1410689504-10032-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.7.9.4
X-Dispatcher: imput version 20110525(IM151)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Please add the following patch to the queue for the next merge window.

It ensures that nilfs_sync_fs() function sends a cache flush request
to the underlying device when required.  The current nilfs_sync_fs()
has a defect that it can skip the flush if only a small amount of data
is written.  The original cover letter can be seen at:

[1] http://marc.info/?l=linux-nilfs&m=141061909728506
    "[PATCH v6 0/1] nilfs2: add missing blkdev_issue_flush() to
    nilfs_sync_fs()"

Thanks,
Ryusuke Konishi
--
Andreas Rohner (1):
      nilfs2: add missing blkdev_issue_flush() to nilfs_sync_fs()

 fs/nilfs2/file.c      |    8 +++-----
 fs/nilfs2/ioctl.c     |    8 +++-----
 fs/nilfs2/segment.c   |    3 +++
 fs/nilfs2/super.c     |    6 ++++++
 fs/nilfs2/the_nilfs.h |   22 ++++++++++++++++++++++
 5 files changed, 37 insertions(+), 10 deletions(-)

