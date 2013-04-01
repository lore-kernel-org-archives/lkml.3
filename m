Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab3DAG7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:59:12 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62386 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757942Ab3DAG47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:56:59 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-9c-51592fb9a702
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 3/9] f2fs: remove redundant lock_page calls
Date: Mon, 01 Apr 2013 15:55:54 +0900
Message-id: <1364799360-23145-3-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t8zfd2d+pGBBh/vcVtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAldG7awJLwUWZirtr
	pzI1MH4T62Lk5JAQMJF48nMnO4QtJnHh3nq2LkYuDiGBZYwSf48sZYEp+r7xIjNEYhGjxLaz
	K9khnDYmiUtXNwG1cHCwCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9B5skLGAtcX5pMxuI
	zSKgKvF0/TKw1bwC7hK/H8xghNimK7H6/3OwOKeAh8Tnto9gvUJANaf2rQY7T0LgO5vEk92/
	mSAGCUh8m3yIBeQICQFZiU0HmCHmSEocXHGDZQKj8AJGhlWMoqkFyQXFSelFxnrFibnFpXnp
	esn5uZsYIUHbv4Px7gHrQ4zJQOMmMkuJJucDgz6vJN7Q2MzIwtTE1NjI3NKMNGElcV61FutA
	IYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyL7zLe91TZ6ro4KjAitTHhobedDWfetH/zqhu3
	zAs6fnTZlQCj02nvW1bMKHMxvh27SVXvsMoZ12e399ry2grcf/HIheHCRF+rsEw3s0N/7x5f
	u9RgyrfJ9x98eJotX/JBM26ryoL6vPa7sx5/+PJ6plTE9Qs7BT5yTt5htzEza2rUWetGg2uV
	SizFGYmGWsxFxYkAoRGLoXACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAd2d+pGBBuvWsFtc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jRu2sCS8FFmYq7a6cyNTB+E+ti5OSQEDCR+L7xIjOELSZx4d56ti5GLg4h
	gUWMEtvOrmSHcNqYJC5d3QSU4eBgE9CW2LzfAKRBRIBZYsHU84wgNcwCExgl/i96zwKSEBaw
	lji/tJkNxGYRUJV4un4ZO4jNK+Au8fvBDEaIbboSq/8/B4tzCnhIfG77CNYrBFRzat9qtgmM
	vAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfEM+kdjKsaLA4xCnAwKvHwRlyICBRi
	TSwrrsw9xCjBwawkwuvzDSjEm5JYWZValB9fVJqTWnyIMRnoqonMUqLJ+cB4zSuJNzQ2MTOy
	NDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxt5QN/s52edPJxt2zPde+SVT
	9dfzKcf6k3+l7PHllyzo37NcPPWH++2zc6cyx1roW7KKuGo5r3uY1HJX5/////KGP1wjatj5
	NF/UaUrvX5/xv8D674z1qUdmSGpPTGd8US7sXfxy8pVHQj92FS/lXFWT82neDeG7x3/fEMx5
	ZPxE7GyiQH9KjRJLcUaioRZzUXEiAElhSPXNAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In get_node_page, we do not need to call lock_page all the time.

If the node page is cached as uptodate,

1. grab_cache_page locks the page,
2. read_node_page unlocks the page, and
3. lock_page is called for further process.

Let's avoid this.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 63 +++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 10cbee9..c5360b7 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -847,32 +847,13 @@ fail:
 	return ERR_PTR(err);
 }
 
-static int read_node_page(struct page *page, int type)
-{
-	struct f2fs_sb_info *sbi = F2FS_SB(page->mapping->host->i_sb);
-	struct node_info ni;
-
-	get_node_info(sbi, page->index, &ni);
-
-	if (ni.blk_addr == NULL_ADDR) {
-		f2fs_put_page(page, 1);
-		return -ENOENT;
-	}
-
-	if (PageUptodate(page)) {
-		unlock_page(page);
-		return 0;
-	}
-
-	return f2fs_readpage(sbi, page, ni.blk_addr, type);
-}
-
 /*
  * Readahead a node page
  */
 void ra_node_page(struct f2fs_sb_info *sbi, nid_t nid)
 {
 	struct address_space *mapping = sbi->node_inode->i_mapping;
+	struct node_info ni;
 	struct page *apage;
 
 	apage = find_get_page(mapping, nid);
@@ -886,22 +867,40 @@ void ra_node_page(struct f2fs_sb_info *sbi, nid_t nid)
 	if (!apage)
 		return;
 
-	if (read_node_page(apage, READA) == 0)
+	get_node_info(sbi, nid, &ni);
+
+	if (ni.blk_addr == NULL_ADDR || PageUptodate(apage)) {
+		f2fs_put_page(apage, 1);
+		return;
+	}
+
+	if (f2fs_readpage(sbi, apage, ni.blk_addr, READA) == 0)
 		f2fs_put_page(apage, 0);
 	return;
 }
 
 struct page *get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid)
 {
-	int err;
-	struct page *page;
 	struct address_space *mapping = sbi->node_inode->i_mapping;
+	struct page *page;
+	struct node_info ni;
+	int err;
 
 	page = grab_cache_page(mapping, nid);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
-	err = read_node_page(page, READ_SYNC);
+	get_node_info(sbi, nid, &ni);
+
+	if (ni.blk_addr == NULL_ADDR) {
+		f2fs_put_page(page, 1);
+		return ERR_PTR(-ENOENT);
+	}
+
+	if (PageUptodate(page))
+		goto got_it;
+
+	err = f2fs_readpage(sbi, page, ni.blk_addr, READ_SYNC);
 	if (err)
 		return ERR_PTR(err);
 
@@ -910,6 +909,7 @@ struct page *get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid)
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-EIO);
 	}
+got_it:
 	BUG_ON(nid != nid_of_node(page));
 	mark_page_accessed(page);
 	return page;
@@ -923,6 +923,7 @@ struct page *get_node_page_ra(struct page *parent, int start)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(parent->mapping->host->i_sb);
 	struct address_space *mapping = sbi->node_inode->i_mapping;
+	struct node_info ni;
 	int i, end;
 	int err = 0;
 	nid_t nid;
@@ -936,10 +937,18 @@ struct page *get_node_page_ra(struct page *parent, int start)
 	page = grab_cache_page(mapping, nid);
 	if (!page)
 		return ERR_PTR(-ENOMEM);
-	else if (PageUptodate(page))
+
+	get_node_info(sbi, nid, &ni);
+
+	if (ni.blk_addr == NULL_ADDR) {
+		f2fs_put_page(page, 1);
+		return ERR_PTR(-ENOENT);
+	}
+
+	if (PageUptodate(page))
 		goto page_hit;
 
-	err = read_node_page(page, READ_SYNC);
+	err = f2fs_readpage(sbi, page, ni.blk_addr, READ_SYNC);
 	if (err)
 		return ERR_PTR(err);
 
@@ -956,7 +965,7 @@ struct page *get_node_page_ra(struct page *parent, int start)
 	lock_page(page);
 
 page_hit:
-	if (PageError(page)) {
+	if (!PageUptodate(page)) {
 		f2fs_put_page(page, 1);
 		return ERR_PTR(-EIO);
 	}
-- 
1.8.1.3.566.gaa39828

