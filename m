Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaLCOPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:15:53 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:61587 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbaLCOPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:15:50 -0500
MIME-Version: 1.0
In-Reply-To: <3484329.phAPviVnbd@vostro.rjw.lan>
References: <37310416.jZXoh5nfSC@vostro.rjw.lan>
	<3484329.phAPviVnbd@vostro.rjw.lan>
Date: Wed, 3 Dec 2014 15:15:49 +0100
Message-ID: <CAPDyKFoZmCYYNAGfNzwwEj=jk9wrfCKoxqQ4p=KStADSK1suCg@mail.gmail.com>
Subject: Re: [PATCH 1/4] PM: Drop the SET_PM_RUNTIME_PM_OPS() macro
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>, Kevin Hilman <khilman@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2014 at 01:38, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> The SET_PM_RUNTIME_PM_OPS() and SET_RUNTIME_PM_OPS() macros are
> identical except that one of them is not empty for CONFIG_PM set,
> while the other one is not empty for CONFIG_PM_RUNTIME set,
> respectively.
>
> However, after commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) PM_RUNTIME is always set if PM is set, so one
> of these macros is now redundant.
>
> For this reason, drop SET_PM_RUNTIME_PM_OPS() and replace it with
> SET_RUNTIME_PM_OPS() everywhere.

Hi Rafael,

Apparently, I have queued an mmc patch in my mmc tree, which means one
mmc driver starts using the SET_PM_RUNTIME_PM_OPS macro. It should
cause a build error in linux-next with @subject patch.

I have shared that patch through an immutable branch, I have also
checked potential conflicts and it shouldn't be any problems to pull
that in to your tree. Then you can fix $subject patch by also
converting the mmc driver to use SET_RUNTIME_PM_OPS macro.

The branch is available at:
git://git.linaro.org/people/ulf.hansson/mmc.git mmc_for_linux_pm

Kind regards
Uffe

