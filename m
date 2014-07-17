Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbaGQLYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:24:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14293 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951AbaGQLX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:23:27 -0400
X-AuditID: cbfee68f-b7fef6d000003970-8d-53c7b22c1e2f
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org,
        jic23@kernel.org
Subject: [PATCH 1/4 v2] iio: exyno-adc: use syscon for PMU register access
Date: Thu, 17 Jul 2014 16:49:50 +0530
Message-id: <1405595993-16661-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405595993-16661-1-git-send-email-ch.naveen@samsung.com>
References: <1405595993-16661-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWyRsSkSldn0/Fgg11LDCxeHtK0uP7lOavF
	/CPnWC2aF69ns3h15AeTxYOmVUwWSybPZ7WYd+Qdi8XlXXPYLGac38dksWjbf2YHbo/ZDRdZ
	PHbOusvusWlVJ5vH/rlr2D2WvDnE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZUxYEFRyT
	q7gweS17A+NayS5GDg4JAROJ1rNMXYycQKaYxIV769m6GLk4hASWMkoc6jvNDJEwkbi8aTcL
	RGI6o8S5Zb1QTj+TxOs3nxhBqtgEzCQOLlrNDmKLCMRJfLjczw5SxCywn1Hi9ev9YAlhAS+J
	U+/3sYHYLAKqEov2PgSL8wq4SkzqvcsMcZKCxJxJNiBhTgE3iRVr/rCBhIWASm48yAMZKSFw
	jF1i5csZrBBjBCS+TT7EAtEqK7HpANTRkhIHV9xgmcAovICRYRWjaGpBckFxUnqRsV5xYm5x
	aV66XnJ+7iZGYHSc/vesfwfj3QPWhxiTgcZNZJYSTc4HRldeSbyhsZmRhamJqbGRuaUZacJK
	4rz3HyYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamAMrQtuXb0964v5il15vz3nBtwIkFE5
	78NWUdj+17Zu2pR5UY+l3R5mLZxnHdBupuH1Z8Ga7IKXUXa3FP+pqTerOhgazOFO+Cl2zkFj
	g/zF2HspMXmMThIx6/4dfeHFk2tY+JFjqrjag6ZPa1f/ustbq58uxbO4cMIsTWZbIdvOE5c3
	sLnK5CixFGckGmoxFxUnAgCiAZO0pAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t9jQV2dTceDDZp2aFi8PKRpcf3Lc1aL
	+UfOsVo0L17PZvHqyA8miwdNq5gslkyez2ox78g7FovLu+awWcw4v4/JYtG2/8wO3B6zGy6y
	eOycdZfdY9OqTjaP/XPXsHsseXOI1aNvyypGj8+b5ALYoxoYbTJSE1NSixRS85LzUzLz0m2V
	vIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAjlRSKEvMKQUKBSQWFyvp22GaEBripmsB
	0xih6xsSBNdjZIAGEtYwZkxZEFRwTK7iwuS17A2MayW7GDk5JARMJC5v2s0CYYtJXLi3nq2L
	kYtDSGA6o8S5Zb0sEE4/k8TrN58YQarYBMwkDi5azQ5iiwjESXy43M8OUsQssJ9R4vXr/WAJ
	YQEviVPv97GB2CwCqhKL9j4Ei/MKuEpM6r3L3MXIAbROQWLOJBuQMKeAm8SKNX/YQMJCQCU3
	HuRNYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4+p5J7WBc2WBxiFGAg1GJhzeh
	9ViwEGtiWXFl7iFGCQ5mJRHebV3Hg4V4UxIrq1KL8uOLSnNSiw8xmgLdNJFZSjQ5H5gY8kri
	DY1NzE2NTS1NLEzMLJXEeQ+0WgcKCaQnlqRmp6YWpBbB9DFxcEo1MBq8tVy16fiK7qa3iUwp
	YlMCDgTYnrJsCPtew1iS+lOfPfDwLKn1SblMl6q1HVYELlL3s7Gq1XGz69nMe3Ad56O1pY5h
	KYoK2ySfhGrdunA0ZbZ8+P3XC3/7ybAKTFB159+9VEPI/zmH7pdfsW1GXxRztz9cr5FxyXyG
	Wf1U3WtbNc9I7J0/W4mlOCPRUIu5qDgRANCsX5fUAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the IIO based ADC driver to use syscon and regmap
