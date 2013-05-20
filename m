Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab3ETDdp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 23:33:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41635 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab3ETDdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 23:33:41 -0400
X-AuditID: cbfee690-b7efc6d000006d92-16-5199998e25ae
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 07/15] f2fs: change get_new_data_page to pass a locked node page
Date: Mon, 20 May 2013 12:32:21 +0900
Message-id: <1369020743-18520-7-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1369020743-18520-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1369020743-18520-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zA92+mTMDDTZeN7S4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2PRX4eCFVIVu963
	MDUwXhXtYuTgkBAwkZh20raLkRPIFJO4cG89WxcjF4eQwDJGiY9/v7JDJEwkLl9+BZVYxCgx
	Z8V0ZginjUliY8MRNpBJbALaEpv3G4A0iAgwSyyYep4RpIZZYAKjxP9F71lAEsICARK7np1i
	BbFZBFQllm/8B7aBV8Bd4seBTWwQ23QlVv9/DhbnFPCQ2Hr3FCPIfCGgmtfnSkBmSgh8ZpN4
	0juJHWKOgMS3yYdYIL6Rldh0gBlijKTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKJXnJhbXJqX
	rpecn7uJERKuE3Yw3jtgfYgxGWjcRGYp0eR8YLjnlcQbGpsZWZiamBobmVuakSasJM6r3mId
	KCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHRa9ZhT7M137Z9zJ0a9GZWZ3Kf7d5PMwXylF+V
	Pf15+Mk9g7xDPzf8V/G5P7Wqctf7PxVy3DszsluXHpzae3V1pN6mL1L3g/Ymz2Pr+2b9PphH
	geGzGy9fZInTpZev3Z8wlC6UetPzYPl+9aP3TdKfCzw9EvH0pFDRo6zAXUwywmsztu2b8X6l
	khJLcUaioRZzUXEiAFYk3V9tAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAd2+mTMDDZbf0LW4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjFj0V+HghVSFbvetzA1MF4V7WLk5JAQMJG4fPkVG4QtJnHh3nogm4tDSGAR
	o8ScFdOZIZw2JomNDUeAMhwcbALaEpv3G4A0iAgwSyyYep4RpIZZYAKjxP9F71lAEsICARK7
	np1iBbFZBFQllm/8xw5i8wq4S/w4sAlqm67E6v/PweKcAh4SW++eYgSZLwRU8/pcyQRG3gWM
	DKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxguPhmfQOxlUNFocYBTgYlXh4BQJmBgqxJpYV
	V+YeYpTgYFYS4Y3uBgrxpiRWVqUW5ccXleakFh9iTAY6aiKzlGhyPjBW80riDY1NzIwsjcws
	jEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB0e1e0IQlgd2xbbe2tD/esErvk+g0
	XcFK373Fua2ySWEeEXfXtD88arTthLamnZQib35cKEtodI7I2YlPQmfti71olqPWENdudyD8
	oYSPwbbNW31jtv45zM9bp1/NYrLV5PPZBWtjj1xccnXth8DN91bMnRr+7JbQC5tM5S/FF7Sn
	Pu/mPp/2WYmlOCPRUIu5qDgRAGECmHfLAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is for passing a locked node page to get_dnode_of_data.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 12 +++++++-----
 fs/f2fs/dir.c  |  4 ++--
 fs/f2fs/f2fs.h |  2 +-
 fs/f2fs/file.c |  2 +-
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 05fb5c6..af74549 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -280,8 +280,8 @@ repeat:
  * Also, caller should grab and release a mutex by calling mutex_lock_op() and
  * mutex_unlock_op().
  */
-struct page *get_new_data_page(struct inode *inode, pgoff_t index,
-						bool new_i_size)
+struct page *get_new_data_page(struct inode *inode,
+		struct page *npage, pgoff_t index, bool new_i_size)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	struct address_space *mapping = inode->i_mapping;
@@ -289,18 +289,20 @@ struct page *get_new_data_page(struct inode *inode, pgoff_t index,
 	struct dnode_of_data dn;
 	int err;
 
-	set_new_dnode(&dn, inode, NULL, NULL, 0);
+	set_new_dnode(&dn, inode, npage, npage, 0);
 	err = get_dnode_of_data(&dn, index, ALLOC_NODE);
 	if (err)
 		return ERR_PTR(err);
 
 	if (dn.data_blkaddr == NULL_ADDR) {
 		if (reserve_new_block(&dn)) {
-			f2fs_put_dnode(&dn);
+			if (!npage)
+				f2fs_put_dnode(&dn);
 			return ERR_PTR(-ENOSPC);
 		}
 	}
-	f2fs_put_dnode(&dn);
+	if (!npage)
+		f2fs_put_dnode(&dn);
 repeat:
 	page = grab_cache_page(mapping, index);
 	if (!page)
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 1ac6b93..7db6e58 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -287,7 +287,7 @@ static int make_empty_dir(struct inode *inode, struct inode *parent)
 	struct f2fs_dir_entry *de;
 	void *kaddr;
 
-	dentry_page = get_new_data_page(inode, 0, true);
+	dentry_page = get_new_data_page(inode, NULL, 0, true);
 	if (IS_ERR(dentry_page))
 		return PTR_ERR(dentry_page);
 
@@ -448,7 +448,7 @@ start:
 	bidx = dir_block_index(level, (le32_to_cpu(dentry_hash) % nbucket));
 
 	for (block = bidx; block <= (bidx + nblock - 1); block++) {
-		dentry_page = get_new_data_page(dir, block, true);
+		dentry_page = get_new_data_page(dir, NULL, block, true);
 		if (IS_ERR(dentry_page))
 			return PTR_ERR(dentry_page);
 
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index ef6cac8..cbae2b6 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1027,7 +1027,7 @@ int reserve_new_block(struct dnode_of_data *);
 void update_extent_cache(block_t, struct dnode_of_data *);
 struct page *find_data_page(struct inode *, pgoff_t, bool);
 struct page *get_lock_data_page(struct inode *, pgoff_t);
-struct page *get_new_data_page(struct inode *, pgoff_t, bool);
+struct page *get_new_data_page(struct inode *, struct page *, pgoff_t, bool);
 int f2fs_readpage(struct f2fs_sb_info *, struct page *, block_t, int);
 int do_write_data_page(struct page *);
 
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 1cae864..b8e34db 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -387,7 +387,7 @@ static void fill_zero(struct inode *inode, pgoff_t index,
 	f2fs_balance_fs(sbi);
 
 	ilock = mutex_lock_op(sbi);
-	page = get_new_data_page(inode, index, false);
+	page = get_new_data_page(inode, NULL, index, false);
 	mutex_unlock_op(sbi, ilock);
 
 	if (!IS_ERR(page)) {
-- 
1.8.1.3.566.gaa39828

