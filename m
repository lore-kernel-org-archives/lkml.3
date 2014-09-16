Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbaIPEMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 00:12:43 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:40077 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbaIPEMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 00:12:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqUGAFy4F1Sl5H4J/2dsb2JhbABghDeFKs0TAYEreIQEAQEEOj8QCw4KCRUQDwERNgYTiCoDEbQvDYcBAReNIIItB4RLBY83i0GREYY+g3ArL4JKAQEB
From: Alistair Popple <alistair@popple.id.au>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] powerpc: Fix build failure
Date: Tue, 16 Sep 2014 14:12:37 +1000
Message-ID: <1480446.gFeczbkrbH@mexican>
User-Agent: KMail/4.11.5 (Linux/3.11.0-17-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1408626271-13519-1-git-send-email-bobby.prani@gmail.com>
References: <1408626271-13519-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for fixing these!

Acked-by: Alistair Popple <alistair@popple.id.au>

On Thu, 21 Aug 2014 09:04:31 Pranith Kumar wrote:
> Fix the following build failure
> 
> drivers/built-in.o: In function `nhi_init':
> nhi.c:(.init.text+0x63390): undefined reference to `ehci_init_driver'
> 
> by adding a dependency on USB_EHCI_HCD which supplies the
> ehci_init_driver().
> 
> Also we need to depend on USB_OHCI_HCD similarly
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> ---
>  arch/powerpc/platforms/44x/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/44x/Kconfig
> b/arch/powerpc/platforms/44x/Kconfig index 4d88f6a..3e7deb2 100644
> --- a/arch/powerpc/platforms/44x/Kconfig
> +++ b/arch/powerpc/platforms/44x/Kconfig
> @@ -216,8 +216,8 @@ config AKEBONO
>  	select IBM_EMAC_EMAC4
>  	select IBM_EMAC_RGMII_WOL
>  	select USB
> -	select USB_OHCI_HCD_PLATFORM
> -	select USB_EHCI_HCD_PLATFORM
> +	select USB_OHCI_HCD_PLATFORM if USB_OHCI_HCD
> +	select USB_EHCI_HCD_PLATFORM if USB_EHCI_HCD
>  	select MMC_SDHCI
>  	select MMC_SDHCI_PLTFM
>  	select MMC_SDHCI_OF_476GTR

