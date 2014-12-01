Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbaLAOxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 09:53:11 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36109 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbaLAOxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:53:09 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-b8-547c80d39fbb
Message-id: <547C80D1.6030904@samsung.com>
Date: Mon, 01 Dec 2014 15:53:05 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC v8 06/14] media: Add registration helpers for V4L2
 flash sub-devices
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-7-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1417166286-27685-7-git-send-email-j.anaszewski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xq7qXG2pCDHqfS1psnLGe1eLozolM
	Fkt+7mKy6L36nNHibNMbdovLu+awWWx9s47RomfDVlaLu6eOslns3vWU1eLwm3ZWizP7V7I5
	8HhM+b2R1WPnrLvsHoe/LmTx2DP/B6tH35ZVjB4rVn9n9/i8SS6APYrLJiU1J7MstUjfLoEr
	Y8vtbuaCt4cZK/42n2ZtYLw3j7GLkYNDQsBE4u5tpS5GTiBTTOLCvfVsXYxcHEICSxkleiYc
	Y4JwPjJKPF7xhRmkildAS+LPmd+sIDaLgKpE37NuNhCbTcBQ4ueL10wgtqhAhMSf0/tYIeoF
	JX5MvscCskxEIFri0rF6kJnMAp8ZJeY0tzCC1AgLxEl8XrOLBWJZO6PEzL2HWUASnAKeEq+v
	/GUHsZkFrCVWTtrGCGHLS2xe85Z5AqPALCQ7ZiEpm4WkbAEj8ypG0dTS5ILipPRcI73ixNzi
	0rx0veT83E2MkIj5uoNx6TGrQ4wCHIxKPLyaa6tDhFgTy4orcw8xSnAwK4nwshbUhAjxpiRW
	VqUW5ccXleakFh9iZOLglGpgXHUnlSv3+O+fJ/bvVIqIW7qXeWXDeSXvu9qqix8xr/IN/Xrk
	Yu8rZ/fyE10nXnFPby+feO41w1O/4MXK85ze5Mh8ZxD4vlVpw4f6oj3Tbdd+jPx/4OZJh5rH
	XhNtt6kKOXmWrlOdN+3qmtUKdyWexfLf/u7QsXffvRbW+xfOXc9/4MlyYoOHd5kSS3FGoqEW
	c1FxIgDqZkNKdgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2014 10:17 AM, Jacek Anaszewski wrote:
