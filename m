Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbbASJyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:54:32 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:62826 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbbASJya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:54:30 -0500
Date: Mon, 19 Jan 2015 09:54:23 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Steve Twiss <stwiss.opensource@diasemi.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, DT <devicetree@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Support Opensource <support.opensource@diasemi.com>
Subject: Re: [PATCH V1] mfd: da9063: Add device tree support
Message-ID: <20150119095423.GM21886@x1>
References: <201501141438.t0EEcMBg010491@swsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201501141438.t0EEcMBg010491@swsrvapps-01.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015, Steve Twiss wrote:

> From: Steve Twiss <stwiss.opensource@diasemi.com>
> 
> Add device tree support for DA9063 regulators; Real-Time Clock
> and Watchdog.
> 
> 
> Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
> 
> ---
> Checks performed with linux-next/v3.19-rc4/scripts/checkpatch.pl
>  da9063.txt                total: 0 errors, 0 warnings, 94 lines checked
>  da9063-core.c             total: 0 errors, 0 warnings, 192 lines checked
>  da9063-i2c.c              total: 0 errors, 0 warnings, 277 lines checked
>  core.h                    total: 0 errors, 0 warnings, 99 lines checked

There is no need to put this in here really.  It is assumed that
checkpatch.pl has been run and that no warnings/errors exists.

> This patch applies against linux-next and v3.19-rc4 
> 
> 
> 
>  Documentation/devicetree/bindings/mfd/da9063.txt | 94 ++++++++++++++++++++++++
>  drivers/mfd/da9063-core.c                        |  2 +
>  drivers/mfd/da9063-i2c.c                         | 11 +++
>  include/linux/mfd/da9063/core.h                  |  1 +
>  4 files changed, 108 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/da9063.txt
> 
> diff --git a/Documentation/devicetree/bindings/mfd/da9063.txt b/Documentation/devicetree/bindings/mfd/da9063.txt
> new file mode 100644
> index 0000000..ac26af4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/da9063.txt
> @@ -0,0 +1,94 @@
> +* Dialog DA9063 Power Management Integrated Circuit (PMIC)
> +
> +DA9093 consists of a large and varied group of sub-devices (I2C Only):
> +
> +Device                   Supply Names    Description
> +------                   ------------    -----------
> +da9063-regulator        :               : LDOs & BUCKs
> +da9063-rtc              :               : Real-Time Clock
> +da9063-watchdog         :               : Watchdog
> +
> +======
> +
> +Required properties:
> +
> +- compatible : Should be "dlg,da9063-ca", "dlg,da9063-bb" or/and
> +  "dlg,da9063-ad".

What are 'ca', 'bb' and 'ad'?

