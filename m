Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524AbaAaPhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:37:35 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:40665 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbaAaPhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:37:34 -0500
Message-ID: <52EBC33A.6080101@linaro.org>
Date: Fri, 31 Jan 2014 16:37:30 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>
CC: Preeti Murthy <preeti.lkml@gmail.com>, nicolas.pitre@linaro.org,
        mingo@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct
 rq
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org> <1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org> <20140130153150.GD5002@laptop.programming.kicks-ass.net> <52EA7D8A.6080604@linaro.org> <20140130163501.GG5002@laptop.programming.kicks-ass.net> <52EA8B07.6020206@linaro.org> <CAM4v1pPwmRUOtNeGh5sZmj+wAsC8RstofNA5Gx862SEECvW-Lg@mail.gmail.com> <20140131090230.GM5002@laptop.programming.kicks-ass.net> <52EB6F65.8050008@linux.vnet.ibm.com> <52EBBC23.8020603@linux.intel.com>
In-Reply-To: <52EBBC23.8020603@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 04:07 PM, Arjan van de Ven wrote:
>>>>
>>>> Hence I think this patch would make sense only with additional
>>>> information
>>>> like exit_latency or target_residency is present for the scheduler.
>>>> The idle
>>>> state index alone will not be sufficient.
>>>
>>> Alternatively, can we enforce sanity on the cpuidle infrastructure to
>>> make the index naturally ordered? If not, please explain why :-)
>>
>> The commit id 71abbbf856a0e70 says that there are SOCs which could have
>> their target_residency and exit_latency values change at runtime. This
>> commit thus removed the ordering of the idle states according to their
>> target_residency/exit_latency. Adding Len and Arjan to the CC.
>
> the ARM folks wanted a dynamic exit latency, so.... it makes much more
> sense
> to me to store the thing you want to use (exit latency) than the number
> of the state.
>
> more than that, you can order either by target residency OR by exit
> latency,
> if you sort by one, there is no guarantee that you're also sorted by the
> other

IMO, it would be preferable to store the index for the moment as we are 
integrating cpuidle with the scheduler. The index allows to access more 
informations. Then when everything is fully integrated we can improve 
the result, no ?

> (for example, you can on a hardware level make a "fast exit" state, and
> burn power for this faster exit,
> which means your break even gets longer to recoup this extra power
> compared to the same state without
> the fast exit)
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

