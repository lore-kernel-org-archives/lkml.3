Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbaCSXZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 19:25:19 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:45317 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755129AbaCSXZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 19:25:17 -0400
Message-ID: <532A2759.1000708@semaphore.gr>
Date: Thu, 20 Mar 2014 01:25:13 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: Remove unnecessary braces
References: <532A0D0C.50507@semaphore.gr> <93042283.W9rbzHbJB2@vostro.rjw.lan>
In-Reply-To: <93042283.W9rbzHbJB2@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/03/2014 12:45 πμ, Rafael J. Wysocki wrote:
> On Wednesday, March 19, 2014 11:33:00 PM Stratos Karafotis wrote:
>> Remove 3 sets of unnecessary braces
>>
>> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
>> ---
>>  drivers/cpufreq/cpufreq.c | 11 ++++-------
>>  1 file changed, 4 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>> index 1eafd8c..ca3c01f 100644
>> --- a/drivers/cpufreq/cpufreq.c
>> +++ b/drivers/cpufreq/cpufreq.c
>> @@ -1325,17 +1325,16 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
>>  	cpus = cpumask_weight(policy->cpus);
>>  	up_read(&policy->rwsem);
>>  
>> -	if (cpu != policy->cpu) {
>> +	if (cpu != policy->cpu)
>>  		sysfs_remove_link(&dev->kobj, "cpufreq");
>> -	} else if (cpus > 1) {
> 
> These braces aren't in fact unnecessary, they are in accordance with CodingStyle.
> 
>> +	else if (cpus > 1) {
>>  		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu);
>>  		if (new_cpu >= 0) {
>>  			update_policy_cpu(policy, new_cpu);
>>  
>> -			if (!cpufreq_suspended) {
>> +			if (!cpufreq_suspended)
>>  				pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
>>  					 __func__, new_cpu, cpu);
>> -			}
>>  		}
>>  	}
>>  
>> @@ -2158,11 +2157,9 @@ int cpufreq_update_policy(unsigned int cpu)
>>  		if (!policy->cur) {
>>  			pr_debug("Driver did not initialize current freq\n");
>>  			policy->cur = new_policy.cur;
>> -		} else {
>> -			if (policy->cur != new_policy.cur && has_target())
>> +		} else if (policy->cur != new_policy.cur && has_target())
> 
> And here too.
> 
>>  				cpufreq_out_of_sync(cpu, policy->cur,
>>  								new_policy.cur);
>> -		}
>>  	}
>>  
>>  	ret = cpufreq_set_policy(policy, &new_policy);
>>
> 

I'm sorry for the inconvenience. I read again the CodingStyle (more carefully :) ).
I'm sending the corrected patch with the single case of unnecessary braces.

Thanks,
Stratos

------------------------8<-----------------------
Remove unnecessary braces from a single statement.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index e3aa9de..220c4a9 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1330,10 +1330,9 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 		if (new_cpu >= 0) {
 			update_policy_cpu(policy, new_cpu);
 
-			if (!cpufreq_suspended) {
+			if (!cpufreq_suspended)
 				pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
 					 __func__, new_cpu, cpu);
-			}
 		}
 	}
 
-- 
1.8.5.3


