Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaBRC1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:27:09 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:51128 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaBRC1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:27:06 -0500
Message-ID: <5302C4F1.3020907@linux.vnet.ibm.com>
Date: Tue, 18 Feb 2014 10:26:57 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched: fair: NULL ptr deref in check_preempt_wakeup
References: <52FFF7F8.2070801@oracle.com> <5301C41D.5000009@linux.vnet.ibm.com> <20140217092055.GP27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140217092055.GP27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021802-5564-0000-0000-00000C10CDED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2014 05:20 PM, Peter Zijlstra wrote:
[snip]
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
> Yes indeed. My first idea yesterday was to put it in set_task_rq() to be
> absolutely sure we catch all; but if this is sufficient its better.

Agree, let's wait for Sasha's testing result then :)

Regards,
Michael Wang

> 
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

