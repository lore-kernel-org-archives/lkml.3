Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaIPJiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:38:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59591 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaIPJiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:38:14 -0400
X-AuditID: cbfee691-f79546d0000011a1-05-5418050383aa
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, sjg@chromium.org,
        grundler@chromium.org, linux-kernel@vger.kernel.org, wsa@the-dreams.de,
        cpgs@samsung.com, devicetree@vger.kernel.org
Subject: [PATCH 1/2] i2c: exynos: add support for HSI2C module on Exynos7
Date: Tue, 16 Sep 2014 15:03:17 +0530
Message-id: <1410859998-29285-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1410859998-29285-1-git-send-email-ch.naveen@samsung.com>
References: <1410859998-29285-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWyRsSkTpeZVSLEYOVnQ4uXhzQt5h85x2rx
	6sgPJotNj6+xWnT8/cJocXnXHDaLGef3MVks2vaf2eLblm2MFitPzGJ24PKY3XCRxWPnrLvs
	HpuX1Hv0bVnF6HHy1BMWj8+b5ALYorhsUlJzMstSi/TtErgy/p7dwV6w2aji0tzzjA2MvRpd
	jJwcEgImEi9fH2WDsMUkLtxbD2RzcQgJLGWUWLB8CRtM0e8HZ5kgEosYJQ7+PgHl9DNJtDac
	A6tiEzCTOLhoNTuILSIgK9H6YA0zSBGzwFdGiUPznjCBJIQFPCXetT0Ha2ARUJXo7e5lAbF5
	BVwl9l39BtTMAbROQWLOJBuQMKeAm8TKeZtYQMJCQCWz73uCjJQQ2MUusezeeWaIMQIS3yYf
	YoFolZXYdIAZ4mhJiYMrbrBMYBRewMiwilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMwFk7/
	ezZxB+P9A9aHGAU4GJV4eD0eiYcIsSaWFVfmHmI0BdowkVlKNDkfGHF5JfGGxmZGFqYmpsZG
	5pZmSuK8OtI/g4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw5nVXPz5fmi3R9eXKA/fzc9O4
	91lwqv+pcE6xmipn6rch54DDguDvrx8eLqotW5PV++LmWh9lvlVCsYrmgkbrFTbteDXHMzXp
	/TPjGBG32RJ5YSUPDS/9WS8u9vaka47e1AjJt83vb/Fe55CUjhJve/ijucki1PbJWt3orT/L
	z939/uCzX7iVEktxRqKhFnNRcSIArilG1YACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAV0GVokQg/6vBhYvD2lazD9yjtXi
	1ZEfTBabHl9jtej4+4XR4vKuOWwWM87vY7JYtO0/s8W3LdsYLVaemMXswOUxu+Eii8fOWXfZ
	PTYvqffo27KK0ePkqScsHp83yQWwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxhzPh7dgd7wWajiktzzzM2MPZqdDFyckgImEj8fnCWCcIWk7hwbz1bFyMXh5DAIkaJg79P
	MEE4/UwSrQ3n2ECq2ATMJA4uWs0OYosIyEq0PljDDFLELPCVUeLQvCdgo4QFPCXetT0Ha2AR
	UJXo7e5lAbF5BVwl9l39BtTMAbROQWLOJBuQMKeAm8TKeZtYQMJCQCWz73tOYORdwMiwilE0
	tSC5oDgpPddQrzgxt7g0L10vOT93EyM40p5J7WBc2WBxiFGAg1GJh9fjkXiIEGtiWXFl7iFG
	CQ5mJRHei3+AQrwpiZVVqUX58UWlOanFhxhNgW6ayCwlmpwPTAJ5JfGGxibmpsamliYWJmaW
	SuK8B1qtA4UE0hNLUrNTUwtSi2D6mDg4pRoYz3y+od104DKrxYOnt9b/iLh3qsRX9p7DTtNL
	vE1Nb5l2qlT8uL9CUrpnb/xSu4jrZ52PiN+Mb1zqc/6vgrVqm9iTizV/jRZPd/W9dsLkkHjr
	qhrdqhWs9c4S89r85++YM7uvSt3g8rd5L7x5ZNeyT7GMe7/nye0jl2TPuWT27v+4bcu8A4cP
	/VFiKc5INNRiLipOBAC3iNgfygIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HSI2C module on Exynos7 differs in the transfer status
