Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbaJUMOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:14:38 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:38192 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbaJUMOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:14:37 -0400
Message-ID: <54464E10.8060604@gmail.com>
Date: Tue, 21 Oct 2014 20:14:08 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: Kirill V Tkhai <tkhai@yandex.ru>, Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND v2] sched/deadline: do not try to push tasks if
 pinned task switches to dl
References: <1412989095-7507-1-git-send-email-wanpeng.li@linux.intel.com> <5446316B.4070707@arm.com>
In-Reply-To: <5446316B.4070707@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


于 10/21/14, 6:11 PM, Juri Lelli 写道:
> Hi,
>
> On 11/10/14 01:58, Wanpeng Li wrote:
>> As Kirill mentioned(https://lkml.org/lkml/2013/1/29/118):
>> | If rq has already had 2 or more pushable tasks and we try to add a
>> | pinned task then call of push_rt_task will just waste a time.
>>
>> Just switched pinned task is not able to be pushed. If the rq had had
>                                                                   ^
>                                                                  has
>> several dl tasks before they have already been considered as candidates
>> to be pushed (or pulled). This patch done the same behavior as rt class
>                                          ^
>                                      implements? aligns to...
>
>> which introduced by commit 10447917551e ("sched/rt: Do not try to push
>> tasks if pinned task switches to RT").
>>
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>> ---
>> v1 -> v2:
>>   * use 12 or more chars for the git commit ID
>>
>>   kernel/sched/deadline.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>> index abfaf3d..cf7c9b6 100644
>> --- a/kernel/sched/deadline.c
>> +++ b/kernel/sched/deadline.c
>> @@ -1603,7 +1603,8 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
>>   
>>   	if (task_on_rq_queued(p) && rq->curr != p) {
>>   #ifdef CONFIG_SMP
>> -		if (rq->dl.overloaded && push_dl_task(rq) && rq != task_rq(p))
>> +		if (p->nr_cpus_allowed > 1 && rq->dl.overloaded
>> +				&& push_dl_task(rq) && rq != task_rq(p))
> I'd personally align this && to p->nr_cpus_allowed, but that's just my
> personal taste, though. :)

Ah, ok, I will send out a newer version tomorrow. ;-)

Regards,
Wanpeng Li

>
>>   			/* Only reschedule if pushing failed */
>>   			check_resched = 0;
>>   #endif /* CONFIG_SMP */
>>
> Anyway, the change looks good, thanks!
>
> Best,
>
> - Juri
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

