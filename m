Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3FFCW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 22:22:58 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:47322 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab3FFCW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 22:22:57 -0400
Message-ID: <51AFF279.2070104@linux.vnet.ibm.com>
Date: Thu, 06 Jun 2013 10:22:49 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/3] sched: code refine in unthrottle_cfs_rq()
References: <51AD87A8.6080608@linux.vnet.ibm.com> <51AD87EB.1070605@linux.vnet.ibm.com> <20130605111544.GA8923@twins.programming.kicks-ass.net>
In-Reply-To: <20130605111544.GA8923@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060602-8878-0000-0000-0000076A9C2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 07:15 PM, Peter Zijlstra wrote:
> On Tue, Jun 04, 2013 at 02:23:39PM +0800, Michael Wang wrote:
>> Directly use rq to save some code.
>>
>> CC: Ingo Molnar <mingo@kernel.org>
>> CC: Peter Zijlstra <peterz@infradead.org>
>> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> 
> Please send patches against tip/master; the below didn't apply cleanly.
> It was a trivial conflict so I applied force and made it fit.

My sincere apologies on that, please allow me to resend the accepted
patches based on latest tip/master, forgive me for create extra work
like that...

Regards,
Michael Wang

> 
> Thanks!
> 
>> ---
>>  kernel/sched/fair.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index c61a614..1e10911 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -2298,7 +2298,7 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
>>  	int enqueue = 1;
>>  	long task_delta;
>>  
>> -	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
>> +	se = cfs_rq->tg->se[cpu_of(rq)];
>>  
>>  	cfs_rq->throttled = 0;
>>  	raw_spin_lock(&cfs_b->lock);
>> -- 
>> 1.7.4.1
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

