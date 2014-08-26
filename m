Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbaHZCyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 22:54:49 -0400
Received: from regular1.263xmail.com ([211.150.99.130]:47013 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaHZCyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 22:54:47 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <bb8a2eb4ff38f99da9957296377db7ff>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <53FBF6EB.1080002@rock-chips.com>
Date: Tue, 26 Aug 2014 10:54:35 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH v5 2/5] MFD: RK808: Add new mfd driver for RK808
References: <1408973516-21395-1-git-send-email-zyw@rock-chips.com> <CAD=FV=Wz1yssGvB05ExPaYxsiizcPRYrfP9OWE+HdoSDKVc_Tw@mail.gmail.com>
In-Reply-To: <CAD=FV=Wz1yssGvB05ExPaYxsiizcPRYrfP9OWE+HdoSDKVc_Tw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/26/2014 04:44 AM, Doug Anderson wrote:
> Chris,
>
> On Mon, Aug 25, 2014 at 6:31 AM, Chris Zhong <zyw@rock-chips.com> wrote:
>> The RK808 chip is a power management IC for multimedia and handheld
>> devices. It contains the following components:
>>
>> - Regulators
>> - RTC
>>
>> The RK808 core driver is registered as a platform driver and provides
>> communication through I2C with the host device for the different
>> components.
>>
>> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> You need a Signed-off-by: Zhang Qing <zhangqing@rock-chips.com>

Done

>
>> ---
>>
>> Changes in v5:
>> - re-edit base on Mark's branch
>>
>> Changes in v4:
>> - use &client->dev replace rk808->dev
>>
>> Changes in v3: None
>> Changes in v2:
>> Adviced by Mark Browm:
>> - change of_find_node_by_name to find_child_by_name
>> - use RK808_NUM_REGULATORS as the name of the constant
>> - create a pdata when missing platform data
>> - use the rk808_reg name to supply_regulator name
>> - replace regulator_register with devm_regulator_register
>> - some other problem with coding style
>>
>>   drivers/mfd/Kconfig       |   13 +++
>>   drivers/mfd/Makefile      |    1 +
>>   drivers/mfd/rk808.c       |  265 +++++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/mfd/rk808.h |  211 ++++++++++++++++++++++++++++++++++++
>>   4 files changed, 490 insertions(+)
>>   create mode 100644 drivers/mfd/rk808.c
>>   create mode 100644 include/linux/mfd/rk808.h
>>
>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
>> index de5abf2..2c7fdb2 100644
>> --- a/drivers/mfd/Kconfig
>> +++ b/drivers/mfd/Kconfig
>> @@ -582,6 +582,19 @@ config MFD_RC5T583
>>            Additional drivers must be enabled in order to use the
>>            different functionality of the device.
>>
>> +config MFD_RK808
>> +       tristate "Rockchip RK808 Power Management chip"
>> +       depends on I2C
>> +       select MFD_CORE
>> +       select REGMAP_I2C
>> +       select REGMAP_IRQ
>> +       help
>> +         If you say yes here you get support for the RK808
>> +         Power Management chips.
>> +         This driver provides common support for accessing the device
>> +         through I2C interface. The device supports multiple sub-devices
>> +         including interrupts, RTC, LDO & DCDC regulators, and onkey.
>> +
>>   config MFD_SEC_CORE
>>          bool "SAMSUNG Electronics PMIC Series Support"
>>          depends on I2C=y
>> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
>> index f001487..dbc28e7 100644
>> --- a/drivers/mfd/Makefile
>> +++ b/drivers/mfd/Makefile
>> @@ -160,6 +160,7 @@ obj-$(CONFIG_MFD_INTEL_MSIC)        += intel_msic.o
>>   obj-$(CONFIG_MFD_PALMAS)       += palmas.o
>>   obj-$(CONFIG_MFD_VIPERBOARD)    += viperboard.o
>>   obj-$(CONFIG_MFD_RC5T583)      += rc5t583.o rc5t583-irq.o
>> +obj-$(CONFIG_MFD_RK808)                += rk808.o
>>   obj-$(CONFIG_MFD_SEC_CORE)     += sec-core.o sec-irq.o
>>   obj-$(CONFIG_MFD_SYSCON)       += syscon.o
>>   obj-$(CONFIG_MFD_LM3533)       += lm3533-core.o lm3533-ctrlbank.o
>> diff --git a/drivers/mfd/rk808.c b/drivers/mfd/rk808.c
>> new file mode 100644
>> index 0000000..40c951e
>> --- /dev/null
>> +++ b/drivers/mfd/rk808.c
>> @@ -0,0 +1,265 @@
>> +/*
>> + * MFD core driver for Rockchip RK808
>> + *
>> + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
>> + *
>> + * Author: Chris Zhong <zyw@rock-chips.com>
>> + * Author: Zhang Qing <zhangqing@rock-chips.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + */
>> +
>> +#include <linux/i2c.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/mfd/rk808.h>
>> +#include <linux/mfd/core.h>
>> +#include <linux/module.h>
>> +#include <linux/regmap.h>
>> +
>> +struct rk808_reg_data {
>> +       int addr;
>> +       int mask;
>> +       int value;
>> +};
>> +
>> +static struct rk808 *g_rk808;
> I think Lee's "Grim" comment here was that prefixing globals with "g_"
> is not consistent with the Linux coding style.  Just remove the "g_".

