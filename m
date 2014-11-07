Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaKGJln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:41:43 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44741 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaKGJlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:41:40 -0500
Message-ID: <545C9244.6040508@linaro.org>
Date: Fri, 07 Nov 2014 10:35:00 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        patches@linaro.org
Subject: Re: [PATCH V2 1/5] sched: idle: cpuidle: Check the latency req before
 idle
References: <1414054881-17713-1-git-send-email-daniel.lezcano@linaro.org> <CAM4v1pOg1GFW82WD8b6Vas5xhYQrQtdP1STGxyzYtrBNSa+-Pw@mail.gmail.com> <544FE787.8090108@linaro.org> <54504A60.2090908@linux.vnet.ibm.com> <545A3414.7030500@linaro.org> <545AF424.2070302@linux.vnet.ibm.com> <545B7AAC.3020309@linaro.org> <545C4AA4.7010904@linux.vnet.ibm.com>
In-Reply-To: <545C4AA4.7010904@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 05:29 AM, Preeti U Murthy wrote:
> On 11/06/2014 07:12 PM, Daniel Lezcano wrote:
>>
>> Preeti,
>>
>> I am wondering if we aren't going to a false debate.
>>
>> If the latency_req is 0, we should just poll and not enter in any idle
>> state even if one has zero exit latency. With a zero latency req, we
>> want full reactivity on the system, not enter an idle state with all the
>> computation in the menu governor, no ?
>>
>> I agree this patch changes the behavior on PowerPC, but only if the
>> latency_req is set to zero. I don't think we are worried about power
>> saving when setting this value.
>>
>> Couldn't the patch accepted as it is for the sake of consistency on all
>> the platform and then we optimize cleanly for the special latency zero
>> case ?
>
> Alright Daniel, you can go ahead. I was thinking this patch through and
> now realize that, like you point out the logic will only get complicated
> with all the additional hack.
>
> But would it be possible to add the weak arch_cpu_idle_loop() call for
> the cases where latency requirement is 0 like you had suggested earlier
> ? This would ensure the polling logic does not break on PowerPC and we
> don't bother the governor even. I will add the function in the core
> PowerPC code. If arch does not define this function it will fall back to
> cpu_idle_loop(). Fair enough?

Yes, sounds good.

I will add the weak function as the first patch in the series.

Thanks for your reviews.

   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

