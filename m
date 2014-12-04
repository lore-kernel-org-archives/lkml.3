Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaLDJ3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:29:34 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21396 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaLDJ3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:29:31 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-9d-54802977095b
Message-id: <54802966.8060405@samsung.com>
Date: Thu, 04 Dec 2014 10:29:10 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, s.nawrocki@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Subject: Re: [PATCH/RFC v9 01/19] leds: Add LED Flash class extension to the
 LED subsystem
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-2-git-send-email-j.anaszewski@samsung.com>
 <20141203165013.GM14746@valkosipuli.retiisi.org.uk>
In-reply-to: <20141203165013.GM14746@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e/4Fd1yzYYQg7evZS02zljPanF050Qm
	i/43C1ktzr1ayWhxtukNu8XlXXPYLLa+Wcdo0bNhK6vF0usXmSzunjrKZjFh+loWi9a9R9gt
	du96ympx+E07q8WZ/SvZHPg91sxbw+hxua+XyWPnrLvsHiuXf2HzOPx1IYvHplWdbB575v9g
	9ejbsorRY8Xq7+wenzfJBXBFcdmkpOZklqUW6dslcGV0Ns9iLZh8nLFic0M7awPjloWMXYyc
	HBICJhKzL/2FssUkLtxbz9bFyMUhJLCUUaLj/Ep2kISQwEdGicuv60FsXgEtif2rDwPFOThY
	BFQlni/OBgmzCRhK/HzxmgnEFhWIkPhzeh8rRLmgxI/J91hAbBEBNYmnmx6ygMxnFrjGJLFh
	/UkmkDnCAjESGza4Qezdyyjx/mIL2F5OAQeJJSeuMoPYzALWEisnbWOEsOUlNq95yzyBUWAW
	kh2zkJTNQlK2gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIrH3Zwbj4mNUhRgEORiUe
	3gVP60OEWBPLiitzDzFKcDArifAy/gUK8aYkVlalFuXHF5XmpBYfYmTi4JRqYJzxolbqVzPb
	9twIjpjEqGtaf8S7bWxWrbOIXJ+w5IDQxbvLJBzXSsfNZOb4Nd+hpaz8HmM8/wc/mdylO63M
	1GzddG5n9+VnHF2/4WBo8t2aaVyak1hP9SUxL3lze7O/ccHEuVaGqswXvZ7cmWeyl+e5R+Dj
	XxZ+fVe+T/q7OLux0ipGbMZ7MSWW4oxEQy3mouJEAKoB33+TAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

Thanks for the review.

