Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaGVCGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 22:06:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47213 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaGVCFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 22:05:08 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-95-53cdc6ccc099
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org
Cc: ch.naveen@samsung.com, arnd@arndb.de, kgene.kim@samsung.com,
        kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv8 2/4] iio: adc: exynos_adc: Control special clock of ADC to
 support Exynos3250 ADC
Date: Tue, 22 Jul 2014 11:04:54 +0900
Message-id: <1405994696-3117-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1405994696-3117-1-git-send-email-cw00.choi@samsung.com>
References: <1405994696-3117-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWyRsSkWPfMsbPBBp3rpC3+TjrGbnH3+WFG
	i+tfnrNazD9yjtXiQdMqJoveBVfZLM42vWG32PT4GqvFwrYlLBbzjrxjsbi8aw6bxYzz+5gs
	1s94zeLA6/H71yRGj02rOtk8Ni+p9+jbsorR4/MmuQDWKC6blNSczLLUIn27BK6Mt2tusBU8
	M65oXBHfwLhUq4uRg0NCwETi6rTYLkZOIFNM4sK99WxdjFwcQgJLGSUWLv3EBpEwkdjcNJkZ
	IrGIUeLao6PsEE4Tk8T1X/PBqtgEtCT2v7gBZosIiEjcO/2BEaSIWeAqk8T2HevZQRLCAqkS
	b5/+ACtiEVCVWPZmEguIzSvgIrF32TFmiHVyEh/2PAKr5xRwldi9+gxYjRBQzde755hAhkoI
	HGKX2HuplxFikIDEt8mHWCD+kZXYdABqjqTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKpXnJhb
	XJqXrpecn7uJERghp/89m7iD8f4B60OMyUDjJjJLiSbnAyMsryTe0NjMyMLUxNTYyNzSjDRh
	JXHe9EdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYV/uHr/dd2vzxjub0Xw2WNUsVA3l/
	sV5cu6SGbfW5395MQt0HRftbzqTddpkwzf3MrtDuR4u/i+c0n2Lbe4+1JO6pw5YzKUec40J8
	X5ddvpDwp+rqy03XLx8W1bzvuuRuz+mDUV4JHbtMQ20v6DmuCTnJ2HRLdE9V+Raz5Q0lQW47
	1ooWb8gyVmIpzkg01GIuKk4EAMGIBR2mAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t9jAd0zx84GG7xvE7L4O+kYu8Xd54cZ
	La5/ec5qMf/IOVaLB02rmCx6F1xlszjb9IbdYtPja6wWC9uWsFjMO/KOxeLyrjlsFjPO72Oy
	WD/jNYsDr8fvX5MYPTat6mTz2Lyk3qNvyypGj8+b5AJYoxoYbTJSE1NSixRS85LzUzLz0m2V
	vIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAjlRSKEvMKQUKBSQWFyvp22GaEBripmsB
	0xih6xsSBNdjZIAGEtYwZrxdc4Ot4JlxReOK+AbGpVpdjJwcEgImEpubJjND2GISF+6tZ+ti
	5OIQEljEKHHt0VF2CKeJSeL6r/lsIFVsAloS+1/cALNFBEQk7p3+wAhSxCxwlUli+4717CAJ
	YYFUibdPf4AVsQioSix7M4kFxOYVcJHYu+wY1Do5iQ97HoHVcwq4SuxefQasRgio5uvdc0wT
	GHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOwGdSOxhXNlgcYhTgYFTi4Z2geDZY
	iDWxrLgy9xCjBAezkghv+x6gEG9KYmVValF+fFFpTmrxIUZToKsmMkuJJucDk0NeSbyhsYmZ
	kaWRuaGFkbG5kjjvgVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQbGmGLf3vj4fxL5D5ztFe6mNcQ4
	il/fvX5izdzG396eBr4uDDMz3Gpmh+vNqu+1i2Ayvdrwt/x0zl7Rqets1x1aILXAUUb1VRTH
	ydPvQy/e6O3yj/0hJbFTNv9Q0apTVw+u64/98vR/06FvCudaDDeKVvZ/v1rg1Rmx5eHNI4nR
	rBnstwPVXr1RYinOSDTUYi4qTgQAMSRE7tYCAAA=
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
Acked-by: Arnd Bergmann <arnd@arndb.de>
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

