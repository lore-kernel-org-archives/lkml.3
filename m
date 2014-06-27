Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaF0Eaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 00:30:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38626 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaF0EaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 00:30:20 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-2b-53acf3557f5d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com, t.figa@samsung.com,
        kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        kyungmin.park@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv5 2/4] iio: adc: exynos_adc: Control special clock of ADC to
 support Exynos3250 ADC
Date: Fri, 27 Jun 2014 13:30:04 +0900
Message-id: <1403843406-28229-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1403843406-28229-1-git-send-email-cw00.choi@samsung.com>
References: <1403843406-28229-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsWyRsSkQDf085pggyPPuC3uPj/MaHH9y3NW
	i/lHzrFa9L9ZyGpx7tVKRosHTauYLHoXXGWzONv0ht1i3pF3LBaXd81hs5hxfh+TxdLrF5ks
	Jkxfy2Lx9s50FovWvUfYLU7+6WW0WD/jNYuDoMeaeWsYPS739TJ5rFz+hc1j8wotj02rOtk8
	7lzbw+bRt2UVo8fnTXIBHFFcNimpOZllqUX6dglcGbNneBZMMaxY//0bWwNjv0YXIyeHhICJ
	RP/f70wQtpjEhXvr2boYuTiEBJYySvxctpARpujH0dnsEInpjBLPVr1iBUkICTQxSUxfUw9i
	swloSex/cYMNxBYRiJCYv3kHE0gDs8AzJonWF31Akzg4hAVSJWZs0ASpYRFQlfj2ahkLiM0r
	4CrR/uQWO8QyOYkPex6xg5RzCrhJTHxSALHKVeLF9y2sECU/2SUev4UaIyDxbfIhFpByCQFZ
	iU0HmCFKJCUOrrjBMoFReAEjwypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MwAg7/e9Z3w7G
	mwesDzEmA42byCwlmpwPjNC8knhDYzMjC1MTU2Mjc0sz0oSVxHkXPUwKEhJITyxJzU5NLUgt
	ii8qzUktPsTIxMEp1cA4/bf9u4+25wu3J06Kt6uJ0hGt+zGzZKJa//Gr6yJVo5NeFM2b/ffp
	Br52rz2/Fl/2s207sj5rx4ID1n8bhe8kmT7f0yik8GHbRWcnl6PWVo4PlmefuDD1p2HXK4kH
	BuGM7Hf/vXJ69kbCQfDyHiG2vcyLLq9Zbvr0n0Bd7Ly1MrbZNZrHfmi/UWIpzkg01GIuKk4E
	ANfIRizGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t9jQd3Qz2uCDdbUWtx9fpjR4vqX56wW
	84+cY7Xof7OQ1eLcq5WMFg+aVjFZ9C64ymZxtukNu8W8I+9YLC7vmsNmMeP8PiaLpdcvMllM
	mL6WxeLtneksFq17j7BbnPzTy2ixfsZrFgdBjzXz1jB6XO7rZfJYufwLm8fmFVoem1Z1snnc
	ubaHzaNvyypGj8+b5AI4ohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPIS
	c1NtlVx8AnTdMnOA3lBSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZsye
	4VkwxbBi/fdvbA2M/RpdjJwcEgImEj+OzmaHsMUkLtxbz9bFyMUhJDCdUeLZqlesIAkhgSYm
	ielr6kFsNgEtif0vbrCB2CICERLzN+9gAmlgFnjGJNH6oo+xi5GDQ1ggVWLGBk2QGhYBVYlv
	r5axgNi8Aq4S7U9uQS2Tk/iw5xE7SDmngJvExCcFEKtcJV5838I6gZF3ASPDKkbR1ILkguKk
	9FwjveLE3OLSvHS95PzcTYzg+H0mvYNxVYPFIUYBDkYlHt4OrzXBQqyJZcWVuYcYJTiYlUR4
	X94DCvGmJFZWpRblxxeV5qQWH2I0BTpqIrOUaHI+MLXklcQbGpuYGVkamRtaGBmbK4nzHmy1
	DhQSSE8sSc1OTS1ILYLpY+LglGpg1PsYbDnh5KznS/h7zbZxPrwVd9TuprMu2+JKCV4mRyPR
	ix41zvlOHs4W+x3nH/tconMwYIEyR7mu8G2WuHOZT26d3xWc9tDh/XLWf/cP8c2IvfS/sOoT
	w/qoGM3/P1eFChhMUC/Xva56ILni0geOT3ZtXLNuTDHS0WOavTz6du2thg0ZJxclKLEUZyQa
	ajEXFScCAD9vegr1AgAA
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
---
 drivers/iio/adc/exynos_adc.c | 112 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 101 insertions(+), 11 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index 00d67fd..b63e882 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -81,9 +81,11 @@
 
 struct exynos_adc {
 	struct exynos_adc_data	*data;
+	struct device		*dev;
 	void __iomem		*regs;
 	void __iomem		*enable_reg;
 	struct clk		*clk;
+	struct clk		*sclk;
 	unsigned int		irq;
 	struct regulator	*vdd;
 
@@ -95,6 +97,7 @@ struct exynos_adc {
 
 struct exynos_adc_data {
 	int num_channels;
+	bool needs_sclk;
 
 	void (*init_hw)(struct exynos_adc *info);
 	void (*exit_hw)(struct exynos_adc *info);
@@ -102,6 +105,66 @@ struct exynos_adc_data {
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
@@ -199,13 +262,20 @@ static void exynos_adc_v2_start_conv(struct exynos_adc *info,
 	writel(con1 | ADC_CON_EN_START, ADC_V2_CON1(info->regs));
 }
 
+#define __EXYNOS_ADC_V2_DATA				\
+	.num_channels	= MAX_ADC_V2_CHANNELS,		\
+	.init_hw	= exynos_adc_v2_init_hw,	\
+	.exit_hw	= exynos_adc_v2_exit_hw,	\
+	.clear_irq	= exynos_adc_v2_clear_irq,	\
+	.start_conv	= exynos_adc_v2_start_conv,	\
+
 static struct exynos_adc_data const exynos_adc_v2_data = {
-	.num_channels	= MAX_ADC_V2_CHANNELS,
+	__EXYNOS_ADC_V2_DATA
+};
 
-	.init_hw	= exynos_adc_v2_init_hw,
-	.exit_hw	= exynos_adc_v2_exit_hw,
-	.clear_irq	= exynos_adc_v2_clear_irq,
-	.start_conv	= exynos_adc_v2_start_conv,
+static struct exynos_adc_data const exynos3250_adc_v2_data = {
+	__EXYNOS_ADC_V2_DATA
+	.needs_sclk = true,
 };
 
 static const struct of_device_id exynos_adc_match[] = {
@@ -215,6 +285,9 @@ static const struct of_device_id exynos_adc_match[] = {
 	}, {
 		.compatible = "samsung,exynos-adc-v2",
 		.data = (void *)&exynos_adc_v2_data,
+	}, {
+		.compatible = "samsung,exynos3250-adc-v2",
+		.data = (void *)&exynos3250_adc_v2_data,
 	},
 	{},
 };
@@ -376,6 +449,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	}
 
 	info->irq = irq;
+	info->dev = &pdev->dev;
 
 	init_completion(&info->completion);
 
@@ -386,6 +460,16 @@ static int exynos_adc_probe(struct platform_device *pdev)
 		return PTR_ERR(info->clk);
 	}
 
+	if (info->data->needs_sclk) {
+		info->sclk = devm_clk_get(&pdev->dev, "sclk_adc");
+		if (IS_ERR(info->sclk)) {
+			dev_err(&pdev->dev,
+				"failed getting sclk_adc, err = %ld\n",
+				PTR_ERR(info->sclk));
+			return PTR_ERR(info->sclk);
+		}
+	}
+
 	info->vdd = devm_regulator_get(&pdev->dev, "vdd");
 	if (IS_ERR(info->vdd)) {
 		dev_err(&pdev->dev, "failed getting regulator, err = %ld\n",
@@ -397,10 +481,14 @@ static int exynos_adc_probe(struct platform_device *pdev)
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
@@ -443,7 +531,9 @@ err_irq:
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
@@ -460,7 +550,8 @@ static int exynos_adc_remove(struct platform_device *pdev)
 	free_irq(info->irq, info);
 	if (info->data->exit_hw)
 		info->data->exit_hw(info);
-	clk_disable_unprepare(info->clk);
+	exynos_adc_disable_clk(info);
+	exynos_adc_unprepare_clk(info);
 	regulator_disable(info->vdd);
 
 	return 0;
@@ -474,8 +565,7 @@ static int exynos_adc_suspend(struct device *dev)
 
 	if (info->data->exit_hw)
 		info->data->exit_hw(info);
-
-	clk_disable_unprepare(info->clk);
+	exynos_adc_disable_clk(info);
 	regulator_disable(info->vdd);
 
 	return 0;
@@ -491,7 +581,7 @@ static int exynos_adc_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	ret = clk_prepare_enable(info->clk);
+	ret = exynos_adc_enable_clk(info);
 	if (ret)
 		return ret;
 
-- 
1.8.0

