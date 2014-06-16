Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaFPOYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:24:03 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60323 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaFPOYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:24:01 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <539EFDF9.8000708@roeck-us.net>
Date: Mon, 16 Jun 2014 07:23:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Suppress -Wignored-qualifiers warnings
References: <539C17BB.1020809@acm.org> <CAKfTPtBLSHYCdUpdN6MZiD_gCLa12Gv-hMO5oRY6uyiw4AqCug@mail.gmail.com>
In-Reply-To: <CAKfTPtBLSHYCdUpdN6MZiD_gCLa12Gv-hMO5oRY6uyiw4AqCug@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 12:49 AM, Vincent Guittot wrote:
> Hi Bart,
>
> Guenter sent similar patch few days ago
> https://lkml.org/lkml/2014/6/12/743
> with additional patches for ARM and powerpc architecture
> https://lkml.org/lkml/2014/6/13/399
> https://lkml.org/lkml/2014/6/13/407
>

Still not applied, though, so maybe a few more submissions
until one of them is accepted won't hurt ;-).

Guenter

> Vincent
>
>
> On 14 June 2014 11:36, Bart Van Assche <bvanassche@acm.org> wrote:
>> Avoid that gcc reports the following warning when building with W=1:
>>
>> warning: type qualifiers ignored on function return type [-Wignored-qualifiers]
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>   include/linux/sched.h | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 306f4f0..0376b05 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -872,21 +872,21 @@ enum cpu_idle_type {
>>   #define SD_NUMA                        0x4000  /* cross-node balancing */
>>
>>   #ifdef CONFIG_SCHED_SMT
>> -static inline const int cpu_smt_flags(void)
>> +static inline int cpu_smt_flags(void)
>>   {
>>          return SD_SHARE_CPUCAPACITY | SD_SHARE_PKG_RESOURCES;
>>   }
>>   #endif
>>
>>   #ifdef CONFIG_SCHED_MC
>> -static inline const int cpu_core_flags(void)
>> +static inline int cpu_core_flags(void)
>>   {
>>          return SD_SHARE_PKG_RESOURCES;
>>   }
>>   #endif
>>
>>   #ifdef CONFIG_NUMA
>> -static inline const int cpu_numa_flags(void)
>> +static inline int cpu_numa_flags(void)
>>   {
>>          return SD_NUMA;
>>   }
>> @@ -999,7 +999,7 @@ void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
>>   bool cpus_share_cache(int this_cpu, int that_cpu);
>>
>>   typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
>> -typedef const int (*sched_domain_flags_f)(void);
>> +typedef int (*sched_domain_flags_f)(void);
>>
>>   #define SDTL_OVERLAP   0x01
>>
>> --
>> 1.8.4.5
>>
>
>

