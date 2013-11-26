Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3KZXuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:50:09 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15799 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab3KZXuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:50:06 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 26 Nov 2013 15:43:48 -0800
Message-ID: <529533AD.2050406@nvidia.com>
Date: Tue, 26 Nov 2013 15:50:05 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: cpufreq-cpu0: clk_round_rate() can return a
 zero upon error
References: <alpine.DEB.2.02.1311251559460.23090@tamien> <52942B87.1040203@linaro.org>
In-Reply-To: <52942B87.1040203@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 09:03 PM, viresh kumar wrote:
> On Tuesday 26 November 2013 07:31 AM, Paul Walmsley wrote:
>> diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
>> index d4585ce2346c..0faf756f6197 100644
>> --- a/drivers/cpufreq/cpufreq-cpu0.c
>> +++ b/drivers/cpufreq/cpufreq-cpu0.c
>> @@ -44,7 +44,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
>> unsigned int index)
>>       int ret;
>>
>>       freq_Hz = clk_round_rate(cpu_clk, freq_table[index].frequency * 1000);
>> -    if (freq_Hz < 0)
>> +    if (freq_Hz <= 0)
>>           freq_Hz = freq_table[index].frequency * 1000;
>>
>>       freq_exact = freq_Hz;
> So, we will see another patch where you will do: s/<=/== ??

Probably so for this driver - along with converting the type of freq_Hz 
to be u64 or unsigned long.  Not sure yet about all of the other 
drivers, since many of them are unlikely to see rates above (2^31)-1 Hz.

> I am wondering if there is any other way we can get this solved, i.e. in a
> single patchset.

I'm trying to avoid sending up a large series that touches drivers all 
over the tree :-(

> Otherwise, for both SPEAr and cpu0 patches:
>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks!  But I was instead hoping you might queue them up for merging 
for v3.14?  That should greatly reduce the risk of merge conflicts.

- Paul

