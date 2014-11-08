Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbaKHRQK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 12:16:10 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:50931 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbaKHRQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 12:16:08 -0500
MIME-Version: 1.0
In-Reply-To: <1415452601-13078-3-git-send-email-amit.daniel@samsung.com>
References: <1415452601-13078-1-git-send-email-amit.daniel@samsung.com> <1415452601-13078-3-git-send-email-amit.daniel@samsung.com>
From: Pankaj Dubey <pankaj.dubey@samsung.com>
Date: Sat, 8 Nov 2014 22:45:46 +0530
X-Google-Sender-Auth: 7JC5IQo_kkqKq7cxvDQzVtLrTp8
Message-ID: <CAGcde9HdX_sac3u554nwzk1ZcKLUmo69QG6CGPRkwT7uCNEX4Q@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] drivers: soc: Add support for Exynos PMU driver
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, lee.jones@linaro.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

On 8 November 2014 18:46, Amit Daniel Kachhap <amit.daniel@samsung.com> wrote:
> This patch moves Exynos PMU driver implementation from "arm/mach-exynos"
> to "drivers/soc/samsung". This driver is mainly used for setting misc bits of
> register from PMU IP of Exynos SoC which will be required to configure
> before Suspend/Resume. Currently all these settings are done in
> "arch/arm/mach-exynos/pmu.c" but moving ahead for ARM64 based SoC
> support,there is a need of DT based implementation of PMU driver.
>
> This driver uses already existing DT binding information.
>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  arch/arm/mach-exynos/Makefile                      |    2 +-
>  drivers/soc/Kconfig                                |    1 +
>  drivers/soc/Makefile                               |    1 +
>  drivers/soc/samsung/Kconfig                        |   19 +++++++++++++++++++
>  drivers/soc/samsung/Makefile                       |    1 +
>  .../pmu.c => drivers/soc/samsung/exynos-pmu.c      |    0
>  6 files changed, 23 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/soc/samsung/Kconfig
>  create mode 100644 drivers/soc/samsung/Makefile
>  rename arch/arm/mach-exynos/pmu.c => drivers/soc/samsung/exynos-pmu.c (100%)
>
> diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
> index bcefb54..b91b382 100644
> --- a/arch/arm/mach-exynos/Makefile
> +++ b/arch/arm/mach-exynos/Makefile
> @@ -9,7 +9,7 @@ ccflags-$(CONFIG_ARCH_MULTIPLATFORM) += -I$(srctree)/$(src)/include -I$(srctree)
>
>  # Core
>
> -obj-$(CONFIG_ARCH_EXYNOS)      += exynos.o pmu.o exynos-smc.o firmware.o
> +obj-$(CONFIG_ARCH_EXYNOS)      += exynos.o exynos-smc.o firmware.o
>
>  obj-$(CONFIG_EXYNOS_CPU_SUSPEND) += pm.o sleep.o
>  obj-$(CONFIG_PM_SLEEP)         += suspend.o
> diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
> index 76d6bd4..90f33b9 100644
> --- a/drivers/soc/Kconfig
> +++ b/drivers/soc/Kconfig
> @@ -3,5 +3,6 @@ menu "SOC (System On Chip) specific Drivers"
>  source "drivers/soc/qcom/Kconfig"
>  source "drivers/soc/ti/Kconfig"
>  source "drivers/soc/versatile/Kconfig"
> +source "drivers/soc/samsung/Kconfig"
>
>  endmenu
> diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
> index 063113d..44d220d 100644
> --- a/drivers/soc/Makefile
> +++ b/drivers/soc/Makefile
> @@ -6,3 +6,4 @@ obj-$(CONFIG_ARCH_QCOM)         += qcom/
>  obj-$(CONFIG_ARCH_TEGRA)       += tegra/
>  obj-$(CONFIG_SOC_TI)           += ti/
>  obj-$(CONFIG_PLAT_VERSATILE)   += versatile/
> +obj-$(CONFIG_ARCH_EXYNOS)      += samsung/
> diff --git a/drivers/soc/samsung/Kconfig b/drivers/soc/samsung/Kconfig
> new file mode 100644
> index 0000000..beb6dfc
> --- /dev/null
> +++ b/drivers/soc/samsung/Kconfig
> @@ -0,0 +1,19 @@
> +#
> +# SAMSUNG SOC drivers
> +#
> +menuconfig SOC_SAMSUNG
> +       bool "Samsung SOC drivers support"
> +
> +if SOC_SAMSUNG
> +
> +config MFD_EXYNOS_PMU

MFD_EXYNOS_PMU? I think it should be only EXYNOS_PMU,
as we are moving here in drivers/soc giving reason as it does not fit
into MFD.

> +       tristate "Support Exynos Power Management Unit"

I think this config should not be user visible config option, as I remember
same was pointed out by Tomasz some times back.

> +       depends on ARM || ARM64

How about only making depends on ARCH_EXYNOS?

> +       default y
> +       help
> +         Exynos SoC have Power Management Unit (PMU) which controls power and
> +         operation state of Exynos SoC in two different ways. This driver
> +         provides implementation of PMU driver and provides basic functionality
> +         required during these operation state.
> +
> +endif #SOC_SAMSUNG
> diff --git a/drivers/soc/samsung/Makefile b/drivers/soc/samsung/Makefile
> new file mode 100644
> index 0000000..9d30f61
> --- /dev/null
> +++ b/drivers/soc/samsung/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_MFD_EXYNOS_PMU)   += exynos-pmu.o
> diff --git a/arch/arm/mach-exynos/pmu.c b/drivers/soc/samsung/exynos-pmu.c
> similarity index 100%
> rename from arch/arm/mach-exynos/pmu.c
> rename to drivers/soc/samsung/exynos-pmu.c
> --
> 1.7.9.5
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
