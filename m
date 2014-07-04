Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbaGDLai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 07:30:38 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10937 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaGDLag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:30:36 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f626d000004b39-f2-53b69059440d
Content-transfer-encoding: 8BIT
Message-id: <1404473434.14069.10.camel@AMDC1943>
Subject: Re: [PATCH v6 17/23] mfd: max77686: Add Maxim 77802 PMIC support
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
Date: Fri, 04 Jul 2014 13:30:34 +0200
In-reply-to: <1404467722-26687-18-git-send-email-javier.martinez@collabora.co.uk>
References: <1404467722-26687-1-git-send-email-javier.martinez@collabora.co.uk>
 <1404467722-26687-18-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e/4Zd3ICduCDXb8k7NYcvEqu0XzpmKL
	qQ+fsFnMP3KO1eLssoNsFkd/F1j0LrjKZnH/61FGi29XOpgsNj2+xmpxedccNosZ5/cxWTyd
	cJHN4tT1z2wWfWsvsVlsmLyb3WLu70ZWB0GP2Q0XWTz+Pr/O4rHj7hJGj52z7rJ7bFrVyeZx
	59oeNo/NS+o9rpxoYvXo27KK0WPz6WqP6fN+Mnl83iQXwBPFZZOSmpNZllqkb5fAlTHv1H+W
	gj7Pio83GxkbGOdYdjFyckgImEisn/CHEcIWk7hwbz1bFyMXh5DAUkaJR8eus4EkeAUEJX5M
	vsfSxcjBwSwgL3HkUjZImFlAXWLSvEXMEPWfGSUOX3rADlFvINE7rQtsqLCAp8TyJfdYQWw2
	AWOJzcuXgM0UEbCTuLH6IVgzs8AtFolfyzeBFbEIqEpMfXkFrIhTIFhi7t5XjBAbpjFKTD52
	jgXiVGWJefuPMU1gFJiF5MBZCAfOQnLgAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxgh
	kfh1B+PSY1aHGAU4GJV4eBtatgULsSaWFVfmHmKU4GBWEuE90AcU4k1JrKxKLcqPLyrNSS0+
	xMjEwSnVwBgh9WHV1IorM9fGHA/3y8p2DnEu15nae7Q8Q0f6x4QpD7hXmFRn1E0/kLP/QKCV
	8Mmv/1Pi/U8zSUX+KPUUKA6InlG66UNe4UfnrU3RvFGM+xz7Ms69na0dZjtjLft67dfeTnkL
	PPgtn/8443hy1/pFK6Q5xEJCzYREk3cIerl5ahQ1iNr9UmIpzkg01GIuKk4EAKaHTOSiAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On pią, 2014-07-04 at 11:55 +0200, Javier Martinez Canillas wrote:
> Maxim MAX77802 is a power management chip that contains 10 high
> efficiency Buck regulators, 32 Low-dropout (LDO) regulators used
> to power up application processors and peripherals, a 2-channel
> 32kHz clock outputs, a Real-Time-Clock (RTC) and a I2C interface
> to program the individual regulators, clocks outputs and the RTC.
> 
> This patch adds support for MAX77802 to the MAX77686 driver and is
> based on a driver added to the Chrome OS kernel 3.8 by Simon Glass.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> ---
> 
>     NOTE: I didn't carry previous {Review,Acked,Tested}-by tags since
>     this patch extending MAX77686 is quite different than the old one
>     adding a new mfd driver. So review and test is highly appreciated.
> 
>     Changes since v5:
>      - Extend the 77686 driver to support 77802 instead of adding a new driver.
>        Suggested by Lee Jones.
> 
>     Changes since v4:
>      - Use consistent expressions when checking for NULL values.
>        Suggested by Krzysztof Kozlowski.
>      - Remove unused defines. Suggested by Krzysztof Kozlowski.
>      - Explain why IRQ is disabled on suspend. Suggested by Krzysztof Kozlowski.
> 
>     Changes since v3:
>      - Remove unnecessary OOM error message since the mm subsystem already logs it.
> 
>     Changes since v2:
>      - Split the DT binding docs in a separate patch and improve the documentation.
>        Suggested by Mark Brown.
>      - Add all the devices in the MFD driver instead of doing in separate patches.
>        Suggested by Mark Brown.
> 
>     Changes since v1:
>      - Convert max77{686,802} to regmap irq API and get rid of max77{686,802}-irq.c
>        Suggested by Krzysztof Kozlowski.
>      - Don't protect max77802 mfd_cells using Kconfig options since mfd core omits
>        devices that don't match. Suggested by Lee Jones.
>      - Change mfd driver to be tristate instead of boolean. Suggested by Mark Brown.
>      - Change binding "voltage-regulators" property to "regulators" to be consistent
>        with other PMIC drivers. Suggested by Mark Brown.
>      - Use regulators node names instead of the deprecated "regulator-compatible"
>        property. Suggested by Mark Brown.
>      - Use the new descriptor-based GPIO interface instead of the deprecated
> ---
>  drivers/mfd/Kconfig                  |   6 +-
>  drivers/mfd/max77686.c               | 187 ++++++++++++++++++++++++++-----
>  include/linux/mfd/max77686-private.h | 208 ++++++++++++++++++++++++++++++++++-
>  include/linux/mfd/max77686.h         |  60 +++++++++-
>  4 files changed, 428 insertions(+), 33 deletions(-)
> 

