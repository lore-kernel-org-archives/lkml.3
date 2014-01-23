Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbaAWATu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:19:50 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:41930 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045AbaAWATq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:19:46 -0500
X-AuditID: cbfee68e-b7f566d000002344-aa-52e0601af4d2
Message-id: <1390436297.25542.4.camel@kjgkr>
Subject: Re: [PATCH 1/2 v2] f2fs: call mark_inode_dirty to flush dirty pages
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Thu, 23 Jan 2014 09:18:17 +0900
In-reply-to: <1390298075-21458-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1390298075-21458-1-git-send-email-jaegeuk.kim@samsung.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zY12phAdBBjt2WltcWuRusWfvSRaL
	y7vmsDkwe+xe8JnJ4/MmuQCmKC6blNSczLLUIn27BK6Mx6+2MBc8kq7o2X2BrYHxhVgXIweH
	hICJxJWN4V2MnECmmMSFe+vZuhi5OIQEljFKdF1/xQ6RMJFY/W4fG4gtJLCIUWLuCkaIopeM
	EjfbN4IV8QroSBxq/wFWJCzgI7FmzwdWkAVsAtoSm/cbQPQqSrzdfxcsLAJkX37vBGIyC3hI
	7DpWClLBIqAqcfjRcSYQmxMo/OTQCqit7hJr331kAbH5BUQlDi/czgxiMwuoS0yat4gZ4kol
	id3tnewQcXmJzWveMkMcJijxY/I9FpCLJQTWsUtsn7mCHWKZgMS3yYdYIMEgK7HpANQcSYmD
	K26wTGCUmIVkxSwkY2chGbuAkXkVo2hqQXJBcVJ6kZFecWJucWleul5yfu4mRkhc9e1gvHnA
	+hBjMtDKicxSosn5wLjMK4k3NDYzsjA1MTU2Mrc0I01YSZx30cOkICGB9MSS1OzU1ILUovii
	0pzU4kOMTBycUg2Muju+v7Gqm3B85dr9f4OlVl/84z5l3tXJGQ0dO17HMeY+fj/ZhXF1jvFv
	pb1lUy+0ul/dePPA/9Yrn0IEWa6e/nT+9k7bsxtFbpzJs1jk8etDydPbC6+6FPrFFsuZ9p8p
	3NXJd/OjaIEJw9NrlVunqOr9cwydoVQRbvUmZvO9tR3HXkUd+VNv36HEUpyRaKjFXFScCADl
	xGiswQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgK5UwoMggw1nzC0uLXK32LP3JIvF
	5V1z2ByYPXYv+Mzk8XmTXABTVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmS
	Ql5ibqqtkotPgK5bZg7QDiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1j
	xuNXW5gLHklX9Oy+wNbA+EKsi5GTQ0LARGL1u31sELaYxIV768FsIYFFjBJzVzB2MXIB2S8Z
	JW62b2QHSfAK6Egcav8BViQs4COxZs8H1i5GDg42AW2JzfsNIHoVJd7uvwsWFgGyL793AjGZ
	BTwkdh0rBalgEVCVOPzoOBOIzQkUfnJoBdRWd4m17z6ygNj8AqIShxduZwaxmQXUJSbNW8QM
	caWSxO72TnaIuLzE5jVvmSEOE5T4MfkeywRGoVlIWmYhKZuFpGwBI/MqRtHUguSC4qT0XEO9
	4sTc4tK8dL3k/NxNjOC4fSa1g3Flg8UhRgEORiUe3oQv94OEWBPLiitzDzFKcDArifAmRT4I
	EuJNSaysSi3Kjy8qzUktPsSYDPTdRGYp0eR8YErJK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1
	oJBAemJJanZqakFqEcwWJg5OqQbGpOZ1jbEb2blVHddMkT224HPv0bia6R9kw234OX9EsZy6
	kBZcFS5pt3UKo4hi951yw6Q0tZDYrUu+Ji+8vSBL89mPuguKvyKy2wLyQtJLxVxXtL3+sGSl
	m+Vf/4jy2NseXFFMyxnfhPx2+1EZ753g+dL70rStT4vrN5X+Pdyve0dil6pm1y8lluKMREMt
	5qLiRAB2P9D8HwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chang log from v1:
 o check and add mark_inode_dirty across the whole paths

