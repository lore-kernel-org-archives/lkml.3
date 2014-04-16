Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbaDPKlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:41:15 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36739 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbaDPKlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:41:09 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-4e-534e5e43a445
Message-id: <534E5E41.4090400@samsung.com>
Date: Wed, 16 Apr 2014 12:41:05 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, jic23@kernel.org,
        ch.naveen@samsung.com, kgene.kim@samsung.com
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv3 1/2] iio: adc: exynos_adc: Control special clock of ADC
 to support Exynos3250 ADC
References: <1397643118-6934-1-git-send-email-cw00.choi@samsung.com>
 <1397643118-6934-2-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1397643118-6934-2-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e/4VV3nOL9gg0vPZS3uPj/MaHH9y3NW
	i/lHzrFa9L9ZyGpx7tVKRosHTauYLHoXXGWz2PT4GqvFwrYlLBbzjrxjsbi8aw6bxYzz+5gs
	ll6/yGQxYfpaFou3d6azWLTuPcJucfJPL6ODoMeaeWsYPS739TJ5rFz+hc1j8wotj02rOtk8
	7lzbA+Qtqffo27KK0ePzJrkAzigum5TUnMyy1CJ9uwSujP+/+ApmGVV0zL7E2sB4R72LkZND
	QsBEYt61JawQtpjEhXvr2boYuTiEBJYySrRNvsEK4XwGcqbMZAap4hXQkpg2/RkTiM0ioCrR
	fvsbO4jNJqAm8bnhERuIzQ9Us6bpOguILSoQIXGv8TArRK+gxI/J98DiIgJZErenHmMEsZkF
	XjBJrO3zAbGFBTIlbq/tBKsXEqiXODjtMFANBwengKvE3L/eEOXWEisnbYNqlZfYvOYt8wRG
	wVlINsxCUjYLSdkCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCEx+HUH49JjVocYBTgY
	lXh4Z+T4BguxJpYVV+YeYpTgYFYS4W2M9AsW4k1JrKxKLcqPLyrNSS0+xMjEwSnVwOgSt2bL
	zylKL9Vu/7W78mDuPs80R8GJjBrlrhmf97Iuqrz7oZ3/4tw9eWXnZY/KbVm7VPVpc3o494bQ
	OdP81rX/b835X2FwMFD4cP6Nh3V/7z5ey+KutlHRQFLOsGYej8b+5X3RfTtrdJrnmTfmRwTz
	5n0pPvzfVHpe4Qn9pm09bU5Tp63K/ajEUpyRaKjFXFScCAA2FL1MnwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 16.04.2014 12:11, Chanwoo Choi wrote:
