Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbaBFMHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 07:07:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63937 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226AbaBFMHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 07:07:10 -0500
X-AuditID: cbfee68f-b7f156d00000276c-8f-52f37aed96aa
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        naveenkrishna.ch@gmail.com, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, taeggyun.ko@samsung.com, balbi@ti.com,
        cpgs@samsung.com, t.figa@samsung.com
Subject: [PATCH 1/2 v3] i2c: exynos5: add support for HSI2C on Exynos5260 SoC
Date: Thu, 06 Feb 2014 17:36:48 +0530
Message-id: <1391688408-8077-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385100851-32254-1-git-send-email-ch.naveen@samsung.com>
References: <1385100851-32254-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWyRsSkVvdt1ecgg8trOSwO3q+3eHlI0+LA
	7IesFq/ObGSz6F1wlc1i0+NrrBYdf78wWlzeNYfNYsb5fUwWi7b9Z7ZYP+M1i8WT/0Cxfa+3
	MjvweuycdZfdY/OSeo/zMxYyevT/NfDo27KK0ePnSx2P4ze2M3l83iQXwBHFZZOSmpNZllqk
	b5fAlXH4wQnWgqm6Fb3zdBsY/6h0MXJySAiYSMw9u4YdwhaTuHBvPVsXIxeHkMBSRomDZy+w
	wxQtvdIPlZjOKDHj9kRGCKefSWL7rdMsIFVsAmYSBxetBusQEXCQmLf2OztIEbPAYiaJlffP
	AnVwcAgL+EosnlYCYrIIqErc/ZwIYvIKuEhc21MJYkoIKEjMmWQDMoRTwE3i35OJTCBhIQFX
	iesTI0HmSQhcY5fo3PaPCaSGRUBA4tvkQywQrbISmw4wQ1wsKXFwxQ2WCYzCCxgZVjGKphYk
	FxQnpRcZ6xUn5haX5qXrJefnbmIExsvpf8/6dzDePWB9iDEZaNxEZinR5HxgvOWVxBsamxlZ
	mJqYGhuZW5qRJqwkznv/YVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsaQ1+qcS27Ke7b3
	2vB9X3hsdZvhHOvPck63VlgXfJdcMyuli9mT99qyFfdm2HG8t5VxmCYmpe60QEdLV3Hfep6t
	3OmrfrRf3yCZ8Kzl7LIyrrOPt8V/N1wYGbPH0Sdglr3DullTp/VZK7p+/sn75vq8i+E59pM0
	Fqw/tiuk5+6tr2uZJ0rNrXyoxFKckWioxVxUnAgAERhwm60CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t9jQd03VZ+DDLZstbI4eL/e4uUhTYsD
	sx+yWrw6s5HNonfBVTaLTY+vsVp0/P3CaHF51xw2ixnn9zFZLNr2n9li/YzXLBZP/gPF9r3e
	yuzA67Fz1l12j81L6j3Oz1jI6NH/18Cjb8sqRo+fL3U8jt/YzuTxeZNcAEdUA6NNRmpiSmqR
	Qmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtC9SgpliTmlQKGAxOJi
	JX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMww9OsBZM1a3onafbwPhHpYuRk0NCwERi6ZV+
	NghbTOLCvfVANheHkMB0RokZtycyQjj9TBLbb51mAaliEzCTOLhoNTuILSLgIDFv7Xd2kCJm
	gcVMEivvnwXq4OAQFvCVWDytBMRkEVCVuPs5EcTkFXCRuLanEsSUEFCQmDPJBmQIp4CbxL8n
	E5lAwkICrhLXJ0ZOYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Gp9J72Bc1WBx
	iFGAg1GJh3fD+k9BQqyJZcWVuYcYJTiYlUR4xQo+BwnxpiRWVqUW5ccXleakFh9iTAa6aCKz
	lGhyPjBR5JXEGxqbmJsam1qaWJiYWZImrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo7Tn
	usQN245MyDr8d+OrzJJ7Itaz124vsuoKmZ5y2cLdokx+xWctxR+ReYbit74I6bZY7WNafCw2
	ec/J59f/vP4aGn8q/WT1nUjfe0H6D+YGlCj9YGfa0O+1Xqi9RkmZbX7Wla8TQ2VeS3FOzOjk
	tL14S0H5wGOJsKtnPAqOCdaqdn/dNiXHVomlOCPRUIu5qDgRAJpiaYkKAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a variant struct to handle the differences
(like fifo_depths) in the HSI2C modules across SoCs.

Adds a new compatible to support HSI2C module on Exynos5260.
Also resets the module as an init sequence (Needed by Exynos5260).

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
Changes since v2:
1. Used variant struct as suggested by Tomasz Figa.
2. Change compatible strings from samsung,exynos5-hsi2c to
   samsung,exynos5250-hsi2c based on the first SoC to see the feature.
