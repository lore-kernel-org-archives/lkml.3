Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751020Ab3HSGi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 02:38:29 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:35025 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3HSGi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 02:38:27 -0400
MIME-Version: 1.0
In-Reply-To: <1376388505-30233-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1376388505-30233-1-git-send-email-l.majewski@samsung.com>
Date: Mon, 19 Aug 2013 12:08:26 +0530
Message-ID: <CAKohponN=JE4KiCL7pVXJvcf__qfC+Fb59ZjBAX5_WK49eCELw@mail.gmail.com>
Subject: Re: [PATCH v7 0/7] cpufreq:boost: CPU Boost mode support
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
> This patch series introduces support for CPU overclocking technique
> called Boost.
>
> It is a follow up of a LAB governor proposal. Boost is a LAB component:
> http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
>
> Boost unifies hardware based solution (e.g. Intel Nehalem) with
> software oriented one (like the one done at Exynos).
> For this reason cpufreq/freq_table code has been reorganized to include
> common code.
>
> Important design decisions:
> - Boost related code is compiled-in unconditionally to cpufreq core and
>   disabled by default. The cpufreq_driver is responsibile for setting
>   boost_supported flag and providing set_boost callback(if HW support
>   is needed). For software managed boost, special Kconfig flag -
>   CONFIG_CPU_FREQ_BOOST_SW has been defined. It will be selected only
>   when a target platform has thermal framework properly configured.
>
> - struct cpufreq_driver has been extended with boost related fields:
>         -- boost_supported - when driver supports boosting
>         -- boost_enabled - boost state
>         -- set_boost - callback to function, which is necessary to
>            enable/disable boost
>
> - Boost sysfs attribute (/sys/devices/system/cpu/cpufreq/boost) is visible
>   _only_ when cpufreq driver supports Boost.
>
> - No special spin_lock for Boost was created. The one from cpufreq core
>   was reused.
>
> - The Boost code doesn't rely on any policy. When boost state is changed,
>   then the policy list is iterated and proper adjustements are done.
>
> - To improve safety level, the thermal framework is also extended to disable
>   software boosting, when thermal trip point is reached. Then it starts
>   monitoring target temperature to evaluate if boost can be enabled
>   again. This emulates behaviour similar to HW managed boost (like x86)
>
> Tested at HW:
>        Exynos 4412 3.11-rc4 Linux
>        Intel Core i7-3770 3.11-rc4 Linux
>
> Above patches were posted on top of linux_pm/linux-next with following
> patches applied:
>
> cpufreq: exynos5440: Fix to skip when new frequency same as current
> cpufreq: fix EXYNOS drivers selection
>
> Lukasz Majewski (7):
>   cpufreq: Add boost frequency support in core
>   cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to work with common
>     boost solution
>   thermal:boost: Automatic enable/disable of BOOST feature
>   cpufreq:boost:Kconfig: Provide support for software managed BOOST
>   cpufreq:exynos:Extend Exynos cpufreq driver to support boost
>     framework
>   Documentation:cpufreq:boost: Update BOOST documentation
>   cpufreq:exynos4x12: Change L0 driver data to CPUFREQ_BOOST_FREQ

Hi Lukasz,

I haven't found time yet to go through this series.. I want to do a deep/careful
review this time as these are almost the final patches.

Will try to get over them by the end of this week..

--
viresh
