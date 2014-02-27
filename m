Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaB0LxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:53:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11087 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaB0LxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:53:21 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-b3-530f273077ad
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev] [PATCH] f2fs: use existing macro to clean up some codes
Date: Thu, 27 Feb 2014 19:52:21 +0800
Message-id: <001301cf33b2$81e816a0$85b843e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac8zshoZZpOfM/nXSJSGLHcPV+WmKQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAV0Ddf5gg5N/+C2u7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyvh7/ypjwQaeigmd
	m5gaGGdzdTFyckgImEisOPyBGcIWk7hwbz1bFyMXh5DAIkaJd0/es0I4Pxgl3rx+DFbFJqAi
	sbzjPxOILSKgKLHh/QZ2EJtZIFNizuvJrCC2sIC3xIFz/9hAbBYBVYnmY2uBejk4eAUsJbZ0
	VYKEeQUEJX5MvscC0aolsX7ncSYIW15i85q3UAcpSOw4+5oRpFVEQE9i3z4DiBJxiY1HbrFM
	YBSYhWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwWH8THoH46oG
	i0OMAhyMSjy8P3T5goVYE8uKK3MPMUpwMCuJ8K5n4g8W4k1JrKxKLcqPLyrNSS0+xCjNwaIk
	znuw1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwMh/5+KVq3671NRf9Nz85iqcpxK5n0PyjNE/gV0X
	lz3oWvFMaTd/5q1TXpEf10Xc2PXm/a6ooII/1fVS07QZPQ2j/A7OulSlGWi77+/f/oXncnIt
	vjzk8byds3zv9J6L345/eznr0cTmqdV32nJ/nHcWW5iT/TjhwH9moefXb20WsrWts//OYnNV
	iaU4I9FQi7moOBEAH6ATGV8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use existing macro F2FS_INODE/NEXT_FREE_BLKADDR to clean up some
codes.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h     |    6 ++----
 fs/f2fs/recovery.c |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index cc0b27f..459078b 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -996,8 +996,7 @@ static inline unsigned int addrs_per_inode(struct f2fs_inode_info *fi)
 
 static inline void *inline_xattr_addr(struct page *page)
 {
-	struct f2fs_inode *ri;
-	ri = (struct f2fs_inode *)page_address(page);
+	struct f2fs_inode *ri = F2FS_INODE(page);
 	return (void *)&(ri->i_addr[DEF_ADDRS_PER_INODE -
 					F2FS_INLINE_XATTR_ADDRS]);
 }
@@ -1017,8 +1016,7 @@ static inline int f2fs_has_inline_data(struct inode *inode)
 
 static inline void *inline_data_addr(struct page *page)
 {
-	struct f2fs_inode *ri;
-	ri = (struct f2fs_inode *)page_address(page);
+	struct f2fs_inode *ri = F2FS_INODE(page);
 	return (void *)&(ri->i_addr[1]);
 }
 
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 72adbbf..aef7768 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -136,7 +136,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 
 	/* get node pages in the current segment */
 	curseg = CURSEG_I(sbi, CURSEG_WARM_NODE);
-	blkaddr = START_BLOCK(sbi, curseg->segno) + curseg->next_blkoff;
+	blkaddr = NEXT_FREE_BLKADDR(sbi, curseg);
 
 	/* read node page */
 	page = alloc_page(GFP_F2FS_ZERO);
-- 
1.7.9.5

