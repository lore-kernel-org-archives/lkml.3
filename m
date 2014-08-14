Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaHNIZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:25:57 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31146 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaHNIZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:25:32 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-75-53ec7279c7f8
Message-id: <53EC7278.6040101@samsung.com>
Date: Thu, 14 Aug 2014 10:25:28 +0200
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
 <53E8C4BA.6050805@samsung.com>
 <20140814043436.GM16460@valkosipuli.retiisi.org.uk>
In-reply-to: <20140814043436.GM16460@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xq7qVRW+CDebP4rDYOGM9q8X8I+dY
	LZb83MVkcbbpDbvF5V1z2Cy2vlnHaNGzYSurxZn9K9kcODym/N7I6nH460IWj74tqxg9Pm+S
	C2CJ4rJJSc3JLEst0rdL4Mr4sOsnY8FLnYrm5QvZGhi3qHYxcnJICJhIrJv0kw3CFpO4cG89
	kM3FISSwlFGi5cJ6FgjnI6PErX9XGUGqeAW0JA6dfwRmswioSjTdWgnWzSZgKPHzxWsmEFtU
	IELiz+l9rBD1ghI/Jt9jAbFFBNQknm56CDaUWeA6o8SKdw/ZQRLCAgESCy7PBGsQErjAJNG7
	xwzE5hRwkLhxYAvYAmYBa4mVk7YxQtjyEpvXvGWewCgwC8mOWUjKZiEpW8DIvIpRNLU0uaA4
	KT3XUK84Mbe4NC9dLzk/dxMjJNC/7GBcfMzqEKMAB6MSD++L2a+DhVgTy4orcw8xSnAwK4nw
	vsl9EyzEm5JYWZValB9fVJqTWnyIkYmDU6qBseXyQk4GTqGUmOpuzorj/z5czbhU2JYjG88q
	8PLDROVZ+zh1ZBoerp2bufKT8uX7c88KzFD6qLioaWuCuI3oTS2Rb+xv5uYr/ol9+mChG7d4
	a0p337QHn2Q57NMWqvX8P6Cp1ppUqH2kevqN+MgHlrP6s7u/zdWUuv5f6e71/pfL152O6Vxh
	rcRSnJFoqMVcVJwIAAUvv09SAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2014 06:34 AM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Mon, Aug 11, 2014 at 03:27:22PM +0200, Jacek Anaszewski wrote:
