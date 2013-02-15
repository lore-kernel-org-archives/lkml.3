Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161872Ab3BOM6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:58:22 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:64350 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161706Ab3BOM6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:58:11 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 25/35] mfd: ab8500-core: Add additional resources to ab8505_iddet_resources
Date: Fri, 15 Feb 2013 12:56:56 +0000
Message-Id: <1360933026-30325-26-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add VBUS_DET_R, VBUS_DET_F IRQ, ID_DET_PLUGR and ID_DET_PLUGF IRQ
information to ab8505_iddet_resources. These are required to get
interrupts for AB8505 cut-2.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/ab8500-core.c         |   24 ++++++++++++++++++++++++
 include/linux/mfd/abx500/ab8500.h |    2 ++
 2 files changed, 26 insertions(+)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index bbbd6e4..17187c3 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -963,6 +963,30 @@ static struct resource ab8505_iddet_resources[] = {
 		.end   = AB8505_INT_KEYSTUCK,
 		.flags = IORESOURCE_IRQ,
 	},
+	{
+		.name = "VBUS_DET_R",
+		.start = AB8500_INT_VBUS_DET_R,
+		.end = AB8500_INT_VBUS_DET_R,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "VBUS_DET_F",
+		.start = AB8500_INT_VBUS_DET_F,
+		.end = AB8500_INT_VBUS_DET_F,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "ID_DET_PLUGR",
+		.start = AB8500_INT_ID_DET_PLUGR,
+		.end = AB8500_INT_ID_DET_PLUGR,
+		.flags = IORESOURCE_IRQ,
+	},
+	{
+		.name = "ID_DET_PLUGF",
+		.start = AB8500_INT_ID_DET_PLUGF,
+		.end = AB8500_INT_ID_DET_PLUGF,
+		.flags = IORESOURCE_IRQ,
+	},
 };
 
 static struct resource ab8500_temp_resources[] = {
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index 3e9131f..46418f3 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -163,12 +163,14 @@ enum ab8500_version {
 #define AB8500_INT_SRP_DETECT		88
 #define AB8500_INT_USB_CHARGER_NOT_OKR	89
 #define AB8500_INT_ID_WAKEUP_R		90
+#define AB8500_INT_ID_DET_PLUGR		91 /* 8505/9540 cut2.0 */
 #define AB8500_INT_ID_DET_R1R		92
 #define AB8500_INT_ID_DET_R2R		93
 #define AB8500_INT_ID_DET_R3R		94
 #define AB8500_INT_ID_DET_R4R		95
 /* ab8500_irq_regoffset[12] -> IT[Source|Latch|Mask]21 */
 #define AB8500_INT_ID_WAKEUP_F		96 /* not 8505/9540 */
+#define AB8500_INT_ID_DET_PLUGF		97 /* 8505/9540 cut2.0 */
 #define AB8500_INT_ID_DET_R1F		98 /* not 8505/9540 */
 #define AB8500_INT_ID_DET_R2F		99 /* not 8505/9540 */
 #define AB8500_INT_ID_DET_R3F		100 /* not 8505/9540 */
-- 
1.7.10.4

