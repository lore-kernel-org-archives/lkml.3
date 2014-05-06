Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934085AbaEFGoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 02:44:37 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:28191 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933956AbaEFGoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 02:44:34 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-ee-536884d06fc2
Message-id: <536884D9.4050104@samsung.com>
Date: Tue, 06 May 2014 08:44:41 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH/RFC v3 5/5] media: Add registration helpers for V4L2 flash
 sub-devices
References: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
 <1397228216-6657-6-git-send-email-j.anaszewski@samsung.com>
 <20140416182141.GG8753@valkosipuli.retiisi.org.uk>
 <534F9044.6080508@samsung.com>
 <20140423152435.GJ8753@valkosipuli.retiisi.org.uk>
 <535E3A95.6010206@samsung.com>
 <20140502110651.GX8753@valkosipuli.retiisi.org.uk>
In-reply-to: <20140502110651.GX8753@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xa7oXWjKCDfauELe4te4cq8X8I0Di
	bNMbdovLu+awWWx9s47RomfDVlaLw2/aWS3O7F/J5sDhcfjrQhaPvi2rGD0+b5ILYI7isklJ
	zcksSy3St0vgyphz6y97QQNfxaspD9gbGOdzdzFyckgImEg0LDjEDGGLSVy4t56ti5GLQ0hg
	KaPErmW3GCGcj4wSB06/ZQKp4hXQkph35gSYzSKgKrH6zjp2EJtNwFDi54vXYHFRgQiJP6f3
	sULUC0r8mHyPBcQWEVCTeLrpIQvIUGaBg4wSH7ZfYANJCAvESCw79ANq2zMmiR9Hb4PdxClg
	L9G8bgvYVGYBa4mVk7YxQtjyEpvXvGWewCgwC8mSWUjKZiEpW8DIvIpRNLU0uaA4KT3XUK84
	Mbe4NC9dLzk/dxMjJMC/7GBcfMzqEKMAB6MSD++L6IxgIdbEsuLK3EOMEhzMSiK89flAId6U
	xMqq1KL8+KLSnNTiQ4xMHJxSDYyNrZ3TnskXrPr6vqqn0feYd/x71YaVtd+YZlUafbncueTI
	owuyHELPqvouSpqucNkSezu+8iyvf84cmR83osLKS27ffHekvfzbhS9td5sj7fn/PTvhMnHl
	lD1OQZ0di5JEr+g+07kYpK/A69/suas+49weF8c1TdePvTT/O92+r/uPUd+tf3OUWIozEg21
	mIuKEwFQ0LuMTgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

On 05/02/2014 01:06 PM, Sakari Ailus wrote:

>>>> [...]
>>>>>> +static inline enum led_brightness v4l2_flash_intensity_to_led_brightness(
>>>>>> +					struct led_ctrl *config,
>>>>>> +					u32 intensity)
>>>>>
>>>>> Fits on a single line.
>>>>>
>>>>>> +{
>>>>>> +	return intensity / config->step;
>>>>>
>>>>> Shouldn't you first decrement the minimum before the division?
>>>>
>>>> Brightness level 0 means that led is off. Let's consider following case:
>>>>
>>>> intensity - 15625
>>>> config->step - 15625
>>>> intensity / config->step = 1 (the lowest possible current level)
>>>
>>> In V4L2 controls the minimum is not off, and zero might not be a possible
>>> value since minimum isn't divisible by step.
>>>
>>> I wonder how to best take that into account.
>>
>> I've assumed that in MODE_TORCH a led is always on. Switching
>> the mode to MODE_FLASH or MODE_OFF turns the led off.
>> This way we avoid the problem with converting 0 uA value to
>> led_brightness, as available torch brightness levels start from
>> the minimum current level value and turning the led off is
>> accomplished on transition to MODE_OFF or MODE_FLASH, by
>> calling brightness_set op with led_brightness = 0.
>
> I'm not sure if we understood the issue the same way. My concern was that if
> the intensity isn't a multiple of step (but intensity - min is), the above
> formula won't return a valid result (unless I miss something).
>

Please note that v4l2_flash_intensity_to_led_brightness is called only
from s_ctrl callback, and thus it expects to get the intensity aligned
to the step value, so it will always be a multiple of step.
Is it possible that s_ctrl callback would be passed a non-aligned
control value?

Regards,
Jacek Anaszewski

