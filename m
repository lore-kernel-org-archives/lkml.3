Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaLDIhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:37:36 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34763 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbaLDIhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:37:35 -0500
Date: Thu, 4 Dec 2014 08:37:30 +0000
From: Lee Jones <lee.jones@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] MFD / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Message-ID: <20141204083730.GG327@x1>
References: <2857906.7ft1XTNUKe@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2857906.7ft1XTNUKe@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Dec 2014, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> Replace CONFIG_PM_RUNTIME with CONFIG_PM everywhere under
> drivers/mfd/.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.

It's okay to take the patch.

Acked-by: Lee Jones <lee.jones@linaro.org>

> ---
>  drivers/mfd/ab8500-gpadc.c |    2 +-
>  drivers/mfd/arizona-core.c |    4 ++--
>  drivers/mfd/wm8994-core.c  |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> Index: linux-pm/drivers/mfd/ab8500-gpadc.c
> ===================================================================
> --- linux-pm.orig/drivers/mfd/ab8500-gpadc.c
> +++ linux-pm/drivers/mfd/ab8500-gpadc.c
> @@ -867,7 +867,7 @@ static void ab8500_gpadc_read_calibratio
>  		gpadc->cal_data[ADC_INPUT_VBAT].offset);
>  }
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int ab8500_gpadc_runtime_suspend(struct device *dev)
>  {
>  	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
> Index: linux-pm/drivers/mfd/wm8994-core.c
> ===================================================================
> --- linux-pm.orig/drivers/mfd/wm8994-core.c
> +++ linux-pm/drivers/mfd/wm8994-core.c
> @@ -116,7 +116,7 @@ static const char *wm8958_main_supplies[
>  	"SPKVDD2",
>  };
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int wm8994_suspend(struct device *dev)
>  {
>  	struct wm8994 *wm8994 = dev_get_drvdata(dev);
> Index: linux-pm/drivers/mfd/arizona-core.c
> ===================================================================
> --- linux-pm.orig/drivers/mfd/arizona-core.c
> +++ linux-pm/drivers/mfd/arizona-core.c
> @@ -330,7 +330,7 @@ err_fll:
>  		return err;
>  }
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int arizona_runtime_resume(struct device *dev)
>  {
>  	struct arizona *arizona = dev_get_drvdata(dev);
> @@ -1024,7 +1024,7 @@ int arizona_dev_init(struct arizona *ari
>  		goto err_irq;
>  	}
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  	regulator_disable(arizona->dcvdd);
>  #endif
>  
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
