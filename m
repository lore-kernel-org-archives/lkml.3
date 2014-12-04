Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaLDKMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:12:21 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:62863 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbaLDKMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:12:15 -0500
MIME-Version: 1.0
In-Reply-To: <14058791.TAS1lQ00cW@vostro.rjw.lan>
References: <14058791.TAS1lQ00cW@vostro.rjw.lan>
Date: Thu, 4 Dec 2014 11:12:14 +0100
Message-ID: <CAPDyKFrkfg5mQR8GGVoSPdeuO=pjRxed=aVmtqiAE5=huHLGWg@mail.gmail.com>
Subject: Re: [PATCH] MMC / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
From: Ulf Hansson <ulf.hansson@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        Ben Dooks <ben-linux@fluff.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 December 2014 at 02:12, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
>
> Replace CONFIG_PM_RUNTIME with CONFIG_PM everywhere under
> drivers/misc/.

drivers/mmc

>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
>
> Please let me know if it is OK to take this one into linux-pm.

Please go ahead! I have also tried to apply it on my next branch for
my mmc tree, there are no conflicts.

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

>
> ---
>  drivers/mmc/core/bus.c             |    4 ++--
>  drivers/mmc/host/sdhci-acpi.c      |    2 +-
>  drivers/mmc/host/sdhci-esdhc-imx.c |    4 ++--
>  drivers/mmc/host/sdhci-pci.c       |   18 +++++++-----------
>  drivers/mmc/host/sdhci-pxav3.c     |    2 +-
>  drivers/mmc/host/sdhci-s3c.c       |    6 +++---
>  drivers/mmc/host/sdhci.c           |    7 ++-----
>  drivers/mmc/host/sdhci.h           |    3 ---
>  8 files changed, 18 insertions(+), 28 deletions(-)
>
> Index: linux-pm/drivers/mmc/core/bus.c
> ===================================================================
> --- linux-pm.orig/drivers/mmc/core/bus.c
> +++ linux-pm/drivers/mmc/core/bus.c
> @@ -179,7 +179,7 @@ static int mmc_bus_resume(struct device
>  }
>  #endif
>
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int mmc_runtime_suspend(struct device *dev)
>  {
>         struct mmc_card *card = mmc_dev_to_card(dev);
> @@ -195,7 +195,7 @@ static int mmc_runtime_resume(struct dev
>
>         return host->bus_ops->runtime_resume(host);
>  }
> -#endif /* !CONFIG_PM_RUNTIME */
> +#endif /* !CONFIG_PM */
>
>  static const struct dev_pm_ops mmc_bus_pm_ops = {
>         SET_RUNTIME_PM_OPS(mmc_runtime_suspend, mmc_runtime_resume, NULL)
> Index: linux-pm/drivers/mmc/host/sdhci-acpi.c
> ===================================================================
> --- linux-pm.orig/drivers/mmc/host/sdhci-acpi.c
> +++ linux-pm/drivers/mmc/host/sdhci-acpi.c
> @@ -416,7 +416,7 @@ static int sdhci_acpi_resume(struct devi
>
>  #endif
>
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>
>  static int sdhci_acpi_runtime_suspend(struct device *dev)
>  {
> Index: linux-pm/drivers/mmc/host/sdhci-esdhc-imx.c
> ===================================================================
> --- linux-pm.orig/drivers/mmc/host/sdhci-esdhc-imx.c
> +++ linux-pm/drivers/mmc/host/sdhci-esdhc-imx.c
> @@ -1172,7 +1172,7 @@ static int sdhci_esdhc_imx_remove(struct
>         pm_runtime_dont_use_autosuspend(&pdev->dev);
>         pm_runtime_disable(&pdev->dev);
>
> -       if (!IS_ENABLED(CONFIG_PM_RUNTIME)) {
> +       if (!IS_ENABLED(CONFIG_PM)) {
>                 clk_disable_unprepare(imx_data->clk_per);
>                 clk_disable_unprepare(imx_data->clk_ipg);
>                 clk_disable_unprepare(imx_data->clk_ahb);
> @@ -1183,7 +1183,7 @@ static int sdhci_esdhc_imx_remove(struct
>         return 0;
>  }
>
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int sdhci_esdhc_runtime_suspend(struct device *dev)
>  {
>         struct sdhci_host *host = dev_get_drvdata(dev);
> Index: linux-pm/drivers/mmc/host/sdhci-pci.c
> ===================================================================
> --- linux-pm.orig/drivers/mmc/host/sdhci-pci.c
> +++ linux-pm/drivers/mmc/host/sdhci-pci.c
> @@ -134,7 +134,7 @@ static int pch_hc_probe_slot(struct sdhc
>         return 0;
>  }
>
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>
>  static irqreturn_t sdhci_pci_sd_cd(int irq, void *dev_id)
>  {
> @@ -1230,15 +1230,6 @@ static int sdhci_pci_resume(struct devic
>         return 0;
>  }
>
> -#else /* CONFIG_PM */
> -
> -#define sdhci_pci_suspend NULL
> -#define sdhci_pci_resume NULL
> -
> -#endif /* CONFIG_PM */
> -
> -#ifdef CONFIG_PM_RUNTIME
> -
>  static int sdhci_pci_runtime_suspend(struct device *dev)
>  {
>         struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
> @@ -1310,7 +1301,12 @@ static int sdhci_pci_runtime_idle(struct
>         return 0;
>  }
>
> -#endif
> +#else /* CONFIG_PM */
> +
> +#define sdhci_pci_suspend NULL
> +#define sdhci_pci_resume NULL
> +
> +#endif /* CONFIG_PM */
>
>  static const struct dev_pm_ops sdhci_pci_pm_ops = {
>         .suspend = sdhci_pci_suspend,
> Index: linux-pm/drivers/mmc/host/sdhci-pxav3.c
> ===================================================================
> --- linux-pm.orig/drivers/mmc/host/sdhci-pxav3.c
> +++ linux-pm/drivers/mmc/host/sdhci-pxav3.c
> @@ -436,7 +436,7 @@ static int sdhci_pxav3_resume(struct dev
>  }
>  #endif
>
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int sdhci_pxav3_runtime_suspend(struct device *dev)
>  {
>         struct sdhci_host *host = dev_get_drvdata(dev);
> Index: linux-pm/drivers/mmc/host/sdhci-s3c.c
> ===================================================================
> --- linux-pm.orig/drivers/mmc/host/sdhci-s3c.c
> +++ linux-pm/drivers/mmc/host/sdhci-s3c.c
> @@ -609,7 +609,7 @@ static int sdhci_s3c_probe(struct platfo
>                 goto err_req_regs;
>         }
>
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>         if (pdata->cd_type != S3C_SDHCI_CD_INTERNAL)
>                 clk_disable_unprepare(sc->clk_io);
>  #endif
> @@ -635,7 +635,7 @@ static int sdhci_s3c_remove(struct platf
>         if (sc->ext_cd_irq)
>                 free_irq(sc->ext_cd_irq, sc);
>
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>         if (sc->pdata->cd_type != S3C_SDHCI_CD_INTERNAL)
>                 clk_prepare_enable(sc->clk_io);
>  #endif
> @@ -667,7 +667,7 @@ static int sdhci_s3c_resume(struct devic
>  }
>  #endif
>
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int sdhci_s3c_runtime_suspend(struct device *dev)
>  {
>         struct sdhci_host *host = dev_get_drvdata(dev);
> Index: linux-pm/drivers/mmc/host/sdhci.c
> ===================================================================
> --- linux-pm.orig/drivers/mmc/host/sdhci.c
> +++ linux-pm/drivers/mmc/host/sdhci.c
> @@ -56,7 +56,7 @@ static int sdhci_execute_tuning(struct m
>  static void sdhci_tuning_timer(unsigned long data);
>  static void sdhci_enable_preset_value(struct sdhci_host *host, bool enable);
>
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int sdhci_runtime_pm_get(struct sdhci_host *host);
>  static int sdhci_runtime_pm_put(struct sdhci_host *host);
>  static void sdhci_runtime_pm_bus_on(struct sdhci_host *host);
> @@ -2654,9 +2654,6 @@ int sdhci_resume_host(struct sdhci_host
>  }
>
>  EXPORT_SYMBOL_GPL(sdhci_resume_host);
> -#endif /* CONFIG_PM */
> -
> -#ifdef CONFIG_PM_RUNTIME
>
>  static int sdhci_runtime_pm_get(struct sdhci_host *host)
>  {
> @@ -2757,7 +2754,7 @@ int sdhci_runtime_resume_host(struct sdh
>  }
>  EXPORT_SYMBOL_GPL(sdhci_runtime_resume_host);
>
> -#endif
> +#endif /* CONFIG_PM */
>
>  /*****************************************************************************\
>   *                                                                           *
> Index: linux-pm/drivers/mmc/host/sdhci.h
> ===================================================================
> --- linux-pm.orig/drivers/mmc/host/sdhci.h
> +++ linux-pm/drivers/mmc/host/sdhci.h
> @@ -411,9 +411,6 @@ void sdhci_set_uhs_signaling(struct sdhc
>  extern int sdhci_suspend_host(struct sdhci_host *host);
>  extern int sdhci_resume_host(struct sdhci_host *host);
>  extern void sdhci_enable_irq_wakeups(struct sdhci_host *host);
> -#endif
> -
> -#ifdef CONFIG_PM_RUNTIME
>  extern int sdhci_runtime_suspend_host(struct sdhci_host *host);
>  extern int sdhci_runtime_resume_host(struct sdhci_host *host);
>  #endif
>
