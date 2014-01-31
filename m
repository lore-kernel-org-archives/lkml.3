Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbaAaOEk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:04:40 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:50920 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbaAaOEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:04:39 -0500
Message-ID: <52EBAD70.6040303@linaro.org>
Date: Fri, 31 Jan 2014 15:04:32 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Len Brown <len.brown@intel.com>
CC: Preeti Murthy <preeti.lkml@gmail.com>, nicolas.pitre@linaro.org,
        mingo@redhat.com, Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC PATCH 3/3] idle: store the idle state index in the struct
 rq
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org> <1391090962-15032-4-git-send-email-daniel.lezcano@linaro.org> <20140130153150.GD5002@laptop.programming.kicks-ass.net> <52EA7D8A.6080604@linaro.org> <20140130163501.GG5002@laptop.programming.kicks-ass.net> <52EA8B07.6020206@linaro.org> <CAM4v1pPwmRUOtNeGh5sZmj+wAsC8RstofNA5Gx862SEECvW-Lg@mail.gmail.com> <20140131090230.GM5002@laptop.programming.kicks-ass.net> <52EB6F65.8050008@linux.vnet.ibm.com>
In-Reply-To: <52EB6F65.8050008@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 10:39 AM, Preeti U Murthy wrote:
> Hi Peter,
>
> On 01/31/2014 02:32 PM, Peter Zijlstra wrote:
>> On Fri, Jan 31, 2014 at 02:15:47PM +0530, Preeti Murthy wrote:
>>>>
>>>> If the driver does its own random mapping that will break the governor
>>>> logic. So yes, the states are ordered, the higher the index is, the more you
>>>> save power and the higher the exit latency is.
>>>
>>> The above point holds true for only the ladder governor which sees the idle
>>> states indexed in the increasing order of target_residency/exit_latency.
>>>
>>> However this is not true as far as I can see in the menu governor. It
>>> acknowledges the dynamic ordering of idle states as can be seen in the
>>> menu_select() function in the menu governor, where the idle state for the
>>> CPU gets chosen.  You will notice that, even if it is found that the predicted
>>> idle time of the CPU is smaller than the target residency of an idle state,
>>> the governor continues to search for suitable idle states in the higher indexed
>>> states although it should have halted if the idle states' were ordered according
>>> to their target residency.. The same holds for exit_latency.
>>>
>>> Hence I think this patch would make sense only with additional information
>>> like exit_latency or target_residency is present for the scheduler. The idle
>>> state index alone will not be sufficient.
>>
>> Alternatively, can we enforce sanity on the cpuidle infrastructure to
>> make the index naturally ordered? If not, please explain why :-)
>
> The commit id 71abbbf856a0e70 says that there are SOCs which could have
> their target_residency and exit_latency values change at runtime. This
> commit thus removed the ordering of the idle states according to their
> target_residency/exit_latency. Adding Len and Arjan to the CC.

This commit is outdated, AFAICT.

Indeed, there are dynamic idle states. Some idle states are added or 
removed when a laptop is going to battery or plugged in.

In ACPI, the power event leads the acpi cpuidle driver to disable the 
cpuidle framework, get the idle states which are ordered, and re-enable 
the cpuidle framework which in turn kicks all the cpus. So the index in 
the struct rq should be always ok.




-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

