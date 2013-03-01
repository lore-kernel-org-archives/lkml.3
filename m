Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756417Ab3CAAtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:49:17 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:60561 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581Ab3CAAnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:43:55 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 10/30] staging: sync: Export sync API symbols
Date: Thu, 28 Feb 2013 16:43:06 -0800
Message-Id: <1362098606-26469-11-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

This is needed to allow modules to link against the sync subsystem

Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Erik Gilling <konkers@android.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robclark@gmail.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: dri-devel@lists.freedesktop.org
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Erik Gilling <konkers@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sync.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 54f84d9..6739a84 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/debugfs.h>
+#include <linux/export.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
@@ -64,6 +65,7 @@ struct sync_timeline *sync_timeline_create(const struct sync_timeline_ops *ops,
 
 	return obj;
 }
+EXPORT_SYMBOL(sync_timeline_create);
 
 static void sync_timeline_free(struct sync_timeline *obj)
 {
@@ -94,6 +96,7 @@ void sync_timeline_destroy(struct sync_timeline *obj)
 	else
 		sync_timeline_signal(obj);
 }
+EXPORT_SYMBOL(sync_timeline_destroy);
 
 static void sync_timeline_add_pt(struct sync_timeline *obj, struct sync_pt *pt)
 {
@@ -152,6 +155,7 @@ void sync_timeline_signal(struct sync_timeline *obj)
 		sync_fence_signal_pt(pt);
 	}
 }
+EXPORT_SYMBOL(sync_timeline_signal);
 
 struct sync_pt *sync_pt_create(struct sync_timeline *parent, int size)
 {
@@ -169,6 +173,7 @@ struct sync_pt *sync_pt_create(struct sync_timeline *parent, int size)
 
 	return pt;
 }
+EXPORT_SYMBOL(sync_pt_create);
 
 void sync_pt_free(struct sync_pt *pt)
 {
@@ -179,6 +184,7 @@ void sync_pt_free(struct sync_pt *pt)
 
 	kfree(pt);
 }
+EXPORT_SYMBOL(sync_pt_free);
 
 /* call with pt->parent->active_list_lock held */
 static int _sync_pt_has_signaled(struct sync_pt *pt)
@@ -284,6 +290,7 @@ struct sync_fence *sync_fence_create(const char *name, struct sync_pt *pt)
 
 	return fence;
 }
+EXPORT_SYMBOL(sync_fence_create);
 
 static int sync_fence_copy_pts(struct sync_fence *dst, struct sync_fence *src)
 {
@@ -331,16 +338,19 @@ err:
 	fput(file);
 	return NULL;
 }
+EXPORT_SYMBOL(sync_fence_fdget);
 
 void sync_fence_put(struct sync_fence *fence)
 {
 	fput(fence->file);
 }
+EXPORT_SYMBOL(sync_fence_put);
 
 void sync_fence_install(struct sync_fence *fence, int fd)
 {
 	fd_install(fd, fence->file);
 }
+EXPORT_SYMBOL(sync_fence_install);
 
 static int sync_fence_get_status(struct sync_fence *fence)
 {
@@ -388,6 +398,7 @@ err:
 	kfree(fence);
 	return NULL;
 }
+EXPORT_SYMBOL(sync_fence_merge);
 
 static void sync_fence_signal_pt(struct sync_pt *pt)
 {
@@ -447,6 +458,7 @@ out:
 
 	return err;
 }
+EXPORT_SYMBOL(sync_fence_wait_async);
 
 int sync_fence_cancel_async(struct sync_fence *fence,
 			     struct sync_fence_waiter *waiter)
@@ -475,6 +487,7 @@ int sync_fence_cancel_async(struct sync_fence *fence,
 	spin_unlock_irqrestore(&fence->waiter_list_lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL(sync_fence_cancel_async);
 
 int sync_fence_wait(struct sync_fence *fence, long timeout)
 {
@@ -500,6 +513,7 @@ int sync_fence_wait(struct sync_fence *fence, long timeout)
 
 	return 0;
 }
+EXPORT_SYMBOL(sync_fence_wait);
 
 static int sync_fence_release(struct inode *inode, struct file *file)
 {
-- 
1.7.10.4

