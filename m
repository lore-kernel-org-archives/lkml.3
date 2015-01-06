Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756677AbbAFTaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:30:05 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:49828 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653AbbAFT3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:29:52 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org,
        hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com,
        lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, Tejun Heo <tj@kernel.org>
Subject: [PATCH 16/16] writeback: move inode_to_bdi() to include/linux/backing-dev.h
Date: Tue,  6 Jan 2015 14:29:17 -0500
Message-Id: <1420572557-11572-17-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420572557-11572-1-git-send-email-tj@kernel.org>
References: <1420572557-11572-1-git-send-email-tj@kernel.org>
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
2.1.0

