Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbaA0HMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 02:12:33 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28151 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaA0HMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 02:12:32 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-f3-52e606db1854
Message-id: <52E606D8.6000401@samsung.com>
Date: Mon, 27 Jan 2014 11:12:24 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        anton@enomsg.org, kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com, Alexey Perevalov <a.perevalov@samsung.com>
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
 <52DEC6A3.9020600@linaro.org>
In-reply-to: <52DEC6A3.9020600@linaro.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xa7q32Z4FGfyczWEx9+55Fos569ew
	WRzcqmlx/ctzVoszv3Utzja9Ybe4vGsOm8XmTVOZHTg8JvR/YvS4c20Pm8e7c+fYPU7M+M3i
	0bdlFaPH501yAWxRXDYpqTmZZalF+nYJXBm3HqxhLVgkUHFz7S/mBsYu3i5GTg4JAROJt/u/
	MEHYYhIX7q1n62Lk4hASWMoosWfhEnYI5zOjxNovW8GqeAW0JN5vmcUOYrMIqEq07HwNZHNw
	sAkYSOy7ZwtiigpESBxdrglRLSjxY/I9FhBbREBDYuOlW8wgI5kFrjJKNDz5ygqSEBZwlTix
	fT2YLSSQLtH87BPYeE6gVRvvbwdbyyxgLbFy0jZGCFteYvOat8wTGAVmIdkxC0nZLCRlCxiZ
	VzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKEBP3XHYxLj1kdYhTgYFTi4c24/jRIiDWxrLgy
	9xCjBAezkghv3vonQUK8KYmVValF+fFFpTmpxYcYmTg4pRoYZ16y0otdWDg9+X7mYY7ab66H
	zcwuvnVvmHP83qEPl9yjlEqPCmYbqOfKnL6SsOXisrCuX3Ymx/te1UhtENJcECOelxX5a+N7
	p43e2sLyjkvMOIP9HRg3/zc2Ei06+67rxO81x0pjkg6d0y/95zEr4MPmh6u38KruKZqqaXXp
	7q6spW5rBOyfKrEUZyQaajEXFScCAGmLjh9YAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Thomas,
could you please comment John's question (see bellow) regarding flags.

On 01/21/2014 11:12 PM, John Stultz wrote:
> On 01/13/2014 02:43 AM, Alexey Perevalov wrote:
>> Hello dear community.
>>
>> This is reworked patch set of original Anton's Vorontsov
>> proposal regarding unified deferrable timers in the user space.
>> http://lwn.net/Articles/514707/
>>
>>
>> I decided to resubmit it due we found it usefull for us too.
>>
>> timerfd was modified since Anton's commit, Alarm support was added.
>> This isn't only rebase. Anton's previous version used deferrable timer
>> in couple with hrtimer. This version uses only deferrable timer. It
>> mean the behaviour of overrun number is different.
>> e.g. if you don't poll one second timer for a 10 seconds - you'll get
>> 10 overruns with hrtimer, but for deferrable timer it could be another value.
>>
> Sorry, last week was a little crazy and I didn't get a chance to closely
> review this. But looking at this my major conceptual objection with the
> previous patchset (introducing the new clockid) is gone.
>
> My remaining conceptual concern here is that the TIMER_DEFERRABLE flag
> is a timerfd only construct here, and I worry we should make sure we
> think this through well enough that the same functionality can be
> supported via other timer interfaces (like clock_nanosleep, etc), which
> may mean the functionality should be pushed more deeply into the hrtimer
> subsystem.
>
> So main suggestion here is to make sure you cc Thomas Gleixner on future
> iterations, so he can provide some thoughts on what the best approach
> might be here. I know he also has some plans that might collide with the
> jiffies_to_ktime work.
>
> Thomas: Any thought here? Should we be trying to unify the timerfd flags
> and the posix timer flags (specifically things like TIMER_CANCEL_ON_SET,
> which is currently timerfd-only)?  Should a deferrable flag be added to
> the hrtimer core or left to the timer wheel?
>
> thanks
> -john
>


-- 
Best regards,
Alexey Perevalov
