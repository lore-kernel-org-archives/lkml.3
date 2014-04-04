Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaDDN5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 09:57:39 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:46687 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbaDDN5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 09:57:37 -0400
MIME-Version: 1.0
In-Reply-To: <1396618417-9560-1-git-send-email-gautam.vivek@samsung.com>
References: <1396618417-9560-1-git-send-email-gautam.vivek@samsung.com>
Date: Fri, 4 Apr 2014 19:27:36 +0530
Message-ID: <CAFp+6iGwMhQT=atd_u0-qA-cEnnwPMHkOEB=9ooqtPOj8QOcvg@mail.gmail.com>
Subject: Re: [PATCH] usb: ohci-exynos: Remove locks for 'ohci' in suspend callback
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Manjunath Goudar <csmanjuvijay@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 7:03 PM, Vivek Gautam <gautamvivek1987@gmail.com> wrote:
> Patch : 14982e3 USB: OHCI: Properly handle ohci-exynos suspend
> has already removed 'ohci_hcd' settings from exynos glue layer
> as a part of streamlining the ohci controller's suspend.
> So we don't need the locks for 'ohci_hcd' anymore.
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Cc: Manjunath Goudar <csmanjuvijay@gmail.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> ---

Please ignore this patch, WIP, got sent by mistake :-(
Sorry for spamming.

>  drivers/usb/host/ohci-exynos.c |    4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> index 68588d8..7f5e779 100644
> --- a/drivers/usb/host/ohci-exynos.c
> +++ b/drivers/usb/host/ohci-exynos.c
> @@ -199,8 +199,6 @@ static int exynos_ohci_suspend(struct device *dev)
>         if (rc)
>                 return rc;
>
> -       spin_lock_irqsave(&ohci->lock, flags);
> -
>         if (exynos_ohci->otg)
>                 exynos_ohci->otg->set_host(exynos_ohci->otg, &hcd->self);
>
> @@ -208,8 +206,6 @@ static int exynos_ohci_suspend(struct device *dev)
>
>         clk_disable_unprepare(exynos_ohci->clk);
>
> -       spin_unlock_irqrestore(&ohci->lock, flags);
> -
>         return 0;
>  }
>
> --
> 1.7.10.4
>



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
