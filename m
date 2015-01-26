Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbbAZXDe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:03:34 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:41254 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbbAZXDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:03:31 -0500
MIME-Version: 1.0
In-Reply-To: <54B3800C.2000704@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-3-git-send-email-j.anaszewski@samsung.com>
 <20150109174058.GC18076@amd> <54B3800C.2000704@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 26 Jan 2015 15:03:09 -0800
Message-ID: <CAK5ve-LKieXPbKVTG8PV6EQQPvOKXC46AdwAxksuNcKU_QKcug@mail.gmail.com>
Subject: Re: [PATCH/RFC v10 02/19] Documentation: leds: Add description of LED
 Flash class extension
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, b.zolnierkie@samsung.com,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 12:04 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> Hi Pavel,
>
> Thanks for the review.
>
> On 01/09/2015 06:40 PM, Pavel Machek wrote:
>>
>> Hi!
>>
>>> The documentation being added contains overall description of the
>>> LED Flash Class and the related sysfs attributes.
>>>
>>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> Cc: Bryan Wu <cooloney@gmail.com>
>>> Cc: Richard Purdie <rpurdie@rpsys.net>
>>
>>
>>> +In order to enable support for flash LEDs CONFIG_LEDS_CLASS_FLASH symbol
>>> +must be defined in the kernel config. A flash LED driver must register
>>> +in the LED subsystem with led_classdev_flash_register function to gain
>>> flash
>>> +related capabilities.
>>> +
>>> +There are flash LED devices which can control more than one LED and
>>> allow for
>>> +strobing the sub-leds synchronously. A LED will be strobed synchronously
>>> with
>>> +the one whose identifier is written to the flash_sync_strobe sysfs
>>> attribute.
>>> +The list of available sub-led identifiers can be read from the
>>
>>
>> sub-LED?
>
>
> Indeed, this naming will be more consistent.
>
>>> +       - flash_fault - bitmask of flash faults that may have occurred
>>> +                       possible flags are:
>>> +               * 0x01 - flash controller voltage to the flash LED has
>>> exceeded
>>> +                        the limit specific to the flash controller
>>> +               * 0x02 - the flash strobe was still on when the timeout
>>> set by
>>> +                        the user has expired; not all flash controllers
>>> may
>>> +                        set this in all such conditions
>>> +               * 0x04 - the flash controller has overheated
>>> +               * 0x08 - the short circuit protection of the flash
>>> controller
>>> +                        has been triggered
>>> +               * 0x10 - current in the LED power supply has exceeded the
>>> limit
>>> +                        specific to the flash controller
>>> +               * 0x20 - the flash controller has detected a short or
>>> open
>>> +                        circuit condition on the indicator LED
>>> +               * 0x40 - flash controller voltage to the flash LED has
>>> been
>>> +                        below the minimum limit specific to the flash
>>> +               * 0x80 - the input voltage of the flash controller is
>>> below
>>> +                        the limit under which strobing the flash at full
>>> +                        current will not be possible. The condition
>>> persists
>>> +                        until this flag is no longer set
>>> +               * 0x100 - the temperature of the LED has exceeded its
>>> allowed
>>> +                         upper limit
>>
>>
>> Did not everyone agree that text strings are preferable to bitmasks?
>>
>>
>> Pavel
>>
>
> I just forgot to update the flash_fault documentation. Will fix in the
> next version.
>
Please provide an updated version. I will merge them.

-Bryan
