Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751016Ab3BBFig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 00:38:36 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:55530 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3BBFif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 00:38:35 -0500
MIME-Version: 1.0
In-Reply-To: <1359744343-18690-7-git-send-email-dirk.brandewie@gmail.com>
References: <1359744343-18690-1-git-send-email-dirk.brandewie@gmail.com>
	<1359744343-18690-7-git-send-email-dirk.brandewie@gmail.com>
Date: Sat, 2 Feb 2013 11:08:33 +0530
X-Google-Sender-Auth: Dfgqd2mqmN_hXTi6sJZHJy25w8Y
Message-ID: <CAOh2x=k0=wqYqDwnoUNn0wAmh8f0FSPtaFgFSK49hkmyrAganQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] cpufreq_stats: Do not track policies without
 associated governors.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 2, 2013 at 12:15 AM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> Scaling drivers that implement internal governors do not have governor
> sturctures associated with them.  Do not create/remove statisitcs
> entries for polices that do not have governors associated with them.
>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>

It is not based of latest work.

Why don't we want stats to be updated for these? What does stats have
to do with governor?

> ---
>  drivers/cpufreq/cpufreq_stats.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> index 9d7732b..8a1daf4 100644
> --- a/drivers/cpufreq/cpufreq_stats.c
> +++ b/drivers/cpufreq/cpufreq_stats.c
> @@ -183,7 +183,7 @@ static void cpufreq_stats_free_table(unsigned int cpu)
>  static void cpufreq_stats_free_sysfs(unsigned int cpu)
>  {
>         struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
> -       if (policy && policy->cpu == cpu)
> +       if (policy && policy->cpu == cpu && policy->governor)
>                 sysfs_remove_group(&policy->kobj, &stats_attr_group);
>         if (policy)
>                 cpufreq_cpu_put(policy);
> @@ -271,6 +271,8 @@ static int cpufreq_stat_notifier_policy(struct notifier_block *nb,
>         unsigned int cpu = policy->cpu;
>         if (val != CPUFREQ_NOTIFY)
>                 return 0;
> +       if (!policy->governor)
> +               return 0;
>         table = cpufreq_frequency_get_table(cpu);
>         if (!table)
>                 return 0;
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
