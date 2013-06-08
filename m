Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab3FHI4m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 04:56:42 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:60487 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab3FHI4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 04:56:39 -0400
Message-ID: <51B2F1A4.5070604@ahsoftware.de>
Date: Sat, 08 Jun 2013 10:56:04 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] rtc: rtc-hid-sensor-time: fix possible bug on driver_remove
References: <1367752887-2927-4-git-send-email-holler@ahsoftware.de> <1370338722-3646-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1370338722-3646-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

sorry to bother again. I've now had the time to play with the new 
hctosys I proposed patches for and rtc-hid-sensor-time.

If the new hctosys mechanism will end up in the kernel, the following 
patches I've recently send and which already got merged to -mm won't 
work anymore and should disappear:

[PATCH 3/4] rtc: rtc-hid-sensor-time: add option hctosys to set time at boot
[PATCH 4/4] rtc: rtc-hid-sensor-time: add support for milliseconds
[PATCH] rtc: rtc-hid-sensor-time: fix possible bug on driver_remove


The other two patches


[PATCH 1/4] rtc: rtc-hid-sensor-time: allow full years (16bit) in HID 
reports
[PATCH 2/4] rtc: rtc-hid-sensor-time: allow 16 and 32 bit values for all 
attributes.

which got merged too are still fine.


I don't know if I should send reverts for those 3 patches, or ...

I've already have a patch which would be needed if the new hctosys would 
be used, but I will delay sending them until we figured out if and how 
that new hctosys will become real. But you might already revert or 
delete the above 3 patches in your tree.


That silly looking driver rtc-hid-sensor-time is really an endless story. :/

Besides writing the driver and an example firmware implementation I had 
to make patches for iio, hid-sensor-hub and hid, and now for timekeeping 
and rtc. All for nothing but the fun having to convince maintainers of 
all sorts and bothering them. ;)


And the todo-list still contains some stuff:

- rtc-hid-sensor-time still does not get loaded automatically if a 
matching hid-sensor-hub appears to the system. That needs changes to hid 
and/or hid-sensor-hub. Problem is that I don't have a real hid sensor 
hub and I don't know why the people which do produce such products and 
have written hid-sensor-hub didn't have implemented a way to do such. Or 
I've just missed something.

- Have to redo millisecond support.

- ntp functionality (e.g. module parameter adjtime) to make it possible 
to use a hardware clock with support for milliseconds to turn the system 
clock to a stratum 1 clock.

- and last but not least I hope the standard for those HID sensors will 
become a standardized way to set the time. I still wouldn't like it if I 
had to "invent" something myself (easy, but it would be linux-specific 
and "invented" by some fool like me who just wrote it's own firmware 
without having any knowledge about some real hid-sensor products ;) ), 
but ...

Regards,

Alexander Holler
