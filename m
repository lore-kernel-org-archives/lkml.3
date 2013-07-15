Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab3GOBX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 21:23:29 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:13660
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753739Ab3GOBXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 21:23:21 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VS8(zz98dI1432Ib922lc8k8b9ckzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 15 Jul 2013 09:22:36 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Robin Gong <b38343@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <rob@landley.net>
Subject: Re: [PATCH v2] regulator: pfuze100: add pfuze100 regulator driver
Message-ID: <20130715012233.GA2730@S2101-09.ap.freescale.net>
References: <1373604855-17714-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1373604855-17714-1-git-send-email-b38343@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch looks good.  Comments below are mostly random coding style
nitpicks.

On Fri, Jul 12, 2013 at 12:54:15PM +0800, Robin Gong wrote:
> Add pfuze100 regulator driver.
> 
> Signed-off-by: Robin Gong <b38343@freescale.com>
> ---
>  .../devicetree/bindings/regulator/pfuze100.txt     |  113 +++++
>  drivers/regulator/Kconfig                          |    7 +
>  drivers/regulator/Makefile                         |    1 +
>  drivers/regulator/pfuze100-regulator.c             |  489 ++++++++++++++++++++
>  include/linux/regulator/pfuze.h                    |   49 ++

We should probably name the header in the same way as driver file, so
pfuze100.h?

>  5 files changed, 659 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/regulator/pfuze100.txt
>  create mode 100644 drivers/regulator/pfuze100-regulator.c
>  create mode 100644 include/linux/regulator/pfuze.h
> 
> diff --git a/Documentation/devicetree/bindings/regulator/pfuze100.txt b/Documentation/devicetree/bindings/regulator/pfuze100.txt
> new file mode 100644
> index 0000000..d9fc752
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/pfuze100.txt
> @@ -0,0 +1,113 @@
> +PFUZE100 family of regulators
> +
> +Required properties:
> +- compatible: "fsl,pfuze100"
> +- reg: I2C slave address
> +- regulators: This is the list of child nodes that specify the regulator
> +  initialization data for defined regulators. Please refer to below doc
> +  Documentation/devicetree/bindings/regulator/regulator.txt.
> +
> +  The valid names for regulators are:
> +  sw1ab,sw1c,sw2,sw3a,sw3b,sw4,swbst,vsnvs,vrefddr,vgen1~vgen6
> +
> +Each regulator is defined using the standard binding for regulators.
> +
> +Example:
> +
> +	pmic: pfuze100@08 {
> +		compatible = "fsl,pfuze100";
> +		reg = <0x08>;
> +
> +		regulators {
> +			sw1a_reg: sw1ab {
> +				regulator-min-microvolt = <1100000>;
> +				regulator-max-microvolt = <1875000>;
> +				regulator-boot-on;
> +				regulator-always-on;
> +				regulator-ramp-delay = <6250>;
> +			};
> +
> +			sw1c_reg: sw1c {
> +				regulator-min-microvolt = <110000>;
> +				regulator-max-microvolt = <1875000>;
> +				regulator-boot-on;
> +				regulator-always-on;
> +			};
> +
> +			sw2_reg: sw2 {
> +				regulator-min-microvolt = <800000>;
> +				regulator-max-microvolt = <3300000>;
> +				regulator-boot-on;
> +				regulator-always-on;
> +			};
> +
> +			sw3a_reg: sw3a {
> +				regulator-min-microvolt = <400000>;
> +				regulator-max-microvolt = <1975000>;
> +				regulator-boot-on;
> +				regulator-always-on;
> +			};
> +
> +			sw3b_reg: sw3b {
> +				regulator-min-microvolt = <400000>;
> +				regulator-max-microvolt = <1975000>;
> +				regulator-boot-on;
> +				regulator-always-on;
> +			};
> +
> +			sw4_reg: sw4 {
> +				regulator-min-microvolt = <800000>;
> +				regulator-max-microvolt = <3300000>;
> +			};
> +
> +			swbst_reg: swbst {
> +				regulator-min-microvolt = <5000000>;
> +				regulator-max-microvolt = <5150000>;
> +			};
> +
> +			snvs_reg: vsnvs {
> +				regulator-min-microvolt = <1200000>;
> +				regulator-max-microvolt = <3000000>;
> +				regulator-boot-on;
> +				regulator-always-on;
> +			};
> +
> +			vref_reg: vrefddr {
> +				regulator-boot-on;
> +				regulator-always-on;
> +			};
> +
> +			vgen1_reg: vgen1 {
> +				regulator-min-microvolt = <800000>;
> +				regulator-max-microvolt = <1550000>;
> +			};
> +
> +			vgen2_reg: vgen2 {
> +				regulator-min-microvolt = <800000>;
> +				regulator-max-microvolt = <1550000>;
> +			};
> +
> +			vgen3_reg: vgen3 {
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <3300000>;
> +			};
> +
> +			vgen4_reg: vgen4 {
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <3300000>;
> +				regulator-always-on;
> +			};
> +
> +			vgen5_reg: vgen5 {
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <3300000>;
> +				regulator-always-on;
> +			};
> +
> +			vgen6_reg: vgen6 {
> +				regulator-min-microvolt = <1800000>;
> +				regulator-max-microvolt = <3300000>;
> +				regulator-always-on;
> +			};
> +		};
> +	};
> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> index f1e6ad9..f913172 100644
> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -158,6 +158,13 @@ config REGULATOR_MC13892
>  	  Say y here to support the regulators found on the Freescale MC13892
>  	  PMIC.
>  
> +config REGULATOR_PFUZE100
> +	tristate "Support regulators on Freescale PFUZE100 PMIC"
> +	depends on I2C
> +	help
> +	  Say y here to support the regulators found on the Freescale PFUZE100
> +	  PMIC.
> +
>  config REGULATOR_ISL6271A
>  	tristate "Intersil ISL6271A Power regulator"
>  	depends on I2C
> diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
> index ba4a3cf..68cc298 100644
> --- a/drivers/regulator/Makefile
> +++ b/drivers/regulator/Makefile
> @@ -72,6 +72,7 @@ obj-$(CONFIG_REGULATOR_WM831X) += wm831x-ldo.o
>  obj-$(CONFIG_REGULATOR_WM8350) += wm8350-regulator.o
>  obj-$(CONFIG_REGULATOR_WM8400) += wm8400-regulator.o
>  obj-$(CONFIG_REGULATOR_WM8994) += wm8994-regulator.o
> +obj-$(CONFIG_REGULATOR_PFUZE100) += pfuze100-regulator.o
>  
>  
>  ccflags-$(CONFIG_REGULATOR_DEBUG) += -DDEBUG
> diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
> new file mode 100644
> index 0000000..9fc6406
> --- /dev/null
> +++ b/drivers/regulator/pfuze100-regulator.c
> @@ -0,0 +1,489 @@
> +/*
> + * Copyright (C) 2011-2013 Freescale Semiconductor, Inc. All Rights Reserved.
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
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/err.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/regulator/of_regulator.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/driver.h>
> +#include <linux/regulator/machine.h>
> +#include <linux/regulator/pfuze.h>
> +#include <linux/i2c.h>
> +#include <linux/slab.h>
> +#include <linux/regmap.h>
> +
> +
> +#define PFUZE_NUMREGS		128
> +#define PFUZE100_VOL_OFFSET	0
> +#define PFUZE100_STANDBY_OFFSET	1
> +#define PFUZE100_MODE_OFFSET	3
> +#define PFUZE100_CONF_OFFSET	4
> +
> +#define PFUZE100_DEVICEID	0x0
> +#define PFUZE100_REVID		0x3
> +#define PFUZE100_FABID		0x3
> +
> +#define PFUZE100_SW1ABVOL	0x20
> +#define PFUZE100_SW1CVOL	0x2e
> +#define PFUZE100_SW2VOL		0x35
> +#define PFUZE100_SW3AVOL	0x3c
> +#define PFUZE100_SW3BVOL	0x43
> +#define PFUZE100_SW4VOL		0x4a
> +#define PFUZE100_SWBSTCON1	0x66
> +#define PFUZE100_VREFDDRCON	0x6a
> +#define PFUZE100_VSNVSVOL	0x6b
> +#define PFUZE100_VGEN1VOL	0x6c
> +#define PFUZE100_VGEN2VOL	0x6d
> +#define PFUZE100_VGEN3VOL	0x6e
> +#define PFUZE100_VGEN4VOL	0x6f
> +#define PFUZE100_VGEN5VOL	0x70
> +#define PFUZE100_VGEN6VOL	0x71
> +
> +struct pfuze_regulator {
> +	struct regulator_desc desc;
> +	unsigned char stby_reg;
> +	unsigned char stby_mask;
> +};
> +
> +enum pfuze_id {
> +	PFUZE_ID_PFUZE100,
> +	PFUZE_ID_INVALID,
> +};

Have a blank line here.

Is there any other valid ID other than PFUZE_ID_PFUZE100?  If not, we
may not need this pfuze_id at all.  All the use of it is in
pfuze_identify() for dev_info output.

> +struct pfuze_chip {
> +	struct pfuze_regulator *regulators_desc;
> +	int num_regulators;
> +	struct regmap *regmap;
> +	struct device *dev;
> +	enum pfuze_id chip;	/*chip type*/

/* comment */

Also I do not see much necessity of this member.  It's only used in
function pfuze_identify(), from what I can see.

> +	struct regulator_dev *regulators[];
> +};
> +
> +static struct regulator_ops pfuze100_ldo_regulator_ops;
> +static struct regulator_ops pfuze100_fixed_regulator_ops;
> +static struct regulator_ops pfuze100_sw_regulator_ops;
> +static struct regulator_ops pfuze100_swb_regulator_ops;
> +
> +static const int pfuze100_swbst[] = {
> +	5000000, 5050000, 5100000, 5150000,
> +};
> +
> +static const int pfuze100_vsnvs[] = {
> +	1000000, 1100000, 1200000, 1300000, 1500000, 1800000, 3000000,
> +};
> +
> +static const struct i2c_device_id pfuze_device_id[] = {
> +	{.name = "pfuze100", .driver_data = PFUZE_ID_PFUZE100},

You do not use .driver_data in the driver at all, and can just drop it.

> +	{},
> +};
> +MODULE_DEVICE_TABLE(i2c, pfuze_device_id);
> +
> +