Done

>
>
>> +static const struct regmap_config rk808_regmap_config = {
>> +       .reg_bits = 8,
>> +       .val_bits = 8,
>> +       .max_register = RK808_IO_POL_REG,
>> +};
>> +
>> +static struct resource rtc_resources[] = {
>> +       {
>> +               .start  = RK808_IRQ_RTC_ALARM,
>> +               .end    = RK808_IRQ_RTC_ALARM,
>> +               .flags  = IORESOURCE_IRQ,
>> +       }
>> +};
>> +
>> +static const struct mfd_cell rk808s[] = {
>> +       { .name = "rk808-clkout", },
>> +       { .name = "rk808-regulator", },
>> +       {
>> +               .name = "rk808-rtc",
>> +               .num_resources = ARRAY_SIZE(rtc_resources),
>> +               .resources = &rtc_resources[0],
>> +       },
>> +};
>> +
>> +static const struct rk808_reg_data pre_init_reg[] = {
>> +       {RK808_BUCK3_CONFIG_REG, BUCK_ILMIN_MASK,  BUCK_ILMIN_150MA},
> nit: with {} we have space, so:
>
> { RK808_BUCK3_CONFIG_REG, BUCK_ILMIN_MASK,  BUCK_ILMIN_150MA },
>
> instead of:
>
> {RK808_BUCK3_CONFIG_REG, BUCK_ILMIN_MASK,  BUCK_ILMIN_150MA},

Done

>
>> +       {RK808_BUCK4_CONFIG_REG, BUCK_ILMIN_MASK,  BUCK_ILMIN_200MA},
>> +       {RK808_BOOST_CONFIG_REG, BOOST_ILMIN_MASK, BOOST_ILMIN_100MA},
>> +       {RK808_BUCK1_CONFIG_REG, BUCK1_RATE_MASK,  BUCK_ILMIN_200MA},
>> +       {RK808_BUCK2_CONFIG_REG, BUCK2_RATE_MASK,  BUCK_ILMIN_200MA},
>> +       {RK808_VB_MON_REG,       MASK_ALL,         VB_LO_ACT |
>> +        VB_LO_SEL_3500MV},
> nit: add spacing so that VB_LO_SEL_3500MV lines up under VB_LO_ACT

Done

>
>> +       {RK808_INT_STS_REG1,     MASK_NONE,        0},
>> +       {RK808_INT_STS_REG2,     MASK_NONE,        0},
>> +};
>> +
>> +static const struct regmap_irq rk808_irqs[] = {
>> +       /* INT_STS */
>> +       [RK808_IRQ_VOUT_LO] = {
>> +               .mask = RK808_IRQ_VOUT_LO_MSK,
>> +               .reg_offset = 0,
>> +       },
>> +       [RK808_IRQ_VB_LO] = {
>> +               .mask = RK808_IRQ_VB_LO_MSK,
>> +               .reg_offset = 0,
>> +       },
>> +       [RK808_IRQ_PWRON] = {
>> +               .mask = RK808_IRQ_PWRON_MSK,
>> +               .reg_offset = 0,
>> +       },
>> +       [RK808_IRQ_PWRON_LP] = {
>> +               .mask = RK808_IRQ_PWRON_LP_MSK,
>> +               .reg_offset = 0,
>> +       },
>> +       [RK808_IRQ_HOTDIE] = {
>> +               .mask = RK808_IRQ_HOTDIE_MSK,
>> +               .reg_offset = 0,
>> +       },
>> +       [RK808_IRQ_RTC_ALARM] = {
>> +               .mask = RK808_IRQ_RTC_ALARM_MSK,
>> +               .reg_offset = 0,
>> +       },
>> +       [RK808_IRQ_RTC_PERIOD] = {
>> +               .mask = RK808_IRQ_RTC_PERIOD_MSK,
>> +               .reg_offset = 0,
>> +       },
>> +
>> +       /* INT_STS2 */
>> +       [RK808_IRQ_PLUG_IN_INT] = {
>> +               .mask = RK808_IRQ_PLUG_IN_INT_MSK,
>> +               .reg_offset = 1,
>> +       },
>> +       [RK808_IRQ_PLUG_OUT_INT] = {
>> +               .mask = RK808_IRQ_PLUG_OUT_INT_MSK,
>> +               .reg_offset = 1,
>> +       },
>> +};
>> +
>> +static struct regmap_irq_chip rk808_irq_chip = {
>> +       .name = "rk808",
>> +       .irqs = rk808_irqs,
>> +       .num_irqs = ARRAY_SIZE(rk808_irqs),
>> +       .num_regs = 2,
>> +       .irq_reg_stride = 2,
>> +       .status_base = RK808_INT_STS_REG1,
>> +       .mask_base = RK808_INT_STS_MSK_REG1,
>> +       .ack_base = RK808_INT_STS_REG1,
>> +};
>> +
>> +static void rk808_device_shutdown(void)
>> +{
>> +       int ret;
>> +       struct rk808 *rk808 = g_rk808;
>> +       struct i2c_client *client = rk808->i2c;
>> +
>> +       if (!rk808) {
>> +               dev_warn(&client->dev, "have no rk808, so do nothing here\n");
>> +               return;
>> +       }
>> +
>> +       ret = regmap_update_bits(rk808->regmap,
>> +                                RK808_DEVCTRL_REG,
>> +                                DEV_OFF_RST, DEV_OFF_RST);
>> +       if (ret)
>> +               dev_err(&client->dev, "power off error!\n");
>> +}
>> +
>> +static int rk808_pre_init(struct rk808 *rk808)
>> +{
>> +       int i;
>> +       int ret;
>> +       struct i2c_client *client = rk808->i2c;
>> +
>> +       for (i = 0; i < ARRAY_SIZE(pre_init_reg); i++) {
>> +               ret = regmap_update_bits(rk808->regmap, pre_init_reg[i].addr,
>> +                                        pre_init_reg[i].mask,
>> +                                        pre_init_reg[i].value);
>> +               if (ret) {
>> +                       dev_err(&client->dev,
>> +                               "0x%x write err\n", pre_init_reg[i].addr);
>> +                       return ret;
>> +               }
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int rk808_probe(struct i2c_client *client,
>> +                      const struct i2c_device_id *id)
>> +{
>> +       int ret;
>> +       struct rk808 *rk808;
>> +       struct device_node *np = client->dev.of_node;
>> +       struct rk808_board *pdata = dev_get_platdata(&client->dev);
>> +
>> +       if (!pdata) {
>> +               pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
>> +               if (!pdata)
>> +                       return -ENOMEM;
>> +
>> +               pdata->pm_off = of_property_read_bool(np,
>> +                               "rockchip,system-power-controller");
>> +       }
>> +
>> +       rk808 = devm_kzalloc(&client->dev, sizeof(*rk808), GFP_KERNEL);
>> +       if (!rk808)
>> +               return -ENOMEM;
>> +
>> +       rk808->pdata = pdata;
>> +       rk808->i2c = client;
>> +       i2c_set_clientdata(client, rk808);
>> +
>> +       rk808->regmap = devm_regmap_init_i2c(client, &rk808_regmap_config);
>> +       if (IS_ERR(rk808->regmap)) {
>> +               dev_err(&client->dev, "regmap initialization failed\n");
>> +               return PTR_ERR(rk808->regmap);
>> +       }
>> +
>> +       ret = rk808_pre_init(rk808);
>> +       if (ret)
>> +               return ret;
>> +
>> +       if (!client->irq) {
>> +               dev_err(&client->dev, "No interrupt support, no core IRQ\n");
>> +               return -EINVAL;
>> +       }
>> +
>> +       ret = regmap_add_irq_chip(rk808->regmap, client->irq,
>> +                                 IRQF_ONESHOT, -1,
>> +                                 &rk808_irq_chip, &rk808->irq_data);
>> +       if (ret) {
>> +               dev_err(&client->dev, "Failed to add irq_chip %d\n", ret);
>> +               return ret;
>> +       }
>> +
>> +       ret = mfd_add_devices(&client->dev, -1,
>> +                             rk808s, ARRAY_SIZE(rk808s),
>> +                             NULL, 0, regmap_irq_get_domain(rk808->irq_data));
>> +       if (ret) {
>> +               dev_err(&client->dev, "failed to add MFD devices %d\n", ret);
>> +               goto err_irq;
>> +       }
>> +
>> +       g_rk808 = rk808;
>> +       if (pdata->pm_off && !pm_power_off)
>> +               pm_power_off = rk808_device_shutdown;
>> +
>> +       return 0;
>> +
>> +err_irq:
>> +       regmap_del_irq_chip(client->irq, rk808->irq_data);
>> +       return ret;
>> +}
>> +
>> +static int rk808_remove(struct i2c_client *client)
>> +{
>> +       struct rk808 *rk808 = i2c_get_clientdata(client);
>> +
>> +       regmap_del_irq_chip(client->irq, rk808->irq_data);
>> +       mfd_remove_devices(&client->dev);
>> +       pm_power_off = NULL;
>> +       return 0;
>> +}
>> +
>> +static struct of_device_id rk808_of_match[] = {
>> +       { .compatible = "rockchip,rk808" },
>> +};
>> +MODULE_DEVICE_TABLE(of, rk808_of_match);
>> +
>> +static const struct i2c_device_id rk808_ids[] = {
>> +        { "rk808", 0 },
> I think Lee wanted the above to be:
>
>         { "rk808", },

Done

>
>
>> +};
>> +
>> +MODULE_DEVICE_TABLE(i2c, rk808_ids);
>> +
>> +static struct i2c_driver rk808_i2c_driver = {
>> +       .driver = {
>> +               .name = "rk808",
>> +               .owner = THIS_MODULE,
> I think Lee wanted you to remove ".owner = THIS_MODULE"

Done

>
>
>> +               .of_match_table = of_match_ptr(rk808_of_match),
>> +       },
>> +       .probe    = rk808_probe,
>> +       .remove   = rk808_remove,
>> +       .id_table = rk808_ids,
>> +};
>> +
>> +module_i2c_driver(rk808_i2c_driver);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_AUTHOR("Chris Zhong <zyw@rock-chips.com>");
>> +MODULE_AUTHOR("Zhang Qing <zhangqing@rock-chips.com>");
>> +MODULE_DESCRIPTION("RK808 PMIC driver");
>> diff --git a/include/linux/mfd/rk808.h b/include/linux/mfd/rk808.h
>> new file mode 100644
>> index 0000000..8bdec67
>> --- /dev/null
>> +++ b/include/linux/mfd/rk808.h
>> @@ -0,0 +1,211 @@
>> +/*
>> + * rk808.h for Rockchip RK808
>> + *
>> + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
>> + *
>> + * Author: Chris Zhong <zyw@rock-chips.com>
>> + * Author: Zhang Qing <zhangqing@rock-chips.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>> + * more details.
>> + */
>> +
>> +#ifndef __LINUX_REGULATOR_rk808_H
>> +#define __LINUX_REGULATOR_rk808_H
>> +
>> +#include <linux/regulator/machine.h>
>> +#include <linux/regmap.h>
>> +
>> +/*
>> + * rk808 Global Register Map.
>> + */
>> +
>> +#define RK808_DCDC1    0 /* (0+RK808_START) */
>> +#define RK808_LDO1     4 /* (4+RK808_START) */
>> +#define RK808_NUM_REGULATORS   14
>> +
>> +enum rk808_reg {
>> +       RK808_ID_DCDC1,
>> +       RK808_ID_DCDC2,
>> +       RK808_ID_DCDC3,
>> +       RK808_ID_DCDC4,
>> +       RK808_ID_LDO1,
>> +       RK808_ID_LDO2,
>> +       RK808_ID_LDO3,
>> +       RK808_ID_LDO4,
>> +       RK808_ID_LDO5,
>> +       RK808_ID_LDO6,
>> +       RK808_ID_LDO7,
>> +       RK808_ID_LDO8,
>> +       RK808_ID_SWITCH1,
>> +       RK808_ID_SWITCH2,
>> +};
>> +
>> +#define RK808_SECONDS_REG      0x00
>> +#define RK808_MINUTES_REG      0x01
>> +#define RK808_HOURS_REG                0x02
>> +#define RK808_DAYS_REG         0x03
>> +#define RK808_MONTHS_REG       0x04
>> +#define RK808_YEARS_REG                0x05
>> +#define RK808_WEEKS_REG                0x06
>> +#define RK808_ALARM_SECONDS_REG        0x08
>> +#define RK808_ALARM_MINUTES_REG        0x09
>> +#define RK808_ALARM_HOURS_REG  0x0a
>> +#define RK808_ALARM_DAYS_REG   0x0b
>> +#define RK808_ALARM_MONTHS_REG 0x0c
>> +#define RK808_ALARM_YEARS_REG  0x0d
>> +#define RK808_RTC_CTRL_REG     0x10
>> +#define RK808_RTC_STATUS_REG   0x11
>> +#define RK808_RTC_INT_REG      0x12
>> +#define RK808_RTC_COMP_LSB_REG 0x13
>> +#define RK808_RTC_COMP_MSB_REG 0x14
>> +#define RK808_CLK32OUT_REG     0x20
>> +#define RK808_VB_MON_REG       0x21
>> +#define RK808_THERMAL_REG      0x22
>> +#define RK808_DCDC_EN_REG      0x23
>> +#define RK808_LDO_EN_REG       0x24
>> +#define RK808_SLEEP_SET_OFF_REG1       0x25
>> +#define RK808_SLEEP_SET_OFF_REG2       0x26
>> +#define RK808_DCDC_UV_STS_REG  0x27
>> +#define RK808_DCDC_UV_ACT_REG  0x28
>> +#define RK808_LDO_UV_STS_REG   0x29
>> +#define RK808_LDO_UV_ACT_REG   0x2a
>> +#define RK808_DCDC_PG_REG      0x2b
>> +#define RK808_LDO_PG_REG       0x2c
>> +#define RK808_VOUT_MON_TDB_REG 0x2d
>> +#define RK808_BUCK1_CONFIG_REG         0x2e
>> +#define RK808_BUCK1_ON_VSEL_REG                0x2f
>> +#define RK808_BUCK1_SLP_VSEL_REG       0x30
>> +#define RK808_BUCK1_DVS_VSEL_REG       0x31
>> +#define RK808_BUCK2_CONFIG_REG         0x32
>> +#define RK808_BUCK2_ON_VSEL_REG                0x33
>> +#define RK808_BUCK2_SLP_VSEL_REG       0x34
>> +#define RK808_BUCK2_DVS_VSEL_REG       0x35
>> +#define RK808_BUCK3_CONFIG_REG         0x36
>> +#define RK808_BUCK4_CONFIG_REG         0x37
>> +#define RK808_BUCK4_ON_VSEL_REG                0x38
>> +#define RK808_BUCK4_SLP_VSEL_REG       0x39
>> +#define RK808_BOOST_CONFIG_REG         0x3a
>> +#define RK808_LDO1_ON_VSEL_REG         0x3b
>> +#define RK808_LDO1_SLP_VSEL_REG                0x3c
>> +#define RK808_LDO2_ON_VSEL_REG         0x3d
>> +#define RK808_LDO2_SLP_VSEL_REG                0x3e
>> +#define RK808_LDO3_ON_VSEL_REG         0x3f
>> +#define RK808_LDO3_SLP_VSEL_REG                0x40
>> +#define RK808_LDO4_ON_VSEL_REG         0x41
>> +#define RK808_LDO4_SLP_VSEL_REG                0x42
>> +#define RK808_LDO5_ON_VSEL_REG         0x43
>> +#define RK808_LDO5_SLP_VSEL_REG                0x44
>> +#define RK808_LDO6_ON_VSEL_REG         0x45
>> +#define RK808_LDO6_SLP_VSEL_REG                0x46
>> +#define RK808_LDO7_ON_VSEL_REG         0x47
>> +#define RK808_LDO7_SLP_VSEL_REG                0x48
>> +#define RK808_LDO8_ON_VSEL_REG         0x49
>> +#define RK808_LDO8_SLP_VSEL_REG                0x4a
>> +#define RK808_DEVCTRL_REG      0x4b
>> +#define RK808_INT_STS_REG1     0x4c
>> +#define RK808_INT_STS_MSK_REG1 0x4d
>> +#define RK808_INT_STS_REG2     0x4e
>> +#define RK808_INT_STS_MSK_REG2 0x4f
>> +#define RK808_IO_POL_REG       0x50
>> +
>> +/* IRQ Definitions */
>> +#define RK808_IRQ_VOUT_LO      0
>> +#define RK808_IRQ_VB_LO                1
>> +#define RK808_IRQ_PWRON                2
>> +#define RK808_IRQ_PWRON_LP     3
>> +#define RK808_IRQ_HOTDIE       4
>> +#define RK808_IRQ_RTC_ALARM    5
>> +#define RK808_IRQ_RTC_PERIOD   6
>> +#define RK808_IRQ_PLUG_IN_INT  7
>> +#define RK808_IRQ_PLUG_OUT_INT 8
>> +#define RK808_NUM_IRQ          9
>> +
>> +#define RK808_IRQ_VOUT_LO_MSK          BIT(0)
>> +#define RK808_IRQ_VB_LO_MSK            BIT(1)
>> +#define RK808_IRQ_PWRON_MSK            BIT(2)
>> +#define RK808_IRQ_PWRON_LP_MSK         BIT(3)
>> +#define RK808_IRQ_HOTDIE_MSK           BIT(4)
>> +#define RK808_IRQ_RTC_ALARM_MSK                BIT(5)
>> +#define RK808_IRQ_RTC_PERIOD_MSK       BIT(6)
>> +#define RK808_IRQ_PLUG_IN_INT_MSK      BIT(0)
>> +#define RK808_IRQ_PLUG_OUT_INT_MSK     BIT(1)
>> +
>> +#define RK808_VBAT_LOW_2V8     0x00
>> +#define RK808_VBAT_LOW_2V9     0x01
>> +#define RK808_VBAT_LOW_3V0     0x02
>> +#define RK808_VBAT_LOW_3V1     0x03
>> +#define RK808_VBAT_LOW_3V2     0x04
>> +#define RK808_VBAT_LOW_3V3     0x05
>> +#define RK808_VBAT_LOW_3V4     0x06
>> +#define RK808_VBAT_LOW_3V5     0x07
>> +#define VBAT_LOW_VOL_MASK      (0x07 << 0)
>> +#define EN_VABT_LOW_SHUT_DOWN  (0x00 << 4)
>> +#define EN_VBAT_LOW_IRQ                (0x1 << 4)
>> +#define VBAT_LOW_ACT_MASK      (0x1 << 4)
>> +
>> +#define BUCK_ILMIN_MASK                (7 << 0)
>> +#define BOOST_ILMIN_MASK       (7 << 0)
>> +#define BUCK1_RATE_MASK                (3 << 3)
>> +#define BUCK2_RATE_MASK                (3 << 3)
>> +#define MASK_ALL       0xff
>> +#define MASK_NONE      0
>> +
>> +#define SWITCH2_EN     BIT(6)
>> +#define SWITCH1_EN     BIT(5)
>> +#define DEV_OFF_RST    BIT(3)
>> +
>> +#define VB_LO_ACT              BIT(4)
>> +#define VB_LO_SEL_3500MV       (7 << 0)
>> +
>> +#define VOUT_LO_INT    BIT(0)
>> +#define CLK32KOUT2_EN  BIT(0)
>> +
>> +enum {
>> +       BUCK_ILMIN_50MA,
>> +       BUCK_ILMIN_100MA,
>> +       BUCK_ILMIN_150MA,
>> +       BUCK_ILMIN_200MA,
>> +       BUCK_ILMIN_250MA,
>> +       BUCK_ILMIN_300MA,
>> +       BUCK_ILMIN_350MA,
>> +       BUCK_ILMIN_400MA,
>> +};
>> +
>> +enum {
>> +       BOOST_ILMIN_75MA,
>> +       BOOST_ILMIN_100MA,
>> +       BOOST_ILMIN_125MA,
>> +       BOOST_ILMIN_150MA,
>> +       BOOST_ILMIN_175MA,
>> +       BOOST_ILMIN_200MA,
>> +       BOOST_ILMIN_225MA,
>> +       BOOST_ILMIN_250MA,
>> +};
>> +
>> +struct rk808_board {
>> +       int wakeup;
>> +       bool pm_off;
>> +       struct regulator_init_data *rk808_init_data[RK808_NUM_REGULATORS];
>> +       struct device_node *of_node[RK808_NUM_REGULATORS];
>> +       unsigned int dcdc_slp_voltage[3]; /* buckx_voltage in uV */
>> +       unsigned int ldo_slp_voltage[7];
>> +};
>> +
>> +struct rk808 {
>> +       struct rk808_board *pdata;
>> +       struct i2c_client *i2c;
>> +       int num_regulators;
>> +       struct regulator_dev **rdev;
>> +       struct regmap_irq_chip_data *irq_data;
>> +       struct regmap *regmap;
>> +       unsigned int dcdc_slp_voltage[3]; /* buckx_voltage in uV */
>> +       unsigned int ldo_slp_voltage[7];
>> +};
>> +#endif /* __LINUX_REGULATOR_rk808_H */
>
> I didn't do a thorough review, just compared to Lee's old feedback.
> Maybe a good idea to get in the habit to responding to others comments
> with "Done" so others know you have addressed each comment?
>
> -Doug
>
>
>


