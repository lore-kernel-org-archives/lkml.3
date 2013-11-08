Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab3KHF1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 00:27:42 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:35430 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab3KHF1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 00:27:39 -0500
MIME-Version: 1.0
In-Reply-To: <1383888232-27049-2-git-send-email-chenxg@marvell.com>
References: <1383888232-27049-1-git-send-email-chenxg@marvell.com>
	<1383888232-27049-2-git-send-email-chenxg@marvell.com>
Date: Fri, 8 Nov 2013 10:57:37 +0530
Message-ID: <CAKohponWfm5etQPwBGUFhobkuE-MJdLauab7XM1mG+gEmnx0dA@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: conservative: set requested_freq to policy
 max when it is over policy max
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Xiaoguang Chen <chenxg@marvell.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xiaoguang Chen <chenxg.marvell@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 November 2013 10:53, Xiaoguang Chen <chenxg@marvell.com> wrote:
> When requested_freq is over policy->max, set it to policy->max.
> This can help to speed up decreasing frequency.
>
> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
> ---
>  drivers/cpufreq/cpufreq_conservative.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
> index 218460f..25a70d0 100644
> --- a/drivers/cpufreq/cpufreq_conservative.c
> +++ b/drivers/cpufreq/cpufreq_conservative.c
> @@ -68,6 +68,9 @@ static void cs_check_cpu(int cpu, unsigned int load)
>
>                 dbs_info->requested_freq += get_freq_target(cs_tuners, policy);
>
> +               if (dbs_info->requested_freq > policy->max)
> +                       dbs_info->requested_freq = policy->max;
> +
>                 __cpufreq_driver_target(policy, dbs_info->requested_freq,
>                         CPUFREQ_RELATION_H);
>                 return;

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
