Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638AbaFRCVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 22:21:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21474 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442AbaFRCVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 22:21:13 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-53-53a0f7946847
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com, t.figa@samsung.com,
        kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 1/4] iio: adc: exynos_adc: Add exynos_adc_ops structure to
 improve readability
Date: Wed, 18 Jun 2014 11:20:58 +0900
Message-id: <1403058061-24271-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1403058061-24271-1-git-send-email-cw00.choi@samsung.com>
References: <1403058061-24271-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsWyRsSkQHfK9wXBBg2brSzuPj/MaHH9y3NW
	i/lHzrFa9L9ZyGpx7tVKRosHTauYLHoXXGWzWNi2hMVi3pF3LBaXd81hs5hxfh+TxdLrF5ks
	Jkxfy2Lx9s50FovWvUfYLU7+6WW0WD/jNYuDoMeaeWsYPS739TJ5rFz+hc1j8wotj02rOtk8
	7lzbw+bRt2UVo8fnTXIBHFFcNimpOZllqUX6dglcGT1bO9kLVjtWLNg+hamBcYJZFyMnh4SA
	icTV/T/YIWwxiQv31rN1MXJxCAksZZSY3TOVpYuRA6xoUasdRHw6o8TUtWfYQBqEBJqYJBbv
	KQCx2QS0JPa/uAEWFxGIkJi/eQcTSAOzwAsmiUd3HzCCJIQFkiSal61mAxnKIqAq8eUwH0iY
	V8BV4uG9U1BHyEl82PMIzOYUcJP4uWEGC8QuV4lpD+awgMyUEGjkkGh/uZwVJMEiICDxbfIh
	qENlJTYdYIaYIylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525iBEbZ6X/P
	Ju5gvH/A+hBjMtC4icxSosn5wCjNK4k3NDYzsjA1MTU2Mrc0I01YSZw3/VFSkJBAemJJanZq
	akFqUXxRaU5q8SFGJg5OqQZGz0x2XmnBlambL2Wk7DR4e8z7ymkGb79V5uteT9Ldaq36apX+
	lVuLbi+MKvyR9mHltYw50989X6e1JdK05KVLg/p0kXM3uBbHuYSw7v30caFj/7X1T+RM/ml5
	HtincfQFd8Jc26c/Ix7yHxGXU1LQWnqxMtu4RclD8t201bO73x07m7N+0boXbEosxRmJhlrM
	RcWJAHvHYZbIAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQd0p3xcEGyyeYWhx9/lhRovrX56z
	Wsw/co7Vov/NQlaLc69WMlo8aFrFZNG74CqbxcK2JSwW8468Y7G4vGsOm8WM8/uYLJZev8hk
	MWH6WhaLt3ems1i07j3CbnHyTy+jxfoZr1kcBD3WzFvD6HG5r5fJY+XyL2wem1doeWxa1cnm
	cefaHjaPvi2rGD0+b5IL4IhqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LI
	S8xNtVVy8QnQdcvMAfpDSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jR
	s7WTvWC1Y8WC7VOYGhgnmHUxcnBICJhILGq162LkBDLFJC7cW8/WxcjFISQwnVFi6tozbCAJ
	IYEmJonFewpAbDYBLYn9L26AxUUEIiTmb97BBNLALPCCSeLR3QeMIAlhgSSJ5mWr2UAWsAio
	Snw5zAcS5hVwlXh47xQ7xDI5iQ97HoHZnAJuEj83zGCB2OUqMe3BHJYJjLwLGBlWMYqmFiQX
	FCel5xrpFSfmFpfmpesl5+duYgTH8DPpHYyrGiwOMQpwMCrx8HLkLggWYk0sK67MPcQowcGs
	JMKrcg4oxJuSWFmVWpQfX1Sak1p8iDEZ6KiJzFKiyfnA9JJXEm9obGJmZGlkbmhhZGxOmrCS
	OO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYwWm4IPrm7nEk6Nm2F3d3vXesYdjqx6Yd4Tr2Xe
	9d+S++Xunza/gz+Uujs3h9zhqP02pbHDraNd2jD/1AzujS8i1/R4SEwyS3h6R6j/d/H817MN
	NCZrdOi72n61dryz/xIzI+O9r8+XvTxrq3TBNXrzo+7eLatKhKZeP2JSuq747Jt7Tate6C1R
	YinOSDTUYi4qTgQA4BMAGyUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add 'exynos_adc_ops' structure which includes some functions
