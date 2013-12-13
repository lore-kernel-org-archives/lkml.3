Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab3LMBqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 20:46:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:65080 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761Ab3LMBqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 20:46:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,476,1384329600"; 
   d="scan'208";a="449283766"
Date: Thu, 12 Dec 2013 17:51:33 -0800
From: David Cohen <david.a.cohen@linux.intel.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] usb: host: xhci: Move suspend ops under PM_SLEEP to
 avoid warning
Message-ID: <20131213015133.GA29964@psi-dev26.jf.intel.com>
References: <1386896784-23916-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386896784-23916-1-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 08:06:24PM -0500, Santosh Shilimkar wrote:
> Otherwise you get below build warnings
> 
> drivers/usb/host/xhci-plat.c:201:12: warning: ‘xhci_plat_suspend’ defined but not used [-Wunused-function]
> drivers/usb/host/xhci-plat.c:209:12: warning: ‘xhci_plat_resume’ defined but not used [-Wunused-function]
> 
> Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>  drivers/usb/host/xhci-plat.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
> index d9c169f..4875be5 100644
> --- a/drivers/usb/host/xhci-plat.c
> +++ b/drivers/usb/host/xhci-plat.c
> @@ -197,7 +197,7 @@ static int xhci_plat_remove(struct platform_device *dev)
>  	return 0;
>  }
>  
> -#ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP

Can't you just remove these #ifdefs altogether?
xhci_plat_pm_ops is set using SET_SYSTEM_SLEEP_PM_OPS() macro which
already handles '#ifdef CONFIG_PM_SLEEP' case.

>  static int xhci_plat_suspend(struct device *dev)
>  {
>  	struct usb_hcd	*hcd = dev_get_drvdata(dev);
> @@ -220,7 +220,7 @@ static const struct dev_pm_ops xhci_plat_pm_ops = {
>  #define DEV_PM_OPS	(&xhci_plat_pm_ops)
>  #else
>  #define DEV_PM_OPS	NULL
> -#endif /* CONFIG_PM */
> +#endif /* CONFIG_PM_SLEEP */

Ditto.

Br, David Cohen

>  
>  #ifdef CONFIG_OF
>  static const struct of_device_id usb_xhci_of_match[] = {
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
