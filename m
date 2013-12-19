Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3LSTdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:33:43 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36111 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab3LSTdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:33:40 -0500
Message-ID: <52B34A0F.5080901@wwwdotorg.org>
Date: Thu, 19 Dec 2013 12:33:35 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Bill Huang <bilhuang@nvidia.com>, rjw@rjwysocki.net,
        viresh.kumar@linaro.org, thierry.reding@gmail.com
CC: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v5 1/1] cpufreq: tegra: Re-model Tegra20 cpufreq driver
References: <1387451926-21373-1-git-send-email-bilhuang@nvidia.com>
In-Reply-To: <1387451926-21373-1-git-send-email-bilhuang@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 04:18 AM, Bill Huang wrote:
> Re-model Tegra20 cpufreq driver as below.
> 
> * Rename tegra-cpufreq.c to tegra20-cpufreq.c since this file supports
>   only Tegra20.
> * Add probe function so defer probe can be used when we're going to
>   support DVFS.
> * Create a fake cpufreq platform device with its name being
>   "${root_compatible}-cpufreq" so SoC cpufreq driver can bind to it
>   accordingly.

Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>

It should be fine to merge the arch/arm/mach-tegra/ changes in this
patch through the cpufreq tree, since I don't think they'll conflict at
all with anything in other trees this kernel cycle.

> diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra20-cpufreq.c

> -#define NUM_CPUS	2
> +#define MAX_CPUS	2

Nit: Given this driver is explicitly for a 2-CPU SoC, I don't think
there's any need to s/NUM/MAX/ here. But I don't care that much.

