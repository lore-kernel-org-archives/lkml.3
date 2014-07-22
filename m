Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbaGVCL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:11:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49252 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaGVCLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:11:22 -0400
X-AuditID: cbfee68f-b7fef6d000003970-ac-53cdc8476361
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org
Cc: ch.naveen@samsung.com, arnd@arndb.de, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/2] iio: adc: exynos_adc: Add support for S3C24xx ADC
Date: Tue, 22 Jul 2014 11:11:14 +0900
Message-id: <1405995074-3271-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1405995074-3271-1-git-send-email-cw00.choi@samsung.com>
References: <1405995074-3271-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWyRsSkWNf9xNlgg/PbdS3+TjrGbnH3+WFG
	i+tfnrNazD9yjtXiQdMqJoveBVfZLM42vWG32PT4GqvFwrYlLBbzjrxjsbi8aw6bxYzz+5gs
	1s94zeLA6/H71yRGj02rOtk8Ni+p9+jbsorR4/MmuQDWKC6blNSczLLUIn27BK6MK7OXsxd0
	2FQcvGbQwDjfsIuRg0NCwESi42VSFyMnkCkmceHeerYuRi4OIYGljBJ3lu5ghkiYSExd8Z8F
	IjGdUeLuog4mCKeJSeLb4eWsIFVsAloS+1/cYAOxRQREJO6d/sAIUsQscJVJYvuO9ewgCWEB
	N4nbX/8xgdgsAqoS95/uB2vmFXCRuLlpJQvEOjmJD3segdVzCrhKdJ/bDnaGEFDNkwltYPdJ
	CBxjl9i+6wgrxCABiW+TD7FA/CMrsekA1NmSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGxXnFi
	bnFpXrpecn7uJkZghJz+96x/B+PdA9aHGJOBxk1klhJNzgdGWF5JvKGxmZGFqYmpsZG5pRlp
	wkrivPcfJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYDzxzbCtdAnH3JXLe2Zk6iw5bTnp
	z9R8nZg/mnvtUr5/vlW462GI9cwujyOT1qwQDQ/6pbjkXCbD16kzSmrqP52+/o+zVHypgMSS
	9Jq/Ooxn9yt/sZmk9IT5jlCk6/2ZXom82+d6/k2srLhqppSbtuALV0foSd4PBxo2Olq+a1Q7
	tm/V0bJra82UWIozEg21mIuKEwFicKwDpgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t9jQV33E2eDDb48U7b4O+kYu8Xd54cZ
	La5/ec5qMf/IOVaLB02rmCx6F1xlszjb9IbdYtPja6wWC9uWsFjMO/KOxeLyrjlsFjPO72Oy
	WD/jNYsDr8fvX5MYPTat6mTz2Lyk3qNvyypGj8+b5AJYoxoYbTJSE1NSixRS85LzUzLz0m2V
	vIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAjlRSKEvMKQUKBSQWFyvp22GaEBripmsB
	0xih6xsSBNdjZIAGEtYwZlyZvZy9oMOm4uA1gwbG+YZdjJwcEgImElNX/GeBsMUkLtxbz9bF
	yMUhJDCdUeLuog4mCKeJSeLb4eWsIFVsAloS+1/cYAOxRQREJO6d/sAIUsQscJVJYvuO9ewg
	CWEBN4nbX/8xgdgsAqoS95/uB2vmFXCRuLlpJdQ6OYkPex6B1XMKuEp0n9vODGILAdU8mdDG
	NoGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Ah8JrWDcWWDxSFGAQ5GJR7eCYpn
	g4VYE8uKK3MPMUpwMCuJ8LbvAQrxpiRWVqUW5ccXleakFh9iNAW6aiKzlGhyPjA55JXEGxqb
	mBlZGpkbWhgZmyuJ8x5otQ4UEkhPLEnNTk0tSC2C6WPi4JRqYBTao7Vsw9Oz8zpmPZx8dudr
	0Q0ivQIH2b4ETQuYOtnnsibHat8nyje7ujm+idW//vkmXO//odMLNv3sqpvyV92y6+zCXQof
	m1WE+a3c/76ru8Zef5t1wfut85vuW9hpy+t13TwS07Nkr2RuowTHv947D2+EqV7JYXXay1Ug
	dURp4c8tjh11lxOVWIozEg21mIuKEwHqX5Kw1gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add support for s3c2410/s3c2416/s3c2440/s3c2443 ADC. The s3c24xx
is alomost same as ADCv1. But, There are a little difference as following:
- ADCMUX register address to select channel
- ADCDAT mask (10bit or 12bit ADC resolution according to SoC version)

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../devicetree/bindings/arm/samsung/exynos-adc.txt | 10 ++-
 drivers/iio/adc/exynos_adc.c                       | 89 +++++++++++++++++++++-
 2 files changed, 96 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
