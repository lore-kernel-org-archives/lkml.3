Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405Ab3LEBzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 20:55:04 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31689 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228Ab3LEBzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 20:55:01 -0500
X-AuditID: cbfee61b-b7f006d000003e1f-76-529fdceffd7f
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH 1/3] f2fs: use inner macro GFP_F2FS_ZERO for
 simplification
Date: Thu, 05 Dec 2013 09:54:00 +0800
Message-id: <001601cef15c$fd1a7d60$f74f7820$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7xViD0C5aBsyeWR8eoQBusHIUMVQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAd33d+YHGWy7KmxxfddfJotLi9wt
	9uw9yWJxedccNovWheeZHVg9di/4zOTRt2UVo8fnTXIBzFFcNimpOZllqUX6dglcGf/WzGcv
	uM1Tse/hbdYGxhVcXYwcHBICJhJPXip3MXICmWISF+6tZ+ti5OIQEljEKLF0xhUo5wejxIbJ
	HWwgVWwCKhLLO/4zgdgiAooSG95vYAcpYhaYwShxeO4/VpCEsECExOR57xhBbBYBVYmrn3ex
	gGzjFbCU+HY7BSTMKyAo8WPyPRYQm1lAQ6J/0QY2CFteYvOat8wQFylI7Dj7mhFil57E1f2T
	oGrEJTYeucUygVFgFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525i
	BIf0M+kdjKsaLA4xCnAwKvHwvkicHyTEmlhWXJl7iFGCg1lJhLf+KlCINyWxsiq1KD++qDQn
	tfgQozQHi5I478FW60AhgfTEktTs1NSC1CKYLBMHp1QDY2vFw4kzTsXd6lzkEHywtffQ8/5p
	zye8MYg4arnirYDB3xP+gimne4Q8JzX+rZ3sxuhVcyH55OsLFr45Ho9KX7r3cOvnNIptk570
	MFwlOXvjcYviiRofmp8dUHY52SqkvnNjC0OhwqSITum+MzmK6Ww6X42SV+VEvNzSs7zPu3uh
	wLYCJdUPSizFGYmGWsxFxYkAKolfyGUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use inner macro GFP_F2FS_ZERO to instead of GFP_NOFS | __GFP_ZERO for
simplification of code.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/node.c     |    2 +-
 fs/f2fs/recovery.c |    2 +-
 fs/f2fs/super.c    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 0855168..099f06f 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1577,7 +1577,7 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
 
 	for (; page_idx < start + nrpages; page_idx++) {
 		/* alloc temporal page for read node summary info*/
-		page = alloc_page(GFP_NOFS | __GFP_ZERO);
+		page = alloc_page(GFP_F2FS_ZERO);
 		if (!page) {
 			struct page *tmp;
 			list_for_each_entry_safe(page, tmp, pages, lru) {
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index c209b86..7dda1f28 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -377,7 +377,7 @@ static int recover_data(struct f2fs_sb_info *sbi,
 	blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
 
 	/* read node page */
-	page = alloc_page(GFP_NOFS | __GFP_ZERO);
+	page = alloc_page(GFP_F2FS_ZERO);
 	if (!page)
 		return -ENOMEM;
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index dd55074..22b07c3 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -332,7 +332,7 @@ static struct inode *f2fs_alloc_inode(struct super_block *sb)
 {
 	struct f2fs_inode_info *fi;
 
-	fi = kmem_cache_alloc(f2fs_inode_cachep, GFP_NOFS | __GFP_ZERO);
+	fi = kmem_cache_alloc(f2fs_inode_cachep, GFP_F2FS_ZERO);
 	if (!fi)
 		return NULL;
 
-- 
1.7.9.5

