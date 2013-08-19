Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab3HSLiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:38:18 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:47010 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3HSLiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:38:17 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] mfd: dbx500-prcmu: Move PRCMU numerical clock identifiers into DT include file
Date: Mon, 19 Aug 2013 12:38:07 +0100
Message-Id: <1376912287-26460-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are required to request DBx500 PRCMU clocks from Device Tree. The
numbers used are taken directly from the Hardware Specification document.
We're moving them from the DBx500 PRCMU include file into the DT include
directory and referencing them from the former via a #include.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/dt-bindings/mfd/dbx500-prcmu.h | 84 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/dbx500-prcmu.h       | 77 +------------------------------
 2 files changed, 86 insertions(+), 75 deletions(-)
 create mode 100644 include/dt-bindings/mfd/dbx500-prcmu.h

diff --git a/include/dt-bindings/mfd/dbx500-prcmu.h b/include/dt-bindings/mfd/dbx500-prcmu.h
new file mode 100644
index 0000000..b7ee8c9
--- /dev/null
+++ b/include/dt-bindings/mfd/dbx500-prcmu.h
@@ -0,0 +1,84 @@
+/*
+ * This header provides constants for the PRCMU bindings.
+ *
+ */
+
+#ifndef _DT_BINDINGS_MFD_PRCMU_H
+#define _DT_BINDINGS_MFD_PRCMU_H
+
+/*
+ * Clock identifiers.
+ */
+#define ARMCLK			0
+#define PRCMU_ACLK		1
+#define PRCMU_SVAMMCSPCLK 	2
+#define PRCMU_SDMMCHCLK 	2  /* DBx540 only. */
+#define PRCMU_SIACLK 		3
+#define PRCMU_SIAMMDSPCLK 	3  /* DBx540 only. */
+#define PRCMU_SGACLK 		4
+#define PRCMU_UARTCLK 		5
+#define PRCMU_MSP02CLK 		6
+#define PRCMU_MSP1CLK 		7
+#define PRCMU_I2CCLK 		8
+#define PRCMU_SDMMCCLK 		9
+#define PRCMU_SLIMCLK 		10
+#define PRCMU_CAMCLK 		10 /* DBx540 only. */
+#define PRCMU_PER1CLK 		11
+#define PRCMU_PER2CLK 		12
+#define PRCMU_PER3CLK 		13
+#define PRCMU_PER5CLK 		14
+#define PRCMU_PER6CLK 		15
+#define PRCMU_PER7CLK 		16
+#define PRCMU_LCDCLK 		17
+#define PRCMU_BMLCLK 		18
+#define PRCMU_HSITXCLK 		19
+#define PRCMU_HSIRXCLK 		20
+#define PRCMU_HDMICLK		21
+#define PRCMU_APEATCLK 		22
+#define PRCMU_APETRACECLK 	23
+#define PRCMU_MCDECLK  	 	24
+#define PRCMU_IPI2CCLK  	25
+#define PRCMU_DSIALTCLK  	26
+#define PRCMU_DMACLK  	 	27
+#define PRCMU_B2R2CLK  	 	28
+#define PRCMU_TVCLK  	 	29
+#define SPARE_UNIPROCLK  	30
+#define PRCMU_SSPCLK  	 	31
+#define PRCMU_RNGCLK  	 	32
+#define PRCMU_UICCCLK  	 	33
+#define PRCMU_G1CLK             34 /* DBx540 only. */
+#define PRCMU_HVACLK            35 /* DBx540 only. */
+#define PRCMU_SPARE1CLK	 	36
+#define PRCMU_SPARE2CLK	 	37
+
+#define PRCMU_NUM_REG_CLOCKS  	38
+
+#define PRCMU_RTCCLK  	 	PRCMU_NUM_REG_CLOCKS
+#define PRCMU_SYSCLK  	 	39
+#define PRCMU_CDCLK  	 	40
+#define PRCMU_TIMCLK  	 	41
+#define PRCMU_PLLSOC0  	 	42
+#define PRCMU_PLLSOC1  	 	43
+#define PRCMU_ARMSS  	 	44
+#define PRCMU_PLLDDR  	 	45
+#define PRCMU_BML8580CLK        46
+
+/* DSI Clocks */
+#define PRCMU_PLLDSI  	 	47
+#define PRCMU_DSI0CLK 	  	48
+#define PRCMU_DSI1CLK  	 	49
+#define PRCMU_DSI0ESCCLK  	50
+#define PRCMU_DSI1ESCCLK  	51
+#define PRCMU_DSI2ESCCLK  	52
+
+/* LCD DSI PLL - Ux540 only */
+#define PRCMU_PLLDSI_LCD        53
+#define PRCMU_DSI0CLK_LCD       54
+#define PRCMU_DSI1CLK_LCD       55
+#define PRCMU_DSI0ESCCLK_LCD    56
+#define PRCMU_DSI1ESCCLK_LCD    57
+#define PRCMU_DSI2ESCCLK_LCD    58
+
+#define PRCMU_NUM_CLKS  	59
+
+#endif
diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index 87667d4..060e112 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -12,6 +12,8 @@
 #include <linux/notifier.h>
 #include <linux/err.h>
 