APIs to access and use PMU registers instead of remapping the PMU
registers in the driver.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
---
Changes since v1:
None

 drivers/iio/adc/exynos_adc.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index b63e882..60847ef 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -38,6 +38,8 @@
 #include <linux/iio/iio.h>
 #include <linux/iio/machine.h>
 #include <linux/iio/driver.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
 
 /* EXYNOS4412/5250 ADC_V1 registers definitions */
 #define ADC_V1_CON(x)		((x) + 0x00)
@@ -79,11 +81,14 @@
 
 #define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(100))
 
+#define EXYNOS_ADCV1_PHY_OFFSET	0x0718
+#define EXYNOS_ADCV2_PHY_OFFSET	0x0720
+
 struct exynos_adc {
 	struct exynos_adc_data	*data;
 	struct device		*dev;
 	void __iomem		*regs;
-	void __iomem		*enable_reg;
+	struct regmap		*pmu_map;
 	struct clk		*clk;
 	struct clk		*sclk;
 	unsigned int		irq;
@@ -98,6 +103,7 @@ struct exynos_adc {
 struct exynos_adc_data {
 	int num_channels;
 	bool needs_sclk;
+	int phy_offset;
 
 	void (*init_hw)(struct exynos_adc *info);
 	void (*exit_hw)(struct exynos_adc *info);
@@ -169,7 +175,7 @@ static void exynos_adc_v1_init_hw(struct exynos_adc *info)
 {
 	u32 con1;
 
-	writel(1, info->enable_reg);
+	regmap_write(info->pmu_map, info->data->phy_offset, 1);
 
 	/* set default prescaler values and Enable prescaler */
 	con1 =  ADC_V1_CON_PRSCLV(49) | ADC_V1_CON_PRSCEN;
@@ -183,7 +189,7 @@ static void exynos_adc_v1_exit_hw(struct exynos_adc *info)
 {
 	u32 con;
 
-	writel(0, info->enable_reg);
+	regmap_write(info->pmu_map, info->data->phy_offset, 0);
 
 	con = readl(ADC_V1_CON(info->regs));
 	con |= ADC_V1_CON_STANDBY;
@@ -208,6 +214,7 @@ static void exynos_adc_v1_start_conv(struct exynos_adc *info,
 
 static struct exynos_adc_data const exynos_adc_v1_data = {
 	.num_channels	= MAX_ADC_V1_CHANNELS,
+	.phy_offset	= EXYNOS_ADCV1_PHY_OFFSET,
 
 	.init_hw	= exynos_adc_v1_init_hw,
 	.exit_hw	= exynos_adc_v1_exit_hw,
@@ -219,7 +226,7 @@ static void exynos_adc_v2_init_hw(struct exynos_adc *info)
 {
 	u32 con1, con2;
 
-	writel(1, info->enable_reg);
+	regmap_write(info->pmu_map, info->data->phy_offset, 1);
 
 	con1 = ADC_V2_CON1_SOFT_RESET;
 	writel(con1, ADC_V2_CON1(info->regs));
@@ -236,7 +243,7 @@ static void exynos_adc_v2_exit_hw(struct exynos_adc *info)
 {
 	u32 con;
 
-	writel(0, info->enable_reg);
+	regmap_write(info->pmu_map, info->data->phy_offset, 0);
 
 	con = readl(ADC_V2_CON1(info->regs));
 	con &= ~ADC_CON_EN_START;
@@ -271,10 +278,12 @@ static void exynos_adc_v2_start_conv(struct exynos_adc *info,
 
 static struct exynos_adc_data const exynos_adc_v2_data = {
 	__EXYNOS_ADC_V2_DATA
+	.phy_offset = EXYNOS_ADCV2_PHY_OFFSET,
 };
 
 static struct exynos_adc_data const exynos3250_adc_v2_data = {
 	__EXYNOS_ADC_V2_DATA
+	.phy_offset = EXYNOS_ADCV1_PHY_OFFSET,
 	.needs_sclk = true,
 };
 
@@ -437,10 +446,12 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	if (IS_ERR(info->regs))
 		return PTR_ERR(info->regs);
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	info->enable_reg = devm_ioremap_resource(&pdev->dev, mem);
-	if (IS_ERR(info->enable_reg))
-		return PTR_ERR(info->enable_reg);
+	info->pmu_map = syscon_regmap_lookup_by_phandle(pdev->dev.of_node,
+					"samsung,syscon-phandle");
+	if (IS_ERR(info->pmu_map)) {
+		dev_err(&pdev->dev, "syscon regmap lookup failed.\n");
+		return PTR_ERR(info->pmu_map);
+	}
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
-- 
1.7.9.5

