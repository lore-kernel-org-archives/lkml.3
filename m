Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568Ab3F0ER5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 00:17:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10837 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab3F0ERc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 00:17:32 -0400
X-AuditID: cbfee68f-b7f436d000000f81-df-51cbbcd9c71c
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 2/2] f2fs: fix to recover i_size from roll-forward
Date: Thu, 27 Jun 2013 13:17:28 +0900
Message-id: <1372306648-26438-2-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
In-reply-to: <1372306648-26438-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1372306648-26438-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zfd2be04HGrxcyG5xfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHMUl01Kak5mWWqRvl0CV8bxGe+ZCjbyVaxe
	9oS9gfENdxcjJ4eEgInE1hO3mCBsMYkL99azdTFycQgJLGOUWNm/jQmm6EbzHBaIxCJGifUN
	ZxghnDYmiVk/O4GqODjYBLQlNu83AGkQEWCWWDD1PFgNs8AERon/i96zgCSEBZwkDrSfYgex
	WQRUJSa8/AYW5xVwl9jb/5kNYpuuxKITB1lBbE4BD4mTXw+B1QgB1dzvhYhLCHxnk7jzgAdi
	joDEt8kgNRxAcVmJTQeYIUokJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJjveLE3OLSvHS95Pzc
	TYyQkO3fwXj3gPUhxmSgcROZpUST84Ehn1cSb2hsZmRhamJqbGRuaUaasJI4r1qLdaCQQHpi
	SWp2ampBalF8UWlOavEhRiYOTqkGRlHWBzM29F9dEyd/YdHN6StPLjXS2stkzjlTK1ar7evd
	49J6b6UfC+u4Tr5sEl7T5q7mqjGRqbY5lGur1vwwDv8nU2Xajv9TOLRk+afFN6d/qZsoV+x3
	eJfgMxfJk/nKP5TjsrvNSnWNzp+c5FyoOu+hUuICfi93jW+ydfNb7rtq2sxqu/h1vhJLcUai
	oRZzUXEiAGm9q/VvAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAd2be04HGnx+ymxxfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtA2JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+
	IUFwPUYGaCBhHWPG8RnvmQo28lWsXvaEvYHxDXcXIyeHhICJxI3mOSwQtpjEhXvr2boYuTiE
	BBYxSqxvOMMI4bQxScz62cnUxcjBwSagLbF5vwFIg4gAs8SCqefBapgFJjBK/F/0HmySsICT
	xIH2U+wgNouAqsSEl9/A4rwC7hJ7+z+zQWzTlVh04iAriM0p4CFx8ushsBohoJr7vQdZJzDy
	LmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHBPPpHYwrmywOMQowMGoxMPrwXI6UIg1
	say4MvcQowQHs5IIb2gOUIg3JbGyKrUoP76oNCe1+BBjMtBVE5mlRJPzgfGaVxJvaGxiZmRp
	ZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MyTrXvwRuanlRseexxfragoWv
	r0769fVFzIt1bxjUNQXD7/r4qPlWr9764eP/rhXxO6Jy6nkfNymbG1letWo4/2fy0usvN9tW
	vunYdVZKU2rR8/WtHU9vNdzf0OHJcPljDqPFtNjdgfn6zneOlfV1q20/xvHoV1x7XW+rdK8f
	T5ju28WXbUsvKLEUZyQaajEXFScCAB7lSZzNAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If user requests many data writes and fsync together, the last updated i_size
should be stored to the inode block consistently.

But, previous write_end just marks the inode as dirty and doesn't update its
metadata into its inode block.
After that, fsync just writes the inode block with newly updated data index
excluding inode metadata updates.

So, this patch introduces write_end in which updates inode block too when the
i_size is changed.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 6d4a743..e88f46f 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -701,6 +701,27 @@ err:
 	return err;
 }
 
+static int f2fs_write_end(struct file *file,
+			struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
+{
+	struct inode *inode = page->mapping->host;
+
+	SetPageUptodate(page);
+	set_page_dirty(page);
+
+	if (pos + copied > i_size_read(inode)) {
+		i_size_write(inode, pos + copied);
+		mark_inode_dirty(inode);
+		update_inode_page(inode);
+	}
+
+	unlock_page(page);
+	page_cache_release(page);
+	return copied;
+}
+
 static ssize_t f2fs_direct_IO(int rw, struct kiocb *iocb,
 		const struct iovec *iov, loff_t offset, unsigned long nr_segs)
 {
@@ -757,7 +778,7 @@ const struct address_space_operations f2fs_dblock_aops = {
 	.writepage	= f2fs_write_data_page,
 	.writepages	= f2fs_write_data_pages,
 	.write_begin	= f2fs_write_begin,
-	.write_end	= nobh_write_end,
+	.write_end	= f2fs_write_end,
 	.set_page_dirty	= f2fs_set_data_page_dirty,
 	.invalidatepage	= f2fs_invalidate_data_page,
 	.releasepage	= f2fs_release_data_page,
-- 
1.8.3.1.437.g0dbd812

