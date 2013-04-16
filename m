Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827Ab3DPPa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:30:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42032 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757599Ab3DPPa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:30:58 -0400
Date: Tue, 16 Apr 2013 11:30:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>, <holler@ahsoftware.de>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: ehci-omap: Don't select any PHY driver
In-Reply-To: <1366026636-29198-1-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1304161130380.1391-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013, Roger Quadros wrote:

> Don't select NOP_USB_XCEIV. Instead, board config
> must select USB_PHY and the appropriate PHY driver.
> 
> Also add a hint in Kconfig so that users enabling
> this driver manually enable the right PHY drivers as well.
> 
> Gets rid of the below warnings when USB_EHCI_HCD_OMAP
> is enabled.
> 
> warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unmet direct dependencies (USB_SUPPORT && USB_PHY)
> warning: (USB_EHCI_HCD_OMAP) selects NOP_USB_XCEIV which has unmet direct dependencies (USB_SUPPORT && USB_PHY)
> 
> CC: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/usb/host/Kconfig |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index c0be25c..c558472 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -150,11 +150,13 @@ config USB_EHCI_MXC
>  config USB_EHCI_HCD_OMAP
>  	tristate "EHCI support for OMAP3 and later chips"
>  	depends on ARCH_OMAP
> -	select NOP_USB_XCEIV
>  	default y
>  	---help---
>  	  Enables support for the on-chip EHCI controller on
>  	  OMAP3 and later chips.
> +	  If your system uses a PHY on the USB port, you will need to
> +	  enable USB_PHY and the appropriate PHY driver as well. Most
> +	  boards need the NOP_USB_XCEIV PHY driver.
>  
>  config USB_EHCI_HCD_ORION
>  	tristate  "Support for Marvell EBU on-chip EHCI USB controller"

Acked-by: Alan Stern <stern@rowland.harvard.edu>

