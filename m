Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3F0Jgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:36:46 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:35470 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3F0Jgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:36:43 -0400
MIME-Version: 1.0
In-Reply-To: <1371661969-7660-6-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1371661969-7660-1-git-send-email-l.majewski@samsung.com>
	<1371661969-7660-6-git-send-email-l.majewski@samsung.com>
Date: Thu, 27 Jun 2013 15:06:43 +0530
Message-ID: <CAKohpo=EwapTp8epok30=_ZYLPeCR8_LhpBF5H724dE=+SwMLg@mail.gmail.com>
Subject: Re: [PATCH v4 5/7] cpufreq: Calculate number of busy CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 June 2013 22:42, Lukasz Majewski <l.majewski@samsung.com> wrote:
> In the core governor code, per cpu load value is calculated. This patch
> uses it to mark processor as a "busy" one, when load value is higher than
> 90%.

How can we take this assumption. What about a cpu which is only 70-80%
busy? So, we would be running at around 70% of policy->max.. Now at
this point you want to enable boost frequency and so that will happen for
all cores... Wouldn't that burn your chip?

> New cpufreq sysfs attribute is created (busy_cpus). It is read only
> and provides information about number of actually busy CPU.

Not required.

> diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
> index 077cea7..3402533 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -148,6 +148,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
>                         continue;
>
>                 load = 100 * (wall_time - idle_time) / wall_time;
> +               cpufreq_set_busy_cpu(j, load > 90 ? 1 : 0);

do this only when boost is enabled.

>                 if (dbs_data->cdata->governor == GOV_ONDEMAND) {
>                         int freq_avg = __cpufreq_driver_getavg(policy, j);
