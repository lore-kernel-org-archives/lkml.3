Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbaAGG6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 01:58:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54170 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbaAGG6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 01:58:35 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-24-52cba598b7df
Date: Tue, 07 Jan 2014 07:58:24 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org,
        rjw@sisk.pl
Subject: Re: [PATCH v12 0/7] cpufreq:boost: CPU Boost mode support
Message-id: <20140107075824.59a1ed3c@amdc2363>
In-reply-to: <1387549495-809-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1387549495-809-1-git-send-email-l.majewski@samsung.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t9jAd0ZS08HGZw/bW6xccZ6VounTT/Y
	Lfp+XmG2WLP/J5NF59knzBZvHnFbvHm4mdHi8q45bBafe48wWsw4v4/J4nbjCjaLM6cvsVr0
	L+xlsnjysI/NYuNXDwd+j8V7XjJ53Lm2h81j3bS3zB5brrazePRtWcXo8WhxC6PH8RvbmTw+
	b5IL4IjisklJzcksSy3St0vgypjw5iNjwXyZiqf7tjM2MH4T7WLk4JAQMJH4Nsm/i5ETyBST
	uHBvPVsXIxeHkMAiRomF19sYIZxfjBLzjzxlA6liEVCVWLtkA5jNJqAn8fnuUyYQW0RAW2Ju
	zylmkAZmge0sEtMONYAVCQs4SUxeMJkZZBsvUMP1X9UgYU4BV4nVa+8wgthCAg2MEk0bVUFs
	fgFJifZ/P5ghLrKTOPdpAzuIzSsgKPFj8j0WEJtZQEti87YmVghbXmLzmrfMExgFZyEpm4Wk
	bBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxguPsmfQOxlUNFocYBTgYlXh4X+w9
	FSTEmlhWXJl7iFGCg1lJhFcz5XSQEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp
	2ampBalFMFkmDk6pBkY35XeZXDF3OG5Pu6hwc+FzX9+JG0yn8QebWqz7MK3LQKFv6uwTJjyL
	HuhO4VDLP/5z3kSrgGtcewMvyU28d3zlqd82eowzHXQT2fzkZfMWuTlss3F7aJTGsfmS99LD
	05ldPuoefVY1762MdXLL9sNNX2XWVpbND972V87AJP/tgulhN1qexx9QYinOSDTUYi4qTgQA
	nmF0fq8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> This patch series introduces support for CPU overclocking technique
> called Boost.
> 
> It is a follow up of a LAB governor proposal. Boost is a LAB
> component:
> http://thread.gmane.org/gmane.linux.kernel/1484746/match=cpufreq
> 
> Boost unifies hardware based solution (e.g. Intel Nehalem) with
> software oriented one (like the one done at Exynos).
> For this reason cpufreq/freq_table code has been reorganized to
> include common code.
> 
> Important design decisions:
> - Boost related code is compiled-in unconditionally to cpufreq core
> and disabled by default. The cpufreq_driver is responsibile for
> setting boost_supported flag and providing set_boost callback(if HW
> support is needed). For software managed boost, special Kconfig flag -
>   CONFIG_CPU_FREQ_BOOST_SW has been defined. It will be selected only
>   when a target platform has thermal framework properly configured.
> 
> - struct cpufreq_driver has been extended with boost related fields:
>         -- boost_supported - when driver supports boosting
>         -- boost_enabled - boost state
>         -- set_boost - callback to function, which is necessary to
>            enable/disable boost
> 
> - Boost sysfs attribute (/sys/devices/system/cpu/cpufreq/boost) is
> visible _only_ when cpufreq driver supports Boost.
> 
> - No special spin_lock for Boost was created. The one from cpufreq
> core was reused.
> 
> - The Boost code doesn't rely on any policy. When boost state is
> changed, then the policy list is iterated and proper adjustements are
> done.
> 
> - To improve safety level, the thermal framework is also extended to
> disable software boosting, when thermal trip point is reached. After
> cooling down the boost can be enabled again. This emulates behaviour
> similar to HW managed boost (like x86)
> 
> Tested at HW:
>        Exynos 4412 3.13-rc4 Linux
>        Intel Core i7-3770 3.13-rc4 Linux
> 
> Above patches were posted on top of kernel_pm/bleeding-edge
> (SHA1: bd0f3a5d9dce48a917ce1f1047534d79c725149)
> 
> Lukasz Majewski (7):
>   cpufreq: Add boost frequency support in core
>   cpufreq:acpi:x86: Adjust the acpi-cpufreq.c code to work with common
>     boost solution
>   cpufreq:boost:Kconfig: Provide support for software managed BOOST
>   cpufreq:exynos:Extend Exynos cpufreq driver to support boost
>     framework
>   Documentation:cpufreq:boost: Update BOOST documentation
>   cpufreq:exynos4x12: Change L0 driver data to CPUFREQ_BOOST_FREQ
>   thermal:exynos:boost: Automatic enable/disable of BOOST feature (at
>     Exynos4412)
> 
>  Documentation/cpu-freq/boost.txt          |   26 +++----
>  drivers/cpufreq/Kconfig                   |    4 +
>  drivers/cpufreq/Kconfig.arm               |   15 ++++
>  drivers/cpufreq/acpi-cpufreq.c            |   86
> +++++++-------------- drivers/cpufreq/cpufreq.c                 |
> 118 ++++++++++++++++++++++++++++-
> drivers/cpufreq/exynos-cpufreq.c          |    3 +
> drivers/cpufreq/exynos4x12-cpufreq.c      |    2 +-
> drivers/cpufreq/freq_table.c              |   56 ++++++++++++--
> drivers/thermal/samsung/exynos_tmu_data.c |   12 +--
> include/linux/cpufreq.h                   |   24 ++++++ 10 files
> changed, 261 insertions(+), 85 deletions(-)
> 

A gentle ping about BOOST patches.

Its been already acked by Viresh and Eduardo.

It applies on kernel_pm/bleeding_edge SHA1:
4836deb72c5e2a9af0cb2129c1149783a26d99ab

Thanks in advance.

-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
