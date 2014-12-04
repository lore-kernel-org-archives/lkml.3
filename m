Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035AbaLDSIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:08:49 -0500
Received: from lists.s-osg.org ([54.187.51.154]:39268 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932678AbaLDSIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:08:47 -0500
Date: Thu, 4 Dec 2014 16:08:40 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-media@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Kamil Debski <k.debski@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Message-ID: <20141204160840.7d021bf1@recife.lan>
In-Reply-To: <4139875.fkJ48z9AaU@vostro.rjw.lan>
References: <4139875.fkJ48z9AaU@vostro.rjw.lan>
Organization: Samsung
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 03 Dec 2014 03:13:55 +0100
"Rafael J. Wysocki" <rjw@rjwysocki.net> escreveu:

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> The alternative of CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME may be
> replaced with CONFIG_PM too.
> 
> Make these changes everywhere under drivers/media/.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Feel free to apply it via your tree.

PS.: I won't doubt that you would find some extra checks for
PM_RUNTIME on other places at media, as I remember I merged some
things like that recently - I think they are there for 3.19, but
it needs to be double-checked.

Regards,
Mauro

> ---
> 
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.
> 
> ---
>  drivers/media/platform/coda/coda-common.c       |    4 ++--
>  drivers/media/platform/exynos4-is/fimc-core.c   |    6 +++---
>  drivers/media/platform/exynos4-is/fimc-is-i2c.c |    2 +-
>  drivers/media/platform/exynos4-is/fimc-lite.c   |    2 +-
>  drivers/media/platform/exynos4-is/mipi-csis.c   |    2 +-
>  drivers/media/platform/s5p-jpeg/jpeg-core.c     |    4 ++--
>  drivers/media/platform/s5p-mfc/s5p_mfc.c        |    2 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_pm.c     |   10 ++++------
>  8 files changed, 15 insertions(+), 17 deletions(-)
> 
> Index: linux-pm/drivers/media/platform/s5p-jpeg/jpeg-core.c
> ===================================================================
> --- linux-pm.orig/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ linux-pm/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -2632,7 +2632,7 @@ static int s5p_jpeg_remove(struct platfo
>  	return 0;
>  }
>  
> -#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
> +#ifdef CONFIG_PM
>  static int s5p_jpeg_runtime_suspend(struct device *dev)
>  {
>  	struct s5p_jpeg *jpeg = dev_get_drvdata(dev);
> @@ -2682,7 +2682,7 @@ static int s5p_jpeg_runtime_resume(struc
>  
>  	return 0;
>  }
> -#endif /* CONFIG_PM_RUNTIME || CONFIG_PM_SLEEP */
> +#endif /* CONFIG_PM */
>  
>  #ifdef CONFIG_PM_SLEEP
>  static int s5p_jpeg_suspend(struct device *dev)
> Index: linux-pm/drivers/media/platform/s5p-mfc/s5p_mfc.c
> ===================================================================
> --- linux-pm.orig/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ linux-pm/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -1302,7 +1302,7 @@ static int s5p_mfc_resume(struct device
>  }
>  #endif
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int s5p_mfc_runtime_suspend(struct device *dev)
>  {
>  	struct platform_device *pdev = to_platform_device(dev);
> Index: linux-pm/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
> ===================================================================
> --- linux-pm.orig/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
> +++ linux-pm/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
> @@ -13,9 +13,7 @@
>  #include <linux/clk.h>
>  #include <linux/err.h>
>  #include <linux/platform_device.h>
> -#ifdef CONFIG_PM_RUNTIME
>  #include <linux/pm_runtime.h>
> -#endif
>  #include "s5p_mfc_common.h"
>  #include "s5p_mfc_debug.h"
>  #include "s5p_mfc_pm.h"
> @@ -67,7 +65,7 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *
>  	}
>  
>  	atomic_set(&pm->power, 0);
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  	pm->device = &dev->plat_dev->dev;
>  	pm_runtime_enable(pm->device);
>  #endif
> @@ -93,7 +91,7 @@ void s5p_mfc_final_pm(struct s5p_mfc_dev
>  	}
>  	clk_unprepare(pm->clock_gate);
>  	clk_put(pm->clock_gate);
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  	pm_runtime_disable(pm->device);
>  #endif
>  }
> @@ -120,7 +118,7 @@ void s5p_mfc_clock_off(void)
>  
>  int s5p_mfc_power_on(void)
>  {
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  	return pm_runtime_get_sync(pm->device);
>  #else
>  	atomic_set(&pm->power, 1);
> @@ -130,7 +128,7 @@ int s5p_mfc_power_on(void)
>  
>  int s5p_mfc_power_off(void)
>  {
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  	return pm_runtime_put_sync(pm->device);
>  #else
>  	atomic_set(&pm->power, 0);
> Index: linux-pm/drivers/media/platform/exynos4-is/fimc-is-i2c.c
> ===================================================================
> --- linux-pm.orig/drivers/media/platform/exynos4-is/fimc-is-i2c.c
> +++ linux-pm/drivers/media/platform/exynos4-is/fimc-is-i2c.c
> @@ -81,7 +81,7 @@ static int fimc_is_i2c_remove(struct pla
>  	return 0;
>  }
>  
> -#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
> +#ifdef CONFIG_PM
>  static int fimc_is_i2c_runtime_suspend(struct device *dev)
>  {
>  	struct fimc_is_i2c *isp_i2c = dev_get_drvdata(dev);
> Index: linux-pm/drivers/media/platform/exynos4-is/fimc-lite.c
> ===================================================================
> --- linux-pm.orig/drivers/media/platform/exynos4-is/fimc-lite.c
> +++ linux-pm/drivers/media/platform/exynos4-is/fimc-lite.c
> @@ -1588,7 +1588,7 @@ err_clk_put:
>  	return ret;
>  }
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int fimc_lite_runtime_resume(struct device *dev)
>  {
>  	struct fimc_lite *fimc = dev_get_drvdata(dev);
> Index: linux-pm/drivers/media/platform/exynos4-is/mipi-csis.c
> ===================================================================
> --- linux-pm.orig/drivers/media/platform/exynos4-is/mipi-csis.c
> +++ linux-pm/drivers/media/platform/exynos4-is/mipi-csis.c
> @@ -978,7 +978,7 @@ static int s5pcsis_resume(struct device
>  }
>  #endif
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int s5pcsis_runtime_suspend(struct device *dev)
>  {
>  	return s5pcsis_pm_suspend(dev, true);
> Index: linux-pm/drivers/media/platform/exynos4-is/fimc-core.c
> ===================================================================
> --- linux-pm.orig/drivers/media/platform/exynos4-is/fimc-core.c
> +++ linux-pm/drivers/media/platform/exynos4-is/fimc-core.c
> @@ -832,7 +832,7 @@ err:
>  	return -ENXIO;
>  }
>  
> -#if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
> +#ifdef CONFIG_PM
>  static int fimc_m2m_suspend(struct fimc_dev *fimc)
>  {
>  	unsigned long flags;
> @@ -871,7 +871,7 @@ static int fimc_m2m_resume(struct fimc_d
>  
>  	return 0;
>  }
> -#endif /* CONFIG_PM_RUNTIME || CONFIG_PM_SLEEP */
> +#endif /* CONFIG_PM */
>  
>  static const struct of_device_id fimc_of_match[];
>  
> @@ -1039,7 +1039,7 @@ err_sclk:
>  	return ret;
>  }
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int fimc_runtime_resume(struct device *dev)
>  {
>  	struct fimc_dev *fimc =	dev_get_drvdata(dev);
> Index: linux-pm/drivers/media/platform/coda/coda-common.c
> ===================================================================
> --- linux-pm.orig/drivers/media/platform/coda/coda-common.c
> +++ linux-pm/drivers/media/platform/coda/coda-common.c
> @@ -1980,7 +1980,7 @@ static int coda_probe(struct platform_de
>  
>  	/*
>  	 * Start activated so we can directly call coda_hw_init in
> -	 * coda_fw_callback regardless of whether CONFIG_PM_RUNTIME is
> +	 * coda_fw_callback regardless of whether CONFIG_PM is
>  	 * enabled or whether the device is associated with a PM domain.
>  	 */
>  	pm_runtime_get_noresume(&pdev->dev);
> @@ -2013,7 +2013,7 @@ static int coda_remove(struct platform_d
>  	return 0;
>  }
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int coda_runtime_resume(struct device *dev)
>  {
>  	struct coda_dev *cdev = dev_get_drvdata(dev);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