Three comments below, after fixing:
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

(...)

> @@ -55,6 +123,17 @@ static struct regmap_config max77686_rtc_regmap_config = {
>  	.val_bits = 8,
>  };
>  
> +static struct regmap_config max77802_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.writeable_reg = max77802_is_accessible_reg,
> +	.readable_reg = max77802_is_accessible_reg,
> +	.precious_reg = max77802_is_precious_reg,
> +	.volatile_reg = max77802_is_volatile_reg,
> +	.name = "max77802-pmic",
> +	.cache_type = REGCACHE_RBTREE,
> +};
> +
>  static const struct regmap_irq max77686_irqs[] = {
>  	/* INT1 interrupts */
>  	{ .reg_offset = 0, .mask = MAX77686_INT1_PWRONF_MSK, },
> @@ -98,9 +177,34 @@ static const struct regmap_irq_chip max77686_rtc_irq_chip = {
>  	.num_irqs		= ARRAY_SIZE(max77686_rtc_irqs),
>  };
>  
> +static const struct regmap_irq_chip max77802_irq_chip = {
> +	.name			= "max77802-pmic",
> +	.status_base		= MAX77802_REG_INT1,
> +	.mask_base		= MAX77802_REG_INT1MSK,
> +	.num_regs		= 2,
> +	.irqs			= max77686_irqs, /* same masks than 77686 */

"same masks as 77686"

> +	.num_irqs		= ARRAY_SIZE(max77686_irqs),
> +};
> +
> +static const struct regmap_irq_chip max77802_rtc_irq_chip = {
> +	.name			= "max77802-rtc",
> +	.status_base		= MAX77802_RTC_INT,
> +	.mask_base		= MAX77802_RTC_INTM,
> +	.num_regs		= 1,
> +	.irqs			= max77686_rtc_irqs, /* same masks than 77686 */

Ditto

> +	.num_irqs		= ARRAY_SIZE(max77686_rtc_irqs),
> +};
> +
>  static const struct of_device_id max77686_pmic_dt_match[] = {
> -	{.compatible = "maxim,max77686", .data = NULL},
> -	{},
> +	{
> +		.compatible = "maxim,max77686",
> +		.data = (void *)TYPE_MAX77686,
> +	},
> +	{
> +		.compatible = "maxim,max77802",
> +		.data = (void *)TYPE_MAX77802,
> +	},
> +	{ },
>  };
>  
>  static void max77686_dt_parse_dvs_gpio(struct device *dev)
> @@ -236,6 +340,12 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
>  	struct max77686_platform_data *pdata = dev_get_platdata(&i2c->dev);
>  	unsigned int data;
>  	int ret = 0;
> +	const struct regmap_config *config;
> +	const struct regmap_irq_chip *irq_chip;
> +	const struct regmap_irq_chip *rtc_irq_chip;
> +	struct regmap **rtc_regmap;
> +	const struct mfd_cell *cells;
> +	int n_devs;
>  
>  	if (IS_ENABLED(CONFIG_OF) && i2c->dev.of_node && !pdata)
>  		pdata = max77686_i2c_parse_dt_pdata(&i2c->dev);
> @@ -258,56 +368,77 @@ static int max77686_i2c_probe(struct i2c_client *i2c,
>  	max77686->wakeup = pdata->wakeup;
>  	max77686->irq = i2c->irq;
>  
> -	max77686->regmap = devm_regmap_init_i2c(i2c, &max77686_regmap_config);
> +	if (max77686->type == TYPE_MAX77686) {
> +		config = &max77686_regmap_config;
> +		irq_chip = &max77686_irq_chip;
> +		rtc_irq_chip = &max77686_rtc_irq_chip;
> +		rtc_regmap = &max77686->rtc_regmap;
> +		cells =  max77686_devs;
> +		n_devs = ARRAY_SIZE(max77686_devs);
> +	} else {
> +		config = &max77802_regmap_config;
> +		irq_chip = &max77802_irq_chip;
> +		rtc_irq_chip = &max77802_rtc_irq_chip;
> +		rtc_regmap = &max77686->regmap;
> +		cells =  max77802_devs;
> +		n_devs = ARRAY_SIZE(max77802_devs);
> +	}
> +
> +	max77686->regmap = devm_regmap_init_i2c(i2c, config);
>  	if (IS_ERR(max77686->regmap)) {
>  		ret = PTR_ERR(max77686->regmap);
>  		dev_err(max77686->dev, "Failed to allocate register map: %d\n",
> -				ret);
> +			ret);
>  		return ret;
>  	}
>  
>  	ret = regmap_read(max77686->regmap, MAX77686_REG_DEVICE_ID, &data);
>  	if (ret < 0) {
>  		dev_err(max77686->dev,
> -			"device not found on this channel (this is not an error)\n");
> -		return -ENODEV;
> -	}
> -
> -	max77686->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
> -	if (!max77686->rtc) {
> -		dev_err(max77686->dev, "Failed to allocate I2C device for RTC\n");
> +			"device not found on this channel\n");
>  		return -ENODEV;
>  	}
> -	i2c_set_clientdata(max77686->rtc, max77686);
>  
> -	max77686->rtc_regmap = devm_regmap_init_i2c(max77686->rtc,
> -						    &max77686_rtc_regmap_config);
> -	if (IS_ERR(max77686->rtc_regmap)) {
> -		ret = PTR_ERR(max77686->rtc_regmap);
> -		dev_err(max77686->dev, "failed to allocate RTC regmap: %d\n",
> -			ret);
> -		goto err_unregister_i2c;
> +	if (max77686->type == TYPE_MAX77686) {
> +		max77686->rtc = i2c_new_dummy(i2c->adapter, I2C_ADDR_RTC);
> +		if (!max77686->rtc) {
> +			dev_err(max77686->dev,
> +				"Failed to allocate I2C device for RTC\n");
> +			return -ENODEV;
> +		}
> +		i2c_set_clientdata(max77686->rtc, max77686);
> +
> +		max77686->rtc_regmap =
> +			devm_regmap_init_i2c(max77686->rtc,
> +					     &max77686_rtc_regmap_config);
> +		if (IS_ERR(max77686->rtc_regmap)) {
> +			ret = PTR_ERR(max77686->rtc_regmap);
> +			dev_err(max77686->dev,
> +				"failed to allocate RTC regmap: %d\n",
> +				ret);
> +			goto err_unregister_i2c;
> +		}
>  	}
>  
>  	ret = regmap_add_irq_chip(max77686->regmap, max77686->irq,
>  				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
> -				  IRQF_SHARED, 0, &max77686_irq_chip,
> +				  IRQF_SHARED, 0, irq_chip,
>  				  &max77686->irq_data);
>  	if (ret) {
>  		dev_err(&i2c->dev, "failed to add PMIC irq chip: %d\n", ret);
>  		goto err_unregister_i2c;
>  	}
> -	ret = regmap_add_irq_chip(max77686->rtc_regmap, max77686->irq,
> +
> +	ret = regmap_add_irq_chip(*rtc_regmap, max77686->irq,
>  				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
> -				  IRQF_SHARED, 0, &max77686_rtc_irq_chip,
> +				  IRQF_SHARED, 0, rtc_irq_chip,
>  				  &max77686->rtc_irq_data);
>  	if (ret) {
>  		dev_err(&i2c->dev, "failed to add RTC irq chip: %d\n", ret);
>  		goto err_del_irqc;
>  	}
>  
> -	ret = mfd_add_devices(max77686->dev, -1, max77686_devs,
> -			      ARRAY_SIZE(max77686_devs), NULL, 0, NULL);
> +	ret = mfd_add_devices(max77686->dev, -1, cells, n_devs, NULL, 0, NULL);
>  	if (ret < 0) {
>  		dev_err(&i2c->dev, "failed to add MFD devices: %d\n", ret);
>  		goto err_del_rtc_irqc;
> @@ -320,7 +451,8 @@ err_del_rtc_irqc:
>  err_del_irqc:
>  	regmap_del_irq_chip(max77686->irq, max77686->irq_data);
>  err_unregister_i2c:
> -	i2c_unregister_device(max77686->rtc);
> +	if (max77686->type == TYPE_MAX77686)
> +		i2c_unregister_device(max77686->rtc);
>  
>  	return ret;
>  }
> @@ -341,6 +473,7 @@ static int max77686_i2c_remove(struct i2c_client *i2c)

In remove() you should unregister dummy RTC I2C device only on MAX77686
(77802 does not add it).

Best regards,
Krzysztof