>
> ...
>
>>>>>> diff --git a/include/media/v4l2-flash.h b/include/media/v4l2-flash.h
>>>>>> new file mode 100644
>>>>>> index 0000000..effa46b
>>>>>> --- /dev/null
>>>>>> +++ b/include/media/v4l2-flash.h
>>>>>> @@ -0,0 +1,137 @@
>>>>>> +/*
>>>>>> + * V4L2 Flash LED sub-device registration helpers.
>>>>>> + *
>>>>>> + *	Copyright (C) 2014 Samsung Electronics Co., Ltd
>>>>>> + *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
>>>>>> + *
>>>>>> + * This program is free software; you can redistribute it and/or modify
>>>>>> + * it under the terms of the GNU General Public License version 2 as
>>>>>> + * published by the Free Software Foundation."
>>>>>> + */
>>>>>> +
>>>>>> +#ifndef _V4L2_FLASH_H
>>>>>> +#define _V4L2_FLASH_H
>>>>>> +
>>>>>> +#include <media/v4l2-ctrls.h>
>>>>>> +#include <media/v4l2-device.h>
>>>>>> +#include <media/v4l2-dev.h>le
>>>>>> +#include <media/v4l2-event.h>
>>>>>> +#include <media/v4l2-ioctl.h>
>>>>>> +
>>>>>> +struct led_classdev_flash;
>>>>>> +struct led_classdev;
>>>>>> +enum led_brightness;
>>>>>> +
>>>>>> +struct v4l2_flash_ops {
>>>>>> +	int (*torch_brightness_set)(struct led_classdev *led_cdev,
>>>>>> +					enum led_brightness brightness);
>>>>>> +	int (*torch_brightness_update)(struct led_classdev *led_cdev);
>>>>>> +	int (*flash_brightness_set)(struct led_classdev_flash *flash,
>>>>>> +					u32 brightness);
>>>>>> +	int (*flash_brightness_update)(struct led_classdev_flash *flash);
>>>>>> +	int (*strobe_set)(struct led_classdev_flash *flash, bool state);
>>>>>> +	int (*strobe_get)(struct led_classdev_flash *flash, bool *state);
>>>>>> +	int (*timeout_set)(struct led_classdev_flash *flash, u32 timeout);
>>>>>> +	int (*indicator_brightness_set)(struct led_classdev_flash *flash,
>>>>>> +					u32 brightness);
>>>>>> +	int (*indicator_brightness_update)(struct led_classdev_flash *flash);
>>>>>> +	int (*external_strobe_set)(struct led_classdev_flash *flash,
>>>>>> +					bool enable);
>>>>>> +	int (*fault_get)(struct led_classdev_flash *flash, u32 *fault);
>>>>>> +	void (*sysfs_lock)(struct led_classdev *led_cdev);
>>>>>> +	void (*sysfs_unlock)(struct led_classdev *led_cdev);
>>>>>
>>>>> These functions are not driver specific and there's going to be just one
>>>>> implementation (I suppose). Could you refresh my memory regarding why
>>>>> the LED framework functions aren't called directly?
>>>>
>>>> These ops are required to make possible building led-class-flash as
>>>> a kernel module.
>>>
>>> Assuming you'd use the actual implementation directly, what would be the
>>> dependencies? I don't think the LED flash framework has any callbacks
>>> towards the V4L2 (LED) flash framework, does it? Please correct my
>>> understanding if I'm missing something. In Makefile format, assume all
>>> targets are .PHONY:
>>>
>>> led-flash-api: led-api
>>>
>>> v4l2-flash: led-flash-api
>>>
>>> driver: led-flash-api v4l2-flash
>>
>> LED Class Flash driver gains V4L2 Flash API when
>> CONFIG_V4L2_FLASH_LED_CLASS is defined. This is accomplished in
>> the probe function by either calling v4l2_flash_init function
>> or the macro of this name, when the CONFIG_V4L2_FLASH_LED_CLASS
>> macro isn't defined.
>>
>> If the v4l2-flash.c was to call the LED API directly, then the
>> led-class-flash module symbols would have to be available at
>> v4l2-flash.o linking time.
>
> Is this an issue? EXPORT_SYMBOL_GPL() for the relevant symbols should be
> enough.

It isn't enough. If I call e.g. led_set_flash_brightness
directly from v4l2-flash.c and configure led-class-flash to be built as
a module then I am getting "undefined reference to
led_set_flash_brightness" error during linking phase.

It happens because the linker doesn't take into account
led-flash-class.ko symbols. It is reasonable because initially
the kernel boots up without led-flash-class.ko module and
the processor wouldn't know the address to jump to in the
result of calling a led API function.
The led-class-flash.ko binary code is loaded into memory not
sooner than after executing "insmod led-class-flash.ko".

After linking dynamically with kernel the LED API function
addresses are relocated, and the LED Flash Class core can
initialize the v4l2_flash_ops structure. Then every LED Flash Class
driver can obtain the address of this structure with
led_get_v4l2_flash_ops and pass it to the v4l2_flash_init.

>> This requirement cannot be met if the led-class-flash is built
>> as a module.
>>
>> Use of function pointers in the v4l2-flash.c allows to compile it
>> into the kernel and enables the possibility of adding the V4L2 Flash
>> support conditionally, during driver probing.
>
> I'd simply decide this during kernel compilation time. If you want
> something, just enable it. v4l2_flash_init() is called directly by the
> driver in any case, so unless that is also called through a wrapper the
> driver is still directly dependent on it.

The problem is that v4l2-flash.o would have to depend on
led-class-flash.o, which when built as a module isn't available
during v4l2-flash.o linking time. In order to avoid v4l2-flash.o linking
problem, it would have to be built as a module.

Nevertheless, in this arrangement, the CONFIG_V4L2_FLASH_LED_CLASS
macro would be defined only in v4l2-flash.ko module, and
a LED Flash Class driver couldn't check whether V4L2 Flash support
is enabled. Its dependence on v4l2-flash.o would have to be fixed,
which is not what we want.

I have tested all these cases.

Best Regards,
Jacek Anaszewski
