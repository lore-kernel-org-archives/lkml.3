Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaDQUwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:52:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40728 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbaDQUu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:50:29 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 02/19] bus: omap_l3_noc: rename functions and data to omap_l3
Date: Thu, 17 Apr 2014 15:49:18 -0500
Message-ID: <1397767775-10965-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397767775-10965-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1397767775-10965-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sricharan R <r.sricharan@ti.com>

Since omap_l3_noc driver is now being used for OMAP5 and reusable with
DRA7 and AM437x, using omap4 specific naming is misleading.

Signed-off-by: Sricharan R <r.sricharan@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---

V2: reordered the patch
V1: https://patchwork.kernel.org/patch/3984321/

 drivers/bus/omap_l3_noc.c |   24 ++++++++++++------------
 drivers/bus/omap_l3_noc.h |   11 ++++++-----
 2 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 1eb6d85..800486c 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -1,5 +1,5 @@
 /*
- * OMAP4XXX L3 Interconnect error handling driver
+ * OMAP L3 Interconnect error handling driver
  *
  * Copyright (C) 2011-2014 Texas Instruments Incorporated - http://www.ti.com/
  *	Santosh Shilimkar <santosh.shilimkar@ti.com>
@@ -50,7 +50,7 @@
 static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 {
 
-	struct omap4_l3 *l3 = _l3;
+	struct omap_l3 *l3 = _l3;
 	int inttype, i, k;
 	int err_src = 0;
 	u32 std_err_main, err_reg, clear, masterid;
@@ -122,9 +122,9 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
 	return IRQ_HANDLED;
 }
 
-static int omap4_l3_probe(struct platform_device *pdev)
+static int omap_l3_probe(struct platform_device *pdev)
 {
-	static struct omap4_l3 *l3;
+	static struct omap_l3 *l3;
 	int ret, i;
 
 	l3 = devm_kzalloc(&pdev->dev, sizeof(*l3), GFP_KERNEL);
@@ -176,8 +176,8 @@ MODULE_DEVICE_TABLE(of, l3_noc_match);
 #define l3_noc_match NULL
 #endif
 
-static struct platform_driver omap4_l3_driver = {
-	.probe		= omap4_l3_probe,
+static struct platform_driver omap_l3_driver = {
+	.probe		= omap_l3_probe,
 	.driver		= {
 		.name		= "omap_l3_noc",
 		.owner		= THIS_MODULE,
@@ -185,14 +185,14 @@ static struct platform_driver omap4_l3_driver = {
 	},
 };
 
-static int __init omap4_l3_init(void)
+static int __init omap_l3_init(void)
 {
-	return platform_driver_register(&omap4_l3_driver);
+	return platform_driver_register(&omap_l3_driver);
 }
-postcore_initcall_sync(omap4_l3_init);
+postcore_initcall_sync(omap_l3_init);
 
-static void __exit omap4_l3_exit(void)
+static void __exit omap_l3_exit(void)
 {
-	platform_driver_unregister(&omap4_l3_driver);
+	platform_driver_unregister(&omap_l3_driver);
 }
-module_exit(omap4_l3_exit);
+module_exit(omap_l3_exit);
diff --git a/drivers/bus/omap_l3_noc.h b/drivers/bus/omap_l3_noc.h
index cc4b1b1..b3c81f2 100644
--- a/drivers/bus/omap_l3_noc.h
+++ b/drivers/bus/omap_l3_noc.h
@@ -1,5 +1,5 @@
 /*
- * OMAP4XXX L3 Interconnect  error handling driver header
+ * OMAP L3 Interconnect  error handling driver header
  *
  * Copyright (C) 2011-2014 Texas Instruments Incorporated - http://www.ti.com/
  *	Santosh Shilimkar <santosh.shilimkar@ti.com>
@@ -14,8 +14,8 @@
  * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
-#ifndef __ARCH_ARM_MACH_OMAP2_L3_INTERCONNECT_3XXX_H
-#define __ARCH_ARM_MACH_OMAP2_L3_INTERCONNECT_3XXX_H
+#ifndef __OMAP_L3_NOC_H
+#define __OMAP_L3_NOC_H
 
 #define L3_MODULES			3
 #define CLEAR_STDERR_LOG		(1 << 31)
@@ -157,7 +157,7 @@ static u32 *l3_targ[L3_MODULES] = {
 	l3_targ_inst_clk3,
 };
 
-struct omap4_l3 {
+struct omap_l3 {
 	struct device *dev;
 	struct clk *ick;
 
@@ -167,4 +167,5 @@ struct omap4_l3 {
 	int debug_irq;
 	int app_irq;
 };
-#endif
+
+#endif	/* __OMAP_L3_NOC_H */
-- 
1.7.9.5

