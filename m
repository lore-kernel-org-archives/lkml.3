Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855AbaKMUAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:00:34 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58105 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933146AbaKMUAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:00:33 -0500
Message-ID: <54650DD6.1010000@ti.com>
Date: Thu, 13 Nov 2014 14:00:22 -0600
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bryan Wu <cooloney@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Subject: Re: [PATCH] leds: lp8860: Introduce TI lp8860 4 channel LED driver
References: <1415882116-4115-1-git-send-email-dmurphy@ti.com> <CAK5ve-+Xf=8d241H9uVUe2G1NqqDfpTtkkJ0FFmFcF-deSVfzA@mail.gmail.com>
In-Reply-To: <CAK5ve-+Xf=8d241H9uVUe2G1NqqDfpTtkkJ0FFmFcF-deSVfzA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan
Thanks for the review

On 11/13/2014 01:43 PM, Bryan Wu wrote:
> On Thu, Nov 13, 2014 at 4:35 AM, Dan Murphy <dmurphy@ti.com> wrote:
>> Introduce the Texas Instruments lp8860
>> 4 channel LED driver.
>>
>> This driver configures the device in display custer mode
> custer or cluster?

Ooops cluster it is.

>
>> as this seems to be the most used configuration at the
>> time of the driver configuration.
>>
>> For more product information please see the link below:
>> http://www.ti.com/product/lp8860-q1
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>  .../devicetree/bindings/leds/leds-lp8860.txt       |  29 ++
>>  drivers/leds/Kconfig                               |  10 +
>>  drivers/leds/Makefile                              |   1 +
>>  drivers/leds/leds-lp8860.c                         | 491 +++++++++++++++++++++
>>  4 files changed, 531 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/leds/leds-lp8860.txt
>>  create mode 100644 drivers/leds/leds-lp8860.c
>>
>> diff --git a/Documentation/devicetree/bindings/leds/leds-lp8860.txt b/Documentation/devicetree/bindings/leds/leds-lp8860.txt
>> new file mode 100644
>> index 0000000..aad38dd
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/leds/leds-lp8860.txt
>> @@ -0,0 +1,29 @@
>> +* Texas Instruments - lp8860 4-Channel LED Driver
>> +
>> +The LP8860-Q1 is an high-efficiency LED
>> +driver with boost controller. It has 4 high-precision
>> +current sinks that can be controlled by a PWM input
>> +signal, a SPI/I2C master, or both.
>> +
>> +Required properties:
>> +       - compatible:
>> +               "ti,lp8860"
>> +       - reg -  I2C slave address
>> +       - label - Used for naming LEDs
>> +
>> +Optional properties:
>> +       - enable-gpio - gpio pin to enable/disable the device.
>> +       - supply - "vled" - LED supply
>> +
>> +Example:
>> +
>> +leds: leds@6 {
>> +       compatible = "ti,lp8860";
>> +       reg = <0x2d>;
>> +       label = "display_cluster";
>> +       enable-gpio = <&gpio1 28 GPIO_ACTIVE_HIGH>;
>> +       vled-supply = <&vbatt>;
>> +}
>> +
>> +For more product information please see the link below:
>> +http://www.ti.com/product/lp8860-q1
>> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
>> index a210338..b0dce59 100644
>> --- a/drivers/leds/Kconfig
>> +++ b/drivers/leds/Kconfig
>> @@ -250,6 +250,16 @@ config LEDS_LP8788
>>         help
>>           This option enables support for the Keyboard LEDs on the LP8788 PMIC.
>>
>> +config LEDS_LP8860
>> +       tristate "LED support for the TI LP8860 4 channel LED driver"
>> +       depends on LEDS_CLASS && REGMAP_I2C
>> +       help
>> +         If you say yes here you get support for the TI LP8860 4 channel
>> +         LED driver.
>> +         This option enables support for the display cluster LEDs
>> +         on the LP8860 4 channel LED driver using the I2C communication
>> +         bus.
>> +
>>  config LEDS_CLEVO_MAIL
>>         tristate "Mail LED on Clevo notebook"
>>         depends on LEDS_CLASS
>> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
>> index a2b1647..1c65a19 100644
>> --- a/drivers/leds/Makefile
>> +++ b/drivers/leds/Makefile
>> @@ -28,6 +28,7 @@ obj-$(CONFIG_LEDS_LP5523)             += leds-lp5523.o
>>  obj-$(CONFIG_LEDS_LP5562)              += leds-lp5562.o
>>  obj-$(CONFIG_LEDS_LP8501)              += leds-lp8501.o
>>  obj-$(CONFIG_LEDS_LP8788)              += leds-lp8788.o
>> +obj-$(CONFIG_LEDS_LP8860)              += leds-lp8860.o
>>  obj-$(CONFIG_LEDS_TCA6507)             += leds-tca6507.o
>>  obj-$(CONFIG_LEDS_CLEVO_MAIL)          += leds-clevo-mail.o
>>  obj-$(CONFIG_LEDS_IPAQ_MICRO)          += leds-ipaq-micro.o
>> diff --git a/drivers/leds/leds-lp8860.c b/drivers/leds/leds-lp8860.c
>> new file mode 100644
>> index 0000000..a91eab9
>> --- /dev/null
>> +++ b/drivers/leds/leds-lp8860.c
>> @@ -0,0 +1,491 @@
>> +/*
>> + * TI LP8860 4-Channel LED Driver
>> + *
>> + * Copyright (C) 2014 Texas Instruments
>> + *
>> + * Author: Dan Murphy <dmurphy@ti.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + *
>> + */
>> +
>> +#include <linux/i2c.h>
>> +#include <linux/init.h>
>> +#include <linux/leds.h>
>> +#include <linux/regmap.h>
>> +#include <linux/regulator/consumer.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/of.h>
>> +#include <linux/of_gpio.h>
>> +#include <linux/gpio/consumer.h>
>> +#include <linux/slab.h>
>> +
>> +#define LP8860_DISP_CL1_BRT_MSB                0x00
>> +#define LP8860_DISP_CL1_BRT_LSB                0x01
>> +#define LP8860_DISP_CL1_CURR_MSB       0x02
>> +#define LP8860_DISP_CL1_CURR_LSB       0x03
>> +#define LP8860_CL2_BRT_MSB             0x04
>> +#define LP8860_CL2_BRT_LSB             0x05
>> +#define LP8860_CL2_CURRENT             0x06
>> +#define LP8860_CL3_BRT_MSB             0x07
>> +#define LP8860_CL3_BRT_LSB             0x08
>> +#define LP8860_CL3_CURRENT             0x09
>> +#define LP8860_CL4_BRT_MSB             0x0a
>> +#define LP8860_CL4_BRT_LSB             0x0b
>> +#define LP8860_CL4_CURRENT             0x0c
>> +#define LP8860_CONFIG                  0x0d
>> +#define LP8860_STATUS                  0x0e
>> +#define LP8860_FAULT                   0x0f
>> +#define LP8860_LED_FAULT               0x10
>> +#define LP8860_FAULT_CLEAR             0x11
>> +#define LP8860_ID                      0x12
>> +#define LP8860_TEMP_MSB                        0x13
>> +#define LP8860_TEMP_LSB                        0x14
>> +#define LP8860_DISP_LED_CURR_MSB       0x15
>> +#define LP8860_DISP_LED_CURR_LSB       0x16
>> +#define LP8860_DISP_LED_PWM_MSB                0x17
>> +#define LP8860_DISP_LED_PWM_LSB                0x18
>> +#define LP8860_EEPROM_CNTRL            0x19
>> +#define LP8860_EEPROM_UNLOCK           0x1a
>> +
>> +#define LP8860_EEPROM_REG_0            0x60
>> +#define LP8860_EEPROM_REG_1            0x61
>> +#define LP8860_EEPROM_REG_2            0x62
>> +#define LP8860_EEPROM_REG_3            0x63
>> +#define LP8860_EEPROM_REG_4            0x64
>> +#define LP8860_EEPROM_REG_5            0x65
>> +#define LP8860_EEPROM_REG_6            0x66
>> +#define LP8860_EEPROM_REG_7            0x67
>> +#define LP8860_EEPROM_REG_8            0x68
>> +#define LP8860_EEPROM_REG_9            0x69
>> +#define LP8860_EEPROM_REG_10           0x6a
>> +#define LP8860_EEPROM_REG_11           0x6b
>> +#define LP8860_EEPROM_REG_12           0x6c
>> +#define LP8860_EEPROM_REG_13           0x6d
>> +#define LP8860_EEPROM_REG_14           0x6e
>> +#define LP8860_EEPROM_REG_15           0x6f
>> +#define LP8860_EEPROM_REG_16           0x70
>> +#define LP8860_EEPROM_REG_17           0x71
>> +#define LP8860_EEPROM_REG_18           0x72
>> +#define LP8860_EEPROM_REG_19           0x73
>> +#define LP8860_EEPROM_REG_20           0x74
>> +#define LP8860_EEPROM_REG_21           0x75
>> +#define LP8860_EEPROM_REG_22           0x76
>> +#define LP8860_EEPROM_REG_23           0x77
>> +#define LP8860_EEPROM_REG_24           0x78
>> +
>> +#define LP8860_LOCK_EEPROM             0x00
>> +#define LP8860_UNLOCK_EEPROM           0x01
>> +#define LP8860_PROGRAM_EEPROM          0x02
>> +#define LP8860_EEPROM_CODE_1           0x08
>> +#define LP8860_EEPROM_CODE_2           0xba
>> +#define LP8860_EEPROM_CODE_3           0xef
>> +
>> +#define LP8860_CLEAR_FAULTS            0x01
>> +
>> +#define LP8860_DISP_LED_NAME           "display_cluster"
>> +
>> +/**
>> + * struct lp8860_led -
>> + * @lock - Lock for reading/writing the device
>> + * @work - Work item used to off load the brightness register writes
>> + * @client - Pointer to the I2C client
>> + * @led_dev - led class device pointer
>> + * @regmap - Devices register map
>> + * @eeprom_regmap - EEPROM register map
>> + * @enable_gpio - VDDIO/EN gpio to enable communication interface
>> + * @regulator - LED supply regulator pointer
>> + * @brightness - Current brightness value requested
>> + * @label - LED label
>> +**/
>> +struct lp8860_led {
>> +       struct mutex lock;
>> +       struct work_struct work;
>> +       struct i2c_client *client;
>> +       struct led_classdev led_dev;
>> +       struct regmap *regmap;
>> +       struct regmap *eeprom_regmap;
>> +       struct gpio_desc *enable_gpio;
>> +       struct regulator *regulator;
>> +       enum led_brightness brightness;
>> +       const char *label;
>> +};
>> +
>> +struct lp8860_eeprom_reg {
>> +       uint8_t reg;
>> +       uint8_t value;
>> +};
>> +
>> +struct lp8860_eeprom_reg lp8860_eeprom_disp_regs[] = {
>> +       { LP8860_EEPROM_REG_0, 0xed },
>> +       { LP8860_EEPROM_REG_1, 0xdf },
>> +       { LP8860_EEPROM_REG_2, 0xdc },
>> +       { LP8860_EEPROM_REG_3, 0xf0 },
>> +       { LP8860_EEPROM_REG_4, 0xdf },
>> +       { LP8860_EEPROM_REG_5, 0xe5 },
>> +       { LP8860_EEPROM_REG_6, 0xf2 },
>> +       { LP8860_EEPROM_REG_7, 0x77 },
>> +       { LP8860_EEPROM_REG_8, 0x77 },
>> +       { LP8860_EEPROM_REG_9, 0x71 },
>> +       { LP8860_EEPROM_REG_10, 0x3f },
>> +       { LP8860_EEPROM_REG_11, 0xb7 },
>> +       { LP8860_EEPROM_REG_12, 0x17 },
>> +       { LP8860_EEPROM_REG_13, 0xef },
>> +       { LP8860_EEPROM_REG_14, 0xb0 },
>> +       { LP8860_EEPROM_REG_15, 0x87 },
>> +       { LP8860_EEPROM_REG_16, 0xce },
>> +       { LP8860_EEPROM_REG_17, 0x72 },
>> +       { LP8860_EEPROM_REG_18, 0xe5 },
>> +       { LP8860_EEPROM_REG_19, 0xdf },
>> +       { LP8860_EEPROM_REG_20, 0x35 },
>> +       { LP8860_EEPROM_REG_21, 0x06 },
>> +       { LP8860_EEPROM_REG_22, 0xdc },
>> +       { LP8860_EEPROM_REG_23, 0x88 },
>> +       { LP8860_EEPROM_REG_24, 0x3E },
>> +};
>> +
>> +static int lp8860_unlock_eeprom(struct lp8860_led *led, int lock)
>> +{
>> +       int ret;
>> +
>> +       mutex_lock(&led->lock);
>> +
>> +       if (lock == LP8860_UNLOCK_EEPROM) {
>> +               ret = regmap_write(led->regmap,
>> +                       LP8860_EEPROM_UNLOCK,
>> +                       LP8860_EEPROM_CODE_1);
>> +               if (ret) {
>> +                       dev_err(&led->client->dev, "EEPROM Unlock failed\n");
>> +                       goto out;
>> +               }
>> +
>> +               ret = regmap_write(led->regmap,
>> +                       LP8860_EEPROM_UNLOCK,
>> +                       LP8860_EEPROM_CODE_2);
>> +               if (ret) {
>> +                       dev_err(&led->client->dev, "EEPROM Unlock failed\n");
>> +                       goto out;
>> +               }
>> +               ret = regmap_write(led->regmap,
>> +                       LP8860_EEPROM_UNLOCK,
>> +                       LP8860_EEPROM_CODE_3);
>> +               if (ret) {
>> +                       dev_err(&led->client->dev, "EEPROM Unlock failed\n");
>> +                       goto out;
>> +               }
>> +       } else {
>> +               ret = regmap_write(led->regmap,
>> +                       LP8860_EEPROM_UNLOCK,
>> +                       LP8860_LOCK_EEPROM);
>> +       }
>> +
>> +out:
>> +       mutex_unlock(&led->lock);
>> +       return ret;
>> +}
>> +
>> +static int lp8860_fault_check(struct lp8860_led *led)
>> +{
>> +       int ret, fault;
>> +       unsigned int read_buf;
>> +
>> +       ret = regmap_read(led->regmap, LP8860_LED_FAULT, &read_buf);
>> +       if (ret)
>> +               goto out;
>> +
>> +       fault = read_buf;
>> +
>> +       ret = regmap_read(led->regmap, LP8860_FAULT, &read_buf);
>> +       if (ret)
>> +               goto out;
>> +
>> +       fault |= read_buf;
>> +
> Looks like this function is just read fault code from the chip but
> forget to pass that fault information to caller. Then what we are
> checking here?

This function will just read the two fault registers.  IF there is a fault
then we send the clear over the I2C bus.  If there is no fault then no
clear.

Once we clear the faults the device re-validates to make sure faults to
not exist.  So we should check and clear to get any fresh faults.

>
>> +       /* Attempt to clear any faults */
>> +       if (fault)
>> +               ret = regmap_write(led->regmap, LP8860_FAULT_CLEAR,
>> +                       LP8860_CLEAR_FAULTS);
>> +out:
>> +       return ret;
>> +}
>> +
>> +static void lp8860_led_brightness_work(struct work_struct *work)
>> +{
>> +       struct lp8860_led *led = container_of(work, struct lp8860_led, work);
>> +       int ret;
>> +       int disp_brightness = led->brightness * 255;
>> +
>> +       mutex_lock(&led->lock);
>> +
>> +       ret = lp8860_fault_check(led);
>> +       if (ret) {
>> +               dev_err(&led->client->dev, "Cannot read/clear faults\n");
>> +               goto out;
>> +       }
>> +
>> +       ret = regmap_write(led->regmap, LP8860_DISP_CL1_BRT_MSB,
>> +                       (disp_brightness & 0xff00) >> 8);
>> +       if (ret) {
>> +               dev_err(&led->client->dev, "Cannot write CL1 MSB\n");
>> +               goto out;
>> +       }
>> +
>> +       ret = regmap_write(led->regmap, LP8860_DISP_CL1_BRT_LSB,
>> +                       disp_brightness & 0xff);
>> +       if (ret) {
>> +               dev_err(&led->client->dev, "Cannot write CL1 LSB\n");
>> +               goto out;
>> +       }
>> +out:
>> +       mutex_unlock(&led->lock);
>> +}
>> +
>> +static void lp8860_brightness_set(struct led_classdev *led_cdev,
>> +                               enum led_brightness brt_val)
>> +{
>> +       struct lp8860_led *led =
>> +                       container_of(led_cdev, struct lp8860_led, led_dev);
>> +
>> +       led->brightness = brt_val;
>> +       schedule_work(&led->work);
>> +}
>> +
>> +static int lp8860_init(struct lp8860_led *led)
>> +{
>> +       unsigned int read_buf;
>> +       int ret, i, reg_count;
>> +
>> +       if (led->enable_gpio)
>> +               gpiod_direction_output(led->enable_gpio, 1);
>> +
>> +       ret = lp8860_fault_check(led);
>> +       if (ret)
>> +               goto out;
>> +
>> +       ret = regmap_read(led->regmap, LP8860_STATUS, &read_buf);
>> +       if (ret)
>> +               goto out;
>> +
>> +       ret = lp8860_unlock_eeprom(led, LP8860_UNLOCK_EEPROM);
>> +       if (ret) {
>> +               dev_err(&led->client->dev, "Failed unlocking EEPROM\n");
>> +               goto out;
>> +       }
>> +
>> +       reg_count = ARRAY_SIZE(lp8860_eeprom_disp_regs) / sizeof(lp8860_eeprom_disp_regs[0]);
>> +       for (i = 0; i < reg_count; i++) {
>> +               ret = regmap_write(led->eeprom_regmap,
>> +                               lp8860_eeprom_disp_regs[i].reg,
>> +                               lp8860_eeprom_disp_regs[i].value);
>> +               if (ret) {
>> +                       dev_err(&led->client->dev, "Failed writing EEPROM\n");
>> +                       goto out;
>> +               }
>> +       }
>> +
>> +       ret = lp8860_unlock_eeprom(led, LP8860_LOCK_EEPROM);
>> +       if (ret)
>> +               goto out;
>> +
>> +       ret = regmap_write(led->regmap,
>> +                       LP8860_EEPROM_CNTRL,
>> +                       LP8860_PROGRAM_EEPROM);
>> +       if (ret)
>> +               dev_err(&led->client->dev, "Failed programming EEPROM\n");
>> +out:
>> +       if (ret)
>> +               if (led->enable_gpio)
>> +                       gpiod_direction_output(led->enable_gpio, 0);
>> +       return ret;
>> +}
>> +
>> +static struct reg_default lp8860_reg_defs[] = {
>> +       { LP8860_DISP_CL1_BRT_MSB, 0x00},
>> +       { LP8860_DISP_CL1_BRT_LSB, 0x00},
>> +       { LP8860_DISP_CL1_CURR_MSB, 0x00},
>> +       { LP8860_DISP_CL1_CURR_LSB, 0x00},
>> +       { LP8860_CL2_BRT_MSB, 0x00},
>> +       { LP8860_CL2_BRT_LSB, 0x00},
>> +       { LP8860_CL2_CURRENT, 0x00},
>> +       { LP8860_CL3_BRT_MSB, 0x00},
>> +       { LP8860_CL3_BRT_LSB, 0x00},
>> +       { LP8860_CL3_CURRENT, 0x00},
>> +       { LP8860_CL4_BRT_MSB, 0x00},
>> +       { LP8860_CL4_BRT_LSB, 0x00},
>> +       { LP8860_CL4_CURRENT, 0x00},
>> +       { LP8860_CONFIG, 0x00},
>> +       { LP8860_FAULT_CLEAR, 0x00},
>> +       { LP8860_EEPROM_CNTRL, 0x80},
>> +       { LP8860_EEPROM_UNLOCK, 0x00},
>> +};
>> +
>> +static const struct regmap_config lp8860_regmap_config = {
>> +       .reg_bits = 8,
>> +       .val_bits = 8,
>> +
>> +       .max_register = LP8860_EEPROM_UNLOCK,
>> +       .reg_defaults = lp8860_reg_defs,
>> +       .num_reg_defaults = ARRAY_SIZE(lp8860_reg_defs),
>> +       .cache_type = REGCACHE_NONE,
>> +};
>> +
>> +static struct reg_default lp8860_eeprom_defs[] = {
>> +       { LP8860_EEPROM_REG_0, 0x00 },
>> +       { LP8860_EEPROM_REG_1, 0x00 },
>> +       { LP8860_EEPROM_REG_2, 0x00 },
>> +       { LP8860_EEPROM_REG_3, 0x00 },
>> +       { LP8860_EEPROM_REG_4, 0x00 },
>> +       { LP8860_EEPROM_REG_5, 0x00 },
>> +       { LP8860_EEPROM_REG_6, 0x00 },
>> +       { LP8860_EEPROM_REG_7, 0x00 },
>> +       { LP8860_EEPROM_REG_8, 0x00 },
>> +       { LP8860_EEPROM_REG_9, 0x00 },
>> +       { LP8860_EEPROM_REG_10, 0x00 },
>> +       { LP8860_EEPROM_REG_11, 0x00 },
>> +       { LP8860_EEPROM_REG_12, 0x00 },
>> +       { LP8860_EEPROM_REG_13, 0x00 },
>> +       { LP8860_EEPROM_REG_14, 0x00 },
>> +       { LP8860_EEPROM_REG_15, 0x00 },
>> +       { LP8860_EEPROM_REG_16, 0x00 },
>> +       { LP8860_EEPROM_REG_17, 0x00 },
>> +       { LP8860_EEPROM_REG_18, 0x00 },
>> +       { LP8860_EEPROM_REG_19, 0x00 },
>> +       { LP8860_EEPROM_REG_20, 0x00 },
>> +       { LP8860_EEPROM_REG_21, 0x00 },
>> +       { LP8860_EEPROM_REG_22, 0x00 },
>> +       { LP8860_EEPROM_REG_23, 0x00 },
>> +       { LP8860_EEPROM_REG_24, 0x00 },
>> +};
>> +
>> +static const struct regmap_config lp8860_eeprom_regmap_config = {
>> +       .reg_bits = 8,
>> +       .val_bits = 8,
>> +
>> +       .max_register = LP8860_EEPROM_REG_24,
>> +       .reg_defaults = lp8860_eeprom_defs,
>> +       .num_reg_defaults = ARRAY_SIZE(lp8860_eeprom_defs),
>> +       .cache_type = REGCACHE_NONE,
>> +};
>> +
>> +static int lp8860_probe(struct i2c_client *client,
>> +                       const struct i2c_device_id *id)
>> +{
>> +       int ret;
>> +       struct lp8860_led *led;
>> +       struct device_node *np = client->dev.of_node;
>> +
>> +       led = devm_kzalloc(&client->dev, sizeof(*led), GFP_KERNEL);
>> +       if (!led)
>> +               return -ENOMEM;
>> +
>> +       led->label = LP8860_DISP_LED_NAME;
>> +
>> +       if (client->dev.of_node) {
>> +               ret = of_property_read_string(np, "label", &led->label);
>> +               if (ret) {
>> +                       dev_err(&client->dev, "Missing label in dt\n");
>> +                       return -EINVAL;
>> +               }
>> +       }
>> +
>> +       led->enable_gpio = devm_gpiod_get(&client->dev, "enable");
>> +       if (IS_ERR(led->enable_gpio))
>> +               led->enable_gpio = NULL;
>> +       else
>> +               gpiod_direction_output(led->enable_gpio, 0);
>> +
>> +       led->regulator = devm_regulator_get(&client->dev, "vled");
>> +       if (IS_ERR(led->regulator))
>> +               led->regulator = NULL;
>> +
>> +       led->client = client;
>> +       led->led_dev.name = led->label;
>> +       led->led_dev.max_brightness = LED_FULL;
>> +       led->led_dev.brightness_set = lp8860_brightness_set;
>> +
>> +       mutex_init(&led->lock);
>> +       INIT_WORK(&led->work, lp8860_led_brightness_work);
> I think INIT_WORK() should be put after those devm_regmap_init_i2c(),
> since it might cause some race condition.

This to me does not seem to be an issue.  The work
item is not scheduled until you have registered to the LED class.

This is only scheduled through the brightness sysfs api entry.

>
>> +
>> +       i2c_set_clientdata(client, led);
>> +
>> +       led->regmap = devm_regmap_init_i2c(client, &lp8860_regmap_config);
>> +       if (IS_ERR(led->regmap)) {
>> +               ret = PTR_ERR(led->regmap);
>> +               dev_err(&client->dev, "Failed to allocate register map: %d\n",
>> +                       ret);
>> +               return ret;
>> +       }
>> +
>> +       led->eeprom_regmap = devm_regmap_init_i2c(client, &lp8860_eeprom_regmap_config);
>> +       if (IS_ERR(led->eeprom_regmap)) {
>> +               ret = PTR_ERR(led->eeprom_regmap);
>> +               dev_err(&client->dev, "Failed to allocate register map: %d\n",
>> +                       ret);
>> +               return ret;
>> +       }
>    INIT_WORK(&led->work, lp8860_led_brightness_work);
>
>> +
>> +       ret = lp8860_init(led);
>> +       if (ret)
>> +               return ret;
>> +
>> +       ret = led_classdev_register(&client->dev, &led->led_dev);
>> +       if (ret) {
>> +               dev_err(&client->dev, "led register err: %d\n", ret);
>> +               return ret;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int lp8860_remove(struct i2c_client *client)
>> +{
>> +       struct lp8860_led *led = i2c_get_clientdata(client);
>> +       int ret;
>> +
>> +       led_classdev_unregister(&led->led_dev);
>> +       flush_work(&led->work);
> flush_work() is not good here, please use cancel_work_sync().

Yeah that would work better.

>
>> +
>> +       if (led->enable_gpio)
>> +               gpiod_direction_output(led->enable_gpio, 0);
>> +
>> +       if (led->regulator) {
>> +               ret = regulator_disable(led->regulator);
>> +               if (ret)
>> +                       dev_err(&led->client->dev,
>> +                               "Failed to disable regulator\n");
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static const struct i2c_device_id lp8860_id[] = {
>> +       { "lp8860", 0 },
>> +       { }
>> +};
>> +MODULE_DEVICE_TABLE(i2c, lp8860_id);
>> +
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id of_lp8860_leds_match[] = {
>> +       { .compatible = "ti,lp8860", },
>> +       {},
>> +};
>> +MODULE_DEVICE_TABLE(of, of_lp8860_leds_match);
>> +#endif
>> +
>> +static struct i2c_driver lp8860_driver = {
>> +       .driver = {
>> +               .name   = "lp8860",
>> +               .of_match_table = of_match_ptr(of_lp8860_leds_match),
>> +       },
>> +       .probe          = lp8860_probe,
>> +       .remove         = lp8860_remove,
>> +       .id_table       = lp8860_id,
>> +};
>> +module_i2c_driver(lp8860_driver);
>> +
>> +MODULE_DESCRIPTION("Texas Instruments LP8860 LED drvier");
>> +MODULE_AUTHOR("Dan Murphy <dmurphy@ti.com>");
>> +MODULE_LICENSE("GPL");
>> --
>> 1.9.1
>>


-- 
------------------
Dan Murphy

