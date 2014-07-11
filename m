Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaGKJLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:11:45 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:52094 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaGKJKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:10:42 -0400
X-AuditID: cbfee690-b7fb56d000003439-2a-53bfaa0fefba
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org
Subject: [PATCH 1/4] iio: exyno-adc: use syscon for PMU register access
Date: Fri, 11 Jul 2014 14:36:26 +0530
Message-id: <1405069589-10388-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1405069589-10388-1-git-send-email-ch.naveen@samsung.com>
References: <1405069589-10388-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42JZI2JSrcu/an+wwcctlhYvD2laXP/ynNVi
	/pFzrBbNi9ezWbw68oPJYsnk+awW8468Y7G4vGsOm8WM8/uYLBZt+8/swOUxu+Eii8fOWXfZ
	PfbPXcPuseTNIVaPvi2rGD0+b5ILYIvisklJzcksSy3St0vgyth19iRzwWq5iglfjrM1MM6S
	7GLk5JAQMJHYe+4aM4QtJnHh3nq2LkYuDiGBpYwSjx+3MsMUzZ73jxEiMZ1RYumXm1BOP5PE
	vsX72UCq2ATMJA4uWs0OYosIxEl8uNzPDlLELLCWUaJt21WwhLCAu8Sp11tYuhg5OFgEVCV2
	bPADCfMKuEosPHMVLCwhoCAxZ5INSJhTwE3i279GsCOEgEq23OpmARkpIbCLXeLbu61ge1kE
	BCS+TT4E1SsrsekA1NGSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZg
	NJz+92zCDsZ7B6wPMSYDjZvILCWanA+MprySeENjMyMLUxNTYyNzSzPShJXEedUeJQUJCaQn
	lqRmp6YWpBbFF5XmpBYfYmTi4JRqYLQVMnwZZGgyVzBrx7dLZcbt7GFLp07kWHReJXXdmYiH
	m6a56DPzrVN9WW4TKr6NgWdZjL3i7o+3Nv2pU9n1wGHxmgojr9Cvqp8Ougf8SNTc7zTtw9uA
	+Uf3yrOfL7nR78nE7uzneS5n4YO9Gs2RFXdj5G0us2nzangyctcuXpKv/c5Jy2/CISWW4oxE
	Qy3mouJEAEASF9OcAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t9jQd0PK/cHGxzoY7N4eUjT4vqX56wW
	84+cY7VoXryezeLVkR9MFksmz2e1mHfkHYvF5V1z2CxmnN/HZLFo239mBy6P2Q0XWTx2zrrL
	7rF/7hp2jyVvDrF69G1ZxejxeZNcAFtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGu
	oaWFuZJCXmJuqq2Si0+ArltmDtBpSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM
	0EDCGsaMXWdPMheslquY8OU4WwPjLMkuRk4OCQETidnz/jFC2GISF+6tZ+ti5OIQEpjOKLH0
	y01GCKefSWLf4v1sIFVsAmYSBxetZgexRQTiJD5c7mcHKWIWWMso0bbtKlhCWMBd4tTrLSxd
	jBwcLAKqEjs2+IGEeQVcJRaeuQoWlhBQkJgzyQYkzCngJvHtXyMziC0EVLLlVjfLBEbeBYwM
	qxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCY+2Z1A7GlQ0WhxgFOBiVeHgV1u8LFmJNLCuu
	zD3EKMHBrCTC+6R+f7AQb0piZVVqUX58UWlOavEhRlOgmyYyS4km5wPTQF5JvKGxibmpsaml
	iYWJmaWSOO+BVutAIYH0xJLU7NTUgtQimD4mDk6pBka9BYqaKRv/8r04963q6eOA8jeZu1Q7
	n+8+eOEnm5+0pJ3OHjahR2+jDl/TF9l+pef6cokvLyyEFT5t8PulYfFBxFL458ZAiTgVjS2O
	NmuXqNs5/HN/Jxwa9mtfbaCyZ73RBVW+M0nuaVZ66edvv67uOiHAmN6e2qAb19lTrv6OXXeL
	c1mQrRJLcUaioRZzUXEiAK0RPkrLAgAA
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

