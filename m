Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535Ab3GZK2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:28:51 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:61960 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214Ab3GZK2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:28:50 -0400
MIME-Version: 1.0
In-Reply-To: <1374770011-22171-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1374770011-22171-1-git-send-email-l.majewski@samsung.com>
Date: Fri, 26 Jul 2013 15:58:49 +0530
Message-ID: <CAKohpokTqL8QPFrM9OQJvC78iM92XR+KOkFSZXpWzesa7Uc9sA@mail.gmail.com>
Subject: Re: [PATCH v6 0/8] cpufreq:boost: CPU Boost mode support
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
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 July 2013 22:03, Lukasz Majewski <l.majewski@samsung.com> wrote:
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
> - All available policies are now stored in a list.
>
> - The Boost code doesn't rely on any policy. When boost state is changed,
>   then the policy list is iterated and proper adjustements are done.
>
> - To improve safety level, the thermal framework is also extended to disable
>   software boosting, when thermal trip point is reached. Then it starts
>   monitoring target temperature to evaluate if boost can be enabled
>   again. This emulates behaviour similar to HW managed boost (like x86)
>
> New patches for v6:
> cpufreq:exynos4x12: Change L0 driver data to CPUFREQ_BOOST_FREQ
>
> Tested at HW:
>        Exynos 4412 3.11-rc1 Linux
>        Intel Core i7-3770 3.11-rc1 Linux

I am done with review of this patchset now and should say pretty much
comfortable with it now..
