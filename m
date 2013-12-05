Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3LEWyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 17:54:49 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:38204 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab3LEWyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 17:54:44 -0500
Message-ID: <52A10431.6070306@wwwdotorg.org>
Date: Thu, 05 Dec 2013 15:54:41 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Bill Huang <bilhuang@nvidia.com>, rjw@rjwysocki.net,
        viresh.kumar@linaro.org, thierry.reding@gmail.com
CC: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 1/2] cpufreq: tegra: Call tegra_cpufreq_init() specifically
 in machine code
References: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com> <1386229462-3474-2-git-send-email-bilhuang@nvidia.com>
In-Reply-To: <1386229462-3474-2-git-send-email-bilhuang@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2013 12:44 AM, Bill Huang wrote:
> Move the call from module_init to Tegra machine codes so it won't be
> called in a multi-platform kernel running on non-Tegra SoCs.

> diff --git a/include/linux/tegra-soc.h b/include/linux/tegra-soc.h

It might be better to create <linux/tegra-cpufreq.h> for the interface
to the cpufreq driver; tegra-soc.h is for the interface to core Tegra
code *from* other drivers.

> +#ifdef CONFIG_ARM_TEGRA_CPUFREQ
> +int tegra_cpufreq_init(void);
> +#else
> +static inline int tegra_cpufreq_init(void)
> +{
> +	return -EINVAL;
> +}
> +#endif

Probably best to "return 0" from the !CONFIG_ARM_TEGRA_CPUFREQ case; the
whole point is to isolate callers from having to care whether
CONFIG_ARM_TEGRA_CPUFREQ is enabled, and making the function act like it
worked OK is part of that isolation.
