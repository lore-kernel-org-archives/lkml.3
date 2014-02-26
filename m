Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaBZFLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:11:40 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:46716 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbaBZFLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:11:34 -0500
MIME-Version: 1.0
In-Reply-To: <1393385915-19138-2-git-send-email-skannan@codeaurora.org>
References: <1789244.B5CzWbcp6h@vostro.rjw.lan>
	<1393385915-19138-2-git-send-email-skannan@codeaurora.org>
Date: Wed, 26 Feb 2014 10:41:33 +0530
Message-ID: <CAKohpomZ9VnZOdtEr5HCWTOCUQ-49UZXaUW4qKVF7rwFgTUdjg@mail.gmail.com>
Subject: Re: [PATCH 2/3] cpufreq: stats: Fix error handling in __cpufreq_stats_create_table()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 February 2014 09:08, Saravana Kannan <skannan@codeaurora.org> wrote:
> Remove sysfs group if __cpufreq_stats_create_table() fails after creating
> one.
>
> Change-Id: Icb0b44424cc4eb6c88be255e2839ef51c3f8779c
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> ---
>  drivers/cpufreq/cpufreq_stats.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> index e4bd27f..c52b440 100644
> --- a/drivers/cpufreq/cpufreq_stats.c
> +++ b/drivers/cpufreq/cpufreq_stats.c
> @@ -216,7 +216,7 @@ static int __cpufreq_stats_create_table(struct cpufreq_policy *policy,
>         stat->time_in_state = kzalloc(alloc_size, GFP_KERNEL);
>         if (!stat->time_in_state) {
>                 ret = -ENOMEM;
> -               goto error_out;
> +               goto error_alloc;
>         }
>         stat->freq_table = (unsigned int *)(stat->time_in_state + count);
>
> @@ -237,6 +237,8 @@ static int __cpufreq_stats_create_table(struct cpufreq_policy *policy,
>         stat->last_index = freq_table_get_index(stat, policy->cur);
>         spin_unlock(&cpufreq_stats_lock);
>         return 0;
> +error_alloc:
> +       sysfs_remove_group(&policy->kobj, &stats_attr_group);
>  error_out:
>         kfree(stat);
>         per_cpu(cpufreq_stats_table, cpu) = NULL;

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
