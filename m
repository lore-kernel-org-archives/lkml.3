Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaFGKMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 06:12:42 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:53619 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaFGKMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 06:12:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140606094752.GB9307@localhost>
References: <1402003746-6354-1-git-send-email-janne.kanniainen@gmail.com>
	<20140606094752.GB9307@localhost>
Date: Sat, 7 Jun 2014 13:12:39 +0300
Message-ID: <CAEEjW04UAsi7yOdmF3FZ3sLE7m7B-VAH0prDPYjaMXarAfNwcw@mail.gmail.com>
Subject: Re: [PATCH v2] leds: USB: Add support for MSI GT683R led panels
From: Janne Kanniainen <janne.kanniainen@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-usb@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> First of all, please reply to the original thread and make sure to not
> drop people or lists from CC.

Sorry this is my first patch and i didn't know that. Now I know.

> For arrays you can use the ARRAY_SIZE() macro if that was the reason for
> this change. I should have mentioned that when I pointed out that you
> cannot use strlen().

That wasn't the reason. I just thought it might be better to use u64
than char[8]. I know why I can't use strlen and that was only careless
error. And there was lot of them :( I will be more careful next time.

> Where did you get these (HID report) values from by the way?

I got them by reverse engineering.

>> +
>> +static void gt683r_brightness_set(struct led_classdev *led_cdev,
>> +                               enum led_brightness brightness)
>> +{
>> +     struct gt683r_led *led =
>> +                     container_of(led_cdev, struct gt683r_led, led_dev);
>> +
>> +     mutex_lock(&led->lock);
>
> You cannot grab a mutex here since this function can be called from
> interrupt context (if I remember correctly). Either way, you shouldn't
> be holding the lock until the work task has finished...

I thought use asked me to put some lock there:

>> +
>> +static void gt683r_brightness_set(struct led_classdev *led_cdev,
>> +                               enum led_brightness brightness)
>> +{
>> +     struct gt683r_led *led =
>> +                     container_of(led_cdev, struct gt683r_led, led_dev);
>> +
>> +     led->brightness = brightness;
>
> Missing locking?

Janne
