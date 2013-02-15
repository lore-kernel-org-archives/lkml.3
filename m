Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161766Ab3BONIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:08:23 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:52140 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161211Ab3BOMpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:44 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, cbouatmailru@gmail.com,
        sameo@linux.intel.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/40] mfd: Differentiate between newly added abx500 based platforms
Date: Fri, 15 Feb 2013 12:44:31 +0000
Message-Id: <1360932310-30065-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
References: <1360932310-30065-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide the functionality to check for more abx500 type platforms.
These new platforms include: ab9540v3, <=ab8540v1, <=ab8540v1.1,
<=ab8540v1.2, <=ab8540v2, ab8540v2, <=ab8505v2 and <=ab9540v2.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mfd/abx500/ab8500.h |   46 +++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index b9a6a84..28bffd0 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -32,6 +32,7 @@ enum ab8500_version {
 #define AB8500_CUTEARLY	0x00
 #define AB8500_CUT1P0	0x10
 #define AB8500_CUT1P1	0x11
+#define AB8500_CUT1P2	0x12 /* Only valid for AB8540 */
 #define AB8500_CUT2P0	0x20
 #define AB8500_CUT3P0	0x30
 #define AB8500_CUT3P3	0x33
@@ -365,4 +366,49 @@ static inline int is_ab9540_2p0(struct ab8500 *ab)
 {
 	return (is_ab9540(ab) && (ab->chip_id == AB8500_CUT2P0));
 }
+
+/*
+ * Be careful, the marketing name for this chip is 2.1
+ * but the value read from the chip is 3.0 (0x30)
+ */
+static inline int is_ab9540_3p0(struct ab8500 *ab)
+{
+	return (is_ab9540(ab) && (ab->chip_id == AB8500_CUT3P0));
+}
+
+static inline int is_ab8540_1p0_or_earlier(struct ab8500 *ab)
+{
+	return is_ab8540(ab) && (ab->chip_id <= AB8500_CUT1P0);
+}
+
+static inline int is_ab8540_1p1_or_earlier(struct ab8500 *ab)
+{
+	return is_ab8540(ab) && (ab->chip_id <= AB8500_CUT1P1);
+}
+
+static inline int is_ab8540_1p2_or_earlier(struct ab8500 *ab)
+{
+	return is_ab8540(ab) && (ab->chip_id <= AB8500_CUT1P2);
+}
+
+static inline int is_ab8540_2p0_or_earlier(struct ab8500 *ab)
+{
+	return is_ab8540(ab) && (ab->chip_id <= AB8500_CUT2P0);
+}
+
+static inline int is_ab8540_2p0(struct ab8500 *ab)
+{
+	return is_ab8540(ab) && (ab->chip_id == AB8500_CUT2P0);
+}
+
+static inline int is_ab8505_2p0_earlier(struct ab8500 *ab)
+{
+	return (is_ab8505(ab) && (ab->chip_id < AB8500_CUT2P0));
+}
+
+static inline int is_ab9540_2p0_or_earlier(struct ab8500 *ab)
+{
+	return (is_ab9540(ab) && (ab->chip_id < AB8500_CUT2P0));
+}
+
 #endif /* MFD_AB8500_H */
-- 
1.7.10.4

