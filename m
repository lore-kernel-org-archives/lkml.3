Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaIPJEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:04:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32615 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaIPJDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:03:39 -0400
X-AuditID: cbfee68d-f79c46d000000b84-1b-5417fce8d811
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cw00.choi@samsung.com,
        gregkh@linuxfoundation.org, naveenkrishna.ch@gmail.com,
        lars@metafoo.de, cpgs@samsung.com, grundler@chromium.org,
        jic23@kernel.org
Subject: [PATCH v2 1/3] iio: exyno-adc: use syscon for PMU register access
Date: Tue, 16 Sep 2014 14:28:49 +0530
Message-id: <1410857931-4980-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1410857931-4980-1-git-send-email-ch.naveen@samsung.com>
References: <1410857931-4980-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkWvfFH/EQg8tnRSxeHtK0uP7lOavF
	/CPnWC2aF69ns3h15AeTxYOmVUwWSybPZ7WYd+Qdi8XlXXPYLGac38dksWjbf2YHbo/ZDRdZ
	PHbOusvusWlVJ5vH/rlr2D2WvDnE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZa7faFxxQ
	rNiw8SxbA+N56S5GTg4JAROJ08t2MEHYYhIX7q1n62Lk4hASWMoo8eHGQtYuRg6wos0TdSHi
	0xkljq1/D1XUzyTxf/I0FpBuNgEziYOLVrOD2CICcRIfLvezgxQxC+xnlHj9ej9YQljAS+L/
	mmOsIDaLgKrEznevwGxeAReJe/2zmSC2KUjMmWQDEuYUcJWYv+MzG4gtBFRyq/MVI8hMCYFj
	7BLvFjdCzRGQ+Db5EAtEr6zEpgPMEN9IShxccYNlAqPwAkaGVYyiqQXJBcVJ6UWGesWJucWl
	eel6yfm5mxiB8XH637PeHYy3D1gfYhTgYFTi4fV4JB4ixJpYVlyZe4jRFGjDRGYp0eR8YBTm
	lcQbGpsZWZiamBobmVuaKYnzKkr9DBYSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAKMmf72L+
	SyTVTSB/WdCSL+v9+cvWfuc913Um4u4rpsec15Yz+E1WEt44MSY+M2bxx6cSzz8dfTfve2fd
	VseP0kmuantzj+SJtbTq31TgttnQtvpHmfcX1exPuts86g2aj9xt90vgKviglfH81bFFXm+t
	nQ8s+z3hpGTyLcPgj78W8MvsW/KtXomlOCPRUIu5qDgRAHAXQIKKAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t9jQd0Xf8RDDK5t57J4eUjT4vqX56wW
	84+cY7VoXryezeLVkR9MFg+aVjFZLJk8n9Vi3pF3LBaXd81hs5hxfh+TxaJt/5kduD1mN1xk
	8dg56y67x6ZVnWwe++euYfdY8uYQq0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2Tmpdsq
	eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHamkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxhzFi71b7ggGLFho1n2RoYz0t3MXJwSAiYSGyeqNvFyAlkiklcuLee
	rYuRi0NIYDqjxLH176GcfiaJ/5OnsYBUsQmYSRxctJodxBYRiJP4cLmfHaSIWWA/o8Tr1/vB
	EsICXhL/1xxjBbFZBFQldr57BWbzCrhI3OufzQSxWUFiziQbkDCngKvE/B2f2UBsIaCSW52v
	GCcw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERx9z6R2MK5ssDjEKMDBqMTD6/FI
	PESINbGsuDL3EKMEB7OSCO+DT0Ah3pTEyqrUovz4otKc1OJDjKZAR01klhJNzgcmhrySeENj
	E3NTY1NLEwsTM0slcd4DrdaBQgLpiSWp2ampBalFMH1MHJxSDYxqs+Rf2sw/nHLnjtgaE7t/
	KUFbju//cmpRkarWzMlnW1omTdsiK9Bcp/+hbPJr/1geZYvqMz84iq/xry/ZNcV7w+UJAuHm
	TovnflmvUmRw/A67edsHLpZ9/7RfrGYM3PBky7PTZl/Nza5vSPp5W/j9C9/H8bE8MbMMcjdP
	lVixu1dw3p/gP82/lViKMxINtZiLihMB8VNBwNQCAAA=
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
Rebased on top of togreg branch of IIO git

 drivers/iio/adc/exynos_adc.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index 43620fd..fe03177 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -39,6 +39,8 @@
 #include <linux/iio/iio.h>
 #include <linux/iio/machine.h>
 #include <linux/iio/driver.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
 
 /* S3C/EXYNOS4412/5250 ADC_V1 registers definitions */
 #define ADC_V1_CON(x)		((x) + 0x00)
