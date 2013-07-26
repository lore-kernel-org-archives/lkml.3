Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511Ab3GZKZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:25:00 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64742 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567Ab3GZKY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:24:57 -0400
MIME-Version: 1.0
In-Reply-To: <1374770011-22171-6-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
	<1374770011-22171-1-git-send-email-l.majewski@samsung.com>
	<1374770011-22171-6-git-send-email-l.majewski@samsung.com>
Date: Fri, 26 Jul 2013 15:54:56 +0530
Message-ID: <CAKohpokL57mXSQooX=4LZKtjMxJoXAB4uuzj13fgr3Gs7Wcf0A@mail.gmail.com>
Subject: Re: [PATCH v6 5/8] cpufreq:boost:Kconfig: Provide support for
 software managed BOOST
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
> For safety reasons new flag - CONFIG_CPU_FREQ_BOOST_SW has been added.
> Only after selecting "EXYNOS Frequency Overclocking - Software" Kconfig

You shouldn't mention Exynos here and must do exynos stuff at the end
in a separate patch. This one must be generic.

> option the software managed boost is enabled. It also selects thermal
> subsystem to be compiled in. Thermal is necessary for disabling boost
> and cooling down the device when overheating detected.
>
> Boost _MUST_NOT_ work without thermal subsystem with properly defined
> overheating temperatures.
>
> This option doesn't affect x86's ACPI hardware managed boost support
> (i.e. Intel, AMD). In this situation boost management is embedded at
> hardware.
>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
>
> ---
> Changes for v6:
> - CPU_FREQ_BOOST_SW [1] is now defined as "invisible" bool option.
> - Platform dependent ARM_EXYNOS_CPU_FREQ_BOOST_SW config option has been
>   added. It depends on ARM_EXYNOS_CPUFREQ options and selects
>   EXYNOS_THERMAL with the main boost config [1].
>
> Changes for v5:
> - New patch
>
>  drivers/cpufreq/Kconfig     |    3 +++
>  drivers/cpufreq/Kconfig.arm |   16 ++++++++++++++++
>  2 files changed, 19 insertions(+)
>
> diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
> index 534fcb8..3f058a3 100644
> --- a/drivers/cpufreq/Kconfig
> +++ b/drivers/cpufreq/Kconfig
> @@ -23,6 +23,9 @@ config CPU_FREQ_TABLE
>  config CPU_FREQ_GOV_COMMON
>         bool
>
> +config CPU_FREQ_BOOST_SW
> +       bool

Invisible is fine but this must be disabled by default and must
depend on thermal, rather than moving dependency on platform's
config.
