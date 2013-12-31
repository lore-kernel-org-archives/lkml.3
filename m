Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab3LaSsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 13:48:53 -0500
Received: from blu0-omc3-s32.blu0.hotmail.com ([65.55.116.107]:45479 "EHLO
	blu0-omc3-s32.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755608Ab3LaSsv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 13:48:51 -0500
X-TMN: [2AHEHjC4hEesdKkctwznvCOAM/KLBwGE]
X-Originating-Email: [lgxue@hotmail.com]
Message-ID: <BLU172-W451DF59115DB2B0A7F694AACC90@phx.gbl>
From: Joe Xue <lgxue@hotmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH] Add LED pattern trigger
Date: Tue, 31 Dec 2013 13:48:50 -0500
Importance: Normal
In-Reply-To: <20131230162158.7420e811@alan.etchedpixels.co.uk>
References: <1388362275-1618-1-git-send-email-lgxue@hotmail.com>,<20131230162158.7420e811@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 31 Dec 2013 18:48:50.0944 (UTC) FILETIME=[F252E000:01CF0658]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> + * Based on Richard Purdie's ledtrig-timer.c and Atsushi Nemoto's
>> + * ledtrig-heartbeat.c and Shuah Khan's ledtrig-transient.c
>
> I stil think this belongs in user space except for platforms with hardware
> acceleration for it.

This can free the user space application from loop or thread.

>> +#define MAX_PATTEN_LEN 255
>
> Arbitary limits that are not needed if it was in userspace, and not it
> seems a sensible one - why not use 256 ?

Yes, will change it to kmalloc


>> +static DEVICE_ATTR(pattern, 0644, pattern_pattern_show, pattern_pattern_store);
>> +static DEVICE_ATTR(delay_unit, 0644,
>> +static void pattern_trig_deactivate(struct led_classdev *led_cdev)
>> +{
>> + struct pattern_trig_data *pattern_data = led_cdev->trigger_data;
>> +
>> + if (led_cdev->activated) {
>> + del_timer_sync(&pattern_data->timer);
>> + device_remove_file(led_cdev->dev, &dev_attr_pattern);
>> + device_remove_file(led_cdev->dev, &dev_attr_delay_unit);
>
> This doesn't as far as I can see do what you think. If I have the file
> currently open then device_remove_file will not remove my existing access
> to it, but you just released the pattern data so I now write to free
> memory.

will add the mutex lock to avoid that 		 	   		  