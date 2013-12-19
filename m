Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3LSQiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:38:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab3LSQiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:38:19 -0500
Date: Thu, 19 Dec 2013 08:38:21 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Denis Turischev <denis.turischev@compulab.co.il>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: xhci: Switch Intel Lynx Point ports to EHCI on shutdown
Message-ID: <20131219163821.GA27409@kroah.com>
References: <52B31EDA.60908@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B31EDA.60908@compulab.co.il>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 06:29:14PM +0200, Denis Turischev wrote:
> The same issue like with Panther Point chipsets. If the USB ports are
> switched to xHCI on shutdown, the xHCI host will send a spurious interrupt,
> which will wake the system. Some BIOS have work around for this, but not all.
> 
> The bug can be avoided if the USB ports are switched back to EHCI on
> shutdown.
> 
> Signed-off-by: Denis Turischev <denis@compulab.co.il>
> 
> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> --- a/drivers/usb/host/xhci-pci.c	2013-12-19 11:36:12.049589400 +0200
> +++ b/drivers/usb/host/xhci-pci.c	2013-12-19 11:37:27.261590385 +0200
> @@ -91,8 +91,9 @@
>  		xhci->quirks |= XHCI_LPM_SUPPORT;
>  		xhci->quirks |= XHCI_INTEL_HOST;
>  	}
> -	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
> -			pdev->device == PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI) {
> +	if (pdev->vendor == PCI_VENDOR_ID_INTEL && (
> +			(pdev->device == PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI) ||
> +			(pdev->device == PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI))) {
>  		xhci->quirks |= XHCI_EP_LIMIT_QUIRK;
>  		xhci->limit_active_eps = 64;
>  		xhci->quirks |= XHCI_SW_BW_CHECKING;
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> --- a/include/linux/pci_ids.h	2013-12-19 11:36:11.945589398 +0200
> +++ b/include/linux/pci_ids.h	2013-12-19 11:35:57.817589213 +0200
> @@ -2576,6 +2576,7 @@
>  #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX	0x1c5f
>  #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_0	0x1d40
>  #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_1	0x1d41
> +#define PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI	0x9c31

Please read the top of this file for why to not add new device ids to
it.

And if you really need to do so, please do it in sorted order:

>  #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI	0x1e31
>  #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MIN	0x1e40
>  #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MAX	0x1e5f

Which you didn't do :(

greg k-h
