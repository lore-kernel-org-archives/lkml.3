Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbaIVRqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:46:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:32706 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbaIVRqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:46:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="389889621"
Date: Mon, 22 Sep 2014 10:46:02 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v4 2/3] iio/adc: add support for axp288 adc
Message-ID: <20140922104602.0e16b50a@ultegra>
In-Reply-To: <541ECF29.8060006@kernel.org>
References: <1410912715-25903-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1410912715-25903-3-git-send-email-jacob.jun.pan@linux.intel.com>
	<541ECF29.8060006@kernel.org>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Sep 2014 14:14:17 +0100
Jonathan Cameron <jic23@kernel.org> wrote:

> On 17/09/14 01:11, Jacob Pan wrote:
> > Platform driver for X-Powers AXP288 ADC, which is a sub-device of
> > the customized AXP288 PMIC for Intel Baytrail-CR platforms. GPADC
> > device enumerates as one of the MFD cell devices. It uses IIO
> > infrastructure to communicate with userspace and consumer drivers.
> >
> > Usages of ADC channels include battery charging and thermal sensors.
> >
> > Based on initial work by:
> > Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> >
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> A few more bits from me...
> 
> Jonathan
> > ---
> >  drivers/iio/adc/Kconfig      |   8 ++
> >  drivers/iio/adc/Makefile     |   1 +
> >  drivers/iio/adc/axp288_adc.c | 254
> > +++++++++++++++++++++++++++++++++++++++++++ 3 files changed, 263
> > insertions(+) create mode 100644 drivers/iio/adc/axp288_adc.c
> >
> > diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> > index 11b048a..db2681b 100644
> > --- a/drivers/iio/adc/Kconfig
> > +++ b/drivers/iio/adc/Kconfig
> > @@ -127,6 +127,14 @@ config AT91_ADC
> >  	help
> >  	  Say yes here to build support for Atmel AT91 ADC.
> >
> > +config AXP288_ADC
> > +	tristate "X-Powers AXP288 ADC driver"
> > +	depends on MFD_AXP20X
> > +	help
> > +	  Say yes here to have support for X-Powers power
> > management IC (PMIC) ADC
> > +	  device. Depending on platform configuration, this
> > general purpose ADC can
> > +	  be used for sampling sensors such as thermal resistors.
> > +
> >  config EXYNOS_ADC
> >  	tristate "Exynos ADC driver support"
> >  	depends on ARCH_EXYNOS || (OF && COMPILE_TEST)
> > diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
> > index ad81b51..19640f9 100644
> > --- a/drivers/iio/adc/Makefile
> > +++ b/drivers/iio/adc/Makefile
> > @@ -14,6 +14,7 @@ obj-$(CONFIG_AD7793) += ad7793.o
> >  obj-$(CONFIG_AD7887) += ad7887.o
> >  obj-$(CONFIG_AD799X) += ad799x.o
> >  obj-$(CONFIG_AT91_ADC) += at91_adc.o
> > +obj-$(CONFIG_AXP288_ADC) += axp288_adc.o
> >  obj-$(CONFIG_EXYNOS_ADC) += exynos_adc.o
> >  obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
> >  obj-$(CONFIG_MAX1027) += max1027.o
> > diff --git a/drivers/iio/adc/axp288_adc.c
> > b/drivers/iio/adc/axp288_adc.c new file mode 100644
> > index 0000000..333c624
> > --- /dev/null
> > +++ b/drivers/iio/adc/axp288_adc.c
> > @@ -0,0 +1,254 @@
> > +/*
> > + * axp288_adc.c - X-Powers AXP288 PMIC ADC Driver
> > + *
> > + * Copyright (C) 2014 Intel Corporation
> > + *
> > + *
> > ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > + *
> > + * This program is free software; you can redistribute it and/or
> > modify
> > + * it under the terms of the GNU General Public License as
> > published by
> > + * the Free Software Foundation; version 2 of the License.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See
> > the GNU
> > + * General Public License for more details.
> > + *
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/device.h>
> > +#include <linux/regmap.h>
> > +#include <linux/mfd/axp20x.h>
> > +#include <linux/platform_device.h>
> > +
> > +#include <linux/iio/iio.h>
> > +#include <linux/iio/machine.h>
> > +#include <linux/iio/driver.h>
> > +
> > +#define AXP288_ADC_EN_MASK		0xF1
> > +#define AXP288_ADC_TS_PIN_GPADC		0xF2
> > +#define AXP288_ADC_TS_PIN_ON		0xF3
> > +
> > +enum axp288_adc_id {
> > +	AXP288_ADC_TS,
> > +	AXP288_ADC_PMIC,
> > +	AXP288_ADC_GP,
> > +	AXP288_ADC_BATT_CHRG_I,
> > +	AXP288_ADC_BATT_DISCHRG_I,
> > +	AXP288_ADC_BATT_V,
> > +	AXP288_ADC_NR_CHAN,
> > +};
> > +
> > +struct axp288_adc_info {
> > +	int irq;
> > +	struct device *dev;
> Is the dev element ever used?
> 
> > +	struct regmap *regmap;
> > +};
> > +
> > +static const struct iio_chan_spec const axp288_adc_channels[] = {
> > +	{
> > +		.indexed = 1,
> > +		.type = IIO_TEMP,
> > +		.channel = 0,
> > +		.address = AXP288_TS_ADC_H,
> > +		.datasheet_name = "CH0",
> > +	}, {
> > +		.indexed = 1,
> > +		.type = IIO_TEMP,
> > +		.channel = 1,
> > +		.address = AXP288_PMIC_ADC_H,
> > +		.datasheet_name = "CH1",
> > +	}, {
> > +		.indexed = 1,
> > +		.type = IIO_TEMP,
> > +		.channel = 2,
> > +		.address = AXP288_GP_ADC_H,
> > +		.datasheet_name = "CH2",
> > +	}, {
> > +		.indexed = 1,
> > +		.type = IIO_CURRENT,
> > +		.channel = 3,
> > +		.address = AXP20X_BATT_CHRG_I_H,
> > +		.datasheet_name = "CH3",
> > +		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
> > +	}, {
> > +		.indexed = 1,
> > +		.type = IIO_CURRENT,
> > +		.channel = 4,
> > +		.address = AXP20X_BATT_DISCHRG_I_H,
> > +		.datasheet_name = "CH4",
> > +		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
> > +	}, {
> > +		.indexed = 1,
> > +		.type = IIO_VOLTAGE,
> > +		.channel = 5,
> > +		.address = AXP20X_BATT_V_H,
> > +		.datasheet_name = "CH5",
> > +		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
> > +	},
> > +};
> > +
> > +#define AXP288_ADC_MAP(_adc_channel_label,
> > _consumer_dev_name,	\
> > +		_consumer_channel)				\
> > +	{							\
> > +		.adc_channel_label = _adc_channel_label,	\
> > +		.consumer_dev_name = _consumer_dev_name,	\
> > +		.consumer_channel =
> > _consumer_channel,		\
> > +	}
> > +
> > +/* for consumer drivers */
> > +static struct iio_map axp288_adc_default_maps[] = {
> > +	AXP288_ADC_MAP("TS_PIN", "axp288-batt",
> > "axp288-batt-temp"),
> > +	AXP288_ADC_MAP("PMIC_TEMP", "axp288-pmic",
> > "axp288-pmic-temp"),
> > +	AXP288_ADC_MAP("GPADC", "axp288-gpadc",
> > "axp288-system-temp"),
> > +	AXP288_ADC_MAP("BATT_CHG_I", "axp288-chrg",
> > "axp288-chrg-curr"),
> > +	AXP288_ADC_MAP("BATT_DISCHRG_I", "axp288-chrg",
> > "axp288-chrg-d-curr"),
> > +	AXP288_ADC_MAP("BATT_V", "axp288-batt",
> > "axp288-batt-volt"),
> > +	{},
> > +};
> > +
> > +static int axp288_adc_read_raw(struct iio_dev *indio_dev,
> > +			struct iio_chan_spec const *chan,
> > +			int *val, int *val2, long mask)
> > +{
> > +	int ret;
> > +	struct axp288_adc_info *info = iio_priv(indio_dev);
> > +	u8 buf[2];
> > +
> > +	mutex_lock(&indio_dev->mlock);
> > +	switch (mask) {
> > +	case IIO_CHAN_INFO_RAW:
> > +		/* special case for GPADC sample */
> > +		if (chan->address == AXP288_GP_ADC_H) {
> > +			ret = regmap_write(info->regmap,
> > AXP288_ADC_TS_PIN_CTRL,
> > +					AXP288_ADC_TS_PIN_GPADC);
> > +			if (ret) {
> > +				dev_err(&indio_dev->dev, "GPADC
> > mode\n");
> > +				mutex_unlock(&indio_dev->mlock);
> > +				return ret;
> > +			}
> > +		}
> > +	case IIO_CHAN_INFO_PROCESSED:
> > +		ret = regmap_bulk_read(info->regmap,
> > chan->address, buf, 2);
> > +		if (ret) {
> > +			dev_err(&indio_dev->dev, "sample raw data
> > failed\n");
> > +			break;
> > +		}
> > +		*val = (buf[0] << 4) + ((buf[1] >> 4) & 0x0F);
> > +		ret = IIO_VAL_INT;
> > +		break;
> > +	default:

> > +		ret = -EINVAL;
> > +	}
> > +
> Why is this statement down here rather than in the relevant case entry
> above?

I think you meant the line below, why I need to check the same
conditions again for INFO_RAW. The reason is that the regmap_write()
call is preparing a valid mode for the regmap_bulk_read below. I could
move the statement in the case statement and duplicate the
regmap_bulk_read() such that INFO_RAW and INFO_PROCESSED has its own
break statement. That should make a code more readable but with
duplicated code.


> > +	if (mask == IIO_CHAN_INFO_RAW && chan->address ==
> > AXP288_GP_ADC_H)
> > +		ret = regmap_write(info->regmap,
> > AXP288_ADC_TS_PIN_CTRL,
> > +			AXP288_ADC_TS_PIN_ON);
> > +
> > +	mutex_unlock(&indio_dev->mlock);
> > +
> > +	return ret;
> > +}
> > +
> > +static int axp288_adc_enable(struct regmap *regmap, bool enable)
> It's fussy, but axp288_adc_set_state or similar would be slightly
> less confusing as enable with a parameter of false, just means
> don't enable, not disable as i would imagine you intend...
agreed.
> 
> > +{
> > +	unsigned int pin_on, adc_en;
> > +
> > +	if (enable) {
> > +		pin_on = AXP288_ADC_TS_PIN_ON;
> > +		adc_en = AXP288_ADC_EN_MASK;
> > +	} else {
> > +		pin_on = ~AXP288_ADC_TS_PIN_ON;
> > +		adc_en = ~AXP288_ADC_EN_MASK;
> > +	}
> > +	if (regmap_write(regmap, AXP288_ADC_TS_PIN_CTRL, pin_on))
> > +		return -EIO;
> > +
> > +	return regmap_write(regmap, AXP20X_ADC_EN1,
> > ~AXP288_ADC_EN_MASK); +}
> > +
> > +static const struct iio_info axp288_adc_iio_info = {
> > +	.read_raw = &axp288_adc_read_raw,
> > +	.driver_module = THIS_MODULE,
> > +};
> > +
> > +static int axp288_adc_probe(struct platform_device *pdev)
> > +{
> > +	int ret;
> > +	struct axp288_adc_info *info;
> > +	struct iio_dev *indio_dev;
> > +	struct axp20x_dev *axp20x =
> > dev_get_drvdata(pdev->dev.parent); +
> > +	indio_dev = devm_iio_device_alloc(&pdev->dev,
> > sizeof(*info));
> > +	if (!indio_dev)
> > +		return -ENOMEM;
> > +
> > +	info = iio_priv(indio_dev);
> > +	info->irq = platform_get_irq(pdev, 0);
> > +	if (info->irq < 0) {
> > +		dev_err(&pdev->dev, "no irq resource?\n");
> > +		return info->irq;
> > +	}
> > +	platform_set_drvdata(pdev, indio_dev);
> > +	info->regmap = axp20x->regmap;
> > +	ret = axp288_adc_enable(axp20x->regmap, true);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Unable to enable ADC
> > device\n");
> > +		return ret;
> > +	}
> > +
> > +	indio_dev->dev.parent = &pdev->dev;
> > +	indio_dev->name = pdev->name;
> > +	indio_dev->channels = axp288_adc_channels;
> > +	indio_dev->num_channels = ARRAY_SIZE(axp288_adc_channels);
> > +	indio_dev->info = &axp288_adc_iio_info;
> > +	indio_dev->modes = INDIO_DIRECT_MODE;
> > +	ret = iio_map_array_register(indio_dev,
> > axp288_adc_default_maps);
> > +	if (ret < 0)
> > +		goto err_disable_dev;
> > +
> > +	ret = iio_device_register(indio_dev);
> > +	if (ret < 0) {
> > +		dev_err(&pdev->dev, "unable to register iio
> > device\n");
> > +		goto err_array_unregister;
> > +	}
> > +
> > +	return 0;
> > +
> > +err_array_unregister:
> > +	iio_map_array_unregister(indio_dev);
> > +err_disable_dev:
> > +	ret = axp288_adc_enable(axp20x->regmap, false);
> > +
> > +	return ret;
> > +}
> > +
> > +static int axp288_adc_remove(struct platform_device *pdev)
> > +{
> > +	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
> > +	struct axp20x_dev *axp20x =
> > dev_get_drvdata(pdev->dev.parent);
> Would feel a little more consistent to get the regmap from
> info->regmap, but doesn't really matter I suppose...
> > +
> > +	if (axp288_adc_enable(axp20x->regmap, false))
> > +		dev_err(&pdev->dev, "Unable to disable ADC
> > device\n");
> > +	iio_device_unregister(indio_dev);
> > +	iio_map_array_unregister(indio_dev);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver axp288_adc_driver = {
> > +	.probe = axp288_adc_probe,
> > +	.remove = axp288_adc_remove,
> > +	.driver = {
> > +		.name = "axp288_adc",
> > +		.owner = THIS_MODULE,
> > +	},
> > +};
> > +
> > +module_platform_driver(axp288_adc_driver);
> > +
> > +MODULE_AUTHOR("Jacob Pan <jacob.jun.pan@linux.intel.com>");
> > +MODULE_DESCRIPTION("X-Powers AXP288 ADC Driver");
> > +MODULE_LICENSE("GPL");
> >

[Jacob Pan]
