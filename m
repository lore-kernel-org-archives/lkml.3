Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857Ab3LIIlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:41:15 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4941 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab3LIIlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:41:12 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Dec 2013 00:37:54 -0800
Message-ID: <52A5822A.9030807@nvidia.com>
Date: Mon, 9 Dec 2013 16:41:14 +0800
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
Subject: Re: [PATCH v3 1/2] cpufreq: tegra: Call tegra_cpufreq_init() specifically
 in machine code
References: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com> <1386229462-3474-2-git-send-email-bilhuang@nvidia.com> <52A10431.6070306@wwwdotorg.org>
In-Reply-To: <52A10431.6070306@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 06:54 AM, Stephen Warren wrote:
> On 12/05/2013 12:44 AM, Bill Huang wrote:
>> Move the call from module_init to Tegra machine codes so it won't be
>> called in a multi-platform kernel running on non-Tegra SoCs.
>
>> diff --git a/include/linux/tegra-soc.h b/include/linux/tegra-soc.h
>
> It might be better to create <linux/tegra-cpufreq.h> for the interface
> to the cpufreq driver; tegra-soc.h is for the interface to core Tegra
> code *from* other drivers.
Thanks, will do.
>
>> +#ifdef CONFIG_ARM_TEGRA_CPUFREQ
>> +int tegra_cpufreq_init(void);
>> +#else
>> +static inline int tegra_cpufreq_init(void)
>> +{
>> +	return -EINVAL;
>> +}
>> +#endif
>
> Probably best to "return 0" from the !CONFIG_ARM_TEGRA_CPUFREQ case; the
> whole point is to isolate callers from having to care whether
> CONFIG_ARM_TEGRA_CPUFREQ is enabled, and making the function act like it
> worked OK is part of that isolation.
>
OK thanks.
