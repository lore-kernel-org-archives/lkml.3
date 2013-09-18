Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab3IRM0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:26:11 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:45247 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab3IRMOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:14:51 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 01/41] mfd: dbx500-prcmu: Correctly reorder PRCMU clock identifiers
Date: Wed, 18 Sep 2013 13:13:58 +0100
Message-Id: <1379506478-16625-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... as stipulated by the Hardware Specification document.

Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mfd/dbx500-prcmu.h | 135 ++++++++++++++++++++-------------------
 1 file changed, 71 insertions(+), 64 deletions(-)

diff --git a/include/linux/mfd/dbx500-prcmu.h b/include/linux/mfd/dbx500-prcmu.h
index ca0790f..87667d4 100644
--- a/include/linux/mfd/dbx500-prcmu.h
+++ b/include/linux/mfd/dbx500-prcmu.h
@@ -97,70 +97,77 @@ enum prcmu_wakeup_index {
 /*
  * Clock identifiers.
  */
-enum prcmu_clock {
-	PRCMU_SGACLK,
-	PRCMU_UARTCLK,
-	PRCMU_MSP02CLK,
-	PRCMU_MSP1CLK,
-	PRCMU_I2CCLK,
-	PRCMU_SDMMCCLK,
-	PRCMU_SPARE1CLK,
-	PRCMU_SLIMCLK,
-	PRCMU_PER1CLK,
-	PRCMU_PER2CLK,
-	PRCMU_PER3CLK,
-	PRCMU_PER5CLK,
-	PRCMU_PER6CLK,
-	PRCMU_PER7CLK,
-	PRCMU_LCDCLK,
-	PRCMU_BMLCLK,
-	PRCMU_HSITXCLK,
-	PRCMU_HSIRXCLK,
-	PRCMU_HDMICLK,
-	PRCMU_APEATCLK,
-	PRCMU_APETRACECLK,
-	PRCMU_MCDECLK,
-	PRCMU_IPI2CCLK,
-	PRCMU_DSIALTCLK,
-	PRCMU_DMACLK,
-	PRCMU_B2R2CLK,
-	PRCMU_TVCLK,
-	PRCMU_SSPCLK,
-	PRCMU_RNGCLK,
-	PRCMU_UICCCLK,
-	PRCMU_PWMCLK,
-	PRCMU_IRDACLK,
-	PRCMU_IRRCCLK,
-	PRCMU_SIACLK,
-	PRCMU_SVACLK,
-	PRCMU_ACLK,
-	PRCMU_HVACLK, /* Ux540 only */
-	PRCMU_G1CLK, /* Ux540 only */
-	PRCMU_SDMMCHCLK,
-	PRCMU_CAMCLK,
-	PRCMU_BML8580CLK,
-	PRCMU_NUM_REG_CLOCKS,
-	PRCMU_SYSCLK = PRCMU_NUM_REG_CLOCKS,
-	PRCMU_CDCLK,
-	PRCMU_TIMCLK,
-	PRCMU_PLLSOC0,
-	PRCMU_PLLSOC1,
-	PRCMU_ARMSS,
-	PRCMU_PLLDDR,
-	PRCMU_PLLDSI,
-	PRCMU_DSI0CLK,
-	PRCMU_DSI1CLK,
-	PRCMU_DSI0ESCCLK,
-	PRCMU_DSI1ESCCLK,
-	PRCMU_DSI2ESCCLK,
-	/* LCD DSI PLL - Ux540 only */
-	PRCMU_PLLDSI_LCD,
-	PRCMU_DSI0CLK_LCD,
-	PRCMU_DSI1CLK_LCD,
-	PRCMU_DSI0ESCCLK_LCD,
-	PRCMU_DSI1ESCCLK_LCD,
-	PRCMU_DSI2ESCCLK_LCD,
-};
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
 
 /**
  * enum prcmu_wdog_id - PRCMU watchdog IDs
-- 
1.8.1.2

