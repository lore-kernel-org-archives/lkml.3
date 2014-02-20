Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaBTCTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 21:19:10 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:49993 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaBTCTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 21:19:08 -0500
Message-ID: <53056612.9070209@linux.vnet.ibm.com>
Date: Thu, 20 Feb 2014 10:18:58 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: fair: NULL ptr deref in check_preempt_wakeup
References: <52FFF7F8.2070801@oracle.com> <5301C41D.5000009@linux.vnet.ibm.com> <20140219161657.GO15586@twins.programming.kicks-ass.net>
In-Reply-To: <20140219161657.GO15586@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022002-5564-0000-0000-00000C1A5115
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 12:16 AM, Peter Zijlstra wrote:
[snip]
>>
>>
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 235cfa7..4445e56 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -7317,7 +7317,11 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
>>   */
>>  static void switched_to_fair(struct rq *rq, struct task_struct *p)
>>  {
>> -	if (!p->se.on_rq)
>> +	struct sched_entity *se = &p->se;
>> +#ifdef CONFIG_FAIR_GROUP_SCHED
>> +	se->depth = se->parent ? se->parent->depth + 1 : 0;
>> +#endif
>> +	if (!se->on_rq)
>>  		return;
>>  
>>  	/*
> 
> 
> Michael, do you think you can send a proper patch for this?

My pleasure :) will post it later.

Regards,
Michael Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

