Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290AbaDNJIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:08:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23440 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbaDNJHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:07:14 -0400
X-AuditID: cbfee68f-b7f156d00000276c-88-534ba540e123
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com, kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, t.figa@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 1/2] iio: adc: exynos_adc: Control special clock of ADC to
 support Exynos3250 ADC
Date: Mon, 14 Apr 2014 18:07:05 +0900
Message-id: <1397466426-13870-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397466426-13870-1-git-send-email-cw00.choi@samsung.com>
References: <1397466426-13870-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsWyRsSkWNdxqXewwcl/zBZ3nx9mtLj+5Tmr
	xfwj51gt+t8sZLU492olo8WDplVMFr0LrrJZbHp8jdViYdsSFot5R96xWFzeNYfNYsb5fUwW
	S69fZLKYMH0ti8XbO9NZLFr3HmG3WD/jNYuDoMeaeWsYPS739TJ5rFz+hc1j8wotj02rOoGM
	JfUefVtWMXp83iQXwBHFZZOSmpNZllqkb5fAlfG8oY2t4JN+xc9TrcwNjNvUuxg5OSQETCTe
	tnayQNhiEhfurWfrYuTiEBJYyigx7fgqJpiiVzPnMEIkFjFKXL2/jx3CaWKSWLp7EStIFZuA
	lsT+FzfYQGwRASeJn9/ugY1iFuhklvjXfZ8ZJCEskCqxtv85WAOLgKpE57erYA28Aq4Sp47c
	h1onJ/FhzyOgDRwcnAJuEgfaFUHCQkAl757+YYco+csu0XbOAGKMgMS3yYdYQMolBGQlNh1g
	hiiRlDi44gbLBEbhBYwMqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzECo+z0v2f9OxjvHrA+
	xJgMNG4is5Rocj4wSvNK4g2NzYwsTE1MjY3MLc1IE1YS573/MClISCA9sSQ1OzW1ILUovqg0
	J7X4ECMTB6dUA6OV6GrrmurFc9W59k38M+tw4P8FUhOaLuxh3i3prqHwxX7rlvkBb0T39hvP
	/7Bgk8eJgoP+myRNc84dSX+Uwx//rm6aXeLH8MZVEn5bH57pqNFT/TavR2bbpKVW0iz1Jms2
	Oif/nFpsZ3JTfj0L09Upjse636yOrz3uE8cRJSTyJ3nnvSDb9sVKLMUZiYZazEXFiQDvpHsJ
	yAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jAV2Hpd7BBu++mVncfX6Y0eL6l+es
	FvOPnGO16H+zkNXi3KuVjBYPmlYxWfQuuMpmsenxNVaLhW1LWCzmHXnHYnF51xw2ixnn9zFZ
	LL1+kcliwvS1LBZv70xnsWjde4TdYv2M1ywOgh5r5q1h9Ljc18vksXL5FzaPzSu0PDat6gQy
	ltR79G1ZxejxeZNcAEdUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJu
	qq2Si0+ArltmDtAbSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM5w1t
	bAWf9Ct+nmplbmDcpt7FyMkhIWAi8WrmHEYIW0ziwr31bF2MXBxCAosYJa7e38cO4TQxSSzd
	vYgVpIpNQEti/4sbbCC2iICTxM9v98A6mAU6mSX+dd9nBkkIC6RKrO1/DtbAIqAq0fntKlgD
	r4CrxKkj95kg1slJfNjzCGgDBwengJvEgXZFkLAQUMm7p3/YJzDyLmBkWMUomlqQXFCclJ5r
	pFecmFtcmpeul5yfu4kRHMXPpHcwrmqwOMQowMGoxMPbMcc7WIg1say4MvcQowQHs5II77YM
	r2Ah3pTEyqrUovz4otKc1OJDjMlAR01klhJNzgcmmLySeENjEzMjSyNzQwsjY3PShJXEeQ+2
	WgcKCaQnlqRmp6YWpBbBbGHi4JRqYJwxx+NSqnXQ5OgZ+RWyNelHuLw1pP6YdKzM/9l7XT9S
	2vy6ite2lRrn1E73zzCPjPmVbn/7h+dJTT+NXwEpllsLXnsWC9/aX/5mx76MmzuuF/1sKngR
	lKem+7m65vXx+emn9tvcVF+nKcbUW3oj9uPZ0yF8j/5d3PDI0zlvt7Wuptjbq1/7zimxFGck
	GmoxFxUnAgDEO0UiJgMAAA==
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

Exynos3250 has additional 'sclk_tsadc' clock as following:
- 'sclk_tsadc' clock: special clock for ADC which provide clock to internal ADC

Exynos 4210/4212/4412 and Exynos5250/5420 has not included 'sclk_tsadc' clock
in FSYS_BLK. But, Exynos3250 based on Cortex-A7 has only included 'sclk_tsadc'
clock in FSYS_BLK.

Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Naveen Krishna Chatradhi
Cc: linux-iio@vger.kernel.org
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/iio/adc/exynos_adc.c | 54 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 41 insertions(+), 13 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index d25b262..3c99243 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -40,8 +40,9 @@
 #include <linux/iio/driver.h>
 
 enum adc_version {
-	ADC_V1,
-	ADC_V2
+	ADC_V1 = 0x1,
+	ADC_V2 = 0x2,
+	ADC_V3 = (ADC_V1 | ADC_V2),
 };
 
 /* EXYNOS4412/5250 ADC_V1 registers definitions */
