Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbaBFRrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 12:47:21 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:34306 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaBFRrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 12:47:17 -0500
Message-ID: <52F3CAA2.3070705@linaro.org>
Date: Thu, 06 Feb 2014 09:47:14 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexey Perevalov <a.perevalov@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, anton@enomsg.org, kyungmin.park@samsung.com,
        akpm@linux-foundation.org, cw00.choi@samsung.com
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com> <52DEC6A3.9020600@linaro.org> <52E606D8.6000401@samsung.com> <alpine.DEB.2.02.1402041419420.24986@ionos.tec.linutronix.de> <52F1DDA8.90605@samsung.com> <alpine.DEB.2.02.1402051229260.24986@ionos.tec.linutronix.de> <52F2B504.5010403@linaro.org> <alpine.DEB.2.02.1402052306580.24986@ionos.tec.linutronix.de> <52F3C8A5.708@samsung.com>
In-Reply-To: <52F3C8A5.708@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 09:38 AM, Alexey Perevalov wrote:
> On 02/06/2014 02:16 AM, Thomas Gleixner wrote:
>> On Wed, 5 Feb 2014, John Stultz wrote: 
>>> My reasoning was that the deferrablity isn't a clock domain, and is
>>> more
>>> of a modifier. Thus to keep the interfaces somewhat sane (and avoiding
>>> having to add N new clockids for each new modifier), we should utilize
>>> the flag arguments to timers. So instead of just having TIMER_ABSTIME,
>>> we could add TIMER_DEFER, etc, which we could utilize instead.
>> I can see the point. I have no objections against that approach as
>> long as we map that against separate internal bases.
>>  
>>> Internally we can still keep separate bases, much as your patch
>>> does, to
>>> keep the next-event searching overhead more limited.
>> It's not only more limited, it's bound.
>>  
>>> I mainly wanted to get your thoughts on extending the flags, and doing
>>> so in a consistent manner between the timerfd and other timer
>>> interfaces.
>> So the only interface which does not support that is sys_nanosleep()
>> but that's not really an issue. sys_nanosleep() should die anyway :)
>>
>>> Of course, all this is after I added the _ALARM clockids... so you can
>>> decide if its hypocrisy or experience.
>>> (The "old wisdom comes from experience and experience comes from bad
>>> decisions" bit ;).
>> Well, you have a valid point about the clock ids. I did not realize in
>> the first place that we can avoid that business if we use the flags to
>> select the internal representation.
>>
>> Either way is preferred over reintroducing the timer wheel mess....
>
> As I truly understand, you decided - flags is better than new
> clockids, and internals of timerfd could be a mix of timer_list and
> hrtimer.
> If so, it's in v2 patch set.

So, I think Thomas is suggesting we add new deferrable HRTIMER bases,
then the timerfd code would only use the hrtimers for non-alarm-timers.
We would then use the flag from the interface to decide internally which
base to add the hrtimer to. This would also allow us to use the flag via
non-timerfd interfaces to get the same result.

Does that clarify things?

thanks
-john




