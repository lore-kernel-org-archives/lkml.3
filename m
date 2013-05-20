Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3ETDd5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 23:33:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41635 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab3ETDdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 23:33:44 -0400
X-AuditID: cbfee690-b7efc6d000006d92-1e-5199998f2efd
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 09/15] f2fs: add debug msgs in the recovery routine
Date: Mon, 20 May 2013 12:32:23 +0900
Message-id: <1369020743-18520-9-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1369020743-18520-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1369020743-18520-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zA93+mTMDDS5vYra4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2PayV3MBbtVK6Yf
	2cjYwPhetouRk0NCwETi/b65bBC2mMSFe+uBbC4OIYFljBI7umYywRRdXn+NHSKxiFFiz+dd
	rBBOG5PExoYjQC0cHGwC2hKb9xuANIgIMEssmHqeEaSGWWACo8T/Re9ZQGqEBZwlHm4vAKlh
	EVCVmDTzCQuIzSvgLrFlyxGoZboSq/8/ZwexOQU8JLbePcUI0ioEVPP6XAnISAmB32wSO27/
	Z4OYIyDxbfIhsPESArISmw4wQ4yRlDi44gbLBEbhBYwMqxhFUwuSC4qT0otM9IoTc4tL89L1
	kvNzNzFCAnbCDsZ7B6wPMSYDjZvILCWanA8M+LySeENjMyMLUxNTYyNzSzPShJXEedVbrAOF
	BNITS1KzU1MLUovii0pzUosPMTJxcEo1MMbffWp3KGviK/bHWRkxuee++rVyzIu9ufvfvhLn
	zexvP3ZNZmhLZ/oifv3XOqe81F+u3P+W87Z92Vp849vVyCPfcjx9+V58uSt0YOPcgIULjt8P
	d/CaWHGO2bvyunP+4aj3czLZuFed4LqpXygqMan/MdM8T/6/4gYuBwT7JgU6fZfeHnPxBZ8S
	S3FGoqEWc1FxIgD6Q13gbgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAd2+mTMDDY4ut7G4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjFj2sldzAW7VSumH9nI2MD4XraLkZNDQsBE4vL6a+wQtpjEhXvr2boYuTiE
	BBYxSuz5vIsVwmljktjYcAQow8HBJqAtsXm/AUiDiACzxIKp5xlBapgFJjBK/F/0ngWkRljA
	WeLh9gKQGhYBVYlJM5+wgNi8Au4SW7YcYYJYpiux+v9zsMWcAh4SW++eYgRpFQKqeX2uZAIj
	7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwfHwTHoH46oGi0OMAhyMSjy8AgEzA4VY
	E8uKK3MPMUpwMCuJ8EZ3A4V4UxIrq1KL8uOLSnNSiw8xJgMdNZFZSjQ5HxireSXxhsYmZkaW
	RmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAKLvq4nv2Wcm/7RI9lz9UrT+3
	jO/Yeqb37gJ/jkY0Lj+U53aPffuM5Ye9H2pO5E/XXcIdXbB56tEKt8Nfmxb+yd3VefyQcMid
	95xxc7kY5ZduYt+doKl5cs6NRTz9/+tKpN/prn99KPnEk8d5THm1x1JWH5lw757F2tsTrr2+
	7Jeu6RbvfexnwV8lluKMREMt5qLiRACaD6GhywIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds some trivial debugging messages in the recovery process.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c     |  1 -
 fs/f2fs/recovery.c | 44 +++++++++++++++++++++++++-------------------
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index b41482d..5a59780 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1495,7 +1495,6 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
 		WARN_ON(1);
 	set_node_addr(sbi, &new_ni, NEW_ADDR);
 	inc_valid_inode_count(sbi);
-
 	f2fs_put_page(ipage, 1);
 	return 0;
 }
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index c573944..774efdb 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -49,9 +49,6 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
 	struct inode *dir;
 	int err = 0;
 
-	if (!is_dent_dnode(ipage))
-		goto out;
-
 	dir = check_dirty_dir_inode(F2FS_SB(inode->i_sb), pino);
 	if (!dir) {
 		dir = f2fs_iget(inode->i_sb, pino);
@@ -73,6 +70,9 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
 		err = __f2fs_add_link(dir, &name, inode);
 	}
 out:
+	f2fs_msg(inode->i_sb, KERN_NOTICE, "recover_inode and its dentry: "
+			"ino = %x, name = %s, dir = %lx, err = %d",
+			ino_of_node(ipage), raw_inode->i_name, dir->i_ino, err);
 	kunmap(ipage);
 	return err;
 }
@@ -83,6 +83,9 @@ static int recover_inode(struct inode *inode, struct page *node_page)
 	struct f2fs_node *raw_node = (struct f2fs_node *)kaddr;
 	struct f2fs_inode *raw_inode = &(raw_node->i);
 
+	if (!IS_INODE(node_page))
+		return 0;
+
 	inode->i_mode = le16_to_cpu(raw_inode->i_mode);
 	i_size_write(inode, le64_to_cpu(raw_inode->i_size));
 	inode->i_atime.tv_sec = le64_to_cpu(raw_inode->i_mtime);
@@ -92,7 +95,12 @@ static int recover_inode(struct inode *inode, struct page *node_page)
 	inode->i_ctime.tv_nsec = le32_to_cpu(raw_inode->i_ctime_nsec);
 	inode->i_mtime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
 
-	return recover_dentry(node_page, inode);
+	if (is_dent_dnode(node_page))
+		return recover_dentry(node_page, inode);
+
+	f2fs_msg(inode->i_sb, KERN_NOTICE, "recover_inode: ino = %x, name = %s",
+			ino_of_node(node_page), raw_inode->i_name);
+	return 0;
 }
 
 static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
@@ -123,7 +131,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 		lock_page(page);
 
 		if (cp_ver != cpver_of_node(page))
-			goto unlock_out;
+			break;
 
 		if (!is_fsync_dnode(page))
 			goto next;
@@ -133,40 +141,33 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 			if (IS_INODE(page) && is_dent_dnode(page)) {
 				err = recover_inode_page(sbi, page);
 				if (err)
-					goto unlock_out;
+					break;
 			}
 
 			/* add this fsync inode to the list */
 			entry = kmem_cache_alloc(fsync_entry_slab, GFP_NOFS);
 			if (!entry) {
 				err = -ENOMEM;
-				goto unlock_out;
+				break;
 			}
 
 			entry->inode = f2fs_iget(sbi->sb, ino_of_node(page));
 			if (IS_ERR(entry->inode)) {
 				err = PTR_ERR(entry->inode);
 				kmem_cache_free(fsync_entry_slab, entry);
-				goto unlock_out;
+				break;
 			}
 			list_add_tail(&entry->list, head);
 		}
 		entry->blkaddr = blkaddr;
 
-		if (IS_INODE(page)) {
-			err = recover_inode(entry->inode, page);
-			if (err == -ENOENT) {
-				goto next;
-			} else if (err) {
-				err = -EINVAL;
-				goto unlock_out;
-			}
-		}
+		err = recover_inode(entry->inode, page);
+		if (err && err != -ENOENT)
+			break;
 next:
 		/* check next segment */
 		blkaddr = next_blkaddr_of_node(page);
 	}
-unlock_out:
 	unlock_page(page);
 out:
 	__free_pages(page, 0);
@@ -244,7 +245,7 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 	struct dnode_of_data dn;
 	struct f2fs_summary sum;
 	struct node_info ni;
-	int err = 0;
+	int err = 0, recovered = 0;
 	int ilock;
 
 	start = start_bidx_of_node(ofs_of_node(page));
@@ -289,6 +290,7 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 			/* write dummy data page */
 			recover_data_page(sbi, NULL, &sum, src, dest);
 			update_extent_cache(dest, &dn);
+			recovered++;
 		}
 		dn.ofs_in_node++;
 	}
@@ -306,6 +308,10 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 	recover_node_page(sbi, dn.node_page, &sum, &ni, blkaddr);
 	f2fs_put_dnode(&dn);
 	mutex_unlock_op(sbi, ilock);
+
+	f2fs_msg(sbi->sb, KERN_NOTICE, "recover_data: ino = %lx, "
+			"recovered_data = %d blocks",
+			inode->i_ino, recovered);
 	return 0;
 }
 
-- 
1.8.1.3.566.gaa39828