On 12/03/2014 05:50 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> Thanks for the update. A few comments below.
>
> On Wed, Dec 03, 2014 at 05:06:36PM +0100, Jacek Anaszewski wrote:
>> Some LED devices support two operation modes - torch and flash.
>> This patch provides support for flash LED devices in the LED subsystem
>> by introducing new sysfs attributes and kernel internal interface.
>> The attributes being introduced are: flash_brightness, flash_strobe,
>> flash_timeout, max_flash_timeout, max_flash_brightness, flash_fault
>> and flash_sync_strobe. All the flash related features are placed
>> in a separate module. Torch mode is supported by the LED class
>> interface.
>>
>> The modifications aim to be compatible with V4L2 framework requirements
>> related to the flash devices management. The design assumes that V4L2
>> sub-device can take of the LED class device control and communicate
>> with it through the kernel internal interface. When V4L2 Flash sub-device
>> file is opened, the LED class device sysfs interface is made
>> unavailable.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> ---
>>   drivers/leds/Kconfig            |   10 +
>>   drivers/leds/Makefile           |    1 +
>>   drivers/leds/led-class-flash.c  |  446 +++++++++++++++++++++++++++++++++++++++
>>   drivers/leds/led-class.c        |    4 +
>>   include/linux/led-class-flash.h |  186 ++++++++++++++++
>>   include/linux/leds.h            |    3 +
>>   6 files changed, 650 insertions(+)
>>   create mode 100644 drivers/leds/led-class-flash.c
>>   create mode 100644 include/linux/led-class-flash.h
>>
>> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
>> index b3c0d8a..fa8021e 100644
>> --- a/drivers/leds/Kconfig
>> +++ b/drivers/leds/Kconfig
>> @@ -19,6 +19,16 @@ config LEDS_CLASS
>>   	  This option enables the led sysfs class in /sys/class/leds.  You'll
>>   	  need this to do anything useful with LEDs.  If unsure, say N.
>>
>> +config LEDS_CLASS_FLASH
>> +	tristate "LED Flash Class Support"
>> +	depends on LEDS_CLASS
>> +	help
>> +	  This option enables the flash led sysfs class in /sys/class/leds.
>> +	  It wrapps LED Class and adds flash LEDs specific sysfs attributes
>> +	  and kernel internal API to it. You'll need this to provide support
>> +	  for the flash related features of a LED device. It can be built
>> +	  as a module.
>> +
>>   comment "LED drivers"
>>
>>   config LEDS_88PM860X
>> diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
>> index 1c65a19..cbba921 100644
>> --- a/drivers/leds/Makefile
>> +++ b/drivers/leds/Makefile
>> @@ -2,6 +2,7 @@
>>   # LED Core
>>   obj-$(CONFIG_NEW_LEDS)			+= led-core.o
>>   obj-$(CONFIG_LEDS_CLASS)		+= led-class.o
>> +obj-$(CONFIG_LEDS_CLASS_FLASH)		+= led-class-flash.o
>>   obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
>>
>>   # LED Platform Drivers
>> diff --git a/drivers/leds/led-class-flash.c b/drivers/leds/led-class-flash.c
>> new file mode 100644
>> index 0000000..219b414
>> --- /dev/null
>> +++ b/drivers/leds/led-class-flash.c
>> @@ -0,0 +1,446 @@
>> +/*
>> + * LED Flash class interface
>> + *
>> + * Copyright (C) 2014 Samsung Electronics Co., Ltd.
>> + * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/device.h>
>> +#include <linux/init.h>
>> +#include <linux/led-class-flash.h>
>> +#include <linux/leds.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +#include "leds.h"
>> +
>> +#define has_flash_op(flash, op)				\
>> +	(flash && flash->ops->op)
>> +
>> +#define call_flash_op(flash, op, args...)		\
>> +	((has_flash_op(flash, op)) ?			\
>> +			(flash->ops->op(flash, args)) :	\
>> +			-EINVAL)
>> +
>> +static ssize_t flash_brightness_store(struct device *dev,
>> +		struct device_attribute *attr, const char *buf, size_t size)
>> +{
>> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>> +	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
>> +	unsigned long state;
>> +	ssize_t ret;
>> +
>> +	mutex_lock(&led_cdev->led_access);
>> +
>> +	if (led_sysfs_is_disabled(led_cdev)) {
>> +		ret = -EBUSY;
>> +		goto unlock;
>> +	}
>> +
>> +	ret = kstrtoul(buf, 10, &state);
>> +	if (ret)
>> +		goto unlock;
>> +
>> +	ret = led_set_flash_brightness(flash, state);
>> +	if (ret < 0)
>> +		goto unlock;
>> +
>> +	ret = size;
>> +unlock:
>> +	mutex_unlock(&led_cdev->led_access);
>> +	return ret;
>> +}
>> +
>> +static ssize_t flash_brightness_show(struct device *dev,
>> +		struct device_attribute *attr, char *buf)
>> +{
>> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>> +	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
>> +
>> +	/* no lock needed for this */
>> +	led_update_flash_brightness(flash);
>> +
>> +	return sprintf(buf, "%u\n", flash->brightness.val);
>> +}
>> +static DEVICE_ATTR_RW(flash_brightness);
>> +
>> +static ssize_t max_flash_brightness_show(struct device *dev,
>> +		struct device_attribute *attr, char *buf)
>> +{
>> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>> +	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
>> +
>> +	return sprintf(buf, "%u\n", flash->brightness.max);
>> +}
>> +static DEVICE_ATTR_RO(max_flash_brightness);
>> +
>> +static ssize_t flash_strobe_store(struct device *dev,
>> +		struct device_attribute *attr, const char *buf, size_t size)
>> +{
>> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>> +	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
>> +	unsigned long state;
>> +	ssize_t ret = -EINVAL;
>> +
>> +	mutex_lock(&led_cdev->led_access);
>> +
>> +	if (led_sysfs_is_disabled(led_cdev)) {
>> +		ret = -EBUSY;
>> +		goto unlock;
>> +	}
>> +
>> +	ret = kstrtoul(buf, 10, &state);
>> +	if (ret)
>> +		goto unlock;
>> +
>> +	if (state < 0 || state > 1) {
>> +		ret = -EINVAL;
>> +		goto unlock;
>> +	}
>> +
>> +	ret = led_set_flash_strobe(flash, state);
>> +	if (ret < 0)
>> +		goto unlock;
>> +	ret = size;
>> +unlock:
>> +	mutex_unlock(&led_cdev->led_access);
>> +	return ret;
>> +}
>> +
>> +static ssize_t flash_strobe_show(struct device *dev,
>> +		struct device_attribute *attr, char *buf)
>> +{
>> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>> +	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
>> +	bool state;
>> +	int ret;
>> +
>> +	/* no lock needed for this */
>> +	ret = led_get_flash_strobe(flash, &state);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	return sprintf(buf, "%u\n", state);
>> +}
>> +static DEVICE_ATTR_RW(flash_strobe);
>> +
>> +static ssize_t flash_timeout_store(struct device *dev,
>> +		struct device_attribute *attr, const char *buf, size_t size)
>> +{
>> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>> +	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
>> +	unsigned long flash_timeout;
>> +	ssize_t ret;
>> +
>> +	mutex_lock(&led_cdev->led_access);
>> +
>> +	if (led_sysfs_is_disabled(led_cdev)) {
>> +		ret = -EBUSY;
>> +		goto unlock;
>> +	}
>> +
>> +	ret = kstrtoul(buf, 10, &flash_timeout);
>> +	if (ret)
>> +		goto unlock;
>> +
>> +	ret = led_set_flash_timeout(flash, flash_timeout);
>> +	if (ret < 0)
>> +		goto unlock;
>> +
>> +	ret = size;
>> +unlock:
>> +	mutex_unlock(&led_cdev->led_access);
>> +	return ret;
>> +}
>> +
>> +static ssize_t flash_timeout_show(struct device *dev,
>> +		struct device_attribute *attr, char *buf)
>> +{
>> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>> +	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
>> +
>> +	return sprintf(buf, "%u\n", flash->timeout.val);
>> +}
>> +static DEVICE_ATTR_RW(flash_timeout);
>> +
>> +static ssize_t max_flash_timeout_show(struct device *dev,
>> +		struct device_attribute *attr, char *buf)
>> +{
>> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>> +	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
>> +
>> +	return sprintf(buf, "%u\n", flash->timeout.max);
>> +}
>> +static DEVICE_ATTR_RO(max_flash_timeout);
>> +
>> +static ssize_t flash_fault_show(struct device *dev,
>> +		struct device_attribute *attr, char *buf)
>> +{
>> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>> +	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
>> +	u32 fault;
>> +	int ret;
>> +
>> +	ret = led_get_flash_fault(flash, &fault);
>> +	if (ret < 0)
>> +		return -EINVAL;
>> +
>> +	return sprintf(buf, "0x%8.8x\n", fault);
>> +}
>> +static DEVICE_ATTR_RO(flash_fault);
>> +
>> +static ssize_t flash_sync_strobe_store(struct device *dev,
>> +		struct device_attribute *attr, const char *buf, size_t size)
>> +{
>> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>> +	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
>> +	unsigned long sync_strobe;
>> +	ssize_t ret;
>> +
>> +	mutex_lock(&led_cdev->led_access);
>> +
>> +	if (led_sysfs_is_disabled(led_cdev)) {
>> +		ret = -EBUSY;
>> +		goto unlock;
>> +	}
>> +
>> +	ret = kstrtoul(buf, 10, &sync_strobe);
>> +	if (ret)
>> +		goto unlock;
>> +
>> +	flash->sync_strobe = sync_strobe;
>> +
>> +	ret = size;
>> +unlock:
>> +	mutex_unlock(&led_cdev->led_access);
>> +	return ret;
>> +}
>> +
>> +static ssize_t flash_sync_strobe_show(struct device *dev,
>> +		struct device_attribute *attr, char *buf)
>> +{
>> +	struct led_classdev *led_cdev = dev_get_drvdata(dev);
>> +	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
>> +
>> +	return sprintf(buf, "%u\n", flash->sync_strobe);
>> +}
>> +static DEVICE_ATTR_RW(flash_sync_strobe);
>> +
>> +static struct attribute *led_flash_strobe_attrs[] = {
>> +	&dev_attr_flash_strobe.attr,
>> +	NULL,
>> +};
>> +
>> +static struct attribute *led_flash_timeout_attrs[] = {
>> +	&dev_attr_flash_timeout.attr,
>> +	&dev_attr_max_flash_timeout.attr,
>> +	NULL,
>> +};
>> +
>> +static struct attribute *led_flash_brightness_attrs[] = {
>> +	&dev_attr_flash_brightness.attr,
>> +	&dev_attr_max_flash_brightness.attr,
>> +	NULL,
>> +};
>> +
>> +static struct attribute *led_flash_fault_attrs[] = {
>> +	&dev_attr_flash_fault.attr,
>> +	NULL,
>> +};
>> +
>> +static struct attribute *led_flash_sync_strobe_attrs[] = {
>> +	&dev_attr_flash_sync_strobe.attr,
>> +	NULL,
>> +};
>> +
>> +static const struct attribute_group led_flash_strobe_group = {
>> +	.attrs = led_flash_strobe_attrs,
>> +};
>> +
>> +static const struct attribute_group led_flash_timeout_group = {
>> +	.attrs = led_flash_timeout_attrs,
>> +};
>> +
>> +static const struct attribute_group led_flash_brightness_group = {
>> +	.attrs = led_flash_brightness_attrs,
>> +};
>> +
>> +static const struct attribute_group led_flash_fault_group = {
>> +	.attrs = led_flash_fault_attrs,
>> +};
>> +
>> +static const struct attribute_group led_flash_sync_strobe_group = {
>> +	.attrs = led_flash_sync_strobe_attrs,
>> +};
>> +
>> +static const struct attribute_group *flash_groups[] = {
>> +	&led_flash_strobe_group,
>> +	NULL,
>> +	NULL,
>> +	NULL,
>> +	NULL,
>> +	NULL,
>> +	NULL
>> +};
>> +
>> +static void led_flash_resume(struct led_classdev *led_cdev)
>> +{
>> +	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
>> +
>> +	call_flash_op(flash, flash_brightness_set, flash->brightness.val);
>> +	call_flash_op(flash, timeout_set, flash->timeout.val);
>> +}
>> +
>> +static void led_flash_init_sysfs_groups(struct led_classdev_flash *flash)
>> +{
>> +	struct led_classdev *led_cdev = &flash->led_cdev;
>> +	const struct led_flash_ops *ops = flash->ops;
>> +	int num_sysfs_groups = 1;
>> +
>> +	if (ops->flash_brightness_set)
>> +		flash_groups[num_sysfs_groups++] = &led_flash_brightness_group;
>> +
>> +	if (ops->timeout_set)
>> +		flash_groups[num_sysfs_groups++] = &led_flash_timeout_group;
>> +
>> +	if (ops->fault_get)
>> +		flash_groups[num_sysfs_groups++] = &led_flash_fault_group;
>> +
>> +	if (led_cdev->flags & LED_DEV_CAP_COMPOUND)
>> +		flash_groups[num_sysfs_groups++] = &led_flash_sync_strobe_group;
>> +
>> +	led_cdev->groups = flash_groups;
>
> Shouldn't you have groups local to the device instead? If you register
> another flash device bad things will happen if the ops the device supports
> are different.

The groups are local to the device. A LED class device is registered
with device_create_with_groups called from led_classdev_register
function. It is passed led_cdev->groups in the fifth argument.

>> +}
>> +
>> +int led_classdev_flash_register(struct device *parent,
>> +				struct led_classdev_flash *flash)
>> +{
>> +	struct led_classdev *led_cdev;
>> +	const struct led_flash_ops *ops;
>> +	int ret;
>> +
>> +	if (!flash)
>
> Do you have a use case for this?

This is just a guard against NULL pointer dereference. Maybe it is
indeed redundant, as the driver developer can easily check its
origin during implementation.

>> +		return -EINVAL;
>> +
>> +	led_cdev = &flash->led_cdev;
>> +
>> +	if (led_cdev->flags & LED_DEV_CAP_FLASH) {
>> +		if (!led_cdev->brightness_set_sync)
>> +			return -EINVAL;
>> +
>> +		ops = flash->ops;
>> +		if (!ops || !ops->strobe_set)
>> +			return -EINVAL;
>> +
>> +		led_cdev->flash_resume = led_flash_resume;
>> +
>> +		/* Select the sysfs attributes to be created for the device */
>> +		led_flash_init_sysfs_groups(flash);
>> +	}
>> +
>> +	/* Register led class device */
>> +	ret = led_classdev_register(parent, led_cdev);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* Setting a torch brightness needs to have immediate effect */
>> +	led_cdev->flags &= ~SET_BRIGHTNESS_ASYNC;
>> +	led_cdev->flags |= SET_BRIGHTNESS_SYNC;
>
> I'm ok with making this a property of the device (rather than interface as I
> originally thought it).

