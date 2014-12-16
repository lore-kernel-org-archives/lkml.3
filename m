Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199AbaLPL3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 06:29:15 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:39740 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaLPL3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 06:29:13 -0500
Message-ID: <54901788.7020307@linaro.org>
Date: Tue, 16 Dec 2014 12:29:12 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org, horms@verge.net.au, geert@linux-m68k.org,
        tglx@linutronix.de
Subject: Re: [PATCH] clocksource: sh_tmu: Set cpu_possible_mask to fix SMP
 broadcast
References: <20141216094854.22639.69181.sendpatchset@w520> <54901420.50403@linaro.org> <1418731028.WfBPmyK53y@avalon>
In-Reply-To: <1418731028.WfBPmyK53y@avalon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 12:20 PM, Laurent Pinchart wrote:
> Hi Daniel,
>
> On Tuesday 16 December 2014 12:14:40 Daniel Lezcano wrote:
>> On 12/16/2014 10:48 AM, Magnus Damm wrote:
>>> From: Magnus Damm <damm+renesas@opensource.se>
>>>
>>> Update the TMU driver to use cpu_possible_mask as cpumask to make
>>> r8a7779 SMP work as expected with or without the ARM TWD timer.
>>>
>>> Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
>>
>> Applied as a 3.18 fix.
>
> You're a bit too fast, I haven't had time to review the patch yet.

Ah, ok. Hanging on then :)

 >
>> ps: May I suggest to use the CLOCK_EVT_FEAT_DYNIRQ flag for this driver ?
>>
>>> ---
>>>
>>>    drivers/clocksource/sh_tmu.c |    2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> --- 0001/drivers/clocksource/sh_tmu.c
>>> +++ work/drivers/clocksource/sh_tmu.c	2014-12-16 17:49:49.000000000 +0900
>>> @@ -428,7 +428,7 @@ static void sh_tmu_register_clockevent(s
>>>
>>>    	ced->features = CLOCK_EVT_FEAT_PERIODIC;
>>>    	ced->features |= CLOCK_EVT_FEAT_ONESHOT;
>>>    	ced->rating = 200;
>>> -	ced->cpumask = cpumask_of(0);
>>> +	ced->cpumask = cpu_possible_mask;
>
> Magnus, how thoroughly have you tested this ? The TMU is indeed usable by all
> CPUs, so setting the CPU mask to cpu_possible_mask makes sense, but last time
> I've tried that it broke the broadcast timer due to the heuristics used by the
> clock events core code.
>
> Could you please confirm that you've tested both CONFIG_PREEMPT_NONE and
> CONFIG_PREEMPT with and without the ARM TWD times, and that you've booted to
> userspace and tested timer broadcast on all CPUs ?
>
>>>    	ced->set_next_event = sh_tmu_clock_event_next;
>>>    	ced->set_mode = sh_tmu_clock_event_mode;
>>>    	ced->suspend = sh_tmu_clock_event_suspend;
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

