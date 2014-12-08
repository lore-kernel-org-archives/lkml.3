Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaLHISz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:18:55 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33808 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbaLHISw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:18:52 -0500
Message-ID: <54855EE4.7040104@ti.com>
Date: Mon, 8 Dec 2014 13:48:44 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@kernel.org>
Subject: Re: [PATCH] phy / PM: Replace CONFIG_PM_RUNTIME with CONFIG_PM
References: <2122955.8tCSpWHocD@vostro.rjw.lan>
In-Reply-To: <2122955.8tCSpWHocD@vostro.rjw.lan>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Saturday 06 December 2014 08:09 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> Replace CONFIG_PM_RUNTIME with CONFIG_PM everywhere under
> drivers/phy/.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.

Sure.

Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> 
> ---
>  drivers/phy/phy-omap-usb2.c |    2 +-
>  drivers/phy/phy-ti-pipe3.c  |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-pm/drivers/phy/phy-omap-usb2.c
> ===================================================================
> --- linux-pm.orig/drivers/phy/phy-omap-usb2.c
> +++ linux-pm/drivers/phy/phy-omap-usb2.c
> @@ -322,7 +322,7 @@ static int omap_usb2_remove(struct platf
>  	return 0;
>  }
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  
>  static int omap_usb2_runtime_suspend(struct device *dev)
>  {
> Index: linux-pm/drivers/phy/phy-ti-pipe3.c
> ===================================================================
> --- linux-pm.orig/drivers/phy/phy-ti-pipe3.c
> +++ linux-pm/drivers/phy/phy-ti-pipe3.c
> @@ -423,7 +423,7 @@ static int ti_pipe3_remove(struct platfo
>  	return 0;
>  }
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  
>  static int ti_pipe3_runtime_suspend(struct device *dev)
>  {
> 
