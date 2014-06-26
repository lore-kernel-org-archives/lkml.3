Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbaFZJEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 05:04:12 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40911 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011AbaFZJEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 05:04:08 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7fac6d000006cfe-e4-53abe200eeb4
Content-transfer-encoding: 8BIT
Message-id: <1403773439.27156.1.camel@AMDC1943>
Subject: Re: [PATCH v4 02/14] mfd: max77686: Allow the max77686 rtc to wakeup
 the system
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Jun 2014 11:03:59 +0200
In-reply-to: <1403723019-6212-3-git-send-email-javier.martinez@collabora.co.uk>
References: <1403723019-6212-1-git-send-email-javier.martinez@collabora.co.uk>
 <1403723019-6212-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e/4ZV2GR6uDDdavtbZYcvEqu8XUh0/Y
	LDb1b2W3mH/kHKvF2WUH2SyO/i6w6F1wlc3i/tejjBbfrnQwWWx6fI3V4vKuOWwWM87vY7J4
	OuEim8Wp65/ZLE53s1pMP/6W1aJv7SU2B0GP2Q0XWTz+Pr/O4rHj7hJGj52z7rJ7bFrVyeZx
	59oeNo95JwM9Ni+p97hyoonVo2/LKkaP6fN+Mnl83iQXwBPFZZOSmpNZllqkb5fAlXHkynLm
	giWCFZtW7GRrYPzK28XIySEhYCLR83YNK4QtJnHh3nq2LkYuDiGBpYwSrftWgCV4BQQlfky+
	x9LFyMHBLCAvceRSNkiYWUBdYtK8RcwQ9Z8ZJa71PWIEqeEV0JeYsTEFpEZYIEqie3InI4jN
	JmAssXn5EjYQW0TATuLG6odgvcwCj1gkHm35A1bEIqAqceffXyYQm1PAX+LsvnnsEAsmM0rM
	efQP6lJliXn7jzFNYBSYheS+WQj3zUJy3wJG5lWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsY
	IXH4ZQfj4mNWhxgFOBiVeHgl5q4OFmJNLCuuzD3EKMHBrCTC23kHKMSbklhZlVqUH19UmpNa
	fIiRiYNTqoFx07XOSTcXuKaHf59Tc+zX6j996//wVga035Kocz67pif9+u7/GZo5uXO1p5qp
	3m499aCNQb74sMn7R7O2ih6/L+kl/lJhzQn+iKdXblR0hV/ZpSyz8dnrqO0h9osUPzlesax/
	a7iegWlNxUarnRHvtL9GainrOW3i1Cv+9GGVmPnkvSveThHbosRSnJFoqMVcVJwIACXvPRGh	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-06-25 at 21:03 +0200, Javier Martinez Canillas wrote:
> From: Doug Anderson <dianders@chromium.org>
> 
> The max77686 includes an RTC that keeps power during suspend.  It's
> convenient to be able to use it as a wakeup source.
> 
> NOTE: due to wakeup ordering problems this patch alone doesn't work so
> well on exynos5250-snow.  You also need something that brings the i2c
> bus up before the max77686 wakeup runs.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
> 
> Changes since v3:
>  - Keep the note that this patch needs another change due wakeup
>    ordering problems.
> 
>  drivers/rtc/rtc-max77686.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


> diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
> index d20a7f0..c1c6055 100644
> --- a/drivers/rtc/rtc-max77686.c
> +++ b/drivers/rtc/rtc-max77686.c
> @@ -583,6 +583,33 @@ static void max77686_rtc_shutdown(struct platform_device *pdev)
>  #endif /* MAX77686_RTC_WTSR_SMPL */
>  }
>  
> +#ifdef CONFIG_PM_SLEEP
> +static int max77686_rtc_suspend(struct device *dev)
> +{
> +	if (device_may_wakeup(dev)) {
> +		struct max77686_rtc_info *info = dev_get_drvdata(dev);
> +
> +		return enable_irq_wake(info->virq);
> +	}
> +
> +	return 0;
> +}
> +
> +static int max77686_rtc_resume(struct device *dev)
> +{
> +	if (device_may_wakeup(dev)) {
> +		struct max77686_rtc_info *info = dev_get_drvdata(dev);
> +
> +		return disable_irq_wake(info->virq);
> +	}
> +
> +	return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(max77686_rtc_pm_ops,
> +			 max77686_rtc_suspend, max77686_rtc_resume);
> +
>  static const struct platform_device_id rtc_id[] = {
>  	{ "max77686-rtc", 0 },
>  	{},
> @@ -592,6 +619,7 @@ static struct platform_driver max77686_rtc_driver = {
>  	.driver		= {
>  		.name	= "max77686-rtc",
>  		.owner	= THIS_MODULE,
> +		.pm	= &max77686_rtc_pm_ops,
>  	},
>  	.probe		= max77686_rtc_probe,
>  	.shutdown	= max77686_rtc_shutdown,

