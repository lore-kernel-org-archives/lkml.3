Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaHDOoB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:44:01 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15286 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaHDOn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:43:58 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-91-53df9c2b69f4
Message-id: <53DF9C2A.8060403@samsung.com>
Date: Mon, 04 Aug 2014 16:43:54 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC v4 15/21] media: Add registration helpers for V4L2 flash
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
 <1405087464-13762-16-git-send-email-j.anaszewski@samsung.com>
 <53CCF59E.3070200@iki.fi>
In-reply-to: <53CCF59E.3070200@iki.fi>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xa7rac+4HG7QtkLDYOGM9q8X8I+dY
	LZb83MVkcbbpDbvF5V1z2Cy2vlnHaNGzYSurxZn9K9kcODym/N7I6nH460IWj74tqxg9Pm+S
	C2CJ4rJJSc3JLEst0rdL4MqY8X8za8GK14wVFy8dZmxg3LOPsYuRk0NCwETi+Y+9bBC2mMSF
	e+uBbC4OIYGljBKrG1YzQTgfGSVaTl4A6+AV0JLYM/sAE4jNIqAqMaF3KjOIzSZgKPHzxWuw
	uKhAhMSf0/tYIeoFJX5MvscCYosIqEk83fSQBWQos8B1RokV7x6ygySEBQIkFlyeyQqxbQmj
	xPTdy4Hu4ODgBOqYcEIHpIZZwEziUcs6ZghbXmLzmrfMExgFZiHZMQtJ2SwkZQsYmVcxiqaW
	JhcUJ6XnGuoVJ+YWl+al6yXn525ihAT7lx2Mi49ZHWIU4GBU4uE1OH03WIg1say4MvcQowQH
	s5IIb3bZ/WAh3pTEyqrUovz4otKc1OJDjEwcnFINjCEJ2bOMX2o/OeR4ymnnonwmb0fevofT
	96d4ZV8UzxXZkJelEvyualJwu5dXbrGJeWoIf0vqispF81i1WKW9nxx/vHFPTdBH4dpmk+Mv
	X/FcjVtzTHZ58PvdKUYbkz51awV9aNWOm3bfKf7f1z8TZ9l9/J34L2DdPpPj/668n77vVLv7
	f8cnVUosxRmJhlrMRcWJAHABGBpUAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

Thanks for the review.