> This patch control special clock for ADC in Exynos series's FSYS block.
> If special clock of ADC is registerd on clock list of common clk framework,
> Exynos ADC drvier have to control this clock.
>
> Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
> - 'adc' clock: bus clock for ADC
>
> Exynos3250 has additional 'sclk_tsadc' clock as following:
> - 'sclk_tsadc' clock: special clock for ADC which provide clock to internal ADC
>
> Exynos 4210/4212/4412 and Exynos5250/5420 has not included 'sclk_tsadc' clock
> in FSYS_BLK. But, Exynos3250 based on Cortex-A7 has only included 'sclk_tsadc'
> clock in FSYS_BLK.
>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Naveen Krishna Chatradhi
> Cc: linux-iio@vger.kernel.org
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>   drivers/iio/adc/exynos_adc.c | 86 +++++++++++++++++++++++++++++++++++++-------
>   1 file changed, 73 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index d25b262..486771e 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -40,8 +40,9 @@
>   #include <linux/iio/driver.h>
>
>   enum adc_version {
> -	ADC_V1,
> -	ADC_V2
> +	ADC_V1 = 0x1,
> +	ADC_V2 = 0x2,
> +	ADC_V3 = (ADC_V1 | ADC_V2),

I don't think Exynos3250 has really a V3 of the ADC block. It looks like 
a V2, just with different integration details. This approach is 
confusing and will create problems if real V3 shows up.

In general, using a version enum and a lot of ifs for particular 
versions in the code is rather a bad practice, especially when multiple 
versions happen to require the same quirks.

Instead, a variant struct should be introduced with bitfields for 
particular quirks and/or register offsets and/or function pointers. Let 
me show example solutions inline with your changes below.

>   };
>
>   /* EXYNOS4412/5250 ADC_V1 registers definitions */
> @@ -85,9 +86,11 @@ enum adc_version {
>   #define EXYNOS_ADC_TIMEOUT	(msecs_to_jiffies(1000))
>
>   struct exynos_adc {
> +	struct device		*dev;
>   	void __iomem		*regs;
>   	void __iomem		*enable_reg;
>   	struct clk		*clk;
> +	struct clk		*sclk;
>   	unsigned int		irq;
>   	struct regulator	*vdd;
>
> @@ -100,6 +103,7 @@ struct exynos_adc {
>   static const struct of_device_id exynos_adc_match[] = {
>   	{ .compatible = "samsung,exynos-adc-v1", .data = (void *)ADC_V1 },
>   	{ .compatible = "samsung,exynos-adc-v2", .data = (void *)ADC_V2 },
> +	{ .compatible = "samsung,exynos-adc-v3", .data = (void *)ADC_V3 },
>   	{},
>   };
>   MODULE_DEVICE_TABLE(of, exynos_adc_match);
> @@ -128,7 +132,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
>   	mutex_lock(&indio_dev->mlock);
>
>   	/* Select the channel to be used and Trigger conversion */
> -	if (info->version == ADC_V2) {
> +	if (info->version >= ADC_V2) {
>   		con2 = readl(ADC_V2_CON2(info->regs));
>   		con2 &= ~ADC_V2_CON2_ACH_MASK;
>   		con2 |= ADC_V2_CON2_ACH_SEL(chan->address);

This function should be split into exynos_adc_v1_read_raw() and 
exynos_adc_v2_read_raw(). Then a function pointer for int 
(*read_raw)(...) should be added to the variant struct I mentioned 
above. Then the generic part of existing exynos_read_raw() would just 
call variant->read_raw().

> @@ -165,7 +169,7 @@ static irqreturn_t exynos_adc_isr(int irq, void *dev_id)
>   	info->value = readl(ADC_V1_DATX(info->regs)) &
>   						ADC_DATX_MASK;
>   	/* clear irq */
> -	if (info->version == ADC_V2)
> +	if (info->version >= ADC_V2)
>   		writel(1, ADC_V2_INT_ST(info->regs));
>   	else
>   		writel(1, ADC_V1_INTCLR(info->regs));

void (*clear_irq)().

> @@ -226,11 +230,43 @@ static int exynos_adc_remove_devices(struct device *dev, void *c)
>   	return 0;
>   }
>
> +static int exynos_adc_enable_clock(struct exynos_adc *info, bool enable)
> +{
> +	int ret;
> +
> +	if (enable) {
> +		ret = clk_prepare_enable(info->clk);
> +		if (ret) {
> +			dev_err(info->dev, "failed to enable adc clock\n");
> +			return ret;
> +		}
> +		if (info->version == ADC_V3) {

Here, a bitfield bool needs_sclk:1; in the variant struct would be 
sufficient.

> +			ret = clk_prepare_enable(info->sclk);
> +			if (ret) {
> +				dev_err(info->dev,
> +					"failed to enable sclk_tsadc clock\n");
> +				goto err;
> +			}
> +		}
> +
> +	} else {
> +		if (info->version == ADC_V3)
> +			clk_disable_unprepare(info->sclk);
> +		clk_disable_unprepare(info->clk);
> +	}
> +
> +	return 0;
> +err:
> +	clk_disable_unprepare(info->clk);
> +
> +	return ret;
> +}

Ugh. Please split this into exynos_adc_enable_clock() and 
exynos_adc_disable_clock().

> +
>   static void exynos_adc_hw_init(struct exynos_adc *info)
>   {
>   	u32 con1, con2;
>
> -	if (info->version == ADC_V2) {
> +	if (info->version >= ADC_V2) {
>   		con1 = ADC_V2_CON1_SOFT_RESET;
>   		writel(con1, ADC_V2_CON1(info->regs));
>

This function should be completely split into v1_hw_init() and 
v2_hw_init() and the code calling currently exynos_adc_hw_init() could 
call variant->hw_init() directly.

> @@ -287,6 +323,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
>   	}
>
>   	info->irq = irq;
> +	info->dev = &pdev->dev;
>
>   	init_completion(&info->completion);
>
> @@ -300,6 +337,8 @@ static int exynos_adc_probe(struct platform_device *pdev)
>
>   	writel(1, info->enable_reg);
>
> +	info->version = exynos_adc_get_version(pdev);
> +

Instead of getting version, here a pointer to variant struct could be 
retrieved.

>   	info->clk = devm_clk_get(&pdev->dev, "adc");
>   	if (IS_ERR(info->clk)) {
>   		dev_err(&pdev->dev, "failed getting clock, err = %ld\n",
> @@ -308,6 +347,16 @@ static int exynos_adc_probe(struct platform_device *pdev)
>   		goto err_irq;
>   	}
>
> +	if (info->version == ADC_V3) {

if (info->variant->needs_sclk) {

> +		info->sclk = devm_clk_get(&pdev->dev, "sclk_tsadc");
> +		if (IS_ERR(info->sclk)) {
> +			ret = PTR_ERR(info->sclk);
> +			dev_warn(&pdev->dev,
> +				"failed getting sclk clock, err = %d\n", ret);
> +			goto err_irq;
> +		}
> +	}
> +

etc., etc.

Best regards,
Tomasz