> This patch adds helper functions for registering/unregistering
> LED Flash class devices as V4L2 sub-devices. The functions should
> be called from the LED subsystem device driver. In case the
> support for V4L2 Flash sub-devices is disabled in the kernel
> config the functions' empty versions will be used.
>
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>   drivers/media/v4l2-core/Kconfig      |   11 +
>   drivers/media/v4l2-core/Makefile     |    2 +
>   drivers/media/v4l2-core/v4l2-flash.c |  516 ++++++++++++++++++++++++++++++++++
>   include/media/v4l2-flash.h           |  138 +++++++++
>   4 files changed, 667 insertions(+)
>   create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
>   create mode 100644 include/media/v4l2-flash.h
>
> diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
> index ba7e21a..f034f1a 100644
> --- a/drivers/media/v4l2-core/Kconfig
> +++ b/drivers/media/v4l2-core/Kconfig
> @@ -44,6 +44,17 @@ config V4L2_MEM2MEM_DEV
>           tristate
>           depends on VIDEOBUF2_CORE
>
> +# Used by LED subsystem flash drivers
> +config V4L2_FLASH_LED_CLASS
> +	tristate "Enable support for Flash sub-devices"
> +	depends on VIDEO_V4L2_SUBDEV_API
> +	depends on LEDS_CLASS_FLASH
> +	---help---
> +	  Say Y here to enable support for Flash sub-devices, which allow
> +	  to control LED class devices with use of V4L2 Flash controls.
> +
> +	  When in doubt, say N.
> +
>   # Used by drivers that need Videobuf modules
>   config VIDEOBUF_GEN
>   	tristate
> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> index 63d29f2..44e858c 100644
> --- a/drivers/media/v4l2-core/Makefile
> +++ b/drivers/media/v4l2-core/Makefile
> @@ -22,6 +22,8 @@ obj-$(CONFIG_VIDEO_TUNER) += tuner.o
>
>   obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
>
> +obj-$(CONFIG_V4L2_FLASH_LED_CLASS) += v4l2-flash.o
> +
>   obj-$(CONFIG_VIDEOBUF_GEN) += videobuf-core.o
>   obj-$(CONFIG_VIDEOBUF_DMA_SG) += videobuf-dma-sg.o
>   obj-$(CONFIG_VIDEOBUF_DMA_CONTIG) += videobuf-dma-contig.o
> diff --git a/drivers/media/v4l2-core/v4l2-flash.c b/drivers/media/v4l2-core/v4l2-flash.c
> new file mode 100644
> index 0000000..f5075b0
> --- /dev/null
> +++ b/drivers/media/v4l2-core/v4l2-flash.c
> @@ -0,0 +1,516 @@
> +/*
> + * V4L2 Flash LED sub-device registration helpers.
> + *
> + *	Copyright (C) 2014 Samsung Electronics Co., Ltd
> + *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation."
> + */
> +
> +#include <linux/led-class-flash.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <media/v4l2-flash.h>
> +
> +#define has_flash_op(v4l2_flash, op)			\
> +	(v4l2_flash && v4l2_flash->ops->op)
> +
> +#define call_flash_op(v4l2_flash, op, args...)		\
> +		(has_flash_op(v4l2_flash, op) ?		\
> +			v4l2_flash->ops->op(args) :	\
> +			-EINVAL)
> +
> +static inline enum led_brightness v4l2_flash_intensity_to_led_brightness(
> +					struct v4l2_ctrl *ctrl,
> +					s32 intensity)
> +{
> +	s64 __intensity = intensity - ctrl->minimum;
> +
> +	do_div(__intensity, ctrl->step);
> +
> +	return __intensity + 1;
> +}
> +
> +static inline s32 v4l2_flash_led_brightness_to_intensity(
> +					struct v4l2_ctrl *ctrl,
> +					enum led_brightness brightness)
> +{
> +	return ((brightness - 1) * ctrl->step) + ctrl->minimum;
> +}
> +
> +static int v4l2_flash_g_volatile_ctrl(struct v4l2_ctrl *c)
> +{
> +	struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
> +	struct led_classdev_flash *flash = v4l2_flash->flash;
> +	struct led_classdev *led_cdev = &flash->led_cdev;
> +	struct v4l2_ctrl **ctrls = v4l2_flash->ctrls;
> +	bool is_strobing;
> +	int ret;
> +
> +	switch (c->id) {
> +	case V4L2_CID_FLASH_TORCH_INTENSITY:
> +		/*
> +		 * Update torch brightness only if in TORCH_MODE.
> +		 * In other modes torch led is turned off, which
> +		 * would spuriously inform the user space that
> +		 * V4L2_CID_FLASH_TORCH_INTENSITY control setting
> +		 * has changed.
> +		 */
> +		if (ctrls[LED_MODE]->val == V4L2_FLASH_LED_MODE_TORCH) {
> +			ret = led_update_brightness(led_cdev);
> +			if (ret < 0)
> +				return ret;
> +			c->val = v4l2_flash_led_brightness_to_intensity(
> +							ctrls[TORCH_INTENSITY],
> +							led_cdev->brightness);
> +		}
> +		return 0;
> +	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
> +		ret = led_update_brightness(led_cdev);
> +		if (ret < 0)
> +			return ret;
> +		c->val = v4l2_flash_led_brightness_to_intensity(
> +						ctrls[INDICATOR_INTENSITY],
> +						led_cdev->brightness);
> +		return 0;
> +	case V4L2_CID_FLASH_INTENSITY:
> +		ret = led_update_flash_brightness(flash);
> +		if (ret < 0)
> +			return ret;
> +		/* no conversion is needed */
> +		c->val = flash->brightness.val;
> +		return 0;
> +	case V4L2_CID_FLASH_STROBE_STATUS:
> +		ret = led_get_flash_strobe(flash, &is_strobing);
> +		if (ret < 0)
> +			return ret;
> +		c->val = is_strobing;
> +		return 0;
> +	case V4L2_CID_FLASH_FAULT:
> +		/* led faults map directly to V4L2 flash faults */
> +		return led_get_flash_fault(flash, &c->val);
> +	case V4L2_CID_FLASH_SYNC_STROBE:
> +		c->val = flash->sync_strobe;
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
> +{
> +	struct v4l2_flash *v4l2_flash = v4l2_ctrl_to_v4l2_flash(c);
> +	struct led_classdev_flash *flash = v4l2_flash->flash;
> +	struct led_classdev *led_cdev = &flash->led_cdev;
> +	struct v4l2_ctrl **ctrls = v4l2_flash->ctrls;
> +	enum led_brightness brightness;
> +	bool external_strobe;
> +	int ret = 0;
> +
> +	switch (c->id) {
> +	case V4L2_CID_FLASH_LED_MODE:
> +		switch (c->val) {
> +		case V4L2_FLASH_LED_MODE_NONE:
> +			led_set_brightness(led_cdev, LED_OFF);
> +			return led_set_flash_strobe(flash, false);
> +		case V4L2_FLASH_LED_MODE_FLASH:
> +			/* Turn the torch LED off */
> +			led_set_brightness(led_cdev, LED_OFF);
> +			external_strobe = (ctrls[STROBE_SOURCE]->val ==
> +					V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
> +
> +			if (has_flash_op(v4l2_flash, external_strobe_set))
> +				ret = call_flash_op(v4l2_flash,
> +						external_strobe_set, v4l2_flash,
> +						external_strobe);
> +			return ret;
> +		case V4L2_FLASH_LED_MODE_TORCH:
> +			/* Stop flash strobing */
> +			ret = led_set_flash_strobe(flash, false);
> +			if (ret < 0)
> +				return ret;
> +
> +			brightness =
> +				v4l2_flash_intensity_to_led_brightness(
> +						ctrls[TORCH_INTENSITY],
> +						ctrls[TORCH_INTENSITY]->val);
> +			led_set_brightness(led_cdev, brightness);
> +			return 0;
> +		}
> +		break;
> +	case V4L2_CID_FLASH_STROBE_SOURCE:
> +		external_strobe = (c->val == V4L2_FLASH_STROBE_SOURCE_EXTERNAL);
> +
> +		return call_flash_op(v4l2_flash, external_strobe_set,
> +					v4l2_flash, external_strobe);
> +	case V4L2_CID_FLASH_STROBE:
> +		if (ctrls[LED_MODE]->val != V4L2_FLASH_LED_MODE_FLASH ||
> +		    ctrls[STROBE_SOURCE]->val !=
> +					V4L2_FLASH_STROBE_SOURCE_SOFTWARE)
> +			return -EINVAL;
> +		return led_set_flash_strobe(flash, true);
> +	case V4L2_CID_FLASH_STROBE_STOP:
> +		if (ctrls[LED_MODE]->val != V4L2_FLASH_LED_MODE_FLASH ||
> +		    ctrls[STROBE_SOURCE]->val !=
> +					V4L2_FLASH_STROBE_SOURCE_SOFTWARE)
> +			return -EINVAL;
> +		return led_set_flash_strobe(flash, false);
> +	case V4L2_CID_FLASH_TIMEOUT:
> +		/* no conversion is needed */
> +		return led_set_flash_timeout(flash, c->val);
> +	case V4L2_CID_FLASH_INTENSITY:
> +		/* no conversion is needed */
> +		return led_set_flash_brightness(flash, c->val);
> +	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
> +		brightness = v4l2_flash_intensity_to_led_brightness(
> +						ctrls[INDICATOR_INTENSITY],
> +						c->val);
> +		led_set_brightness(led_cdev, brightness);
> +		return 0;
> +	case V4L2_CID_FLASH_TORCH_INTENSITY:
> +		/*
> +		 * If not in MODE_TORCH don't call led-class brightness_set
> +		 * op, as it would result in turning the torch led on.
> +		 * Instead the value is cached only and will be written
> +		 * to the device upon transition to MODE_TORCH.
> +		 */
> +		if (ctrls[LED_MODE]->val == V4L2_FLASH_LED_MODE_TORCH) {
> +			brightness =
> +				v4l2_flash_intensity_to_led_brightness(
> +							ctrls[TORCH_INTENSITY],
> +							c->val);
> +			led_set_brightness(led_cdev, brightness);
> +		}
> +		return 0;
> +	case V4L2_CID_FLASH_SYNC_STROBE:
> +		flash->sync_strobe = c->val;
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static const struct v4l2_ctrl_ops v4l2_flash_ctrl_ops = {
> +	.g_volatile_ctrl = v4l2_flash_g_volatile_ctrl,
> +	.s_ctrl = v4l2_flash_s_ctrl,
> +};
> +
> +static void fill_ctrl_init_data(struct v4l2_flash *v4l2_flash,
> +			  struct v4l2_flash_ctrl_config *flash_cfg,
> +			  struct v4l2_flash_ctrl_data *ctrl_init_data)
> +{
> +	struct led_classdev_flash *flash = v4l2_flash->flash;
> +	const struct led_flash_ops *flash_ops = flash->ops;
> +	struct led_classdev *led_cdev = &flash->led_cdev;
> +	struct v4l2_ctrl_config *ctrl_cfg;
> +	u32 mask;
> +	s64 max;
> +
> +	/* Init FLASH_LED_MODE ctrl data */
> +	mask = 1 << V4L2_FLASH_LED_MODE_NONE |
> +	       1 << V4L2_FLASH_LED_MODE_TORCH;
> +	if (led_cdev->flags & LED_DEV_CAP_FLASH)
> +		mask |= 1 << V4L2_FLASH_LED_MODE_FLASH;

I didn't take into account the case when there is no LED_DEV_CAP_FLASH
flag set but there is has_indicator flag set in the
v4l2_flash_ctrl_config. In fact this is the only valid arrangement
in the new approach where the indicator led will have its own
LED Flash class device and the related v4l2_subdev.

Actually has_indicator is the residue after previous version of the
patch set. It should be renamed to e.g. indicator_led. Similarly
indicator_intensity should be removed, torch_intensity renamed to
something more generic for both torch and indicator leds e.g. 
led_intensity or just intensity like in case of proposed
new leds/common.txt bindings where the property max-microamp doesn't
have any additional segment and there is flash-max-microamp property
for flash leds. Mode and torch intensity controls also shouldn't be
created for indicator leds.

Summarizing - indicator led should have maximum two controls:
V4L2_CID_FLASH_INDICATOR_INTENSITY and V4L2_CID_FLASH_FAULT

Best Regards,
Jacek Anaszewski

> +	ctrl_init_data[LED_MODE].supported = true;
> +	ctrl_cfg = &ctrl_init_data[LED_MODE].config;
> +	ctrl_cfg->id = V4L2_CID_FLASH_LED_MODE;
> +	ctrl_cfg->max = V4L2_FLASH_LED_MODE_TORCH;
> +	ctrl_cfg->menu_skip_mask = ~mask;
> +	ctrl_cfg->def = V4L2_FLASH_LED_MODE_NONE;
> +	ctrl_cfg->flags = 0;
> +
> +	/* Init TORCH_INTENSITY ctrl data */
> +	ctrl_init_data[TORCH_INTENSITY].supported = true;
> +	ctrl_init_data[TORCH_INTENSITY].config = flash_cfg->torch_intensity;
> +	ctrl_cfg = &ctrl_init_data[TORCH_INTENSITY].config;
> +	ctrl_cfg->id = V4L2_CID_FLASH_TORCH_INTENSITY;
> +	ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE;
> +
> +	if (!(led_cdev->flags & LED_DEV_CAP_FLASH))
> +		return;
> +
> +	/* Init FLASH_STROBE_SOURCE ctrl data */
> +	mask = 1 << V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
> +	if (flash_cfg->has_external_strobe) {
> +		mask |= 1 << V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
> +		max = V4L2_FLASH_STROBE_SOURCE_EXTERNAL;
> +	} else {
> +		max = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
> +	}
> +
> +	ctrl_init_data[STROBE_SOURCE].supported = true;
> +	ctrl_cfg = &ctrl_init_data[STROBE_SOURCE].config;
> +	ctrl_cfg->id = V4L2_CID_FLASH_STROBE_SOURCE;
> +	ctrl_cfg->max = max;
> +	ctrl_cfg->menu_skip_mask = ~mask;
> +	ctrl_cfg->def = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
> +
> +	/* Init FLASH_STROBE ctrl data */
> +	ctrl_init_data[FLASH_STROBE].supported = true;
> +	ctrl_cfg = &ctrl_init_data[FLASH_STROBE].config;
> +	ctrl_cfg->id = V4L2_CID_FLASH_STROBE;
> +
> +	/* Init STROBE_STOP ctrl data */
> +	ctrl_init_data[STROBE_STOP].supported = true;
> +	ctrl_cfg = &ctrl_init_data[STROBE_STOP].config;
> +	ctrl_cfg->id = V4L2_CID_FLASH_STROBE_STOP;
> +
> +	/* Init STROBE_STATUS ctrl data */
> +	if (flash_ops->strobe_get) {
> +		ctrl_init_data[STROBE_STATUS].supported = true;
> +		ctrl_cfg = &ctrl_init_data[STROBE_STATUS].config;
> +		ctrl_cfg->id = V4L2_CID_FLASH_STROBE_STATUS;
> +		ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE |
> +				  V4L2_CTRL_FLAG_READ_ONLY;
> +	}
> +
> +	/* Init FLASH_TIMEOUT ctrl data */
> +	if (flash_ops->timeout_set) {
> +		ctrl_init_data[FLASH_TIMEOUT].supported = true;
> +		ctrl_init_data[FLASH_TIMEOUT].config = flash_cfg->flash_timeout;
> +		ctrl_cfg = &ctrl_init_data[FLASH_TIMEOUT].config;
> +		ctrl_cfg->id = V4L2_CID_FLASH_TIMEOUT;
> +		ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE;
> +	}
> +
> +	/* Init FLASH_INTENSITY ctrl data */
> +	if (flash_ops->flash_brightness_set) {
> +		ctrl_init_data[FLASH_INTENSITY].supported = true;
> +		ctrl_init_data[FLASH_INTENSITY].config =
> +					flash_cfg->flash_intensity;
> +		ctrl_cfg = &ctrl_init_data[FLASH_INTENSITY].config;
> +		ctrl_cfg->id = V4L2_CID_FLASH_INTENSITY;
> +		ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE;
> +	}
> +
> +	/* Init INDICATOR_INTENSITY ctrl data */
> +	if (flash_cfg->has_indicator) {
> +		ctrl_init_data[INDICATOR_INTENSITY].supported = true;
> +		ctrl_init_data[INDICATOR_INTENSITY].config =
> +					flash_cfg->indicator_intensity;
> +		ctrl_cfg = &ctrl_init_data[INDICATOR_INTENSITY].config;
> +		ctrl_cfg->id = V4L2_CID_FLASH_INDICATOR_INTENSITY;
> +		ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE;
> +	}
> +
> +	/* Init FLASH_FAULT ctrl data */
> +	if (flash_cfg->flash_faults) {
> +		ctrl_init_data[FLASH_FAULT].supported = true;
> +		ctrl_cfg = &ctrl_init_data[FLASH_FAULT].config;
> +		ctrl_cfg->id = V4L2_CID_FLASH_FAULT;
> +		ctrl_cfg->max = flash_cfg->flash_faults;
> +		ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE |
> +				  V4L2_CTRL_FLAG_READ_ONLY;
> +	}
> +
> +	if (led_cdev->flags & LED_DEV_CAP_COMPOUND) {
> +		ctrl_init_data[SYNC_STROBE].supported = true;
> +		ctrl_cfg = &ctrl_init_data[SYNC_STROBE].config;
> +		ctrl_cfg->id = V4L2_CID_FLASH_SYNC_STROBE;
> +		ctrl_cfg->flags = V4L2_CTRL_FLAG_VOLATILE;
> +	}
> +}
> +
> +static int v4l2_flash_init_controls(struct v4l2_flash *v4l2_flash,
> +				struct v4l2_flash_ctrl_config *flash_cfg)
> +
> +{
> +	struct v4l2_flash_ctrl_data *ctrl_init_data;
> +	struct v4l2_ctrl *ctrl;
> +	struct v4l2_ctrl_config *ctrl_cfg;
> +	int i, ret, num_ctrls = 0;
> +
> +	/* allocate memory dynamically so as not to exceed stack frame size */
> +	ctrl_init_data = kcalloc(NUM_FLASH_CTRLS, sizeof(*ctrl_init_data),
> +					GFP_KERNEL);
> +	if (!ctrl_init_data)
> +		return -ENOMEM;
> +
> +	memset(ctrl_init_data, 0, sizeof(*ctrl_init_data));
> +
> +	fill_ctrl_init_data(v4l2_flash, flash_cfg, ctrl_init_data);
> +
> +	for (i = 0; i < NUM_FLASH_CTRLS; ++i)
> +		if (ctrl_init_data[i].supported)
> +			++num_ctrls;
> +
> +	v4l2_ctrl_handler_init(&v4l2_flash->hdl, num_ctrls);
> +
> +	for (i = 0; i < NUM_FLASH_CTRLS; ++i) {
> +		ctrl_cfg = &ctrl_init_data[i].config;
> +		if (!ctrl_init_data[i].supported)
> +			continue;
> +
> +		if (ctrl_cfg->id == V4L2_CID_FLASH_LED_MODE ||
> +		    ctrl_cfg->id == V4L2_CID_FLASH_STROBE_SOURCE)
> +			ctrl = v4l2_ctrl_new_std_menu(&v4l2_flash->hdl,
> +						&v4l2_flash_ctrl_ops,
> +						ctrl_cfg->id,
> +						ctrl_cfg->max,
> +						ctrl_cfg->menu_skip_mask,
> +						ctrl_cfg->def);
> +		else
> +			ctrl = v4l2_ctrl_new_std(&v4l2_flash->hdl,
> +						&v4l2_flash_ctrl_ops,
> +						ctrl_cfg->id,
> +						ctrl_cfg->min,
> +						ctrl_cfg->max,
> +						ctrl_cfg->step,
> +						ctrl_cfg->def);
> +
> +		if (ctrl)
> +			ctrl->flags |= ctrl_cfg->flags;
> +
> +		if (i <= STROBE_SOURCE)
> +			v4l2_flash->ctrls[i] = ctrl;
> +	}
> +
> +	kfree(ctrl_init_data);
> +
> +	if (v4l2_flash->hdl.error) {
> +		ret = v4l2_flash->hdl.error;
> +		goto error_free_handler;
> +	}
> +
> +	v4l2_ctrl_handler_setup(&v4l2_flash->hdl);
> +
> +	v4l2_flash->sd.ctrl_handler = &v4l2_flash->hdl;
> +
> +	return 0;
> +
> +error_free_handler:
> +	v4l2_ctrl_handler_free(&v4l2_flash->hdl);
> +	return ret;
> +}
> +
> +/*
> + * V4L2 subdev internal operations
> + */
> +
> +static int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
> +	struct led_classdev_flash *flash = v4l2_flash->flash;
> +	struct led_classdev *led_cdev = &flash->led_cdev;
> +	int ret = 0;
> +
> +	mutex_lock(&led_cdev->led_access);
> +
> +	if (!v4l2_fh_is_singular(&fh->vfh)) {
> +		ret = -EBUSY;
> +		goto unlock;
> +	}
> +
> +	led_sysfs_disable(led_cdev);
> +
> +unlock:
> +	mutex_unlock(&led_cdev->led_access);
> +	return ret;
> +}
> +
> +static int v4l2_flash_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
> +	struct led_classdev_flash *flash = v4l2_flash->flash;
> +	struct led_classdev *led_cdev = &flash->led_cdev;
> +	int ret = 0;
> +
> +	mutex_lock(&led_cdev->led_access);
> +
> +	if (has_flash_op(v4l2_flash, external_strobe_set))
> +		ret = call_flash_op(v4l2_flash, external_strobe_set,
> +				v4l2_flash, false);
> +	led_sysfs_enable(led_cdev);
> +
> +	mutex_unlock(&led_cdev->led_access);
> +
> +	return ret;
> +}
> +
> +static const struct v4l2_subdev_internal_ops v4l2_flash_subdev_internal_ops = {
> +	.open = v4l2_flash_open,
> +	.close = v4l2_flash_close,
> +};
> +
> +static const struct v4l2_subdev_core_ops v4l2_flash_core_ops = {
> +	.queryctrl = v4l2_subdev_queryctrl,
> +	.querymenu = v4l2_subdev_querymenu,
> +};
> +
> +static const struct v4l2_subdev_ops v4l2_flash_subdev_ops = {
> +	.core = &v4l2_flash_core_ops,
> +};
> +
> +struct v4l2_flash *v4l2_flash_init(struct led_classdev_flash *flash,
> +				   const struct v4l2_flash_ops *ops,
> +				   struct v4l2_flash_ctrl_config *config)
> +{
> +	struct v4l2_flash *v4l2_flash;
> +	struct led_classdev *led_cdev = &flash->led_cdev;
> +	struct v4l2_subdev *sd;
> +	int ret;
> +
> +	if (!flash || !ops || !config)
> +		return ERR_PTR(-EINVAL);
> +
> +	v4l2_flash = kzalloc(sizeof(*v4l2_flash), GFP_KERNEL);
> +	if (!v4l2_flash)
> +		return ERR_PTR(-ENOMEM);
> +
> +	sd = &v4l2_flash->sd;
> +	v4l2_flash->flash = flash;
> +	v4l2_flash->ops = ops;
> +	sd->dev = led_cdev->dev->parent;
> +	v4l2_subdev_init(sd, &v4l2_flash_subdev_ops);
> +	sd->internal_ops = &v4l2_flash_subdev_internal_ops;
> +	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	snprintf(sd->name, sizeof(sd->name), led_cdev->name);
> +
> +	ret = v4l2_flash_init_controls(v4l2_flash, config);
> +	if (ret < 0)
> +		goto err_init_controls;
> +
> +	ret = media_entity_init(&sd->entity, 0, NULL, 0);
> +	if (ret < 0)
> +		goto err_init_entity;
> +
> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;
> +
> +	ret = v4l2_async_register_subdev(sd);
> +	if (ret < 0)
> +		goto err_init_entity;
> +
> +	return v4l2_flash;
> +
> +err_init_entity:
> +	media_entity_cleanup(&sd->entity);
> +err_init_controls:
> +	v4l2_ctrl_handler_free(sd->ctrl_handler);
> +	kfree(v4l2_flash);
> +
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_flash_init);
> +
> +void v4l2_flash_release(struct v4l2_flash *v4l2_flash)
> +{
> +	struct v4l2_subdev *sd = &v4l2_flash->sd;
> +
> +	if (!v4l2_flash)
> +		return;
> +
> +	v4l2_async_unregister_subdev(sd);
> +	media_entity_cleanup(&sd->entity);
> +	v4l2_ctrl_handler_free(sd->ctrl_handler);
> +	kfree(v4l2_flash);
> +}
> +EXPORT_SYMBOL_GPL(v4l2_flash_release);
> +
> +MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("V4L2 Flash sub-device helpers");
> diff --git a/include/media/v4l2-flash.h b/include/media/v4l2-flash.h
> new file mode 100644
> index 0000000..1e18df5
> --- /dev/null
> +++ b/include/media/v4l2-flash.h
> @@ -0,0 +1,138 @@
> +/*
> + * V4L2 Flash LED sub-device registration helpers.
> + *
> + *	Copyright (C) 2014 Samsung Electronics Co., Ltd
> + *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation."
> + */
> +
> +#ifndef _V4L2_FLASH_H
> +#define _V4L2_FLASH_H
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-event.h>
> +#include <media/v4l2-ioctl.h>
> +
> +struct led_classdev_flash;
> +struct led_classdev;
> +struct v4l2_flash;
> +enum led_brightness;
> +
> +enum ctrl_init_data_id {
> +	LED_MODE,
> +	TORCH_INTENSITY,
> +	STROBE_SOURCE,
> +	FLASH_STROBE,
> +	STROBE_STOP,
> +	STROBE_STATUS,
> +	FLASH_TIMEOUT,
> +	FLASH_INTENSITY,
> +	INDICATOR_INTENSITY,
> +	FLASH_FAULT,
> +	SYNC_STROBE,
> +	NUM_FLASH_CTRLS,
> +};
> +
> +/*
> + * struct v4l2_flash_ctrl_data - flash control initialization data -
> + *				 filled basing on the features declared
> + *				 by the LED Flash class driver
> + * @config:	initialization data for a control
> + * @supported:	indicates whether a control is supported
> + *		by the LED Flash class driver
> + */
> +struct v4l2_flash_ctrl_data {
> +	struct v4l2_ctrl_config config;
> +	bool supported;
> +};
> +
> +struct v4l2_flash_ops {
> +	/* setup strobing the flash by hardware pin state assertion */
> +	int (*external_strobe_set)(struct v4l2_flash *v4l2_flash,
> +					bool enable);
> +};
> +
> +/**
> + * struct v4l2_flash_ctrl_config - V4L2 Flash controls initialization data
> + * @torch_intensity:		V4L2_CID_FLASH_TORCH_INTENSITY constraints
> + * @flash_intensity:		V4L2_CID_FLASH_INTENSITY constraints
> + * @indicator_intensity:	V4L2_CID_FLASH_INDICATOR_INTENSITY constraints
> + * @flash_timeout:		V4L2_CID_FLASH_TIMEOUT constraints
> + * @flash_fault:		possible flash faults
> + * @has_external_strobe:	external strobe capability
> + */
> +struct v4l2_flash_ctrl_config {
> +	struct v4l2_ctrl_config torch_intensity;
> +	struct v4l2_ctrl_config flash_intensity;
> +	struct v4l2_ctrl_config indicator_intensity;
> +	struct v4l2_ctrl_config flash_timeout;
> +	u32 flash_faults;
> +	bool has_external_strobe:1;
> +	bool has_indicator:1;
> +};
> +
> +/**
> + * struct v4l2_flash - Flash sub-device context
> + * @flash:		LED Flash Class device controlled by this sub-device
> + * @ops:		V4L2 specific flash ops
> + * @sd:			V4L2 sub-device
> + * @hdl:		flash controls handler
> + * @ctrls:		array of pointers to controls, whose values define
> +			the sub-device state
> + */
> +struct v4l2_flash {
> +	struct led_classdev_flash *flash;
> +	const struct v4l2_flash_ops *ops;
> +
> +	struct v4l2_subdev sd;
> +	struct v4l2_ctrl_handler hdl;
> +	struct v4l2_ctrl *ctrls[STROBE_SOURCE + 1];
> +};
> +
> +static inline struct v4l2_flash *v4l2_subdev_to_v4l2_flash(
> +							struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct v4l2_flash, sd);
> +}
> +
> +static inline struct v4l2_flash *v4l2_ctrl_to_v4l2_flash(struct v4l2_ctrl *c)
> +{
> +	return container_of(c->handler, struct v4l2_flash, hdl);
> +}
> +
> +#if IS_ENABLED(CONFIG_V4L2_FLASH_LED_CLASS)
> +/**
> + * v4l2_flash_init - initialize V4L2 flash led sub-device
> + * @led_fdev:	the LED Flash Class device to wrap
> + * @config:	initialization data for V4L2 Flash controls
> + * @flash_ops:	V4L2 Flash device ops
> + *
> + * Create V4L2 subdev wrapping given LED subsystem device.
> +
> + * Returns: A valid pointer, or, when an error occurs, the return
> + * value is encoded using ERR_PTR(). Use IS_ERR() to check and
> + * PTR_ERR() to obtain the numeric return value.
> + */
> +struct v4l2_flash *v4l2_flash_init(struct led_classdev_flash *led_fdev,
> +				   const struct v4l2_flash_ops *ops,
> +				   struct v4l2_flash_ctrl_config *config);
> +
> +/**
> + * v4l2_flash_release - release V4L2 Flash sub-device
> + * @flash: the V4L2 Flash device to release
> + *
> + * Release V4L2 flash led subdev.
> + */
> +void v4l2_flash_release(struct v4l2_flash *v4l2_flash);
> +
> +#else
> +#define v4l2_flash_init(led_cdev, ops, config) (NULL)
> +#define v4l2_flash_release(v4l2_flash)
> +#endif /* CONFIG_V4L2_FLASH_LED_CLASS */
> +
> +#endif /* _V4L2_FLASH_H */
>

