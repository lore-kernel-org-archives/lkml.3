Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951AbaDQJXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:23:16 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24116 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaDQJXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:23:08 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-a5-534f9d7923fb
Message-id: <534F9D7A.6070203@samsung.com>
Date: Thu, 17 Apr 2014 11:23:06 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH/RFC v3 3/5] leds: Add support for max77693 mfd flash cell
References: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
 <1397228216-6657-4-git-send-email-j.anaszewski@samsung.com>
 <20140416172604.GF8753@valkosipuli.retiisi.org.uk>
In-reply-to: <20140416172604.GF8753@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xK7qVc/2DDabfl7W4te4cq8XRnROZ
	LOYfAbI+3vvHanG26Q27xf2vRxktLu+aw2ax9c06RoueDVtZLXbvespqcfhNO6vFmf0r2SxO
	d7M68HrsnHWX3ePw14UsHneu7WHzmHcy0GPP/B+sHn1bVjF6PPv4jtnj8ya5AI4oLpuU1JzM
	stQifbsEroxppzMLljUwVdz9dY6tgfHFOcYuRg4OCQETia1/lLsYOYFMMYkL99azdTFycQgJ
	LGWUePZ9IjOE85FRYta6hywgVbwCWhI7dy5gB7FZBFQlbmyfyQZiswkYSvx88ZoJxBYViJD4
	c3ofK0S9oMSPyffAekUE1CSebgKZw8XBLPCTSeLz2c9gCWEBX4n3d14xQWzbxSgxb+EVsG5O
	AXuJtufvGUFsZgFriZWTtkHZ8hKb17xlnsAoMAvJkllIymYhKVvAyLyKUTS1NLmgOCk911Cv
	ODG3uDQvXS85P3cTIySCvuxgXHzM6hCjAAejEg8vx2+/YCHWxLLiytxDjBIczEoivEt6/YOF
	eFMSK6tSi/Lji0pzUosPMTJxcEo1MFodPpH/yeLaHN0Xya/nSCk6FrBH+pjPlZz4jXvLziP6
	K7lPaEftFLMtPOZTev/4icACO5dUidYHgtJ5O05zyN+rMfsytep8lbpDkujsFIdbfw8ffBod
	OH1GiFrT9okqKaZXnlh97xM0/7zw5sLl76bo3G7ljilY+PWZ+rmIqOksRyNCX4uK9SqxFGck
	GmoxFxUnAgDxiV1mfgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

Thanks for the review.

