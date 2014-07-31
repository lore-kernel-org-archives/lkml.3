Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbaGaG1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:27:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:56703 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269AbaGaG1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:27:41 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] f2fs: fix coding style
Date: Wed, 30 Jul 2014 23:28:04 -0700
Message-Id: <1406788084-11274-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes wrong coding style.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/f2fs.h | 2 +-
 fs/f2fs/file.c | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 14b9f74..80c7869 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -781,7 +781,7 @@ static inline void *__bitmap_ptr(struct f2fs_sb_info *sbi, int flag)
 		if (flag == NAT_BITMAP)
 			return &ckpt->sit_nat_version_bitmap;
 		else
-			return ((unsigned char *)ckpt + F2FS_BLKSIZE);
+			return (unsigned char *)ckpt + F2FS_BLKSIZE;
 	} else {
 		offset = (flag == NAT_BITMAP) ?
 			le32_to_cpu(ckpt->sit_ver_bitmap_bytesize) : 0;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 9550135..2a91a7d 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -231,8 +231,9 @@ static pgoff_t __get_first_dirty_index(struct address_space *mapping,
 
 	/* find first dirty page index */
 	pagevec_init(&pvec, 0);
-	nr_pages = pagevec_lookup_tag(&pvec, mapping, &pgofs, PAGECACHE_TAG_DIRTY, 1);
-	pgofs = nr_pages ? pvec.pages[0]->index: LONG_MAX;
+	nr_pages = pagevec_lookup_tag(&pvec, mapping, &pgofs,
+					PAGECACHE_TAG_DIRTY, 1);
+	pgofs = nr_pages ? pvec.pages[0]->index : LONG_MAX;
 	pagevec_release(&pvec);
 	return pgofs;
 }
-- 
1.8.5.2 (Apple Git-48)

