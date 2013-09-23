Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab3IWIgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:36:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:42938 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab3IWIgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:36:49 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-ec-523ffd9fdeb7
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kyungmin.park@samsung.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, rob@landley.net, dwmw2@infradead.org,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, m.szyprowski@samsung.com,
        t.figa@samsung.com, Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH] MTD: Onenand: Add device tree support for samsung onenand
Date: Mon, 23 Sep 2013 10:36:28 +0200
Message-id: <1379925388-25051-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t9jQd35f+2DDObd57WYf+Qcq8XElZOZ
	LQ782cFocbbpDbvFwrYlLBaXd81hs9jdtIzd4vSaU8wWa4/cZbdYev0ik8WE6WtZLA6vOMBk
	se7ldBaLVwfbWCzWz3jN4sDvsWbeGkaPBZ+vsHtsXqHl8Wr1TFaPO9f2sHlsXlLvcfDdHiaP
	vi2rGD0+b5Lz2Dg3NIArissmJTUnsyy1SN8ugSvjdfNlxoILqhXHvzxnb2C8L9fFyMkhIWAi
	8eXvPUYIW0ziwr31bF2MXBxCAtMZJe7OfsYM4bQzSby7M40ZpIpNwFxi4rNNLCC2iICsxMTJ
	X8CKmAV+MUkse7sZLCEs4CXx7PokoLEcHCwCqhKTXkWBhHkF/CT6Zv6G2qYg8fPyCbYJjNwL
	GBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgSH6DPpHYyrGiwOMQpwMCrx8EYm2gcJsSaW
	FVfmHmKU4GBWEuFt6gQK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoE
	k2Xi4JRqYGR7HRZnHHvoTv3+mP1yy8O6XyxMrjZYzZ/R1x/r/znLT+69ltTlZat7Tjm9Cz73
	8tSGyFzpONeIqY+3vjvYapy/b7dy2Ua3jYJ7J9zzWtg79Yi29K38ltlme+U2qLzfkrLt6v58
	k69J7i+WXHWa+y4+J1tL5NHDmPztMjXbN2zjkC7sNvggO0uJpTgj0VCLuag4EQAGVSGyTQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add clk and device tree nodes for samsung onenand driver.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/mtd/samsung-onenand.txt    | 40 ++++++++++++++++++++++
 drivers/mtd/onenand/samsung.c                      | 37 +++++++++++++++++++-
 2 files changed, 76 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/mtd/samsung-onenand.txt

diff --git a/Documentation/devicetree/bindings/mtd/samsung-onenand.txt b/Documentation/devicetree/bindings/mtd/samsung-onenand.txt
new file mode 100644
index 0000000..cc46160
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/samsung-onenand.txt
@@ -0,0 +1,40 @@
+Device tree bindings for Samsung Onenand
+
+Required properties:
+  - compatible: value should be either of the following.
+      (a) "samsung, s3c6400-onenand", for onenand compatible with s3c6400 onenand.
+      (b) "samsung, s3c6410-onenand", for onenand compatible with s3c6410 onenand.
+      (c) "samsung, s5pc100-onenand", for onenand compatible with s5pc100 onenand.
+      (d) "samsung, s5pc110-onenand", for s5pc100-like onenand used
+	   on s5pc110 which supports DMA.
+
+Required properties:
+
+ - reg:					The CS line the peripheral
+					is connected to
+ - interrupt-parent, interrupts		Width of the ONENAND device
+ - 					connected to the Samsung SoC
+					in bytes. Must be 1 or 2.
+
+Optional properties:
+
+ - dma-channel:		DMA Channel index
+
+For inline partiton table parsing (optional):
+
+ - #address-cells: should be set to 1
+ - #size-cells: should be set to 1
+
+Example for an s5pv210 board:
+
+		onenand@b0000000 {
+			compatible = "samsung,s5pc110-onenand";
+			reg = <0xb0000000 0x20000>, <0xb0600000 0x2000>;
+			interrupt-parent = <&vic1>;
+			interrupts = <31>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			clocks = <&clocks NANDXL>;
+			clock-names = "gate";
+			status = "okay";
+		};
diff --git a/drivers/mtd/onenand/samsung.c b/drivers/mtd/onenand/samsung.c
index df7400d..5a2cc4b 100644
--- a/drivers/mtd/onenand/samsung.c
+++ b/drivers/mtd/onenand/samsung.c
@@ -14,6 +14,7 @@
  *	S5PC110: use DMA
  */
 
+#include <linux/clk.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/sched.h>
@@ -24,6 +25,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/of.h>
 
 #include <asm/mach/flash.h>
 
@@ -133,6 +135,7 @@ enum soc_type {
 struct s3c_onenand {
 	struct mtd_info	*mtd;
 	struct platform_device	*pdev;
+	struct clk *gate;
 	enum soc_type	type;
 	void __iomem	*base;
 	struct resource *base_res;
@@ -859,6 +862,19 @@ static void s3c_onenand_setup(struct mtd_info *mtd)
 	this->write_bufferram = onenand_write_bufferram;
 }
 
+static const struct of_device_id onenand_s3c_dt_match[] = {
+	{ .compatible = "samsung,s3c6400-onenand",
+		.data = (void *)TYPE_S3C6400 },
+	{ .compatible = "samsung,s3c6410-onenand",
+		.data = (void *)TYPE_S3C6410 },
+	{ .compatible = "samsung,s5pc100-onenand",
+		.data = (void *)TYPE_S5PC100 },
+	{ .compatible = "samsung,s5pc110-onenand",
+		.data = (void *)TYPE_S5PC110 },
+	{},
+};
+MODULE_DEVICE_TABLE(of, onenand_s3c_dt_match);
+
 static int s3c_onenand_probe(struct platform_device *pdev)
 {
 	struct onenand_platform_data *pdata;
@@ -883,12 +899,26 @@ static int s3c_onenand_probe(struct platform_device *pdev)
 		goto onenand_fail;
 	}
 
+	onenand->gate = clk_get(&pdev->dev, "gate");
+	if (IS_ERR(onenand->gate))
+		return PTR_ERR(onenand->gate);
+	clk_prepare_enable(onenand->gate);
+
 	this = (struct onenand_chip *) &mtd[1];
 	mtd->priv = this;
 	mtd->dev.parent = &pdev->dev;
 	mtd->owner = THIS_MODULE;
 	onenand->pdev = pdev;
-	onenand->type = platform_get_device_id(pdev)->driver_data;
+
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+
+		match = of_match_node(onenand_s3c_dt_match, pdev->dev.of_node);
+		onenand->type = (enum soc_type)match->data;
+	} else {
+		onenand->type = platform_get_device_id(pdev)->driver_data;
+	}
+
 
 	s3c_onenand_setup(mtd);
 
@@ -1077,6 +1107,10 @@ static int s3c_onenand_remove(struct platform_device *pdev)
 	kfree(onenand->page_buf);
 	kfree(onenand);
 	kfree(mtd);
+
+	clk_disable_unprepare(onenand->gate);
+	clk_put(onenand->gate);
+
 	return 0;
 }
 
@@ -1125,6 +1159,7 @@ MODULE_DEVICE_TABLE(platform, s3c_onenand_driver_ids);
 static struct platform_driver s3c_onenand_driver = {
 	.driver         = {
 		.name	= "samsung-onenand",
+		.of_match_table = of_match_ptr(onenand_s3c_dt_match),
 		.pm	= &s3c_pm_ops,
 	},
 	.id_table	= s3c_onenand_driver_ids,
-- 
1.8.1.2

