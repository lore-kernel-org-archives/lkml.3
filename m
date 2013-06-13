Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab3FMJAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 05:00:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:44392 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932688Ab3FMJAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 05:00:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,857,1363158000"; 
   d="scan'208";a="349193855"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH 2/3] f2fs: make locate_dirty_segment() as static
Date: Thu, 13 Jun 2013 16:59:28 +0800
Message-Id: <1371113969-946-3-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371113969-946-1-git-send-email-haicheng.li@linux.intel.com>
References: <1371113969-946-1-git-send-email-haicheng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's used only locally and could be static.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/f2fs/f2fs.h    |    1 -
 fs/f2fs/segment.c |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index a05aa65..3e7cb33 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -996,7 +996,6 @@ void destroy_node_manager_caches(void);
  */
 void f2fs_balance_fs(struct f2fs_sb_info *);
 void invalidate_blocks(struct f2fs_sb_info *, block_t);
-void locate_dirty_segment(struct f2fs_sb_info *, unsigned int);
 void clear_prefree_segments(struct f2fs_sb_info *);
 int npages_for_summary_flush(struct f2fs_sb_info *);
 void allocate_new_segments(struct f2fs_sb_info *);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 77f31c0..b15debc 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -94,7 +94,7 @@ static void __remove_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno,
  * Adding dirty entry into seglist is not critical operation.
  * If a given segment is one of current working segments, it won't be added.
  */
-void locate_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno)
+static void locate_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno)
 {
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
 	unsigned short valid_blocks;
-- 
1.7.9.5