Drop one blank line.

> +static const struct of_device_id pfuze_dt_ids[] = {
> +	{ .compatible = "fsl,pfuze100", .data = (void *)PFUZE_ID_PFUZE100},

You do not use .data in the driver at all, and can just drop it.

> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, pfuze_dt_ids);
> +
> +#define PFUZE100_FIXED_REG(_name, base, voltage)	\
> +	[PFUZE100_ ## _name] = {	\
> +		.desc = {	\
> +			.name = #_name,	\
> +			.n_voltages = 1,	\
> +			.ops = &pfuze100_fixed_regulator_ops,	\
> +			.type = REGULATOR_VOLTAGE,	\
> +			.id = PFUZE100_ ## _name,	\
> +			.owner = THIS_MODULE,	\
> +			.min_uV = (voltage),	\
> +			.enable_reg = (base),	\
> +			.enable_mask = 0x10,	\
> +		},	\
> +	}
> +
> +#define PFUZE100_SW_REG(_name, base, min, max, step)	\
> +	[PFUZE100_ ## _name] = {	\
> +		.desc = {	\
> +			.name = #_name,\
> +			.n_voltages = ((max) - (min)) / (step) + 1,	\
> +			.ops = &pfuze100_sw_regulator_ops,	\
> +			.type = REGULATOR_VOLTAGE,	\
> +			.id = PFUZE100_ ## _name,	\
> +			.owner = THIS_MODULE,	\
> +			.min_uV = (min),	\
> +			.uV_step = (step),	\
> +			.vsel_reg = (base) + PFUZE100_VOL_OFFSET,	\
> +			.vsel_mask = 0x3f,	\
> +		},	\
> +		.stby_reg = (base) + PFUZE100_STANDBY_OFFSET,	\
> +		.stby_mask = 0x3f,	\
> +	}
> +
> +#define PFUZE100_SWB_REG(_name, base, mask, voltages)	\
> +	[PFUZE100_ ## _name] = {	\
> +		.desc = {	\
> +			.name = #_name,	\
> +			.n_voltages = ARRAY_SIZE(voltages),	\
> +			.ops = &pfuze100_swb_regulator_ops,	\
> +			.type = REGULATOR_VOLTAGE,	\
> +			.id = PFUZE100_ ## _name,	\
> +			.owner = THIS_MODULE,	\
> +			.volt_table = voltages,	\
> +			.vsel_reg = (base),	\
> +			.vsel_mask = (mask),	\
> +		},	\
> +	}
> +
> +#define PFUZE100_VGEN_REG(_name, base, min, max, step)	\
> +	[PFUZE100_ ## _name] = {	\
> +		.desc = {	\
> +			.name = #_name,	\
> +			.n_voltages = ((max) - (min)) / (step) + 1,	\
> +			.ops = &pfuze100_ldo_regulator_ops,	\
> +			.type = REGULATOR_VOLTAGE,	\
> +			.id = PFUZE100_ ## _name,	\
> +			.owner = THIS_MODULE,	\
> +			.min_uV = (min),	\
> +			.uV_step = (step),	\
> +			.vsel_reg = (base),	\
> +			.vsel_mask = 0xf,	\
> +			.enable_reg = (base),	\
> +			.enable_mask = 0x10,	\
> +		},	\
> +		.stby_reg = (base),	\
> +		.stby_mask = 0x20,	\
> +	}
> +
> +static struct pfuze_regulator pfuze100_regulators[] = {
> +	PFUZE100_SW_REG(SW1AB, PFUZE100_SW1ABVOL, 300000, 1875000, 25000),
> +	PFUZE100_SW_REG(SW1C, PFUZE100_SW1CVOL, 300000, 1875000, 25000),
> +	PFUZE100_SW_REG(SW2, PFUZE100_SW2VOL, 400000, 1975000, 25000),
> +	PFUZE100_SW_REG(SW3A, PFUZE100_SW3AVOL, 400000, 1975000, 25000),
> +	PFUZE100_SW_REG(SW3B, PFUZE100_SW3BVOL, 400000, 1975000, 25000),
> +	PFUZE100_SW_REG(SW4, PFUZE100_SW4VOL, 400000, 1975000, 25000),
> +	PFUZE100_SWB_REG(SWBST, PFUZE100_SWBSTCON1, 0x3 , pfuze100_swbst),
> +	PFUZE100_SWB_REG(VSNVS, PFUZE100_VSNVSVOL, 0x7, pfuze100_vsnvs),
> +	PFUZE100_FIXED_REG(VREFDDR, PFUZE100_VREFDDRCON, 750000),
> +	PFUZE100_VGEN_REG(VGEN1, PFUZE100_VGEN1VOL, 800000, 1550000, 50000),
> +	PFUZE100_VGEN_REG(VGEN2, PFUZE100_VGEN2VOL, 800000, 1550000, 50000),
> +	PFUZE100_VGEN_REG(VGEN3, PFUZE100_VGEN3VOL, 1800000, 3300000, 100000),
> +	PFUZE100_VGEN_REG(VGEN4, PFUZE100_VGEN4VOL, 1800000, 3300000, 100000),
> +	PFUZE100_VGEN_REG(VGEN5, PFUZE100_VGEN5VOL, 1800000, 3300000, 100000),
> +	PFUZE100_VGEN_REG(VGEN6, PFUZE100_VGEN6VOL, 1800000, 3300000, 100000),
> +};
> +
> +