@@ -90,11 +92,14 @@
 
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
@@ -110,6 +115,7 @@ struct exynos_adc_data {
 	int num_channels;
 	bool needs_sclk;
 	bool needs_adc_phy;
+	int phy_offset;
 	u32 mask;
 
 	void (*init_hw)(struct exynos_adc *info);
@@ -183,7 +189,7 @@ static void exynos_adc_v1_init_hw(struct exynos_adc *info)
 	u32 con1;
 
 	if (info->data->needs_adc_phy)
-		writel(1, info->enable_reg);
+		regmap_write(info->pmu_map, info->data->phy_offset, 1);
 
 	/* set default prescaler values and Enable prescaler */
 	con1 =  ADC_V1_CON_PRSCLV(49) | ADC_V1_CON_PRSCEN;
@@ -198,7 +204,7 @@ static void exynos_adc_v1_exit_hw(struct exynos_adc *info)
 	u32 con;
 
 	if (info->data->needs_adc_phy)
-		writel(0, info->enable_reg);
+		regmap_write(info->pmu_map, info->data->phy_offset, 0);
 
 	con = readl(ADC_V1_CON(info->regs));
 	con |= ADC_V1_CON_STANDBY;
@@ -225,6 +231,7 @@ static const struct exynos_adc_data exynos_adc_v1_data = {
 	.num_channels	= MAX_ADC_V1_CHANNELS,
 	.mask		= ADC_DATX_MASK,	/* 12 bit ADC resolution */
 	.needs_adc_phy	= true,
+	.phy_offset	= EXYNOS_ADCV1_PHY_OFFSET,
 
 	.init_hw	= exynos_adc_v1_init_hw,
 	.exit_hw	= exynos_adc_v1_exit_hw,
@@ -314,7 +321,7 @@ static void exynos_adc_v2_init_hw(struct exynos_adc *info)
 	u32 con1, con2;
 
 	if (info->data->needs_adc_phy)
-		writel(1, info->enable_reg);
+		regmap_write(info->pmu_map, info->data->phy_offset, 1);
 
 	con1 = ADC_V2_CON1_SOFT_RESET;
 	writel(con1, ADC_V2_CON1(info->regs));
@@ -332,7 +339,7 @@ static void exynos_adc_v2_exit_hw(struct exynos_adc *info)
 	u32 con;
 
 	if (info->data->needs_adc_phy)
-		writel(0, info->enable_reg);
+		regmap_write(info->pmu_map, info->data->phy_offset, 0);
 
 	con = readl(ADC_V2_CON1(info->regs));
 	con &= ~ADC_CON_EN_START;
@@ -362,6 +369,7 @@ static const struct exynos_adc_data exynos_adc_v2_data = {
 	.num_channels	= MAX_ADC_V2_CHANNELS,
 	.mask		= ADC_DATX_MASK, /* 12 bit ADC resolution */
 	.needs_adc_phy	= true,
+	.phy_offset	= EXYNOS_ADCV2_PHY_OFFSET,
 
 	.init_hw	= exynos_adc_v2_init_hw,
 	.exit_hw	= exynos_adc_v2_exit_hw,
@@ -374,6 +382,7 @@ static const struct exynos_adc_data exynos3250_adc_data = {
 	.mask		= ADC_DATX_MASK, /* 12 bit ADC resolution */
 	.needs_sclk	= true,
 	.needs_adc_phy	= true,
+	.phy_offset	= EXYNOS_ADCV1_PHY_OFFSET,
 
 	.init_hw	= exynos_adc_v2_init_hw,
 	.exit_hw	= exynos_adc_v2_exit_hw,
@@ -558,10 +567,13 @@ static int exynos_adc_probe(struct platform_device *pdev)
 
 
 	if (info->data->needs_adc_phy) {
-		mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-		info->enable_reg = devm_ioremap_resource(&pdev->dev, mem);
-		if (IS_ERR(info->enable_reg))
-			return PTR_ERR(info->enable_reg);
+		info->pmu_map = syscon_regmap_lookup_by_phandle(
+					pdev->dev.of_node,
+					"samsung,syscon-phandle");
+		if (IS_ERR(info->pmu_map)) {
+			dev_err(&pdev->dev, "syscon regmap lookup failed.\n");
+			return PTR_ERR(info->pmu_map);
+		}
 	}
 
 	irq = platform_get_irq(pdev, 0);
-- 
1.7.9.5

