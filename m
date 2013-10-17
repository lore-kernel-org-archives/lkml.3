Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab3JQRFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:05:17 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:45814 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3JQRFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:05:15 -0400
Message-ID: <526018C6.5070604@linaro.org>
Date: Thu, 17 Oct 2013 10:05:10 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] alarmtimer: return EINVAL instead of ENOTSUPP if rtcdev
 doesn't exist
References: <1381786396-1818-1-git-send-email-kosaki.motohiro@gmail.com>
In-Reply-To: <1381786396-1818-1-git-send-email-kosaki.motohiro@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 02:33 PM, kosaki.motohiro@gmail.com wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> Fedora Ruby maintainer reported latest Ruby doesn't work on Fedora Rawhide
> on ARM. (http://bugs.ruby-lang.org/issues/9008)
>
> Because of, commit 1c6b39ad3f (alarmtimers: Return -ENOTSUPP if no
> RTC device is present) intruduced to return ENOTSUPP when
> clock_get{time,res} can't find a RTC device. However it is incorrect.
>
> Posix and Linux man pages agree that clock_gettime and clock_getres
> should return EINVAL if clk_id argument is invalid. This is significant
> different from timer_create API.
>
> This patch fixes it.

Hrm... So I feel like there is a difference here. The clockid for
CLOCK_BOOTTIME_ALARM and CLOCK_REALTIME_ALARM are both valid.

Its just that they're not supported on this specific hardware because it
apparently lacks a RTC that has told the system it can be used as a
wakeup device (Its actually quite likely on the hardware that the RTC
can be a wakeup device, but that the driver is probably setting the
wakeup flag after the RTC registered - so there is probably a driver bug
here too).

So I feel like in this case EINVAL isn't quite right.  I'll admit it is
somewhat new behavior, because we haven't had any clockids before that
were dependent on the particular hardware, they either existed in a
kernel verison or didn't.

Would updating the manpage be a better route?

thanks
-john


