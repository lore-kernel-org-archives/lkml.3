Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3HZFdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 01:33:54 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:40253 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab3HZFdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 01:33:52 -0400
MIME-Version: 1.0
In-Reply-To: <1376388505-30233-4-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1376388505-30233-1-git-send-email-l.majewski@samsung.com>
	<1376388505-30233-4-git-send-email-l.majewski@samsung.com>
Date: Mon, 26 Aug 2013 11:03:51 +0530
Message-ID: <CAKohpo=KSVOFr5PXcpTZTaSq3_fv7AZgSiHiY-kWYREj6JdUoA@mail.gmail.com>
Subject: Re: [PATCH v7 3/7] thermal:boost: Automatic enable/disable of BOOST feature
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 August 2013 15:38, Lukasz Majewski <l.majewski@samsung.com> wrote:
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index b5defd4..ec19da9 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -408,10 +408,24 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
>
>  void cpufreq_frequency_table_update_policy_cpu(struct cpufreq_policy *policy);
>  ssize_t cpufreq_show_cpus(const struct cpumask *mask, char *buf);
> +#ifdef CONFIG_CPU_FREQ
>  int cpufreq_boost_trigger_state(int state);
>  int cpufreq_boost_supported(void);
>  int cpufreq_boost_enabled(void);
> -
> +#else
> +static inline int cpufreq_boost_trigger_state(int state)
> +{
> +       return 0;
> +}
> +static inline int cpufreq_boost_supported(void)
> +{
> +       return 0;
> +}
> +static inline int cpufreq_boost_enabled(void)
> +{
> +       return 0;
> +}
> +#endif

I almost gave an Ack before I saw this :)
This should be moved to the first patch I believe..
