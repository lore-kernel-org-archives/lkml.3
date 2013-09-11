Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab3IKMjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 08:39:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:52333 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab3IKMjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 08:39:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,884,1371106800"; 
   d="scan'208";a="358936986"
Message-ID: <5230646F.3030701@intel.com>
Date: Wed, 11 Sep 2013 08:39:11 -0400
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] Cpufreq: Remove fossil comment of cpufreq_set_policy
References: <1378824287-7696-1-git-send-email-tianyu.lan@intel.com> <CAKohponpX9AedBrsASojK7fKS-rRN-AQwJT42=mrOJcNpGqE+w@mail.gmail.com> <522FE369.3030106@intel.com> <CAKohponyaogXLr5sJzQbb6ZhswMWfwhFTm-b=4Ztzg=UmKx_ig@mail.gmail.com>
In-Reply-To: <CAKohponyaogXLr5sJzQbb6ZhswMWfwhFTm-b=4Ztzg=UmKx_ig@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 06:08 AM, Viresh Kumar wrote:
> On 11 September 2013 08:58, Lan Tianyu <tianyu.lan@intel.com> wrote:
>>  From 668e1b6fd94b5c0e56a651b4c60cbbc7a6868b46 Mon Sep 17 00:00:00 2001
>> From: Lan Tianyu <tianyu.lan@intel.com>
>> Date: Wed, 11 Sep 2013 11:31:15 +0800
>> Subject: [PATCH] Cpufreq/governor: Remove fossil comment
>>
>> cpufreq_set_policy() has been changed to origin __cpufreq_set_policy()
>> and policy->lock has been converted to rewrite lock by commit 5a01f2.
>> So remove it.
>>
>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>> ---
>>   drivers/cpufreq/cpufreq_userspace.c | 11 -----------
>>   1 file changed, 11 deletions(-)
>>
>> diff --git a/drivers/cpufreq/cpufreq_userspace.c
>> b/drivers/cpufreq/cpufreq_userspace.c
>> index 0307809..4dbf1db 100644
>> --- a/drivers/cpufreq/cpufreq_userspace.c
>> +++ b/drivers/cpufreq/cpufreq_userspace.c
>> @@ -38,18 +38,7 @@ static int cpufreq_set(struct cpufreq_policy *policy,
>> unsigned int freq)
>>          if (!per_cpu(cpu_is_managed, policy->cpu))
>>                  goto err;
>>
>> -       /*
>> -        * We're safe from concurrent calls to ->target() here
>> -        * as we hold the userspace_mutex lock. If we were calling
>> -        * cpufreq_driver_target, a deadlock situation might occur:
>> -        * A: cpufreq_set (lock userspace_mutex) ->
>> -        *      cpufreq_driver_target(lock policy->lock)
>> -        * B: cpufreq_set_policy(lock policy->lock) ->
>> -        *      __cpufreq_governor ->
>> -        *         cpufreq_governor_userspace (lock userspace_mutex)
>> -        */
>>          ret = __cpufreq_driver_target(policy, freq, CPUFREQ_RELATION_L);
>> -
>>    err:
>>          mutex_unlock(&userspace_mutex);
>>          return ret;
>
> Looks fine:
>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>

Thanks. I will send formal version.

