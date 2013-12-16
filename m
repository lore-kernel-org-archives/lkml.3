Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3LPIyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 03:54:11 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:46086 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3LPIyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 03:54:08 -0500
MIME-Version: 1.0
In-Reply-To: <1386202994-30784-3-git-send-email-robherring2@gmail.com>
References: <1386202994-30784-1-git-send-email-robherring2@gmail.com>
	<1386202994-30784-3-git-send-email-robherring2@gmail.com>
Date: Mon, 16 Dec 2013 14:24:07 +0530
Message-ID: <CAKohpomzgsQVuBOm-hrs0HNAJoM4zxExFn-rz5aCGyZSyeEatQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: highbank: rework the kconfig dependencies
 for arm64
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 December 2013 05:53, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> Make ARM_HIGHBANK_CPUFREQ not depend on ARCH_HIGHBANK to enable on
> arm64 and also give better build converage. Change the selects to be

s/converage/coverage

> same depends as the cpu0 driver. Otherwise, we can get kconfig select
> errors. Also, add missing depends for PL320_MBOX.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: cpufreq@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> ---
>  drivers/cpufreq/Kconfig.arm | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index ce52ed9..0d7130d 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -65,16 +65,14 @@ config ARM_EXYNOS5440_CPUFREQ
>           If in doubt, say N.
>
>  config ARM_HIGHBANK_CPUFREQ
> -       tristate "Calxeda Highbank-based"
> -       depends on ARCH_HIGHBANK
> -       select GENERIC_CPUFREQ_CPU0
> +       tristate "Calxeda ECX based"
> +       depends on HAVE_CLK && REGULATOR && OF
> +       depends on PL320_MBOX
> +       select ARCH_HAS_OPP
>         select PM_OPP
> -       select REGULATOR
> -
> -       default m
> +       select GENERIC_CPUFREQ_CPU0
>         help
> -         This adds the CPUFreq driver for Calxeda Highbank SoC
> -         based boards.
> +         This adds the CPUFreq driver for Calxeda based SoCs.
>
>           If in doubt, say N.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org> for both patches.
