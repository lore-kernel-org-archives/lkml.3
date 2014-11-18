Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbaKRIim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:38:42 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:46247 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbaKRIhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:37:47 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/10] writeback: move inode_to_bdi() to include/linux/backing-dev.h
Date: Tue, 18 Nov 2014 03:37:28 -0500
Message-Id: <1416299848-22112-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416299848-22112-1-git-send-email-tj@kernel.org>
References: <1416299848-22112-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inode_to_bdi() will be used by inline functions for the planned cgroup
writeback support.  Move it to include/linux/backing-dev.h.

This patch doesn't introduce any behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c           | 10 ----------
 include/linux/backing-dev.h | 10 ++++++++++
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 41c9f1e..5130895 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -66,16 +66,6 @@ int writeback_in_progress(struct backing_dev_info *bdi)
 }
 EXPORT_SYMBOL(writeback_in_progress);
 
-static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
-{
-	struct super_block *sb = inode->i_sb;
-
-	if (sb_is_blkdev_sb(sb))
-		return inode->i_mapping->backing_dev_info;
-
-	return sb->s_bdi;
-}
-
 static inline struct inode *wb_inode(struct list_head *head)
 {
 	return list_entry(head, struct inode, i_wb_list);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 918f5c9..3c6fd34 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -253,4 +253,14 @@ static inline int bdi_sched_wait(void *word)
 	return 0;
 }
 
+static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+
+	if (sb_is_blkdev_sb(sb))
+		return inode->i_mapping->backing_dev_info;
+
+	return sb->s_bdi;
+}
+
 #endif		/* _LINUX_BACKING_DEV_H */
-- 
1.9.3

