Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbaDKJl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:41:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29850 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaDKJlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:41:51 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-6c-5347b8dd8ba6
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: jic23@kernel.org, ch.naveen@samsung.com, kgene.kim@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] iio: adc: exynos_adc: Control special clock of ADC to
 support Exynos3250 ADC
Date: Fri, 11 Apr 2014 11:41:41 +0200
Message-id: <18632148.yOYlTYattA@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1397181640-18513-1-git-send-email-cw00.choi@samsung.com>
References: <1397181640-18513-1-git-send-email-cw00.choi@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9jQd27O9yDDT5ts7K4+/wwo8X1L89Z
	LR40rWKy6F1wlc3ibNMbdotNj6+xWsw78o7F4vKuOWwWM87vY3Lg9Ni0qpPNY/OSeo++LasY
	PT5vkgtgieKySUnNySxLLdK3S+DK+HB1F0vBJumKvXOmsDUwLhPrYuTgkBAwkbh1pryLkRPI
	FJO4cG89G4gtJDCdUeL9Uo0uRi4gu4VJYtHaBWAJNgEriYntqxhBbBEBDYmZf68wghQxC3xl
	lHjyfRkzyFBhgWSJtRcEQGpYBFQlHj7YzA5i8wpoSWw9/IIFxBYV8JTYsX0lG0g5p4CbxLJ1
	rBB7XSVazz9igygXlPgx+R5YObOAvMS+/VNZIWwdif2t09gmMArMQlI2C0nZLCRlCxiZVzGK
	phYkFxQnpeca6hUn5haX5qXrJefnbmIEB/ozqR2MKxssDjEKcDAq8fBmXHALFmJNLCuuzD3E
	KMHBrCTC67bBPViINyWxsiq1KD++qDQntfgQozQHi5I474FW60AhgfTEktTs1NSC1CKYLBMH
	p1QD4462/Qo+E7XX8IkqckfeWdXbaZ5+XXv99yc5j8K0yxOmbWLdai9Vv73qE+srftMs5Yws
	KWmLrCkFa+vy2C7PXPPOXkhnp3V2Tth61jUPlreYpbyYefZaqa6V2G+e6POR1RMvzvm3+Hya
	44fGVy7TqyY7RHhvUVghaN8S+e58TO1uhwnpK5Y6KbEUZyQaajEXFScCABJRB2FwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Friday, April 11, 2014 11:00:40 AM Chanwoo Choi wrote:
> This patch control special clock for ADC in Exynos series's FSYS block.

s/control/controls/

> If special clock of ADC is registerd on clock list of common clk framework,
> Exynos ADC drvier have to control this clock.

s/drvier/driver/

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
> Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Cc: linux-iio@vger.kernel.org
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/iio/adc/exynos_adc.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
> index d25b262..4cd1975 100644
> --- a/drivers/iio/adc/exynos_adc.c
> +++ b/drivers/iio/adc/exynos_adc.c
> @@ -88,6 +88,7 @@ struct exynos_adc {
>  	void __iomem		*regs;
>  	void __iomem		*enable_reg;
>  	struct clk		*clk;
> +	struct clk		*sclk;
>  	unsigned int		irq;
>  	struct regulator	*vdd;
>  
> @@ -308,6 +309,13 @@ static int exynos_adc_probe(struct platform_device *pdev)
>  		goto err_irq;
>  	}
>  
> +	info->sclk = devm_clk_get(&pdev->dev, "sclk_tsadc");
> +	if (IS_ERR(info->sclk)) {
> +		dev_warn(&pdev->dev, "failed getting sclk clock, err = %ld\n",
> +							PTR_ERR(info->sclk));
> +		info->sclk = NULL;
> +	}
> +
>  	info->vdd = devm_regulator_get(&pdev->dev, "vdd");
>  	if (IS_ERR(info->vdd)) {
>  		dev_err(&pdev->dev, "failed getting regulator, err = %ld\n",
> @@ -341,6 +349,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
>  		goto err_iio_dev;
>  
>  	clk_prepare_enable(info->clk);
> +	clk_prepare_enable(info->sclk);
>  
>  	exynos_adc_hw_init(info);
>  
> @@ -357,6 +366,7 @@ err_of_populate:
>  				exynos_adc_remove_devices);
>  	regulator_disable(info->vdd);
>  	clk_disable_unprepare(info->clk);
> +	clk_disable_unprepare(info->sclk);

Please disable clocks in the reverse of order in which they were enabled.

>  err_iio_dev:
>  	iio_device_unregister(indio_dev);
>  err_irq:
> @@ -373,6 +383,7 @@ static int exynos_adc_remove(struct platform_device *pdev)
>  				exynos_adc_remove_devices);
>  	regulator_disable(info->vdd);
>  	clk_disable_unprepare(info->clk);
> +	clk_disable_unprepare(info->sclk);

ditto

>  	writel(0, info->enable_reg);
>  	iio_device_unregister(indio_dev);
>  	free_irq(info->irq, info);
> @@ -398,6 +409,7 @@ static int exynos_adc_suspend(struct device *dev)
>  	}
>  
>  	clk_disable_unprepare(info->clk);
> +	clk_disable_unprepare(info->sclk);

ditto

>  	writel(0, info->enable_reg);
>  	regulator_disable(info->vdd);
>  
> @@ -416,6 +428,7 @@ static int exynos_adc_resume(struct device *dev)
>  
>  	writel(1, info->enable_reg);
>  	clk_prepare_enable(info->clk);
> +	clk_prepare_enable(info->sclk);
>  
>  	exynos_adc_hw_init(info);

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

