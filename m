Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286AbaKMJbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:31:13 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:14057 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074AbaKMJbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:31:08 -0500
Message-ID: <54647A59.6080709@atmel.com>
Date: Thu, 13 Nov 2014 10:31:05 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91: remove CONFIG_MACH_SAMA5_DT
References: <1415652353-15985-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1415652353-15985-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2014 21:45, Alexandre Belloni :
> CONFIG_MACH_SAMA5_DT is useless as the only way to boot on sama5 based boards is
> to use device tree.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

queued on at91-3.19-cleanup. Thanks.

> ---
>  arch/arm/configs/sama5_defconfig |  1 -
>  arch/arm/mach-at91/Kconfig       | 10 +---------
>  arch/arm/mach-at91/Makefile      |  2 +-
>  3 files changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm/configs/sama5_defconfig b/arch/arm/configs/sama5_defconfig
> index c9089c927daf..299ca18bbd75 100644
> --- a/arch/arm/configs/sama5_defconfig
> +++ b/arch/arm/configs/sama5_defconfig
> @@ -20,7 +20,6 @@ CONFIG_ARCH_AT91=y
>  CONFIG_SOC_SAM_V7=y
>  CONFIG_SOC_SAMA5D3=y
>  CONFIG_SOC_SAMA5D4=y
> -CONFIG_MACH_SAMA5_DT=y
>  CONFIG_AEABI=y
>  CONFIG_UACCESS_WITH_MEMCPY=y
>  CONFIG_ZBOOT_ROM_TEXT=0x0
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 0e6d548b70d9..81ddd7d31d1e 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -58,6 +58,7 @@ config SOC_SAMA5
>  	select USE_OF
>  	select MEMORY
>  	select ATMEL_SDRAMC
> +	select PHYLIB if NETDEVICES
>  
>  menu "Atmel AT91 System-on-Chip"
>  
> @@ -221,15 +222,6 @@ config MACH_AT91SAM9_DT
>  	  Select this if you want to experiment device-tree with
>  	  an Atmel Evaluation Kit.
>  
> -config MACH_SAMA5_DT
> -	bool "Atmel SAMA5 Evaluation Kits with device-tree support"
> -	depends on SOC_SAMA5
> -	select USE_OF
> -	select PHYLIB if NETDEVICES
> -	help
> -	  Select this if you want to experiment device-tree with
> -	  an Atmel Evaluation Kit.
> -
>  # ----------------------------------------------------------
>  
>  comment "AT91 Feature Selections"
> diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
> index 1b9ae0257a6e..25ae74837d23 100644
> --- a/arch/arm/mach-at91/Makefile
> +++ b/arch/arm/mach-at91/Makefile
> @@ -80,7 +80,7 @@ obj-$(CONFIG_MACH_AT91RM9200_DT) += board-dt-rm9200.o
>  obj-$(CONFIG_MACH_AT91SAM9_DT) += board-dt-sam9.o
>  
>  # SAMA5 board with device-tree
> -obj-$(CONFIG_MACH_SAMA5_DT) += board-dt-sama5.o
> +obj-$(CONFIG_SOC_SAMA5)		+= board-dt-sama5.o
>  
>  # AT91X40 board-specific support
>  obj-$(CONFIG_MACH_AT91EB01)	+= board-eb01.o
> 


-- 
Nicolas Ferre
