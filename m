Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbaCNMSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 08:18:48 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52165 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753065AbaCNMSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 08:18:46 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xin.wang@arm.com, arvind.chauhan@arm.com, Sudeep.Holla@arm.com
Subject: Re: [PATCH 1/2] cpufreq: arm_big_little: make vexpress driver dependent on bL core driver
Date: Fri, 14 Mar 2014 13:34:09 +0100
Message-ID: <2887258.3GWxA0iuUl@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4689064c920e08d5667b38d7117620ab98150273.1394779110.git.viresh.kumar@linaro.org>
References: <4689064c920e08d5667b38d7117620ab98150273.1394779110.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 14, 2014 12:10:54 PM Viresh Kumar wrote:
> Currently vexpress big LITTLE driver selects ARM_BIG_LITTLE_CPUFREQ and so if
> CONFIG_BIG_LITTLE isn't enabled and CONFIG_ARM_VEXPRESS_SPC_CPUFREQ is enabled
> we get below warnings while compiling:
> 
> warning: (ARM_VEXPRESS_SPC_CPUFREQ) selects ARM_BIG_LITTLE_CPUFREQ which has
> unmet direct dependencies (ARCH_HAS_CPUFREQ && CPU_FREQ && (ARM || ARM64) && ARM
> && BIG_LITTLE && ARM_CPU_TOPOLOGY && HAVE_CLK)
> 
> To fix this make ARM_VEXPRESS_SPC_CPUFREQ dependent on ARM_BIG_LITTLE_CPUFREQ
> instead of selecting it.
> 
> This also moves entry for ARM_VEXPRESS_SPC_CPUFREQ along with other big LITTLE
> config entries.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Hi Rafael,

Hi,

> Both of these are fixes, please see if they can make it to 3.14 only.

Quite frankly, I'm afraid they won't make it.

I'm sending a pull request for -rc7 in a while and I won't add anything to it
without running it through linux-next at least for a day.

And since I'm expecting no -rc8 in this cycle, I have no plans for any pull
requests next week.  At least not for 3.14.

Also I'm going to travel during the last week of March, so probably I'll send
my first pull request for the 3.15 merge window before departure.

Thanks,
Rafael


>  drivers/cpufreq/Kconfig.arm | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
> index 3129749..9fb6270 100644
> --- a/drivers/cpufreq/Kconfig.arm
> +++ b/drivers/cpufreq/Kconfig.arm
> @@ -2,6 +2,7 @@
>  # ARM CPU Frequency scaling drivers
>  #
>  
> +# big LITTLE core layer and glue drivers
>  config ARM_BIG_LITTLE_CPUFREQ
>  	tristate "Generic ARM big LITTLE CPUfreq driver"
>  	depends on ARM && BIG_LITTLE && ARM_CPU_TOPOLOGY && HAVE_CLK
> @@ -16,6 +17,14 @@ config ARM_DT_BL_CPUFREQ
>  	  This enables probing via DT for Generic CPUfreq driver for ARM
>  	  big.LITTLE platform. This gets frequency tables from DT.
>  
> +config ARM_VEXPRESS_SPC_CPUFREQ
> +        tristate "Versatile Express SPC based CPUfreq driver"
> +	depends on ARM_BIG_LITTLE_CPUFREQ && ARCH_VEXPRESS_SPC
> +        help
> +          This add the CPUfreq driver support for Versatile Express
> +	  big.LITTLE platforms using SPC for power management.
> +
> +
>  config ARM_EXYNOS_CPUFREQ
>  	bool
>  
> @@ -241,11 +250,3 @@ config ARM_TEGRA_CPUFREQ
>  	default y
>  	help
>  	  This adds the CPUFreq driver support for TEGRA SOCs.
> -
> -config ARM_VEXPRESS_SPC_CPUFREQ
> -        tristate "Versatile Express SPC based CPUfreq driver"
> -        select ARM_BIG_LITTLE_CPUFREQ
> -        depends on ARCH_VEXPRESS_SPC
> -        help
> -          This add the CPUfreq driver support for Versatile Express
> -	  big.LITTLE platforms using SPC for power management.
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
