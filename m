Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbaGDLPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:15:15 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56543 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbaGDLPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:15:12 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f626d000004b39-8a-53b68cbd90d4
Content-transfer-encoding: 8BIT
Message-id: <1404472510.14069.6.camel@AMDC1943>
Subject: Re: [PATCH v6 08/23] mfd: max77686: Add Dynamic Voltage Scaling (DVS)
 support
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Tushar Behera <trblinux@gmail.com>, Andreas Farber <afaerber@suse.de>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 04 Jul 2014 13:15:10 +0200
In-reply-to: <1404467722-26687-9-git-send-email-javier.martinez@collabora.co.uk>
References: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
 <1404467722-26687-9-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42I5/e/4Zd29PduCDe53cVosuXiV3aJ5U7HF
	1IdP2CzmHznHanF22UE2i6O/Cyx6F1xls7j/9SijxbcrHUwWmx5fY7W4vGsOm8WM8/uYLJ5O
	uMhmcer6ZzaLvrWX2Cw2TN7NbjH3dyOrg6DH7IaLLB5/n19n8dhxdwmjx85Zd9k9Nq3qZPO4
	c20Pm8fmJfUeV040sXr0bVnF6LH5dLXH9Hk/mTw+b5IL4InisklJzcksSy3St0vgyrh76j1T
	wSHliotnVrE0MP6S7mLk5JAQMJF48K+TBcIWk7hwbz1bFyMXh5DAUkaJZ41bwBK8AoISPybf
	A7I5OJgF5CWOXMoGCTMLqEtMmreIGaL+M6PE2a4ZrBD1+hLv5nwC6xUWiJBYM+kFG4jNJmAs
	sXn5EjBbRMBO4sbqh2DNzAK3WCR+Ld8E1swioCqxeNVKJhCbUyBAonXmG7AGIYGpjBL3+mIh
	LlWWmLf/GNMERoFZSO6bhXDfLCT3LWBkXsUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREodf
	dzAuPWZ1iFGAg1GJh7ehZVuwEGtiWXFl7iFGCQ5mJRFe7i6gEG9KYmVValF+fFFpTmrxIUYm
	Dk6pBsaFTe1lk7KrmefVdktl7WD99vnyj7sTf5u7eVtJXw9bvz8pIf1FP8vcdfzv901kde6Z
	oOa98rbeqgv2OjKvXWQtuM7+7+wpz+fifrxoh99+0b1tOt5eVQ9v3NHqP6uze/q7v4KZd6y3
	cnyRutr09nC6Xj+XYkSPwMfvX53XMhXG6enutp8aXKHEUpyRaKjFXFScCACobK25oQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-07-04 at 11:55 +0200, Javier Martinez Canillas wrote:
> Some regulators on the MAX77686 PMIC have Dynamic Voltage Scaling
> (DVS) support that allows output voltage to change dynamically.
> 
> For MAX77686, these regulators are Buck regulators 2, 3 and 4.
> 
> Each Buck output voltage is selected using a set of external
> inputs: DVS1-3 and SELB2-4.
> 
> DVS registers can be used to configure the output voltages for each
> Buck regulator and which one is active is controled by DVSx lines.
> 
> SELBx lines are used to control if individual Buck lines are ON or OFF.
> 
> This patch adds support to configure the DVSx and SELBx lines
> from DT and to setup and read the GPIO lines connected to them.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
>  drivers/mfd/max77686.c       | 115 +++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/max77686.h |  18 ++++---
>  2 files changed, 125 insertions(+), 8 deletions(-)

One minor comment below, but overall looks good to me:
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>


> diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
> index 8650832..648d564 100644
> --- a/drivers/mfd/max77686.c
> +++ b/drivers/mfd/max77686.c
> @@ -32,8 +32,10 @@
>  #include <linux/mfd/core.h>
>  #include <linux/mfd/max77686.h>
>  #include <linux/mfd/max77686-private.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/err.h>
>  #include <linux/of.h>
> +#include <linux/export.h>
>  
>  #define I2C_ADDR_RTC	(0x0C >> 1)
>  
> @@ -101,9 +103,115 @@ static const struct of_device_id max77686_pmic_dt_match[] = {
>  	{},
>  };
>  
> +static void max77686_dt_parse_dvs_gpio(struct device *dev)
> +{
> +	struct max77686_platform_data *pd = dev_get_platdata(dev);
> +	int i;
> +
> +	/*
> +	 * NOTE: we don't consider GPIO errors fatal; board may have some lines
> +	 * directly pulled high or low and thus doesn't specify them.
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_dvs); i++)
> +		pd->buck_gpio_dvs[i] =
> +			devm_gpiod_get_index(dev, "max77686,pmic-buck-dvs", i);
> +
> +	for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_selb); i++)
> +		pd->buck_gpio_selb[i] =
> +			devm_gpiod_get_index(dev, "max77686,pmic-buck-selb", i);
> +}
> +
> +/**
> + * max77686_setup_gpios - init DVS-related GPIOs
> + *
> + * This function claims / initalizations GPIOs related to DVS if they are
> + * defined. This may have the effect of switching voltages if the
> + * pdata->buck_default_idx does not match the boot time state of pins.
> + */
> +int max77686_setup_gpios(struct device *dev)
> +{
> +	struct max77686_platform_data *pd = dev_get_platdata(dev);
> +	int buck_default_idx = pd->buck_default_idx;
> +	int ret;
> +	int i;
> +
> +	/* Set all SELB high to avoid glitching while DVS is changing */
> +	for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_selb); i++) {
> +		struct gpio_desc *gpio = pd->buck_gpio_selb[i];
> +
> +		/* OK if some GPIOs aren't defined */
> +		if (IS_ERR(gpio))
> +			continue;
> +
> +		ret = gpiod_direction_output_raw(gpio, 1);
> +		if (ret) {
> +			dev_err(dev, "can't set gpio[%d] dir: %d\n", i, ret);
> +			return ret;
> +		}
> +	}
> +
> +	/* Set our initial setting */
> +	for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_dvs); i++) {
> +		struct gpio_desc *gpio = pd->buck_gpio_dvs[i];
> +
> +		/* OK if some GPIOs aren't defined */
> +		if (IS_ERR(gpio))
> +			continue;
> +
> +		/* If a GPIO is valid, set it */
> +		gpiod_direction_output(gpio, (buck_default_idx >> i) & 1);
> +		if (ret) {
> +			dev_err(dev, "can't set gpio[%d]: dir %d\n", i, ret);
> +			return ret;
> +		}
> +	}
> +
> +	/* Now set SELB low to take effect */
> +	for (i = 0; i < ARRAY_SIZE(pd->buck_gpio_selb); i++) {
> +		struct gpio_desc *gpio = pd->buck_gpio_selb[i];
> +
> +		if (!IS_ERR(gpio))
> +			gpiod_set_value(gpio, 0);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(max77686_setup_gpios);
> +
> +/**
> + * max77686_read_gpios - read the current state of the dvs GPIOs
> + *
> + * We call this function at bootup to detect what slot the firmware was
> + * using for the DVS GPIOs.  That way we can properly preserve the firmware's
> + * voltage settings
> + */
> +int max77686_read_gpios(struct max77686_platform_data *pdata)
> +{

Can you document that this function can sleep? It is quite obvious but
the function is exported so maybe it is worth noting.

Best regards,
Krzysztof