One blank line is enough.

> +static int pfuze100_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
> +{
> +	struct pfuze_chip *pfuze100 = rdev_get_drvdata(rdev);
> +	int id = pfuze100->regulators_desc->desc.id;
> +	unsigned int val, ramp_bits, reg;
> +	int ret;
> +
> +	if (id < PFUZE100_SWBST) {
> +		if (id == PFUZE100_SW1AB)
> +			reg = PFUZE100_SW1ABVOL;
> +		else
> +			reg = PFUZE100_SW1CVOL + (id - PFUZE100_SW1C) * 7;
> +		regmap_read(pfuze100->regmap, reg, &val);
> +		if (val & 0x40)
> +			ramp_delay = 50000 / (4 * ramp_delay);
> +		else
> +			ramp_delay = 25000 / (2 * ramp_delay);
> +		if (id <= PFUZE100_SW1C)
> +			ramp_delay = 25000 / (2 * ramp_delay);
> +		ramp_bits = (ramp_delay >> 1) - (ramp_delay >> 3);
> +		ret = regmap_update_bits(pfuze100->regmap, reg + 4 , 0xc0,
> +				ramp_bits << 6);
> +		if (ret < 0)
> +			dev_err(pfuze100->dev, "SW ramp failed,err %d\nr", ret);
> +
> +	} else
> +		ret = -EACCES;

	} else {
		ret = -EACCES;
	}

