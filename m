Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab3LQKqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 05:46:13 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15298 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3LQKqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 05:46:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 17 Dec 2013 02:48:24 -0800
Message-ID: <52B02B83.7@nvidia.com>
Date: Tue, 17 Dec 2013 18:46:27 +0800
From: bilhuang <bilhuang@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v4 1/1] cpufreq: tegra: Re-model Tegra20 cpufreq driver
References: <1386840835-28751-1-git-send-email-bilhuang@nvidia.com> <52AB967F.9030900@wwwdotorg.org> <52AEDB6A.2080501@nvidia.com> <52AF3126.6090000@wwwdotorg.org>
In-Reply-To: <52AF3126.6090000@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2013 12:58 AM, Stephen Warren wrote:
> On 12/16/2013 03:52 AM, bilhuang wrote:
>> On 12/14/2013 07:21 AM, Stephen Warren wrote:
>>> On 12/12/2013 02:33 AM, Bill Huang wrote:
>>>> Re-model Tegra20 cpufreq driver as below.
>>>>
>>>> * Rename tegra-cpufreq.c to tegra20-cpufreq.c since this file supports
>>>>     only Tegra20.
>>>> * Add probe function so defer probe can be used when we're going to
>>>>     support DVFS.
>>>> * Create a fake cpufreq platform device with its name being
>>>>     "${root_compatible}-cpufreq" so SoC cpufreq driver can bind to it
>>>>     accordingly.
>>>
>>>> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
>>>
>>>> +config ARM_TEGRA20_CPUFREQ
>>>> +    bool "NVIDIA TEGRA20"
>>>> +    depends on ARM_TEGRA_CPUFREQ && ARCH_TEGRA_2x_SOC
>>>> +    default y
>>>> +    help
>>>> +      This enables Tegra20 cpufreq functionality, it adds
>>>> +      Tegra20 CPU frequency ladder and the call back functions
>>>> +      to set CPU rate. All the non-SoC dependant codes are
>>>> +      controlled by the config ARM_TEGRA20_CPUFREQ.
>>>
>>> I think that last sentence is no longer true in this patch version. Or,
>>> did you mean to write ARM_TEGRA_CPUFREQ rather than ARM_TEGRA20_CPUFREQ?
>>
>> Right, should be ARM_TEGRA_CPUFREQ, thanks for catching this.
>>>
>>>> diff --git a/drivers/cpufreq/tegra-cpufreq.c
>>>> b/drivers/cpufreq/tegra-cpufreq.c
>>>
>>>> +static const char * const tegra_soc_compat[] = {
>>>> +    "nvidia,tegra124",
>>>> +    "nvidia,tegra114",
>>>> +    "nvidia,tegra30",
>>>> +    "nvidia,tegra20",
>>>> +    NULL
>>>>    };
>>>
>>> That table will need editing for each chip. I wonder if you can do
>>> something like always use the very last entry in /compatible. That would
>>> assume a particular ordering of the compatible entries, but they should
>>> be in the order $board, $soc anyway...
>>
>> How do we get subset of a string and making sure it is the last? There
>> must be some assumptions here (though they will possibly be true) I
>> guess, for example, they should be in the order $board, $soc... and the
>> last "nvidia" should be the start of the last compatible id we would
>> like to get.
>
> The compatible property is an array of strings, rather than one big
> string, so you can just keep getting index 0, 1, 2, ... until you find
> there aren't any more entries. I think it's reasonable to assume that
> the SoC compatible value must be last, and it should be in practice,
> although perhaps that is fragile. If you want, we can leave this as-is
> for now, and modify it later if it becomes a problem.
>
Right, thanks.
