Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab3JRXMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 19:12:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42491 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab3JRXMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 19:12:05 -0400
Message-ID: <5261C040.5050000@jp.fujitsu.com>
Date: Fri, 18 Oct 2013 19:12:00 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: john.stultz@linaro.org, kosaki.motohiro@gmail.com
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, fweisbec@gmail.com
Subject: Re: [PATCH] alarmtimer: return EINVAL instead of ENOTSUPP if rtcdev
 doesn't exist
References: <1381786396-1818-1-git-send-email-kosaki.motohiro@gmail.com> <526018C6.5070604@linaro.org> <52608AE7.30100@gmail.com> <5261B887.3010705@linaro.org>
In-Reply-To: <5261B887.3010705@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 6:39 PM, John Stultz wrote:
> On 10/17/2013 06:12 PM, KOSAKI Motohiro wrote:
>> (10/17/13 1:05 PM), John Stultz wrote:
>>> On 10/14/2013 02:33 PM, kosaki.motohiro@gmail.com wrote:
>>>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>>>
>>>> Fedora Ruby maintainer reported latest Ruby doesn't work on Fedora
>>>> Rawhide
>>>> on ARM. (http://bugs.ruby-lang.org/issues/9008)
>>>>
>>>> Because of, commit 1c6b39ad3f (alarmtimers: Return -ENOTSUPP if no
>>>> RTC device is present) intruduced to return ENOTSUPP when
>>>> clock_get{time,res} can't find a RTC device. However it is incorrect.
>>>>
>>>> Posix and Linux man pages agree that clock_gettime and clock_getres
>>>> should return EINVAL if clk_id argument is invalid. This is significant
>>>> different from timer_create API.
>>>>
>>>> This patch fixes it.
>>>
>>> Hrm... So I feel like there is a difference here. The clockid for
>>> CLOCK_BOOTTIME_ALARM and CLOCK_REALTIME_ALARM are both valid.
>>>
>>> Its just that they're not supported on this specific hardware because it
>>> apparently lacks a RTC that has told the system it can be used as a
>>> wakeup device (Its actually quite likely on the hardware that the RTC
>>> can be a wakeup device, but that the driver is probably setting the
>>> wakeup flag after the RTC registered - so there is probably a driver bug
>>> here too).
>>>
>>> So I feel like in this case EINVAL isn't quite right.  I'll admit it is
>>> somewhat new behavior, because we haven't had any clockids before that
>>> were dependent on the particular hardware, they either existed in a
>>> kernel verison or didn't.
>>>
>>> Would updating the manpage be a better route?
>>
>> Nope.
>>
>> ENOTSUPP is not exported to userland. ENOTSUP (single P) and EOPNOTSUP is
>> valid errno (and they are same on linux), but ENOTSUPP is a kernel
>> internal specific.
>>
>> Moreover, I completely disagree your position. Both
>> CLOCK_REALTIME_ALARM unsupported
>> kernel and ARM which doesn't support RTC should use the same error
>> because application
>> need the same fallback.
> 
> Ok. You're right. The technicality that the clockid is valid but
> unsupported isn't really useful to the applications, since the effect is
> the same.
> 
> What is the urgency on this? As the issue has been around since 3.0, is
> it ok if it gets queued for 3.13 and marked for stable, or does it need
> to land in 3.12?

3.13 is OK to me.




