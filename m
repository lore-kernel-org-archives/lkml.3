Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaBPPU5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 10:20:57 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19776 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbaBPPUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 10:20:55 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-04-5300d75454dd
Message-id: <5300D752.5030403@samsung.com>
Date: Sun, 16 Feb 2014 19:20:50 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        anton@enomsg.org, kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
 <52DEC6A3.9020600@linaro.org> <52E606D8.6000401@samsung.com>
 <alpine.DEB.2.02.1402041419420.24986@ionos.tec.linutronix.de>
 <52F1DDA8.90605@samsung.com>
 <alpine.DEB.2.02.1402051229260.24986@ionos.tec.linutronix.de>
 <52F2B504.5010403@linaro.org>
 <alpine.DEB.2.02.1402052306580.24986@ionos.tec.linutronix.de>
 <52F3C8A5.708@samsung.com>
 <alpine.DEB.2.02.1402062148440.21991@ionos.tec.linutronix.de>
In-reply-to: <alpine.DEB.2.02.1402062148440.21991@ionos.tec.linutronix.de>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xq7oh1xmCDS6+sLCYs34Nm8XBrZoW
	1788Z7U481vX4mzTG3aLy7vmsFls3jSV2YHdY0L/J0aPO9f2sHm8O3eO3ePEjN8sHn1bVjF6
	fN4kF8AWxWWTkpqTWZZapG+XwJVx/dhM1oJf4hUHjk1mamC8LNzFyMkhIWAiMfvbYiYIW0zi
	wr31bF2MXBxCAksZJZ5ue8EC4XxmlOjf+IoNpIpXQEuib/ZZRhCbRUBV4u+tTuYuRg4ONgED
	iX33bEFMUYEIiaPLNSGqBSV+TL7HAmKLCGhIbLx0ixlkJLPASkaJud/+sIMkhAVcJU5sX88K
	sesRs8Sh/vVguzgFvCQ6Dq1jBrGZBawlVk7axghhy0tsXvOWeQKjwCwkS2YhKZuFpGwBI/Mq
	RtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJBg/7KDcfExq0OMAhyMSjy8CY//BwmxJpYVV+Ye
	YpTgYFYS4S3YwBAsxJuSWFmVWpQfX1Sak1p8iJGJg1OqgTHfU7lBcHbglQ0TZ9hvcnx8qyiq
	n3EW9+W/r6sub/3qkH4p9edk4+v/NV+4y0+6IJWRltDHJ7KatSlGd+r2F0H3zRt5yjfrfimc
	Ib3Sbaf4HJsAUZZTgcfm+vzZvaTFM0iu57lMrH+P/vxWrf791by3Iy9yr7m4ZnaDceXfiiVL
	WW3f37Gp81FiKc5INNRiLipOBAA6XR95VAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 12:50 AM, Thomas Gleixner wrote:
> On Thu, 6 Feb 2014, Alexey Perevalov wrote:
>> On 02/06/2014 02:16 AM, Thomas Gleixner wrote:
>> As I truly understand, you decided - flags is better than new clockids, and
>> internals of timerfd could be a mix of timer_list and hrtimer.
> NO, NO, NO, NO. There is no mix of timer_list and hrtimer. Either we
> add proper deferrable support to hrtimers or the whole thing is not
> going to happen at all. There is no way that we bring back timer_list
> to user space interfaces. Period.
>
> Thanks,
>
> 	tglx
>
>
>
Hello Thomas,
I checked you patch on system with CONFIG_HZ=250,
Here is result for hrtimer with 200ms interval
[291943.009557] time delta 209518762
[291943.205546] time delta 195995131
[291943.403012] time delta 197466387
[291943.610090] time delta 207071848
[291943.816138] time delta 206054438
[291944.000063] time delta 183918221
[291944.209290] time delta 209234301
[291944.405104] time delta 195813256
[291944.601507] time delta 196396567
[291944.816090] time delta 214589122
[291945.000125] time delta 184034925
[291945.214207] time delta 214075670

Maximum delay is 14 ms, but sometimes timer function is called early.

On the same system deferrable timer_list looks like:
[292214.336130] time delta 248064082
[292214.548061] time delta 211932930
[292214.804028] time delta 255964215
[292215.080160] time delta 276133570
[292215.328212] time delta 248043192
[292215.576241] time delta 248043616
[292215.796066] time delta 219818102
[292216.004040] time delta 207973662
[292216.260111] time delta 256069522
[292216.568160] time delta 308049741
[292216.816120] time delta 247962559
[292217.028062] time delta 211941369
[292217.264078] time delta 236013934

Maximum delay is 108 ms. And it looks like more predictable.

After I changed CONFIG_HZ=200,
hrtimer charged for 200ms had shown following result:

[  187.548009] time delta 200360371
[  187.724141] time delta 176132213
[  187.826221] time delta 102085975
[  188.008010] time delta 181788726
[  188.312062] time delta 304051846
[  188.705480] time delta 393417803
[  188.800070] time delta 94583497
[  189.000125] time delta 200055104
[  189.224055] time delta 223937438
[  189.400065] time delta 176009338
[  189.672916] time delta 272851573
[  189.828029] time delta 155112014
[  190.000047] time delta 172018578

Now it has maximum delay 193 ms (393417803), but in other times it 
triggers early.
Normal deferrable timer behaves as expected (time delta is 200ms).
These examples were made with MONOTONIC timers.

As I understand main idea in hrtimer.c was do not decrement expires_next 
in case of DEFERRABLE timers type.
Such small average delay could be explained: it's due higher resolution, 
and cpu is not in idle when we in hrtimer_interrupt,
with timer_list decrementing process not so often.
In this case it's hard to me to explain such small "time delta", it 
occurs almost every time we have larger delay.

-- 
Best regards,
Alexey Perevalov
