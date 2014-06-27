Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaF0Eai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 00:30:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54117 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaF0EaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 00:30:16 -0400
X-AuditID: cbfee68f-b7fef6d000003970-e5-53acf354a609
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com, t.figa@samsung.com,
        kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        kyungmin.park@samsung.com, linux-iio@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv5 1/4] iio: adc: exynos_adc: Add exynos_adc_data structure to
 improve readability
Date: Fri, 27 Jun 2014 13:30:03 +0900
Message-id: <1403843406-28229-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1403843406-28229-1-git-send-email-cw00.choi@samsung.com>
References: <1403843406-28229-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsWyRsSkSDfk85pgg2tbpSzuPj/MaHH9y3NW
	i/lHzrFa9L9ZyGpx7tVKRosHTauYLHoXXGWzONv0ht1i3pF3LBaXd81hs5hxfh+TxdLrF5ks
	Jkxfy2Lx9s50FovWvUfYLU7+6WW0WD/jNYuDoMeaeWsYPS739TJ5rFz+hc1j8wotj02rOtk8
	7lzbw+bRt2UVo8fnTXIBHFFcNimpOZllqUX6dglcGTOvmxU8Dq640NrB2MD40LWLkZNDQsBE
	4sGj3WwQtpjEhXvrgWwuDiGBpYwS5zZ/ZYYpOryqDSoxnVFixruZTCAJIYEmJonNnQIgNpuA
	lsT+FzfAJokIREjM37yDCaSBWeAZk0Triz5GkISwQLLE0SvbWUBsFgFViY6Pn8DivAKuEmsX
	z2GE2CYn8WHPI/YuRg4OTgE3iYlPCiB2uUq8+L6FFWSmhMBPdon//ycyQswRkPg2+RALSL2E
	gKzEpgNQR0tKHFxxg2UCo/ACRoZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGIFRdvrfs/4d
	jHcPWB9iTAYaN5FZSjQ5HxileSXxhsZmRhamJqbGRuaWZqQJK4nz3n+YFCQkkJ5YkpqdmlqQ
	WhRfVJqTWnyIkYmDU6qBsV/+txHHs8lSj4Q35q3m+pr+TtKu07K4oPFtyMs3oS8N5FoOV/Gu
	3Rd322lVY8WCHVfWhLBd+RVXESSwnMfk6Jdcm+8fFH9Gm7hMP/hQyjr45Xv52fNfs1qutA0s
	lT5z5oCAf1rqhbw/enetbOwZNG5bxL8Pk+PKKVQJ39wy+SOD+94LdzM9lViKMxINtZiLihMB
	7OA0e8gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd2Qz2uCDc6281vcfX6Y0eL6l+es
	FvOPnGO16H+zkNXi3KuVjBYPmlYxWfQuuMpmcbbpDbvFvCPvWCwu75rDZjHj/D4mi6XXLzJZ
	TJi+lsXi7Z3pLBate4+wW5z808tosX7GaxYHQY8189Ywelzu62XyWLn8C5vH5hVaHptWdbJ5
	3Lm2h82jb8sqRo/Pm+QCOKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
	EnNTbZVcfAJ03TJzgP5QUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGbM
	vG5W8Di44kJrB2MD40PXLkZODgkBE4nDq9rYIGwxiQv31gPZXBxCAtMZJWa8m8kEkhASaGKS
	2NwpAGKzCWhJ7H9xA6xBRCBCYv7mHUwgDcwCz5gkWl/0MYIkhAWSJY5e2c4CYrMIqEp0fPwE
	FucVcJVYu3gOI8Q2OYkPex6xdzFycHAKuElMfFIAsctV4sX3LawTGHkXMDKsYhRNLUguKE5K
	zzXUK07MLS7NS9dLzs/dxAiO4WdSOxhXNlgcYhTgYFTi4TXwWBMsxJpYVlyZe4hRgoNZSYT3
	5T2gEG9KYmVValF+fFFpTmrxIUZToKMmMkuJJucD00teSbyhsYmZkaWRuaGFkbG5kjjvgVbr
	QCGB9MSS1OzU1ILUIpg+Jg5OqQZGjVrrM5u8WyPnWEqft/JUSONQO+XRmmpYfHaSNfPzV2v1
	tj6/+LFukblK4/03N5TnLdmxvrjyir2BSJ26ldqrlsPtwfLZD4KDXabcUucsrks9xC+mk3jM
	Y/Uh9zOPLabWVD8KfPtLr0v8pJb5s9Pf58bPSbmc7lGaL/VoiXvzBtNDD89oBd1WYinOSDTU
	Yi4qTgQAfTEWrPcCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add 'exynos_adc_data' structure which includes some functions
