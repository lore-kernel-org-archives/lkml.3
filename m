Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030509AbaDJP1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 11:27:46 -0400
Received: from netrider.rowland.org ([192.131.102.5]:50258 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030458AbaDJP1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 11:27:44 -0400
Date: Thu, 10 Apr 2014 11:27:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Vivek Gautam <gautam.vivek@samsung.com>
cc: linux-usb@vger.kernel.org, <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <kgene.kim@samsung.com>,
        <jg1.han@samsung.com>
Subject: Re: [PATCH v2 1/2] usb: ehci-exynos: Return immediately from suspend
 if ehci_suspend fails
In-Reply-To: <1397125682-4955-1-git-send-email-gautam.vivek@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1404101127270.32351-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014, Vivek Gautam wrote:

> Patch 'b8efdaf USB: EHCI: add check for wakeup/suspend race'
> adds a check for possible race between suspend and wakeup interrupt,
> and thereby it returns -EBUSY as error code if there's a wakeup
> interrupt.
> So the platform host controller should not proceed further with
> its suspend callback, rather should return immediately to avoid
> powering down the essential things, like phy.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> ---
> 
> Changes from v1:
> -- Removed unnecessary change 'return 0'
> 
>  drivers/usb/host/ehci-exynos.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
> index d1d8c47..7f425ac 100644
> --- a/drivers/usb/host/ehci-exynos.c
> +++ b/drivers/usb/host/ehci-exynos.c
> @@ -212,6 +212,8 @@ static int exynos_ehci_suspend(struct device *dev)
>  	int rc;
>  
>  	rc = ehci_suspend(hcd, do_wakeup);
> +	if (rc)
> +		return rc;
>  
>  	if (exynos_ehci->otg)
>  		exynos_ehci->otg->set_host(exynos_ehci->otg, &hcd->self);

Acked-by: Alan Stern <stern@rowland.harvard.edu>

