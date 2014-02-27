Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaB0Fjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:39:49 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:58677 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaB0Fjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:39:46 -0500
MIME-Version: 1.0
In-Reply-To: <1393445858-7062-3-git-send-email-skannan@codeaurora.org>
References: <1393445858-7062-3-git-send-email-skannan@codeaurora.org>
Date: Thu, 27 Feb 2014 11:09:45 +0530
Message-ID: <CAKohpo=Xf+5OxjAuYkh_jCJ92MPuutgpHXL8fxOLq_3B18cSEA@mail.gmail.com>
Subject: Re: [PATCH 3/3] cpufreq: stats: Refactor common code into __cpufreq_stats_create_table()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 February 2014 01:47, Saravana Kannan <skannan@codeaurora.org> wrote:
> cpufreq_frequency_get_table() is called from all callers of
> __cpufreq_stats_create_table(). So, move it inside.
>
> Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> ---
>  drivers/cpufreq/cpufreq_stats.c | 22 +++++++++-------------
>  1 file changed, 9 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> index c52b440..9d9e366 100644
> --- a/drivers/cpufreq/cpufreq_stats.c
> +++ b/drivers/cpufreq/cpufreq_stats.c
> @@ -180,13 +180,18 @@ static void cpufreq_stats_free_table(unsigned int cpu)
>         cpufreq_cpu_put(policy);
>  }
>
> -static int __cpufreq_stats_create_table(struct cpufreq_policy *policy,
> -               struct cpufreq_frequency_table *table)
> +static int __cpufreq_stats_create_table(struct cpufreq_policy *policy)
>  {
>         unsigned int i, j, count = 0, ret = 0;
>         struct cpufreq_stats *stat;
>         unsigned int alloc_size;
>         unsigned int cpu = policy->cpu;
> +       struct cpufreq_frequency_table *table;
> +
> +       table = cpufreq_frequency_get_table(policy->cpu);

s/policy->cpu/cpu

Otherwise, Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
