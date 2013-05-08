Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab3EHASM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 20:18:12 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37766 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068Ab3EHASK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 20:18:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH, RFC 02/22] cpufreq: ARM_DT_BL_CPUFREQ needs ARM_CPU_TOPOLOGY
Date: Wed, 08 May 2013 02:26:34 +0200
Message-ID: <2500374.5Hpjds0B3f@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAKohponuYRm+D-FU5_7Ny1PPmwUhFLm9DkAR9iHURur+GFq_kA@mail.gmail.com>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-3-git-send-email-arnd@arndb.de> <CAKohponuYRm+D-FU5_7Ny1PPmwUhFLm9DkAR9iHURur+GFq_kA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 04, 2013 12:09:40 PM Viresh Kumar wrote:
> On 2 May 2013 20:46, Arnd Bergmann <arnd@arndb.de> wrote:
> > The big.LITTLE cpufreq driver uses the CPU topology API, which
> > needs to be reflected in Kconfig to prevent broken configurations.
> >
> > warning: (ARM_DT_BL_CPUFREQ) selects ARM_BIG_LITTLE_CPUFREQ which
> > has unmet direct dependencies (ARCH_HAS_CPUFREQ && CPU_FREQ && ARM && ARM_CPU_TOPOLOGY)
> >
> > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > Cc: cpufreq@vger.kernel.org
> > Cc: linux-pm@vger.kernel.org
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/cpufreq/Kconfig.arm | 1 +
> >  1 file changed, 1 insertion(+)
> 
> With all the discussions we had, please see if you can replace your
> patch with this one (Attached too for applying, copy/paste in gmail
> will break it):
> 
> From: Viresh Kumar <viresh.kumar@linaro.org>
> Date: Sat, 4 May 2013 12:03:54 +0530
> Subject: [PATCH] cpufreq: ARM big LITTLE: Fix Kconfig entries
> 
> This fixes usage of "depends on" and "select" options in Kconfig for ARM big
> LITTLE cpufreq driver. Otherwise we get these warnings:
> 
> warning: (ARM_DT_BL_CPUFREQ) selects ARM_BIG_LITTLE_CPUFREQ which
> has unmet direct dependencies (ARCH_HAS_CPUFREQ && CPU_FREQ && ARM &&
> ARM_CPU_TOPOLOGY)
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Queued up as a fix for v3.10.

Thanks,
Rafael


> ---
>  drivers/cpufreq/Kconfig.arm | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index 634e992..a924408 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -3,17 +3,17 @@
>  #
> 
>  config ARM_BIG_LITTLE_CPUFREQ
> -	tristate
> -	depends on ARM_CPU_TOPOLOGY
> -	select PM_OPP
> +	tristate "Generic ARM big LITTLE CPUfreq driver"
> +	depends on ARM_CPU_TOPOLOGY && PM_OPP && HAVE_CLK
> +	help
> +	  This enables the Generic CPUfreq driver for ARM big.LITTLE platforms.
> 
>  config ARM_DT_BL_CPUFREQ
> -	tristate "Generic ARM big LITTLE CPUfreq driver probed via DT"
> -	select ARM_BIG_LITTLE_CPUFREQ
> -	depends on OF && HAVE_CLK
> +	tristate "Generic probing via DT for ARM big LITTLE CPUfreq driver"
> +	depends on ARM_BIG_LITTLE_CPUFREQ && OF
>  	help
> -	  This enables the Generic CPUfreq driver for ARM big.LITTLE platform.
> -	  This gets frequency tables from DT.
> +	  This enables probing via DT for Generic CPUfreq driver for ARM
> +	  big.LITTLE platform. This gets frequency tables from DT.
> 
>  config ARM_EXYNOS_CPUFREQ
>  	bool "SAMSUNG EXYNOS SoCs"
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
