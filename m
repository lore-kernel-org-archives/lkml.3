Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaCGKwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:52:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:23066 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbaCGKwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:52:14 -0500
X-IronPort-AV: E=Sophos;i="4.97,607,1389715200"; 
   d="scan'208";a="9660334"
Message-ID: <5319A2D0.7010306@cn.fujitsu.com>
Date: Fri, 07 Mar 2014 18:43:28 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] f2fs: remove the unused ctor argument of f2fs_kmem_cache_create()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/07 18:49:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/07 18:49:35,
	Serialize complete at 2014/03/07 18:49:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/f2fs/checkpoint.c |    4 ++--
 fs/f2fs/f2fs.h       |    4 ++--
 fs/f2fs/gc.c         |    2 +-
 fs/f2fs/node.c       |    4 ++--
 fs/f2fs/recovery.c   |    2 +-
 fs/f2fs/segment.c    |    2 +-
 fs/f2fs/super.c      |    2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index f069249..911b6f9 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -939,11 +939,11 @@ void init_orphan_info(struct f2fs_sb_info *sbi)
 int __init create_checkpoint_caches(void)
 {
 	orphan_entry_slab = f2fs_kmem_cache_create("f2fs_orphan_entry",
-			sizeof(struct orphan_inode_entry), NULL);
+			sizeof(struct orphan_inode_entry));
 	if (!orphan_entry_slab)
 		return -ENOMEM;
 	inode_entry_slab = f2fs_kmem_cache_create("f2fs_dirty_dir_entry",
-			sizeof(struct dir_inode_entry), NULL);
+			sizeof(struct dir_inode_entry));
 	if (!inode_entry_slab) {
 		kmem_cache_destroy(orphan_entry_slab);
 		return -ENOMEM;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 8b2cb82..f845e92 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -852,9 +852,9 @@ static inline void f2fs_put_dnode(struct dnode_of_data *dn)
 }
 
 static inline struct kmem_cache *f2fs_kmem_cache_create(const char *name,
-					size_t size, void (*ctor)(void *))
+					size_t size)
 {
-	return kmem_cache_create(name, size, 0, SLAB_RECLAIM_ACCOUNT, ctor);
+	return kmem_cache_create(name, size, 0, SLAB_RECLAIM_ACCOUNT, NULL);
 }
 
 static inline void *f2fs_kmem_cache_alloc(struct kmem_cache *cachep,
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index d94acbc..b90dbe5 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -742,7 +742,7 @@ void build_gc_manager(struct f2fs_sb_info *sbi)
 int __init create_gc_caches(void)
 {
 	winode_slab = f2fs_kmem_cache_create("f2fs_gc_inodes",
-			sizeof(struct inode_entry), NULL);
+			sizeof(struct inode_entry));
 	if (!winode_slab)
 		return -ENOMEM;
 	return 0;
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 9653096..8787469 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1896,12 +1896,12 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
 int __init create_node_manager_caches(void)
 {
 	nat_entry_slab = f2fs_kmem_cache_create("nat_entry",
-			sizeof(struct nat_entry), NULL);
+			sizeof(struct nat_entry));
 	if (!nat_entry_slab)
 		return -ENOMEM;
 
 	free_nid_slab = f2fs_kmem_cache_create("free_nid",
-			sizeof(struct free_nid), NULL);
+			sizeof(struct free_nid));
 	if (!free_nid_slab) {
 		kmem_cache_destroy(nat_entry_slab);
 		return -ENOMEM;
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index aef7768..03b28ec 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -436,7 +436,7 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 	bool need_writecp = false;
 
 	fsync_entry_slab = f2fs_kmem_cache_create("f2fs_fsync_inode_entry",
-			sizeof(struct fsync_inode_entry), NULL);
+			sizeof(struct fsync_inode_entry));
 	if (!fsync_entry_slab)
 		return -ENOMEM;
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index fbb41ba..199c964 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1878,7 +1878,7 @@ void destroy_segment_manager(struct f2fs_sb_info *sbi)
 int __init create_segment_manager_caches(void)
 {
 	discard_entry_slab = f2fs_kmem_cache_create("discard_entry",
-			sizeof(struct discard_entry), NULL);
+			sizeof(struct discard_entry));
 	if (!discard_entry_slab)
 		return -ENOMEM;
 	return 0;
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 1bd9153..72df734 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1089,7 +1089,7 @@ MODULE_ALIAS_FS("f2fs");
 static int __init init_inodecache(void)
 {
 	f2fs_inode_cachep = f2fs_kmem_cache_create("f2fs_inode_cache",
-			sizeof(struct f2fs_inode_info), NULL);
+			sizeof(struct f2fs_inode_info));
 	if (!f2fs_inode_cachep)
 		return -ENOMEM;
 	return 0;
-- 
1.7.7

