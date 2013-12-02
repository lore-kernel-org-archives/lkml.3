Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab3LBNSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:18:17 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:51026 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3LBNSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:18:14 -0500
Message-ID: <529C8892.8090102@gmail.com>
Date: Mon, 02 Dec 2013 21:18:10 +0800
From: Younger Liu <younger.liucn@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
CC: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fs-devel <linux-fsdevel@vger.kernel.org>,
        kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] f2fs: A minor change for avoiding any possible conflicts
 to the other fs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Younger Liu <liuyiyang@hisense.com>

This minor change for the naming conventions of debugfs_root
to avoid any possible conflicts to the other filesystem.

This patch is based on the first patch
"[PATCH 0/2] f2fs: remove debufs dir if debugfs_create_file() failed".

Signed-off-by: Younger Liu <liuyiyang@hisense.com>
Cc: Younger Liu <younger.liucn@gmail.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/debug.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index d27b689..9e8d355 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -24,7 +24,7 @@
 #include "gc.h"
 
 static LIST_HEAD(f2fs_stat_list);
-static struct dentry *debugfs_root;
+static struct dentry *f2fs_debugfs_root;
 static DEFINE_MUTEX(f2fs_stat_mutex);
 
 static void update_general_status(struct f2fs_sb_info *sbi)
@@ -342,19 +342,19 @@ void __init f2fs_create_root_stats(void)
 {
     struct dentry *file;
 
-    debugfs_root = debugfs_create_dir("f2fs", NULL);
-    if (!debugfs_root)
+    f2fs_debugfs_root = debugfs_create_dir("f2fs", NULL);
+    if (!f2fs_debugfs_root)
         goto bail;
 
     file = debugfs_create_file("status", S_IRUGO,
-            debugfs_root, NULL, &stat_fops);
+            f2fs_debugfs_root, NULL, &stat_fops);
     if (!file)
         goto free_debugfs_dir;
 
     return;
 
 free_debugfs_dir:
-    debugfs_remove(debugfs_root);
+    debugfs_remove(f2fs_debugfs_root);
 
 bail:
     return;
@@ -362,6 +362,6 @@ bail:
 
 void f2fs_destroy_root_stats(void)
 {
-    debugfs_remove_recursive(debugfs_root);
-    debugfs_root = NULL;
+    debugfs_remove_recursive(f2fs_debugfs_root);
+    f2fs_debugfs_root = NULL;
 }
-- 
1.7.9.5

