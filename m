Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaGUCSF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 22:18:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47721 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbaGUCR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 22:17:58 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-f3-53cc78537843
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com
Cc: arnd@arndb.de, kgene.kim@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv7 2/4] iio: adc: exynos_adc: Control special clock of ADC to
 support Exynos3250 ADC
Date: Mon, 21 Jul 2014 11:17:46 +0900
Message-id: <1405909068-22539-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1405909068-22539-1-git-send-email-cw00.choi@samsung.com>
References: <1405909068-22539-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsWyRsSkSDe44kywwa4rVhZ/Jx1jt7j7/DCj
	xfUvz1kt5h85x2rR/2Yhq8W5VysZLR40rWKy6F1wlc3ibNMbdotNj6+xWixsW8JiMe/IOxaL
	y7vmsFnMOL+PyWLp9YtMFhOmr2WxeHtnOotF694j7BbrZ7xmcRD2WDNvDaPH71+TGD0u9/Uy
	eaxc/oXNY/MKLY9NqzqBjCX1Hn1bVjF6fN4kF8AZxWWTkpqTWZZapG+XwJVx4tUPloK9xhWr
	Ly5hbWBs1Opi5OSQEDCROPhuOhuELSZx4d56IJuLQ0hgKaPEhum72LsYOcCKNrSoQMQXMUqc
	ub0KqqiJSWLp5HYWkG42AS2J/S9ugE0SEdCWmLCwA6yIWeAMs0Rv20p2kISwQKrE7F2nwIpY
	BFQlprQvB2vmFXCVmLljPxPEGXISH/Y8AqvnFHCTaH/cxgpiCwHV/Jt0hxFkqIRAL4fEqVXP
	mCAGCUh8m3yIBeJUWYlNB5gh5khKHFxxg2UCo/ACRoZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ
	+bmbGIFRePrfs4k7GO8fsD7EmAw0biKzlGhyPjCK80riDY3NjCxMTUyNjcwtzUgTVhLnTX+U
	FCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB0dOp8ccBf687P2qX6e6ykAibdLt8zkUNrt2t
	xl77D3y3+X1pI8uRxhi1TRl5p7m+yJeVqc603rJwg/2Tp1sLHp+ZMXf3T+mXP+VnKhpPNptQ
	m/UucWafZOvUTYVCXxnXZ4j+rC9KTNrpsf17sl3yh6olhfPcTz/OvXCsYvvHyjl7RAs2+pWy
	rVJiKc5INNRiLipOBABim27L2AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAd3gijPBBg9vGlj8nXSM3eLu88OM
	Fte/PGe1mH/kHKtF/5uFrBbnXq1ktHjQtIrJonfBVTaLs01v2C02Pb7GarGwbQmLxbwj71gs
	Lu+aw2Yx4/w+Joul1y8yWUyYvpbF4u2d6SwWrXuPsFusn/GaxUHYY828NYwev39NYvS43NfL
	5LFy+Rc2j80rtDw2reoEMpbUe/RtWcXo8XmTXABnVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8
	c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QV0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0
	fUOC4HqMDNBAwhrGjBOvfrAU7DWuWH1xCWsDY6NWFyMHh4SAicSGFpUuRk4gU0ziwr31bF2M
	XBxCAosYJc7cXgXlNDFJLJ3czgJSxSagJbH/xQ02EFtEQFtiwsIOsCJmgTPMEr1tK9lBEsIC
	qRKzd50CK2IRUJWY0r4crJlXwFVi5o79TBDr5CQ+7HkEVs8p4CbR/riNFcQWAqr5N+kO4wRG
	3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgmP8mdQOxpUNFocYBTgYlXh4PRjPBAux
	JpYVV+YeYpTgYFYS4T2RARTiTUmsrEotyo8vKs1JLT7EaAp01URmKdHkfGD6ySuJNzQ2MTOy
	NDI3tDAyNlcS5z3Qah0oJJCeWJKanZpakFoE08fEwSnVwOjc0rgwWqC46InS9+yodPFDrvfT
	9C+Khtgvbv3jni/90OR2Yd2kROklp5Sr9ua9nfM7bWZm+m75t1sO6oXcT26U2JBRwZ0394P4
	1zN3vz6QmLnl/YbWI9JrM8PWB/Qu/rFhblpz2LfFkQJux+t6nohckuX5dePlyQ/273ivv4gM
	mZqst26b4QMlluKMREMt5qLiRABYkZ5YBwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch control special clock for ADC in Exynos series's FSYS block.
