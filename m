Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbaFLMX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 08:23:56 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:48748 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbaFLMXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 08:23:53 -0400
Message-ID: <539996AA.6020205@ahsoftware.de>
Date: Thu, 12 Jun 2014 14:01:46 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>, John Whitmore <arigead@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: rtc/hctosys.c Problem during kernel boot
References: <20140611230127.GA28066@griso.site> <CANcMJZDqAmdFLYq2LW60zU_d05Pv8tcYE1Nb=ftZcj5UukxqaA@mail.gmail.com>
In-Reply-To: <CANcMJZDqAmdFLYq2LW60zU_d05Pv8tcYE1Nb=ftZcj5UukxqaA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.06.2014 01:53, schrieb John Stultz:

> Sigh. Yea, this issue was brought up previously, but we never got
> around to a solution that could be merged.
>
> Basically hctosys is late_init, but if the driver is a module, it
> might not be loaded in time. Adding hooks at module load time when
> RTCs are registered could be done, but then you have the issue that
> userspace might have set the clock via something like ntpdate, so
> HCTOSYS could then cause the clock to be less accurate.
>
> So we need to make the HCTOSYS functionality happen at RTC register
> time, but it needs to set the clock only if nothing has set the clock
> already. This requires a new timekeeeping interface - something like
> timekeeping_set_time_if_unset(), which atomically would set the time
> if it has never been set.
>
> You can read some of the previous discussion here:
> https://lkml.org/lkml/2013/6/17/533
>
> I'd be very interested in patches to resolve this!

Hmm, I'm still using this patches, now with 3.15 on a bunch of very 
different x86 and arm boxes. So they are now tested since a year.

Unfortunately my expieriences with Linux kernel maintainers became even 
worse and I'm not very eager to post patches. But if someone wants these 
patches based on 3.15, feel free to notice me.

To get rid of hctosys, I have 3 patches, and 2 more to implement 
rtc_read_timeval() for higher resolution clocks.

Regards,

Alexander Holler