bits. Transfer status bits were moved to INT_ENABLE and
INT_STATUS registers

This patch adds support for the HSI2C module on Exynos7.
1. Implementes a "hw" field in the variant struct to distinguish
   the hardware.
2. Updates the dt-new compatible in dt-binding documenation

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Wolfram Sang <wsa@the-dreams.de>
---
 .../devicetree/bindings/i2c/i2c-exynos5.txt        |    2 +
 drivers/i2c/busses/i2c-exynos5.c                   |   71 ++++++++++++++++++--
 2 files changed, 67 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
index d4745e3..2dbc0b6 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
@@ -12,6 +12,8 @@ Required properties:
 				on Exynos5250 and Exynos5420 SoCs.
 	-> "samsung,exynos5260-hsi2c", for i2c compatible with HSI2C available
 				on Exynos5260 SoCs.
+	-> "samsung,exynos7-hsi2c", for i2c compatible with HSI2C available
+				on Exynos7 SoCs.
 
   - reg: physical base address of the controller and length of memory mapped
     region.
diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index 28073f1..81e6263 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -83,7 +83,6 @@
 #define HSI2C_INT_TX_ALMOSTEMPTY_EN		(1u << 0)
 #define HSI2C_INT_RX_ALMOSTFULL_EN		(1u << 1)
 #define HSI2C_INT_TRAILING_EN			(1u << 6)
-#define HSI2C_INT_I2C_EN			(1u << 9)
 
 /* I2C_INT_STAT Register bits */
 #define HSI2C_INT_TX_ALMOSTEMPTY		(1u << 0)
@@ -95,6 +94,17 @@
 #define HSI2C_INT_TRAILING			(1u << 6)
 #define HSI2C_INT_I2C				(1u << 9)
 
+#define HSI2C_INT_TRANS_DONE			(1u << 7)
+#define HSI2C_INT_TRANS_ABORT			(1u << 8)
+#define HSI2C_INT_NO_DEV_ACK			(1u << 9)
+#define HSI2C_INT_NO_DEV			(1u << 10)
+#define HSI2C_INT_TIMEOUT			(1u << 11)
+#define HSI2C_INT_I2C_TRANS			(HSI2C_INT_TRANS_DONE |	\
+						HSI2C_INT_TRANS_ABORT |	\
+						HSI2C_INT_NO_DEV_ACK |	\
+						HSI2C_INT_NO_DEV |	\
+						HSI2C_INT_TIMEOUT)
+
 /* I2C_FIFO_STAT Register bits */
 #define HSI2C_RX_FIFO_EMPTY			(1u << 24)
 #define HSI2C_RX_FIFO_FULL			(1u << 23)
@@ -143,6 +153,8 @@
 
 #define EXYNOS5_I2C_TIMEOUT (msecs_to_jiffies(1000))
 
