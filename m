Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281AbaBRSyT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:54:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:38802 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbaBRSyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:54:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,502,1389772800"; 
   d="scan'208";a="457573354"
Date: Tue, 18 Feb 2014 10:54:17 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Denis Turischev <denis.turischev@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RESEND] [PATCH] xhci: Switch Intel Lynx Point ports to EHCI on
 shutdown.
Message-ID: <20140218185417.GD7395@xanatos>
References: <52B31EDA.60908@compulab.co.il>
 <52F0CAB8.20803@compulab.co.il>
 <53030EEF.7090708@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53030EEF.7090708@compulab.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay in reviewing this.  It helps me if you don't make the
patch in-reply-to a months old thread. :)  I'll take a look at this
shortly.

Sarah Sharp

On Tue, Feb 18, 2014 at 09:42:39AM +0200, Denis Turischev wrote:
> The same issue like with Panther Point chipsets. If the USB ports are
> switched to xHCI on shutdown, the xHCI host will send a spurious interrupt,
> which will wake the system. Some BIOS have work around for this, but not all.
> One example is Compulab's mini-desktop, the Intense-PC2.
> 
> The bug can be avoided if the USB ports are switched back to EHCI on
> shutdown.
> 
> Signed-off-by: Denis Turischev <denis@compulab.co.il>
> ---
>  drivers/usb/host/xhci-pci.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> index 3c898c1..9233d12 100644
> --- a/drivers/usb/host/xhci-pci.c
> +++ b/drivers/usb/host/xhci-pci.c
> @@ -134,6 +134,8 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
>  		 */
>  		if (pdev->subsystem_vendor == PCI_VENDOR_ID_HP)
>  			xhci->quirks |= XHCI_SPURIOUS_WAKEUP;
> +
> +		xhci->quirks |= XHCI_SPURIOUS_REBOOT;
>  	}
>  	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
>  			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
> -- 1.8.1.2
> 
> 
