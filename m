Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab3GPJ6n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:58:43 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:52066 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3GPJ6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:58:40 -0400
MIME-Version: 1.0
In-Reply-To: <1372927830-2949-7-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1372927830-2949-1-git-send-email-l.majewski@samsung.com>
	<1372927830-2949-7-git-send-email-l.majewski@samsung.com>
Date: Tue, 16 Jul 2013 15:28:40 +0530
Message-ID: <CAKohpokR=jrcLQQ7VAD+vr7GWgSFBfuqbOhWHwA3FCgk__EJ3Q@mail.gmail.com>
Subject: Re: [PATCH v5 6/7] cpufreq:boost:Kconfig: Enable software managed
 BOOST support at Kconfig
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 July 2013 14:20, Lukasz Majewski <l.majewski@samsung.com> wrote:
> diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig

> +config CPU_FREQ_BOOST_SW
> +       bool "CPU frequency overclocking (BOOST)"

Name it "CPU Frequency Overclocking - Software"

> +       depends on ARM_EXYNOS_CPUFREQ && EXYNOS_THERMAL

Remote Exynos from here. If you want to enable it for your platform by
default, then select it from EXYNOS.

> +       default n
> +       help
> +        This driver supports software managed overclocking (BOOST).
> +         It allows usage of special frequencies for a particular processor
> +         if thermal conditions are appropriate.
> +
> +        It reguires, for safe operation, thermal framework with properly defined
> +         trip points.
> +
> +        If in doubt, say N.
> +
>  config CPU_FREQ_STAT
>         tristate "CPU frequency translation statistics"
>         select CPU_FREQ_TABLE
> diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
> index 4f42fcc..7586b28 100644
> --- a/drivers/cpufreq/exynos-cpufreq.c
> +++ b/drivers/cpufreq/exynos-cpufreq.c
> @@ -288,7 +288,9 @@ static struct cpufreq_driver exynos_driver = {
>
>  static int __init exynos_cpufreq_init(void)
>  {
> +#ifdef CONFIG_CPU_FREQ_BOOST_SW
>         struct device_node *node = pdev->dev.of_node;
> +#endif
>         int ret = -EINVAL;
>
>         exynos_info = kzalloc(sizeof(struct exynos_dvfs_info), GFP_KERNEL);
> @@ -319,9 +321,10 @@ static int __init exynos_cpufreq_init(void)
>         }
>
>         locking_frequency = exynos_getspeed(0);
> +#ifdef CONFIG_CPU_FREQ_BOOST_SW
>         if (of_property_read_bool(node, "boost_mode"))
>                 exynos_driver.boost_supported = 1;
> -
> +#endif

Add a blank line here.

>         register_pm_notifier(&exynos_cpufreq_nb);
>
>         if (cpufreq_register_driver(&exynos_driver)) {
> --
> 1.7.10.4
>
