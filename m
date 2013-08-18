Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3HRKuX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 06:50:23 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:36009 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab3HRKuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 06:50:21 -0400
MIME-Version: 1.0
In-Reply-To: <b3ef5357898c06aaccb2fcbaee4ef91a3d0fd7bb.1376486713.git.viresh.kumar@linaro.org>
References: <cover.1376486713.git.viresh.kumar@linaro.org>
	<b3ef5357898c06aaccb2fcbaee4ef91a3d0fd7bb.1376486713.git.viresh.kumar@linaro.org>
Date: Sun, 18 Aug 2013 16:20:18 +0530
X-Google-Sender-Auth: CTIL0FAArj8Mr0yHNeJkpLn0hUs
Message-ID: <CADGdYn5nPCOb=mqoJPXzbZzgnbfrhFX6+nsUO5h+PTc-M=2NFA@mail.gmail.com>
Subject: Re: [PATCH 13/37] cpufreq: exynos: don't initialize part of policy
 that is set by core too
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>, cpufreq@vger.kernel.org,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 7:02 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Many common initializations of struct policy are moved to core now and hence
> this driver doesn't need to do it. This patch removes such code.
>
> Most recent of those changes is to call ->get() in the core after calling
> ->init().
>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
This consolidation work looks fine,
Acked-By: Amit Daniel Kachhap <amit.daniel@samsung.com>

Thanks,
Amit
> ---
>  drivers/cpufreq/exynos-cpufreq.c     | 2 --
>  drivers/cpufreq/exynos5440-cpufreq.c | 1 -
>  2 files changed, 3 deletions(-)
>
> diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
> index 79b869b..b1db082 100644
> --- a/drivers/cpufreq/exynos-cpufreq.c
> +++ b/drivers/cpufreq/exynos-cpufreq.c
> @@ -226,8 +226,6 @@ static struct notifier_block exynos_cpufreq_nb = {
>
>  static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
>  {
> -       policy->cur = policy->min = policy->max = exynos_getspeed(policy->cpu);
> -
>         /* set the transition latency value */
>         policy->cpuinfo.transition_latency = 100000;
>
> diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
> index 9a5ed485..91a64d6 100644
> --- a/drivers/cpufreq/exynos5440-cpufreq.c
> +++ b/drivers/cpufreq/exynos5440-cpufreq.c
> @@ -316,7 +316,6 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
>                 return ret;
>         }
>
> -       policy->cur = dvfs_info->cur_frequency;
>         policy->cpuinfo.transition_latency = dvfs_info->latency;
>         cpumask_setall(policy->cpus);
>
> --
> 1.7.12.rc2.18.g61b472e
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
