Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936326Ab3DIHIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 03:08:13 -0400
Received: from mail1.sysgo.com ([176.9.26.183]:36684 "EHLO mail1.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932600Ab3DIHIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 03:08:10 -0400
Message-ID: <5163BE58.3090206@sysgo.com>
Date: Tue, 09 Apr 2013 09:08:08 +0200
From: David Engraf <david.engraf@sysgo.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ktime_add_ns() may overflow on 32bit architectures
References: <51485A43.4020600@sysgo.com> <51632673.8030603@linaro.org>
In-Reply-To: <51632673.8030603@linaro.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.04.2013 22:20, schrieb John Stultz:
> On 03/19/2013 05:29 AM, David Engraf wrote:
>> Hello,
>>
>> I've triggered an overflow when using ktime_add_ns() on a 32bit
>> architecture not supporting CONFIG_KTIME_SCALAR.
>>
>> When passing a very high value for u64 nsec, e.g. 7881299347898368000
>> the do_div() function converts this value to seconds (7881299347)
>> which is still to high to pass to the ktime_set() function as long.
>> The result in my case is a negative value.
>>
>> The problem on my system occurs in the tick-sched.c,
>> tick_nohz_stop_sched_tick() when time_delta is set to
>> timekeeping_max_deferment(). The check for time_delta < KTIME_MAX is
>> valid, thus ktime_add_ns() is called with a too large value resulting
>> in a negative expire value. This leads to an endless loop in the
>> ticker code:
>>
>> time_delta: 7881299347898368000
>> expires = ktime_add_ns(last_update, time_delta)
>> expires: negative value
>>
>> This error doesn't occurs on 64bit or architectures supporting
>> CONFIG_KTIME_SCALAR (e.g. ARM, x86-32).
>
> Sorry, this fell through the cracks. I see Andrew caught it, but I've
> queued for 3.10 in my tree as well.
>
> This should be tagged for -stable as well, no?

Yes, please tag it for -stable as well because I had the problem with 
kernel 3.0 and it can overflow on all current version.

Best regards
- David

> thanks
> -john
>

