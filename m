Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab3C1Mmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 08:42:35 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:55009 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab3C1Mmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 08:42:32 -0400
MIME-Version: 1.0
In-Reply-To: <1364457923-8499-2-git-send-email-amit.daniel@samsung.com>
References: <1364457923-8499-1-git-send-email-amit.daniel@samsung.com>
	<1364457923-8499-2-git-send-email-amit.daniel@samsung.com>
Date: Thu, 28 Mar 2013 18:12:31 +0530
Message-ID: <CAKohpon5BYW0Ypx8SbBsSUuugUnmYU=rBCMizz-CxuHjCzObpQ@mail.gmail.com>
Subject: Re: [PATCH V5 1/4] cpufreq: exynos: Add cpufreq driver for exynos5440
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>, cpufreq@vger.kernel.org,
        Inderpal Singh <inderpal.singh@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 March 2013 13:35, Amit Daniel Kachhap <amit.daniel@samsung.com> wrote:
> +++ b/drivers/cpufreq/exynos5440-cpufreq.c
> +static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
> +{
> +       policy->cur = dvfs_info->cur_frequency;
> +       cpufreq_frequency_table_get_attr(dvfs_info->freq_table, policy->cpu);
> +
> +       /* set the transition latency value */
> +       policy->cpuinfo.transition_latency = dvfs_info->latency;
> +
> +       cpumask_setall(policy->cpus);
> +
> +       return cpufreq_frequency_table_cpuinfo(policy, dvfs_info->freq_table);

I missed this earlier and saw this mistake in yet another driver.
You need to call cpufreq_frequency_table_get_attr() only when
cpufreq_frequency_table_cpuinfo() has passed.

> +}
