Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaDUVMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 17:12:13 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:60896 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbaDUVMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 17:12:05 -0400
From: Alex Elder <elder@linaro.org>
To: mturquette@linaro.org, mporter@linaro.org, bcm@fixthebug.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 RESEND 3/7] clk: bcm281xx: change some symbol names
Date: Mon, 21 Apr 2014 16:11:39 -0500
Message-Id: <1398114703-32410-4-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398114703-32410-1-git-send-email-elder@linaro.org>
References: <1398114703-32410-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I developed the bcm281xx clock code I understood there were
restrictions on device tree "compatible" strings names, and as a
result "bcm11351" was used in places despite the part family being
more properly called "bcm281xx".  This can be a little confusing.

In some cases I went to far and things using "bcm11351" when that
was not necessary.

This patch remedies this.  It renames the symbol used to define the
"compatible" string (but not its value) so it uses "BCM281XX".
Similarly, the name names provided to the CLK_OF_DECLARE() macro
are changed, hoping to minimize the number of places that the
confusing "11351" string is used.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/bcm/clk-bcm281xx.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/bcm/clk-bcm281xx.c b/drivers/clk/bcm/clk-bcm281xx.c
index 3c66de6..bb947af 100644
--- a/drivers/clk/bcm/clk-bcm281xx.c
+++ b/drivers/clk/bcm/clk-bcm281xx.c
@@ -15,12 +15,17 @@
 #include "clk-kona.h"
 #include "dt-bindings/clock/bcm281xx.h"
 
-/* bcm11351 CCU device tree "compatible" strings */
-#define BCM11351_DT_ROOT_CCU_COMPAT	"brcm,bcm11351-root-ccu"
-#define BCM11351_DT_AON_CCU_COMPAT	"brcm,bcm11351-aon-ccu"
-#define BCM11351_DT_HUB_CCU_COMPAT	"brcm,bcm11351-hub-ccu"
-#define BCM11351_DT_MASTER_CCU_COMPAT	"brcm,bcm11351-master-ccu"
-#define BCM11351_DT_SLAVE_CCU_COMPAT	"brcm,bcm11351-slave-ccu"
+/*
+ * These are the bcm281xx CCU device tree "compatible" strings.
+ * We're stuck with using "bcm11351" in the string because wild
+ * cards aren't allowed, and that name was the first one defined
+ * in this family of devices.
+ */
+#define BCM281XX_DT_ROOT_CCU_COMPAT	"brcm,bcm11351-root-ccu"
+#define BCM281XX_DT_AON_CCU_COMPAT	"brcm,bcm11351-aon-ccu"
+#define BCM281XX_DT_HUB_CCU_COMPAT	"brcm,bcm11351-hub-ccu"
+#define BCM281XX_DT_MASTER_CCU_COMPAT	"brcm,bcm11351-master-ccu"
+#define BCM281XX_DT_SLAVE_CCU_COMPAT	"brcm,bcm11351-slave-ccu"
 
 /* Root CCU clocks */
 
@@ -404,13 +409,13 @@ static void __init kona_dt_slave_ccu_setup(struct device_node *node)
 	kona_dt_ccu_setup(node, bcm281xx_slave_ccu_clks_setup);
 }
 
-CLK_OF_DECLARE(bcm11351_root_ccu, BCM11351_DT_ROOT_CCU_COMPAT,
+CLK_OF_DECLARE(bcm281xx_root_ccu, BCM281XX_DT_ROOT_CCU_COMPAT,
 			kona_dt_root_ccu_setup);
-CLK_OF_DECLARE(bcm11351_aon_ccu, BCM11351_DT_AON_CCU_COMPAT,
+CLK_OF_DECLARE(bcm281xx_aon_ccu, BCM281XX_DT_AON_CCU_COMPAT,
 			kona_dt_aon_ccu_setup);
-CLK_OF_DECLARE(bcm11351_hub_ccu, BCM11351_DT_HUB_CCU_COMPAT,
+CLK_OF_DECLARE(bcm281xx_hub_ccu, BCM281XX_DT_HUB_CCU_COMPAT,
 			kona_dt_hub_ccu_setup);
-CLK_OF_DECLARE(bcm11351_master_ccu, BCM11351_DT_MASTER_CCU_COMPAT,
+CLK_OF_DECLARE(bcm281xx_master_ccu, BCM281XX_DT_MASTER_CCU_COMPAT,
 			kona_dt_master_ccu_setup);
-CLK_OF_DECLARE(bcm11351_slave_ccu, BCM11351_DT_SLAVE_CCU_COMPAT,
+CLK_OF_DECLARE(bcm281xx_slave_ccu, BCM281XX_DT_SLAVE_CCU_COMPAT,
 			kona_dt_slave_ccu_setup);
-- 
1.9.1

