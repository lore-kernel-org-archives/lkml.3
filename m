Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaETU7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:59:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaETU7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:59:46 -0400
Message-ID: <537BC208.5030904@redhat.com>
Date: Tue, 20 May 2014 16:58:48 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>, Tim Chen <tim.c.chen@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>, Russ Anderson <rja@sgi.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Reduce the rate of needless idle load balancing
References: <1400617046.2970.270.camel@schen9-DESK> <CAGQ1y=5cwk+-Ztv8kXod+QexwEqQ0U6wPdMDBLL66rcF_cukLA@mail.gmail.com>
In-Reply-To: <CAGQ1y=5cwk+-Ztv8kXod+QexwEqQ0U6wPdMDBLL66rcF_cukLA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 04:51 PM, Jason Low wrote:
> On Tue, May 20, 2014 at 1:17 PM, Tim Chen <tim.c.chen@linux.intel.com> wrote:
> 
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 9b4c4f3..97132db 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -6764,12 +6764,17 @@ static void nohz_idle_balance(struct rq *this_rq, enum cpu_idle_type idle)
>>
>>                 rq = cpu_rq(balance_cpu);
>>
>> -               raw_spin_lock_irq(&rq->lock);
>> -               update_rq_clock(rq);
>> -               update_idle_cpu_load(rq);
>> -               raw_spin_unlock_irq(&rq->lock);
>> -
>> -               rebalance_domains(rq, CPU_IDLE);
>> +               /*
>> +                * If time for next balance is due,
>> +                * do the balance.
>> +                */
>> +               if (time_after(jiffies + 1, rq->next_balance)) {
> 
> Hi Tim,
> 
> If we want to do idle load balancing only when it is due for a
> balance, shouldn't the above just be "if (time_after(jiffies,
> rq->next_balance))"?

I was wondering the same.

Everything else gets my

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
