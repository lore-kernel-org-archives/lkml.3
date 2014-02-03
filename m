Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbaBCGGC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 01:06:02 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:53162 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaBCGF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 01:05:59 -0500
MIME-Version: 1.0
In-Reply-To: <1391295009-10844-1-git-send-email-robherring2@gmail.com>
References: <1391295009-10844-1-git-send-email-robherring2@gmail.com>
Date: Mon, 3 Feb 2014 11:35:58 +0530
Message-ID: <CAKohpomT2Nu2B7-jMA=776N4L9pknsYxvT5QdiHkKk3Ubwivjg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: cpu0: make THERMAL_CPU support optional
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Rob Herring <robherring2@gmail.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ing the guy who introduced this bug..

On 2 February 2014 04:20, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <robh@kernel.org>
>
> The addition of THERMAL and THERMAL_CPU selections causes a kconfig
> warning on highbank platforms:
>
> warning: (ARM_HIGHBANK_CPUFREQ) selects GENERIC_CPUFREQ_CPU0 which has
> unmet direct dependencies (ARCH_HAS_CPUFREQ && CPU_FREQ && HAVE_CLK &&
>  REGULATOR && OF && THERMAL && CPU_THERMAL)
>
> The cpufreq-cpu0 driver does not require thermal zone support, and it
> should be selectable independently. Add a new kconfig option to enable
> this feature.
>
> Reported-by: Olof Johansson <olof@lixom.net>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: cpufreq@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  drivers/cpufreq/Kconfig | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
> index 4b029c0..a197a04a 100644
> --- a/drivers/cpufreq/Kconfig
> +++ b/drivers/cpufreq/Kconfig
> @@ -185,7 +185,7 @@ config CPU_FREQ_GOV_CONSERVATIVE
>
>  config GENERIC_CPUFREQ_CPU0
>         tristate "Generic CPU0 cpufreq driver"
> -       depends on HAVE_CLK && REGULATOR && OF && THERMAL && CPU_THERMAL
> +       depends on HAVE_CLK && REGULATOR && OF

That's fine as code would still compile due to dummy routines..

>         select PM_OPP
>         help
>           This adds a generic cpufreq driver for CPU0 frequency management.
> @@ -194,6 +194,14 @@ config GENERIC_CPUFREQ_CPU0
>
>           If in doubt, say N.
>
> +config GENERIC_CPUFREQ_CPU0_THERMAL
> +       bool "Thermal zone support for Generic CPU0 cpufreq"
> +       depends on GENERIC_CPUFREQ_CPU0
> +       select THERMAL
> +       select THERMAL_CPU
> +       help
> +         This adds thermal support to the generic cpufreq driver for CPU0.

But do we really need this? Let the platform enable THERMAL
and THERMAL_CPU themselves, as this was the case currently.
