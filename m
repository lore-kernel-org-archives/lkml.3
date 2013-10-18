Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3JRBMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 21:12:09 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:34479 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3JRBMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 21:12:07 -0400
Message-ID: <52608AE7.30100@gmail.com>
Date: Thu, 17 Oct 2013 21:12:07 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] alarmtimer: return EINVAL instead of ENOTSUPP if rtcdev
 doesn't exist
References: <1381786396-1818-1-git-send-email-kosaki.motohiro@gmail.com> <526018C6.5070604@linaro.org>
In-Reply-To: <526018C6.5070604@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(10/17/13 1:05 PM), John Stultz wrote:
> On 10/14/2013 02:33 PM, kosaki.motohiro@gmail.com wrote:
>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>
>> Fedora Ruby maintainer reported latest Ruby doesn't work on Fedora Rawhide
>> on ARM. (http://bugs.ruby-lang.org/issues/9008)
>>
>> Because of, commit 1c6b39ad3f (alarmtimers: Return -ENOTSUPP if no
>> RTC device is present) intruduced to return ENOTSUPP when
>> clock_get{time,res} can't find a RTC device. However it is incorrect.
>>
>> Posix and Linux man pages agree that clock_gettime and clock_getres
>> should return EINVAL if clk_id argument is invalid. This is significant
>> different from timer_create API.
>>
>> This patch fixes it.
>
> Hrm... So I feel like there is a difference here. The clockid for
> CLOCK_BOOTTIME_ALARM and CLOCK_REALTIME_ALARM are both valid.
>
> Its just that they're not supported on this specific hardware because it
> apparently lacks a RTC that has told the system it can be used as a
> wakeup device (Its actually quite likely on the hardware that the RTC
> can be a wakeup device, but that the driver is probably setting the
> wakeup flag after the RTC registered - so there is probably a driver bug
> here too).
>
> So I feel like in this case EINVAL isn't quite right.  I'll admit it is
> somewhat new behavior, because we haven't had any clockids before that
> were dependent on the particular hardware, they either existed in a
> kernel verison or didn't.
>
> Would updating the manpage be a better route?

Nope.

ENOTSUPP is not exported to userland. ENOTSUP (single P) and EOPNOTSUP is
valid errno (and they are same on linux), but ENOTSUPP is a kernel internal specific.

Moreover, I completely disagree your position. Both CLOCK_REALTIME_ALARM unsupported
kernel and ARM which doesn't support RTC should use the same error because application
need the same fallback.