3. Using reset as init sequences.
4. Merged the 2 patches into one.

 .../devicetree/bindings/i2c/i2c-exynos5.txt        |    8 ++-
 drivers/i2c/busses/i2c-exynos5.c                   |   64 ++++++++++++++++----
 2 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
index 056732c..5bc4998 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
@@ -5,7 +5,11 @@ at various speeds ranging from 100khz to 3.4Mhz.
 
 Required properties:
   - compatible: value should be.
-      -> "samsung,exynos5-hsi2c", for i2c compatible with exynos5 hsi2c.
+	-> "samsung,exynos5250-hsi2c", for i2c compatible with HSI2C available
+				on Exynos5250 and Exynos5420 SoCs.
+	-> "samsung,exynos5260-hsi2c", for i2c compatible with HSI2C available
+				on Exynos5260 SoCs.
+
   - reg: physical base address of the controller and length of memory mapped
     region.
   - interrupts: interrupt number to the cpu.
@@ -26,7 +30,7 @@ Optional properties:
 Example:
 
 hsi2c@12ca0000 {
-	compatible = "samsung,exynos5-hsi2c";
+	compatible = "samsung,exynos5250-hsi2c";
 	reg = <0x12ca0000 0x100>;
 	interrupts = <56>;
 	clock-frequency = <100000>;
diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index 9fd711c..5052e8f 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -76,12 +76,6 @@
 #define HSI2C_RXFIFO_TRIGGER_LEVEL(x)		((x) << 4)
 #define HSI2C_TXFIFO_TRIGGER_LEVEL(x)		((x) << 16)
 
-/* As per user manual FIFO max depth is 64bytes */
-#define HSI2C_FIFO_MAX				0x40
-/* default trigger levels for Tx and Rx FIFOs */
-#define HSI2C_DEF_TXFIFO_LVL			(HSI2C_FIFO_MAX - 0x30)
-#define HSI2C_DEF_RXFIFO_LVL			(HSI2C_FIFO_MAX - 0x10)
-
 /* I2C_TRAILING_CTL Register bits */
 #define HSI2C_TRAILING_COUNT			(0xf)
 
@@ -183,14 +177,51 @@ struct exynos5_i2c {
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
@@ -415,7 +446,7 @@ static irqreturn_t exynos5_i2c_irq(int irqno, void *dev_id)
 		fifo_status = readl(i2c->regs + HSI2C_FIFO_STATUS);
 		fifo_level = HSI2C_TX_FIFO_LVL(fifo_status);
 
-		len = HSI2C_FIFO_MAX - fifo_level;
+		len = i2c->variant->fifo_depth - fifo_level;
 		if (len > (i2c->msg->len - i2c->msg_ptr))
 			len = i2c->msg->len - i2c->msg_ptr;
 
@@ -483,6 +514,7 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
 	u32 i2c_auto_conf = 0;
 	u32 fifo_ctl;
 	unsigned long flags;
+	unsigned short trig_lvl;
 
 	i2c_ctl = readl(i2c->regs + HSI2C_CTL);
 	i2c_ctl &= ~(HSI2C_TXCHON | HSI2C_RXCHON);
@@ -493,13 +525,19 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
 
 		i2c_auto_conf = HSI2C_READ_WRITE;
 
-		fifo_ctl |= HSI2C_RXFIFO_TRIGGER_LEVEL(HSI2C_DEF_TXFIFO_LVL);
+		trig_lvl = (i2c->msg->len > i2c->variant->fifo_depth) ?
+			(i2c->variant->fifo_depth * 3/4) : i2c->msg->len;
+		fifo_ctl |= HSI2C_RXFIFO_TRIGGER_LEVEL(trig_lvl);
+
 		int_en |= (HSI2C_INT_RX_ALMOSTFULL_EN |
 			HSI2C_INT_TRAILING_EN);
 	} else {
 		i2c_ctl |= HSI2C_TXCHON;
 
-		fifo_ctl |= HSI2C_TXFIFO_TRIGGER_LEVEL(HSI2C_DEF_RXFIFO_LVL);
+		trig_lvl = (i2c->msg->len > i2c->variant->fifo_depth) ?
+			(i2c->variant->fifo_depth * 1/4) : i2c->msg->len;
+		fifo_ctl |= HSI2C_TXFIFO_TRIGGER_LEVEL(trig_lvl);
+
 		int_en |= HSI2C_INT_TX_ALMOSTEMPTY_EN;
 	}
 
@@ -691,7 +729,9 @@ static int exynos5_i2c_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_clk;
 
-	exynos5_i2c_init(i2c);
+	i2c->variant = exynos5_i2c_get_variant(pdev);
+
+	exynos5_i2c_reset(i2c);
 
 	ret = i2c_add_adapter(&i2c->adap);
 	if (ret < 0) {
-- 
1.7.9.5