On 04/16/2014 07:26 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> Thanks for the patch! Comments below.
>
> On Fri, Apr 11, 2014 at 04:56:54PM +0200, Jacek Anaszewski wrote:
>> This patch adds led-flash support to Maxim max77693 chipset.
>> A device can be exposed to user space through LED subsystem
>> sysfs interface or through V4L2 subdevice when the support
>> for V4L2 Flash sub-devices is enabled. Device supports up to
>> two leds which can work in flash and torch mode. Leds can
>> be triggered externally or by software.
>>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> Cc: SangYoung Son <hello.son@smasung.com>
>> Cc: Samuel Ortiz <sameo@linux.intel.com>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> ---
>>   drivers/leds/Kconfig         |   10 +
>>   drivers/leds/Makefile        |    1 +
>>   drivers/leds/leds-max77693.c |  794 ++++++++++++++++++++++++++++++++++++++++++
>>   drivers/mfd/max77693.c       |    2 +-
>>   include/linux/mfd/max77693.h |   38 ++
>>   5 files changed, 844 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/leds/leds-max77693.c
>>
>> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
>> index 1e1c81f..b2152a6 100644
>> --- a/drivers/leds/Kconfig
>> +++ b/drivers/leds/Kconfig
>> @@ -462,6 +462,16 @@ config LEDS_TCA6507
>>   	  LED driver chips accessed via the I2C bus.
>>   	  Driver support brightness control and hardware-assisted blinking.
>>
>> +config LEDS_MAX77693
>> +	tristate "LED support for MAX77693 Flash"
>> +	depends on LEDS_CLASS_FLASH
>> +	depends on MFD_MAX77693
>> +	depends on OF
>> +	help
>> +	  This option enables support for the flash part of the MAX77693
>> +	  multifunction device. It has build in control for two leds in flash
>> +	  and torch mode.
>> +
>>   config LEDS_MAX8997
>>   	tristate "LED support for MAX8997 PMIC"
>>   	depends on LEDS_CLASS && MFD_MAX8997
>> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
>> index 8861b86..64f6234 100644
>> --- a/drivers/leds/Makefile
>> +++ b/drivers/leds/Makefile
>> @@ -52,6 +52,7 @@ obj-$(CONFIG_LEDS_MC13783)		+= leds-mc13783.o
>>   obj-$(CONFIG_LEDS_NS2)			+= leds-ns2.o
>>   obj-$(CONFIG_LEDS_NETXBIG)		+= leds-netxbig.o
>>   obj-$(CONFIG_LEDS_ASIC3)		+= leds-asic3.o
>> +obj-$(CONFIG_LEDS_MAX77693)		+= leds-max77693.o
>>   obj-$(CONFIG_LEDS_MAX8997)		+= leds-max8997.o
>>   obj-$(CONFIG_LEDS_LM355x)		+= leds-lm355x.o
>>   obj-$(CONFIG_LEDS_BLINKM)		+= leds-blinkm.o
>> diff --git a/drivers/leds/leds-max77693.c b/drivers/leds/leds-max77693.c
>> new file mode 100644
>> index 0000000..979736c
>> --- /dev/null
>> +++ b/drivers/leds/leds-max77693.c
>> @@ -0,0 +1,794 @@
>> +/*
>> + *	Copyright (C) 2014, Samsung Electronics Co., Ltd.
>> + *
>> + *	Authors: Andrzej Hajda <a.hajda@samsung.com>
>> + *		 Jacek Anaszewski <j.anaszewski@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + */
>> +
>> +#include <asm/div64.h>
>> +#include <linux/leds_flash.h>
>> +#include <linux/module.h>
>> +#include <linux/mutex.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <media/v4l2-flash.h>
>
> I guess this should be last in the list.
>
>> +#include <linux/workqueue.h>
>> +#include <linux/mfd/max77693.h>
>> +#include <linux/mfd/max77693-private.h>
>> +
>> +#define MAX77693_LED_NAME		"max77693-flash"
>> +
>> +#define MAX77693_TORCH_IOUT_BITS	4
>> +
>> +#define MAX77693_TORCH_NO_TIMER		0x40
>> +#define MAX77693_FLASH_TIMER_LEVEL	0x80
>> +
>> +#define MAX77693_FLASH_EN_OFF		0
>> +#define MAX77693_FLASH_EN_FLASH		1
>> +#define MAX77693_FLASH_EN_TORCH		2
>> +#define MAX77693_FLASH_EN_ON		3
>> +
>> +#define MAX77693_FLASH_EN1_SHIFT	6
>> +#define MAX77693_FLASH_EN2_SHIFT	4
>> +#define MAX77693_TORCH_EN1_SHIFT	2
>> +#define MAX77693_TORCH_EN2_SHIFT	0
>> +
>> +#define MAX77693_FLASH_LOW_BATTERY_EN	0x80
>> +
>> +#define MAX77693_FLASH_BOOST_FIXED	0x04
>> +#define MAX77693_FLASH_BOOST_LEDNUM_2	0x80
>> +
>> +#define MAX77693_FLASH_TIMEOUT_MIN	62500
>> +#define MAX77693_FLASH_TIMEOUT_MAX	1000000
>> +#define MAX77693_FLASH_TIMEOUT_STEP	62500
>> +
>> +#define MAX77693_TORCH_TIMEOUT_MIN	262000
>> +#define MAX77693_TORCH_TIMEOUT_MAX	15728000
>> +
>> +#define MAX77693_FLASH_IOUT_MIN		15625
>> +#define MAX77693_FLASH_IOUT_MAX_1LED	1000000
>> +#define MAX77693_FLASH_IOUT_MAX_2LEDS	625000
>> +#define MAX77693_FLASH_IOUT_STEP	15625
>> +
>> +#define MAX77693_TORCH_IOUT_MIN		15625
>> +#define MAX77693_TORCH_IOUT_MAX		250000
>> +#define MAX77693_TORCH_IOUT_STEP	15625
>> +
>> +#define MAX77693_FLASH_VSYS_MIN		2400
>> +#define MAX77693_FLASH_VSYS_MAX		3400
>> +#define MAX77693_FLASH_VSYS_STEP	33
>> +
>> +#define MAX77693_FLASH_VOUT_MIN		3300
>> +#define MAX77693_FLASH_VOUT_MAX		5500
>> +#define MAX77693_FLASH_VOUT_STEP	25
>> +#define MAX77693_FLASH_VOUT_RMIN	0x0c
>> +
>> +#define MAX77693_LED_STATUS_FLASH_ON	(1 << 3)
>> +#define MAX77693_LED_STATUS_TORCH_ON	(1 << 2)
>> +
>> +#define MAX77693_LED_FLASH_INT_FLED2_OPEN	(1 << 0)
>> +#define MAX77693_LED_FLASH_INT_FLED2_SHORT	(1 << 1)
>> +#define MAX77693_LED_FLASH_INT_FLED1_OPEN	(1 << 2)
>> +#define MAX77693_LED_FLASH_INT_FLED1_SHORT	(1 << 3)
>> +#define MAX77693_LED_FLASH_INT_OVER_CURRENT	(1 << 4)
>> +
>> +#define MAX77693_MODE_OFF			0
>> +#define MAX77693_MODE_FLASH			(1 << 0)
>> +#define MAX77693_MODE_TORCH			(1 << 1)
>> +#define MAX77693_MODE_FLASH_EXTERNAL		(1 << 2)
>> +
>> +enum {
>> +	FLASH1,
>> +	FLASH2,
>> +	TORCH1,
>> +	TORCH2
>> +};
>> +
>> +enum {
>> +	FLASH,
>> +	TORCH
>> +};
>> +
>> +struct max77693_led {
>> +	struct regmap *regmap;
>> +	struct platform_device *pdev;
>> +	struct max77693_led_platform_data *pdata;
>> +	struct mutex lock;
>> +
>> +	struct led_classdev ldev;
>> +
>> +	unsigned int torch_brightness;
>> +	struct work_struct work_brightness_set;
>> +	unsigned int mode_flags;
>> +};
>> +
>> +static u8 max77693_led_iout_to_reg(u32 ua)
>> +{
>> +	if (ua < MAX77693_FLASH_IOUT_MIN)
>> +		ua = MAX77693_FLASH_IOUT_MIN;
>> +	return (ua - MAX77693_FLASH_IOUT_MIN) / MAX77693_FLASH_IOUT_STEP;
>> +}
>> +
>> +static u8 max77693_flash_timeout_to_reg(u32 us)
>> +{
>> +	return (us - MAX77693_FLASH_TIMEOUT_MIN) / MAX77693_FLASH_TIMEOUT_STEP;
>> +}
>> +
>> +static const u32 max77693_torch_timeouts[] = {
>> +	262000, 524000, 786000, 1048000,
>> +	1572000, 2096000, 2620000, 3144000,
>> +	4193000, 5242000, 6291000, 7340000,
>> +	9437000, 11534000, 13631000, 1572800
>> +};
>> +
>> +static u8 max77693_torch_timeout_to_reg(u32 us)
>> +{
>> +	int i, b = 0, e = ARRAY_SIZE(max77693_torch_timeouts);
>
> I haven't run this, but it looks like it'll access max77693_torch_timeouts[]
> array after the last element if you pass it a value greater than 1572800.
> Shouldn't e be initialised to ARRAY_SIZE() - 1 instead?
>
>> +
>> +	while (e - b > 1) {
>> +		i = b + (e - b) / 2;
>> +		if (us < max77693_torch_timeouts[i])
>> +			e = i;
>> +		else
>> +			b = i;
>> +	}
>> +	return b;
>> +}

