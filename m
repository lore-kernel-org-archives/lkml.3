Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3IWNH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:07:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39567 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3IWNHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:07:24 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-e1-52403d0a0ccc
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kyungmin.park@samsung.com
Cc: dwmw2@infradead.org, grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        linux-samsung-soc@vger.kernel.org, t.figa@samsung.com,
        m.szyprowski@samsung.com, b.zolnierkie@samsung.com,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH v2] MTD: Onenand: Add device tree support for samsung onenand
Date: Mon, 23 Sep 2013 15:06:48 +0200
Message-id: <1379941608-5068-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jAV0uW4cgg85uVYuNM9azWsw/co7V
	YuLKycwWB/7sYLQ492olo8XZpjfsFgvblrBYXN41h81id9MydosZ5/cxWZxec4rZYu2Ru+wW
	S69fZLKYMH0ti8XhFQeYLNa9nM5i8epgG4vF+hmvWRyEPNbMW8PoseDzFXaPlcu/sHlsXqHl
	8Wr1TFaPO9f2AHlL6j0OvtvD5NG3ZRWjx+dNch4b54YGcEdx2aSk5mSWpRbp2yVwZTQsv8pS
	8Ea94ty0Q4wNjC8Vuhg5OSQETCQm3utlh7DFJC7cW8/WxcjFISSwiFHi15n7UE47k8TXK0dY
	QKrYBMwlJj7bBGaLCMhKTJz8hRmkiFngBrPE9WefGEESwgK+EkvO3wCyOThYBFQl3uxyBwnz
	AoVbmvoZIbYpSPy8fIJtAiP3AkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBofxMegfj
	qgaLQ4wCHIxKPLyRifZBQqyJZcWVuYcYJTiYlUR4Fyk6BAnxpiRWVqUW5ccXleakFh9ilOZg
	URLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpgzJykMvOCQrfPAQsbtcrns14ckmPcnPT6E6/b
	xmXvXhz9ojjNIXnSWrfzsncO/Pnsfaw+K1zj4XzhKt+nz9RtX1/jOvnvqib753X55yquPfKs
	d1p3yV+/dEebyDGj4gX/E3hs2/ctm/sxpS95ir7nl0Xs014fFJs6dW+9s/vqPMG/MudzVzht
	mabEUpyRaKjFXFScCADrApI7YQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add clk and device tree nodes for samsung onenand driver.

since v1:
Updated Documentation according to Mark Rutland notes.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/mtd/samsung-onenand.txt    | 44 ++++++++++++++++++++++
 drivers/mtd/onenand/samsung.c                      | 37 +++++++++++++++++-
 2 files changed, 80 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/mtd/samsung-onenand.txt

diff --git a/Documentation/devicetree/bindings/mtd/samsung-onenand.txt b/Documentation/devicetree/bindings/mtd/samsung-onenand.txt
new file mode 100644
index 0000000..5bf931c
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/samsung-onenand.txt
@@ -0,0 +1,44 @@
+Device tree bindings for Samsung Onenand
+
+Required properties:
+  - compatible: value should be either of the following.
+      (a) "samsung,s3c6400-onenand",
+		for onenand controller compatible with s3c6400.
+      (b) "samsung,s3c6410-onenand",
+		for onenand controller compatible with s3c6410.
+      (c) "samsung,s5pc100-onenand",
+		for onenand controller compatible with s5pc100.
+      (d) "samsung,s5pc110-onenand",
+      for s5pc100-like onenand controller used on s5pc110 which supports DMA.
+
+Required properties for s5pc110:
+
+ - reg: the offset and length of the control registers. First region describes
+	OneNAND interface, second control registers.
+ - interrupt-parent, interrupts		Onenand memory interrupts
+
+Required properties for others:
+
+ - reg: the offset and length of the control registers. First region describes
+	control registers, second OneNAND interface.
+
+Clocks:
+ - gate - clock which output is supplied to external OneNAND flash memory.
+
+
+For partiton table parsing (optional) please refer to:
+ [1] Documentation/devicetree/bindings/mtd/partition.txt
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

