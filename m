Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbaBCSVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:21:50 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48521 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbaBCSQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:16:39 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Hackmann <ghackmann@google.com>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 05/16] staging: sw_sync: Add stubs for kernels without CONFIG_SW_SYNC
Date: Mon,  3 Feb 2014 10:16:17 -0800
Message-Id: <1391451388-23906-6-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391451388-23906-1-git-send-email-john.stultz@linaro.org>
References: <1391451388-23906-1-git-send-email-john.stultz@linaro.org>
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
index 06aa0b3..1a50669 100644
--- a/drivers/staging/android/sw_sync.h
+++ b/drivers/staging/android/sw_sync.h
@@ -34,9 +34,26 @@ struct sw_sync_pt {
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
 
 #endif /* _LINUX_SW_SYNC_H */
-- 
1.8.3.2