Let's track this case:

us = 1600000
e = 16 (ARRAY_SIZE(max77693_torch_timeouts))

1st iteration:
	while (16 - 0 > 1) {
		i = 0 + (16 - 0) / 2 //= 8
		b = 8
	}

2nd iteration:
	while (16 - 8 > 1) {
		i = 8 + (16 - 8) / 2 //= 12
		b = 12
	}

3rd iteration:
	while (16 - 12 > 1) {
		i = 12 + (16 - 12) / 2 //= 14
		b = 14
	}

4th iteration:
	while (16 - 14 > 1) {
		i = 14 + (16 - 14) / 2 //= 15
		b = 15
	}

5th iteration:
	while (16 - 15 > 1) { //false
	}

	return b (15) - last element in the array
	

>> +static struct max77693_led *ldev_to_led(struct led_classdev *ldev)
>> +{
>> +	return container_of(ldev, struct max77693_led, ldev);
>> +}
>> +
>> +static u32 max77693_torch_timeout_from_reg(u8 reg)
>> +{
>
> I might limit reg to ARRAY_SIZE(...) as well. Up to you.

It is already aligned during validation of platform data.

>> +	return max77693_torch_timeouts[reg];
>> +}
>> +
>> +static u8 max77693_led_vsys_to_reg(u32 mv)
>> +{
>> +	return ((mv - MAX77693_FLASH_VSYS_MIN) / MAX77693_FLASH_VSYS_STEP) << 2;
>> +}
>> +
>> +static u8 max77693_led_vout_to_reg(u32 mv)
>> +{
>> +	return (mv - MAX77693_FLASH_VOUT_MIN) / MAX77693_FLASH_VOUT_STEP +
>> +		MAX77693_FLASH_VOUT_RMIN;
>> +}
>> +
>> +/* split composite current @i into two @iout according to @imax weights */
>
> Are there dependencies between the two LEDs or are they entirely
> independent? If they're independent (with the possible exception of strobe),
> then I'd expose them individually.

They are independent.