+#define HSI2C_EXYNOS7	BIT(0)
+
 struct exynos5_i2c {
 	struct i2c_adapter	adap;
 	unsigned int		suspended:1;
@@ -192,6 +204,7 @@ struct exynos5_i2c {
  */
 struct exynos_hsi2c_variant {
 	unsigned int	fifo_depth;
+	unsigned int	hw;
 };
 
 static const struct exynos_hsi2c_variant exynos5250_hsi2c_data = {
@@ -202,6 +215,11 @@ static const struct exynos_hsi2c_variant exynos5260_hsi2c_data = {
 	.fifo_depth	= 16,
 };
 
+static const struct exynos_hsi2c_variant exynos7_hsi2c_data = {
+	.fifo_depth	= 16,
+	.hw		= HSI2C_EXYNOS7,
+};
+
 static const struct of_device_id exynos5_i2c_match[] = {
 	{
 		.compatible = "samsung,exynos5-hsi2c",
@@ -212,6 +230,9 @@ static const struct of_device_id exynos5_i2c_match[] = {
 	}, {
 		.compatible = "samsung,exynos5260-hsi2c",
 		.data = &exynos5260_hsi2c_data
+	}, {
+		.compatible = "samsung,exynos7-hsi2c",
+		.data = &exynos7_hsi2c_data
 	}, {},
 };
 MODULE_DEVICE_TABLE(of, exynos5_i2c_match);
@@ -256,13 +277,24 @@ static int exynos5_i2c_set_timing(struct exynos5_i2c *i2c, int mode)
 				i2c->hs_clock : i2c->fs_clock;
 
 	/*
+	 * In case of HSI2C controller in Exynos5 series
 	 * FPCLK / FI2C =
 	 * (CLK_DIV + 1) * (TSCLK_L + TSCLK_H + 2) + 8 + 2 * FLT_CYCLE
+	 *
+	 * In case of HSI2C controllers in Exynos7 series
+	 * FPCLK / FI2C =
+	 * (CLK_DIV + 1) * (TSCLK_L + TSCLK_H + 2) + 8 + FLT_CYCLE
+	 *
 	 * utemp0 = (CLK_DIV + 1) * (TSCLK_L + TSCLK_H + 2)
 	 * utemp1 = (TSCLK_L + TSCLK_H + 2)
 	 */
 	t_ftl_cycle = (readl(i2c->regs + HSI2C_CONF) >> 16) & 0x7;
-	utemp0 = (clkin / op_clk) - 8 - 2 * t_ftl_cycle;
+	utemp0 = (clkin / op_clk) - 8;
+
+	if (i2c->variant->hw == HSI2C_EXYNOS7)
+		utemp0 -= t_ftl_cycle;
+	else
+		utemp0 -= 2 * t_ftl_cycle;
 
 	/* CLK_DIV max is 256 */
 	for (div = 0; div < 256; div++) {
@@ -407,7 +439,28 @@ static irqreturn_t exynos5_i2c_irq(int irqno, void *dev_id)
 	writel(int_status, i2c->regs + HSI2C_INT_STATUS);
 
 	/* handle interrupt related to the transfer status */
-	if (int_status & HSI2C_INT_I2C) {
+	if (i2c->variant->hw == HSI2C_EXYNOS7) {
+		if (int_status & HSI2C_INT_TRANS_DONE) {
+			i2c->trans_done = 1;
+			i2c->state = 0;
+		} else if (int_status & HSI2C_INT_TRANS_ABORT) {
+			dev_dbg(i2c->dev, "Deal with arbitration lose\n");
+			i2c->state = -EAGAIN;
+			goto stop;
+		} else if (int_status & HSI2C_INT_NO_DEV_ACK) {
+			dev_dbg(i2c->dev, "No ACK from device\n");
+			i2c->state = -ENXIO;
+			goto stop;
+		} else if (int_status & HSI2C_INT_NO_DEV) {
+			dev_dbg(i2c->dev, "No device\n");
+			i2c->state = -ENXIO;
+			goto stop;
+		} else if (int_status & HSI2C_INT_TIMEOUT) {
+			dev_dbg(i2c->dev, "Accessing device timed out\n");
+			i2c->state = -EAGAIN;
+			goto stop;
+		}
+	} else if (int_status & HSI2C_INT_I2C) {
 		trans_status = readl(i2c->regs + HSI2C_TRANS_STATUS);
 		if (trans_status & HSI2C_NO_DEV_ACK) {
 			dev_dbg(i2c->dev, "No ACK from device\n");
@@ -512,12 +565,17 @@ static int exynos5_i2c_wait_bus_idle(struct exynos5_i2c *i2c)
 static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
 {
 	u32 i2c_ctl;
-	u32 int_en = HSI2C_INT_I2C_EN;
+	u32 int_en = 0;
 	u32 i2c_auto_conf = 0;
 	u32 fifo_ctl;
 	unsigned long flags;
 	unsigned short trig_lvl;
 
+	if (i2c->variant->hw == HSI2C_EXYNOS7)
+		int_en |= HSI2C_INT_I2C_TRANS;
+	else
+		int_en |= HSI2C_INT_I2C;
+
 	i2c_ctl = readl(i2c->regs + HSI2C_CTL);
 	i2c_ctl &= ~(HSI2C_TXCHON | HSI2C_RXCHON);
 	fifo_ctl = HSI2C_RXFIFO_EN | HSI2C_TXFIFO_EN;
@@ -724,12 +782,13 @@ static int exynos5_i2c_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
+	/* Need to check the variant before setting up. */
+	i2c->variant = exynos5_i2c_get_variant(pdev);
+
 	ret = exynos5_hsi2c_clock_setup(i2c);
 	if (ret)
 		goto err_clk;
 
-	i2c->variant = exynos5_i2c_get_variant(pdev);
-
 	exynos5_i2c_reset(i2c);
 
 	ret = i2c_add_adapter(&i2c->adap);
-- 
1.7.9.5

