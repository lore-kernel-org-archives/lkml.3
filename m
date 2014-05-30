Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611AbaE3TVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:21:04 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:55302 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaE3TVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:21:01 -0400
MIME-Version: 1.0
In-Reply-To: <5388546E.5070007@arm.com>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org> <5388546E.5070007@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 30 May 2014 21:20:40 +0200
Message-ID: <CAKfTPtA04sQ4ox7yAU8Wxn_1DLuAxmm9UgER_-Nidtd6sNEEMQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 May 2014 11:50, Dietmar Eggemann <dietmar.eggemann@arm.com> wrote:
> On 23/05/14 16:53, Vincent Guittot wrote:
>> Monitor the activity level of each group of each sched_domain level. The
>> activity is the amount of cpu_power that is currently used on a CPU or group
>> of CPUs. We use the runnable_avg_sum and _period to evaluate this activity
>> level. In the special use case where the CPU is fully loaded by more than 1
>> task, the activity level is set above the cpu_power in order to reflect the
>> overload of the CPU
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>
> [...]
>
>>  /*
>>   * select_task_rq_fair: Select target runqueue for the waking task in domains
>>   * that have the 'sd_flag' flag set. In practice, this is SD_BALANCE_WAKE,
>> @@ -5518,6 +5535,7 @@ struct sg_lb_stats {
>>       unsigned long sum_weighted_load; /* Weighted load of group's tasks */
>>       unsigned long load_per_task;
>>       unsigned long group_power;
>> +     unsigned long group_activity; /* Total activity of the group */
>>       unsigned int sum_nr_running; /* Nr tasks running in the group */
>>       unsigned int group_capacity;
>>       unsigned int idle_cpus;
>> @@ -5538,6 +5556,7 @@ struct sd_lb_stats {
>>       struct sched_group *busiest;    /* Busiest group in this sd */
>>       struct sched_group *local;      /* Local group in this sd */
>>       unsigned long total_load;       /* Total load of all groups in sd */
>> +     unsigned long total_activity;  /* Total activity of all groups in sd */
>>       unsigned long total_pwr;        /* Total power of all groups in sd */
>>       unsigned long avg_load; /* Average load across all groups in sd */
>>
>> @@ -5557,6 +5576,7 @@ static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
>>               .busiest = NULL,
>>               .local = NULL,
>>               .total_load = 0UL,
>> +             .total_activity = 0UL,
>
> AFAICS, total_activity is not used right now. Do you intend to use it to
> calculate something like avg_activity later (like total_load/avg_load)?

this patch only creates group_activity and total_activity.The use of
these statistics appears on the next patches. I have not planned to
compute such avg_activity for the moment mainly because i have need it
yet.

Do you have in mind any use of such avg_activity ?

Vincent

>
>>               .total_pwr = 0UL,
>>               .busiest_stat = {
>>                       .avg_load = 0UL,
>
> [...]
>
