Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaFJROe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:14:34 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47767 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbaFJROc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:14:32 -0400
From: Dirk Brandewie <dirk.brandewie@gmail.com>
X-Google-Original-From: Dirk Brandewie <dirk.j.brandewie@intel.com>
Message-ID: <53973CF5.4000201@intel.com>
Date: Tue, 10 Jun 2014 10:14:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Stratos Karafotis <stratosk@semaphore.gr>
CC: dirk.j.brandewie@intel.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] cpufreq: intel_pstate: Remove duplicate CPU ID check
References: <53962059.6070306@semaphore.gr> <CAKohpokABMSRr88Tf=+Kn4b4=r7ThE+mjdAZcU+dvo28b47Kcg@mail.gmail.com>
In-Reply-To: <CAKohpokABMSRr88Tf=+Kn4b4=r7ThE+mjdAZcU+dvo28b47Kcg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 10:21 PM, Viresh Kumar wrote:
> On 10 June 2014 02:30, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>> We check the CPU ID during driver init. There is no need
>> to do it again per logical CPU initialization.
>>
>> So, remove the duplicate check.
>>
>> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
>> ---
>>   drivers/cpufreq/intel_pstate.c | 6 ------
>>   1 file changed, 6 deletions(-)
>>
>> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
>> index aebd457..4e7f492 100644
>> --- a/drivers/cpufreq/intel_pstate.c
>> +++ b/drivers/cpufreq/intel_pstate.c
>> @@ -691,14 +691,8 @@ MODULE_DEVICE_TABLE(x86cpu, intel_pstate_cpu_ids);
>>
>>   static int intel_pstate_init_cpu(unsigned int cpunum)
>>   {
>> -
>> -       const struct x86_cpu_id *id;
>>          struct cpudata *cpu;
>>
>> -       id = x86_match_cpu(intel_pstate_cpu_ids);
>> -       if (!id)
>> -               return -ENODEV;
>> -
>>          all_cpu_data[cpunum] = kzalloc(sizeof(struct cpudata), GFP_KERNEL);
>>          if (!all_cpu_data[cpunum])
>>                  return -ENOMEM;
>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>
Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