If special clock of ADC is registerd on clock list of common clk framework,
Exynos ADC drvier have to control this clock.

Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
- 'adc' clock: bus clock for ADC

Exynos3250 has additional 'sclk_adc' clock as following:
- 'sclk_adc' clock: special clock for ADC which provide clock to internal ADC

Exynos 4210/4212/4412 and Exynos5250/5420 has not included 'sclk_adc' clock
in FSYS_BLK. But, Exynos3250 based on Cortex-A7 has only included 'sclk_adc'
clock in FSYS_BLK.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
---
 drivers/iio/adc/exynos_adc.c | 111 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 103 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index dde4ca8..87e0895 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -24,6 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/io.h>
@@ -70,8 +71,9 @@
 #define ADC_V2_CON2_ACH_SEL(x)	(((x) & 0xF) << 0)
 #define ADC_V2_CON2_ACH_MASK	0xF
 
-#define MAX_ADC_V2_CHANNELS	10
-#define MAX_ADC_V1_CHANNELS	8
+#define MAX_ADC_V2_CHANNELS		10
+#define MAX_ADC_V1_CHANNELS		8
+#define MAX_EXYNOS3250_ADC_CHANNELS	2
 
 /* Bit definitions common for ADC_V1 and ADC_V2 */
 #define ADC_CON_EN_START	(1u << 0)