> +	return ret;
> +}
> +
> +static struct regulator_ops pfuze100_ldo_regulator_ops = {
> +	.enable = regulator_enable_regmap,
> +	.disable = regulator_disable_regmap,
> +	.is_enabled = regulator_is_enabled_regmap,
> +	.list_voltage = regulator_list_voltage_linear,
> +	.set_voltage_sel = regulator_set_voltage_sel_regmap,
> +	.get_voltage_sel = regulator_get_voltage_sel_regmap,
> +};
> +
> +static struct regulator_ops pfuze100_fixed_regulator_ops = {
> +	.list_voltage = regulator_list_voltage_linear,
> +};
> +
> +static struct regulator_ops pfuze100_sw_regulator_ops = {
> +	.list_voltage = regulator_list_voltage_linear,
> +	.set_voltage_sel = regulator_set_voltage_sel_regmap,
> +	.get_voltage_sel = regulator_get_voltage_sel_regmap,
> +	.set_voltage_time_sel = regulator_set_voltage_time_sel,
> +	.set_ramp_delay = pfuze100_set_ramp_delay,
> +};
> +
> +static struct regulator_ops pfuze100_swb_regulator_ops = {
> +	.list_voltage = regulator_list_voltage_table,
> +	.set_voltage_sel = regulator_set_voltage_sel_regmap,
> +	.get_voltage_sel = regulator_get_voltage_sel_regmap,
> +
> +};
> +
> +#ifdef CONFIG_OF
> +
> +static int  pfuze_get_num_regulators_dt(struct device *dev)
             ^^

