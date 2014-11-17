Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaKQKMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:12:48 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55731 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaKQKMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:12:45 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-d5-5469ca1a4314
Message-id: <5469CA11.3000409@samsung.com>
Date: Mon, 17 Nov 2014 11:12:33 +0100
From: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, lee.jones@linaro.org,
        broonie@kernel.org, mturquette@linaro.org, a.zummo@towertech.it
Cc: lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 2/5] regulator: s2mps11: Add support S2MPS13 regulator
 device
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-3-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1416184980-532-3-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xy7pSpzJDDF5MlbRYcvEqu8XUh0/Y
	LK5/ec5qMf/IOVaLPxNa2Swm3Z/AYvH6haHF2aY37Bb3vx5ltPh2pYPJ4vKuOWwWTydcZLM4
	3c1qcXHFFyYHPo+ds+6ye2xa1cnmcefaHjaPeScDPfq2rGL0mD7vJ5PH501yAexRXDYpqTmZ
	ZalF+nYJXBnfFs9nLjhQUzHlU10D48y0LkZODgkBE4npa/axQdhiEhfurQeyuTiEBJYySjTc
	+sAK4XxmlJja848RpIpXQEuief9MoCoODhYBVYnv77xBwmwCHhLTvvcwg9iiAhESV9bMgSoX
	lPgx+R4LyBwRgUZGiadLfoE5zAKnGSXWLljGBFIlLBAsse/AHLAzhARqJS4tbGAHsTkFXCT2
	NT1jBVnGLKAuMWVKLkiYWUBeYvOat8wTGAVmIdkxC6FqFpKqBYzMqxhFU0uTC4qT0nMN9YoT
	c4tL89L1kvNzNzFC4ubLDsbFx6wOMQpwMCrx8EocyAwRYk0sK67MPcQowcGsJML7+ThQiDcl
	sbIqtSg/vqg0J7X4ECMTB6dUA6Otz8adPLw2Qfq6SeeOH/ZUU+dfvO5lwU7fhLnx/w7MfH7s
	E9eJJf2H1+oUNqd2i13aqb5youWU6BVX0x3rKg797pyucC8ibumLyeJLnh9NZzinUF3dV3V7
	k7Hd0oSVfoybee8ydRVs4v+V9Pzqy4PsXFqTX7Ad4jROTX/x83ztc8ZVW63Cn0spsRRnJBpq
	MRcVJwIA8JZoinkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.11.2014 01:42, Chanwoo Choi wrote:
