Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaIPEMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 00:12:48 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:40077 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752228AbaIPEMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 00:12:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvkGAFy4F1Sl5H4J/2dsb2JhbABghDeFKshJhEoBgSt4hAQBAQQ6PxALDgoJFRAPARE2BhOIKgMRtC8NhwEBF40ggUlkB4RLBY83i0GOQIJRhj6DcCsvgQaBRAEBAQ
From: Alistair Popple <alistair@popple.id.au>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc: Fix build failure when CONFIG_USB=y
Date: Tue, 16 Sep 2014 14:12:44 +1000
Message-ID: <5910448.DIq02Mfy77@mexican>
User-Agent: KMail/4.11.5 (Linux/3.11.0-17-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1408626964-31554-1-git-send-email-bobby.prani@gmail.com>
References: <1408626964-31554-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for fixing these!

Acked-by: Alistair Popple <alistair@popple.id.au>

On Thu, 21 Aug 2014 09:16:04 Pranith Kumar wrote:
> We are enabling USB unconditionally which results in following build failure
> 
> drivers/built-in.o: In function `tb_drom_read':
> (.text+0x1b62b70): undefined reference to `usb_speed_string'
> make: *** [vmlinux] Error
> 
> Enable USB only if USB_SUPPORT is set to avoid such failures
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  arch/powerpc/platforms/44x/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/platforms/44x/Kconfig
> b/arch/powerpc/platforms/44x/Kconfig index 3e7deb2..82f2da2 100644
> --- a/arch/powerpc/platforms/44x/Kconfig
> +++ b/arch/powerpc/platforms/44x/Kconfig
> @@ -215,7 +215,7 @@ config AKEBONO
>  	select NET_VENDOR_IBM
>  	select IBM_EMAC_EMAC4
>  	select IBM_EMAC_RGMII_WOL
> -	select USB
> +	select USB if USB_SUPPORT
>  	select USB_OHCI_HCD_PLATFORM if USB_OHCI_HCD
>  	select USB_EHCI_HCD_PLATFORM if USB_EHCI_HCD
>  	select MMC_SDHCI

