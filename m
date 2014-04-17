Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbaDQFmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 01:42:55 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58939 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaDQFmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 01:42:54 -0400
Message-ID: <534F69D8.40605@linaro.org>
Date: Thu, 17 Apr 2014 13:42:48 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, efault@gmx.de, chris.redpath@arm.com,
        wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] sched: let task migration destination cpu do active
 balance
References: <1397648069-6462-1-git-send-email-alex.shi@linaro.org> <20140416121329.GO26782@laptop.programming.kicks-ass.net>
In-Reply-To: <20140416121329.GO26782@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 08:13 PM, Peter Zijlstra wrote:
> On Wed, Apr 16, 2014 at 07:34:29PM +0800, Alex Shi wrote:
>> Chris Redpath found an issue on active balance: 
>> We let the task source cpu, the busiest cpu, do the active balance,
>> while the destination cpu maybe idle. thus we take the busiest cpu
>> time, but left the idlest cpu wait. That is not good for performance.
>>
>> This patch let the destination cpu do active balance. It will give tasks
>> more running time.
>>
>> Signed-off-by: Alex Shi <alex.shi@linaro.org>
>> ---
>>  kernel/sched/fair.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 9b4c4f3..cccee76 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -6308,7 +6308,7 @@ more_balance:
>>  			raw_spin_unlock_irqrestore(&busiest->lock, flags);
>>  
>>  			if (active_balance) {
>> -				stop_one_cpu_nowait(cpu_of(busiest),
>> +				stop_one_cpu_nowait(busiest->push_cpu,
>>  					active_load_balance_cpu_stop, busiest,
>>  					&busiest->active_balance_work);
>>  			}
> 
> This doesn't make sense, the whole point of active balance is that we're
> going to move current, for that to work we have to interrupt the CPU
> current is running on and make sure another task (the stopper task in
> this case) is running, so that the previous current is now a !running
> task and we can move it around.
> 

Sure, you are right. thanks for correction!

-- 
Thanks
    Alex
