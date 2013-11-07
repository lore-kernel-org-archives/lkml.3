Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3KGEPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 23:15:33 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:41133 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab3KGEP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 23:15:28 -0500
Message-ID: <527B13C8.9030602@linux.vnet.ibm.com>
Date: Thu, 07 Nov 2013 09:45:04 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        scottwood@freescale.com, srivatsa.bhat@linux.vnet.ibm.com,
        preeti@linux.vnet.ibm.com, linux-pm@lists.linux-foundation.org,
        svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH V7 5/7] POWER/cpuidle: Generic POWER CPUIDLE driver supporting
 PSERIES.
References: <20131029110052.31547.82682.stgit@deepthi.in.ibm.com> <20131029110148.31547.8944.stgit@deepthi.in.ibm.com> <527AAF1D.5080605@linaro.org>
In-Reply-To: <527AAF1D.5080605@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110704-1618-0000-0000-000004F0112F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 02:35 AM, Daniel Lezcano wrote:
> On 10/29/2013 12:01 PM, Deepthi Dharwar wrote:
>> This patch includes cleanup and refactoring of the
>> existing code to make the driver POWER generic.
>> * Re-naming the functions from pseries to generic power.
>> * Re-naming the backend driver from pseries_idle to
>>    ibm-power-idle.
>>
>> Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
> 
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Hi Daniel,

Thanks for the Acks.

> ... but I am wondering if 'power' name is not confusing with power
> management and if 'powerpc' would suit better.

'powerpc' would be very generic arch and would comprise of all platforms
including embedded 32/64 bit to server 64 bit (similar to that of ARM).
This driver does not intend to support complete powerpc arch, but just
PSERIES and POWERNV platforms termed as 'POWER' processors. So to avoid
confusion btw 'power mgmt' and 'POWER' archs, I have prefixed both the
driver and file names with 'IBM'namely ibm-power-driver, cpuidle-ibm-power.

Regards,
Deepthi

>> ---
>>   drivers/cpuidle/cpuidle-ibm-power.c |   32
>> ++++++++++++++++----------------
>>   1 file changed, 16 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/cpuidle/cpuidle-ibm-power.c
>> b/drivers/cpuidle/cpuidle-ibm-power.c
>> index e81c207..5b92242 100644
>> --- a/drivers/cpuidle/cpuidle-ibm-power.c
>> +++ b/drivers/cpuidle/cpuidle-ibm-power.c
>> @@ -20,8 +20,8 @@
>>   #include <asm/runlatch.h>
>>   #include <asm/plpar_wrappers.h>
>>
>> -struct cpuidle_driver pseries_idle_driver = {
>> -    .name             = "pseries_idle",
>> +struct cpuidle_driver power_idle_driver = {
>> +    .name             = "ibm_power_idle",
>>       .owner            = THIS_MODULE,
>>   };
>>
>> @@ -182,7 +182,7 @@ void update_smt_snooze_delay(int cpu, int residency)
>>               drv->states[1].target_residency = residency;
>>   }
>>
>> -static int pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
>> +static int power_cpuidle_add_cpu_notifier(struct notifier_block *n,
>>               unsigned long action, void *hcpu)
>>   {
>>       int hotcpu = (unsigned long)hcpu;
>> @@ -213,16 +213,16 @@ static int
>> pseries_cpuidle_add_cpu_notifier(struct notifier_block *n,
>>   }
>>
>>   static struct notifier_block setup_hotplug_notifier = {
>> -    .notifier_call = pseries_cpuidle_add_cpu_notifier,
>> +    .notifier_call = power_cpuidle_add_cpu_notifier,
>>   };
>>
>>   /*
>> - * pseries_cpuidle_driver_init()
>> + * power_cpuidle_driver_init()
>>    */
>> -static int pseries_cpuidle_driver_init(void)
>> +static int power_cpuidle_driver_init(void)
>>   {
>>       int idle_state;
>> -    struct cpuidle_driver *drv = &pseries_idle_driver;
>> +    struct cpuidle_driver *drv = &power_idle_driver;
>>
>>       drv->state_count = 0;
>>       for (idle_state = 0; idle_state < max_idle_state; ++idle_state) {
>> @@ -241,10 +241,10 @@ static int pseries_cpuidle_driver_init(void)
>>   }
>>
>>   /*
>> - * pseries_idle_probe()
>> + * power_idle_probe()
>>    * Choose state table for shared versus dedicated partition
>>    */
>> -static int pseries_idle_probe(void)
>> +static int power_idle_probe(void)
>>   {
>>
>>       if (cpuidle_disable != IDLE_NO_OVERRIDE)
>> @@ -264,24 +264,24 @@ static int pseries_idle_probe(void)
>>       return 0;
>>   }
>>
>> -static int __init pseries_processor_idle_init(void)
>> +static int __init power_processor_idle_init(void)
>>   {
>>       int retval;
>>
>> -    retval = pseries_idle_probe();
>> +    retval = power_idle_probe();
>>       if (retval)
>>           return retval;
>>
>> -    pseries_cpuidle_driver_init();
>> -    retval = cpuidle_register(&pseries_idle_driver, NULL);
>> +    power_cpuidle_driver_init();
>> +    retval = cpuidle_register(&power_idle_driver, NULL);
>>       if (retval) {
>> -        printk(KERN_DEBUG "Registration of pseries driver failed.\n");
>> +        printk(KERN_DEBUG "Registration of ibm_power_idle driver
>> failed.\n");
>>           return retval;
>>       }
>>
>>       register_cpu_notifier(&setup_hotplug_notifier);
>> -    printk(KERN_DEBUG "pseries_idle_driver registered\n");
>> +    printk(KERN_DEBUG "ibm_power_idle registered\n");
>>       return 0;
>>   }
>>
>> -device_initcall(pseries_processor_idle_init);
>> +device_initcall(power_processor_idle_init);
>>
> 
> 

