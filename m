Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaKEVlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:41:13 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:41300 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaKEVlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:41:10 -0500
Message-ID: <545A996C.6030606@linaro.org>
Date: Wed, 05 Nov 2014 22:41:00 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: nicolas.pitre@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH V2 1/5] sched: idle: cpuidle: Check the latency req before
 idle
References: <1414054881-17713-1-git-send-email-daniel.lezcano@linaro.org> <1637800.Fp0noCplzq@vostro.rjw.lan>
In-Reply-To: <1637800.Fp0noCplzq@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 10:57 PM, Rafael J. Wysocki wrote:
> On Thursday, October 23, 2014 11:01:17 AM Daniel Lezcano wrote:
>> When the pmqos latency requirement is set to zero that means "poll in all the
>> cases".
>>
>> That is correctly implemented on x86 but not on the other archs.
>>
>> As how is written the code, if the latency request is zero, the governor will
>> return zero, so corresponding, for x86, to the poll function, but for the
>> others arch the default idle function. For example, on ARM this is wait-for-
>> interrupt with a latency of '1', so violating the constraint.
>>
>> In order to fix that, do the latency requirement check *before* calling the
>> cpuidle framework in order to jump to the poll function without entering
>> cpuidle. That has several benefits:
>>
>>   1. It clarifies and unifies the code
>>   2. It fixes x86 vs other archs behavior
>>   3. Factors out the call to the same function
>>   4. Prevent to enter the cpuidle framework with its expensive cost in
>>      calculation
>>
>> As the latency_req is needed in all the cases, change the select API to take
>> the latency_req as parameter in case it is not equal to zero.
>>
>> As a positive side effect, it introduces the latency constraint specified
>> externally, so one more step to the cpuidle/scheduler integration.
>
> I'm expecting to see a new version of this patchset relatively soon.
>
> Are you planning to send one?

I would like to find an agreement with Preeti. But, yes, I am on it.

   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

