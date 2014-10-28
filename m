Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbaJ1SCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:02:07 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:42671 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbaJ1SCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:02:04 -0400
Message-ID: <544FDA19.4070705@linaro.org>
Date: Tue, 28 Oct 2014 19:02:01 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Preeti Murthy <preeti.lkml@gmail.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/5] sched: idle: Get the next timer event and pass it
 the cpuidle framework
References: <1413822343-1972-1-git-send-email-daniel.lezcano@linaro.org>	<1413822343-1972-2-git-send-email-daniel.lezcano@linaro.org> <CAM4v1pOzC2riePt4sfsdG=SLYvZmhMc4KgT-hfq6XkjF2Mce7g@mail.gmail.com>
In-Reply-To: <CAM4v1pOzC2riePt4sfsdG=SLYvZmhMc4KgT-hfq6XkjF2Mce7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 07:40 AM, Preeti Murthy wrote:
> Hi Daniel,
>
> On Mon, Oct 20, 2014 at 9:55 PM, Daniel Lezcano
> <daniel.lezcano@linaro.org> wrote:
>> Following the logic of the previous patch, retrieve from the idle task the
>> expected timer sleep duration and pass it to the cpuidle framework.
>>
>> Take the opportunity to remove the unused headers in the menu.c file.
>>
>> This patch does not change the current behavior.
>>
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> ---
>>   drivers/cpuidle/cpuidle.c          | 11 +++++------
>>   drivers/cpuidle/governors/ladder.c |  3 ++-
>>   drivers/cpuidle/governors/menu.c   |  8 ++------
>>   include/linux/cpuidle.h            |  8 +++++---
>>   kernel/sched/idle.c                | 16 ++++++++++++----
>>   5 files changed, 26 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
>> index 372c36f..64f5800 100644
>> --- a/drivers/cpuidle/cpuidle.c
>> +++ b/drivers/cpuidle/cpuidle.c
>> @@ -8,16 +8,12 @@
>>    * This code is licenced under the GPL.
>>    */
>>
>> -#include <linux/clockchips.h>
>>   #include <linux/kernel.h>
>>   #include <linux/mutex.h>
>> -#include <linux/sched.h>
>>   #include <linux/notifier.h>
>>   #include <linux/pm_qos.h>
>>   #include <linux/cpu.h>
>>   #include <linux/cpuidle.h>
>> -#include <linux/ktime.h>
>> -#include <linux/hrtimer.h>
>>   #include <linux/module.h>
>>   #include <trace/events/power.h>
>>
>> @@ -155,11 +151,13 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
>>    *
>>    * @drv: the cpuidle driver
>>    * @dev: the cpuidle device
>> + * @latency_req: the latency constraint when choosing an idle state
>
> You might want to include this change in the previous patch itself.

Ah, yes. Thanks.

>> + * @next_timer_event: the duration until the timer expires
>>    *
>>    * Returns the index of the idle state.
>>    */
>
> Regards
> Preeti U Murthy
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

