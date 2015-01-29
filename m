Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbbA2LmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:42:17 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33959 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbbA2LmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:42:13 -0500
Date: Thu, 29 Jan 2015 11:41:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: gregkh@linuxfoundation.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: renesas: fix extcon dependency
Message-ID: <20150129114158.GY26493@n2100.arm.linux.org.uk>
References: <2167400.bYh9r60XLF@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2167400.bYh9r60XLF@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 10:47:18PM +0100, Arnd Bergmann wrote:
> The renesas usbhs driver calls extcon_get_edev_by_phandle(), which
> is defined in drivers/extcon/extcon-class.c, and that can be a
> loadable module. If the extcon-class support is disabled, usbhs
> will work correctly for all devices that do not need extcon.
> 
> However, if extcon-class is a loadable module, and usbhs is
> built-in, the kernel fails to link. In order to solve that,
> we need a Kconfig dependency that allows extcon to be disabled
> but does not allow usbhs built-in if extcon is a module.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/drivers/usb/renesas_usbhs/Kconfig b/drivers/usb/renesas_usbhs/Kconfig
> index de83b9d0cd5c..0ea9040b9f10 100644
> --- a/drivers/usb/renesas_usbhs/Kconfig
> +++ b/drivers/usb/renesas_usbhs/Kconfig
> @@ -6,6 +6,7 @@ config USB_RENESAS_USBHS
>  	tristate 'Renesas USBHS controller'
>  	depends on USB_GADGET
>  	depends on ARCH_SHMOBILE || SUPERH || COMPILE_TEST
> +	depends on EXTCON || !EXTCON # for module build if extcon is

The comment doesn't make much sense on its own (and when I read it before
reading the above description, it was down right confusing.)  Maybe a
longer comment would be a good idea?

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
