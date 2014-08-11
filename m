Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaHKN12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:27:28 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61851 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbaHKN10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:27:26 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-d2-53e8c4bbe904
Message-id: <53E8C4BA.6050805@samsung.com>
Date: Mon, 11 Aug 2014 15:27:22 +0200
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
 <53CCF59E.3070200@iki.fi> <53DF9C2A.8060403@samsung.com>
 <20140811122628.GG16460@valkosipuli.retiisi.org.uk>
In-reply-to: <20140811122628.GG16460@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xK7q7j7wINvj0kdVi44z1rBbzj5xj
	tVjycxeTxdmmN+wWl3fNYbPY+mYdo0XPhq2sFmf2r2Rz4PCY8nsjq8fhrwtZPPq2rGL0+LxJ
	LoAlissmJTUnsyy1SN8ugStjyu+0gon1FV23L7A1MPZmdDFyckgImEgsW76WBcIWk7hwbz1b
	FyMXh5DAUkaJb1f2MkE4HxklFr+4ywRSxSugJTGjaQWYzSKgKnGj/xaYzSZgKPHzxWswW1Qg
	QuLP6X2sEPWCEj8m3wPbICKgJvF000MWkKHMAtcZJVa8e8gOkhAWCJBYcHkmK8S2n4wSx970
	MIMkOAUcJGasPgE2iVnAWmLlpG2MELa8xOY1b5knMArMQrJkFpKyWUjKFjAyr2IUTS1NLihO
	Ss811CtOzC0uzUvXS87P3cQICfQvOxgXH7M6xCjAwajEw2tw+m6wEGtiWXFl7iFGCQ5mJRHe
	W6teBAvxpiRWVqUW5ccXleakFh9iZOLglGpg9Jp5/PK2oq2aHi8rXMKCPuldfGTxZ3LT/zmL
	Dc9aBgXmmF84GSW+dNnOwrnz7YXPH/RWO6Dwp3fHq1s5lcwC+/fxMeevn+BlonpV64aTx/LO
	3f3aks5bgtYHmrUlbimJmPh/Wp2jSRR/gq94UdAuzd8Vx74ZfzrS33fl+1/FddM5ZP26hWX+
	KrEUZyQaajEXFScCAKm1EI5SAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari

