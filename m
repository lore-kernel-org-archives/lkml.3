Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbaGIKJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:09:45 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:43647 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbaGIKJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:09:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAP245DWoQEgotq1FAu9f=zk_-bXAQtnG-RfLWzjrmOoZaCkBDw@mail.gmail.com>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-6-git-send-email-vincent.guittot@linaro.org> <CAP245DWoQEgotq1FAu9f=zk_-bXAQtnG-RfLWzjrmOoZaCkBDw@mail.gmail.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 9 Jul 2014 12:09:23 +0200
Message-ID: <CAKfTPtC4RYVnRY0QMe-XQw0NB+DGsVU58aYYvR0t_QhO0avyGw@mail.gmail.com>
Subject: Re: [PATCH v3 05/12] ARM: topology: use new cpu_power interface
To: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Lists LAKML <linux-arm-kernel@lists.infradead.org>,
        Mike Galbraith <efault@gmx.de>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 July 2014 09:49, Amit Kucheria <amit.kucheria@linaro.org> wrote:
> On Mon, Jun 30, 2014 at 6:05 PM, Vincent Guittot
> <vincent.guittot@linaro.org> wrote:
>> Use the new arch_scale_cpu_power in order to reflect the original capacity of
>
> s/arch_scale_cpu_power/arch_scale_cpu_capacity and similar renames in
> the commit logs across the entire patchset to take into account all
> the renames in the code.

good catch, the commit log passes through the find and replace.  I
will change the other commit message as well

>
>> a CPU instead of arch_scale_freq_power which is more linked to a scaling of
>> the capacity linked to the frequency.
>
> here too...
>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  arch/arm/kernel/topology.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
>> index d42a7db..2310bfb 100644
>> --- a/arch/arm/kernel/topology.c
>> +++ b/arch/arm/kernel/topology.c
>> @@ -42,7 +42,7 @@
>>   */
>>  static DEFINE_PER_CPU(unsigned long, cpu_scale);
>>
>> -unsigned long arch_scale_freq_capacity(struct sched_domain *sd, int cpu)
>> +unsigned long arch_scale_cpu_capacity(struct sched_domain *sd, int cpu)
>>  {
>>         return per_cpu(cpu_scale, cpu);
>>  }
>> @@ -166,7 +166,7 @@ static void update_cpu_capacity(unsigned int cpu)
>>         set_capacity_scale(cpu, cpu_capacity(cpu) / middle_capacity);
>>
>>         printk(KERN_INFO "CPU%u: update cpu_capacity %lu\n",
>> -               cpu, arch_scale_freq_capacity(NULL, cpu));
>> +               cpu, arch_scale_cpu_capacity(NULL, cpu));
>>  }
>>
>>  #else
>> --
>> 1.9.1
>>
>>
>> _______________________________________________
>> linaro-kernel mailing list
>> linaro-kernel@lists.linaro.org
>> http://lists.linaro.org/mailman/listinfo/linaro-kernel
