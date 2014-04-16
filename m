Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbaDPKvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:51:23 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:31152 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755359AbaDPKvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:51:20 -0400
X-IronPort-AV: E=Sophos;i="4.97,871,1389715200"; 
   d="scan'208";a="29339231"
Message-ID: <534E52B7.7070002@cn.fujitsu.com>
Date: Wed, 16 Apr 2014 18:51:51 +0900
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <acme@ghostprotocols.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] sched/wait: Use __add_wait_queue{_tail}_exclusive()
 as possible.
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com> <c232d92d5d70daf9b2c58486dc5a182f95edd951.1397562542.git.yangds.fnst@cn.fujitsu.com> <20140415134949.GU11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140415134949.GU11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 10:49 PM, Peter Zijlstra wrote:
> On Tue, Apr 15, 2014 at 09:32:52PM +0900, Dongsheng Yang wrote:
>> From: Dongsheng <yangds.fnst@cn.fujitsu.com>
>>
>> There is already a function in include/linux/wait.h to cover the
>> 'exclusive' usage. So we can use it in sched/wait.c to replace
>> the opened implementation of it.
>>
>> Signed-off-by: Dongsheng <yangds.fnst@cn.fujitsu.com>
>> ---
>>   kernel/sched/wait.c | 6 ++----
>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
>> index 283750e..b04827e 100644
>> --- a/kernel/sched/wait.c
>> +++ b/kernel/sched/wait.c
>> @@ -38,9 +38,8 @@ void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait)
>>   	unsigned long flags;
>>   
>>   	trace_sched_wait(current);
>> -	wait->flags |= WQ_FLAG_EXCLUSIVE;
>>   	spin_lock_irqsave(&q->lock, flags);
>> -	__add_wait_queue_tail(q, wait);
>> +	__add_wait_queue_tail_exclusive(q, wait);
>>   	spin_unlock_irqrestore(&q->lock, flags);
>>   }
>>   EXPORT_SYMBOL(add_wait_queue_exclusive);
>> @@ -192,10 +191,9 @@ prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
>>   	unsigned long flags;
>>   
>>   	trace_sched_wait(current);
>> -	wait->flags |= WQ_FLAG_EXCLUSIVE;
>>   	spin_lock_irqsave(&q->lock, flags);
>>   	if (list_empty(&wait->task_list))
>> -		__add_wait_queue_tail(q, wait);
>> +		__add_wait_queue_tail_exclusive(q, wait);
>>   	set_current_state(state);
>>   	spin_unlock_irqrestore(&q->lock, flags);
> That is not a no-op, if !list_empty() we loose the WQ_flag

Oh, yes, my mistake. Thanx
> .
>