index b6e3989..fe34c76 100644
--- a/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
+++ b/Documentation/devicetree/bindings/arm/samsung/exynos-adc.txt
@@ -11,11 +11,19 @@ New driver handles the following
 
 Required properties:
 - compatible:		Must be "samsung,exynos-adc-v1"
-				for exynos4412/5250 controllers.
+				for exynos4412/5250 and s5pv210 controllers.
 			Must be "samsung,exynos-adc-v2" for
 				future controllers.
 			Must be "samsung,exynos3250-adc" for
 				controllers compatible with ADC of Exynos3250.
+			Must be "samsung,s3c2410-adc" for
+				the ADC in s3c2410 and compatibles
+			Must be "samsung,s3c2416-adc" for
+				the ADC in s3c2416 and compatibles
+			Must be "samsung,s3c2440-adc" for
+				the ADC in s3c2440 and compatibles
+			Must be "samsung,s3c2443-adc" for
+				the ADC in s3c2443 and compatibles
 			Must be "samsung,s3c6410-adc" for
 				the ADC in s3c6410 and compatibles
 - reg:			Contains ADC register address range (base address and
diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index 05bdd2f12..7d28032 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -51,6 +51,9 @@
 #define ADC_V1_MUX(x)		((x) + 0x1c)
 #define ADC_V1_CLRINTPNDNUP(x)	((x) + 0x20)
 
+/* S3C2410 ADC registers definitions */
+#define ADC_S3C2410_MUX(x)	((x) + 0x18)
+
 /* Future ADC_V2 registers definitions */
 #define ADC_V2_CON1(x)		((x) + 0x00)
 #define ADC_V2_CON2(x)		((x) + 0x04)
@@ -67,6 +70,8 @@
 
 /* Bit definitions for S3C2410 ADC */
 #define ADC_S3C2410_CON_SELMUX(x) (((x) & 7) <<3)
+#define ADC_S3C2410_DATX_MASK	0x3FF
+#define ADC_S3C2416_CON_RES_SEL	(1 << 3)
 
 /* Bit definitions for ADC_V2 */
 #define ADC_V2_CON1_SOFT_RESET	(1u << 2)
@@ -84,6 +89,7 @@
 
 /* Bit definitions common for ADC_V1 and ADC_V2 */
 #define ADC_CON_EN_START	(1u << 0)
+#define ADC_CON_EN_START_MASK	(0x3 << 0)
 #define ADC_DATX_MASK		0xFFF
 
 #define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(100))
@@ -101,12 +107,14 @@ struct exynos_adc {
 	struct completion	completion;
 
 	u32			value;
+	u32			value2;
 	unsigned int            version;
 };
 
 struct exynos_adc_data {
 	int num_channels;
 	bool needs_sclk;
+	u32 mask;
 
 	void (*init_hw)(struct exynos_adc *info);
 	void (*exit_hw)(struct exynos_adc *info);
@@ -217,6 +225,17 @@ static void exynos_adc_v1_start_conv(struct exynos_adc *info,
 
 static const struct exynos_adc_data const exynos_adc_v1_data = {
 	.num_channels	= MAX_ADC_V1_CHANNELS,
+	.mask		= ADC_DATX_MASK, /* 12bit ADC resolution */
+
+	.init_hw	= exynos_adc_v1_init_hw,
+	.exit_hw	= exynos_adc_v1_exit_hw,
+	.clear_irq	= exynos_adc_v1_clear_irq,
+	.start_conv	= exynos_adc_v1_start_conv,
+};
+
+static struct exynos_adc_data const exynos_adc_s3c24xx_data = {
+	.num_channels	= MAX_ADC_V1_CHANNELS,
+	.mask		= ADC_S3C2410_DATX_MASK, /* 10bit ADC resolution */
 
 	.init_hw	= exynos_adc_v1_init_hw,
 	.exit_hw	= exynos_adc_v1_exit_hw,
@@ -224,6 +243,55 @@ static const struct exynos_adc_data const exynos_adc_v1_data = {
 	.start_conv	= exynos_adc_v1_start_conv,
 };
 
+static void exynos_adc_s3c2416_start_conv(struct exynos_adc *info,
+					  unsigned long addr)
+{
+	u32 con1;
+
+	/* Enable 12bit ADC resolution */
+	con1 = readl(ADC_V1_CON(info->regs));
+	con1 |= ADC_S3C2416_CON_RES_SEL;
+	writel(con1, ADC_V1_CON(info->regs));
+
+	/* Select channel for S3C2416 */
+	writel(addr, ADC_S3C2410_MUX(info->regs));
+
+	con1 = readl(ADC_V1_CON(info->regs));
+	writel(con1 | ADC_CON_EN_START, ADC_V1_CON(info->regs));
+}
+
+static struct exynos_adc_data const exynos_adc_s3c2416_data = {
+	.num_channels	= MAX_ADC_V1_CHANNELS,
+	.mask		= ADC_DATX_MASK, /* 12bit ADC resolution */
+
+	.init_hw	= exynos_adc_v1_init_hw,
+	.exit_hw	= exynos_adc_v1_exit_hw,
+	.clear_irq	= exynos_adc_v1_clear_irq,
+	.start_conv	= exynos_adc_s3c2416_start_conv,
+};
+
+static void exynos_adc_s3c2443_start_conv(struct exynos_adc *info,
+					  unsigned long addr)
+{
+	u32 con1;
+
+	/* Select channel for S3C2433 */
+	writel(addr, ADC_S3C2410_MUX(info->regs));
+
+	con1 = readl(ADC_V1_CON(info->regs));
+	writel(con1 | ADC_CON_EN_START, ADC_V1_CON(info->regs));
+}
+
+static struct exynos_adc_data const exynos_adc_s3c2443_data = {
+	.num_channels	= MAX_ADC_V1_CHANNELS,
+	.mask		= ADC_S3C2410_DATX_MASK, /* 10bit ADC resolution */
+
+	.init_hw	= exynos_adc_v1_init_hw,
+	.exit_hw	= exynos_adc_v1_exit_hw,
+	.clear_irq	= exynos_adc_v1_clear_irq,
+	.start_conv	= exynos_adc_s3c2443_start_conv,
+};
+
 static void exynos_adc_s3c64xx_start_conv(struct exynos_adc *info,
 					  unsigned long addr)
 {
@@ -237,6 +305,7 @@ static void exynos_adc_s3c64xx_start_conv(struct exynos_adc *info,
 
 static struct exynos_adc_data const exynos_adc_s3c64xx_data = {
 	.num_channels	= MAX_ADC_V1_CHANNELS,
+	.mask		= ADC_DATX_MASK, /* 12bit ADC resolution */
 
 	.init_hw	= exynos_adc_v1_init_hw,
 	.exit_hw	= exynos_adc_v1_exit_hw,
@@ -293,6 +362,7 @@ static void exynos_adc_v2_start_conv(struct exynos_adc *info,
 
 static const struct exynos_adc_data const exynos_adc_v2_data = {
 	.num_channels	= MAX_ADC_V2_CHANNELS,
+	.mask		= ADC_DATX_MASK, /* 12bit ADC resolution */
 
 	.init_hw	= exynos_adc_v2_init_hw,
 	.exit_hw	= exynos_adc_v2_exit_hw,
@@ -302,6 +372,7 @@ static const struct exynos_adc_data const exynos_adc_v2_data = {
 
 static const struct exynos_adc_data const exynos3250_adc_data = {
 	.num_channels	= MAX_EXYNOS3250_ADC_CHANNELS,
+	.mask		= ADC_DATX_MASK, /* 12bit ADC resolution */
 	.needs_sclk	= true,
 
 	.init_hw	= exynos_adc_v2_init_hw,
@@ -312,6 +383,18 @@ static const struct exynos_adc_data const exynos3250_adc_data = {
 
 static const struct of_device_id exynos_adc_match[] = {
 	{
+		.compatible = "samsung,s3c2410-adc",
+		.data = &exynos_adc_s3c24xx_data,
+	}, {
+		.compatible = "samsung,s3c2416-adc",
+		.data = &exynos_adc_s3c2416_data,
+	}, {
+		.compatible = "samsung,s3c2440-adc",
+		.data = &exynos_adc_s3c24xx_data,
+	}, {
+		.compatible = "samsung,s3c2443-adc",
+		.data = &exynos_adc_s3c2443_data,
+	}, {
 		.compatible = "samsung,s3c6410-adc",
 		.data = &exynos_adc_s3c64xx_data,
 	}, {
@@ -365,7 +448,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 		ret = -ETIMEDOUT;
 	} else {
 		*val = info->value;
-		*val2 = 0;
+		*val2 = info->value2;
 		ret = IIO_VAL_INT;
 	}
 
@@ -377,9 +460,11 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
 {
 	struct exynos_adc *info = (struct exynos_adc *)dev_id;
+	u32 mask = info->data->mask;
 
 	/* Read value */
-	info->value = readl(ADC_V1_DATX(info->regs)) & ADC_DATX_MASK;
+	info->value = readl(ADC_V1_DATX(info->regs)) & mask;
+	info->value2 = readl(ADC_V1_DATY(info->regs)) & mask;
 
 	/* clear irq */
 	if (info->data->clear_irq)
-- 
1.8.0

