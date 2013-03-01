Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab3CAAoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 19:44:05 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:60236 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3CAAn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 19:43:57 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Erik Gilling <konkers@android.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Rob Clark <robclark@gmail.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, dri-devel@lists.freedesktop.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 11/30] staging: sw_sync: Export sw_sync API
Date: Thu, 28 Feb 2013 16:43:07 -0800
Message-Id: <1362098606-26469-12-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
References: <1362098606-26469-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Gilling <konkers@android.com>

Needed to let modules link against sw_sync.

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
 drivers/staging/android/sw_sync.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/android/sw_sync.c b/drivers/staging/android/sw_sync.c
index 081e4d1..d689760 100644
--- a/drivers/staging/android/sw_sync.c
+++ b/drivers/staging/android/sw_sync.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/export.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
@@ -43,6 +44,7 @@ struct sync_pt *sw_sync_pt_create(struct sw_sync_timeline *obj, u32 value)
 
 	return (struct sync_pt *)pt;
 }
+EXPORT_SYMBOL(sw_sync_pt_create);
 
 static struct sync_pt *sw_sync_pt_dup(struct sync_pt *sync_pt)
 {
@@ -120,6 +122,7 @@ struct sw_sync_timeline *sw_sync_timeline_create(const char *name)
 
 	return obj;
 }
+EXPORT_SYMBOL(sw_sync_timeline_create);
 
 void sw_sync_timeline_inc(struct sw_sync_timeline *obj, u32 inc)
 {
@@ -127,7 +130,7 @@ void sw_sync_timeline_inc(struct sw_sync_timeline *obj, u32 inc)
 
 	sync_timeline_signal(&obj->obj);
 }
-
+EXPORT_SYMBOL(sw_sync_timeline_inc);
 
 #ifdef CONFIG_SW_SYNC_USER
 /* *WARNING*
-- 
1.7.10.4

