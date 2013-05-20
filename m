Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab3ETDdn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 23:33:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41635 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab3ETDdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 23:33:38 -0400
X-AuditID: cbfee690-b7efc6d000006d92-0c-5199998e0ddb
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 04/15] f2fs: fix BUG_ON during f2fs_evict_inode(dir)
Date: Mon, 20 May 2013 12:32:18 +0900
Message-id: <1369020743-18520-4-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
In-reply-to: <1369020743-18520-1-git-send-email-jaegeuk.kim@samsung.com>
References: <1369020743-18520-1-git-send-email-jaegeuk.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zA92+mTMDDd69k7a4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2PNuRVsBa+UK868
	v8vawPhDtouRk0NCwETiWudzVghbTOLCvfVsXYxcHEICyxglHp/bwQpT9OZWE1RiEaPEhN8d
	TBBOG5PExoYjQBkODjYBbYnN+w1AGkQEmCUWTD3PCFLDLDCBUeL/ovcsIAlhAReJx78+MIPY
	LAKqEt+a1zKB9PIKuEtceJ4AsUxXYvX/5+wgNqeAh8TWu6cYQUqEgEpenysBGSkh8J1NYsGB
	/awQYwQkvk0+xAJSIyEgK7HpADPEGEmJgytusExgFF7AyLCKUTS1ILmgOCm9yESvODG3uDQv
	XS85P3cTIyRgJ+xgvHfA+hBjMtC4icxSosn5wIDPK4k3NDYzsjA1MTU2Mrc0I01YSZxXvcU6
	UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAMj5+Z915gWCE/dY2ht+/qsX4W3kOoD5g18T5ek
	hau/iuX9tlXetKm96rF7mNn7RUpTe+Iq1xzqTPif8eZMYo1+fbzaqcuPv05S0DdN9Uvt39fv
	vjJUafdCL+fzJ80STK6FvxQyXSFx5z+D6jdz6ZVRfGd/1p5+sWmV5o0G+XT+LYbt/2+q2AQo
	sRRnJBpqMRcVJwIAwhYmQW4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jAd2+mTMDDe7eEre4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjFjzbkVbAWvlCvOvL/L2sD4Q7aLkZNDQsBE4s2tJjYIW0ziwr31QDYXh5DA
	IkaJCb87mCCcNiaJjQ1HgDIcHGwC2hKb9xuANIgIMEssmHqeEaSGWWACo8T/Re9ZQBLCAi4S
	j399YAaxWQRUJb41r2UC6eUVcJe48DwBYpmuxOr/z9lBbE4BD4mtd08xgpQIAZW8PlcygZF3
	ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgeHgmvYNxVYPFIUYBDkYlHl6BgJmBQqyJ
	ZcWVuYcYJTiYlUR4o7uBQrwpiZVVqUX58UWlOanFhxiTgW6ayCwlmpwPjNW8knhDYxMzI0sj
	MwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamDctqDm9eyOstVLtU5ozk479O/n
	rDf13PWJxy58tejwar2jHP25n3PL8byrXhO7tAWO5/Zrsare+91wXYHh9I4De26Vuiu1PLrD
	19wYOev6rJ0Jygl2SgEK1y1ePA/lSV1/Qef4us5o0V0F5ewlvRl7L+7m6a3fvz/wWxHPo9ny
	/sscVF/v+bhViaU4I9FQi7moOBEAmmIkl8sCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the dentry recovery routine, recover_inode() triggers __f2fs_add_link
with its directory inode.

In the following scenario, a bug is captured.
 1. dir = f2fs_iget(pino)
 2. __f2fs_add_link(dir, name)
 3. iput(dir)
  -> f2fs_evict_inode() faces with BUG_ON(atomic_read(fi->dirty_dents))

Kernel BUG at ffffffffa01c0676 [verbose debug info unavailable]
[<ffffffffa01c0676>] f2fs_evict_inode+0x276/0x300 [f2fs]
Call Trace:
 [<ffffffff8118ea00>] evict+0xb0/0x1b0
 [<ffffffff8118f1c5>] iput+0x105/0x190
 [<ffffffffa01d2dac>] recover_fsync_data+0x3bc/0x1070 [f2fs]
 [<ffffffff81692e8a>] ? io_schedule+0xaa/0xd0
 [<ffffffff81690acb>] ? __wait_on_bit_lock+0x7b/0xc0
 [<ffffffff8111a0e7>] ? __lock_page+0x67/0x70
 [<ffffffff81165e21>] ? kmem_cache_alloc+0x31/0x140
 [<ffffffff8118a502>] ? __d_instantiate+0x92/0xf0
 [<ffffffff812a949b>] ? security_d_instantiate+0x1b/0x30
 [<ffffffff8118a5b4>] ? d_instantiate+0x54/0x70

