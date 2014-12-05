Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbaLEObx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:31:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:30248 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbaLEObv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:31:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="425537526"
Date: Fri, 5 Dec 2014 20:02:18 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: dmaengine@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DMA / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
Message-ID: <20141205143218.GH3411@intel.com>
References: <2237445.kkHAuggnGG@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2237445.kkHAuggnGG@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 02:44:08AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> Replace CONFIG_PM_RUNTIME with CONFIG_PM in drivers/dma/nbpfaxi.c
> and drivers/dma/tegra20-apb-dma.c.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
With change of patch title to dmaengine (we dont use DMA for dmaengine
subsystem patches)
Acked-by: Vinod Koul <vinod.koul@intel.com>

-- 
~Vinod

> ---
> 
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.
> 
> ---
>  drivers/dma/nbpfaxi.c         |    2 +-
>  drivers/dma/tegra20-apb-dma.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-pm/drivers/dma/nbpfaxi.c
> ===================================================================
> --- linux-pm.orig/drivers/dma/nbpfaxi.c
> +++ linux-pm/drivers/dma/nbpfaxi.c
> @@ -1479,7 +1479,7 @@ static struct platform_device_id nbpf_id
>  };
>  MODULE_DEVICE_TABLE(platform, nbpf_ids);
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int nbpf_runtime_suspend(struct device *dev)
>  {
>  	struct nbpf_device *nbpf = platform_get_drvdata(to_platform_device(dev));
> Index: linux-pm/drivers/dma/tegra20-apb-dma.c
> ===================================================================
> --- linux-pm.orig/drivers/dma/tegra20-apb-dma.c
> +++ linux-pm/drivers/dma/tegra20-apb-dma.c
> @@ -1587,7 +1587,7 @@ static int tegra_dma_pm_resume(struct de
>  #endif
>  
>  static const struct dev_pm_ops tegra_dma_dev_pm_ops = {
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  	.runtime_suspend = tegra_dma_runtime_suspend,
>  	.runtime_resume = tegra_dma_runtime_resume,
>  #endif
> 

-- 
