Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab3CZSKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:10:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63751 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3CZSKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:10:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Florian Fainelli <florian@openwrt.org>
Subject: Re: [RFC PATCH 2/5] USB: remove USB_EHCI_BIG_ENDIAN_{DESC,MMIO} depends on architecture symbol
Date: Tue, 26 Mar 2013 18:10:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
References: <1364321177-12146-1-git-send-email-florian@openwrt.org> <1364321177-12146-3-git-send-email-florian@openwrt.org>
In-Reply-To: <1364321177-12146-3-git-send-email-florian@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303261810.44154.arnd@arndb.de>
X-Provags-ID: V02:K0:6lwvjN2pFxykZWIXaVh5iVrlcFDzD3UcwK2Tiek9yI2
 5Km7FSJUQiTv4NzlqW5SSt1fBEFpSqCBqB0Js/MT9zEVbJ0Btf
 i4PxQVikO0MGVZGYzZR/L5prq+0Tf/HuoCAyoxfnj9xXgZvWrP
 JVRoGrOliQRHkIGTlICZstee8DeC8LYL+h/FzsBd1SDOxtWI9w
 VZlm/lTMCUKkA2DDEUdwVav64tgr9pbDvpxYVqKI37/ScsAhJd
 /kTceTxFk9IvM38WvgXVrbBsurRLYjtSTC8kxvxDCRLdZ2L2EC
 ZsBuR5pw//4mpnTjy1IoFjx2gONCWwkuDWg+Uaugop/lq2ZMMF
 iNuOb9ukjD4zXBZ9AKUI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 March 2013, Florian Fainelli wrote:
> 
> Just like the OHCI counter part we just can remove the architecture
> specific symbols which prevent these configuration symbols from being
> selected by platforms/architectures requiring it. The original
> implementation did not scale at all since it required each and every
> single architecture to be added for these configuration symbols to be
> selected. Now it is up to the EHCI driver and/or platform to select
> these configuration symbols accordingly.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>

Good idea, just one suggestion:

>  config USB_EHCI_BIG_ENDIAN_MMIO
>         bool
> -       depends on USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX || \
> -                                   ARCH_IXP4XX || XPS_USB_HCD_XILINX || \
> -                                   PPC_MPC512x || CPU_CAVIUM_OCTEON || \
> -                                   PMC_MSP || SPARC_LEON || MIPS_SEAD3)
> -       default y
> +       depends on USB_EHCI_HCD
> +       default n
>  
>  config USB_EHCI_BIG_ENDIAN_DESC
>         bool
> -       depends on USB_EHCI_HCD && (440EPX || ARCH_IXP4XX || XPS_USB_HCD_XILINX || \
> -                                   PPC_MPC512x || PMC_MSP || SPARC_LEON || \
> -                                   MIPS_SEAD3)
> -       default y
> +       depends on USB_EHCI_HCD
> +       default n
>  
>  config XPS_USB_HCD_XILINX
>         bool "Use Xilinx usb host EHCI controller core"

You can drop the "default n" line as well, it's the default.

	Arnd