This means that we should flush all the dentry pages between iget and iput().
But, during the recovery routine, it is unallowed due to consistency, so we
have to wait the whole recovery process.
And then, write_checkpoint flushes all the dirty dentry blocks, and nicely we
can put the stale dir inodes from the dirty_dir_inode_list.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c | 23 +++++++++++++++++++++++
 fs/f2fs/f2fs.h       |  2 ++
 fs/f2fs/recovery.c   | 14 +++++++++-----
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index b1de01d..3d11449 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -514,6 +514,29 @@ void remove_dirty_dir_inode(struct inode *inode)
 	}
 out:
 	spin_unlock(&sbi->dir_inode_lock);
+
+	/* Only from the recovery routine */
+	if (is_inode_flag_set(F2FS_I(inode), FI_DELAY_IPUT))
+		iput(inode);
+}
+
+struct inode *check_dirty_dir_inode(struct f2fs_sb_info *sbi, nid_t ino)
+{
+	struct list_head *head = &sbi->dir_inode_list;
+	struct list_head *this;
+	struct inode *inode = NULL;
+
+	spin_lock(&sbi->dir_inode_lock);
+	list_for_each(this, head) {
+		struct dir_inode_entry *entry;
+		entry = list_entry(this, struct dir_inode_entry, list);
+		if (entry->inode->i_ino == ino) {
+			inode = entry->inode;
+			break;
+		}
+	}
+	spin_unlock(&sbi->dir_inode_lock);
+	return inode;
 }
 
 void sync_dirty_dir_inodes(struct f2fs_sb_info *sbi)
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 20aab02..ef6cac8 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -846,6 +846,7 @@ enum {
 	FI_INC_LINK,		/* need to increment i_nlink */
 	FI_ACL_MODE,		/* indicate acl mode */
 	FI_NO_ALLOC,		/* should not allocate any blocks */
+	FI_DELAY_IPUT,		/* used for the recovery */
 };
 
 static inline void set_inode_flag(struct f2fs_inode_info *fi, int flag)
@@ -1012,6 +1013,7 @@ int recover_orphan_inodes(struct f2fs_sb_info *);
 int get_valid_checkpoint(struct f2fs_sb_info *);
 void set_dirty_dir_page(struct inode *, struct page *);
 void remove_dirty_dir_inode(struct inode *);
+struct inode *check_dirty_dir_inode(struct f2fs_sb_info *, nid_t);
 void sync_dirty_dir_inodes(struct f2fs_sb_info *);
 void write_checkpoint(struct f2fs_sb_info *, bool);
 void init_orphan_info(struct f2fs_sb_info *);
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index f77aedd..c573944 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -42,6 +42,7 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
 {
 	struct f2fs_node *raw_node = (struct f2fs_node *)kmap(ipage);
 	struct f2fs_inode *raw_inode = &(raw_node->i);
+	nid_t pino = le32_to_cpu(raw_inode->i_pino);
 	struct qstr name;
 	struct f2fs_dir_entry *de;
 	struct page *page;
@@ -51,10 +52,14 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
 	if (!is_dent_dnode(ipage))
 		goto out;
 
-	dir = f2fs_iget(inode->i_sb, le32_to_cpu(raw_inode->i_pino));
-	if (IS_ERR(dir)) {
-		err = PTR_ERR(dir);
-		goto out;
+	dir = check_dirty_dir_inode(F2FS_SB(inode->i_sb), pino);
+	if (!dir) {
+		dir = f2fs_iget(inode->i_sb, pino);
+		if (IS_ERR(dir)) {
+			err = PTR_ERR(dir);
+			goto out;
+		}
+		set_inode_flag(F2FS_I(dir), FI_DELAY_IPUT);
 	}
 
 	name.len = le32_to_cpu(raw_inode->i_namelen);
@@ -67,7 +72,6 @@ static int recover_dentry(struct page *ipage, struct inode *inode)
 	} else {
 		err = __f2fs_add_link(dir, &name, inode);
 	}
-	iput(dir);
 out:
 	kunmap(ipage);
 	return err;
-- 
1.8.1.3.566.gaa39828

