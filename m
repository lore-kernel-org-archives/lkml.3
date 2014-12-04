Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaLDD6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 22:58:08 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:41865 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaLDD6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 22:58:07 -0500
Date: Thu, 4 Dec 2014 12:58:00 +0900
From: Simon Horman <horms@verge.net.au>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: sh / PM: Replace CONFIG_PM_RUNTIME with
 CONFIG_PM
Message-ID: <20141204035758.GA6346@verge.net.au>
References: <3463511.sXIeyHdjYI@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3463511.sXIeyHdjYI@vostro.rjw.lan>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 02:24:22AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so #ifdef blocks
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
> 
> Replace CONFIG_PM_RUNTIME with CONFIG_PM in drivers/sh/pm_runtime.c.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
> 
> Please let me know if it is OK to take this one into linux-pm.

Hi Rafael,

That is fine by me if it is fine by Geert.

Acked-by: Simon Horman <horms+renesas@verge.net.au>

> 
> ---
>  drivers/sh/pm_runtime.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-pm/drivers/sh/pm_runtime.c
> ===================================================================
> --- linux-pm.orig/drivers/sh/pm_runtime.c
> +++ linux-pm/drivers/sh/pm_runtime.c
> @@ -20,7 +20,7 @@
>  #include <linux/bitmap.h>
>  #include <linux/slab.h>
>  
> -#ifdef CONFIG_PM_RUNTIME
> +#ifdef CONFIG_PM
>  static int sh_pm_runtime_suspend(struct device *dev)
>  {
>  	int ret;
> @@ -68,7 +68,7 @@ static struct dev_pm_domain default_pm_d
>  
>  #define DEFAULT_PM_DOMAIN_PTR	NULL
>  
> -#endif /* CONFIG_PM_RUNTIME */
> +#endif /* CONFIG_PM */
>  
>  static struct pm_clk_notifier_block platform_bus_notifier = {
>  	.pm_domain = DEFAULT_PM_DOMAIN_PTR,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
