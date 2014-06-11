Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661AbaFKRLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:11:38 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63965 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaFKRLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:11:37 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53988DC1.7000203@roeck-us.net>
Date: Wed, 11 Jun 2014 10:11:29 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Heiko Schocher <hs@denx.de>, lm-sensors@lm-sensors.org
CC: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/13] hwmon: Driver for TI TMP103 temperature sensor
References: <1402468095-14678-1-git-send-email-hs@denx.de>
In-Reply-To: <1402468095-14678-1-git-send-email-hs@denx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 11:28 PM, Heiko Schocher wrote:
> Driver for the TI TMP103.
>
> The TI TMP103 is similar to the TMP102.  It differs from the TMP102
> by having only 8 bit registers.
>
> Signed-off-by: Heiko Schocher <hs@denx.de>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: linux-kernel@vger.kernel.org

Hi Heiko,

You don't need those Cc: in the header.

Why patch 09/13 ? I'd expect to see 12 more patches in this series,
but there is only one (even on kernel.org). If you sent those
other patches to various other mailing lists, everyone will wonder
where the remaining patches are. If there is just one patch,
it is just confusing.

> ---
>   Documentation/devicetree/bindings/hwmon/tmp103 |  30 +++
>   drivers/hwmon/Kconfig                          |  10 +
>   drivers/hwmon/Makefile                         |   1 +
>   drivers/hwmon/tmp103.c                         | 281 +++++++++++++++++++++++++
>   4 files changed, 322 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/hwmon/tmp103
>   create mode 100644 drivers/hwmon/tmp103.c
>
> diff --git a/Documentation/devicetree/bindings/hwmon/tmp103 b/Documentation/devicetree/bindings/hwmon/tmp103
> new file mode 100644
> index 0000000..36d7b36
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwmon/tmp103

Should be Documentation/hwmon/tmp103.

> @@ -0,0 +1,30 @@
> +Kernel driver tmp103
> +====================
> +
> +Supported chips:
> +  * Texas Instruments TMP103
> +    Prefix: 'tmp103'
> +    Addresses scanned: none
> +    Product info and datasheet: http://www.ti.com/product/tmp103
> +
> +Author:
> +	Heiko Schocher <hs@denx.de>
> +
> +Description
> +-----------
> +
> +The TMP103 is a digital output temperature sensor in a four-ball
> +wafer chip-scale package (WCSP). The TMP103 is capable of reading
> +temperatures to a resolution of 1°C. The TMP103 is specified for
> +operation over a temperature range of –40°C to +125°C.
> +
> +Resolution: 8 Bits
> +Accuracy: ±1°C Typ (–10°C to +100°C)
> +
> +The driver provides the common sysfs-interface for temperatures (see
> +Documentation/hwmon/sysfs-interface under Temperatures).
> +
> +Required node properties:
> +- compatible: manufacturer and chip name
> +		"ti,tmp103"
> +- reg: I2C bus address of the device

You don't need this part, and it is not really correct (there are
other ways to instantiate the device, devicetree is just one of them).

I would suggest to refer to Documentation/i2c/instantiating-devices
instead. It might also make sense to update
Documentation/devicetree/bindings/i2c/trivial-devices.txt.

Also, whenever you touch any of the the dt files, you need to copy
the DT maintainers. scripts/get_maintainer.pl will tell you who needs
to be copied.

> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 0034316..0f44dbb 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -1381,6 +1381,16 @@ config SENSORS_TMP102
>   	  This driver can also be built as a module.  If so, the module
>   	  will be called tmp102.
>
> +config SENSORS_TMP103
> +	tristate "Texas Instruments TMP103"
> +	depends on I2C
> +	help
> +	  If you say yes here you get support for Texas Instruments TMP103
> +	  sensor chips.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called tmp103.
> +
>   config SENSORS_TMP401
>   	tristate "Texas Instruments TMP401 and compatibles"
>   	depends on I2C
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 11798ad..8e2f6a2 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -134,6 +134,7 @@ obj-$(CONFIG_SENSORS_SMSC47M192)+= smsc47m192.o
>   obj-$(CONFIG_SENSORS_AMC6821)	+= amc6821.o
>   obj-$(CONFIG_SENSORS_THMC50)	+= thmc50.o
>   obj-$(CONFIG_SENSORS_TMP102)	+= tmp102.o
> +obj-$(CONFIG_SENSORS_TMP103)	+= tmp103.o
>   obj-$(CONFIG_SENSORS_TMP401)	+= tmp401.o
>   obj-$(CONFIG_SENSORS_TMP421)	+= tmp421.o
>   obj-$(CONFIG_SENSORS_TWL4030_MADC)+= twl4030-madc-hwmon.o
> diff --git a/drivers/hwmon/tmp103.c b/drivers/hwmon/tmp103.c
> new file mode 100644
> index 0000000..0bd33d6
> --- /dev/null
> +++ b/drivers/hwmon/tmp103.c
> @@ -0,0 +1,281 @@
> +/*
> + * Texas Instruments TMP103 SMBus temperature sensor driver
> + * Copyright (C) 2014 Heiko Schocher <hs@denx.de>
> + *
> + * Based on:
> + * Texas Instruments TMP102 SMBus temperature sensor driver
> + *
> + * Copyright (C) 2010 Steven King <sfking@fdwdc.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/err.h>
> +#include <linux/mutex.h>
> +#include <linux/device.h>
> +#include <linux/jiffies.h>
> +
> +#define	DRIVER_NAME "tmp103"
> +
> +#define	TMP103_TEMP_REG			0x00
> +#define	TMP103_CONF_REG			0x01
> +#define	TMP103_TLOW_REG			0x02
> +#define	TMP103_THIGH_REG		0x03
> +
> +#define		TMP103_CONF_M0		0x01
> +#define		TMP103_CONF_M1		0x02
> +#define		TMP103_CONF_LC		0x04
> +#define		TMP103_CONF_FL		0x08
> +#define		TMP103_CONF_FH		0x10
> +#define		TMP103_CONF_CR0		0x20
> +#define		TMP103_CONF_CR1		0x40
> +#define		TMP103_CONF_ID		0x80
> +#define		TMP103_CONF_SD		(TMP103_CONF_M0 | TMP103_CONF_M1)
> +
> +struct tmp103 {
> +	struct device *hwmon_dev;
> +	struct mutex lock;
> +	u16 config_orig;
> +	unsigned long last_update;
> +	int temp[3];
> +};
> +
> +static inline int tmp103_reg_to_mC(s8 val)
> +{
> +	return val * 1000;
> +}
> +
> +static inline u8 tmp103_mC_to_reg(int val)
> +{
> +	return val / 1000;

DIV_ROUND_CLOSEST() ?

No camelCase, please.

> +}
> +
> +static const u8 tmp103_reg[] = {
> +	TMP103_TEMP_REG,
> +	TMP103_TLOW_REG,
> +	TMP103_THIGH_REG,
> +};
> +
> +static struct tmp103 *tmp103_update_device(struct i2c_client *client)
> +{
> +	struct tmp103 *tmp103 = i2c_get_clientdata(client);
> +
> +	mutex_lock(&tmp103->lock);
> +	if (time_after(jiffies, tmp103->last_update + HZ / 3)) {
> +		int i;
> +
> +		for (i = 0; i < ARRAY_SIZE(tmp103->temp); ++i) {
> +			int status = i2c_smbus_read_byte_data(client,
> +							 tmp103_reg[i]);
> +			if (status > -1)
> +				tmp103->temp[i] = tmp103_reg_to_mC(status);

I understand this is from the tmp102 driver, but it is kind of unusual
because it does not report the error back to the user. Please consider
doing that, ie return PTR_ERR(status) on error and check/return the error
from the calling functions. Irrelevant if you use regmap (see below).

> +		}
> +		tmp103->last_update = jiffies;
> +	}
> +	mutex_unlock(&tmp103->lock);
> +	return tmp103;
> +}

Overall you might consider dropping the update function and using regmap instead.
It would be an excellent fit for this driver; while it doesn't do timed caching
it supports per-register caching which is ultimately more useful anyway.
Some of the drivers in the hwmon directory use it, so you could use that
as example. Not mandatory, though; just a suggestion.

> +
> +static ssize_t tmp103_show_temp(struct device *dev,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	struct sensor_device_attribute *sda = to_sensor_dev_attr(attr);
> +	struct tmp103 *tmp103 = tmp103_update_device(to_i2c_client(dev));
> +
> +	return sprintf(buf, "%d\n", tmp103->temp[sda->index]);
> +}
> +
> +static ssize_t tmp103_set_temp(struct device *dev,
> +			       struct device_attribute *attr,
> +			       const char *buf, size_t count)
> +{
> +	struct sensor_device_attribute *sda = to_sensor_dev_attr(attr);
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct tmp103 *tmp103 = i2c_get_clientdata(client);
> +	long val;
> +	int status;
> +
> +	if (kstrtol(buf, 10, &val) < 0)
> +		return -EINVAL;
> +	val = clamp_val(val, -55000, 128000);

Max should be 127000.

> +
> +	mutex_lock(&tmp103->lock);
> +	tmp103->temp[sda->index] = val;

You can not do that since it is the non-rounded value. You have to convert to
the register value, then convert back to the display value.

If you use regmap, the problem goes away, since you would not cache converted
data but convert in the show function. Alternatively, you could store register
values and convert in the show function.

> +	status = i2c_smbus_write_byte_data(client, tmp103_reg[sda->index],
> +					      tmp103_mC_to_reg(val));

Please make sure that continuation lines match the '(' in the line above.
Alignments are inconsistent, otherwise I would not mention it.
checkpatch --strict tells you which ones are misaligned.

> +	mutex_unlock(&tmp103->lock);
> +	return status ? : count;
> +}
> +
> +static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, tmp103_show_temp, NULL , 0);
> +
If you use regmap you can store the register directly here and you would not
need tmp103_reg[].

> +static SENSOR_DEVICE_ATTR(temp1_max_hyst, S_IWUSR | S_IRUGO, tmp103_show_temp,
> +			  tmp103_set_temp, 1);
> +
Per the datasheet this should be temp1_min. The register definition is different to TMP102.

> +static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, tmp103_show_temp,
> +			  tmp103_set_temp, 2);
> +
> +static struct attribute *tmp103_attributes[] = {
> +	&sensor_dev_attr_temp1_input.dev_attr.attr,
> +	&sensor_dev_attr_temp1_max_hyst.dev_attr.attr,
> +	&sensor_dev_attr_temp1_max.dev_attr.attr,

You might also consider adding temp1_min_alarm and temp1_max_alarm to inform
user space if limits are exceeded. The status is reported with the FL and FH
bits in the configuration register.

> +	NULL
> +};
> +
> +static const struct attribute_group tmp103_attr_group = {
> +	.attrs = tmp103_attributes,
> +};
> +
Please use the ATTRIBUTE_GROUPS() macro.

> +#define TMP103_CONFIG		(TMP103_CONF_CR1 | TMP103_CONF_M1)
> +#define TMP103_CONFIG_RD_ONLY	(TMP103_CONF_CR1 | TMP103_CONF_M1)

Latter define is not used as far as I can see. Since it is the same
it is unnecessary anyway.

> +
> +static int tmp103_probe(struct i2c_client *client,
> +				  const struct i2c_device_id *id)
> +{
> +	struct tmp103 *tmp103;
> +	int status;
> +
> +	if (!i2c_check_functionality(client->adapter,
> +				     I2C_FUNC_SMBUS_WORD_DATA)) {
> +		dev_err(&client->dev,
> +			"adapter doesn't support SMBus word transactions\n");

Good that the chip doesn't support any ;-). Check for byte transactions instead.

> +		return -ENODEV;
> +	}
> +
> +	tmp103 = devm_kzalloc(&client->dev, sizeof(*tmp103), GFP_KERNEL);
> +	if (!tmp103)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(client, tmp103);
> +
> +	status = i2c_smbus_read_byte_data(client, TMP103_CONF_REG);
> +	if (status < 0) {
> +		dev_err(&client->dev, "error reading config register\n");
> +		return status;
> +	}
> +	tmp103->config_orig = status;

You don't use config_orig outside the probe function,
so storing it in private data doesn't add any value.
Alternatively, you could restore the original configuration on exit.

> +	status = i2c_smbus_write_byte_data(client, TMP103_CONF_REG,
> +					      TMP103_CONFIG);
> +	if (status < 0) {
> +		dev_err(&client->dev, "error writing config register\n");
> +		goto fail_restore_config;
> +	}
> +	status = i2c_smbus_read_byte_data(client, TMP103_CONF_REG);
> +	if (status < 0) {
> +		dev_err(&client->dev, "error reading config register\n");
> +		goto fail_restore_config;
> +	}
> +	if (status != TMP103_CONFIG) {
> +		dev_err(&client->dev, "config settings did not stick\n");
> +		status = -ENODEV;
> +		goto fail_restore_config;
> +	}
> +	tmp103->last_update = jiffies - HZ;
> +	mutex_init(&tmp103->lock);
> +
> +	status = sysfs_create_group(&client->dev.kobj, &tmp103_attr_group);
> +	if (status) {
> +		dev_dbg(&client->dev, "could not create sysfs files\n");
> +		goto fail_restore_config;
> +	}
> +	tmp103->hwmon_dev = hwmon_device_register(&client->dev);
> +	if (IS_ERR(tmp103->hwmon_dev)) {
> +		dev_dbg(&client->dev, "unable to register hwmon device\n");
> +		status = PTR_ERR(tmp103->hwmon_dev);
> +		goto fail_remove_sysfs;
> +	}

Please use devm_hwmon_device_register_with_groups().

> +
> +	dev_info(&client->dev, "initialized\n");

Please drop this message.

> +
> +	return 0;
> +
> +fail_remove_sysfs:
> +	sysfs_remove_group(&client->dev.kobj, &tmp103_attr_group);
> +fail_restore_config:
> +	i2c_smbus_write_word_swapped(client, TMP103_CONF_REG,
> +				     tmp103->config_orig);

i2c_smbus_write_byte_data() ?

> +	return status;
> +}
> +
> +static int tmp103_remove(struct i2c_client *client)
> +{
> +	struct tmp103 *tmp103 = i2c_get_clientdata(client);
> +
> +	hwmon_device_unregister(tmp103->hwmon_dev);
> +	sysfs_remove_group(&client->dev.kobj, &tmp103_attr_group);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int tmp103_suspend(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	int config;
> +
> +	config = i2c_smbus_read_word_swapped(client, TMP103_CONF_REG);

byte

> +	if (config < 0)
> +		return config;
> +
> +	config &= ~TMP103_CONF_SD;
> +	return i2c_smbus_write_word_swapped(client, TMP103_CONF_REG, config);

byte

> +}
> +
> +static int tmp103_resume(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	int config;
> +
> +	config = i2c_smbus_read_word_swapped(client, TMP103_CONF_REG);

byte

> +	if (config < 0)
> +		return config;
> +
> +	config |= TMP103_CONF_SD;
> +	return i2c_smbus_write_word_swapped(client, TMP103_CONF_REG, config);

byte

> +}
> +
> +static const struct dev_pm_ops tmp103_dev_pm_ops = {
> +	.suspend	= tmp103_suspend,
> +	.resume		= tmp103_resume,
> +};
> +
> +#define TMP103_DEV_PM_OPS (&tmp103_dev_pm_ops)
> +#else
> +#define	TMP103_DEV_PM_OPS NULL
> +#endif /* CONFIG_PM */
> +
> +static const struct i2c_device_id tmp103_id[] = {
> +	{ DRIVER_NAME, 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, tmp103_id);
> +
> +static struct i2c_driver tmp103_driver = {
> +	.driver.name	= DRIVER_NAME,
> +	.driver.pm	= TMP103_DEV_PM_OPS,

	.driver = {
		.name	= DRIVER_NAME,
		.pm	= TMP103_DEV_PM_OPS,
	},

would be a bit nicer. I won't mandate it, though.

> +	.probe		= tmp103_probe,
> +	.remove		= tmp103_remove,
> +	.id_table	= tmp103_id,
> +};
> +
> +module_i2c_driver(tmp103_driver);
> +
> +MODULE_AUTHOR("Heiko Schocher <hs@denx.de>");
> +MODULE_DESCRIPTION("Texas Instruments TMP103 temperature sensor driver");
> +MODULE_LICENSE("GPL");
>