> This patch adds S2MPS13 regulator device to existing S2MPS11 device driver.
> The S2MPS13 has just different number of regulators from S2MPS14.
> The S2MPS13 regulator device includes LDO[1-40] and BUCK[1-10].
> 
> Cc: Mark Brown <broonie@kernel.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/mfd/sec-core.c              |  13 +++
>  drivers/regulator/Kconfig           |  10 +-
>  drivers/regulator/s2mps11.c         | 102 +++++++++++++++++++-
>  include/linux/mfd/samsung/core.h    |   1 +
>  include/linux/mfd/samsung/s2mps13.h | 186 ++++++++++++++++++++++++++++++++++++
>  5 files changed, 304 insertions(+), 8 deletions(-)
>  create mode 100644 include/linux/mfd/samsung/s2mps13.h
> 
> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index 48c0d4a..5b8527d 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -27,6 +27,7 @@
>  #include <linux/mfd/samsung/irq.h>
>  #include <linux/mfd/samsung/s2mpa01.h>
>  #include <linux/mfd/samsung/s2mps11.h>
> +#include <linux/mfd/samsung/s2mps13.h>
>  #include <linux/mfd/samsung/s2mps14.h>
>  #include <linux/mfd/samsung/s2mpu02.h>
>  #include <linux/mfd/samsung/s5m8763.h>
> @@ -207,6 +208,15 @@ static const struct regmap_config s2mps11_regmap_config = {
>  	.cache_type = REGCACHE_FLAT,
>  };
>  
> +static const struct regmap_config s2mps13_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +
> +	.max_register = S2MPS13_REG_LDODSCH5,
> +	.volatile_reg = s2mps11_volatile,
> +	.cache_type = REGCACHE_FLAT,
> +};
> +
>  static const struct regmap_config s2mps14_regmap_config = {
>  	.reg_bits = 8,
>  	.val_bits = 8,
> @@ -338,6 +348,9 @@ static int sec_pmic_probe(struct i2c_client *i2c,
>  	case S2MPS11X:
>  		regmap = &s2mps11_regmap_config;
>  		break;
> +	case S2MPS13X:
> +		regmap = &s2mps13_regmap_config;
> +		break;
>  	case S2MPS14X:
>  		regmap = &s2mps14_regmap_config;
>  		break;

Hi,

Shouldn't this (with header file) be part of previous patch (1/5)?

Rest looks fine:
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> index 55d7b7b..5e06134 100644
> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -529,13 +529,13 @@ config REGULATOR_S2MPA01
>  	 via I2C bus. S2MPA01 has 10 Bucks and 26 LDO outputs.
>  
>  config REGULATOR_S2MPS11
> -	tristate "Samsung S2MPS11/S2MPS14/S2MPU02 voltage regulator"
> +	tristate "Samsung S2MPS11/S2MPS13/S2MPS14/S2MPU02 voltage regulator"
>  	depends on MFD_SEC_CORE
>  	help
> -	 This driver supports a Samsung S2MPS11/S2MPS14/S2MPU02 voltage output
> -	 regulator via I2C bus. The chip is comprised of high efficient Buck
> -	 converters including Dual-Phase Buck converter, Buck-Boost converter,
> -	 various LDOs.
> +	 This driver supports a Samsung S2MPS11/S2MPS13/S2MPS14/S2MPU02 voltage
> +	 output regulator via I2C bus. The chip is comprised of high efficient
> +	 Buck converters including Dual-Phase Buck converter, Buck-Boost
> +	 converter, various LDOs.
>  
>  config REGULATOR_S5M8767
>  	tristate "Samsung S5M8767A voltage regulator"
> diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
> index adab82d..738dc77 100644
> --- a/drivers/regulator/s2mps11.c
> +++ b/drivers/regulator/s2mps11.c
> @@ -30,6 +30,7 @@
>  #include <linux/of_gpio.h>
>  #include <linux/mfd/samsung/core.h>
>  #include <linux/mfd/samsung/s2mps11.h>
> +#include <linux/mfd/samsung/s2mps13.h>
>  #include <linux/mfd/samsung/s2mps14.h>
>  #include <linux/mfd/samsung/s2mpu02.h>
>  
> @@ -45,10 +46,10 @@ struct s2mps11_info {
>  	enum sec_device_type dev_type;
>  
>  	/*
> -	 * One bit for each S2MPS14/S2MPU02 regulator whether the suspend mode
> -	 * was enabled.
> +	 * One bit for each S2MPS13/S2MPS14/S2MPU02 regulator whether
> +	 * the suspend mode was enabled.
>  	 */
> -	unsigned long long s2mps14_suspend_state:35;
> +	unsigned long long s2mps14_suspend_state:50;
>  
>  	/* Array of size rdev_num with GPIO-s for external sleep control */
>  	int *ext_control_gpio;
> @@ -369,12 +370,101 @@ static const struct regulator_desc s2mps11_regulators[] = {
>  	regulator_desc_s2mps11_buck6_10(10, MIN_750_MV, STEP_12_5_MV),
>  };
>  
> +static struct regulator_ops s2mps14_reg_ops;
> +
> +#define regulator_desc_s2mps13_ldo(num, min, step, min_sel) {	\
> +	.name		= "LDO"#num,				\
> +	.id		= S2MPS13_LDO##num,			\
> +	.ops		= &s2mps14_reg_ops,			\
> +	.type		= REGULATOR_VOLTAGE,			\
> +	.owner		= THIS_MODULE,				\
> +	.min_uV		= min,					\
> +	.uV_step	= step,					\
> +	.linear_min_sel	= min_sel,				\
> +	.n_voltages	= S2MPS14_LDO_N_VOLTAGES,		\
> +	.vsel_reg	= S2MPS13_REG_L1CTRL + num - 1,		\
> +	.vsel_mask	= S2MPS14_LDO_VSEL_MASK,		\
> +	.enable_reg	= S2MPS13_REG_L1CTRL + num - 1,		\
> +	.enable_mask	= S2MPS14_ENABLE_MASK			\
> +}
> +
> +#define regulator_desc_s2mps13_buck(num, min, step, min_sel) {	\
> +	.name		= "BUCK"#num,				\
> +	.id		= S2MPS13_BUCK##num,			\
> +	.ops		= &s2mps14_reg_ops,			\
> +	.type		= REGULATOR_VOLTAGE,			\
> +	.owner		= THIS_MODULE,				\
> +	.min_uV		= min,					\
> +	.uV_step	= step,					\
> +	.linear_min_sel	= min_sel,				\
> +	.n_voltages	= S2MPS14_BUCK_N_VOLTAGES,		\
> +	.ramp_delay	= S2MPS13_BUCK_RAMP_DELAY,		\
> +	.vsel_reg	= S2MPS13_REG_B1OUT + (num - 1) * 2,	\
> +	.vsel_mask	= S2MPS14_BUCK_VSEL_MASK,		\
> +	.enable_reg	= S2MPS13_REG_B1CTRL + (num - 1) * 2,	\
> +	.enable_mask	= S2MPS14_ENABLE_MASK			\
> +}
> +
> +static const struct regulator_desc s2mps13_regulators[] = {
> +	regulator_desc_s2mps13_ldo(1,  MIN_800_MV,  STEP_12_5_MV, 0x00),
> +	regulator_desc_s2mps13_ldo(2,  MIN_1400_MV, STEP_50_MV,   0x0C),
> +	regulator_desc_s2mps13_ldo(3,  MIN_1000_MV, STEP_25_MV,   0x08),
> +	regulator_desc_s2mps13_ldo(4,  MIN_800_MV,  STEP_12_5_MV, 0x00),
> +	regulator_desc_s2mps13_ldo(5,  MIN_800_MV,  STEP_12_5_MV, 0x00),
> +	regulator_desc_s2mps13_ldo(6,  MIN_800_MV,  STEP_12_5_MV, 0x00),
> +	regulator_desc_s2mps13_ldo(7,  MIN_1000_MV, STEP_25_MV,   0x08),
> +	regulator_desc_s2mps13_ldo(8,  MIN_1000_MV, STEP_25_MV,   0x08),
> +	regulator_desc_s2mps13_ldo(9,  MIN_1000_MV, STEP_25_MV,   0x08),
> +	regulator_desc_s2mps13_ldo(10, MIN_1400_MV, STEP_50_MV,   0x0C),
> +	regulator_desc_s2mps13_ldo(11, MIN_800_MV,  STEP_25_MV,   0x10),
> +	regulator_desc_s2mps13_ldo(12, MIN_800_MV,  STEP_25_MV,   0x10),
> +	regulator_desc_s2mps13_ldo(13, MIN_800_MV,  STEP_25_MV,   0x10),
> +	regulator_desc_s2mps13_ldo(14, MIN_800_MV,  STEP_12_5_MV, 0x00),
> +	regulator_desc_s2mps13_ldo(15, MIN_800_MV,  STEP_12_5_MV, 0x00),
> +	regulator_desc_s2mps13_ldo(16, MIN_1400_MV, STEP_50_MV,   0x0C),
> +	regulator_desc_s2mps13_ldo(17, MIN_1400_MV, STEP_50_MV,   0x0C),
> +	regulator_desc_s2mps13_ldo(18, MIN_1000_MV, STEP_25_MV,   0x08),
> +	regulator_desc_s2mps13_ldo(19, MIN_1000_MV, STEP_25_MV,   0x08),
> +	regulator_desc_s2mps13_ldo(20, MIN_1400_MV, STEP_50_MV,   0x0C),
> +	regulator_desc_s2mps13_ldo(21, MIN_1000_MV, STEP_25_MV,   0x08),
> +	regulator_desc_s2mps13_ldo(22, MIN_1000_MV, STEP_25_MV,   0x08),
> +	regulator_desc_s2mps13_ldo(23, MIN_800_MV,  STEP_12_5_MV, 0x00),
> +	regulator_desc_s2mps13_ldo(24, MIN_800_MV,  STEP_12_5_MV, 0x00),
> +	regulator_desc_s2mps13_ldo(25, MIN_1400_MV, STEP_50_MV,   0x0C),
> +	regulator_desc_s2mps13_ldo(26, MIN_1400_MV, STEP_50_MV,   0x0C),
> +	regulator_desc_s2mps13_ldo(27, MIN_1400_MV, STEP_50_MV,   0x0C),
> +	regulator_desc_s2mps13_ldo(28, MIN_1000_MV, STEP_25_MV,   0x08),
> +	regulator_desc_s2mps13_ldo(29, MIN_1400_MV, STEP_50_MV,   0x0C),
> +	regulator_desc_s2mps13_ldo(30, MIN_1400_MV, STEP_50_MV,   0x0C),
> +	regulator_desc_s2mps13_ldo(31, MIN_1000_MV, STEP_25_MV,   0x08),
> +	regulator_desc_s2mps13_ldo(32, MIN_1000_MV, STEP_25_MV,   0x08),
> +	regulator_desc_s2mps13_ldo(33, MIN_1400_MV, STEP_50_MV,   0x0C),
> +	regulator_desc_s2mps13_ldo(34, MIN_1000_MV, STEP_25_MV,   0x08),
> +	regulator_desc_s2mps13_ldo(35, MIN_1400_MV, STEP_50_MV,   0x0C),
> +	regulator_desc_s2mps13_ldo(36, MIN_800_MV,  STEP_12_5_MV, 0x00),
> +	regulator_desc_s2mps13_ldo(37, MIN_1000_MV, STEP_25_MV,   0x08),
> +	regulator_desc_s2mps13_ldo(38, MIN_1400_MV, STEP_50_MV,   0x0C),
> +	regulator_desc_s2mps13_ldo(39, MIN_1000_MV, STEP_25_MV,   0x08),
> +	regulator_desc_s2mps13_ldo(40, MIN_1400_MV, STEP_50_MV,   0x0C),
> +	regulator_desc_s2mps13_buck(1,  MIN_500_MV,  STEP_6_25_MV, 0x10),
> +	regulator_desc_s2mps13_buck(2,  MIN_500_MV,  STEP_6_25_MV, 0x10),
> +	regulator_desc_s2mps13_buck(3,  MIN_500_MV,  STEP_6_25_MV, 0x10),
> +	regulator_desc_s2mps13_buck(4,  MIN_500_MV,  STEP_6_25_MV, 0x10),
> +	regulator_desc_s2mps13_buck(5,  MIN_500_MV,  STEP_6_25_MV, 0x10),
> +	regulator_desc_s2mps13_buck(6,  MIN_500_MV,  STEP_6_25_MV, 0x10),
> +	regulator_desc_s2mps13_buck(7,  MIN_500_MV,  STEP_6_25_MV, 0x10),
> +	regulator_desc_s2mps13_buck(8,  MIN_1000_MV, STEP_12_5_MV, 0x20),
> +	regulator_desc_s2mps13_buck(9,  MIN_1000_MV, STEP_12_5_MV, 0x20),
> +	regulator_desc_s2mps13_buck(10, MIN_500_MV,  STEP_6_25_MV, 0x10),
> +};
> +
>  static int s2mps14_regulator_enable(struct regulator_dev *rdev)
>  {
>  	struct s2mps11_info *s2mps11 = rdev_get_drvdata(rdev);
>  	unsigned int val;
>  
>  	switch (s2mps11->dev_type) {
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		if (s2mps11->s2mps14_suspend_state & (1 << rdev_get_id(rdev)))
>  			val = S2MPS14_ENABLE_SUSPEND;
> @@ -406,6 +496,7 @@ static int s2mps14_regulator_set_suspend_disable(struct regulator_dev *rdev)
>  
>  	/* Below LDO should be always on or does not support suspend mode. */
>  	switch (s2mps11->dev_type) {
> +	case S2MPS13X:
>  	case S2MPS14X:
>  		switch (rdev_id) {
>  		case S2MPS14_LDO3:
> @@ -831,6 +922,10 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
>  		s2mps11->rdev_num = ARRAY_SIZE(s2mps11_regulators);
>  		regulators = s2mps11_regulators;
>  		break;
> +	case S2MPS13X:
> +		s2mps11->rdev_num = ARRAY_SIZE(s2mps13_regulators);
> +		regulators = s2mps13_regulators;
> +		break;
>  	case S2MPS14X:
>  		s2mps11->rdev_num = ARRAY_SIZE(s2mps14_regulators);
>  		regulators = s2mps14_regulators;
> @@ -927,6 +1022,7 @@ out:
>  
>  static const struct platform_device_id s2mps11_pmic_id[] = {
>  	{ "s2mps11-pmic", S2MPS11X},
> +	{ "s2mps13-pmic", S2MPS13X},
>  	{ "s2mps14-pmic", S2MPS14X},
>  	{ "s2mpu02-pmic", S2MPU02},
>  	{ },
> diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
> index 0c0343e..3fdb7cf 100644
> --- a/include/linux/mfd/samsung/core.h
> +++ b/include/linux/mfd/samsung/core.h
> @@ -28,6 +28,7 @@
>  #define MIN_800_MV		800000
>  #define MIN_750_MV		750000
>  #define MIN_600_MV		600000
> +#define MIN_500_MV		500000
>  
>  /* Macros to represent steps for LDO/BUCK */
>  #define STEP_50_MV		50000
> diff --git a/include/linux/mfd/samsung/s2mps13.h b/include/linux/mfd/samsung/s2mps13.h
> new file mode 100644
> index 0000000..ce5dda8
> --- /dev/null
> +++ b/include/linux/mfd/samsung/s2mps13.h
> @@ -0,0 +1,186 @@
> +/*
> + * s2mps13.h
> + *
> + * Copyright (c) 2014 Samsung Electronics Co., Ltd
> + *              http://www.samsung.com
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __LINUX_MFD_S2MPS13_H
> +#define __LINUX_MFD_S2MPS13_H
> +
> +/* S2MPS13 registers */
> +enum s2mps13_reg {
> +	S2MPS13_REG_ID,
> +	S2MPS13_REG_INT1,
> +	S2MPS13_REG_INT2,
> +	S2MPS13_REG_INT3,
> +	S2MPS13_REG_INT1M,
> +	S2MPS13_REG_INT2M,
> +	S2MPS13_REG_INT3M,
> +	S2MPS13_REG_ST1,
> +	S2MPS13_REG_ST2,
> +	S2MPS13_REG_PWRONSRC,
> +	S2MPS13_REG_OFFSRC,
> +	S2MPS13_REG_BU_CHG,
> +	S2MPS13_REG_RTCCTRL,
> +	S2MPS13_REG_CTRL1,
> +	S2MPS13_REG_CTRL2,
> +	S2MPS13_REG_RSVD1,
> +	S2MPS13_REG_RSVD2,
> +	S2MPS13_REG_RSVD3,
> +	S2MPS13_REG_RSVD4,
> +	S2MPS13_REG_RSVD5,
> +	S2MPS13_REG_RSVD6,
> +	S2MPS13_REG_CTRL3,
> +	S2MPS13_REG_RSVD7,
> +	S2MPS13_REG_RSVD8,
> +	S2MPS13_REG_WRSTBI,
> +	S2MPS13_REG_B1CTRL,
> +	S2MPS13_REG_B1OUT,
> +	S2MPS13_REG_B2CTRL,
> +	S2MPS13_REG_B2OUT,
> +	S2MPS13_REG_B3CTRL,
> +	S2MPS13_REG_B3OUT,
> +	S2MPS13_REG_B4CTRL,
> +	S2MPS13_REG_B4OUT,
> +	S2MPS13_REG_B5CTRL,
> +	S2MPS13_REG_B5OUT,
> +	S2MPS13_REG_B6CTRL,
> +	S2MPS13_REG_B6OUT,
> +	S2MPS13_REG_B7CTRL,
> +	S2MPS13_REG_B7OUT,
> +	S2MPS13_REG_B8CTRL,
> +	S2MPS13_REG_B8OUT,
> +	S2MPS13_REG_B9CTRL,
> +	S2MPS13_REG_B9OUT,
> +	S2MPS13_REG_B10CTRL,
> +	S2MPS13_REG_B10OUT,
> +	S2MPS13_REG_BB1CTRL,
> +	S2MPS13_REG_BB1OUT,
> +	S2MPS13_REG_BUCK_RAMP1,
> +	S2MPS13_REG_BUCK_RAMP2,
> +	S2MPS13_REG_LDO_DVS1,
> +	S2MPS13_REG_LDO_DVS2,
> +	S2MPS13_REG_LDO_DVS3,
> +	S2MPS13_REG_B6OUT2,
> +	S2MPS13_REG_L1CTRL,
> +	S2MPS13_REG_L2CTRL,
> +	S2MPS13_REG_L3CTRL,
> +	S2MPS13_REG_L4CTRL,
> +	S2MPS13_REG_L5CTRL,
> +	S2MPS13_REG_L6CTRL,
> +	S2MPS13_REG_L7CTRL,
> +	S2MPS13_REG_L8CTRL,
> +	S2MPS13_REG_L9CTRL,
> +	S2MPS13_REG_L10CTRL,
> +	S2MPS13_REG_L11CTRL,
> +	S2MPS13_REG_L12CTRL,
> +	S2MPS13_REG_L13CTRL,
> +	S2MPS13_REG_L14CTRL,
> +	S2MPS13_REG_L15CTRL,
> +	S2MPS13_REG_L16CTRL,
> +	S2MPS13_REG_L17CTRL,
> +	S2MPS13_REG_L18CTRL,
> +	S2MPS13_REG_L19CTRL,
> +	S2MPS13_REG_L20CTRL,
> +	S2MPS13_REG_L21CTRL,
> +	S2MPS13_REG_L22CTRL,
> +	S2MPS13_REG_L23CTRL,
> +	S2MPS13_REG_L24CTRL,
> +	S2MPS13_REG_L25CTRL,
> +	S2MPS13_REG_L26CTRL,
> +	S2MPS13_REG_L27CTRL,
> +	S2MPS13_REG_L28CTRL,
> +	S2MPS13_REG_L30CTRL,
> +	S2MPS13_REG_L31CTRL,
> +	S2MPS13_REG_L32CTRL,
> +	S2MPS13_REG_L33CTRL,
> +	S2MPS13_REG_L34CTRL,
> +	S2MPS13_REG_L35CTRL,
> +	S2MPS13_REG_L36CTRL,
> +	S2MPS13_REG_L37CTRL,
> +	S2MPS13_REG_L38CTRL,
> +	S2MPS13_REG_L39CTRL,
> +	S2MPS13_REG_L40CTRL,
> +	S2MPS13_REG_LDODSCH1,
> +	S2MPS13_REG_LDODSCH2,
> +	S2MPS13_REG_LDODSCH3,
> +	S2MPS13_REG_LDODSCH4,
> +	S2MPS13_REG_LDODSCH5,
> +};
> +
> +/*  regulator ids */
> +enum s2mps13_regulators {
> +	S2MPS13_LDO1,
> +	S2MPS13_LDO2,
> +	S2MPS13_LDO3,
> +	S2MPS13_LDO4,
> +	S2MPS13_LDO5,
> +	S2MPS13_LDO6,
> +	S2MPS13_LDO7,
> +	S2MPS13_LDO8,
> +	S2MPS13_LDO9,
> +	S2MPS13_LDO10,
> +	S2MPS13_LDO11,
> +	S2MPS13_LDO12,
> +	S2MPS13_LDO13,
> +	S2MPS13_LDO14,
> +	S2MPS13_LDO15,
> +	S2MPS13_LDO16,
> +	S2MPS13_LDO17,
> +	S2MPS13_LDO18,
> +	S2MPS13_LDO19,
> +	S2MPS13_LDO20,
> +	S2MPS13_LDO21,
> +	S2MPS13_LDO22,
> +	S2MPS13_LDO23,
> +	S2MPS13_LDO24,
> +	S2MPS13_LDO25,
> +	S2MPS13_LDO26,
> +	S2MPS13_LDO27,
> +	S2MPS13_LDO28,
> +	S2MPS13_LDO29,
> +	S2MPS13_LDO30,
> +	S2MPS13_LDO31,
> +	S2MPS13_LDO32,
> +	S2MPS13_LDO33,
> +	S2MPS13_LDO34,
> +	S2MPS13_LDO35,
> +	S2MPS13_LDO36,
> +	S2MPS13_LDO37,
> +	S2MPS13_LDO38,
> +	S2MPS13_LDO39,
> +	S2MPS13_LDO40,
> +	S2MPS13_BUCK1,
> +	S2MPS13_BUCK2,
> +	S2MPS13_BUCK3,
> +	S2MPS13_BUCK4,
> +	S2MPS13_BUCK5,
> +	S2MPS13_BUCK6,
> +	S2MPS13_BUCK7,
> +	S2MPS13_BUCK8,
> +	S2MPS13_BUCK9,
> +	S2MPS13_BUCK10,
> +
> +	S2MPS13_REGULATOR_MAX,
> +};
> +
> +/*
> + * Default ramp delay in uv/us. Datasheet says that ramp delay can be
> + * controlled however it does not specify which register is used for that.
> + * Let's assume that default value will be set.
> + */
> +#define S2MPS13_BUCK_RAMP_DELAY		12500
> +
> +#endif /*  __LINUX_MFD_S2MPS13_H */
> 