to control ADC operation and specific data according to ADC version (v1 or v2).

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/iio/adc/exynos_adc.c | 226 ++++++++++++++++++++++++++++---------------
 1 file changed, 147 insertions(+), 79 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index 010578f..00d67fd 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -39,11 +39,6 @@
 #include <linux/iio/machine.h>
 #include <linux/iio/driver.h>
 
-enum adc_version {
-	ADC_V1,
-	ADC_V2
-};
-
 /* EXYNOS4412/5250 ADC_V1 registers definitions */
 #define ADC_V1_CON(x)		((x) + 0x00)
 #define ADC_V1_DLY(x)		((x) + 0x08)
@@ -85,6 +80,7 @@ enum adc_version {
 #define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(100))
 
 struct exynos_adc {
+	struct exynos_adc_data	*data;
 	void __iomem		*regs;
 	void __iomem		*enable_reg;
 	struct clk		*clk;
@@ -97,43 +93,139 @@ struct exynos_adc {
 	unsigned int            version;
 };
 
-static const struct of_device_id exynos_adc_match[] = {
-	{ .compatible = "samsung,exynos-adc-v1", .data = (void *)ADC_V1 },
-	{ .compatible = "samsung,exynos-adc-v2", .data = (void *)ADC_V2 },
-	{},
+struct exynos_adc_data {
+	int num_channels;
+
+	void (*init_hw)(struct exynos_adc *info);
+	void (*exit_hw)(struct exynos_adc *info);
+	void (*clear_irq)(struct exynos_adc *info);
+	void (*start_conv)(struct exynos_adc *info, unsigned long addr);
 };
-MODULE_DEVICE_TABLE(of, exynos_adc_match);
 
-static inline unsigned int exynos_adc_get_version(struct platform_device *pdev)
+static void exynos_adc_v1_init_hw(struct exynos_adc *info)
 {
-	const struct of_device_id *match;
+	u32 con1;
 
-	match = of_match_node(exynos_adc_match, pdev->dev.of_node);
-	return (unsigned int)match->data;
+	writel(1, info->enable_reg);
+
+	/* set default prescaler values and Enable prescaler */
+	con1 =  ADC_V1_CON_PRSCLV(49) | ADC_V1_CON_PRSCEN;
+
+	/* Enable 12-bit ADC resolution */
+	con1 |= ADC_V1_CON_RES;
+	writel(con1, ADC_V1_CON(info->regs));
+}
+
+static void exynos_adc_v1_exit_hw(struct exynos_adc *info)
+{
+	u32 con;
+
+	writel(0, info->enable_reg);
+
+	con = readl(ADC_V1_CON(info->regs));
+	con |= ADC_V1_CON_STANDBY;
+	writel(con, ADC_V1_CON(info->regs));
+}
+
+static void exynos_adc_v1_clear_irq(struct exynos_adc *info)
+{
+	writel(1, ADC_V1_INTCLR(info->regs));
 }
 
-static void exynos_adc_hw_init(struct exynos_adc *info)
+static void exynos_adc_v1_start_conv(struct exynos_adc *info,
+				     unsigned long addr)
+{
+	u32 con1;
+
+	writel(addr, ADC_V1_MUX(info->regs));
+
+	con1 = readl(ADC_V1_CON(info->regs));
+	writel(con1 | ADC_CON_EN_START, ADC_V1_CON(info->regs));
+}
+
+static struct exynos_adc_data const exynos_adc_v1_data = {
+	.num_channels	= MAX_ADC_V1_CHANNELS,
+
+	.init_hw	= exynos_adc_v1_init_hw,
+	.exit_hw	= exynos_adc_v1_exit_hw,
+	.clear_irq	= exynos_adc_v1_clear_irq,
+	.start_conv	= exynos_adc_v1_start_conv,
+};
+
+static void exynos_adc_v2_init_hw(struct exynos_adc *info)
 {
 	u32 con1, con2;
 
-	if (info->version == ADC_V2) {
-		con1 = ADC_V2_CON1_SOFT_RESET;
-		writel(con1, ADC_V2_CON1(info->regs));
+	writel(1, info->enable_reg);
 
-		con2 = ADC_V2_CON2_OSEL | ADC_V2_CON2_ESEL |
-			ADC_V2_CON2_HIGHF | ADC_V2_CON2_C_TIME(0);
-		writel(con2, ADC_V2_CON2(info->regs));
+	con1 = ADC_V2_CON1_SOFT_RESET;
+	writel(con1, ADC_V2_CON1(info->regs));
 
-		/* Enable interrupts */
-		writel(1, ADC_V2_INT_EN(info->regs));
-	} else {
-		/* set default prescaler values and Enable prescaler */
-		con1 =  ADC_V1_CON_PRSCLV(49) | ADC_V1_CON_PRSCEN;
+	con2 = ADC_V2_CON2_OSEL | ADC_V2_CON2_ESEL |
+		ADC_V2_CON2_HIGHF | ADC_V2_CON2_C_TIME(0);
+	writel(con2, ADC_V2_CON2(info->regs));
 
-		/* Enable 12-bit ADC resolution */
-		con1 |= ADC_V1_CON_RES;
-		writel(con1, ADC_V1_CON(info->regs));
-	}
+	/* Enable interrupts */
+	writel(1, ADC_V2_INT_EN(info->regs));
+}
+
+static void exynos_adc_v2_exit_hw(struct exynos_adc *info)
+{
+	u32 con;
+
+	writel(0, info->enable_reg);
+
+	con = readl(ADC_V2_CON1(info->regs));
+	con &= ~ADC_CON_EN_START;
+	writel(con, ADC_V2_CON1(info->regs));
+}
+
+static void exynos_adc_v2_clear_irq(struct exynos_adc *info)
+{
+	writel(1, ADC_V2_INT_ST(info->regs));
+}
+
+static void exynos_adc_v2_start_conv(struct exynos_adc *info,
+				     unsigned long addr)
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
+static struct exynos_adc_data const exynos_adc_v2_data = {
+	.num_channels	= MAX_ADC_V2_CHANNELS,
+
+	.init_hw	= exynos_adc_v2_init_hw,
+	.exit_hw	= exynos_adc_v2_exit_hw,
+	.clear_irq	= exynos_adc_v2_clear_irq,
+	.start_conv	= exynos_adc_v2_start_conv,
+};
+
+static const struct of_device_id exynos_adc_match[] = {
+	{
+		.compatible = "samsung,exynos-adc-v1",
+		.data = (void *)&exynos_adc_v1_data,
+	}, {
+		.compatible = "samsung,exynos-adc-v2",
+		.data = (void *)&exynos_adc_v2_data,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, exynos_adc_match);
+
+static struct exynos_adc_data *exynos_adc_get_data(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+
+	match = of_match_node(exynos_adc_match, pdev->dev.of_node);
+	return (struct exynos_adc_data *)match->data;
 }
 
 static int exynos_read_raw(struct iio_dev *indio_dev,
@@ -144,7 +236,6 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 {
 	struct exynos_adc *info = iio_priv(indio_dev);
 	unsigned long timeout;
-	u32 con1, con2;
 	int ret;
 
 	if (mask != IIO_CHAN_INFO_RAW)
@@ -154,28 +245,15 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
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
+	if (info->data->start_conv)
+		info->data->start_conv(info, chan->address);
 
 	timeout = wait_for_completion_timeout
 			(&info->completion, EXYNOS_ADC_TIMEOUT);
 	if (timeout == 0) {
 		dev_warn(&indio_dev->dev, "Conversion timed out! Resetting\n");
-		exynos_adc_hw_init(info);
+		if (info->data->init_hw)
+			info->data->init_hw(info);
 		ret = -ETIMEDOUT;
 	} else {
 		*val = info->value;
@@ -193,13 +271,11 @@ static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
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
+	if (info->data->clear_irq)
+		info->data->clear_irq(info);
 
 	complete(&info->completion);
 
@@ -277,6 +353,12 @@ static int exynos_adc_probe(struct platform_device *pdev)
 
 	info = iio_priv(indio_dev);
 
+	info->data = exynos_adc_get_data(pdev);
+	if (!info->data) {
+		dev_err(&pdev->dev, "failed getting exynos_adc_data\n");
+		return -EINVAL;
+	}
+
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	info->regs = devm_ioremap_resource(&pdev->dev, mem);
 	if (IS_ERR(info->regs))
@@ -319,10 +401,6 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_disable_reg;
 
-	writel(1, info->enable_reg);
-
-	info->version = exynos_adc_get_version(pdev);
-
 	platform_set_drvdata(pdev, indio_dev);
 
 	indio_dev->name = dev_name(&pdev->dev);
@@ -331,11 +409,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	indio_dev->info = &exynos_adc_iio_info;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->channels = exynos_adc_iio_channels;
-
-	if (info->version == ADC_V1)
-		indio_dev->num_channels = MAX_ADC_V1_CHANNELS;
-	else
-		indio_dev->num_channels = MAX_ADC_V2_CHANNELS;
+	indio_dev->num_channels = info->data->num_channels;
 
 	ret = request_irq(info->irq, exynos_adc_isr,
 					0, dev_name(&pdev->dev), info);
@@ -349,7 +423,8 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_irq;
 
-	exynos_adc_hw_init(info);
+	if (info->data->init_hw)
+		info->data->init_hw(info);
 
 	ret = of_platform_populate(np, exynos_adc_match, NULL, &indio_dev->dev);
 	if (ret < 0) {
@@ -366,7 +441,8 @@ err_of_populate:
 err_irq:
 	free_irq(info->irq, info);
 err_disable_clk:
-	writel(0, info->enable_reg);
+	if (info->data->exit_hw)
+		info->data->exit_hw(info);
 	clk_disable_unprepare(info->clk);
 err_disable_reg:
 	regulator_disable(info->vdd);
@@ -382,7 +458,8 @@ static int exynos_adc_remove(struct platform_device *pdev)
 				exynos_adc_remove_devices);
 	iio_device_unregister(indio_dev);
 	free_irq(info->irq, info);
-	writel(0, info->enable_reg);
+	if (info->data->exit_hw)
+		info->data->exit_hw(info);
 	clk_disable_unprepare(info->clk);
 	regulator_disable(info->vdd);
 
@@ -394,19 +471,10 @@ static int exynos_adc_suspend(struct device *dev)
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
+	if (info->data->exit_hw)
+		info->data->exit_hw(info);
 
-	writel(0, info->enable_reg);
 	clk_disable_unprepare(info->clk);
 	regulator_disable(info->vdd);
 
@@ -427,8 +495,8 @@ static int exynos_adc_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	writel(1, info->enable_reg);
-	exynos_adc_hw_init(info);
+	if (info->data->init_hw)
+		info->data->init_hw(info);
 
 	return 0;
 }
-- 
1.8.0

