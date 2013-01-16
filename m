Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab3APPIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:08:44 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60798 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652Ab3APPIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:08:41 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH] f2fs: add __init to functions in init_f2fs_fs
Date: Thu, 17 Jan 2013 00:08:30 +0900
Message-Id: <1358348911-8962-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add __init to functions in init_f2fs_fs for code consistency.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/checkpoint.c |    2 +-
 fs/f2fs/f2fs.h       |   10 +++++-----
 fs/f2fs/gc.c         |    2 +-
 fs/f2fs/node.c       |    2 +-
 fs/f2fs/super.c      |    2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index d75c86a..ff3c843 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -771,7 +771,7 @@ void init_orphan_info(struct f2fs_sb_info *sbi)
 	sbi->n_orphans = 0;
 }
 
-int create_checkpoint_caches(void)
+int __init create_checkpoint_caches(void)
 {
 	orphan_entry_slab = f2fs_kmem_cache_create("f2fs_orphan_entry",
 			sizeof(struct orphan_inode_entry), NULL);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 976325d..c8e2d75 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -914,7 +914,7 @@ int restore_node_summary(struct f2fs_sb_info *, unsigned int,
 void flush_nat_entries(struct f2fs_sb_info *);
 int build_node_manager(struct f2fs_sb_info *);
 void destroy_node_manager(struct f2fs_sb_info *);
-int create_node_manager_caches(void);
+int __init create_node_manager_caches(void);
 void destroy_node_manager_caches(void);
 
 /*
@@ -966,7 +966,7 @@ void sync_dirty_dir_inodes(struct f2fs_sb_info *);
 void block_operations(struct f2fs_sb_info *);
 void write_checkpoint(struct f2fs_sb_info *, bool, bool);
 void init_orphan_info(struct f2fs_sb_info *);
-int create_checkpoint_caches(void);
+int __init create_checkpoint_caches(void);
 void destroy_checkpoint_caches(void);
 
 /*
@@ -988,7 +988,7 @@ void stop_gc_thread(struct f2fs_sb_info *);
 block_t start_bidx_of_node(unsigned int);
 int f2fs_gc(struct f2fs_sb_info *);
 void build_gc_manager(struct f2fs_sb_info *);
-int create_gc_caches(void);
+int __init create_gc_caches(void);
 void destroy_gc_caches(void);
 
 /*
@@ -1060,7 +1060,7 @@ struct f2fs_stat_info {
 
 int f2fs_build_stats(struct f2fs_sb_info *);
 void f2fs_destroy_stats(struct f2fs_sb_info *);
-void f2fs_create_root_stats(void);
+void __init f2fs_create_root_stats(void);
 void f2fs_destroy_root_stats(void);
 #else
 #define stat_inc_call_count(si)
@@ -1071,7 +1071,7 @@ void f2fs_destroy_root_stats(void);
 
 static inline int f2fs_build_stats(struct f2fs_sb_info *sbi) { return 0; }
 static inline void f2fs_destroy_stats(struct f2fs_sb_info *sbi) { }
-static inline void f2fs_create_root_stats(void) { }
+static inline void __init f2fs_create_root_stats(void) { }
 static inline void f2fs_destroy_root_stats(void) { }
 #endif
 
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index b4dd90c..809cfec 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -697,7 +697,7 @@ void build_gc_manager(struct f2fs_sb_info *sbi)
 	DIRTY_I(sbi)->v_ops = &default_v_ops;
 }
 
-int create_gc_caches(void)
+int __init create_gc_caches(void)
 {
 	winode_slab = f2fs_kmem_cache_create("f2fs_gc_inodes",
 			sizeof(struct inode_entry), NULL);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 5066bfd..f177c01 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1732,7 +1732,7 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
 	kfree(nm_i);
 }
 
-int create_node_manager_caches(void)
+int __init create_node_manager_caches(void)
 {
 	nat_entry_slab = f2fs_kmem_cache_create("nat_entry",
 			sizeof(struct nat_entry), NULL);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index d551a72..37fad04 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -640,7 +640,7 @@ static struct file_system_type f2fs_fs_type = {
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-static int init_inodecache(void)
+static int __init init_inodecache(void)
 {
 	f2fs_inode_cachep = f2fs_kmem_cache_create("f2fs_inode_cache",
 			sizeof(struct f2fs_inode_info), NULL);
-- 
1.7.9.5