> +- reg : Specifies the I2C slave address (this defaults to 0x58 but it can be
> +  modified to match the chip's OTP settings).
> +- interrupt-parent : Specifies the reference to the interrupt controller for
> +  the DA9063.
> +- interrupts : IRQ line information.
> +- interrupt-controller
> +
> +Sub-nodes:
> +
> +- regulators : This node defines the settings for the LDOs and BUCKs. The
> +  DA9063 regulators are bound using their names listed below:
> +
> +    bcore1    : BUCK CORE1
> +    bcore2    : BUCK CORE2
> +    bpro      : BUCK PRO
> +    bmem      : BUCK MEM
> +    bio       : BUCK IO
> +    bperi     : BUCK PERI
> +    ldo1      : LDO_1
> +    ldo2      : LDO_2
> +    ldo3      : LDO_3
> +    ldo4      : LDO_4
> +    ldo5      : LDO_5
> +    ldo6      : LDO_6
> +    ldo7      : LDO_7
> +    ldo8      : LDO_8
> +    ldo9      : LDO_9
> +    ldo10     : LDO_10
> +    ldo11     : LDO_11
> +
> +  The component follows the standard regulator framework and the bindings
> +  details of individual regulator device can be found in:
> +  Documentation/devicetree/bindings/regulator/regulator.txt
> +
> +- rtc : This node defines settings for the Real-Time Clock associated with
> +  the DA9063. There are currently no entries in this binding, however
> +  compatible = "dlg,da9063-rtc" should be added if a node is created.
> +
> +- watchdog : This node defines settings for the Watchdog timer associated
> +  with the DA9063. There are currently no entries in this binding, however
> +  compatible = "dlg,da9063-watchdog" should be added if a node is created.
> +
> +
> +Example:
> +
> +	pmic0: da9063@58 {
> +		compatible = "dlg,da9063-ca", "dlg,da9063-bb", "dlg,da9063-ad";
> +		reg = <0x58>;
> +		interrupt-parent = <&gpio6>;
> +		interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
> +		interrupt-controller;
> +
> +		rtc {
> +			compatible = "dlg,da9063-rtc";
> +		};
> +
> +		wdt {
> +			compatible = "dlg,da9063-watchdog";
> +		};
> +
> +		regulators {
> +			DA9063_BCORE1: bcore1 {
> +				regulator-name = "BCORE1";
> +				regulator-min-microvolt = <300000>;
> +				regulator-max-microvolt = <1570000>;
> +				regulator-min-microamp = <500000>;
> +				regulator-max-microamp = <2000000>;
> +				regulator-boot-on;
> +			};
> +			DA9063_LDO11: ldo11 {
> +				regulator-name = "LDO_11";
> +				regulator-min-microvolt = <900000>;
> +				regulator-max-microvolt = <3600000>;
> +				regulator-boot-on;
> +			};
> +		};
> +	};
> +
> diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
> index f38bc98..171ed7e 100644
> --- a/drivers/mfd/da9063-core.c
> +++ b/drivers/mfd/da9063-core.c
> @@ -85,6 +85,7 @@ static const struct mfd_cell da9063_devs[] = {
>  		.name		= DA9063_DRVNAME_LEDS,
>  	},
>  	{
> +		.of_compatible = "dlg,da9063-watchdog",

Can you put the of_compatible attribute at the end of the structure
please?

>  		.name		= DA9063_DRVNAME_WATCHDOG,
>  	},
>  	{
> @@ -98,6 +99,7 @@ static const struct mfd_cell da9063_devs[] = {
>  		.resources	= da9063_onkey_resources,
>  	},
>  	{
> +		.of_compatible = "dlg,da9063-rtc",

Same here.

>  		.name		= DA9063_DRVNAME_RTC,
>  		.num_resources	= ARRAY_SIZE(da9063_rtc_resources),
>  		.resources	= da9063_rtc_resources,
> diff --git a/drivers/mfd/da9063-i2c.c b/drivers/mfd/da9063-i2c.c
> index 21fd8d9..c4f5351 100644
> --- a/drivers/mfd/da9063-i2c.c
> +++ b/drivers/mfd/da9063-i2c.c
> @@ -25,6 +25,9 @@
>  #include <linux/mfd/da9063/pdata.h>
>  #include <linux/mfd/da9063/registers.h>
>  
> +#include <linux/of.h>
> +#include <linux/regulator/of_regulator.h>
> +
>  static const struct regmap_range da9063_ad_readable_ranges[] = {
>  	{
>  		.range_min = DA9063_REG_PAGE_CON,
> @@ -203,6 +206,13 @@ static struct regmap_config da9063_regmap_config = {
>  	.cache_type = REGCACHE_RBTREE,
>  };
>  
> +static const struct of_device_id da9063_dt_ids[] = {
> +	{ .compatible = "dlg,da9063-ad", },
> +	{ .compatible = "dlg,da9063-bb", },
> +	{ .compatible = "dlg,da9063-ca", },

Why is there a need to differientiae between 'ad', 'bb' and 'ca'
(whatever they are)?

> +	{ /* sentinel */ }

Nit: You can drop this comment.

> +};
> +MODULE_DEVICE_TABLE(of, da9063_dt_ids);
>  static int da9063_i2c_probe(struct i2c_client *i2c,
>  	const struct i2c_device_id *id)
>  {
> @@ -257,6 +267,7 @@ static struct i2c_driver da9063_i2c_driver = {
>  	.driver = {
>  		.name = "da9063",
>  		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(da9063_dt_ids),
>  	},
>  	.probe    = da9063_i2c_probe,
>  	.remove   = da9063_i2c_remove,
> diff --git a/include/linux/mfd/da9063/core.h b/include/linux/mfd/da9063/core.h
> index b92a326..79f4d82 100644
> --- a/include/linux/mfd/da9063/core.h
> +++ b/include/linux/mfd/da9063/core.h
> @@ -36,6 +36,7 @@ enum da9063_models {
>  enum da9063_variant_codes {
>  	PMIC_DA9063_AD = 0x3,
>  	PMIC_DA9063_BB = 0x5,
> +	PMIC_DA9063_CA = 0x6,
>  };
>  
>  /* Interrupts */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
