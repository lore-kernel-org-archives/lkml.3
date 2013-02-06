Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab3BFCSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:18:36 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:50107 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3BFCSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:18:34 -0500
MIME-Version: 1.0
In-Reply-To: <1360088646-19104-7-git-send-email-dirk.brandewie@gmail.com>
References: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com>
	<1360088646-19104-7-git-send-email-dirk.brandewie@gmail.com>
Date: Wed, 6 Feb 2013 07:48:32 +0530
X-Google-Sender-Auth: meYGmqCRFrcKEJcjf5tt52oKJu0
Message-ID: <CAOh2x=nzZAgU4MXKVGSbLTT53yfZkMxsLSxA_nihMiBMkBABgQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] cpufreq_stats: do not remove sysfs files if frequency
 table is not present
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 11:54 PM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> The sysfs files for cpufreq_stats are created in cpufreq_stats_create_table()
> called from cpufreq_stat_notifier_policy() when a policy is added to
> the cpu. cpufreq_stats_create_table() will not be called if the
> scaling driver does not export a frequency table to cpufreq.  Use the
> same fence on tear down.
>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> ---
>  drivers/cpufreq/cpufreq_stats.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
> index 572124c..fb001e2 100644
> --- a/drivers/cpufreq/cpufreq_stats.c
> +++ b/drivers/cpufreq/cpufreq_stats.c
> @@ -185,6 +185,11 @@ static void cpufreq_stats_free_table(unsigned int cpu)
>  static void cpufreq_stats_free_sysfs(unsigned int cpu)
>  {
>         struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
> +       struct cpufreq_frequency_table *table;
> +
> +       table = cpufreq_frequency_get_table(cpu);
> +       if (!table)
> +               return;

Because we aren't using table later on, i would write it as:

> +       if (!cpufreq_frequency_get_table(cpu))
> +               return;
