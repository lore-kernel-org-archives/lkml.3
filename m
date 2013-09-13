Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab3IMW0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 18:26:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51864 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab3IMW0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 18:26:18 -0400
Message-ID: <52339106.4020601@wwwdotorg.org>
Date: Fri, 13 Sep 2013 16:26:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bill Huang <bilhuang@nvidia.com>
CC: rjw@sisk.pl, viresh.kumar@linaro.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 3/4] cpufreq: tegra: Re-model Tegra cpufreq driver
References: <1378985091-9447-1-git-send-email-bilhuang@nvidia.com> <1378985091-9447-4-git-send-email-bilhuang@nvidia.com>
In-Reply-To: <1378985091-9447-4-git-send-email-bilhuang@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 05:24 AM, Bill Huang wrote:
> Re-model Tegra cpufreq driver to support all Tegra series of SoCs.
> 
> * Make tegra-cpufreq.c a generic Tegra cpufreq driver.
> * Move Tegra20 specific codes into tegra20-cpufreq.c.
> * Bind Tegra cpufreq dirver with a fake device so defer probe would work
>   when we're going to get regulator in the driver to support voltage
>   scaling (DVFS).

> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm

> @@ -232,6 +232,12 @@ config ARM_TEGRA_CPUFREQ
>  	bool "TEGRA CPUFreq support"
>  	depends on ARCH_TEGRA
>  	select CPU_FREQ_TABLE
> +
> +config ARM_TEGRA20_CPUFREQ
> +	bool "NVIDIA TEGRA20"
> +	depends on ARM_TEGRA_CPUFREQ && ARCH_TEGRA_2x_SOC
>  	default y
>  	help
> -	  This adds the CPUFreq driver support for TEGRA SOCs.
> +	  This adds the CPUFreq driver for NVIDIA TEGRA20 SoC.
> +
> +	  If in doubt, say N.

This patch removes the following from "config ARM_TEGRA_CPUFREQ":

	default y
	help
	  This adds the CPUFreq driver support for TEGRA SOCs.

I think that option should be left unchanged, such that this patch
*just* adds the new option without changing the existing one. If you do
that, then you can completely drop patch 4/4.

Other than that, this series looks fine.
