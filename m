Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaIJVLF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:11:05 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:34238 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbaIJVK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:10:58 -0400
From: Purnendu Kapadia <pro8linux@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        pro8linux@gmail.com
Subject: [PATCH] staging: android: checkpatch fixes for sw_sync files
Date: Wed, 10 Sep 2014 22:10:49 +0100
Message-Id: <1410383449-28680-1-git-send-email-pro8linux@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   - add line after declaration
   - allignment should match open parenthesis
   - remove unnecessary new line

Signed-off-by: Purnendu Kapadia <pro8linux@gmail.com>
---
 drivers/staging/android/sw_sync.c | 9 +++++----
 drivers/staging/android/sw_sync.h | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
index a76db3f..c90838d 100644
--- a/drivers/staging/android/sw_sync.c
+++ b/drivers/staging/android/sw_sync.c
@@ -48,11 +48,11 @@ EXPORT_SYMBOL(sw_sync_pt_create);
 
 static struct sync_pt *sw_sync_pt_dup(struct sync_pt *sync_pt)
 {
-	struct sw_sync_pt *pt = (struct sw_sync_pt *) sync_pt;
+	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
 	struct sw_sync_timeline *obj =
 		(struct sw_sync_timeline *)sync_pt_parent(sync_pt);
 
-	return (struct sync_pt *) sw_sync_pt_create(obj, pt->value);
+	return (struct sync_pt *)sw_sync_pt_create(obj, pt->value);
 }
 
 static int sw_sync_pt_has_signaled(struct sync_pt *sync_pt)
@@ -94,9 +94,10 @@ static void sw_sync_timeline_value_str(struct sync_timeline *sync_timeline,
 }
 
 static void sw_sync_pt_value_str(struct sync_pt *sync_pt,
-				       char *str, int size)
+				 char *str, int size)
 {
 	struct sw_sync_pt *pt = (struct sw_sync_pt *)sync_pt;
+
 	snprintf(str, size, "%d", pt->value);
 }
 
@@ -110,7 +111,6 @@ static struct sync_timeline_ops sw_sync_timeline_ops = {
 	.pt_value_str = sw_sync_pt_value_str,
 };
 
-
 struct sw_sync_timeline *sw_sync_timeline_create(const char *name)
 {
 	struct sw_sync_timeline *obj = (struct sw_sync_timeline *)
@@ -156,6 +156,7 @@ static int sw_sync_open(struct inode *inode, struct file *file)
 static int sw_sync_release(struct inode *inode, struct file *file)
 {
 	struct sw_sync_timeline *obj = file->private_data;
+
 	sync_timeline_destroy(&obj->obj);
 	return 0;
 }
diff --git a/drivers/staging/android/sw_sync.h b/drivers/staging/android/sw_sync.h
index 1a50669..c87ae9e 100644
--- a/drivers/staging/android/sw_sync.h
+++ b/drivers/staging/android/sw_sync.h
@@ -50,7 +50,7 @@ static inline void sw_sync_timeline_inc(struct sw_sync_timeline *obj, u32 inc)
 }
 
 static inline struct sync_pt *sw_sync_pt_create(struct sw_sync_timeline *obj,
-		u32 value)
+						u32 value)
 {
 	return NULL;
 }
-- 
1.9.1

