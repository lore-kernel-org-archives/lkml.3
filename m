Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaBGEnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 23:43:13 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:25051 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaBGEnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 23:43:10 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-77-52f4645bffb1
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        naveenkrishna.ch@gmail.com, kgene.kim@samsung.com, wsa@the-dreams.de,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2 v4] i2c: exynos5: add support for HSI2C on Exynos5260 SoC
Date: Fri, 07 Feb 2014 10:12:51 +0530
Message-id: <1391748171-12451-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385100726-32165-1-git-send-email-ch.naveen@samsung.com>
References: <1385100726-32165-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsWyRsSkTjc65UuQwe3rBha9C66yWWx6fI3V
	ouPvF0aLy7vmsFnMOL+PyWLRtv/MFitPzGJ2YPfYOesuu8fmJfUefVtWMXqcPPWExePzJrkA
	1igum5TUnMyy1CJ9uwSujKULpjEXXJGr6NnTx9jA2C7ZxcjJISFgIrFtwzsmCFtM4sK99Wxd
	jFwcQgJLGSW+POpngSl6/Oo2WJGQwCJGiQ1PoYr6mSR2XfzBBpJgEzCTOLhoNTuILSIgK9H6
	YA0ziM0ssJlRYnOrJYgtLOArsfj9J6B6Dg4WAVWJzl3aIGFeAVeJ8+87WEDCEgIKEnMm2YCE
	OQXcJK5enMYOsdZVomX1GSaQtRIC89glPl68zgqSYBEQkPg2+RBUr6zEpgPMECdLShxccYNl
	AqPwAkaGVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxiBAX7637OJOxjvH7A+xJgMNG4is5Ro
	cj4wQvJK4g2NzYwsTE1MjY3MLc1IE1YS501/lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1Oq
	gTF6Nte/cuazpx82c5mq/d/1cXpg7YyIw34Fcw8GbTctK1+qkb/sq5r4A7WmkLff2HVP50t/
	5pIonttR4NJ5WCH9ud/3o8erzW9NM1i8XvaS4my59bn71jDEOq/ICH//7+juylSWomC+pc/m
	v06cZ2gS9plt0yWv7EiW/f+lu6dmvrd8FMq3NFKJpTgj0VCLuag4EQD6/5r4hgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jAd3olC9BBn0f1Sx6F1xls9j0+Bqr
	RcffL4wWl3fNYbOYcX4fk8Wibf+ZLVaemMXswO6xc9Zddo/NS+o9+rasYvQ4eeoJi8fnTXIB
	rFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGco
	KZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDOWLpjGXHBFrqJnTx9jA2O7
	ZBcjJ4eEgInE41e3mSBsMYkL99azgdhCAosYJTY8BbK5gOx+JoldF3+AJdgEzCQOLlrNDmKL
	CMhKtD5YwwxiMwtsZpTY3GoJYgsL+Eosfv8JqJ6Dg0VAVaJzlzZImFfAVeL8+w4WkLCEgILE
	nEk2IGFOATeJqxensUOsdZVoWX2GaQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsY
	wfHzTHoH46oGi0OMAhyMSjy8J5Z+DhJiTSwrrsw9xCjBwawkwsud8CVIiDclsbIqtSg/vqg0
	J7X4EGMy0E0TmaVEk/OBsZ1XEm9obGJuamxqaWJhYmZJmrCSOO/BVutAIYH0xJLU7NTUgtQi
	mC1MHJxSDYxNrZyfpwocunJ4ruyVALF/iTZKi8RPz9u3b6bDxa2mj28bfI2+L7xjfXXZyVbV
	+6v3zFM8ZFA5n6PvK79E795naaX5V7y2um/8Ub+9PMX35uRbi4IsXqbJ3w6apaUXo+J2L9lV
	6K+qke+Pv9uO5D9+VR2sWjP30cYDboLJXUfc+PbkLjZruXVRiaU4I9FQi7moOBEAfRBH2OMC	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new compatible and uses variant struct to support