On 07/21/2014 01:12 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> Jacek Anaszewski wrote:
>> This patch adds helper functions for registering/unregistering
>> LED class flash devices as V4L2 subdevs. The functions should
>> be called from the LED subsystem device driver. In case the
>> support for V4L2 Flash sub-devices is disabled in the kernel
>> config the functions' empty versions will be used.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>   drivers/media/v4l2-core/Kconfig      |   11 +
>>   drivers/media/v4l2-core/Makefile     |    2 +
>>   drivers/media/v4l2-core/v4l2-flash.c |  580 ++++++++++++++++++++++++++++++++++
>>   include/media/v4l2-flash.h           |  137 ++++++++
>>   4 files changed, 730 insertions(+)
>>   create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
>>   create mode 100644 include/media/v4l2-flash.h
>>
>> diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
>> index 9ca0f8d..3ae3f0f 100644
>> --- a/drivers/media/v4l2-core/Kconfig
>> +++ b/drivers/media/v4l2-core/Kconfig
>> @@ -35,6 +35,17 @@ config V4L2_MEM2MEM_DEV
>>           tristate
>>           depends on VIDEOBUF2_CORE
>>
>> +# Used by LED subsystem flash drivers
>> +config V4L2_FLASH_LED_CLASS
>> +	bool "Enable support for Flash sub-devices"
>> +	depends on VIDEO_V4L2_SUBDEV_API
>> +	depends on LEDS_CLASS_FLASH
>> +	---help---
>> +	  Say Y here to enable support for Flash sub-devices, which allow
>> +	  to control LED class devices with use of V4L2 Flash controls.
>> +
>> +	  When in doubt, say N.
>> +
>>   # Used by drivers that need Videobuf modules
>>   config VIDEOBUF_GEN
>>   	tristate
>> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
>> index 63d29f2..44e858c 100644
>> --- a/drivers/media/v4l2-core/Makefile
>> +++ b/drivers/media/v4l2-core/Makefile
>> @@ -22,6 +22,8 @@ obj-$(CONFIG_VIDEO_TUNER) += tuner.o
>>
>>   obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
>>
>> +obj-$(CONFIG_V4L2_FLASH_LED_CLASS) += v4l2-flash.o
>> +
>>   obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
>>   obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
>>   obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
>> diff --git a/drivers/media/v4l2-core/v4l2-flash.c b/drivers/media/v4l2-core/v4l2-flash.c
>> new file mode 100644
>> index 0000000..21080c6
>> --- /dev/null
>> +++ b/drivers/media/v4l2-core/v4l2-flash.c
>> @@ -0,0 +1,580 @@
>> +/*
>> + * V4L2 Flash LED sub-device registration helpers.
>> + *
>> + *	Copyright (C) 2014 Samsung Electronics Co., Ltd
>> + *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation."
>> + */
>> +
>> +#include <linux/led-class-flash.h>
>> +#include <linux/mutex.h>
>> +#include <linux/of_led_flash_manager.h>
>> +#include <linux/slab.h>
>> +#include <media/v4l2-flash.h>
>> +
>> +#define call_flash_op(v4l2_flash, op, args...)			\
>> +		(v4l2_flash->ops->op  ?				\
>> +			v4l2_flash->ops->op(args) :		\
>> +			-EINVAL)
>> +
>> +static struct v4l2_device *v4l2_dev;
>> +static int registered_flashes;
>> +
>> +static inline enum led_brightness v4l2_flash_intensity_to_led_brightness(
>> +					struct v4l2_ctrl_config *config,
>> +					s32 intensity)
>> +{
>> +	return ((intensity - config->min) / config->step) + 1;
>> +}
>> +
>> +static inline s32 v4l2_flash_led_brightness_to_intensity(
>> +					struct v4l2_ctrl_config *config,
>> +					enum led_brightness brightness)
>> +{
>> +	return ((brightness - 1) * config->step) + config->min;
>> +}
>> +
>> +static int v4l2_flash_g_volatile_ctrl(struct v4l2_ctrl *c)
>> +
>> +{
>> +	struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
>> +	struct led_classdev_flash *flash = v4l2_flash->flash;
>> +	struct led_classdev *led_cdev = &flash->led_cdev;
>> +	struct v4l2_flash_ctrl_config *config = &v4l2_flash->config;
>> +	struct v4l2_flash_ctrl *ctrl = &v4l2_flash->ctrl;
>> +	bool is_strobing;
>> +	int ret;
>> +
>> +	switch (c->id) {
>> +	case V4L2_CID_FLASH_TORCH_INTENSITY:
>> +		/*
>> +		 * Update torch brightness only if in TORCH_MODE,
>> +		 * as otherwise brightness_update op returns 0,
>> +		 * which would spuriously inform user space that
>> +		 * V4L2_CID_FLASH_TORCH_INTENSITY control value
>> +		 * has changed.
>> +		 */
>> +		if (ctrl->led_mode->val == V4L2_FLASH_LED_MODE_TORCH) {
>> +			ret = call_flash_op(v4l2_flash, torch_brightness_update,
>> +							led_cdev);
>> +			if (ret < 0)
>> +				return ret;
>> +			ctrl->torch_intensity->val =
>> +				v4l2_flash_led_brightness_to_intensity(
>> +						&config->torch_intensity,
>> +						led_cdev->brightness);
>> +		}
>> +		return 0;
>> +	case V4L2_CID_FLASH_INTENSITY:
>> +		ret = call_flash_op(v4l2_flash, flash_brightness_update,
>> +					flash);
>> +		if (ret < 0)
>> +			return ret;
>> +		/* no conversion is needed */
>> +		c->val = flash->brightness.val;
>> +		return 0;
>> +	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
>> +		ret = call_flash_op(v4l2_flash, indicator_brightness_update,
>> +						flash);
>> +		if (ret < 0)
>> +			return ret;
>> +		/* no conversion is needed */
>> +		c->val = flash->indicator_brightness->val;
>> +		return 0;
>> +	case V4L2_CID_FLASH_STROBE_STATUS:
>> +		ret = call_flash_op(v4l2_flash, strobe_get, flash,
>> +							&is_strobing);
>> +		if (ret < 0)
>> +			return ret;
>> +		c->val = is_strobing;
>> +		return 0;
>> +	case V4L2_CID_FLASH_FAULT:
>> +		/* led faults map directly to V4L2 flash faults */
>> +		ret = call_flash_op(v4l2_flash, fault_get, flash, &c->val);
>> +		return ret;
>> +	case V4L2_CID_FLASH_STROBE_SOURCE:
>> +		c->val = flash->external_strobe;
>> +		return 0;
>> +	case V4L2_CID_FLASH_STROBE_PROVIDER:
>> +		c->val = flash->strobe_provider_id;
>> +		return 0;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +}
>> +
>> +static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
>> +{
>> +	struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
>> +	struct led_classdev_flash *flash = v4l2_flash->flash;
>> +	struct v4l2_flash_ctrl *ctrl = &v4l2_flash->ctrl;
>> +	struct v4l2_flash_ctrl_config *config = &v4l2_flash->config;
>> +	enum led_brightness torch_brightness;
>> +	bool external_strobe;
>> +	int ret;
>> +
>> +	switch (c->id) {
>> +	case V4L2_CID_FLASH_LED_MODE:
>> +		switch (c->val) {
>> +		case V4L2_FLASH_LED_MODE_NONE:
>> +			call_flash_op(v4l2_flash, torch_brightness_set,
>> +							&flash->led_cdev, 0);
>> +			return call_flash_op(v4l2_flash, strobe_set, flash,
>> +							false);
>> +		case V4L2_FLASH_LED_MODE_FLASH:
>> +			/* Turn off torch LED */
>> +			call_flash_op(v4l2_flash, torch_brightness_set,
>> +							&flash->led_cdev, 0);
>> +			external_strobe = (ctrl->source->val ==
>> +					V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
>> +			return call_flash_op(v4l2_flash, external_strobe_set,
>> +						flash, external_strobe);
>> +		case V4L2_FLASH_LED_MODE_TORCH:
>> +			/* Stop flash strobing */
>> +			ret = call_flash_op(v4l2_flash, strobe_set, flash,
>> +							false);
>> +			if (ret)
>> +				return ret;
>> +
>> +			torch_brightness =
>> +				v4l2_flash_intensity_to_led_brightness(
>> +						&config->torch_intensity,
>> +						ctrl->torch_intensity->val);
>> +			call_flash_op(v4l2_flash, torch_brightness_set,
>> +					&flash->led_cdev, torch_brightness);
>> +			return ret;
>> +		}
>> +		break;
>> +	case V4L2_CID_FLASH_STROBE_SOURCE:
>> +		external_strobe = (c->val == V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
>
> Is the external_strobe argument match exactly to the strobe source
> control? You seem to assume that in g_volatile_ctrl() above. I think
> having it the either way is fine but not both. :-)

The STROBE_SOURCE_EXTERNAL control state is volatile if a flash device
depends on muxes that route strobe signals to more then one flash
device. In such a case it behaves similarly to FLASH_STROBE control,
i.e. it activates external strobe only for the flash timeout period.
I touched this issue in the cover letter of this patch series,
paragraph 2.

>
>> +		return call_flash_op(v4l2_flash, external_strobe_set, flash,
>> +							external_strobe);
>> +	case V4L2_CID_FLASH_STROBE:
>> +		if (ctrl->led_mode->val != V4L2_FLASH_LED_MODE_FLASH ||
>> +		    ctrl->source->val != V4L2_FLASH_STROBE_SOURCE_SOFTWARE)
>> +			return -EINVAL;
>> +		return call_flash_op(v4l2_flash, strobe_set, flash, true);
>> +	case V4L2_CID_FLASH_STROBE_STOP:
>
> Should we check the flash mode here? I guess so. How about strobe source
> as well?

Good point.

>> +		return call_flash_op(v4l2_flash, strobe_set, flash, false);
>> +	case V4L2_CID_FLASH_TIMEOUT:
>> +		return call_flash_op(v4l2_flash, timeout_set, flash, c->val);
>> +	case V4L2_CID_FLASH_INTENSITY:
>> +		/* no conversion is needed */
>> +		return call_flash_op(v4l2_flash, flash_brightness_set, flash,
>> +								c->val);
>> +	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
>> +		/* no conversion is needed */
>> +		return call_flash_op(v4l2_flash, indicator_brightness_set,
>> +						flash, c->val);
>> +	case V4L2_CID_FLASH_TORCH_INTENSITY:
>> +		/*
>> +		 * If not in MODE_TORCH don't call led-class brightness_set
>> +		 * op, as it would result in turning the torch led on.
>> +		 * Instead the value is cached only and will be written
>> +		 * to the device upon transition to MODE_TORCH.
>> +		 */
>> +		if (ctrl->led_mode->val == V4L2_FLASH_LED_MODE_TORCH) {
>> +			torch_brightness =
>> +				v4l2_flash_intensity_to_led_brightness(
>> +						&config->torch_intensity,
>> +						ctrl->torch_intensity->val);
>> +			call_flash_op(v4l2_flash, torch_brightness_set,
>> +					&flash->led_cdev, torch_brightness);
>> +		}
>> +		return 0;
>> +	case V4L2_CID_FLASH_STROBE_PROVIDER:
>> +		flash->strobe_provider_id = c->val;
>> +		return 0;
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +static const struct v4l2_ctrl_ops v4l2_flash_ctrl_ops = {
>> +	.g_volatile_ctrl = v4l2_flash_g_volatile_ctrl,
>> +	.s_ctrl = v4l2_flash_s_ctrl,
>> +};
>> +
>> +static int v4l2_flash_init_strobe_providers_menu(struct v4l2_flash *v4l2_flash)
>> +{
>> +	struct led_classdev_flash *flash = v4l2_flash->flash;
>> +	struct led_flash_strobe_provider *provider;
>> +	struct v4l2_ctrl *ctrl;
>> +	int i = 0;
>> +
>> +	v4l2_flash->strobe_providers_menu =
>> +			kzalloc(sizeof(char *) * (flash->num_strobe_providers),
>> +					GFP_KERNEL);
>> +	if (!v4l2_flash->strobe_providers_menu)
>> +		return -ENOMEM;
>> +
>> +	list_for_each_entry(provider, &flash->strobe_providers, list)
>> +		v4l2_flash->strobe_providers_menu[i++] =
>> +						(char *) provider->name;
>> +
>> +	ctrl = v4l2_ctrl_new_std_menu_items(
>> +		&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
>> +		V4L2_CID_FLASH_STROBE_PROVIDER,
>> +		flash->num_strobe_providers - 1,
>> +		0, 0,
>> +		(const char * const *) v4l2_flash->strobe_providers_menu);
>> +
>> +	if (ctrl)
>> +		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
>> +
>> +	return 0;
>> +}
>> +
>> +static int v4l2_flash_init_controls(struct v4l2_flash *v4l2_flash)
>> +
>> +{
>> +	struct led_classdev_flash *flash = v4l2_flash->flash;
>> +	const struct led_flash_ops *flash_ops = flash->ops;
>> +	struct led_classdev *led_cdev = &flash->led_cdev;
>> +	struct v4l2_flash_ctrl_config *config = &v4l2_flash->config;
>> +	struct v4l2_ctrl *ctrl;
>> +	struct v4l2_ctrl_config *ctrl_cfg;
>> +	bool has_flash = led_cdev->flags & LED_DEV_CAP_FLASH;
>> +	bool has_indicator = led_cdev->flags & LED_DEV_CAP_INDICATOR;
>> +	bool has_strobe_providers = (flash->num_strobe_providers > 1);
>> +	unsigned int mask;
>> +	int ret, max, num_ctrls;
>> +
>> +	num_ctrls = has_flash ? 5 : 2;
>> +	if (has_flash) {
>> +		if (flash_ops->flash_brightness_set)
>> +			++num_ctrls;
>> +		if (flash_ops->timeout_set)
>> +			++num_ctrls;
>> +		if (flash_ops->strobe_get)
>> +			++num_ctrls;
>> +		if (has_indicator)
>> +			++num_ctrls;
>> +		if (config->flash_faults)
>> +			++num_ctrls;
>> +		if (has_strobe_providers)
>> +			++num_ctrls;
>> +	}
>> +
>> +	v4l2_ctrl_handler_init(&v4l2_flash->hdl, num_ctrls);
>> +
>> +	mask = 1 << V4L2_FLASH_LED_MODE_NONE |
>> +	       1 << V4L2_FLASH_LED_MODE_TORCH;
>> +	if (flash)
>> +		mask |= 1 << V4L2_FLASH_LED_MODE_FLASH;
>> +
>> +	/* Configure FLASH_LED_MODE ctrl */
>> +	v4l2_flash->ctrl.led_mode = v4l2_ctrl_new_std_menu(
>> +			&v4l2_flash->hdl,
>> +			&v4l2_flash_ctrl_ops, V4L2_CID_FLASH_LED_MODE,
>> +			V4L2_FLASH_LED_MODE_TORCH, ~mask,
>> +			V4L2_FLASH_LED_MODE_NONE);
>> +
>> +	/* Configure TORCH_INTENSITY ctrl */
>> +	ctrl_cfg = &config->torch_intensity;
>> +	ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
>> +				 V4L2_CID_FLASH_TORCH_INTENSITY,
>> +				 ctrl_cfg->min, ctrl_cfg->max,
>> +				 ctrl_cfg->step, ctrl_cfg->def);
>> +	if (ctrl)
>> +		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
>> +	v4l2_flash->ctrl.torch_intensity = ctrl;
>> +
>> +	if (has_flash) {
>> +		/* Configure FLASH_STROBE_SOURCE ctrl */
>> +		mask = 1 << V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
>> +
>> +		if (flash->has_external_strobe) {
>> +			mask |= 1 << V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
>> +			max = V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
>> +		} else {
>> +			max = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
>> +		}
>> +
>> +		v4l2_flash->ctrl.source = v4l2_ctrl_new_std_menu(
>> +					&v4l2_flash->hdl,
>> +					&v4l2_flash_ctrl_ops,
>> +					V4L2_CID_FLASH_STROBE_SOURCE,
>> +					max,
>> +					~mask,
>> +					V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
>> +		if (v4l2_flash->ctrl.source)
>> +			v4l2_flash->ctrl.source->flags |=
>> +						V4L2_CTRL_FLAG_VOLATILE;
>> +
>> +		/* Configure FLASH_STROBE ctrl */
>> +		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
>> +					  V4L2_CID_FLASH_STROBE, 0, 1, 1, 0);
>> +
>> +		/* Configure FLASH_STROBE_STOP ctrl */
>> +		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
>> +					  V4L2_CID_FLASH_STROBE_STOP,
>> +					  0, 1, 1, 0);
>> +
>> +		/* Configure FLASH_STROBE_STATUS ctrl */
>> +		ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
>> +					 V4L2_CID_FLASH_STROBE_STATUS,
>> +					 0, 1, 1, 1);
>
> I think you only should implement the strobe status control if you
> really can know it, i.e. have strobe_get().

Of course, thanks.

>> +		if (flash_ops->strobe_get)
>> +			if (ctrl)
>> +				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
>> +					       V4L2_CTRL_FLAG_READ_ONLY;
>> +
>> +		if (flash_ops->timeout_set) {
>> +			/* Configure FLASH_TIMEOUT ctrl */
>> +			ctrl_cfg = &config->flash_timeout;
>> +			ctrl = v4l2_ctrl_new_std(
>> +					&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
>> +					V4L2_CID_FLASH_TIMEOUT, ctrl_cfg->min,
>> +					ctrl_cfg->max, ctrl_cfg->step,
>> +					ctrl_cfg->def);
>> +			if (ctrl)
>> +				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
>> +		}
>> +
>> +		if (flash_ops->flash_brightness_set) {
>> +			/* Configure FLASH_INTENSITY ctrl */
>> +			ctrl_cfg = &config->flash_intensity;
>> +			ctrl = v4l2_ctrl_new_std(
>> +					&v4l2_flash->hdl,
>> +					&v4l2_flash_ctrl_ops,
>> +					V4L2_CID_FLASH_INTENSITY,
>> +					ctrl_cfg->min, ctrl_cfg->max,
>> +					ctrl_cfg->step, ctrl_cfg->def);
>> +			if (ctrl)
>> +				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
>> +		}
>> +
>> +		if (config->flash_faults) {
>> +			/* Configure FLASH_FAULT ctrl */
>> +			ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl,
>> +						 &v4l2_flash_ctrl_ops,
>> +						 V4L2_CID_FLASH_FAULT, 0,
>> +						 config->flash_faults,
>> +						 0, 0);
>> +			if (ctrl)
>> +				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE |
>> +					       V4L2_CTRL_FLAG_READ_ONLY;
>> +		}
>> +		if (has_indicator) {
>> +			/* Configure FLASH_INDICATOR_INTENSITY ctrl */
>> +			ctrl_cfg = &config->indicator_intensity;
>> +			ctrl = v4l2_ctrl_new_std(
>> +					&v4l2_flash->hdl, &v4l2_flash_ctrl_ops,
>> +					V4L2_CID_FLASH_INDICATOR_INTENSITY,
>> +					ctrl_cfg->min, ctrl_cfg->max,
>> +					ctrl_cfg->step, ctrl_cfg->def);
>> +			if (ctrl)
>> +				ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
>> +		}
>
> Could you implement the above in a loop? You're essentially repeating
> the same but with different parameters.

Sure.

>> +		if (has_strobe_providers) {
>> +			/* Configure V4L2_CID_FLASH_STROBE_PROVIDERS ctrl */
>> +			ret = v4l2_flash_init_strobe_providers_menu(v4l2_flash);
>> +			if (ret < 0)
>> +				goto error_free_handler;
>> +		}
>> +	}
>> +
>> +	if (v4l2_flash->hdl.error) {
>> +		ret = v4l2_flash->hdl.error;
>> +		goto error_free_handler;
>> +	}
>> +
>> +	ret = v4l2_ctrl_handler_setup(&v4l2_flash->hdl);
>> +	if (ret < 0)
>> +		goto error_free_handler;
>> +
>> +	v4l2_flash->sd.ctrl_handler = &v4l2_flash->hdl;
>> +
>> +	return 0;
>> +
>> +error_free_handler:
>> +	v4l2_ctrl_handler_free(&v4l2_flash->hdl);
>> +	return ret;
>> +}
>> +
>> +/*
>> + * V4L2 subdev internal operations
>> + */
>> +
>> +static int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>> +{
>> +	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
>> +	struct led_classdev_flash *flash = v4l2_flash->flash;
>> +	struct led_classdev *led_cdev = &flash->led_cdev;
>> +
>> +	mutex_lock(&led_cdev->led_lock);
>> +	call_flash_op(v4l2_flash, sysfs_lock, led_cdev);
>
> What if you have the device open through multiple file handles? I
> believe v4l2_subdev_fh_is_singular(&fh->vfh) would prove helpful here.

I assume you propose to implement such a function? I don't see it in
the mainline kernel.

>> +	mutex_unlock(&led_cdev->led_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static int v4l2_flash_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>> +{
>> +	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
>> +	struct led_classdev_flash *flash = v4l2_flash->flash;
>> +	struct led_classdev *led_cdev = &flash->led_cdev;
>> +
>> +	mutex_lock(&led_cdev->led_lock);
>> +	call_flash_op(v4l2_flash, sysfs_unlock, led_cdev);
>> +	mutex_unlock(&led_cdev->led_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +int v4l2_flash_register(struct v4l2_flash *v4l2_flash)
>
> Do you expect to call this from elsewhere than this file?

No, I just forgot about 'static' keyword here :)

>> +{
>> +	struct led_classdev_flash *flash = v4l2_flash->flash;
>> +	struct led_classdev *led_cdev = &flash->led_cdev;
>> +	int ret;
>> +
>> +	if (!v4l2_dev) {
>> +		v4l2_dev = kzalloc(sizeof(*v4l2_dev), GFP_KERNEL);
>> +		if (!v4l2_dev)
>> +			return -ENOMEM;
>> +
>> +		strlcpy(v4l2_dev->name, "v4l2-flash-manager",
>> +						sizeof(v4l2_dev->name));
>> +		ret = v4l2_device_register(NULL, v4l2_dev);
>> +		if (ret < 0) {
>> +			dev_err(led_cdev->dev->parent,
>> +				 "Failed to register v4l2_device: %d\n", ret);
>> +			goto err_v4l2_device_register;
>> +		}
>> +	}
>> +
>> +	ret = v4l2_device_register_subdev(v4l2_dev, &v4l2_flash->sd);
>> +	if (ret < 0) {
>> +		dev_err(led_cdev->dev->parent,
>> +			 "Failed to register v4l2_subdev: %d\n", ret);
>> +		goto err_v4l2_device_register;
>> +	}
>> +
>> +	ret = v4l2_device_register_subdev_node(&v4l2_flash->sd, v4l2_dev);
>> +	if (ret < 0) {
>> +		dev_err(led_cdev->dev->parent,
>> +			 "Failed to register v4l2_subdev node: %d\n", ret);
>> +		goto err_register_subdev_node;
>> +	}
>
> This way you can create a V4L2 sub-device node. However, flash devices
> are seldom alone in the system. They are physically close to a sensor,
> and this connection is shown in the Media controller interface. This
> means that the flash sub-device (entity) should be part of the Media
> device created by the driver in control of it. This can be achieved by
> the master driver creating the sub-device. You should register an async
> sub-device here.
>
> This results in the sub-device not being registered if there's no such
> master driver, but I wouldn't expect that to be an issue since the V4L2
> flash API is mostly relevant in such cases.

I addressed this issue in the cover letter of this patch series,
paragraph 1. If strobe signals are routed to a flash device through
a multiplexer then assignment of the related V4L2 Flash sub-device
to a particular media controller may dynamically change in time.
Actually, if a flash device can be shared between media systems
(i.e. it can be configured to react on strobe signals from different
camera sensors, basing on muxes configuration), than it becomes
bound to a particular media system only for the time of strobing.
Please refer to [1].

>> +	++registered_flashes;
>> +
>> +	return 0;
>> +
>> +err_register_subdev_node:
>> +	v4l2_device_unregister_subdev(&v4l2_flash->sd);
>> +err_v4l2_device_register:
>> +	kfree(v4l2_flash->strobe_providers_menu);
>> +	if (v4l2_dev && registered_flashes == 0) {
>> +		v4l2_device_unregister(v4l2_dev);
>> +		kfree(v4l2_dev);
>> +		v4l2_dev = NULL;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static void v4l2_flash_unregister(struct v4l2_flash *v4l2_flash)
>> +{
>> +	if (registered_flashes == 0)
>> +		return;
>> +
>> +	v4l2_device_unregister_subdev(&v4l2_flash->sd);
>> +
>> +	--registered_flashes;
>> +
>> +	if (registered_flashes == 0) {
>> +		v4l2_device_unregister(v4l2_dev);
>> +		kfree(v4l2_dev);
>> +		v4l2_dev = NULL;
>> +	}
>> +}
>> +
>> +static const struct v4l2_subdev_internal_ops v4l2_flash_subdev_internal_ops = {
>> +	.open = v4l2_flash_open,
>> +	.close = v4l2_flash_close,
>> +};
>> +
>> +static const struct v4l2_subdev_core_ops v4l2_flash_core_ops = {
>> +	.queryctrl = v4l2_subdev_queryctrl,
>> +	.querymenu = v4l2_subdev_querymenu,
>> +};
>> +
>> +static const struct v4l2_subdev_ops v4l2_flash_subdev_ops = {
>> +	.core = &v4l2_flash_core_ops,
>> +};
>> +
>> +int v4l2_flash_init(struct led_classdev_flash *flash,
>> +		    struct v4l2_flash_ctrl_config *config,
>> +		    const struct v4l2_flash_ops *flash_ops,
>> +		    struct v4l2_flash **out_flash)
>> +{
>> +	struct v4l2_flash *v4l2_flash;
>> +	struct led_classdev *led_cdev = &flash->led_cdev;
>> +	struct v4l2_subdev *sd;
>> +	int ret;
>> +
>> +	if (!flash || !config || !out_flash)
>> +		return -EINVAL;
>> +
>> +	v4l2_flash = kzalloc(sizeof(*v4l2_flash), GFP_KERNEL);
>> +	if (!v4l2_flash)
>> +		return -ENOMEM;
>> +
>> +	sd = &v4l2_flash->sd;
>> +	v4l2_flash->flash = flash;
>> +	v4l2_flash->ops = flash_ops;
>> +	sd->dev = led_cdev->dev->parent;
>> +	v4l2_subdev_init(sd, &v4l2_flash_subdev_ops);
>> +	sd->internal_ops = &v4l2_flash_subdev_internal_ops;
>> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>> +	snprintf(sd->name, sizeof(sd->name), led_cdev->name);
>> +
>> +	v4l2_flash->config = *config;
>> +	ret = v4l2_flash_init_controls(v4l2_flash);
>> +	if (ret < 0)
>> +		goto err_init_controls;
>> +
>> +	ret = media_entity_init(&sd->entity, 0, NULL, 0);
>> +	if (ret < 0)
>> +		goto err_init_entity;
>> +
>> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
>> +
>> +	ret = v4l2_flash_register(v4l2_flash);
>> +	if (ret < 0)
>> +		goto err_init_entity;
>> +
>> +	*out_flash = v4l2_flash;
>
> How about returning the pointer instead?

OK.

>> +	return 0;
>> +
>> +err_init_entity:
>> +	media_entity_cleanup(&sd->entity);
>> +err_init_controls:
>> +	v4l2_ctrl_handler_free(sd->ctrl_handler);
>> +	kfree(v4l2_flash);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_flash_init);
>> +
>> +void v4l2_flash_release(struct v4l2_flash *v4l2_flash)
>> +{
>> +	if (!v4l2_flash)
>> +		return;
>> +
>> +	v4l2_flash_unregister(v4l2_flash);
>> +	v4l2_ctrl_handler_free(v4l2_flash->sd.ctrl_handler);
>> +	media_entity_cleanup(&v4l2_flash->sd.entity);
>> +	kfree(v4l2_flash->strobe_providers_menu);
>> +	kfree(v4l2_flash);
>> +}
>> +EXPORT_SYMBOL_GPL(v4l2_flash_release);
>> diff --git a/include/media/v4l2-flash.h b/include/media/v4l2-flash.h
>> new file mode 100644
>> index 0000000..effa46b
>> --- /dev/null
>> +++ b/include/media/v4l2-flash.h
>> @@ -0,0 +1,137 @@
>> +/*
>> + * V4L2 Flash LED sub-device registration helpers.
>> + *
>> + *	Copyright (C) 2014 Samsung Electronics Co., Ltd
>> + *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation."
>> + */
>> +
>> +#ifndef _V4L2_FLASH_H
>> +#define _V4L2_FLASH_H
>> +
>> +#include <media/v4l2-ctrls.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-dev.h>
>> +#include <media/v4l2-event.h>
>> +#include <media/v4l2-ioctl.h>
>> +
>> +struct led_classdev_flash;
>> +struct led_classdev;
>> +enum led_brightness;
>> +
>> +struct v4l2_flash_ops {
>> +	int (*torch_brightness_set)(struct led_classdev *led_cdev,
>> +					enum led_brightness brightness);
>> +	int (*torch_brightness_update)(struct led_classdev *led_cdev);
>> +	int (*flash_brightness_set)(struct led_classdev_flash *flash,
>> +					u32 brightness);
>> +	int (*flash_brightness_update)(struct led_classdev_flash *flash);
>> +	int (*strobe_set)(struct led_classdev_flash *flash, bool state);
>> +	int (*strobe_get)(struct led_classdev_flash *flash, bool *state);
>> +	int (*timeout_set)(struct led_classdev_flash *flash, u32 timeout);
>> +	int (*indicator_brightness_set)(struct led_classdev_flash *flash,
>> +					u32 brightness);
>> +	int (*indicator_brightness_update)(struct led_classdev_flash *flash);
>> +	int (*external_strobe_set)(struct led_classdev_flash *flash,
>> +					bool enable);
>> +	int (*fault_get)(struct led_classdev_flash *flash, u32 *fault);
>> +	void (*sysfs_lock)(struct led_classdev *led_cdev);
>> +	void (*sysfs_unlock)(struct led_classdev *led_cdev);
>
> These functions are not driver specific and there's going to be just one
> implementation (I suppose). Could you refresh my memory regarding why
> the LED framework functions aren't called directly?

These ops are required to make possible building led-class-flash as a 
kernel module.

>> +};
>> +
>> +/**
>> + * struct v4l2_flash_ctrl - controls that define the sub-dev's state
>> + * @source:		V4L2_CID_FLASH_STROBE_SOURCE control
>> + * @led_mode:		V4L2_CID_FLASH_LED_MODE control
>> + * @torch_intensity:	V4L2_CID_FLASH_TORCH_INTENSITY control
>> + */
>> +struct v4l2_flash_ctrl {
>> +	struct v4l2_ctrl *source;
>> +	struct v4l2_ctrl *led_mode;
>> +	struct v4l2_ctrl *torch_intensity;
>> +};
>> +
>> +/**
>> + * struct v4l2_flash_ctrl_config - V4L2 Flash controls initialization data
>> + * @torch_intensity:		V4L2_CID_FLASH_TORCH_INTENSITY constraints
>> + * @flash_intensity:		V4L2_CID_FLASH_INTENSITY constraints
>> + * @indicator_intensity:	V4L2_CID_FLASH_INDICATOR_INTENSITY constraints
>> + * @flash_timeout:		V4L2_CID_FLASH_TIMEOUT constraints
>> + * @flash_fault:		possible flash faults
>> + */
>> +struct v4l2_flash_ctrl_config {
>> +	struct v4l2_ctrl_config torch_intensity;
>> +	struct v4l2_ctrl_config flash_intensity;
>> +	struct v4l2_ctrl_config indicator_intensity;
>> +	struct v4l2_ctrl_config flash_timeout;
>> +	u32 flash_faults;
>> +};
>> +
>> +/**
>> + * struct v4l2_flash - Flash sub-device context
>> + * @flash:		LED Flash Class device controlled by this sub-device
>> + * @ops:		LED Flash Class device ops
>> + * @sd:			V4L2 sub-device
>> + * @hdl:		flash controls handler
>> + * @ctrl:		state defining controls
>> + * @config:		V4L2 Flash controlsrconfiguration data
>> + * @software_strobe_gates: route to the software strobe signal
>> + * @external_strobe_gates: route to the external strobe signal
>> + * @sensors:		available external strobe sources
>> + */
>> +struct v4l2_flash {
>> +	struct led_classdev_flash *flash;
>> +	const struct v4l2_flash_ops *ops;
>> +
>> +	struct v4l2_subdev sd;
>> +	struct v4l2_ctrl_handler hdl;
>> +	struct v4l2_flash_ctrl ctrl;
>> +	struct v4l2_flash_ctrl_config config;
>> +	char **strobe_providers_menu;
>> +};
>> +
>> +static inline struct v4l2_flash *v4l2_subdev_to_v4l2_flash(
>> +							struct v4l2_subdev *sd)
>> +{
>> +	return container_of(sd, struct v4l2_flash, sd);
>> +}
>> +
>> +static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
>> +{
>> +	return container_of(c->handler, struct v4l2_flash, hdl);
>> +}
>> +
>> +#ifdef CONFIG_V4L2_FLASH_LED_CLASS
>> +/**
>> + * v4l2_flash_init - initialize V4L2 flash led sub-device
>> + * @led_fdev:	the LED Flash Class device to wrap
>> + * @config:	initialization data for V4L2 Flash controls
>> + * @flash_ops:	V4L2 Flash device ops
>> + * @out_flash:	handler to the new V4L2 Flash device
>> + *
>> + * Create V4L2 subdev wrapping given LED subsystem device.
>> +
>> + * Returns: 0 on success or negative error value on failure
>> + */
>> +int v4l2_flash_init(struct led_classdev_flash *led_fdev,
>> +		    struct v4l2_flash_ctrl_config *config,
>> +		    const struct v4l2_flash_ops *flash_ops,
>> +		    struct v4l2_flash **out_flash);
>> +
>> +/**
>> + * v4l2_flash_release - release V4L2 Flash sub-device
>> + * @flash: the V4L2 Flash device to release
>> + *
>> + * Release V4L2 flash led subdev.
>> + */
>> +void v4l2_flash_release(struct v4l2_flash *v4l2_flash);
>> +
>> +#else
>> +#define v4l2_flash_init(led_cdev, config, flash_ops, out_flash) (0)
>> +#define v4l2_flash_release(v4l2_flash)
>> +#endif /* CONFIG_V4L2_FLASH_LED_CLASS */
>> +
>> +#endif /* _V4L2_FLASH_H */
>>
>

Best Regards,
Jacek Anaszewski

[1] - https://lkml.org/lkml/2014/7/11/942
