Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbaJaGPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 02:15:15 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:38250 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaJaGPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 02:15:13 -0400
From: Dirk Brandewie <dirk.brandewie@gmail.com>
X-Google-Original-From: Dirk Brandewie <dirk.j.brandewie@intel.com>
Message-ID: <545328ED.20900@intel.com>
Date: Thu, 30 Oct 2014 23:15:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        James Geboski <jgeboski@gmail.com>
CC: dirk.j.brandewie@intel.com, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Dirk Brandewie'" <dirk.brandewie@gmail.com>
Subject: Re: [PATCH v2] cpufreq: allow powersave governor as the default without
 expert mode
References: <1413322689-6195-1-git-send-email-jgeboski@gmail.com> <1413459431-12355-1-git-send-email-jgeboski@gmail.com> <1463060.7rHn3OIKry@vostro.rjw.lan>
In-Reply-To: <1463060.7rHn3OIKry@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 02:18 PM, Rafael J. Wysocki wrote:
> On Thursday, October 16, 2014 07:37:11 AM James Geboski wrote:
>> The intel_pstate driver only supports the performance and the powersave
>> governors. With the performance governor ensuring the highest possible
>> performance settings, userspace tools fail to make any lasting changes.
>> In order to allow userspace tools to make modifications to the settings,
>> the powersave governor must be in use. This makes having the powersave
>> governor as the default convenient for systems where the intel_pstate
>> driver is being employed. Having to enable expert mode in the kernel
>> configuration is just a headache for such a trivial task.
>>
>> This patch applies to all kernel versions 2.6.38 or greater after the
>> migration from CONFIG_EMBEDDED to CONFIG_EXPERT (6a108a14fa35). Most
>> importantly, this applies to kernel versions 3.9 or greater when the
>> intel_pstate driver was introduced.
>>
>> Signed-off-by: James Geboski <jgeboski@gmail.com>
>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> Dirk, any objections?

No objection.
>
>> ---
>> ChangeLog v2:
>>    - Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>   drivers/cpufreq/Kconfig | 1 -
>>   1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
>> index 3489f8f..73df7db 100644
>> --- a/drivers/cpufreq/Kconfig
>> +++ b/drivers/cpufreq/Kconfig
>> @@ -63,7 +63,6 @@ config CPU_FREQ_DEFAULT_GOV_PERFORMANCE
>>
>>   config CPU_FREQ_DEFAULT_GOV_POWERSAVE
>>   	bool "powersave"
>> -	depends on EXPERT
>>   	select CPU_FREQ_GOV_POWERSAVE
>>   	help
>>   	  Use the CPUFreq governor 'powersave' as default. This sets
>>
>

