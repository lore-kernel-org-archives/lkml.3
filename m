Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab3C2Vby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 17:31:54 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:59760 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854Ab3C2Vbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 17:31:52 -0400
X-Auth-Info: xGAFisHaLwmLmgZVRA8FD33+nwTV3bRL0Il6ulT31xA=
Date: Fri, 29 Mar 2013 22:31:57 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Florian Fainelli <florian@openwrt.org>
Cc: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org, arnd@arndb.de,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Subject: Re: [RFC PATCH 2/5] USB: remove USB_EHCI_BIG_ENDIAN_{DESC,MMIO}
 depends on architecture symbol
Message-ID: <20130329223157.5f2adef4@crub>
In-Reply-To: <1364321177-12146-3-git-send-email-florian@openwrt.org>
References: <1364321177-12146-1-git-send-email-florian@openwrt.org>
	<1364321177-12146-3-git-send-email-florian@openwrt.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Florian,

On Tue, 26 Mar 2013 19:06:14 +0100
Florian Fainelli <florian@openwrt.org> wrote:
...
> diff --git a/arch/powerpc/platforms/52xx/Kconfig b/arch/powerpc/platforms/52xx/Kconfig
> index 90f4496..65232cb 100644
> --- a/arch/powerpc/platforms/52xx/Kconfig
> +++ b/arch/powerpc/platforms/52xx/Kconfig
> @@ -3,6 +3,8 @@ config PPC_MPC52xx
>  	depends on 6xx
>  	select PPC_CLOCK
>  	select PPC_PCI_CHOICE
> +	select USB_EHCI_BIG_ENDIAN_MMIO
> +	select USB_EHCI_BIG_ENDIAN_DESC

Note that mpc52xx only has an OHCI controller, so this change here
is wrong. It belongs into arch/powerpc/platforms/512x/Kconfig.
mpc512x has an EHCI controller.

Thanks,

Anatolij
