Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaEZI0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 04:26:03 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:59642 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaEZI0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 04:26:02 -0400
MIME-Version: 1.0
In-Reply-To: <5381EE7C.9010809@linux.vnet.ibm.com>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-6-git-send-email-vincent.guittot@linaro.org> <5381EE7C.9010809@linux.vnet.ibm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 26 May 2014 10:25:41 +0200
Message-ID: <CAKfTPtC_vXvf6gUtbrunn+-Zzk8-11AyKF3asjdH5=pejL69Lg@mail.gmail.com>
Subject: Re: [PATCH v2 05/11] ARM: topology: use new cpu_power interface
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 May 2014 15:22, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> Hi Vincent,
>
> Why do we have two interfaces arch_scale_freq_power() and
> arch_scale_cpu_power()? Does it make sense to consolidate them now ?
Hi Preeti,

They don't have the same purpose. arch_scale_cpu_power set the max
capacity of your CPU whereas arch_scale_freq_power can be used to give
the current capacity. ARM platform were using arch_scale_freq_power
because it was the only one available for non SMT system but this
induces some misunderstanding and some limitation in the
characterization of a CPUs. This consolidation is a necessary step so
we can now have the max capacity of a CPU and let
arch_scale_freq_power for other purpose (or even remove it if
useless).

Regards,
Vincent

>
> Regards
> Preeti U Murthy
>
>
> On 05/23/2014 09:22 PM, Vincent Guittot wrote:
>> Use the new arch_scale_cpu_power in order to reflect the original capacity of
>> a CPU instead of arch_scale_freq_power which is more linked to a scaling of
>> the capacity linked to the frequency.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  arch/arm/kernel/topology.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
>> index 71e1fec..6cc25a8 100644
>> --- a/arch/arm/kernel/topology.c
>> +++ b/arch/arm/kernel/topology.c
>> @@ -42,7 +42,7 @@
>>   */
>>  static DEFINE_PER_CPU(unsigned long, cpu_scale);
>>
>> -unsigned long arch_scale_freq_power(struct sched_domain *sd, int cpu)
>> +unsigned long arch_scale_cpu_power(struct sched_domain *sd, int cpu)
>>  {
>>       return per_cpu(cpu_scale, cpu);
>>  }
>> @@ -166,7 +166,7 @@ static void update_cpu_power(unsigned int cpu)
>>       set_power_scale(cpu, cpu_capacity(cpu) / middle_capacity);
>>
>>       printk(KERN_INFO "CPU%u: update cpu_power %lu\n",
>> -             cpu, arch_scale_freq_power(NULL, cpu));
>> +             cpu, arch_scale_cpu_power(NULL, cpu));
>>  }
>>
>>  #else
>>
>
