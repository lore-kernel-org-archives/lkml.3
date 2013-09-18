Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab3IRMZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:25:48 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54766 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab3IRMOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:14:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 03/41] mfd: dbx500: Remove any mention of the BML8580CLK
Date: Wed, 18 Sep 2013 13:14:00 +0100
Message-Id: <1379506478-16625-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
References: <1379506478-16625-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform which it pertains to is no longer supported and is actually
causing some confusion in the new common clock implementation. A recent
patch removed its use in the clock driver, let's take out the definitions
too.

Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/db8500-prcmu.c             |  1 -
 drivers/mfd/dbx500-prcmu-regs.h        |  1 -
 include/dt-bindings/mfd/dbx500-prcmu.h | 27 +++++++++++++--------------
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 3c157faee..ed79d7b 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -480,7 +480,6 @@ struct clk_mgt clk_mgt[PRCMU_NUM_REG_CLOCKS] = {
 	CLK_MGT_ENTRY(PER6CLK, PLL_DIV, true),
 	CLK_MGT_ENTRY(PER7CLK, PLL_DIV, true),
 	CLK_MGT_ENTRY(LCDCLK, PLL_FIX, true),
-	CLK_MGT_ENTRY(BML8580CLK, PLL_DIV, true),
 	CLK_MGT_ENTRY(BMLCLK, PLL_DIV, true),
 	CLK_MGT_ENTRY(HSITXCLK, PLL_DIV, true),
 	CLK_MGT_ENTRY(HSIRXCLK, PLL_DIV, true),
diff --git a/drivers/mfd/dbx500-prcmu-regs.h b/drivers/mfd/dbx500-prcmu-regs.h
index 4f6f0fa..7cc32a8 100644
--- a/drivers/mfd/dbx500-prcmu-regs.h
+++ b/drivers/mfd/dbx500-prcmu-regs.h
@@ -32,7 +32,6 @@
 #define PRCM_PER7CLK_MGT	(0x040)
 #define PRCM_LCDCLK_MGT		(0x044)
 #define PRCM_BMLCLK_MGT		(0x04C)
-#define PRCM_BML8580CLK_MGT	(0x108)
 #define PRCM_HSITXCLK_MGT	(0x050)
 #define PRCM_HSIRXCLK_MGT	(0x054)
 #define PRCM_HDMICLK_MGT	(0x058)
diff --git a/include/dt-bindings/mfd/dbx500-prcmu.h b/include/dt-bindings/mfd/dbx500-prcmu.h
index b7ee8c9..552a2d1 100644
--- a/include/dt-bindings/mfd/dbx500-prcmu.h
+++ b/include/dt-bindings/mfd/dbx500-prcmu.h
@@ -61,24 +61,23 @@
 #define PRCMU_PLLSOC1  	 	43
 #define PRCMU_ARMSS  	 	44
 #define PRCMU_PLLDDR  	 	45
-#define PRCMU_BML8580CLK        46
 
 /* DSI Clocks */
-#define PRCMU_PLLDSI  	 	47
-#define PRCMU_DSI0CLK 	  	48
-#define PRCMU_DSI1CLK  	 	49
-#define PRCMU_DSI0ESCCLK  	50
-#define PRCMU_DSI1ESCCLK  	51
-#define PRCMU_DSI2ESCCLK  	52
+#define PRCMU_PLLDSI  	 	46
+#define PRCMU_DSI0CLK 	  	47
+#define PRCMU_DSI1CLK  	 	48
+#define PRCMU_DSI0ESCCLK  	49
+#define PRCMU_DSI1ESCCLK  	50
+#define PRCMU_DSI2ESCCLK  	51
 
 /* LCD DSI PLL - Ux540 only */
-#define PRCMU_PLLDSI_LCD        53
-#define PRCMU_DSI0CLK_LCD       54
-#define PRCMU_DSI1CLK_LCD       55
-#define PRCMU_DSI0ESCCLK_LCD    56
-#define PRCMU_DSI1ESCCLK_LCD    57
-#define PRCMU_DSI2ESCCLK_LCD    58
+#define PRCMU_PLLDSI_LCD        52
+#define PRCMU_DSI0CLK_LCD       53
+#define PRCMU_DSI1CLK_LCD       54
+#define PRCMU_DSI0ESCCLK_LCD    55
+#define PRCMU_DSI1ESCCLK_LCD    56
+#define PRCMU_DSI2ESCCLK_LCD    57
 
-#define PRCMU_NUM_CLKS  	59
+#define PRCMU_NUM_CLKS  	58
 
 #endif
-- 
1.8.1.2