One space is enough.

> +{
> +	struct device_node *parent, *child;
> +	int num = 0;
> +
> +	of_node_get(dev->parent->of_node);
> +	parent = of_find_node_by_name(dev->parent->of_node, "regulators");
> +	if (!parent)
> +		return -ENODEV;
> +
> +	for_each_child_of_node(parent, child)
> +		num++;
> +
> +	return num;
> +}
> +
> +static struct pfuze_regulator_init_data *pfuze_parse_regulators_dt(
> +	struct pfuze_chip *chip, struct pfuze_regulator *regulators,
> +	int num_regulators)
> +{
> +	struct device *dev = chip->dev;
> +	struct pfuze_regulator_init_data *data, *p;
> +	struct device_node *parent, *child;
> +	int i;
> +
> +	of_node_get(dev->parent->of_node);
> +	parent = of_find_node_by_name(dev->parent->of_node, "regulators");
> +	if (!parent)
> +		return NULL;
> +
> +	data = devm_kzalloc(dev, sizeof(*data) * chip->num_regulators,
> +			    GFP_KERNEL);
> +	if (!data)
> +		return NULL;
> +	p = data;
> +	for_each_child_of_node(parent, child) {
> +		for (i = 0; i < num_regulators; i++) {
> +			if (!of_node_cmp(child->name,
> +					 regulators[i].desc.name)) {
> +				p->id = i;
> +				p->init_data = of_get_regulator_init_data(
> +							dev, child);
> +				p->node = child;
> +				p++;
> +				break;
> +			}
> +		}
> +	}
> +
> +	return data;
> +}
> +
> +#else
> +
> +static int pfuze_get_num_regulators_dt(struct device *dev)
> +{
> +		return -ENODEV;

One tab is enough.

> +
> +}
> +
> +static struct pfuze_regulator_init_data *pfuze_parse_regulators_dt(
> +	struct pfuze_chip *chip, struct pfuze_regulator *regulators,
> +	int num_regulators)
> +{
> +		return NULL;

Ditto

> +
> +}

Good.  I like the style not putting blank line.  But please have #else
and the according #ifdef be consistent with it.

