Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3FEXwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 19:52:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:23404 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab3FEXwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 19:52:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,810,1363158000"; 
   d="scan'208";a="348789249"
Date: Wed, 5 Jun 2013 16:52:52 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Alex Shi <alex.shi@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gregkh <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] usb/xhci: unify parameter of xhci_msi_irq
Message-ID: <20130605235252.GD4790@xanatos>
References: <519ED65B.7040707@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519ED65B.7040707@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, after a brief glance, this looks fine.  I've queued it to my
usb-next branch, and it should go to Greg by next week.

Sarah Sharp

On Fri, May 24, 2013 at 10:54:19AM +0800, Alex Shi wrote:
> 
> Ops, I just find a old patch left on my laptop. and it still works on latest
> Linus tree. I don't remember there is a reasonable excuse to reject this patch.
> 
> So, anyone like to pick it up?
> 
> ------
> From 6ae1b9e71f9b14be5774ae9c1b4cf57cd4e747ac Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@intel.com>
> Date: Mon, 11 Jun 2012 15:10:18 +0800
> Subject: [PATCH] usb/xhci: unify parameter of xhci_msi_irq
> 
> According to Felipe and Alan's comments the second parameter of irq
> handler should be 'void *' not a specific structure pointer.
> So change it.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/usb/host/xhci-ring.c |    2 +-
>  drivers/usb/host/xhci.c      |    4 ++--
>  drivers/usb/host/xhci.h      |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
> index 23b4aef..cc8a52f 100644
> --- a/drivers/usb/host/xhci-ring.c
> +++ b/drivers/usb/host/xhci-ring.c
> @@ -2479,7 +2479,7 @@ hw_died:
>  	return IRQ_HANDLED;
>  }
>  
> -irqreturn_t xhci_msi_irq(int irq, struct usb_hcd *hcd)
> +irqreturn_t xhci_msi_irq(int irq, void *hcd)
>  {
>  	return xhci_irq(hcd);
>  }
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index afdc73e..f7d40c1 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -215,7 +215,7 @@ static int xhci_setup_msi(struct xhci_hcd *xhci)
>  		return ret;
>  	}
>  
> -	ret = request_irq(pdev->irq, (irq_handler_t)xhci_msi_irq,
> +	ret = request_irq(pdev->irq, xhci_msi_irq,
>  				0, "xhci_hcd", xhci_to_hcd(xhci));
>  	if (ret) {
>  		xhci_dbg(xhci, "disable MSI interrupt\n");
> @@ -287,7 +287,7 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
>  
>  	for (i = 0; i < xhci->msix_count; i++) {
>  		ret = request_irq(xhci->msix_entries[i].vector,
> -				(irq_handler_t)xhci_msi_irq,
> +				xhci_msi_irq,
>  				0, "xhci_hcd", xhci_to_hcd(xhci));
>  		if (ret)
>  			goto disable_msix;
> diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
> index de3d6e3..737ef54 100644
> --- a/drivers/usb/host/xhci.h
> +++ b/drivers/usb/host/xhci.h
> @@ -1710,7 +1710,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated);
>  
>  int xhci_get_frame(struct usb_hcd *hcd);
>  irqreturn_t xhci_irq(struct usb_hcd *hcd);
> -irqreturn_t xhci_msi_irq(int irq, struct usb_hcd *hcd);
> +irqreturn_t xhci_msi_irq(int irq, void *hcd);
>  int xhci_alloc_dev(struct usb_hcd *hcd, struct usb_device *udev);
>  void xhci_free_dev(struct usb_hcd *hcd, struct usb_device *udev);
>  int xhci_alloc_tt_info(struct xhci_hcd *xhci,
> -- 
> 1.7.5.4
> 
> -- 
> Thanks
>     Alex
