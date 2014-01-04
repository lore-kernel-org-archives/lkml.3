Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbaADASc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 19:18:32 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:43413 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbaADASb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 19:18:31 -0500
Message-ID: <52C75353.8060505@linaro.org>
Date: Fri, 03 Jan 2014 16:18:27 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexey Perevalov <a.perevalov@samsung.com>
CC: linux-kernel@vger.kernel.org, anton@enomsg.org, kyungmin.park@samsung.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 0/3] Deferrable timers support for timerfd API
References: <1388687448-12987-1-git-send-email-a.perevalov@samsung.com> <52C5F38D.5060201@linaro.org> <52C6F722.3090704@samsung.com>
In-Reply-To: <52C6F722.3090704@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2014 09:45 AM, Alexey Perevalov wrote:
> On 01/03/2014 03:17 AM, John Stultz wrote:
>> On 01/02/2014 10:30 AM, Alexey Perevalov wrote:
>>> This version introduces new clockid (CLOCK_DEFERRABLE) , for
>>> timerfd_create, instead of
>>> new flag (TFD_TIMER_DEFERRABLE) for timerfd_settime introduced in
>>> previous version.
>> So why did you make this change?
>>
>> thanks
>> -john
>>
>>
>
> I looked at alarm timers and found approach of making timer behavior
> persistent per file descriptor is better than
> changeable by timerfd_settime. I think "end user wake up from suspend"
> and "don't wake up in idle" is the same thing on the same abstraction
> level.
>
> Yes Anton's previous  patches worked with CLOCK_MONOTONIC only and I
> didn't intend to use it with CLOCK_REALTIME, cause it's hard to me to
> find such use case.
> Another way - it's stay as was Anton's patch, I mean as flag for the
> timerfd_settime, but in original patch set both hrtimer and deferrable
> timers initialized in timerfd_create, I think it's not needed. Also
> ability to change timer behavior looks not good if you couldn't change
> alarm timer behavior, not unified API.

So while the alarm timers are a reasonable precedent, I think they were
introduced prior to the timerfd interface, so it seemed at the time
having new clockids for the functionality was required to work with the
existing syscalls that use the clockid (Though in retrospect, I question
if it would have been better to use timer flags to introduce the alarm
functionality rather then introducing it via a clockid, as it would
simplify the clockid definitions).

Now that we have the timerfd interface, and if this functionality is
really limited to the timerfds, then we may want to consider what might
be, at least to me, the cleaner approach of using the flag.

Either way, I'd like to make sure we have a sound rational. My worry is
that deferrable timers would be desired on more then just
CLOCK_MONOTONIC, so we could quite likely end up with quite a few new
clockids (ie: CLOCK_BOOTTIME_DEFERRED, CLOCK_TAI_DEFERRED,
CLOCK_REALTIME_DEFERRED).


>
> If I'm right, only high resolution timer could be REALTIME, and there
> is no deferrable behavior for hrtimer only for timer_list.
>
>
I'm not sure I understood this part. Could you explain further?

thanks
-john