> +#endif
> +
> +static int pfuze_identify(struct pfuze_chip *pfuze_chip)
> +{
> +	unsigned int value;
> +	int ret;

So the code is written without any blank line through the function.  I
think it will be much more readable if you have blank lines as I suggest
as below.

Blank line here.

> +	ret = regmap_read(pfuze_chip->regmap, PFUZE100_DEVICEID, &value);
> +	if (ret)
> +		return ret;

Blank line here.

> +	switch (value & 0x0f) {
> +	case 0x0:
> +		pfuze_chip->chip = PFUZE_ID_PFUZE100;
> +		break;
> +	default:
> +		pfuze_chip->chip = PFUZE_ID_INVALID;
> +		dev_warn(pfuze_chip->dev, "Illegal ID: %x\n", value);
> +		break;
> +	}

Blank line here.

> +	ret = regmap_read(pfuze_chip->regmap, PFUZE100_REVID, &value);
> +	if (ret)
> +		return ret;

Blank line here.

> +	dev_info(pfuze_chip->dev,
> +		 "ID: %d,Full lay: %x ,Metal lay: %x\n",

Space should be put after comma, so it should look like:

		 "ID: %d, Full lay: %x, Metal lay: %x\n",

> +		 pfuze_chip->chip, (value & 0xf0) >> 4, value & 0x0f);

Blank line here.

> +	ret = regmap_read(pfuze_chip->regmap, PFUZE100_FABID, &value);
> +	if (ret)
> +		return ret;

Blank line here.

> +	dev_info(pfuze_chip->dev, "FAB: %x ,FIN: %x\n",

Space after comma.

> +		 (value & 0xc) >> 2, value & 0x3);

Blank line here.

> +	return (pfuze_chip->chip == PFUZE_ID_INVALID) ? -ENODEV : 0;
> +}
> +
> +static struct regmap_config pfuze_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.max_register = PFUZE_NUMREGS,
> +	.cache_type = REGCACHE_RBTREE,
> +};
> +
> +static int pfuze100_regulator_probe(struct i2c_client *client,
> +				    const struct i2c_device_id *id)
> +{
> +	const struct of_device_id *of_id;
> +	struct i2c_driver *idrv = to_i2c_driver(client->dev.driver);
> +	struct pfuze_chip *pfuze_chip;
> +	struct pfuze_regulator_platform_data *pdata =
> +	    dev_get_platdata(&client->dev);
> +	struct pfuze_regulator_init_data *pfuze_data;
> +	struct regulator_config config = { };
> +	int i, ret;
> +	int num_regulators = 0;
> +
> +	of_id = of_match_device(pfuze_dt_ids, &client->dev);
> +	if (of_id)
> +		idrv->id_table = (const struct i2c_device_id *) of_id->data;

You do not use it at all from what I can see.  So drop these.

> +
> +	num_regulators = pfuze_get_num_regulators_dt(&client->dev);
> +	if (num_regulators <= 0 && pdata)
> +		num_regulators = pdata->num_regulators;
> +	if (num_regulators <= 0) {
> +		dev_err(&client->dev, "no platform data,please add it!\n");

Have a space after comma.

> +		ret = -EINVAL;
> +		return ret;
> +	}
> +
> +	pfuze_chip = devm_kzalloc(&client->dev, sizeof(*pfuze_chip) +
> +		       num_regulators * sizeof(pfuze_chip->regulators[0]),
> +			GFP_KERNEL);
> +	if (!pfuze_chip) {
> +		dev_err(&client->dev, "%s(): Memory allocation failed\n",
> +						__func__);

I'm not a fan of print memory allocation failure because error code
-ENOMEM is clear enough to tell that.  If you really want to have it,
at least drop __func__, since dev_err() already has some context.  And
other dev_err() in the function does not have it.

> +		return -ENOMEM;
> +	}
> +
> +	dev_set_drvdata(&client->dev, pfuze_chip);
> +	pfuze_chip->dev = &client->dev;
> +
> +	pfuze_chip->regmap = devm_regmap_init_i2c(client, &pfuze_regmap_config);
> +	if (IS_ERR(pfuze_chip->regmap)) {
> +		ret = PTR_ERR(pfuze_chip->regmap);
> +		dev_err(&client->dev,
> +			"%s(): regmap allocation failed with err %d\n",
> +			__func__, ret);
> +		return ret;
> +	}
> +
> +	ret = pfuze_identify(pfuze_chip);
> +	if (ret) {
> +		dev_err(&client->dev, "unrecognized pfuze chip ID!\n");
> +		return ret;
> +	}
> +
> +	pfuze_chip->num_regulators = num_regulators;
> +	pfuze_chip->regulators_desc = pfuze100_regulators;
> +	pfuze_data = pfuze_parse_regulators_dt(pfuze_chip, pfuze100_regulators,
> +					ARRAY_SIZE(pfuze100_regulators));
> +
> +	for (i = 0; i < num_regulators; i++) {
> +		struct regulator_init_data *init_data;
> +		struct regulator_desc *desc;
> +		struct device_node *node = NULL;
> +		int val;
> +		int id;
> +
> +		if (pfuze_data) {
> +			id = pfuze_data[i].id;
> +			init_data = pfuze_data[i].init_data;
> +			node = pfuze_data[i].node;
> +		} else {
> +			id = pdata->regulators[i].id;
> +			init_data = pdata->regulators[i].init_data;
> +		}
> +
> +		desc = &pfuze100_regulators[id].desc;
> +
> +		/* SW2~SW4 high bit check and modify the voltage value table */
> +		if (i > PFUZE100_SW1C && i < PFUZE100_SWBST) {
> +			regmap_read(pfuze_chip->regmap, PFUZE100_SW2VOL +
> +					(i - PFUZE100_SW2) * 7, &val);
> +			if (val & 0x40) {
> +				pfuze100_regulators[id].desc.min_uV = 800000;
> +				pfuze100_regulators[id].desc.uV_step = 50000;
> +			}
> +		}
> +		config.dev = &client->dev;
> +		config.init_data = init_data;
> +		config.driver_data = pfuze_chip;
> +		config.of_node = node;
> +
> +		pfuze_chip->regulators[i] = regulator_register(desc, &config);
> +		if (IS_ERR(pfuze_chip->regulators[i])) {
> +			dev_err(&client->dev, "register regulator%s failed\n",
> +				pfuze100_regulators[i].desc.name);
> +			ret = PTR_ERR(pfuze_chip->regulators[i]);
> +			while (--i >= 0)
> +				regulator_unregister(pfuze_chip->regulators[i]);
> +			return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int pfuze100_regulator_remove(struct i2c_client *client)
> +{
> +	int i;
> +	struct pfuze_chip *pfuze_chip = dev_get_drvdata(&client->dev);
> +
> +	for (i = 0; i < pfuze_chip->num_regulators; i++)
> +		regulator_unregister(pfuze_chip->regulators[i]);
> +	kfree(pfuze_chip);
> +
> +	return 0;
> +}
> +
> +static struct i2c_driver pfuze_driver = {
> +	.id_table = pfuze_device_id,
> +	.driver = {
> +		.name = "pfuze100-regulator",
> +		.owner = THIS_MODULE,
> +		.of_match_table = pfuze_dt_ids,
> +	},
> +	.probe = pfuze100_regulator_probe,
> +	.remove = pfuze100_regulator_remove,
> +};
> +

Drop this blank line.

> +module_i2c_driver(pfuze_driver);
> +
> +MODULE_AUTHOR("Robin Gong <b38343@freescale.com>");
> +MODULE_DESCRIPTION("Regulator Driver for Freescale PFUZE100 PMIC");
> +MODULE_ALIAS("pfuze100-regulator");
> diff --git a/include/linux/regulator/pfuze.h b/include/linux/regulator/pfuze.h
> new file mode 100644
> index 0000000..9791024
> --- /dev/null
> +++ b/include/linux/regulator/pfuze.h
> @@ -0,0 +1,49 @@
> +/*
> + * Copyright (C) 2011-2013 Freescale Semiconductor, Inc. All Rights Reserved.
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
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + */
> +#ifndef __LINUX_REG_PFUZE_H
> +#define __LINUX_REG_PFUZE_H

Remember to update it, if you agree to rename the header at all.

> +
> +#define PFUZE100_SW1AB		0
> +#define PFUZE100_SW1C		1
> +#define PFUZE100_SW2		2
> +#define PFUZE100_SW3A		3
> +#define PFUZE100_SW3B		4
> +#define PFUZE100_SW4		5
> +#define PFUZE100_SWBST		6
> +#define PFUZE100_VSNVS		7
> +#define PFUZE100_VREFDDR	8
> +#define PFUZE100_VGEN1		9
> +#define PFUZE100_VGEN2		10
> +#define PFUZE100_VGEN3		11
> +#define PFUZE100_VGEN4		12
> +#define PFUZE100_VGEN5		13
> +#define PFUZE100_VGEN6		14
> +
> +

Drop one bank line.

> +struct regulator_init_data;

Have a bank line.

> +struct pfuze_regulator_init_data {
> +	int id;
> +	struct regulator_init_data *init_data;
> +	struct device_node *node;
> +};

Have a bank line.

> +struct pfuze_regulator_platform_data {
> +	int num_regulators;
> +	struct pfuze_regulator_init_data *regulators;
> +};
> +
> +#endif

I generally recommend to have a /* macro used in the beginning */
after it.

Shawn

> -- 
> 1.7.5.4
> 
> 

