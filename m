Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323AbaBEALP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:11:15 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50042 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648AbaBEAJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:09:14 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Hackmann <ghackmann@google.com>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 1/7] staging: sw_sync: Add stubs for kernels without CONFIG_SW_SYNC
Date: Tue,  4 Feb 2014 16:08:34 -0800
Message-Id: <1391558920-31590-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391558920-31590-1-git-send-email-john.stultz@linaro.org>
References: <1391558920-31590-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Hackmann <ghackmann@google.com>

Add stubs for kernels without CONFIG_SW_SYNC

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Greg Hackmann <ghackmann@google.com>
[jstultz: resolved minor conflict, tweaked commit message]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/sw_sync.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/staging/android/sw_sync.h b/drivers/staging/android/sw_sync.h
index 585040b..5aaf71d 100644
--- a/drivers/staging/android/sw_sync.h
+++ b/drivers/staging/android/sw_sync.h
@@ -35,10 +35,27 @@ struct sw_sync_pt {
 	u32			value;
 };
 
+#if IS_ENABLED(CONFIG_SW_SYNC)
 struct sw_sync_timeline *sw_sync_timeline_create(const char *name);
 void sw_sync_timeline_inc(struct sw_sync_timeline *obj, u32 inc);
 
 struct sync_pt *sw_sync_pt_create(struct sw_sync_timeline *obj, u32 value);
+#else
+static inline struct sw_sync_timeline *sw_sync_timeline_create(const char *name)
+{
+	return NULL;
+}
+
+static inline void sw_sync_timeline_inc(struct sw_sync_timeline *obj, u32 inc)
+{
+}
+
+static inline struct sync_pt *sw_sync_pt_create(struct sw_sync_timeline *obj,
+		u32 value)
+{
+	return NULL;
+}
+#endif /* IS_ENABLED(CONFIG_SW_SYNC) */
 
 #endif /* __KERNEL __ */
 
-- 
1.8.3.2

