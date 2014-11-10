Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaKJPP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:15:58 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:50656 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaKJPP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:15:56 -0500
Message-ID: <5460D6A6.9070501@linaro.org>
Date: Mon, 10 Nov 2014 16:15:50 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: rjw@rjwysocki.net, preeti@linux.vnet.ibm.com, nicolas.pitre@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org, lenb@kernel.org
Subject: Re: [PATCH V3 3/6] sched: idle: Get the next timer event and pass
 it the cpuidle framework
References: <1415370687-18688-1-git-send-email-daniel.lezcano@linaro.org> <1415370687-18688-4-git-send-email-daniel.lezcano@linaro.org> <20141110124353.GO3337@twins.programming.kicks-ass.net>
In-Reply-To: <20141110124353.GO3337@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 01:43 PM, Peter Zijlstra wrote:
> On Fri, Nov 07, 2014 at 03:31:24PM +0100, Daniel Lezcano wrote:
>>   static void cpu_idle_loop(void)
>>   {
>> -	unsigned int latency_req;
>> +	unsigned int latency_req, next_timer_event;
>>
>>   	while (1) {
>>   		/*
>> @@ -221,6 +222,9 @@ static void cpu_idle_loop(void)
>>
>>   			latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
>>
>> +			next_timer_event =
>> +				ktime_to_us(tick_nohz_get_sleep_length());
>> +
>>   			/*
>>   			 * In poll mode we reenable interrupts and spin.
>>   			 *
>> @@ -238,7 +242,8 @@ static void cpu_idle_loop(void)
>>   			    tick_check_broadcast_expired())
>>   				cpu_idle_poll();
>>   			else
>> -				cpuidle_idle_call(latency_req);
>> +				cpuidle_idle_call(latency_req,
>> +						  next_timer_event);
>>
>>   			arch_cpu_idle_exit();
>>   		}
>
> Why do we want to query the next timer in the poll case? Afaict the
> other patches don't make use of this either.

Well, the direction I am taking when writing those cleanups is to have 
something like:

"I will sleep X usec, I have Y usec latency constraints". Grouping the 
latency req and the next timer allows to stick to the next changes.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