On 08/11/2014 02:26 PM, Sakari Ailus wrote:
>
> Hi Jacek,
>
> On Mon, Aug 04, 2014 at 04:43:54PM +0200, Jacek Anaszewski wrote:
>> Hi Sakari,
>>
>> Thanks for the review.
>
> You're welcome! :)
>
>> On 07/21/2014 01:12 PM, Sakari Ailus wrote:
>>> Hi Jacek,
>>>
>>> Jacek Anaszewski wrote:
>>>> This patch adds helper functions for registering/unregistering
>>>> LED class flash devices as V4L2 subdevs. The functions should
>>>> be called from the LED subsystem device driver. In case the
>>>> support for V4L2 Flash sub-devices is disabled in the kernel
>>>> config the functions' empty versions will be used.
>>>>
>>>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>>>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>>>> ---
>>>>   drivers/media/v4l2-core/Kconfig      |   11 +
>>>>   drivers/media/v4l2-core/Makefile     |    2 +
>>>>   drivers/media/v4l2-core/v4l2-flash.c |  580 ++++++++++++++++++++++++++++++++++
>>>>   include/media/v4l2-flash.h           |  137 ++++++++
>>>>   4 files changed, 730 insertions(+)
>>>>   create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
>>>>   create mode 100644 include/media/v4l2-flash.h
>>>>
>>>> diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
>>>> index 9ca0f8d..3ae3f0f 100644
>>>> --- a/drivers/media/v4l2-core/Kconfig
>>>> +++ b/drivers/media/v4l2-core/Kconfig
>>>> @@ -35,6 +35,17 @@ config V4L2_MEM2MEM_DEV
>>>>           tristate
>>>>           depends on VIDEOBUF2_CORE
>>>>
>>>> +# Used by LED subsystem flash drivers
>>>> +config V4L2_FLASH_LED_CLASS
>>>> +	bool "Enable support for Flash sub-devices"
>>>> +	depends on VIDEO_V4L2_SUBDEV_API
>>>> +	depends on LEDS_CLASS_FLASH
>>>> +	---help---
>>>> +	  Say Y here to enable support for Flash sub-devices, which allow
>>>> +	  to control LED class devices with use of V4L2 Flash controls.
>>>> +
>>>> +	  When in doubt, say N.
>>>> +
>>>>   # Used by drivers that need Videobuf modules
>>>>   config VIDEOBUF_GEN
>>>>   	tristate
>>>> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
>>>> index 63d29f2..44e858c 100644
>>>> --- a/drivers/media/v4l2-core/Makefile
>>>> +++ b/drivers/media/v4l2-core/Makefile
>>>> @@ -22,6 +22,8 @@ obj-$(CONFIG_VIDEO_TUNER) += tuner.o
>>>>
>>>>   obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
>>>>
>>>> +obj-$(CONFIG_V4L2_FLASH_LED_CLASS) += v4l2-flash.o
>>>> +
>>>>   obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
>>>>   obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
>>>>   obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
>>>> diff --git a/drivers/media/v4l2-core/v4l2-flash.c b/drivers/media/v4l2-core/v4l2-flash.c
>>>> new file mode 100644
>>>> index 0000000..21080c6
>>>> --- /dev/null
>>>> +++ b/drivers/media/v4l2-core/v4l2-flash.c
>>>> @@ -0,0 +1,580 @@
>>>> +/*
>>>> + * V4L2 Flash LED sub-device registration helpers.
>>>> + *
>>>> + *	Copyright (C) 2014 Samsung Electronics Co., Ltd
>>>> + *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License version 2 as
>>>> + * published by the Free Software Foundation."
>>>> + */
>>>> +
>>>> +#include <linux/led-class-flash.h>
>>>> +#include <linux/mutex.h>
>>>> +#include <linux/of_led_flash_manager.h>
>>>> +#include <linux/slab.h>
>>>> +#include <media/v4l2-flash.h>
>>>> +
>>>> +#define call_flash_op(v4l2_flash, op, args...)			\
>>>> +		(v4l2_flash->ops->op  ?				\
>>>> +			v4l2_flash->ops->op(args) :		\
>>>> +			-EINVAL)
>>>> +
>>>> +static struct v4l2_device *v4l2_dev;
>>>> +static int registered_flashes;
>>>> +
>>>> +static inline enum led_brightness v4l2_flash_intensity_to_led_brightness(
>>>> +					struct v4l2_ctrl_config *config,
>>>> +					s32 intensity)
>>>> +{
>>>> +	return ((intensity - config->min) / config->step) + 1;
>>>> +}
>>>> +
>>>> +static inline s32 v4l2_flash_led_brightness_to_intensity(
>>>> +					struct v4l2_ctrl_config *config,
>>>> +					enum led_brightness brightness)
>>>> +{
>>>> +	return ((brightness - 1) * config->step) + config->min;
>>>> +}
>>>> +
>>>> +static int v4l2_flash_g_volatile_ctrl(struct v4l2_ctrl *c)
>>>> +
>>>> +{
>>>> +	struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
>>>> +	struct led_classdev_flash *flash = v4l2_flash->flash;
>>>> +	struct led_classdev *led_cdev = &flash->led_cdev;
>>>> +	struct v4l2_flash_ctrl_config *config = &v4l2_flash->config;
>>>> +	struct v4l2_flash_ctrl *ctrl = &v4l2_flash->ctrl;
>>>> +	bool is_strobing;
>>>> +	int ret;
>>>> +
>>>> +	switch (c->id) {
>>>> +	case V4L2_CID_FLASH_TORCH_INTENSITY:
>>>> +		/*
>>>> +		 * Update torch brightness only if in TORCH_MODE,
>>>> +		 * as otherwise brightness_update op returns 0,
>>>> +		 * which would spuriously inform user space that
>>>> +		 * V4L2_CID_FLASH_TORCH_INTENSITY control value
>>>> +		 * has changed.
>>>> +		 */
>>>> +		if (ctrl->led_mode->val == V4L2_FLASH_LED_MODE_TORCH) {
>>>> +			ret = call_flash_op(v4l2_flash, torch_brightness_update,
>>>> +							led_cdev);
>>>> +			if (ret < 0)
>>>> +				return ret;
>>>> +			ctrl->torch_intensity->val =
>>>> +				v4l2_flash_led_brightness_to_intensity(
>>>> +						&config->torch_intensity,
>>>> +						led_cdev->brightness);
>>>> +		}
>>>> +		return 0;
>>>> +	case V4L2_CID_FLASH_INTENSITY:
>>>> +		ret = call_flash_op(v4l2_flash, flash_brightness_update,
>>>> +					flash);
>>>> +		if (ret < 0)
>>>> +			return ret;
>>>> +		/* no conversion is needed */
>>>> +		c->val = flash->brightness.val;
>>>> +		return 0;
>>>> +	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
>>>> +		ret = call_flash_op(v4l2_flash, indicator_brightness_update,
>>>> +						flash);
>>>> +		if (ret < 0)
>>>> +			return ret;
>>>> +		/* no conversion is needed */
>>>> +		c->val = flash->indicator_brightness->val;
>>>> +		return 0;
>>>> +	case V4L2_CID_FLASH_STROBE_STATUS:
>>>> +		ret = call_flash_op(v4l2_flash, strobe_get, flash,
>>>> +							&is_strobing);
>>>> +		if (ret < 0)
>>>> +			return ret;
>>>> +		c->val = is_strobing;
>>>> +		return 0;
>>>> +	case V4L2_CID_FLASH_FAULT:
>>>> +		/* led faults map directly to V4L2 flash faults */
>>>> +		ret = call_flash_op(v4l2_flash, fault_get, flash, &c->val);
>>>> +		return ret;
>>>> +	case V4L2_CID_FLASH_STROBE_SOURCE:
>>>> +		c->val = flash->external_strobe;
>>>> +		return 0;
>>>> +	case V4L2_CID_FLASH_STROBE_PROVIDER:
>>>> +		c->val = flash->strobe_provider_id;
>>>> +		return 0;
>>>> +	default:
>>>> +		return -EINVAL;
>>>> +	}
>>>> +}
>>>> +
>>>> +static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
>>>> +{
>>>> +	struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
>>>> +	struct led_classdev_flash *flash = v4l2_flash->flash;
>>>> +	struct v4l2_flash_ctrl *ctrl = &v4l2_flash->ctrl;
>>>> +	struct v4l2_flash_ctrl_config *config = &v4l2_flash->config;
>>>> +	enum led_brightness torch_brightness;
>>>> +	bool external_strobe;
>>>> +	int ret;
>>>> +
>>>> +	switch (c->id) {
>>>> +	case V4L2_CID_FLASH_LED_MODE:
>>>> +		switch (c->val) {
>>>> +		case V4L2_FLASH_LED_MODE_NONE:
>>>> +			call_flash_op(v4l2_flash, torch_brightness_set,
>>>> +							&flash->led_cdev, 0);
>>>> +			return call_flash_op(v4l2_flash, strobe_set, flash,
>>>> +							false);
>>>> +		case V4L2_FLASH_LED_MODE_FLASH:
>>>> +			/* Turn off torch LED */
>>>> +			call_flash_op(v4l2_flash, torch_brightness_set,
>>>> +							&flash->led_cdev, 0);
>>>> +			external_strobe = (ctrl->source->val ==
>>>> +					V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
>>>> +			return call_flash_op(v4l2_flash, external_strobe_set,
>>>> +						flash, external_strobe);
>>>> +		case V4L2_FLASH_LED_MODE_TORCH:
>>>> +			/* Stop flash strobing */
>>>> +			ret = call_flash_op(v4l2_flash, strobe_set, flash,
>>>> +							false);
>>>> +			if (ret)
>>>> +				return ret;
>>>> +
>>>> +			torch_brightness =
>>>> +				v4l2_flash_intensity_to_led_brightness(
>>>> +						&config->torch_intensity,
>>>> +						ctrl->torch_intensity->val);
>>>> +			call_flash_op(v4l2_flash, torch_brightness_set,
>>>> +					&flash->led_cdev, torch_brightness);
>>>> +			return ret;
>>>> +		}
>>>> +		break;
>>>> +	case V4L2_CID_FLASH_STROBE_SOURCE:
>>>> +		external_strobe = (c->val == V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
>>>
>>> Is the external_strobe argument match exactly to the strobe source
>>> control? You seem to assume that in g_volatile_ctrl() above. I think
>>> having it the either way is fine but not both. :-)
>>
>> The STROBE_SOURCE_EXTERNAL control state is volatile if a flash device
>> depends on muxes that route strobe signals to more then one flash
>> device. In such a case it behaves similarly to FLASH_STROBE control,
>> i.e. it activates external strobe only for the flash timeout period.
>> I touched this issue in the cover letter of this patch series,
>> paragraph 2.
>
> I meant that flash->external_strobe is directly used as
> V4L2_CID_FLASH_STROBE_SOURCE. Are the two guaranteed to be the same?
>
> ...
>
>>>> +/*
>>>> + * V4L2 subdev internal operations
>>>> + */
>>>> +
>>>> +static int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>>>> +{
>>>> +	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
>>>> +	struct led_classdev_flash *flash = v4l2_flash->flash;
>>>> +	struct led_classdev *led_cdev = &flash->led_cdev;
>>>> +
>>>> +	mutex_lock(&led_cdev->led_lock);
>>>> +	call_flash_op(v4l2_flash, sysfs_lock, led_cdev);
>>>
>>> What if you have the device open through multiple file handles? I
>>> believe v4l2_subdev_fh_is_singular(&fh->vfh) would prove helpful here.
>>
>> I assume you propose to implement such a function? I don't see it in
>> the mainline kernel.
>
> Uh, I thought of v4l2_subdev_fh_is_singular() but what I really meant was
> v4l2_fh_is_singular(). There's no sub-device variant of it, as the
> sub-device file handle struct embeds struct v4l2_fh.

OK, I will use it here.

> ...
>
>>>> +{
>>>> +	struct led_classdev_flash *flash = v4l2_flash->flash;
>>>> +	struct led_classdev *led_cdev = &flash->led_cdev;
>>>> +	int ret;
>>>> +
>>>> +	if (!v4l2_dev) {
>>>> +		v4l2_dev = kzalloc(sizeof(*v4l2_dev), GFP_KERNEL);
>>>> +		if (!v4l2_dev)
>>>> +			return -ENOMEM;
>>>> +
>>>> +		strlcpy(v4l2_dev->name, "v4l2-flash-manager",
>>>> +						sizeof(v4l2_dev->name));
>>>> +		ret = v4l2_device_register(NULL, v4l2_dev);
>>>> +		if (ret < 0) {
>>>> +			dev_err(led_cdev->dev->parent,
>>>> +				 "Failed to register v4l2_device: %d\n", ret);
>>>> +			goto err_v4l2_device_register;
>>>> +		}
>>>> +	}
>>>> +
>>>> +	ret = v4l2_device_register_subdev(v4l2_dev, &v4l2_flash->sd);
>>>> +	if (ret < 0) {
>>>> +		dev_err(led_cdev->dev->parent,
>>>> +			 "Failed to register v4l2_subdev: %d\n", ret);
>>>> +		goto err_v4l2_device_register;
>>>> +	}
>>>> +
>>>> +	ret = v4l2_device_register_subdev_node(&v4l2_flash->sd, v4l2_dev);
>>>> +	if (ret < 0) {
>>>> +		dev_err(led_cdev->dev->parent,
>>>> +			 "Failed to register v4l2_subdev node: %d\n", ret);
>>>> +		goto err_register_subdev_node;
>>>> +	}
>>>
>>> This way you can create a V4L2 sub-device node. However, flash devices
>>> are seldom alone in the system. They are physically close to a sensor,
>>> and this connection is shown in the Media controller interface. This
>>> means that the flash sub-device (entity) should be part of the Media
>>> device created by the driver in control of it. This can be achieved by
>>> the master driver creating the sub-device. You should register an async
>>> sub-device here.
>>>
>>> This results in the sub-device not being registered if there's no such
>>> master driver, but I wouldn't expect that to be an issue since the V4L2
>>> flash API is mostly relevant in such cases.
>>
>> I addressed this issue in the cover letter of this patch series,
>> paragraph 1. If strobe signals are routed to a flash device through
>> a multiplexer then assignment of the related V4L2 Flash sub-device
>> to a particular media controller may dynamically change in time.
>> Actually, if a flash device can be shared between media systems
>> (i.e. it can be configured to react on strobe signals from different
>> camera sensors, basing on muxes configuration), than it becomes
>> bound to a particular media system only for the time of strobing.
>> Please refer to [1].
>
> Replied to the cover letter.

Replied to your reply.

> ...
>
>>>> diff --git a/include/media/v4l2-flash.h b/include/media/v4l2-flash.h
>>>> new file mode 100644
>>>> index 0000000..effa46b
>>>> --- /dev/null
>>>> +++ b/include/media/v4l2-flash.h
>>>> @@ -0,0 +1,137 @@
>>>> +/*
>>>> + * V4L2 Flash LED sub-device registration helpers.
>>>> + *
>>>> + *	Copyright (C) 2014 Samsung Electronics Co., Ltd
>>>> + *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License version 2 as
>>>> + * published by the Free Software Foundation."
>>>> + */
>>>> +
>>>> +#ifndef _V4L2_FLASH_H
>>>> +#define _V4L2_FLASH_H
>>>> +
>>>> +#include <media/v4l2-ctrls.h>
>>>> +#include <media/v4l2-device.h>
>>>> +#include <media/v4l2-dev.h>le
>>>> +#include <media/v4l2-event.h>
>>>> +#include <media/v4l2-ioctl.h>
>>>> +
>>>> +struct led_classdev_flash;
>>>> +struct led_classdev;
>>>> +enum led_brightness;
>>>> +
>>>> +struct v4l2_flash_ops {
>>>> +	int (*torch_brightness_set)(struct led_classdev *led_cdev,
>>>> +					enum led_brightness brightness);
>>>> +	int (*torch_brightness_update)(struct led_classdev *led_cdev);
>>>> +	int (*flash_brightness_set)(struct led_classdev_flash *flash,
>>>> +					u32 brightness);
>>>> +	int (*flash_brightness_update)(struct led_classdev_flash *flash);
>>>> +	int (*strobe_set)(struct led_classdev_flash *flash, bool state);
>>>> +	int (*strobe_get)(struct led_classdev_flash *flash, bool *state);
>>>> +	int (*timeout_set)(struct led_classdev_flash *flash, u32 timeout);
>>>> +	int (*indicator_brightness_set)(struct led_classdev_flash *flash,
>>>> +					u32 brightness);
>>>> +	int (*indicator_brightness_update)(struct led_classdev_flash *flash);
>>>> +	int (*external_strobe_set)(struct led_classdev_flash *flash,
>>>> +					bool enable);
>>>> +	int (*fault_get)(struct led_classdev_flash *flash, u32 *fault);
>>>> +	void (*sysfs_lock)(struct led_classdev *led_cdev);
>>>> +	void (*sysfs_unlock)(struct led_classdev *led_cdev);
>>>
>>> These functions are not driver specific and there's going to be just one
>>> implementation (I suppose). Could you refresh my memory regarding why
>>> the LED framework functions aren't called directly?
>>
>> These ops are required to make possible building led-class-flash as
>> a kernel module.
>
> Assuming you'd use the actual implementation directly, what would be the
> dependencies? I don't think the LED flash framework has any callbacks
> towards the V4L2 (LED) flash framework, does it? Please correct my
> understanding if I'm missing something. In Makefile format, assume all
> targets are .PHONY:
>
> led-flash-api: led-api
>
> v4l2-flash: led-flash-api
>
> driver: led-flash-api v4l2-flash

LED Class Flash driver gains V4L2 Flash API when
CONFIG_V4L2_FLASH_LED_CLASS is defined. This is accomplished in
the probe function by either calling v4l2_flash_init function
or the macro of this name, when the CONFIG_V4L2_FLASH_LED_CLASS
macro isn't defined.

If the v4l2-flash.c was to call the LED API directly, then the
led-class-flash module symbols would have to be available at
v4l2-flash.o linking time.

This requirement cannot be met if the led-class-flash is built
as a module.

Use of function pointers in the v4l2-flash.c allows to compile it
into the kernel and enables the possibility of adding the V4L2 Flash
support conditionally, during driver probing.

Best Regards,
Jacek Anaszewski