>> +static void max77693_calc_iout(u32 iout[2], u32 i, u32 imax[2])
>> +{
>> +	u64 t = i;
>> +
>> +	t *= imax[1];
>> +	do_div(t, imax[0] + imax[1]);
>> +
>> +	iout[1] = (u32)t / MAX77693_FLASH_IOUT_STEP * MAX77693_FLASH_IOUT_STEP;
>> +	iout[0] = i - iout[1];
>> +}
>> +
>> +static int max77693_set_mode(struct max77693_led *led, unsigned int mode)
>> +{
>> +	struct max77693_led_platform_data *p = led->pdata;
>> +	struct regmap *rmap = led->regmap;
>> +	int ret, v = 0;
>> +
>> +	if (mode & MAX77693_MODE_TORCH) {
>> +		if (p->trigger[TORCH1] & MAX77693_LED_TRIG_SOFT)
>> +			v |= MAX77693_FLASH_EN_ON << MAX77693_TORCH_EN1_SHIFT;
>> +		if (p->trigger[TORCH2] & MAX77693_LED_TRIG_SOFT)
>> +			v |= MAX77693_FLASH_EN_ON << MAX77693_TORCH_EN2_SHIFT;
>> +	}
>> +
>> +	if (mode & MAX77693_MODE_FLASH) {
>> +		if (p->trigger[FLASH1] & MAX77693_LED_TRIG_SOFT)
>> +			v |= MAX77693_FLASH_EN_ON << MAX77693_FLASH_EN1_SHIFT;
>> +		if (p->trigger[FLASH2] & MAX77693_LED_TRIG_SOFT)
>> +			v |= MAX77693_FLASH_EN_ON << MAX77693_FLASH_EN2_SHIFT;
>> +	} else if (mode & MAX77693_MODE_FLASH_EXTERNAL) {
>> +		if (p->trigger[FLASH1] & MAX77693_LED_TRIG_EXT)
>> +			v |= MAX77693_FLASH_EN_FLASH << MAX77693_FLASH_EN1_SHIFT;
>> +		if (p->trigger[FLASH2] & MAX77693_LED_TRIG_EXT)
>> +			v |= MAX77693_FLASH_EN_FLASH << MAX77693_FLASH_EN2_SHIFT;
>> +		/*
>> +		 * Enable hw triggering also for torch mode, as some camera
>> +		 * sensors use torch led to fathom ambient light conditions
>> +		 * before strobing the flash.
>> +		 */
>> +		if (p->trigger[TORCH1] & MAX77693_LED_TRIG_EXT)
>> +			v |= MAX77693_FLASH_EN_TORCH << MAX77693_TORCH_EN1_SHIFT;
>> +		if (p->trigger[TORCH2] & MAX77693_LED_TRIG_EXT)
>> +			v |= MAX77693_FLASH_EN_TORCH << MAX77693_TORCH_EN2_SHIFT;
>> +	}
>> +
>> +	/* Reset the register only prior setting flash modes */
>> +	if (mode != MAX77693_MODE_TORCH) {
>> +		ret = max77693_write_reg(rmap, MAX77693_LED_REG_FLASH_EN, 0);
>
> A single wrie for strobe. Looks good!
>
>> +		if (ret < 0)
>> +			return ret;
>> +	}
>> +
>> +	return max77693_write_reg(rmap, MAX77693_LED_REG_FLASH_EN, v);
>> +}
>> +
>> +static int max77693_add_mode(struct max77693_led *led, unsigned int mode)
>> +{
>> +	int ret;
>> +
>> +	/* Once enabled torch mode is active until turned off */
>> +	if ((mode == MAX77693_MODE_TORCH) &&
>> +	    (led->mode_flags & MAX77693_MODE_TORCH))
>> +		return 0;
>> +
>> +	/*
>> +	 * FLASH_EXTERNAL mode activates HW triggered flash and torch
>> +	 * modes in the device. The related register settings interfere
>> +	 * with SW triggerred modes, thus clear them to ensure proper
>> +	 * device configuration.
>> +	 */
>> +	if (mode == MAX77693_MODE_FLASH_EXTERNAL)
>> +		led->mode_flags &= (~MAX77693_MODE_TORCH &
>> +				    ~MAX77693_MODE_FLASH);
>> +
>> +	led->mode_flags |= mode;
>> +
>> +	ret = max77693_set_mode(led, led->mode_flags);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/*
>> +	 * Clear flash mode flag after setting the mode to avoid
>> +	 * spurous flash strobing on each successive torch mode
>> +	 * setting.
>> +	 */
>> +	if ((mode == MAX77693_MODE_FLASH) ||
>> +	    (mode == MAX77693_MODE_FLASH_EXTERNAL))
>> +		led->mode_flags &= ~mode;
>> +
>> +	return 0;
>> +}
>> +
>> +static int max77693_clear_mode(struct max77693_led *led, unsigned int mode)
>> +{
>> +	led->mode_flags &= ~mode;
>> +
>> +	return max77693_set_mode(led, led->mode_flags);
>> +}
>> +
>> +static int max77693_set_torch_current(struct max77693_led *led,
>> +					u32 micro_amp)
>> +{
>> +	struct max77693_led_platform_data *p = led->pdata;
>> +	struct regmap *rmap = led->regmap;
>> +	u32 iout[2];
>> +	u8 v, iout1_reg, iout2_reg;
>> +	int ret;
>> +
>> +	max77693_calc_iout(iout, micro_amp, &p->iout[TORCH1]);
>> +	iout1_reg = max77693_led_iout_to_reg(iout[0]);
>> +	iout2_reg = max77693_led_iout_to_reg(iout[1]);
>> +
>> +	v = iout1_reg | (iout2_reg << MAX77693_TORCH_IOUT_BITS);
>> +	ret = max77693_write_reg(rmap, MAX77693_LED_REG_ITORCH, v);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return 0;
>> +}
>> +
>> +static int max77693_set_flash_current(struct max77693_led *led,
>> +					u32 micro_amp)
>> +{
>> +	struct max77693_led_platform_data *p = led->pdata;
>> +	struct regmap *rmap = led->regmap;
>> +	u32 iout[2];
>> +	u8 iout1_reg, iout2_reg;
>> +	int ret;
>> +
>> +	max77693_calc_iout(iout, micro_amp, &p->iout[FLASH1]);
>> +	iout1_reg = max77693_led_iout_to_reg(iout[0]);
>> +	iout2_reg = max77693_led_iout_to_reg(iout[1]);
>> +
>> +	ret = max77693_write_reg(rmap, MAX77693_LED_REG_IFLASH1, iout1_reg);
>> +	if (ret < 0)
>> +		goto error_ret;
>> +	ret = max77693_write_reg(rmap, MAX77693_LED_REG_IFLASH2, iout2_reg);
>> +	if (ret < 0)
>> +		goto error_ret;
>> +
>> +error_ret:
>> +	return ret;
>> +}
>> +
>> +static int max77693_set_timeout(struct max77693_led *led,
>> +				u32 timeout)
>> +{
>> +	struct max77693_led_platform_data *p = led->pdata;
>> +	struct regmap *rmap = led->regmap;
>> +	u8 v;
>> +
>> +	v = max77693_flash_timeout_to_reg(timeout);
>> +
>> +	if (p->trigger_type[FLASH] == MAX77693_LED_TRIG_TYPE_LEVEL)
>> +		v |= MAX77693_FLASH_TIMER_LEVEL;
>> +
>> +	return max77693_write_reg(rmap, MAX77693_LED_REG_FLASH_TIMER, v);
>> +}
>> +
>> +static int max77693_strobe_status_get(struct max77693_led *led)
>> +{
>> +	struct regmap *rmap = led->regmap;
>> +	u8 v;
>> +	int ret;
>> +
>> +	ret = max77693_read_reg(rmap, MAX77693_LED_REG_FLASH_INT_STATUS, &v);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return !!(v & MAX77693_LED_STATUS_FLASH_ON);
>> +}
>> +
>> +static int max77693_int_flag_get(struct max77693_led *led, u8 *v)
>> +{
>> +	struct regmap *rmap = led->regmap;
>> +
>> +	return max77693_read_reg(rmap, MAX77693_LED_REG_FLASH_INT, v);
>> +}
>> +
>> +static int max77693_setup(struct max77693_led *led)
>> +{
>> +	struct max77693_led_platform_data *p = led->pdata;
>> +	struct regmap *rmap = led->regmap;
>> +	int ret;
>> +	u8 v;
>> +
>> +	ret = max77693_set_torch_current(led, p->iout[TORCH1] +
>> +						p->iout[TORCH2]);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = max77693_set_flash_current(led, p->iout[FLASH1] +
>> +						p->iout[FLASH2]);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (p->timeout[TORCH] > 0)
>> +		v = max77693_torch_timeout_to_reg(p->timeout[TORCH]);
>> +	else
>> +		v = MAX77693_TORCH_NO_TIMER;
>> +	if (p->trigger_type[TORCH] == MAX77693_LED_TRIG_TYPE_LEVEL)
>> +		v |= MAX77693_FLASH_TIMER_LEVEL;
>> +	ret = max77693_write_reg(rmap, MAX77693_LED_REG_ITORCHTIMER, v);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	v = max77693_flash_timeout_to_reg(p->timeout[FLASH]);
>> +	if (p->trigger_type[FLASH] == MAX77693_LED_TRIG_TYPE_LEVEL)
>> +		v |= MAX77693_FLASH_TIMER_LEVEL;
>> +	ret = max77693_write_reg(rmap, MAX77693_LED_REG_FLASH_TIMER, v);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (p->low_vsys > 0)
>> +		v = max77693_led_vsys_to_reg(p->low_vsys) |
>> +						MAX77693_FLASH_LOW_BATTERY_EN;
>> +	else
>> +		v = 0;
>> +
>> +	ret = max77693_write_reg(rmap, MAX77693_LED_REG_MAX_FLASH1, v);
>> +	if (ret < 0)
>> +		return ret;
>> +	ret = max77693_write_reg(rmap, MAX77693_LED_REG_MAX_FLASH2, 0);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (p->boost_mode[FLASH1] == MAX77693_LED_BOOST_FIXED ||
>> +	    p->boost_mode[FLASH2] == MAX77693_LED_BOOST_FIXED)
>> +		v = MAX77693_FLASH_BOOST_FIXED;
>> +	else
>> +		v = p->boost_mode[FLASH1] | (p->boost_mode[FLASH2] << 1);
>> +	if (p->boost_mode[FLASH1] && p->boost_mode[FLASH2])
>> +		v |= MAX77693_FLASH_BOOST_LEDNUM_2;
>> +	ret = max77693_write_reg(rmap, MAX77693_LED_REG_VOUT_CNTL, v);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	v = max77693_led_vout_to_reg(p->boost_vout);
>> +	ret = max77693_write_reg(rmap, MAX77693_LED_REG_VOUT_FLASH1, v);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return max77693_set_mode(led, MAX77693_MODE_OFF);
>> +}
>> +
>> +/* LED subsystem callbacks */
>> +
>> +static void max77693_brightness_set_work(struct work_struct *work)
>> +{
>> +	struct max77693_led *led =
>> +		container_of(work, struct max77693_led, work_brightness_set);
>> +	int ret;
>> +
>> +	mutex_lock(&led->lock);
>> +
>> +	if (led->torch_brightness == 0) {
>> +		ret = max77693_clear_mode(led, MAX77693_MODE_TORCH);
>> +		if (ret < 0)
>> +			dev_dbg(&led->pdev->dev,
>> +				"Failed to clear torch mode (%d)\n",
>> +				ret);
>> +		goto unlock;
>> +	}
>> +
>> +	ret = max77693_set_torch_current(led, led->torch_brightness *
>> +						MAX77693_TORCH_IOUT_STEP);
>> +	if (ret < 0) {
>> +		dev_dbg(&led->pdev->dev, "Failed to set torch current (%d)\n",
>> +			ret);
>> +		goto unlock;
>> +	}
>> +
>> +	ret = max77693_add_mode(led, MAX77693_MODE_TORCH);
>> +	if (ret < 0)
>> +		dev_dbg(&led->pdev->dev, "Failed to set torch mode (%d)\n",
>> +			ret);
>> +unlock:
>> +	mutex_unlock(&led->lock);
>> +}
>> +
>> +static void max77693_led_brightness_set(struct led_classdev *led_cdev,
>> +				enum led_brightness value)
>> +{
>> +	struct max77693_led *led = ldev_to_led(led_cdev);
>> +
>> +	led->torch_brightness = value;
>> +	schedule_work(&led->work_brightness_set);
>
> Is there a reason not to do this right now (but in a work queue instead)?

Almost all the drivers in the LED subsystem do it that way.
I think that it is caused by the fact that setting led brightness
should be as fast as possible and non-blocking. The led may be
used e.g. for HD LED (see ledtrig-ide) and activated many times
per second, and thus it could have impact on the system performance
if it wasn't run in a work queue.

>> +}
>> +
>> +static int max77693_led_flash_strobe_get(struct led_classdev *led_cdev)
>> +{
>> +	struct max77693_led *led = ldev_to_led(led_cdev);
>> +	int ret;
>> +
>> +	mutex_lock(&led->lock);
>> +	ret = max77693_strobe_status_get(led);
>> +	mutex_unlock(&led->lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static int max77693_led_flash_fault_get(struct led_classdev *led_cdev,
>> +					u32 *fault)
>> +{
>> +	struct max77693_led *led = ldev_to_led(led_cdev);
>> +	u8 v;
>> +	int ret;
>> +
>> +	mutex_lock(&led->lock);
>> +
>> +	ret = max77693_int_flag_get(led, &v);
>> +	if (ret < 0)
>> +		goto unlock;
>> +
>> +	*fault = 0;
>> +
>> +	if (v & MAX77693_LED_FLASH_INT_FLED2_OPEN ||
>> +	    v & MAX77693_LED_FLASH_INT_FLED1_OPEN)
>> +		*fault |= LED_FAULT_OVER_VOLTAGE;
>> +	if (v & MAX77693_LED_FLASH_INT_FLED2_SHORT ||
>> +	    v & MAX77693_LED_FLASH_INT_FLED1_SHORT)
>> +		*fault |= LED_FAULT_SHORT_CIRCUIT;
>> +	if (v & MAX77693_LED_FLASH_INT_OVER_CURRENT)
>> +		*fault |= LED_FAULT_OVER_CURRENT;
>> +unlock:
>> +	mutex_unlock(&led->lock);
>> +	return ret;
>> +}
>> +
>> +static int max77693_led_flash_strobe_set(struct led_classdev *led_cdev,
>> +						bool state)
>> +{
>> +	struct max77693_led *led = ldev_to_led(led_cdev);
>> +	struct led_flash *flash = led_cdev->flash;
>> +	int ret;
>> +
>> +	mutex_lock(&led->lock);
>> +
>> +	if (flash->external_strobe) {
>> +		ret = -EBUSY;
>> +		goto unlock;
>> +	}
>> +
>> +	if (!state) {
>> +		ret = max77693_clear_mode(led, MAX77693_MODE_FLASH);
>> +		goto unlock;
>> +	}
>> +
>> +	ret = max77693_add_mode(led, MAX77693_MODE_FLASH);
>> +	if (ret < 0)
>> +		goto unlock;
>> +unlock:
>> +	mutex_unlock(&led->lock);
>> +	return ret;
>> +}
>> +
>> +static int max77693_led_external_strobe_set(struct led_classdev *led_cdev,
>> +						bool enable)
>> +{
>> +	struct max77693_led *led = ldev_to_led(led_cdev);
>> +	int ret;
>> +
>> +	mutex_lock(&led->lock);
>> +
>> +	if (enable)
>> +		ret = max77693_add_mode(led, MAX77693_MODE_FLASH_EXTERNAL);
>> +	else
>> +		ret = max77693_clear_mode(led, MAX77693_MODE_FLASH_EXTERNAL);
>> +
>> +	mutex_unlock(&led->lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static int max77693_led_flash_brightness_set(struct led_classdev *led_cdev,
>> +						u32 brightness)
>> +{
>> +	struct max77693_led *led = ldev_to_led(led_cdev);
>> +	int ret;
>> +
>> +	mutex_lock(&led->lock);
>> +
>> +	ret = max77693_set_flash_current(led, brightness);
>> +	if (ret < 0)
>> +		goto unlock;
>> +unlock:
>> +	mutex_unlock(&led->lock);
>> +	return ret;
>> +}
>> +
>> +static int max77693_led_flash_timeout_set(struct led_classdev *led_cdev,
>> +						u32 timeout)
>> +{
>> +	struct max77693_led *led = ldev_to_led(led_cdev);
>> +	int ret;
>> +
>> +	mutex_lock(&led->lock);
>> +
>> +	ret = max77693_set_timeout(led, timeout);
>> +	if (ret < 0)
>> +		goto unlock;
>> +
>> +unlock:
>> +	mutex_unlock(&led->lock);
>> +	return ret;
>> +}
>> +
>> +static void max77693_led_parse_dt(struct max77693_led_platform_data *p,
>> +			    struct device_node *node)
>> +{
>> +	of_property_read_u32_array(node, "maxim,iout", p->iout, 4);
>
> How about separate current for flash and torch modes? They are the same
> LEDs; just the mode is different.

There are separate currents - 2 for torch and 2 for flash mode.

>> +	of_property_read_u32_array(node, "maxim,trigger", p->trigger, 4);
>> +	of_property_read_u32_array(node, "maxim,trigger-type", p->trigger_type,
>> +									2);
>> +	of_property_read_u32_array(node, "maxim,timeout", p->timeout, 2);
>> +	of_property_read_u32_array(node, "maxim,boost-mode", p->boost_mode, 2);
>> +	of_property_read_u32(node, "maxim,boost-vout", &p->boost_vout);
>> +	of_property_read_u32(node, "maxim,vsys-min", &p->low_vsys);
>
> Are these values specific to the maxim chip? I'd suppose e.g. timeout and
> iout are something that can be found pretty much in any flash controller.

Besides the two they are specific. And what with timeout and iout
if they are common for all flash controllers?

>> +}
>> +
>> +static void clamp_align(u32 *v, u32 min, u32 max, u32 step)
>> +{
>> +	*v = clamp_val(*v, min, max);
>> +	if (step > 1)
>> +		*v = (*v - min) / step * step + min;
>> +}
>> +
>> +static void max77693_led_validate_platform_data(
>> +					struct max77693_led_platform_data *p)
>> +{
>> +	u32 max;
>> +	int i;
>> +
>> +	for (i = 0; i < 2; ++i)
>
> How about using ARRAY_SIZE() here, too?

OK.

>
>> +		clamp_align(&p->boost_mode[i], MAX77693_LED_BOOST_NONE,
>> +			    MAX77693_LED_BOOST_FIXED, 1);
>> +	/* boost, if enabled, should be the same on both leds */
>> +	if (p->boost_mode[0] != MAX77693_LED_BOOST_NONE &&
>> +	    p->boost_mode[1] != MAX77693_LED_BOOST_NONE)
>> +		p->boost_mode[1] = p->boost_mode[0];
>> +
>> +	max = (p->boost_mode[FLASH1] && p->boost_mode[FLASH2]) ?
>> +		  MAX77693_FLASH_IOUT_MAX_2LEDS : MAX77693_FLASH_IOUT_MAX_1LED;
>> +
>> +	clamp_align(&p->iout[FLASH1], MAX77693_FLASH_IOUT_MIN,
>> +		    max, MAX77693_FLASH_IOUT_STEP);
>> +	clamp_align(&p->iout[FLASH2], MAX77693_FLASH_IOUT_MIN,
>> +		    max, MAX77693_FLASH_IOUT_STEP);
>> +	clamp_align(&p->iout[TORCH1], MAX77693_TORCH_IOUT_MIN,
>> +		    MAX77693_TORCH_IOUT_MAX, MAX77693_TORCH_IOUT_STEP);
>> +	clamp_align(&p->iout[TORCH2], MAX77693_TORCH_IOUT_MIN,
>> +		    MAX77693_TORCH_IOUT_MAX, MAX77693_TORCH_IOUT_STEP);
>> +
>> +	for (i = 0; i < 4; ++i)
>> +		clamp_align(&p->trigger[i], 0, 7, 1);
>> +	for (i = 0; i < 2; ++i)
>> +		clamp_align(&p->trigger_type[i], MAX77693_LED_TRIG_TYPE_EDGE,
>> +			    MAX77693_LED_TRIG_TYPE_LEVEL, 1);
>
> ARRAY_SIZE() would be nicer than using numeric values for the loop
> condition.
>
>> +	clamp_align(&p->timeout[FLASH], MAX77693_FLASH_TIMEOUT_MIN,
>> +		    MAX77693_FLASH_TIMEOUT_MAX, MAX77693_FLASH_TIMEOUT_STEP);
>> +
>> +	if (p->timeout[TORCH]) {
>> +		clamp_align(&p->timeout[TORCH], MAX77693_TORCH_TIMEOUT_MIN,
>> +			    MAX77693_TORCH_TIMEOUT_MAX, 1);
>> +		p->timeout[TORCH] = max77693_torch_timeout_from_reg(
>> +			      max77693_torch_timeout_to_reg(p->timeout[TORCH]));
>> +	}
>> +
>> +	clamp_align(&p->boost_vout, MAX77693_FLASH_VOUT_MIN,
>> +		    MAX77693_FLASH_VOUT_MAX, MAX77693_FLASH_VOUT_STEP);
>> +
>> +	if (p->low_vsys) {
>> +		clamp_align(&p->low_vsys, MAX77693_FLASH_VSYS_MIN,
>> +			    MAX77693_FLASH_VSYS_MAX, MAX77693_FLASH_VSYS_STEP);
>> +	}
>> +}
>> +
>> +static int max77693_led_get_platform_data(struct max77693_led *led)
>> +{
>> +	struct max77693_led_platform_data *p;
>> +	struct device *dev = &led->pdev->dev;
>> +
>> +	if (dev->of_node) {
>> +		p = devm_kzalloc(dev, sizeof(*led->pdata), GFP_KERNEL);
>> +		if (!p)
>> +			return -ENOMEM;
>
> Check for p can be moved out of the if as it's the same for both.
>
> You could also use led->pdata directly. Up to you.
>
>> +		max77693_led_parse_dt(p, dev->of_node);
>> +	} else {
>> +		p = dev_get_platdata(dev);
>> +		if (!p)
>> +			return -ENODEV;
>> +	}
>> +	led->pdata = p;
>> +
>> +	max77693_led_validate_platform_data(p);
>> +
>> +	return 0;
>> +}
>> +
>> +static struct led_flash led_flash = {
>> +	.ops = {
>> +		.brightness_set		= max77693_led_flash_brightness_set,
>> +		.strobe_set		= max77693_led_flash_strobe_set,
>> +		.strobe_get		= max77693_led_flash_strobe_get,
>> +		.timeout_set		= max77693_led_flash_timeout_set,
>> +		.external_strobe_set	= max77693_led_external_strobe_set,
>> +		.fault_get		= max77693_led_flash_fault_get,
>> +	},
>> +	.has_flash_led = true,
>> +};
>> +
>> +static void max77693_init_led_controls(struct led_classdev *led_cdev,
>> +					struct max77693_led_platform_data *p)
>> +{
>> +	struct led_flash *flash = led_cdev->flash;
>> +	struct led_ctrl *c;
>> +
>> +	/*
>> +	 * brightness_ctrl and fault_flags are used only
>> +	 * for initializing related V4L2 controls.
>> +	 */
>> +#ifdef CONFIG_V4L2_FLASH
>> +	flash->fault_flags = V4L2_FLASH_FAULT_OVER_VOLTAGE |
>> +			     V4L2_FLASH_FAULT_SHORT_CIRCUIT |
>> +			     V4L2_FLASH_FAULT_OVER_CURRENT;
>> +
>> +	c = &led_cdev->brightness_ctrl;
>> +	c->min = (p->iout[TORCH1] != 0 && p->iout[TORCH2] != 0) ?
>> +					MAX77693_TORCH_IOUT_MIN * 2 :
>> +					MAX77693_TORCH_IOUT_MIN;
>> +	c->max = p->iout[TORCH1] + p->iout[TORCH2];
>> +	c->step = MAX77693_TORCH_IOUT_STEP;
>> +	c->val = p->iout[TORCH1] + p->iout[TORCH2];
>
> Can you control the current for the two flash LEDs separately?

Yes.

> If yes, this
> should be also available on the V4L2 flash API. The lm3560 driver does this,
> for example. (It creates two sub-devices since we can only control a single
> LED using a single sub-device, at least for the time being.)

So, should I propose new V4L2 flash API for controlling more than
one led? Probably similar improvement should be applied to the
LED subsystem.

>> +#endif
>> +
>> +	c = &flash->brightness;
>> +	c->min = (p->iout[FLASH1] != 0 && p->iout[FLASH2] != 0) ?
>> +					MAX77693_FLASH_IOUT_MIN * 2 :
>> +					MAX77693_FLASH_IOUT_MIN;
>> +	c->max = p->iout[FLASH1] + p->iout[FLASH2];
>> +	c->step = MAX77693_FLASH_IOUT_STEP;
>> +	c->val = p->iout[FLASH1] + p->iout[FLASH2];
>> +
>> +	c = &flash->timeout;
>> +	c->min = MAX77693_FLASH_TIMEOUT_MIN;
>> +	c->max = MAX77693_FLASH_TIMEOUT_MAX;
>> +	c->step = MAX77693_FLASH_TIMEOUT_STEP;
>> +	c->val = p->timeout[FLASH];
>> +
>> +}
>> +
>> +static int max77693_led_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct max77693_dev *iodev = dev_get_drvdata(dev->parent);
>> +	struct max77693_led *led;
>> +	struct max77693_led_platform_data *p;
>> +	struct led_classdev *led_cdev;
>> +	int ret;
>> +
>> +	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
>> +	if (!led)
>> +		return -ENOMEM;
>> +
>> +	led->pdev = pdev;
>> +	led_cdev = &led->ldev;
>> +	led->regmap = iodev->regmap;
>> +	platform_set_drvdata(pdev, led);
>> +	ret = max77693_led_get_platform_data(led);
>> +	if (ret < 0)
>> +		return -EINVAL;
>> +	p = led->pdata;
>> +
>> +	mutex_init(&led->lock);
>> +
>> +	INIT_WORK(&led->work_brightness_set, max77693_brightness_set_work);
>> +
>> +	/* LED class device initialization */
>> +	led_cdev->name = MAX77693_LED_NAME;
>> +	led_cdev->brightness_set = max77693_led_brightness_set;
>> +	led_cdev->max_brightness = (p->iout[TORCH1] + p->iout[TORCH2]) /
>> +						MAX77693_TORCH_IOUT_STEP;
>> +
>> +	if ((p->trigger[FLASH1] & MAX77693_LED_TRIG_FLASH) ||
>> +	    (p->trigger[FLASH2] & MAX77693_LED_TRIG_FLASH))
>> +		led_flash.has_external_strobe = true;
>> +	led_cdev->flash = &led_flash;
>> +
>> +	max77693_init_led_controls(led_cdev, p);
>> +
>> +	/* Register in the LED subsystem. */
>> +	ret = led_classdev_flash_register(&pdev->dev, led_cdev);
>> +	if (ret < 0)
>
> mutex_destroy()?
>
>> +		return -EINVAL;
>> +
>> +	ret = max77693_setup(led);
>
> Do you intentionally ignore the return value?

No, I just forgot about it :-)

>> +	return 0;
>> +}
>> +
>> +static int max77693_led_remove(struct platform_device *pdev)
>> +{
>> +	struct max77693_led *led = platform_get_drvdata(pdev);
>> +
>> +	led_classdev_flash_unregister(&led->ldev);
>
> mutex_destroy()?

Sure.

>> +	return 0;
>> +}
>> +
>> +static struct of_device_id max77693_led_dt_match[] = {
>> +	{.compatible = "maxim,max77693-flash"},
>> +	{},
>> +};
>> +
>> +static struct platform_driver max77693_led_driver = {
>> +	.probe		= max77693_led_probe,
>> +	.remove		= max77693_led_remove,
>> +	.driver		= {
>> +		.name	= "max77693-flash",
>> +		.owner	= THIS_MODULE,
>> +		.of_match_table = max77693_led_dt_match,
>> +	},
>> +};
>> +
>> +module_platform_driver(max77693_led_driver);
>> +
>> +MODULE_AUTHOR("Andrzej Hajda <a.hajda@samsung.com>");
>> +MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
>> +MODULE_DESCRIPTION("Maxim MAX77693 led flash driver");
>> +MODULE_LICENSE("GPL");
>> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
>> index c5535f0..f061aa8 100644
>> --- a/drivers/mfd/max77693.c
>> +++ b/drivers/mfd/max77693.c
>> @@ -44,7 +44,7 @@
>>   static const struct mfd_cell max77693_devs[] = {
>>   	{ .name = "max77693-pmic", },
>>   	{ .name = "max77693-charger", },
>> -	{ .name = "max77693-flash", },
>> +	{ .name = "max77693-flash", .of_compatible = "maxim,max77693-flash", },
>>   	{ .name = "max77693-muic", },
>>   	{ .name = "max77693-haptic", },
>>   };
>> diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
>> index 3f3dc45..f2285b7 100644
>> --- a/include/linux/mfd/max77693.h
>> +++ b/include/linux/mfd/max77693.h
>> @@ -63,6 +63,43 @@ struct max77693_muic_platform_data {
>>   	int path_uart;
>>   };
>>
>> +/* MAX77693 led flash */
>> +
>> +/* triggers */
>> +enum max77693_led_trigger {
>> +	MAX77693_LED_TRIG_OFF,
>> +	MAX77693_LED_TRIG_FLASH,
>> +	MAX77693_LED_TRIG_TORCH,
>> +	MAX77693_LED_TRIG_EXT,
>> +	MAX77693_LED_TRIG_SOFT,
>> +};
>> +
>> +
>> +/* trigger types */
>> +enum max77693_led_trigger_type {
>> +	MAX77693_LED_TRIG_TYPE_EDGE,
>> +	MAX77693_LED_TRIG_TYPE_LEVEL,
>> +};
>> +
>> +/* boost modes */
>> +enum max77693_led_boost_mode {
>> +	MAX77693_LED_BOOST_NONE,
>> +	MAX77693_LED_BOOST_ADAPTIVE,
>> +	MAX77693_LED_BOOST_FIXED,
>> +};
>> +
>> +struct max77693_led_platform_data {
>> +	u32 iout[4];
>> +	u32 trigger[4];
>> +	u32 trigger_type[2];
>> +	u32 timeout[2];
>> +	u32 boost_mode[2];
>> +	u32 boost_vout;
>> +	u32 low_vsys;
>> +};
>> +
>> +/* MAX77693 */
>> +
>>   struct max77693_platform_data {
>>   	/* regulator data */
>>   	struct max77693_regulator_data *regulators;
>> @@ -70,5 +107,6 @@ struct max77693_platform_data {
>>
>>   	/* muic data */
>>   	struct max77693_muic_platform_data *muic_data;
>> +	struct max77693_led_platform_data *led_data;
>>   };
>>   #endif	/* __LINUX_MFD_MAX77693_H */
>

