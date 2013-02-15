Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161928Ab3BONDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:03:06 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33928 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161701Ab3BOM5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:55 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        zhoubin <bin.zhou@stericsson.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 17/35] mfd: ab8500: Introduce AB8540 cuts definition
Date: Fri, 15 Feb 2013 12:56:48 +0000
Message-Id: <1360933026-30325-18-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: zhoubin <bin.zhou@stericsson.com>

Add AB8540 cuts definition and its associated helper functions.

Signed-off-by: zhoubin <bin.zhou@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Ying Bao JIA <yingbao.jia@stericsson.com>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
Reviewed-by: Philippe LANGLAIS <philippe.langlais@stericsson.com>
Tested-by: Xiao Mei ZHANG <xiaomei.zhang@stericsson.com>
Tested-by: Maxime COQUELIN <maxime.coquelin@stericsson.com>
---
 include/linux/mfd/abx500/ab8500.h |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 7e323fc..06a8292 100644
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
@@ -442,6 +443,31 @@ static inline int is_ab9540_2p0_or_earlier(struct ab8500 *ab)
        return (is_ab9540(ab) && (ab->chip_id < AB8500_CUT2P0));
 }
 
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
 #ifdef CONFIG_AB8500_DEBUG
 void ab8500_dump_all_banks(struct device *dev);
 void ab8500_debug_register_interrupt(int line);
-- 
1.7.10.4

