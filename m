Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbaEHPrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:47:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42690 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753659AbaEHPro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:47:44 -0400
Date: Thu, 8 May 2014 11:47:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 8/8] usb: ohci-da8xx can only be built-in
In-Reply-To: <1399557141-1346645-9-git-send-email-arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1405081147320.1087-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2014, Arnd Bergmann wrote:

> The PHY setup code of the TI DaVinci DA8xx OHCI controller
> uses ad-hoc register access using a pointer that is meant to
> be used only by the DaVinci platform implementation and that
> is intentionally not exported to loadable modules. This results
> in a link error on configurations that use a modular OHCI
> code on this platform.
> 
> While the proper solution for this problem would be to
> implement a real PHY driver shared by ohci-da8xx and musb-da8xx,
> this patch for now just works around the build error by
> only allowing the ohci-da8xx code to be built-in.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> ---
>  drivers/usb/host/Kconfig    | 10 ++++++++++
>  drivers/usb/host/ohci-hcd.c |  2 +-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index e229a47..3af10b7 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -417,6 +417,16 @@ config USB_OHCI_HCD_OMAP3
>  	  Enables support for the on-chip OHCI controller on
>  	  OMAP3 and later chips.
>  
> +config USB_OHCI_HCD_DAVINCI
> +	bool "OHCI support for TI DaVinci DA8xx"
> +	depends on ARCH_DAVINCI_DA8XX
> +	depends on USB_OHCI_HCD=y
> +	default y
> +	help
> +	  Enables support for the DaVinci DA8xx integrated OHCI
> +	  controller. This driver cannot currently be a loadable
> +	  module because it lacks a proper PHY abstraction.
> +
>  config USB_OHCI_ATH79
>  	bool "USB OHCI support for the Atheros AR71XX/AR7240 SoCs (DEPRECATED)"
>  	depends on (SOC_AR71XX || SOC_AR724X)
> diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
> index 3586460..f98d03f 100644
> --- a/drivers/usb/host/ohci-hcd.c
> +++ b/drivers/usb/host/ohci-hcd.c
> @@ -1178,7 +1178,7 @@ MODULE_LICENSE ("GPL");
>  #define SA1111_DRIVER		ohci_hcd_sa1111_driver
>  #endif
>  
> -#ifdef CONFIG_ARCH_DAVINCI_DA8XX
> +#ifdef CONFIG_USB_OHCI_HCD_DAVINCI
>  #include "ohci-da8xx.c"
>  #define DAVINCI_PLATFORM_DRIVER	ohci_hcd_da8xx_driver
>  #endif

Acked-by: Alan Stern <stern@rowland.harvard.edu>

