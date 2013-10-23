Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab3JWClD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 22:41:03 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:33669 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab3JWClA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 22:41:00 -0400
Message-ID: <52673735.3020809@linux.vnet.ibm.com>
Date: Wed, 23 Oct 2013 10:40:53 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [sched] WARNING: CPU: 0 PID: 3166 at kernel/cpu.c:84 put_online_cpus()
References: <20131019005129.GA5979@localhost> <52649F5E.2080303@linux.vnet.ibm.com> <20131022204659.GE2490@laptop.programming.kicks-ass.net>
In-Reply-To: <20131022204659.GE2490@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102302-2674-0000-0000-00000B2DF475
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2013 04:46 AM, Peter Zijlstra wrote:
> On Mon, Oct 21, 2013 at 11:28:30AM +0800, Michael wang wrote:
>> Hi, Fengguang
>>
>> On 10/19/2013 08:51 AM, Fengguang Wu wrote:
>>> Greetings,
>>
>> Will this do any helps?
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index c06b8d3..7c61f31 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -3716,7 +3716,6 @@ long sched_setaffinity(pid_t pid, const struct
>> cpumask *in_mask)
>>         p = find_process_by_pid(pid);
>>         if (!p) {
>>                 rcu_read_unlock();
>> -               put_online_cpus();
>>                 return -ESRCH;
>>         }
> 
> Just so..

Yeah... anyway, will send out a formal patch later :)

Regards,
Michael Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