HSI2C module on Exynos5260. Updates the Documentation dt bindings.
Also resets the module as an init sequence (Needed by Exynos5260).

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v3:
1. split patches as (v1 version does)
   add exynso5260 suppport and handle fifo depths
2. keep the old - compatible = "samsung,exynos5-hsi2c";
   mark it as (DEPRECATED)

 .../devicetree/bindings/i2c/i2c-exynos5.txt        |   11 ++++-
 drivers/i2c/busses/i2c-exynos5.c                   |   46 ++++++++++++++++++--
 2 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
index 056732c..d4745e3 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
@@ -5,7 +5,14 @@ at various speeds ranging from 100khz to 3.4Mhz.
 
 Required properties:
   - compatible: value should be.
-      -> "samsung,exynos5-hsi2c", for i2c compatible with exynos5 hsi2c.
+	-> "samsung,exynos5-hsi2c", (DEPRECATED)
+				for i2c compatible with HSI2C available
+				on Exynos5250 and Exynos5420 SoCs.
+	-> "samsung,exynos5250-hsi2c", for i2c compatible with HSI2C available
+				on Exynos5250 and Exynos5420 SoCs.
+	-> "samsung,exynos5260-hsi2c", for i2c compatible with HSI2C available
+				on Exynos5260 SoCs.
+
   - reg: physical base address of the controller and length of memory mapped
     region.
   - interrupts: interrupt number to the cpu.
@@ -26,7 +33,7 @@ Optional properties:
 Example:
 
 hsi2c@12ca0000 {
-	compatible = "samsung,exynos5-hsi2c";
+	compatible = "samsung,exynos5250-hsi2c";
 	reg = <0x12ca0000 0x100>;
 	interrupts = <56>;
 	clock-frequency = <100000>;
diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index 9fd711c..12730d1 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -183,14 +183,54 @@ struct exynos5_i2c {
 	 * 2. Fast speed upto 1Mbps
 	 */
 	int			speed_mode;
+
+	/* Version of HS-I2C Hardware */
+	struct exynos_hsi2c_variant	*variant;
+};
+
+/**
+ * struct exynos_hsi2c_variant - platform specific HSI2C driver data
+ * @fifo_depth: the fifo depth supported by the HSI2C module
+ *
+ * Specifies platform specific configuration of HSI2C module.
+ * Note: A structure for driver specific platform data is used for future
+ * expansion of its usage.
+ */
+struct exynos_hsi2c_variant {
+	unsigned int		    fifo_depth;
+};
+
+static const struct exynos_hsi2c_variant exynos5250_hsi2c_data = {
+	.fifo_depth	= 64,
+};
+
+static const struct exynos_hsi2c_variant exynos5260_hsi2c_data = {
+	.fifo_depth	= 16,
 };
 
 static const struct of_device_id exynos5_i2c_match[] = {
-	{ .compatible = "samsung,exynos5-hsi2c" },
-	{},
+	{
+		.compatible = "samsung,exynos5-hsi2c"
+		.data = &exynos5250_hsi2c_data
+	}, {
+		.compatible = "samsung,exynos5250-hsi2c",
+		.data = &exynos5250_hsi2c_data
+	}, {
+		.compatible = "samsung,exynos5260-hsi2c",
+		.data = &exynos5260_hsi2c_data
+	}, {},
 };
 MODULE_DEVICE_TABLE(of, exynos5_i2c_match);
 
+static inline struct exynos_hsi2c_variant *exynos5_i2c_get_variant
+					(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+
+	match = of_match_node(exynos5_i2c_match, pdev->dev.of_node);
+	return (struct exynos_hsi2c_variant *)match->data;
+}
+
 static void exynos5_i2c_clr_pend_irq(struct exynos5_i2c *i2c)
 {
 	writel(readl(i2c->regs + HSI2C_INT_STATUS),
@@ -691,7 +731,7 @@ static int exynos5_i2c_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_clk;
 
-	exynos5_i2c_init(i2c);
+	exynos5_i2c_reset(i2c);
 
 	ret = i2c_add_adapter(&i2c->adap);
 	if (ret < 0) {
-- 
1.7.9.5

