Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966261Ab3E2NuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:50:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:26966 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759565Ab3E2NuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:50:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,764,1363158000"; 
   d="scan'208";a="321320722"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH] writeback: make local functions as static
Date: Wed, 29 May 2013 21:49:38 +0800
Message-Id: <1369835379-5389-1-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions not used globally should be static.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/fs-writeback.c         |    7 +++----
 include/linux/writeback.h |    5 -----
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3be5718..1d66062 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -719,7 +719,7 @@ static long __writeback_inodes_wb(struct bdi_writeback *wb,
 	return wrote;
 }
 
-long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
+static long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
 				enum wb_reason reason)
 {
 	struct wb_writeback_work work = {
@@ -959,7 +959,7 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
 /*
  * Retrieve work items and do the writeback they describe
  */
-long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
+static long wb_do_writeback(struct bdi_writeback *wb, int force_wait)
 {
 	struct backing_dev_info *bdi = wb->bdi;
 	struct wb_writeback_work *work;
@@ -1269,7 +1269,7 @@ static void wait_sb_inodes(struct super_block *sb)
  * on how many (if any) will be written, and this function does not wait
  * for IO completion of submitted IO.
  */
-void writeback_inodes_sb_nr(struct super_block *sb,
+static void writeback_inodes_sb_nr(struct super_block *sb,
 			    unsigned long nr,
 			    enum wb_reason reason)
 {
@@ -1289,7 +1289,6 @@ void writeback_inodes_sb_nr(struct super_block *sb,
 	bdi_queue_work(sb->s_bdi, &work);
 	wait_for_completion(&done);
 }
-EXPORT_SYMBOL(writeback_inodes_sb_nr);
 
 /**
  * writeback_inodes_sb	-	writeback dirty inodes from given super_block
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 579a500..ba3de47 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -86,15 +86,10 @@ struct writeback_control {
 struct bdi_writeback;
 int inode_wait(void *);
 void writeback_inodes_sb(struct super_block *, enum wb_reason reason);
-void writeback_inodes_sb_nr(struct super_block *, unsigned long nr,
-							enum wb_reason reason);
 int try_to_writeback_inodes_sb(struct super_block *, enum wb_reason reason);
 int try_to_writeback_inodes_sb_nr(struct super_block *, unsigned long nr,
 				  enum wb_reason reason);
 void sync_inodes_sb(struct super_block *);
-long writeback_inodes_wb(struct bdi_writeback *wb, long nr_pages,
-				enum wb_reason reason);
-long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
 void wakeup_flusher_threads(long nr_pages, enum wb_reason reason);
 void inode_wait_for_writeback(struct inode *inode);
 
-- 
1.7.9.5