@@ -88,6 +89,7 @@ struct exynos_adc {
 	void __iomem		*regs;
 	void __iomem		*enable_reg;
 	struct clk		*clk;
+	struct clk		*sclk;
 	unsigned int		irq;
 	struct regulator	*vdd;
 
@@ -100,6 +102,7 @@ struct exynos_adc {
 static const struct of_device_id exynos_adc_match[] = {
 	{ .compatible = "samsung,exynos-adc-v1", .data = (void *)ADC_V1 },
 	{ .compatible = "samsung,exynos-adc-v2", .data = (void *)ADC_V2 },
+	{ .compatible = "samsung,exynos-adc-v3", .data = (void *)ADC_V3 },
 	{},
 };
 MODULE_DEVICE_TABLE(of, exynos_adc_match);
@@ -128,7 +131,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 	mutex_lock(&indio_dev->mlock);
 
 	/* Select the channel to be used and Trigger conversion */
-	if (info->version == ADC_V2) {
+	if (info->version & ADC_V2) {
 		con2 = readl(ADC_V2_CON2(info->regs));
 		con2 &= ~ADC_V2_CON2_ACH_MASK;
 		con2 |= ADC_V2_CON2_ACH_SEL(chan->address);
@@ -165,7 +168,7 @@ static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
 	info->value = readl(ADC_V1_DATX(info->regs)) &
 						ADC_DATX_MASK;
 	/* clear irq */
-	if (info->version == ADC_V2)
+	if (info->version & ADC_V2)
 		writel(1, ADC_V2_INT_ST(info->regs));
 	else
 		writel(1, ADC_V1_INTCLR(info->regs));
@@ -226,11 +229,25 @@ static int exynos_adc_remove_devices(struct device *dev, void *c)
 	return 0;
 }
 
+static void exynos_adc_enable_clock(struct exynos_adc *info, bool enable)
+{
+	if (enable) {
+		clk_prepare_enable(info->clk);
+		if (info->version == ADC_V3)
+			clk_prepare_enable(info->sclk);
+
+	} else {
+		if (info->version == ADC_V3)
+			clk_disable_unprepare(info->sclk);
+		clk_disable_unprepare(info->clk);
+	}
+}
+
 static void exynos_adc_hw_init(struct exynos_adc *info)
 {
 	u32 con1, con2;
 
-	if (info->version == ADC_V2) {
+	if (info->version & ADC_V2) {
 		con1 = ADC_V2_CON1_SOFT_RESET;
 		writel(con1, ADC_V2_CON1(info->regs));
 
@@ -300,6 +317,8 @@ static int exynos_adc_probe(struct platform_device *pdev)
 
 	writel(1, info->enable_reg);
 
+	info->version = exynos_adc_get_version(pdev);
+
 	info->clk = devm_clk_get(&pdev->dev, "adc");
 	if (IS_ERR(info->clk)) {
 		dev_err(&pdev->dev, "failed getting clock, err = %ld\n",
@@ -308,6 +327,17 @@ static int exynos_adc_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
+	if (info->version == ADC_V3) {
+		info->sclk = devm_clk_get(&pdev->dev, "sclk_tsadc");
+		if (IS_ERR(info->sclk)) {
+			dev_warn(&pdev->dev,
+				"failed getting sclk clock, err = %ld\n",
+				PTR_ERR(info->sclk));
+			ret = PTR_ERR(info->sclk);
+			goto err_irq;
+		}
+	}
+
 	info->vdd = devm_regulator_get(&pdev->dev, "vdd");
 	if (IS_ERR(info->vdd)) {
 		dev_err(&pdev->dev, "failed getting regulator, err = %ld\n",
@@ -316,8 +346,6 @@ static int exynos_adc_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	info->version = exynos_adc_get_version(pdev);
-
 	platform_set_drvdata(pdev, indio_dev);
 
 	indio_dev->name = dev_name(&pdev->dev);
@@ -340,7 +368,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_iio_dev;
 
-	clk_prepare_enable(info->clk);
+	exynos_adc_enable_clock(info, true);
 
 	exynos_adc_hw_init(info);
 
@@ -356,7 +384,7 @@ err_of_populate:
 	device_for_each_child(&pdev->dev, NULL,
 				exynos_adc_remove_devices);
 	regulator_disable(info->vdd);
-	clk_disable_unprepare(info->clk);
+	exynos_adc_enable_clock(info, false);
 err_iio_dev:
 	iio_device_unregister(indio_dev);
 err_irq:
@@ -372,7 +400,7 @@ static int exynos_adc_remove(struct platform_device *pdev)
 	device_for_each_child(&pdev->dev, NULL,
 				exynos_adc_remove_devices);
 	regulator_disable(info->vdd);
-	clk_disable_unprepare(info->clk);
+	exynos_adc_enable_clock(info, false);
 	writel(0, info->enable_reg);
 	iio_device_unregister(indio_dev);
 	free_irq(info->irq, info);
@@ -387,7 +415,7 @@ static int exynos_adc_suspend(struct device *dev)
 	struct exynos_adc *info = iio_priv(indio_dev);
 	u32 con;
 
-	if (info->version == ADC_V2) {
+	if (info->version & ADC_V2) {
 		con = readl(ADC_V2_CON1(info->regs));
 		con &= ~ADC_CON_EN_START;
 		writel(con, ADC_V2_CON1(info->regs));
@@ -397,7 +425,7 @@ static int exynos_adc_suspend(struct device *dev)
 		writel(con, ADC_V1_CON(info->regs));
 	}
 
-	clk_disable_unprepare(info->clk);
+	exynos_adc_enable_clock(info, false);
 	writel(0, info->enable_reg);
 	regulator_disable(info->vdd);
 
@@ -415,7 +443,7 @@ static int exynos_adc_resume(struct device *dev)
 		return ret;
 
 	writel(1, info->enable_reg);
-	clk_prepare_enable(info->clk);
+	exynos_adc_enable_clock(info, true);
 
 	exynos_adc_hw_init(info);
 
-- 
1.8.0

