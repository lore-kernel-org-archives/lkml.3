Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbaA3RZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:25:28 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:46465 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbaA3RZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:25:27 -0500
Message-ID: <52EA8B07.6020206@linaro.org>
Date: Thu, 30 Jan 2014 18:25:27 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: nicolas.pitre@linaro.org, mingo@redhat.com, tglx@linutronix.de,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct
 rq
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org> <1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org> <20140130153150.GD5002@laptop.programming.kicks-ass.net> <52EA7D8A.6080604@linaro.org> <20140130163501.GG5002@laptop.programming.kicks-ass.net>
In-Reply-To: <20140130163501.GG5002@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 05:35 PM, Peter Zijlstra wrote:
> On Thu, Jan 30, 2014 at 05:27:54PM +0100, Daniel Lezcano wrote:
>> struct cpuidle_state *state = &drv->states[rq->index];
>>
>> And from the state, we have the following informations:
>>
>> struct cpuidle_state {
>>
>> 	[ ... ]
>>
>>          unsigned int    exit_latency; /* in US */
>>          int             power_usage; /* in mW */
>>          unsigned int    target_residency; /* in US */
>>          bool            disabled; /* disabled on all CPUs */
>>
>> 	[ ... ]
>> };
>
> Right, but can we say that a higher index will save more power and have
> a higher exit latency? Or is a driver free to have a random mapping from
> idle_index to state?

If the driver does its own random mapping that will break the governor 
logic. So yes, the states are ordered, the higher the index is, the more 
you save power and the higher the exit latency is.

> Also, we should probably create a pretty function to get that state,
> just like you did in patch 1.

Yes, right.

>> IIRC, Alex Shi sent a patchset to improve the choosing of the idlest cpu and
>> the exit_latency was needed.
>
> Right. However if we have a 'natural' order in the state array the index
> itself might often be sufficient to find the least idle state, in this
> specific case the absolute exit latency doesn't matter, all we want is
> the lowest one.

Indeed. It could be simple as that. I feel we may need more informations 
in the future but comparing the indexes could be a nice simple and 
efficient solution.

> Not dereferencing the state array saves hitting cold cachelines.

Yeah, always good to remind that. Should keep in mind for later.

Thanks for your comments.

   -- Daniel



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

