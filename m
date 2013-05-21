Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab3EUWDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:03:06 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:42067 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab3EUWDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:03:04 -0400
Message-ID: <519BEF13.2040500@linaro.org>
Date: Tue, 21 May 2013 15:02:59 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 3/4] rtc: rtc-hid-sensor-time: add option hctosys to set
 time at boot
References: <51765FB9.2050009@ahsoftware.de> <1367752887-2927-1-git-send-email-holler@ahsoftware.de> <1367752887-2927-4-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1367752887-2927-4-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2013 04:21 AM, Alexander Holler wrote:
> drivers/rtc/hctosys (CONFIG_RTC_HCTOSYS) doesn't work for
> rtc-hid-sensor-time because it will be called in late_init, and thus before
> rtc-hid-sensor-time gets loaded. To set the time through
> rtc-hid-sensor-time at startup, the module now checks by default if the
> system time is before 1970-01-02 and sets the system time (once) if this is
> the case.
>
> To disable this behaviour, set the module option hctosys to zero, e.g. by
> using rtc-hid-sensor-time.hctosys=0 at the kernel command line if the
> driver is statically linked into the kernel.

Sorry I missed this earlier, it fell into my spam box for some reason.


Like Andrew, I think this feels particularly hacky.

Why exactly is late_init too early? (I'm unfamiliar with the 
rtc-hid-sensor-time driver)

If this is a hotplug rtc device (why I'm guessing its not available at 
late_init), would it not be better to leave the setting of time using 
hwclock --hctosys via a udev rule or something?

thanks
-john
