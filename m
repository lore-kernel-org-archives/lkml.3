Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaBEFiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 00:38:15 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:54004 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaBEFiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 00:38:08 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-ea-52f1ce3ee5d8
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: fix f2fs_write_meta_page at no checkpoint status
Date: Wed, 05 Feb 2014 14:36:35 +0900
Message-id: <1391578595-854-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
In-reply-to: <1391578595-854-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1391578595-854-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zY127cx+DDB79F7W4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK+PGpH+sBeuFK3Zv
	6mVvYLzB38XIySEhYCIx9/5TVghbTOLCvfVsXYxcHEICyxglHl29yAxT9OLlfVaIxCJGiQNX
	NzFCOE1MEl1PnwJVcXCwCWhLbN5vANIgIsAssWDqebAaZoEJjBL/F71nAUkIC3hLHNr3BWwq
	i4CqxPSdB5lAbF4BV4m/s66xQGzTltj2fCIjiM0p4CZxoGc3C8h8IaCamctLQGZKCPxmk9j1
	9Bc7xBwBiW+TD4HVSAjISmw6AHW0pMTBFTdYJjAKL2BkWMUomlqQXFCclF5kqlecmFtcmpeu
	l5yfu4kRErITdzDeP2B9iDEZaNxEZinR5HxgyOeVxBsamxlZmJqYGhuZW5qRJqwkzpv+KClI
	SCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+OE7Eu7mtsjbrp+ce+bflHq+6yDy+4w2s1Qr3a7
	+2OL2bRdFrY3Lnx0PMdv4b/f/E6+YFS4T01wvuyHYqHKKVcWFVzg4L1l/v65mVwGz7NZC9/O
	3y64k+uOlJUgY8EiuRy2xKlTV3PPnpLyT25zzMGnXz969FUzv9h4y5jlX66fp4LFbb8HepVK
	LMUZiYZazEXFiQBSxcRMbwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAV27cx+DDJYdE7K4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjHjxqR/rAXrhSt2b+plb2C8wd/FyMkhIWAi8eLlfVYIW0ziwr31bF2MXBxC
	AosYJQ5c3cQI4TQxSXQ9fcrcxcjBwSagLbF5vwFIg4gAs8SCqefBapgFJjBK/F/0ngUkISzg
	LXFo3xdmEJtFQFVi+s6DTCA2r4CrxN9Z11ggtmlLbHs+kRHE5hRwkzjQs5sFZL4QUM3M5SUT
	GHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOiGdSOxhXNlgcYhTgYFTi4TUQ/hgk
	xJpYVlyZe4hRgoNZSYQ3sRsoxJuSWFmVWpQfX1Sak1p8iDEZ6KiJzFKiyfnAaM0riTc0NjEz
	sjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBkbPSfeZ489++fto0kz13Ypi
	JtbCoU2ifbmmL43+8Brfb1m58nvOhasS+tHem/pWPG3KvXtBJL76v4mot5P2S92EL3tOSjac
	XyR1JnC+v0tOqawmyxPJJj3fRZHXf4UKJp/MYfQt2Cn9yXqCbZ2y2OOph44sX5J77t6Lj7Ff
	mWuk9u1b+Ch0SbESS3FGoqEWc1FxIgAuahS3zAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If f2fs entered errorneous checkpoint status, it should skip writing meta
pages instead of redirtying the pages out.
Otherwise, it cannot unmount the partition even though f2fs is under read-only
status.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c | 29 +++++++++++++++++++++--------
 fs/f2fs/gc.c         |  2 ++
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 293d048..8f5dff1 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -81,17 +81,18 @@ static int f2fs_write_meta_page(struct page *page,
 	struct inode *inode = page->mapping->host;
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 
-	/* Should not write any meta pages, if any IO error was occurred */
-	if (unlikely(sbi->por_doing ||
-			is_set_ckpt_flags(F2FS_CKPT(sbi), CP_ERROR_FLAG)))
+	if (unlikely(sbi->por_doing))
 		goto redirty_out;
-
 	if (wbc->for_reclaim)
 		goto redirty_out;
 
-	wait_on_page_writeback(page);
+	/* Should not write any meta pages, if any IO error was occurred */
+	if (unlikely(is_set_ckpt_flags(F2FS_CKPT(sbi), CP_ERROR_FLAG)))
+		goto no_write;
 
+	wait_on_page_writeback(page);
 	write_meta_page(sbi, page);
+no_write:
 	dec_page_count(sbi, F2FS_DIRTY_META);
 	unlock_page(page);
 	return 0;
@@ -148,10 +149,22 @@ long sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
 
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
+
 			lock_page(page);
-			f2fs_bug_on(page->mapping != mapping);
-			f2fs_bug_on(!PageDirty(page));
-			clear_page_dirty_for_io(page);
+
+			if (unlikely(page->mapping != mapping)) {
+continue_unlock:
+				unlock_page(page);
+				continue;
+			}
+			if (!PageDirty(page)) {
+				/* someone wrote it for us */
+				goto continue_unlock;
+			}
+
+			if (!clear_page_dirty_for_io(page))
+				goto continue_unlock;
+
 			if (f2fs_write_meta_page(page, &wbc)) {
 				unlock_page(page);
 				break;
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index ea0371e..b0f5762 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -701,6 +701,8 @@ int f2fs_gc(struct f2fs_sb_info *sbi)
 gc_more:
 	if (unlikely(!(sbi->sb->s_flags & MS_ACTIVE)))
 		goto stop;
+	if (unlikely(is_set_ckpt_flags(F2FS_CKPT(sbi), CP_ERROR_FLAG)))
+		goto stop;
 
 	if (gc_type == BG_GC && has_not_enough_free_secs(sbi, nfree)) {
 		gc_type = FG_GC;
-- 
1.8.4.474.g128a96c