>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  drivers/amba/bus.c                |    2 +-
>  drivers/dma/ste_dma40.c           |    2 +-
>  drivers/gpio/gpio-zynq.c          |    2 +-
>  drivers/i2c/busses/i2c-hix5hd2.c  |    2 +-
>  drivers/i2c/busses/i2c-nomadik.c  |    2 +-
>  drivers/mmc/host/mmci.c           |    2 +-
>  drivers/mmc/host/sh_mobile_sdhi.c |    2 +-
>  drivers/mmc/host/tmio_mmc.c       |    2 +-
>  drivers/spi/spi-pl022.c           |    2 +-
>  include/linux/pm.h                |   11 +----------
>  10 files changed, 10 insertions(+), 19 deletions(-)
>
> Index: linux-pm/drivers/amba/bus.c
> ===================================================================
> --- linux-pm.orig/drivers/amba/bus.c
> +++ linux-pm/drivers/amba/bus.c
> @@ -124,7 +124,7 @@ static const struct dev_pm_ops amba_pm =
>         .thaw           = pm_generic_thaw,
>         .poweroff       = pm_generic_poweroff,
>         .restore        = pm_generic_restore,
> -       SET_PM_RUNTIME_PM_OPS(
> +       SET_RUNTIME_PM_OPS(
>                 amba_pm_runtime_suspend,
>                 amba_pm_runtime_resume,
>                 NULL
> Index: linux-pm/drivers/dma/ste_dma40.c
> ===================================================================
> --- linux-pm.orig/drivers/dma/ste_dma40.c
> +++ linux-pm/drivers/dma/ste_dma40.c
> @@ -3051,7 +3051,7 @@ static int dma40_runtime_resume(struct d
>
>  static const struct dev_pm_ops dma40_pm_ops = {
>         SET_LATE_SYSTEM_SLEEP_PM_OPS(dma40_suspend, dma40_resume)
> -       SET_PM_RUNTIME_PM_OPS(dma40_runtime_suspend,
> +       SET_RUNTIME_PM_OPS(dma40_runtime_suspend,
>                                 dma40_runtime_resume,
>                                 NULL)
>  };
> Index: linux-pm/drivers/gpio/gpio-zynq.c
> ===================================================================
> --- linux-pm.orig/drivers/gpio/gpio-zynq.c
> +++ linux-pm/drivers/gpio/gpio-zynq.c
> @@ -578,7 +578,7 @@ static void zynq_gpio_free(struct gpio_c
>
>  static const struct dev_pm_ops zynq_gpio_dev_pm_ops = {
>         SET_SYSTEM_SLEEP_PM_OPS(zynq_gpio_suspend, zynq_gpio_resume)
> -       SET_PM_RUNTIME_PM_OPS(zynq_gpio_runtime_suspend,
> +       SET_RUNTIME_PM_OPS(zynq_gpio_runtime_suspend,
>                         zynq_gpio_runtime_resume, NULL)
>  };
>
> Index: linux-pm/drivers/i2c/busses/i2c-hix5hd2.c
> ===================================================================
> --- linux-pm.orig/drivers/i2c/busses/i2c-hix5hd2.c
> +++ linux-pm/drivers/i2c/busses/i2c-hix5hd2.c
> @@ -528,7 +528,7 @@ static int hix5hd2_i2c_runtime_resume(st
>  #endif
>
>  static const struct dev_pm_ops hix5hd2_i2c_pm_ops = {
> -       SET_PM_RUNTIME_PM_OPS(hix5hd2_i2c_runtime_suspend,
> +       SET_RUNTIME_PM_OPS(hix5hd2_i2c_runtime_suspend,
>                               hix5hd2_i2c_runtime_resume,
>                               NULL)
>  };
> Index: linux-pm/drivers/i2c/busses/i2c-nomadik.c
> ===================================================================
> --- linux-pm.orig/drivers/i2c/busses/i2c-nomadik.c
> +++ linux-pm/drivers/i2c/busses/i2c-nomadik.c
> @@ -932,7 +932,7 @@ static int nmk_i2c_runtime_resume(struct
>
>  static const struct dev_pm_ops nmk_i2c_pm = {
>         SET_LATE_SYSTEM_SLEEP_PM_OPS(nmk_i2c_suspend_late, nmk_i2c_resume_early)
> -       SET_PM_RUNTIME_PM_OPS(nmk_i2c_runtime_suspend,
> +       SET_RUNTIME_PM_OPS(nmk_i2c_runtime_suspend,
>                         nmk_i2c_runtime_resume,
>                         NULL)
>  };
> Index: linux-pm/drivers/mmc/host/mmci.c
> ===================================================================
> --- linux-pm.orig/drivers/mmc/host/mmci.c
> +++ linux-pm/drivers/mmc/host/mmci.c
> @@ -1843,7 +1843,7 @@ static int mmci_runtime_resume(struct de
>  static const struct dev_pm_ops mmci_dev_pm_ops = {
>         SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
>                                 pm_runtime_force_resume)
> -       SET_PM_RUNTIME_PM_OPS(mmci_runtime_suspend, mmci_runtime_resume, NULL)
> +       SET_RUNTIME_PM_OPS(mmci_runtime_suspend, mmci_runtime_resume, NULL)
>  };
>
>  static struct amba_id mmci_ids[] = {
> Index: linux-pm/drivers/mmc/host/sh_mobile_sdhi.c
> ===================================================================
> --- linux-pm.orig/drivers/mmc/host/sh_mobile_sdhi.c
> +++ linux-pm/drivers/mmc/host/sh_mobile_sdhi.c
> @@ -375,7 +375,7 @@ static int sh_mobile_sdhi_remove(struct
>  static const struct dev_pm_ops tmio_mmc_dev_pm_ops = {
>         SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
>                         pm_runtime_force_resume)
> -       SET_PM_RUNTIME_PM_OPS(tmio_mmc_host_runtime_suspend,
> +       SET_RUNTIME_PM_OPS(tmio_mmc_host_runtime_suspend,
>                         tmio_mmc_host_runtime_resume,
>                         NULL)
>  };
> Index: linux-pm/drivers/mmc/host/tmio_mmc.c
> ===================================================================
> --- linux-pm.orig/drivers/mmc/host/tmio_mmc.c
> +++ linux-pm/drivers/mmc/host/tmio_mmc.c
> @@ -135,7 +135,7 @@ static int tmio_mmc_remove(struct platfo
>
>  static const struct dev_pm_ops tmio_mmc_dev_pm_ops = {
>         SET_SYSTEM_SLEEP_PM_OPS(tmio_mmc_suspend, tmio_mmc_resume)
> -       SET_PM_RUNTIME_PM_OPS(tmio_mmc_host_runtime_suspend,
> +       SET_RUNTIME_PM_OPS(tmio_mmc_host_runtime_suspend,
>                         tmio_mmc_host_runtime_resume,
>                         NULL)
>  };
> Index: linux-pm/drivers/spi/spi-pl022.c
> ===================================================================
> --- linux-pm.orig/drivers/spi/spi-pl022.c
> +++ linux-pm/drivers/spi/spi-pl022.c
> @@ -2377,7 +2377,7 @@ static int pl022_runtime_resume(struct d
>
>  static const struct dev_pm_ops pl022_dev_pm_ops = {
>         SET_SYSTEM_SLEEP_PM_OPS(pl022_suspend, pl022_resume)
> -       SET_PM_RUNTIME_PM_OPS(pl022_runtime_suspend, pl022_runtime_resume, NULL)
> +       SET_RUNTIME_PM_OPS(pl022_runtime_suspend, pl022_runtime_resume, NULL)
>  };
>
>  static struct vendor_data vendor_arm = {
> Index: linux-pm/include/linux/pm.h
> ===================================================================
> --- linux-pm.orig/include/linux/pm.h
> +++ linux-pm/include/linux/pm.h
> @@ -342,7 +342,7 @@ struct dev_pm_ops {
>  #define SET_LATE_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
>  #endif
>
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  #define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
>         .runtime_suspend = suspend_fn, \
>         .runtime_resume = resume_fn, \
> @@ -351,15 +351,6 @@ struct dev_pm_ops {
>  #define SET_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn)
>  #endif
>
> -#ifdef CONFIG_PM
> -#define SET_PM_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn) \
> -       .runtime_suspend = suspend_fn, \
> -       .runtime_resume = resume_fn, \
> -       .runtime_idle = idle_fn,
> -#else
> -#define SET_PM_RUNTIME_PM_OPS(suspend_fn, resume_fn, idle_fn)
> -#endif
> -
>  /*
>   * Use this if you want to use the same suspend and resume callbacks for suspend
>   * to RAM and hibernation.
>