>From a18ff063406dd6aec41fda598eabe2691007a30d Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Date: Tue, 21 Jan 2014 13:32:12 +0900
Subject: [PATCH 1/2] f2fs: call mark_inode_dirty to flush dirty pages

If a dentry page is updated, we should call mark_inode_dirty to add the
inode
into the dirty list, so that its dentry pages are flushed to the disk.
Otherwise, the inode can be evicted without flush.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c  | 4 +++-
 fs/f2fs/dir.c   | 6 ++----
 fs/f2fs/namei.c | 3 +++
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index f5fac16..0ae5587 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -249,6 +249,7 @@ int reserve_new_block(struct dnode_of_data *dn)
 
 	__set_data_blkaddr(dn, NEW_ADDR);
 	dn->data_blkaddr = NEW_ADDR;
+	mark_inode_dirty(dn->inode);
 	sync_inode_page(dn);
 	return 0;
 }
@@ -564,7 +565,6 @@ repeat:
 		i_size_write(inode, ((index + 1) << PAGE_CACHE_SHIFT));
 		/* Only the directory inode sets new_i_size */
 		set_inode_flag(F2FS_I(inode), FI_UPDATE_DIR);
-		mark_inode_dirty_sync(inode);
 	}
 	return page;
 
@@ -1060,6 +1060,8 @@ static int f2fs_set_data_page_dirty(struct page
*page)
 	trace_f2fs_set_page_dirty(page, DATA);
 
 	SetPageUptodate(page);
+	mark_inode_dirty(inode);
+
 	if (!PageDirty(page)) {
 		__set_page_dirty_nobuffers(page);
 		set_dirty_dir_page(inode, page);
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index cd055b6..b2b77cc 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -388,6 +388,8 @@ static void update_parent_metadata(struct inode
*dir, struct inode *inode,
 		clear_inode_flag(F2FS_I(inode), FI_NEW_INODE);
 	}
 	dir->i_mtime = dir->i_ctime = CURRENT_TIME;
+	mark_inode_dirty(dir);
+
 	if (F2FS_I(dir)->i_current_depth != current_depth) {
 		F2FS_I(dir)->i_current_depth = current_depth;
 		set_inode_flag(F2FS_I(dir), FI_UPDATE_DIR);
@@ -395,8 +397,6 @@ static void update_parent_metadata(struct inode
*dir, struct inode *inode,
 
 	if (is_inode_flag_set(F2FS_I(dir), FI_UPDATE_DIR))
 		update_inode_page(dir);
-	else
-		mark_inode_dirty(dir);
 
 	if (is_inode_flag_set(F2FS_I(inode), FI_INC_LINK))
 		clear_inode_flag(F2FS_I(inode), FI_INC_LINK);
@@ -553,8 +553,6 @@ void f2fs_delete_entry(struct f2fs_dir_entry
*dentry, struct page *page,
 	if (inode && S_ISDIR(inode->i_mode)) {
 		drop_nlink(dir);
 		update_inode_page(dir);
-	} else {
-		mark_inode_dirty(dir);
 	}
 
 	if (inode) {
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index a68838d..3d32f29 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -430,6 +430,7 @@ static int f2fs_rename(struct inode *old_dir, struct
dentry *old_dentry,
 		if (old_dir_entry)
 			drop_nlink(new_inode);
 		drop_nlink(new_inode);
+		mark_inode_dirty(new_inode);
 
 		if (!new_inode->i_nlink)
 			add_orphan_inode(sbi, new_inode->i_ino);
@@ -459,11 +460,13 @@ static int f2fs_rename(struct inode *old_dir,
struct dentry *old_dentry,
 			f2fs_set_link(old_inode, old_dir_entry,
 						old_dir_page, new_dir);
 			F2FS_I(old_inode)->i_pino = new_dir->i_ino;
+			update_inode_page(old_inode);
 		} else {
 			kunmap(old_dir_page);
 			f2fs_put_page(old_dir_page, 0);
 		}
 		drop_nlink(old_dir);
+		mark_inode_dirty(old_dir);
 		update_inode_page(old_dir);
 	}
 
-- 
1.8.4.474.g128a96c



-- 
Jaegeuk Kim
Samsung

