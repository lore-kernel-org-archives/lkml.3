Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbaEVMDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:03:05 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56937 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbaEVMDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:03:03 -0400
Message-ID: <537DE782.7040408@linaro.org>
Date: Thu, 22 May 2014 14:03:14 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Yang,Wei" <Wei.Yang@windriver.com>
CC: tglx@linutronix.de, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] drivers/clocksource: do not trace read_sched_clock
References: <1399950608-11873-1-git-send-email-Wei.Yang@windriver.com> <537D57CA.6000305@windriver.com>
In-Reply-To: <537D57CA.6000305@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 03:50 AM, Yang,Wei wrote:
> Hi Daniel,
>
> What do you think of it?
>
> Regards
> Wei
> On 05/13/2014 11:10 AM, Wei.Yang@windriver.com wrote:
>> From: Yang Wei <Wei.Yang@windriver.com>
>>
>> We do not need to trace read_sched_clock function,
>> so add notrace attribute for this function.

Hi Yang,

I agree with your patch. Applied in my tree for 3.16

Please in the future fix the subject name:

clocksource: [driver]: [A-Z]....

Thanks
   -- Daniel

>> Signed-off-by: Yang Wei <Wei.Yang@windriver.com>
>> ---
>>   drivers/clocksource/dw_apb_timer_of.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/clocksource/dw_apb_timer_of.c
>> b/drivers/clocksource/dw_apb_timer_of.c
>> index 2a2ea27..d305fb0 100644
>> --- a/drivers/clocksource/dw_apb_timer_of.c
>> +++ b/drivers/clocksource/dw_apb_timer_of.c
>> @@ -106,7 +106,7 @@ static void __init add_clocksource(struct
>> device_node *source_timer)
>>       sched_rate = rate;
>>   }
>> -static u64 read_sched_clock(void)
>> +static u64 notrace read_sched_clock(void)
>>   {
>>       return ~__raw_readl(sched_io_base);
>>   }
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

