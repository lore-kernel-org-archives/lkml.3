Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaDYRB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:01:29 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:45730 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbaDYRB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:01:26 -0400
Message-ID: <535A94E3.5080004@linaro.org>
Date: Fri, 25 Apr 2014 19:01:23 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Amit Kucheria <amit.kucheria@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched: idle: Add sched balance option
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org> <535911DC.9050109@linaro.org> <CAP245DXFRfARtEfj70XD8D8OiAT_1i_5G2zao+y0DT0Lg_YFJA@mail.gmail.com> <2713863.BLQTYQm2Oa@vostro.rjw.lan> <20140425132055.GC11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140425132055.GC11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 03:20 PM, Peter Zijlstra wrote:
> On Fri, Apr 25, 2014 at 01:46:53PM +0200, Rafael J. Wysocki wrote:
>
> _trim_ emails!!! one of these days I'm going to write a bot to flame
> your head of if there's excessive quoting.
>
>>> I had a offline conversation with Daniel about this since there are
>>> other triggers - thermal constraints and game-like apps being examples
>>> - that might want to override the system policy. He intended
>>> "performance" mode to mean the existing code paths and "power" mode to
>>> mean *additional* new heuristics for energy-efficiency. The power
>>> supply assumption is just the first one of those heuristics.
>>
>> Well, so now the question is whether or not we relly want to always
>> go to the "power" (or "energy efficiency" if you will) mode if the system
>> is on battery.  That arguably may not be a good thing even for energy
>> efficiency depending on how exactly the modes are defined.
>
> Nobody is talking about always. But in general it seems a good enough
> approach. Hell, many of the AC/BAT switches in todays power management
> crap things are not always right.
>
> Do I want it to dim the LCD further when I unplug the laptop -- mostly
> no, but still it does. And the most annoying one is that it reduces the
> screen blank time to something near 5 seconds or so.
>
> Why would this be any different? If you know what you want you can turn
> the knob.
>
>> So in my opinion it's too early to add things like that at this point.
>
> Meh..
>

Peter,

I assume the patchset is correct for you (modulo the few comments about 
code), right ?

As the sysctl is some kind of ABI, I would like to make sure we reach a 
consensus and discuss a bit about that.

I understand Rafael and Amit could be reluctant with the power supply to 
be hardcoded. As mentioned Amit, we may want to switch to 'power' if the 
thermal framework tells us we are reaching a threshold. For example, the 
system is set to 'auto', we are on battery, thus the current policy is 
'power', we plug the device, the current policy will switch to 
'performance' but the thermal framework may want to do 'power' because 
of some thermal constraint.

IMO, the power supply part could be extended to take into account the 
thermal.

The other point is, I guess, what should do the 'power' policy ? pack 
tasks or not ? Override the cpuidle governor and choose the deeper idle 
states or not ? etc ... So in other words, how can we put a cursor 
between 'performance' and 'power'. Knowing on some platform one may be 
more efficient than another platform.

IIUC, 'performance' for you means 'max performance' and 'power' means 
'max power', and a list of sysctl for each power/performance option give 
us the knobs to tune one or another policy ? (Each platform defining its 
own options)

Would this approach be ok ?

Thanks

   -- Daniel







-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

