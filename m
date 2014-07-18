Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760362AbaGRGAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 02:00:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37909 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759628AbaGRF74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 01:59:56 -0400
X-AuditID: cbfee68f-b7fef6d000003970-f4-53c8b7d7b36f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, kyungmin.park@samsung.com,
        t.figa@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv6 2/4] iio: adc: exynos_adc: Control special clock of ADC to
 support Exynos3250 ADC
Date: Fri, 18 Jul 2014 14:59:44 +0900
Message-id: <1405663186-26464-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsWyRsSkSPf69hPBBhu2y1ncfX6Y0eL6l+es
	FvOPnGO16H+zkNXi3KuVjBYPmlYxWfQuuMpmcbbpDbvFpsfXWC0Wti1hsZh35B2LxeVdc9gs
	Zpzfx2Sx9PpFJosJ09eyWLy9M53FonXvEXaL9TNeszgIeayZt4bR43JfL5PHyuVf2Dw2r9Dy
	2LSqE8hYUu/Rt2UVo8fnTXIBHFFcNimpOZllqUX6dglcGf8232IqOGxY8endF+YGxp0aXYyc
	HBICJhJzG06yQ9hiEhfurWcDsYUEljJKLD8lDlPz8stjpi5GLqD4IkaJSe/3s0M4TUwS1+ee
	ZgKpYhPQktj/4gZYt4iAtsSEhR1sIEXMAnuZJbavf88MkhAWSJVouv+NEcRmEVCVuLdjP1gD
	r4CrxP2Gl0wQ6+QkPux5BHYSp4CbxL/eq6wQJ7lKTOo7D3aGhMBfdonlcw6yQgwSkPg2+RBL
	FyMHUEJWYtMBZog5khIHV9xgmcAovICRYRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGYMSd
	/vesfwfj3QPWhxiTgcZNZJYSTc4HRmxeSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5ak
	ZqemFqQWxReV5qQWH2Jk4uCUamBMWBK0f30x60rHYMdrBo/eTT115dAdVk4nJ5WItfeUdpQc
	KV4S6zxjtqz5j+etAenpUfNP7s/bb/Jk35SYixJOLXM5Gw4rJAsydLLu3PPpAvf3ui8TphZu
	muD4MT+y7ISQfvic8K3bNwYpx0xq2tro/vKs9M6VRtvezeRTcdV4per6a2vig5tZSizFGYmG
	WsxFxYkAvMwvUc4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t9jAd3r208EGzzqErG4+/wwo8X1L89Z
	LeYfOcdq0f9mIavFuVcrGS0eNK1isuhdcJXN4mzTG3aLTY+vsVosbFvCYjHvyDsWi8u75rBZ
	zDi/j8li6fWLTBYTpq9lsXh7ZzqLReveI+wW62e8ZnEQ8lgzbw2jx+W+XiaPlcu/sHlsXqHl
	sWlVJ5CxpN6jb8sqRo/Pm+QCOKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3M
	lRTyEnNTbZVcfAJ03TJzgH5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLW
	MGb823yLqeCwYcWnd1+YGxh3anQxcnJICJhIvPzymAnCFpO4cG89WxcjF4eQwCJGiUnv97ND
	OE1MEtfnngarYhPQktj/4gYbiC0ioC0xYWEHWAezwF5mie3r3zODJIQFUiWa7n9jBLFZBFQl
	7u3YD9bAK+Aqcb/hJdQ6OYkPex6xg9icAm4S/3qvsoLYQkA1k/rOM01g5F3AyLCKUTS1ILmg
	OCk911CvODG3uDQvXS85P3cTIziin0ntYFzZYHGIUYCDUYmH1+Lm8WAh1sSy4srcQ4wSHMxK
	IrzZ94FCvCmJlVWpRfnxRaU5qcWHGE2BrprILCWanA9MNnkl8YbGJmZGlkbmhhZGxuZK4rwH
	Wq0DhQTSE0tSs1NTC1KLYPqYODilGhin3J36scQ3j/cof/uibUV5Or+XXYqdF8tV/jbQuFLf
	uYh77f1p5RwhvG7fks3kkh5ONnOZFHaoS9/3bCbbw+2d3Oq+biZbHzI9lLLcpxh27FPTNbsD
	C3/PSatU2Jqi/Cqv5rfeI69EzeSv/7xu2exJ7NRY17PP49+f0jAn9dX79TezxDv01CqxFGck
	GmoxFxUnAgDWGlZP/gIAAA==
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

