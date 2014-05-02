Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaEBEaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 00:30:22 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:52201 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaEBEaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 00:30:19 -0400
MIME-Version: 1.0
In-Reply-To: <1398992810-14957-1-git-send-email-nm@ti.com>
References: <1398992810-14957-1-git-send-email-nm@ti.com>
Date: Fri, 2 May 2014 10:00:17 +0530
Message-ID: <CAKohpokEuZ69HnnKE89maXk=21cgAMjEYjEvEcaoBpg4bLRsGg@mail.gmail.com>
Subject: Re: [RFC PATCH] PM / OPP: move cpufreq specific OPP functions out of
 generic OPP library
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May 2014 06:36, Nishanth Menon <nm@ti.com> wrote:
> diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
> index 1fbe11f..281ccfb 100644
> --- a/drivers/cpufreq/Kconfig
> +++ b/drivers/cpufreq/Kconfig
> @@ -17,6 +17,11 @@ config CPU_FREQ
>
>  if CPU_FREQ
>
> +config CPU_FREQ_PM_OPP
> +       bool
> +       depends on PM_OPP
> +       default y
> +

Don't need this

>  config CPU_FREQ_GOV_COMMON
>         bool
>
> diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
> index 0dbb963..16eea68 100644
> --- a/drivers/cpufreq/Makefile
> +++ b/drivers/cpufreq/Makefile
> @@ -1,5 +1,7 @@
>  # CPUfreq core
>  obj-$(CONFIG_CPU_FREQ)                 += cpufreq.o freq_table.o
> +obj-$(CONFIG_CPU_FREQ_PM_OPP)          += cpufreq_opp.o

Just use: obj-$(CONFIG_PM_OPP)

> +
>  # CPUfreq stats
>  obj-$(CONFIG_CPU_FREQ_STAT)             += cpufreq_stats.o
>

> diff --git a/drivers/cpufreq/cpufreq_opp.c b/drivers/cpufreq/cpufreq_opp.c
> new file mode 100644
> index 0000000..2602ff8
> --- /dev/null
> +++ b/drivers/cpufreq/cpufreq_opp.c
> @@ -0,0 +1,102 @@
> +/*
> + * Generic OPP Interface for CPUFREQ drivers
> + *
> + * Copyright (C) 2009-2014 Texas Instruments Incorporated.
> + *     Nishanth Menon
> + *     Romit Dasgupta
> + *     Kevin Hilman
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */

I hope you have just copy pasted routines to this file, and haven't done
even the most minor modification in those, as its hard to review it.

> +#include <linux/slab.h>

Sure? That's it, nothing else required to compile this file independently?
As a rule include all the files directly which might be required for compilation
of this file and don't expect them to be included by some other header
files indirectly.

> diff --git a/drivers/cpufreq/cpufreq_opp.h b/drivers/cpufreq/cpufreq_opp.h

Two problems, driver may lie in arch/ as well, though we don't recommend
them, secondly move these in cpufreq.h, don't need a header here for sure.
