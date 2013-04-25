Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab3DYTyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 15:54:35 -0400
Received: from antcom.de ([188.40.178.216]:47643 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758261Ab3DYTyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 15:54:32 -0400
Message-ID: <51798912.4090108@antcom.de>
Date: Thu, 25 Apr 2013 21:50:42 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 19/21] USB: lpc32xx: ISP1301 needs USB_PHY
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de> <1366910944-3033663-20-git-send-email-arnd@arndb.de>
In-Reply-To: <1366910944-3033663-20-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/13 19:29, Arnd Bergmann wrote:
> The Kconfig entry for USB_LPC32XX unconditionally selects USB_ISP1301,
> which is now only visible when USB_PHY is also enabled.
> 
> This adds an appropriate dependency and enables USB_PHY in the msm
> defconfig, avoiding these build errors:
> 
> warning: (USB_LPC32XX) selects USB_ISP1301 which has unmet direct dependencies (USB_SUPPORT && USB_PHY && (USB || USB_GADGET) && I2C)
> drivers/built-in.o: In function `usb_hcd_nxp_probe':
> drivers/usb/host/ohci-nxp.c:224: undefined reference to `isp1301_get_client'
> drivers/built-in.o: In function `lpc32xx_udc_probe':
> drivers/usb/gadget/lpc32xx_udc.c:3071: undefined reference to `isp1301_get_client'
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-usb@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Roland Stigge <stigge@antcom.de>

Tested-by: Roland Stigge <stigge@antcom.de>
Acked-by: Roland Stigge <stigge@antcom.de>

> ---
>  arch/arm/configs/lpc32xx_defconfig | 1 +
>  drivers/usb/gadget/Kconfig         | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/arm/configs/lpc32xx_defconfig b/arch/arm/configs/lpc32xx_defconfig
> index 8fee514..398a367 100644
> --- a/arch/arm/configs/lpc32xx_defconfig
> +++ b/arch/arm/configs/lpc32xx_defconfig
> @@ -146,6 +146,7 @@ CONFIG_SND_DEBUG_VERBOSE=y
>  # CONFIG_SND_SPI is not set
>  CONFIG_SND_SOC=y
>  CONFIG_USB=y
> +CONFIG_USB_PHY=y
>  CONFIG_USB_OHCI_HCD=y
>  CONFIG_USB_STORAGE=y
>  CONFIG_USB_GADGET=y
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index a61d981..f85b427 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -144,6 +144,7 @@ config USB_AT91
>  config USB_LPC32XX
>  	tristate "LPC32XX USB Peripheral Controller"
>  	depends on ARCH_LPC32XX
> +	depends on USB_PHY
>  	select USB_ISP1301
>  	select USB_OTG_UTILS
>  	help