to control ADC operation according to ADC version (v1 or v2).

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/iio/adc/exynos_adc.c | 174 +++++++++++++++++++++++++++++--------------
 1 file changed, 120 insertions(+), 54 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index 010578f..c30def6 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -90,6 +90,7 @@ struct exynos_adc {
 	struct clk		*clk;
 	unsigned int		irq;
 	struct regulator	*vdd;
+	struct exynos_adc_ops	*ops;
 
 	struct completion	completion;
 
@@ -97,6 +98,13 @@ struct exynos_adc {
 	unsigned int            version;
 };
 
+struct exynos_adc_ops {
+	void (*init_hw)(struct exynos_adc *info);
+	void (*clear_irq)(struct exynos_adc *info);
+	void (*start_conv)(struct exynos_adc *info, unsigned long addr);
+	void (*stop_conv)(struct exynos_adc *info);
+};
+
 static const struct of_device_id exynos_adc_match[] = {
 	{ .compatible = "samsung,exynos-adc-v1", .data = (void *)ADC_V1 },
 	{ .compatible = "samsung,exynos-adc-v2", .data = (void *)ADC_V2 },
@@ -112,30 +120,98 @@ static inline unsigned int exynos_adc_get_version(struct platform_device *pdev)
 	return (unsigned int)match->data;
 }
 
-static void exynos_adc_hw_init(struct exynos_adc *info)
+static void exynos_adc_v1_init_hw(struct exynos_adc *info)
+{
+	u32 con1;
+
+	/* set default prescaler values and Enable prescaler */
+	con1 =  ADC_V1_CON_PRSCLV(49) | ADC_V1_CON_PRSCEN;
+
+	/* Enable 12-bit ADC resolution */
+	con1 |= ADC_V1_CON_RES;
+	writel(con1, ADC_V1_CON(info->regs));
+}
+
+static void exynos_adc_v1_start_conv(struct exynos_adc *info, unsigned long addr)
+{
+	u32 con1;
+
+	writel(addr, ADC_V1_MUX(info->regs));
+
+	con1 = readl(ADC_V1_CON(info->regs));
+	writel(con1 | ADC_CON_EN_START, ADC_V1_CON(info->regs));
+}
+
+static void exynos_adc_v1_clear_irq(struct exynos_adc *info)
+{
+	writel(1, ADC_V1_INTCLR(info->regs));
+}
+
+static void exynos_adc_v1_stop_conv(struct exynos_adc *info)
+{
+	u32 con;
+
+	con = readl(ADC_V1_CON(info->regs));
+	con |= ADC_V1_CON_STANDBY;
+	writel(con, ADC_V1_CON(info->regs));
+}
+
+static struct exynos_adc_ops exynos_adc_v1_ops = {
+	.init_hw	= exynos_adc_v1_init_hw,
+	.clear_irq	= exynos_adc_v1_clear_irq,
+	.start_conv	= exynos_adc_v1_start_conv,
+	.stop_conv	= exynos_adc_v1_stop_conv,
+};
+
+static void exynos_adc_v2_init_hw(struct exynos_adc *info)
 {
 	u32 con1, con2;
 
-	if (info->version == ADC_V2) {
-		con1 = ADC_V2_CON1_SOFT_RESET;
-		writel(con1, ADC_V2_CON1(info->regs));
+	con1 = ADC_V2_CON1_SOFT_RESET;
+	writel(con1, ADC_V2_CON1(info->regs));
 
-		con2 = ADC_V2_CON2_OSEL | ADC_V2_CON2_ESEL |
-			ADC_V2_CON2_HIGHF | ADC_V2_CON2_C_TIME(0);
-		writel(con2, ADC_V2_CON2(info->regs));
+	con2 = ADC_V2_CON2_OSEL | ADC_V2_CON2_ESEL |
+		ADC_V2_CON2_HIGHF | ADC_V2_CON2_C_TIME(0);
+	writel(con2, ADC_V2_CON2(info->regs));
 
-		/* Enable interrupts */
-		writel(1, ADC_V2_INT_EN(info->regs));
-	} else {
-		/* set default prescaler values and Enable prescaler */
-		con1 =  ADC_V1_CON_PRSCLV(49) | ADC_V1_CON_PRSCEN;
+	/* Enable interrupts */
+	writel(1, ADC_V2_INT_EN(info->regs));
+}
 
-		/* Enable 12-bit ADC resolution */
-		con1 |= ADC_V1_CON_RES;
-		writel(con1, ADC_V1_CON(info->regs));
-	}
+static void exynos_adc_v2_start_conv(struct exynos_adc *info, unsigned long addr)
+{
+	u32 con1, con2;
+
+	con2 = readl(ADC_V2_CON2(info->regs));
+	con2 &= ~ADC_V2_CON2_ACH_MASK;
+	con2 |= ADC_V2_CON2_ACH_SEL(addr);
+	writel(con2, ADC_V2_CON2(info->regs));
+
+	con1 = readl(ADC_V2_CON1(info->regs));
+	writel(con1 | ADC_CON_EN_START, ADC_V2_CON1(info->regs));
+}
+
+static void exynos_adc_v2_clear_irq(struct exynos_adc *info)
+{
+	writel(1, ADC_V2_INT_ST(info->regs));
+}
+
+static void exynos_adc_v2_stop_conv(struct exynos_adc *info)
+{
+	u32 con;
+
+	con = readl(ADC_V2_CON1(info->regs));
+	con &= ~ADC_CON_EN_START;
+	writel(con, ADC_V2_CON1(info->regs));
 }
 
+static struct exynos_adc_ops exynos_adc_v2_ops = {
+	.init_hw	= exynos_adc_v2_init_hw,
+	.start_conv	= exynos_adc_v2_start_conv,
+	.clear_irq	= exynos_adc_v2_clear_irq,
+	.stop_conv	= exynos_adc_v2_stop_conv,
+};
+
 static int exynos_read_raw(struct iio_dev *indio_dev,
 				struct iio_chan_spec const *chan,
 				int *val,
@@ -144,7 +220,6 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 {
 	struct exynos_adc *info = iio_priv(indio_dev);
 	unsigned long timeout;
-	u32 con1, con2;
 	int ret;
 
 	if (mask != IIO_CHAN_INFO_RAW)
@@ -154,28 +229,15 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 	reinit_completion(&info->completion);
 
 	/* Select the channel to be used and Trigger conversion */
-	if (info->version == ADC_V2) {
-		con2 = readl(ADC_V2_CON2(info->regs));
-		con2 &= ~ADC_V2_CON2_ACH_MASK;
-		con2 |= ADC_V2_CON2_ACH_SEL(chan->address);
-		writel(con2, ADC_V2_CON2(info->regs));
-
-		con1 = readl(ADC_V2_CON1(info->regs));
-		writel(con1 | ADC_CON_EN_START,
-				ADC_V2_CON1(info->regs));
-	} else {
-		writel(chan->address, ADC_V1_MUX(info->regs));
-
-		con1 = readl(ADC_V1_CON(info->regs));
-		writel(con1 | ADC_CON_EN_START,
-				ADC_V1_CON(info->regs));
-	}
+	if (info->ops->start_conv)
+		info->ops->start_conv(info, chan->address);
 
 	timeout = wait_for_completion_timeout
 			(&info->completion, EXYNOS_ADC_TIMEOUT);
 	if (timeout == 0) {
 		dev_warn(&indio_dev->dev, "Conversion timed out! Resetting\n");
-		exynos_adc_hw_init(info);
+		if (info->ops->init_hw)
+			info->ops->init_hw(info);
 		ret = -ETIMEDOUT;
 	} else {
 		*val = info->value;
@@ -193,13 +255,11 @@ static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
 	struct exynos_adc *info = (struct exynos_adc *)dev_id;
 
 	/* Read value */
-	info->value = readl(ADC_V1_DATX(info->regs)) &
-						ADC_DATX_MASK;
+	info->value = readl(ADC_V1_DATX(info->regs)) & ADC_DATX_MASK;
+
 	/* clear irq */
-	if (info->version == ADC_V2)
-		writel(1, ADC_V2_INT_ST(info->regs));
-	else
-		writel(1, ADC_V1_INTCLR(info->regs));
+	if (info->ops->clear_irq)
+		info->ops->clear_irq(info);
 
 	complete(&info->completion);
 
@@ -277,6 +337,19 @@ static int exynos_adc_probe(struct platform_device *pdev)
 
 	info = iio_priv(indio_dev);
 
+	info->version = exynos_adc_get_version(pdev);
+	switch (info->version) {
+	case ADC_V1:
+		info->ops = &exynos_adc_v1_ops;
+		break;
+	case ADC_V2:
+		info->ops = &exynos_adc_v2_ops;
+		break;
+	default:
+		dev_err(&pdev->dev, "failed to identify ADC version\n");
+		return -EINVAL;
+	};
+
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	info->regs = devm_ioremap_resource(&pdev->dev, mem);
 	if (IS_ERR(info->regs))
@@ -321,8 +394,6 @@ static int exynos_adc_probe(struct platform_device *pdev)
 
 	writel(1, info->enable_reg);
 
-	info->version = exynos_adc_get_version(pdev);
-
 	platform_set_drvdata(pdev, indio_dev);
 
 	indio_dev->name = dev_name(&pdev->dev);
@@ -349,7 +420,8 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_irq;
 
-	exynos_adc_hw_init(info);
+	if (info->ops->init_hw)
+		info->ops->init_hw(info);
 
 	ret = of_platform_populate(np, exynos_adc_match, NULL, &indio_dev->dev);
 	if (ret < 0) {
@@ -394,17 +466,9 @@ static int exynos_adc_suspend(struct device *dev)
 {
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	struct exynos_adc *info = iio_priv(indio_dev);
-	u32 con;
 
-	if (info->version == ADC_V2) {
-		con = readl(ADC_V2_CON1(info->regs));
-		con &= ~ADC_CON_EN_START;
-		writel(con, ADC_V2_CON1(info->regs));
-	} else {
-		con = readl(ADC_V1_CON(info->regs));
-		con |= ADC_V1_CON_STANDBY;
-		writel(con, ADC_V1_CON(info->regs));
-	}
+	if (info->ops->stop_conv)
+		info->ops->stop_conv(info);
 
 	writel(0, info->enable_reg);
 	clk_disable_unprepare(info->clk);
@@ -428,7 +492,9 @@ static int exynos_adc_resume(struct device *dev)
 		return ret;
 
 	writel(1, info->enable_reg);
-	exynos_adc_hw_init(info);
+
+	if (info->ops->init_hw)
+		info->ops->init_hw(info);
 
 	return 0;
 }
-- 
1.8.0

