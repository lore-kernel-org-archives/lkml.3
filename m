Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab3JNWBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 18:01:23 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:37993 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab3JNWBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 18:01:22 -0400
Message-ID: <525C69AC.1010004@gmail.com>
Date: Tue, 15 Oct 2013 09:01:16 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-usb@vger.kernel.org
CC: ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, stern@rowland.harvard.edu,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] usb: ohci: remove ep93xx bus glue platform driver
References: <201310141435.31147.hartleys@visionengravers.com>
In-Reply-To: <201310141435.31147.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/10/13 08:35, H Hartley Sweeten wrote:
> Convert ep93xx to use the OHCI platform driver and remove the
> ohci-ep93xx bus glue driver.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Ryan Mallon <rmallon@gmail.com>
> ---

> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index b3f20d7..2c8f2db 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -472,7 +472,7 @@ config USB_CNS3XXX_OHCI
>  
>  config USB_OHCI_HCD_PLATFORM
>  	tristate "Generic OHCI driver for a platform device"
> -	default n
> +	default y if ARCH_EP93XX

Shouldn't we select USB_OHCI_HCD_PLATFORM, e.g. something like:

	config ARCH_EP93XX_USB
		tristate "USB OHCI support"
		default y
		select USB_OHCI_HCD_PLATFORM

In arch/arm/mach-ep93xx/Kconfig rather than polluting
drivers/usb/host/Kconfig with arch specific stuff?

~Ryan