@@ -81,9 +83,11 @@
 
 struct exynos_adc {
 	struct exynos_adc_data	*data;
+	struct device		*dev;
 	void __iomem		*regs;
 	void __iomem		*enable_reg;
 	struct clk		*clk;
+	struct clk		*sclk;
 	unsigned int		irq;
 	struct regulator	*vdd;
 
@@ -95,6 +99,7 @@ struct exynos_adc {
 
 struct exynos_adc_data {
 	int num_channels;
+	bool needs_sclk;
 
 	void (*init_hw)(struct exynos_adc *info);
 	void (*exit_hw)(struct exynos_adc *info);
@@ -102,6 +107,66 @@ struct exynos_adc_data {
 	void (*start_conv)(struct exynos_adc *info, unsigned long addr);
 };
 
+static void exynos_adc_unprepare_clk(struct exynos_adc *info)
+{
+	if (info->data->needs_sclk)
+		clk_unprepare(info->sclk);
+	clk_unprepare(info->clk);
+}
+
+static int exynos_adc_prepare_clk(struct exynos_adc *info)
+{
+	int ret;
+
+	ret = clk_prepare(info->clk);
+	if (ret) {
+		dev_err(info->dev, "failed preparing adc clock: %d\n", ret);
+		return ret;
+	}
+
+	if (info->data->needs_sclk) {
+		ret = clk_prepare(info->sclk);
+		if (ret) {
+			clk_unprepare(info->clk);
+			dev_err(info->dev,
+				"failed preparing sclk_adc clock: %d\n", ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void exynos_adc_disable_clk(struct exynos_adc *info)
+{
+	if (info->data->needs_sclk)
+		clk_disable(info->sclk);
+	clk_disable(info->clk);
+}
+
+static int exynos_adc_enable_clk(struct exynos_adc *info)
+{
+	int ret;
+
+	ret = clk_enable(info->clk);
+	if (ret) {
+		dev_err(info->dev, "failed enabling adc clock: %d\n", ret);
+		return ret;
+	}
+
+	if (info->data->needs_sclk) {
+		ret = clk_enable(info->sclk);
+		if (ret) {
+			clk_disable(info->clk);
+			dev_err(info->dev,
+				"failed enabling sclk_adc clock: %d\n", ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static void exynos_adc_v1_init_hw(struct exynos_adc *info)
 {
 	u32 con1;
@@ -208,6 +273,16 @@ static const struct exynos_adc_data const exynos_adc_v2_data = {
 	.start_conv	= exynos_adc_v2_start_conv,
 };
 
+static const struct exynos_adc_data const exynos3250_adc_data = {
+	.num_channels	= MAX_EXYNOS3250_ADC_CHANNELS,
+	.needs_sclk	= true,
+
+	.init_hw	= exynos_adc_v2_init_hw,
+	.exit_hw	= exynos_adc_v2_exit_hw,
+	.clear_irq	= exynos_adc_v2_clear_irq,
+	.start_conv	= exynos_adc_v2_start_conv,
+};
+
 static const struct of_device_id exynos_adc_match[] = {
 	{
 		.compatible = "samsung,exynos-adc-v1",
@@ -215,6 +290,9 @@ static const struct of_device_id exynos_adc_match[] = {
 	}, {
 		.compatible = "samsung,exynos-adc-v2",
 		.data = &exynos_adc_v2_data,
+	}, {
+		.compatible = "samsung,exynos3250-adc",
+		.data = &exynos3250_adc_data,
 	},
 	{},
 };
@@ -376,6 +454,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	}
 
 	info->irq = irq;
+	info->dev = &pdev->dev;
 
 	init_completion(&info->completion);
 
@@ -386,6 +465,16 @@ static int exynos_adc_probe(struct platform_device *pdev)
 		return PTR_ERR(info->clk);
 	}
 
+	if (info->data->needs_sclk) {
+		info->sclk = devm_clk_get(&pdev->dev, "sclk");
+		if (IS_ERR(info->sclk)) {
+			dev_err(&pdev->dev,
+				"failed getting sclk clock, err = %ld\n",
+				PTR_ERR(info->sclk));
+			return PTR_ERR(info->sclk);
+		}
+	}
+
 	info->vdd = devm_regulator_get(&pdev->dev, "vdd");
 	if (IS_ERR(info->vdd)) {
 		dev_err(&pdev->dev, "failed getting regulator, err = %ld\n",
@@ -397,10 +486,14 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = clk_prepare_enable(info->clk);
+	ret = exynos_adc_prepare_clk(info);
 	if (ret)
 		goto err_disable_reg;
 
+	ret = exynos_adc_enable_clk(info);
+	if (ret)
+		goto err_unprepare_clk;
+
 	platform_set_drvdata(pdev, indio_dev);
 
 	indio_dev->name = dev_name(&pdev->dev);
@@ -443,7 +536,9 @@ err_irq:
 err_disable_clk:
 	if (info->data->exit_hw)
 		info->data->exit_hw(info);
-	clk_disable_unprepare(info->clk);
+	exynos_adc_disable_clk(info);
+err_unprepare_clk:
+	exynos_adc_unprepare_clk(info);
 err_disable_reg:
 	regulator_disable(info->vdd);
 	return ret;
@@ -460,7 +555,8 @@ static int exynos_adc_remove(struct platform_device *pdev)
 	free_irq(info->irq, info);
 	if (info->data->exit_hw)
 		info->data->exit_hw(info);
-	clk_disable_unprepare(info->clk);
+	exynos_adc_disable_clk(info);
+	exynos_adc_unprepare_clk(info);
 	regulator_disable(info->vdd);
 
 	return 0;
@@ -474,8 +570,7 @@ static int exynos_adc_suspend(struct device *dev)
 
 	if (info->data->exit_hw)
 		info->data->exit_hw(info);
-
-	clk_disable_unprepare(info->clk);
+	exynos_adc_disable_clk(info);
 	regulator_disable(info->vdd);
 
 	return 0;
@@ -491,7 +586,7 @@ static int exynos_adc_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	ret = clk_prepare_enable(info->clk);
+	ret = exynos_adc_enable_clk(info);
 	if (ret)
 		return ret;
 
-- 
1.8.0