Ack.

>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(led_classdev_flash_register);
>> +
>> +void led_classdev_flash_unregister(struct led_classdev_flash *flash)
>> +{
>> +	if (!flash)
>> +		return;
>> +
>> +	led_classdev_unregister(&flash->led_cdev);
>> +}
>> +EXPORT_SYMBOL_GPL(led_classdev_flash_unregister);
>> +
>> +int led_set_flash_strobe(struct led_classdev_flash *flash, bool state)
>> +{
>> +	return call_flash_op(flash, strobe_set, state);
>> +}
>> +EXPORT_SYMBOL_GPL(led_set_flash_strobe);
>> +
>> +int led_get_flash_strobe(struct led_classdev_flash *flash, bool *state)
>> +{
>> +	return call_flash_op(flash, strobe_get, state);
>> +}
>> +EXPORT_SYMBOL_GPL(led_get_flash_strobe);
>
> I'd instead have these in the header as static inline since they're just a
> single function call, but up to you.

Good point. I will apply it.

>> +static void led_clamp_align(struct led_flash_setting *s)
>> +{
>> +	u32 v, offset;
>> +
>> +	v = s->val + s->step / 2;
>> +	v = clamp(v, s->min, s->max);
>> +	offset = v - s->min;
>> +	offset = s->step * (offset / s->step);
>> +	s->val = s->min + offset;
>> +}
>> +
>> +int led_set_flash_timeout(struct led_classdev_flash *flash, u32 timeout)
>> +{
>> +	struct led_classdev *led_cdev = &flash->led_cdev;
>> +	struct led_flash_setting *s = &flash->timeout;
>> +
>> +	s->val = timeout;
>> +	led_clamp_align(s);
>> +
>> +	if (!(led_cdev->flags & LED_SUSPENDED))
>> +		return call_flash_op(flash, timeout_set, s->val);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(led_set_flash_timeout);
>> +
>> +int led_get_flash_fault(struct led_classdev_flash *flash, u32 *fault)
>> +{
>> +	return call_flash_op(flash, fault_get, fault);
>> +}
>> +EXPORT_SYMBOL_GPL(led_get_flash_fault);
>> +
>> +int led_set_flash_brightness(struct led_classdev_flash *flash,
>> +				u32 brightness)
>> +{
>> +	struct led_classdev *led_cdev = &flash->led_cdev;
>> +	struct led_flash_setting *s = &flash->brightness;
>> +
>> +	s->val = brightness;
>> +	led_clamp_align(s);
>> +
>> +	if (!(led_cdev->flags & LED_SUSPENDED))
>> +		return call_flash_op(flash, flash_brightness_set, s->val);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(led_set_flash_brightness);
>> +
>> +int led_update_flash_brightness(struct led_classdev_flash *flash)
>> +{
>> +	struct led_flash_setting *s = &flash->brightness;
>> +	u32 brightness;
>> +
>> +	if (has_flash_op(flash, flash_brightness_get)) {
>> +		int ret = call_flash_op(flash, flash_brightness_get,
>> +						&brightness);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		s->val = brightness;
>> +	}
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(led_update_flash_brightness);
>> +
>> +MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
>> +MODULE_LICENSE("GPL");
>> +MODULE_DESCRIPTION("LED Flash class Interface");
>> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
>> index dbeebac..02564c5 100644
>> --- a/drivers/leds/led-class.c
>> +++ b/drivers/leds/led-class.c
>> @@ -179,6 +179,10 @@ EXPORT_SYMBOL_GPL(led_classdev_suspend);
>>   void led_classdev_resume(struct led_classdev *led_cdev)
>>   {
>>   	led_cdev->brightness_set(led_cdev, led_cdev->brightness);
>> +
>> +	if (led_cdev->flash_resume)
>> +		led_cdev->flash_resume(led_cdev);
>> +
>>   	led_cdev->flags &= ~LED_SUSPENDED;
>>   }
>>   EXPORT_SYMBOL_GPL(led_classdev_resume);
>> diff --git a/include/linux/led-class-flash.h b/include/linux/led-class-flash.h
>> new file mode 100644
>> index 0000000..2043082
>> --- /dev/null
>> +++ b/include/linux/led-class-flash.h
>> @@ -0,0 +1,186 @@
>> +/*
>> + * LED Flash class interface
>> + *
>> + * Copyright (C) 2014 Samsung Electronics Co., Ltd.
>> + * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + */
>> +#ifndef __LINUX_FLASH_LEDS_H_INCLUDED
>> +#define __LINUX_FLASH_LEDS_H_INCLUDED
>> +
>> +#include <linux/leds.h>
>> +#include <uapi/linux/v4l2-controls.h>
>> +
>> +struct device_node;
>> +struct led_classdev_flash;
>> +
>> +/*
>> + * Supported led fault bits - must be kept in synch
>> + * with V4L2_FLASH_FAULT bits.
>> + */
>> +#define LED_FAULT_OVER_VOLTAGE		 V4L2_FLASH_FAULT_OVER_VOLTAGE
>> +#define LED_FAULT_TIMEOUT		 V4L2_FLASH_FAULT_TIMEOUT
>> +#define LED_FAULT_OVER_TEMPERATURE	 V4L2_FLASH_FAULT_OVER_TEMPERATURE
>> +#define LED_FAULT_SHORT_CIRCUIT		 V4L2_FLASH_FAULT_SHORT_CIRCUIT
>> +#define LED_FAULT_OVER_CURRENT		 V4L2_FLASH_FAULT_OVER_CURRENT
>> +#define LED_FAULT_INDICATOR		 V4L2_FLASH_FAULT_INDICATOR
>> +#define LED_FAULT_UNDER_VOLTAGE		 V4L2_FLASH_FAULT_UNDER_VOLTAGE
>> +#define LED_FAULT_INPUT_VOLTAGE		 V4L2_FLASH_FAULT_INPUT_VOLTAGE
>> +#define LED_FAULT_LED_OVER_TEMPERATURE	 V4L2_FLASH_OVER_TEMPERATURE
>
> V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE

Thanks for spotting this.

>> +
>> +struct led_flash_ops {
>> +	/* set flash brightness */
>> +	int (*flash_brightness_set)(struct led_classdev_flash *flash,
>> +					u32 brightness);
>> +	/* get flash brightness */
>> +	int (*flash_brightness_get)(struct led_classdev_flash *flash,
>> +					u32 *brightness);
>> +	/* set flash strobe state */
>> +	int (*strobe_set)(struct led_classdev_flash *flash, bool state);
>> +	/* get flash strobe state */
>> +	int (*strobe_get)(struct led_classdev_flash *flash, bool *state);
>> +	/* set flash timeout */
>> +	int (*timeout_set)(struct led_classdev_flash *flash, u32 timeout);
>> +	/* get the flash LED fault */
>> +	int (*fault_get)(struct led_classdev_flash *flash, u32 *fault);
>> +};
>> +
>> +/*
>> + * Current value of a flash setting along
>> + * with its constraints.
>> + */
>> +struct led_flash_setting {
>> +	/* maximum allowed value */
>> +	u32 min;
>> +	/* maximum allowed value */
>> +	u32 max;
>> +	/* step value */
>> +	u32 step;
>> +	/* current value */
>> +	u32 val;
>> +};
>> +
>> +struct led_classdev_flash {
>> +	/* led class device */
>> +	struct led_classdev led_cdev;
>> +
>> +	/* flash led specific ops */
>> +	const struct led_flash_ops *ops;
>> +
>> +	/* flash brightness value in microamperes along with its constraints */
>> +	struct led_flash_setting brightness;
>> +
>> +	/* flash timeout value in microseconds along with its constraints */
>> +	struct led_flash_setting timeout;
>> +
>> +	/*
>> +	 * Indicates whether the flash sub-led should strobe
>> +	 * upon strobe activation on any of the remaining sub-leds.
>> +	 */
>> +	bool sync_strobe:1;
>> +};
>> +
>> +static inline struct led_classdev_flash *lcdev_to_flash(
>> +						struct led_classdev *lcdev)
>> +{
>> +	return container_of(lcdev, struct led_classdev_flash, led_cdev);
>> +}
>> +
>> +/**
>> + * led_classdev_flash_register - register a new object of led_classdev class
>> + *				 with support for flash LEDs
>> + * @parent: the flash LED to register
>> + * @flash: the led_classdev_flash structure for this device
>> + *
>> + * Returns: 0 on success or negative error value on failure
>> + */
>> +int led_classdev_flash_register(struct device *parent,
>> +				struct led_classdev_flash *flash);
>> +
>> +/**
>> + * led_classdev_flash_unregister - unregisters an object of led_classdev class
>> + *				   with support for flash LEDs
>> + * @flash: the flash LED to unregister
>> + *
>> + * Unregister a previously registered via led_classdev_flash_register object
>> + */
>> +void led_classdev_flash_unregister(struct led_classdev_flash *flash);
>> +
>> +/**
>> + * led_set_flash_strobe - setup flash strobe
>> + * @flash: the flash LED to set strobe on
>> + * @state: 1 - strobe flash, 0 - stop flash strobe
>> + *
>> + * Strobe the flash LED.
>> + *
>> + * Returns: 0 on success or negative error value on failure
>> + */
>> +extern int led_set_flash_strobe(struct led_classdev_flash *flash,
>> +				bool state);
>> +
>> +/**
>> + * led_get_flash_strobe - get flash strobe status
>> + * @flash: the flash LED to query
>> + * @state: 1 - flash is strobing, 0 - flash is off
>> + *
>> + * Check whether the flash is strobing at the moment.
>> + *
>> + * Returns: 0 on success or negative error value on failure
>> + */
>> +extern int led_get_flash_strobe(struct led_classdev_flash *flash,
>> +				bool *state);
>
> Fits on a single line. The same above.

Right.

>> +
>> +/**
>> + * led_set_flash_brightness - set flash LED brightness
>> + * @flash: the flash LED to set
>> + * @brightness: the brightness to set it to
>> + *
>> + * Set a flash LED's brightness.
>> + *
>> + * Returns: 0 on success or negative error value on failure
>> + */
>> +extern int led_set_flash_brightness(struct led_classdev_flash *flash,
>> +					u32 brightness);
>> +
>> +/**
>> + * led_update_flash_brightness - update flash LED brightness
>> + * @flash: the flash LED to query
>> + *
>> + * Get a flash LED's current brightness and update led_flash->brightness
>> + * member with the obtained value.
>> + *
>> + * Returns: 0 on success or negative error value on failure
>> + */
>> +extern int led_update_flash_brightness(struct led_classdev_flash *flash);
>> +
>> +/**
>> + * led_set_flash_timeout - set flash LED timeout
>> + * @flash: the flash LED to set
>> + * @timeout: the flash timeout to set it to
>> + *
>> + * Set the flash strobe duration. The duration set by the driver
>> + * is returned in the timeout argument and may differ from the
>> + * one that was originally passed.
>> + *
>> + * Returns: 0 on success or negative error value on failure
>> + */
>> +extern int led_set_flash_timeout(struct led_classdev_flash *flash,
>> +					u32 timeout);
>> +
>> +/**
>> + * led_get_flash_fault - get the flash LED fault
>> + * @flash: the flash LED to query
>> + * @fault: bitmask containing flash faults
>> + *
>> + * Get the flash LED fault.
>> + *
>> + * Returns: 0 on success or negative error value on failure
>> + */
>> +extern int led_get_flash_fault(struct led_classdev_flash *flash,
>> +					u32 *fault);
>> +
>> +#endif	/* __LINUX_FLASH_LEDS_H_INCLUDED */
>> diff --git a/include/linux/leds.h b/include/linux/leds.h
>> index cfceef3..c359f35 100644
>> --- a/include/linux/leds.h
>> +++ b/include/linux/leds.h
>> @@ -46,6 +46,8 @@ struct led_classdev {
>>   #define LED_SYSFS_DISABLE	(1 << 20)
>>   #define SET_BRIGHTNESS_ASYNC	(1 << 21)
>>   #define SET_BRIGHTNESS_SYNC	(1 << 22)
>> +#define LED_DEV_CAP_FLASH	(1 << 23)
>> +#define LED_DEV_CAP_COMPOUND	(1 << 24)
>>
>>   	/* Set LED brightness level */
>>   	/* Must not sleep, use a workqueue if needed */
>> @@ -81,6 +83,7 @@ struct led_classdev {
>>   	unsigned long		 blink_delay_on, blink_delay_off;
>>   	struct timer_list	 blink_timer;
>>   	int			 blink_brightness;
>> +	void			(*flash_resume)(struct led_classdev *led_cdev);
>>
>>   	struct work_struct	set_brightness_work;
>>   	int			delayed_set_value;
>

Best Regards,
Jacek Anaszewski