+#include <dt-bindings/mfd/dbx500-prcmu.h> /* For clock identifiers */
+
 /* Offset for the firmware version within the TCPM */
 #define DB8500_PRCMU_FW_VERSION_OFFSET 0xA4
 #define DBX540_PRCMU_FW_VERSION_OFFSET 0xA8
@@ -94,81 +96,6 @@ enum prcmu_wakeup_index {
 #define PRCMU_CLKSRC_ARMCLKFIX		0x46
 #define PRCMU_CLKSRC_HDMICLK		0x47
 
-/*
- * Clock identifiers.
- */
-#define ARMCLK			0
-#define PRCMU_ACLK		1
-#define PRCMU_SVAMMCSPCLK 	2
-#define PRCMU_SDMMCHCLK 	2  /* DBx540 only. */
-#define PRCMU_SIACLK 		3
-#define PRCMU_SIAMMDSPCLK 	3  /* DBx540 only. */
-#define PRCMU_SGACLK 		4
-#define PRCMU_UARTCLK 		5
-#define PRCMU_MSP02CLK 		6
-#define PRCMU_MSP1CLK 		7
-#define PRCMU_I2CCLK 		8
-#define PRCMU_SDMMCCLK 		9
-#define PRCMU_SLIMCLK 		10
-#define PRCMU_CAMCLK 		10 /* DBx540 only. */
-#define PRCMU_PER1CLK 		11
-#define PRCMU_PER2CLK 		12
-#define PRCMU_PER3CLK 		13
-#define PRCMU_PER5CLK 		14
-#define PRCMU_PER6CLK 		15
-#define PRCMU_PER7CLK 		16
-#define PRCMU_LCDCLK 		17
-#define PRCMU_BMLCLK 		18
-#define PRCMU_HSITXCLK 		19
-#define PRCMU_HSIRXCLK 		20
-#define PRCMU_HDMICLK		21
-#define PRCMU_APEATCLK 		22
-#define PRCMU_APETRACECLK 	23
-#define PRCMU_MCDECLK  	 	24
-#define PRCMU_IPI2CCLK  	25
-#define PRCMU_DSIALTCLK  	26
-#define PRCMU_DMACLK  	 	27
-#define PRCMU_B2R2CLK  	 	28
-#define PRCMU_TVCLK  	 	29
-#define SPARE_UNIPROCLK  	30
-#define PRCMU_SSPCLK  	 	31
-#define PRCMU_RNGCLK  	 	32
-#define PRCMU_UICCCLK  	 	33
-#define PRCMU_G1CLK             34 /* DBx540 only. */
-#define PRCMU_HVACLK            35 /* DBx540 only. */
-#define PRCMU_SPARE1CLK	 	36
-#define PRCMU_SPARE2CLK	 	37
-
-#define PRCMU_NUM_REG_CLOCKS  	38
-
-#define PRCMU_RTCCLK  	 	PRCMU_NUM_REG_CLOCKS
-#define PRCMU_SYSCLK  	 	39
-#define PRCMU_CDCLK  	 	40
-#define PRCMU_TIMCLK  	 	41
-#define PRCMU_PLLSOC0  	 	42
-#define PRCMU_PLLSOC1  	 	43
-#define PRCMU_ARMSS  	 	44
-#define PRCMU_PLLDDR  	 	45
-#define PRCMU_BML8580CLK        46
-
-/* DSI Clocks */
-#define PRCMU_PLLDSI  	 	47
-#define PRCMU_DSI0CLK 	  	48
-#define PRCMU_DSI1CLK  	 	49
-#define PRCMU_DSI0ESCCLK  	50
-#define PRCMU_DSI1ESCCLK  	51
-#define PRCMU_DSI2ESCCLK  	52
-
-/* LCD DSI PLL - Ux540 only */
-#define PRCMU_PLLDSI_LCD        53
-#define PRCMU_DSI0CLK_LCD       54
-#define PRCMU_DSI1CLK_LCD       55
-#define PRCMU_DSI0ESCCLK_LCD    56
-#define PRCMU_DSI1ESCCLK_LCD    57
-#define PRCMU_DSI2ESCCLK_LCD    58
-
-#define PRCMU_NUM_CLKS  	59
-
 /**
  * enum prcmu_wdog_id - PRCMU watchdog IDs
  * @PRCMU_WDOG_ALL: use all timers
-- 
1.8.1.2

