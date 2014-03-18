Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbaCRRup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:50:45 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:26959 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756673AbaCRRun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:50:43 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0NAFmGKFNbsn1//2dsb2JhbABagwaDRr9rAgKBKxd0glMTHCMYgQIkE4d9AdA+jmKEPwSYRQGSMIMuPA
Date: Tue, 18 Mar 2014 18:52:21 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] MINIX: specific inode data access standardization
Message-Id: <20140318185221.697f8368fca2e51728e201ca@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

minix_i uppercase conversion (like majority of other filesystems).

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/minix/bitmap.c   |  2 +-
 fs/minix/inode.c    | 10 +++++-----
 fs/minix/itree_v1.c |  2 +-
 fs/minix/itree_v2.c |  2 +-
 fs/minix/minix.h    |  2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/minix/bitmap.c b/fs/minix/bitmap.c
index 4bc50da..29cd60d 100644
--- a/fs/minix/bitmap.c
+++ b/fs/minix/bitmap.c
@@ -255,7 +255,7 @@ struct inode *minix_new_inode(const struct inode *dir, umode_t mode, int *error)
 	inode->i_ino = j;
 	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
 	inode->i_blocks = 0;
-	memset(&minix_i(inode)->u, 0, sizeof(minix_i(inode)->u));
+	memset(&MINIX_I(inode)->u, 0, sizeof(MINIX_I(inode)->u));
 	insert_inode_hash(inode);
 	mark_inode_dirty(inode);
 
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index 0332109..3231944 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -71,7 +71,7 @@ static struct inode *minix_alloc_inode(struct super_block *sb)
 static void minix_i_callback(struct rcu_head *head)
 {
 	struct inode *inode = container_of(head, struct inode, i_rcu);
-	kmem_cache_free(minix_inode_cachep, minix_i(inode));
+	kmem_cache_free(minix_inode_cachep, MINIX_I(inode));
 }
 
 static void minix_destroy_inode(struct inode *inode)
@@ -463,7 +463,7 @@ static struct inode *V1_minix_iget(struct inode *inode)
 {
 	struct buffer_head * bh;
 	struct minix_inode * raw_inode;
-	struct minix_inode_info *minix_inode = minix_i(inode);
+	struct minix_inode_info *minix_inode = MINIX_I(inode);
 	int i;
 
 	raw_inode = minix_V1_raw_inode(inode->i_sb, inode->i_ino, &bh);
@@ -496,7 +496,7 @@ static struct inode *V2_minix_iget(struct inode *inode)
 {
 	struct buffer_head * bh;
 	struct minix2_inode * raw_inode;
-	struct minix_inode_info *minix_inode = minix_i(inode);
+	struct minix_inode_info *minix_inode = MINIX_I(inode);
 	int i;
 
 	raw_inode = minix_V2_raw_inode(inode->i_sb, inode->i_ino, &bh);
@@ -550,7 +550,7 @@ static struct buffer_head * V1_minix_update_inode(struct inode * inode)
 {
 	struct buffer_head * bh;
 	struct minix_inode * raw_inode;
-	struct minix_inode_info *minix_inode = minix_i(inode);
+	struct minix_inode_info *minix_inode = MINIX_I(inode);
 	int i;
 
 	raw_inode = minix_V1_raw_inode(inode->i_sb, inode->i_ino, &bh);
@@ -577,7 +577,7 @@ static struct buffer_head * V2_minix_update_inode(struct inode * inode)
 {
 	struct buffer_head * bh;
 	struct minix2_inode * raw_inode;
-	struct minix_inode_info *minix_inode = minix_i(inode);
+	struct minix_inode_info *minix_inode = MINIX_I(inode);
 	int i;
 
 	raw_inode = minix_V2_raw_inode(inode->i_sb, inode->i_ino, &bh);
diff --git a/fs/minix/itree_v1.c b/fs/minix/itree_v1.c
index 282e15a..a96bdae 100644
--- a/fs/minix/itree_v1.c
+++ b/fs/minix/itree_v1.c
@@ -18,7 +18,7 @@ static inline block_t cpu_to_block(unsigned long n)
 
 static inline block_t *i_data(struct inode *inode)
 {
-	return (block_t *)minix_i(inode)->u.i1_data;
+	return (block_t *)MINIX_I(inode)->u.i1_data;
 }
 
 static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
diff --git a/fs/minix/itree_v2.c b/fs/minix/itree_v2.c
index 78e2d93..7cdfdb5 100644
--- a/fs/minix/itree_v2.c
+++ b/fs/minix/itree_v2.c
@@ -17,7 +17,7 @@ static inline block_t cpu_to_block(unsigned long n)
 
 static inline block_t *i_data(struct inode *inode)
 {
-	return (block_t *)minix_i(inode)->u.i2_data;
+	return (block_t *)MINIX_I(inode)->u.i2_data;
 }
 
 #define DIRCOUNT 7
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index 1ebd118..8729dc1 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -82,7 +82,7 @@ static inline struct minix_sb_info *minix_sb(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
-static inline struct minix_inode_info *minix_i(struct inode *inode)
+static inline struct minix_inode_info *MINIX_I(struct inode *inode)
 {
 	return list_entry(inode, struct minix_inode_info, vfs_inode);
 }
-- 
1.8.4.5

