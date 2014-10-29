Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbaJ2WwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:52:25 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42017 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbaJ2WwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:52:24 -0400
Message-ID: <54516FA2.5000101@gmail.com>
Date: Thu, 30 Oct 2014 06:52:18 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
Subject: Re: [PATCH 3/6] sched/dl: add deadline rq status print
References: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com> <1414374067-7209-3-git-send-email-wanpeng.li@linux.intel.com> <54511B5D.1030208@arm.com>
In-Reply-To: <54511B5D.1030208@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juri,
2014/10/30 0:52, Juri Lelli:
> Hi,
>
> On 27/10/14 01:41, Wanpeng Li wrote:
>> This patch add deadline rq status print.
>>
> Don't know if useful, but we could add this, just to be consistent.

Yes, to keep it consistent. Maybe more things can be print if they are 
necessary in the future.

Regards,
Wanpeng Li

>
> Thanks,
>
> - Juri
>
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>> ---
>>   kernel/sched/deadline.c | 9 +++++++++
>>   kernel/sched/debug.c    | 7 +++++++
>>   kernel/sched/sched.h    | 1 +
>>   3 files changed, 17 insertions(+)
>>
>> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>> index d4ffc1e..aa7c27f 100644
>> --- a/kernel/sched/deadline.c
>> +++ b/kernel/sched/deadline.c
>> @@ -1682,3 +1682,12 @@ const struct sched_class dl_sched_class = {
>>   	.switched_from		= switched_from_dl,
>>   	.switched_to		= switched_to_dl,
>>   };
>> +
>> +#ifdef CONFIG_SCHED_DEBUG
>> +extern void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq);
>> +
>> +void print_dl_stats(struct seq_file *m, int cpu)
>> +{
>> +	print_dl_rq(m, cpu, &cpu_rq(cpu)->dl);
>> +}
>> +#endif /* CONFIG_SCHED_DEBUG */
>> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
>> index ce33780..eeb6046 100644
>> --- a/kernel/sched/debug.c
>> +++ b/kernel/sched/debug.c
>> @@ -261,6 +261,12 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
>>   #undef P
>>   }
>>   
>> +void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
>> +{
>> +	SEQ_printf(m, "\ndl_rq[%d]:\n", cpu);
>> +	SEQ_printf(m, "  .%-30s: %ld\n", "dl_nr_running", dl_rq->dl_nr_running);
>> +}
>> +
>>   extern __read_mostly int sched_clock_running;
>>   
>>   static void print_cpu(struct seq_file *m, int cpu)
>> @@ -329,6 +335,7 @@ do {									\
>>   	spin_lock_irqsave(&sched_debug_lock, flags);
>>   	print_cfs_stats(m, cpu);
>>   	print_rt_stats(m, cpu);
>> +	print_dl_stats(m, cpu);
>>   
>>   	print_rq(m, rq, cpu);
>>   	spin_unlock_irqrestore(&sched_debug_lock, flags);
>> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>> index 6130251..2c2ef3c 100644
>> --- a/kernel/sched/sched.h
>> +++ b/kernel/sched/sched.h
>> @@ -1502,6 +1502,7 @@ extern struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq);
>>   extern struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq);
>>   extern void print_cfs_stats(struct seq_file *m, int cpu);
>>   extern void print_rt_stats(struct seq_file *m, int cpu);
>> +extern void print_dl_stats(struct seq_file *m, int cpu);
>>   
>>   extern void init_cfs_rq(struct cfs_rq *cfs_rq);
>>   extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

