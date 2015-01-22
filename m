Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbbAVKXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:23:00 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:47625 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbbAVKWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:22:53 -0500
Message-ID: <54C0CF5D.8020902@atmel.com>
Date: Thu, 22 Jan 2015 11:22:21 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        "Bo Shen" <voice.shen@atmel.com>, Wenyou Yang <Wenyou.Yang@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/17] ARM: at91: merge SOC_AT91SAM9xxx
References: <1421359100-8930-1-git-send-email-alexandre.belloni@free-electrons.com> <1421359100-8930-11-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1421359100-8930-11-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 15/01/2015 22:58, Alexandre Belloni a écrit :
> Only use SOC_AT91SAM9 for all the at91sam9 SoCs.
> 
> It enables HAVE_AT91_SMD and HAVE_AT91_UTMI for all the sam9 SoCs but this only
> represents 96 bytes of uncompressed kernel code.

After this patch that removes all the CONFIG_SOC_AT91SAM9xxxx options
excepted CONFIG_SOC_AT91SAM9, I still see a lot of them remaining in the
source tree.

So, this patch is not complete in my opinion. Even if you remove these
options later on, why not suppress them here?

> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/configs/at91_dt_defconfig | 10 +----
>  arch/arm/mach-at91/Kconfig         | 92 +++++++++++---------------------------
>  2 files changed, 27 insertions(+), 75 deletions(-)
> 
> diff --git a/arch/arm/configs/at91_dt_defconfig b/arch/arm/configs/at91_dt_defconfig
> index 8116d122e098..811e72bbe642 100644
> --- a/arch/arm/configs/at91_dt_defconfig
> +++ b/arch/arm/configs/at91_dt_defconfig
> @@ -15,15 +15,7 @@ CONFIG_MODULE_UNLOAD=y
>  # CONFIG_IOSCHED_CFQ is not set
>  CONFIG_ARCH_AT91=y
>  CONFIG_SOC_AT91RM9200=y
> -CONFIG_SOC_AT91SAM9260=y
> -CONFIG_SOC_AT91SAM9261=y
> -CONFIG_SOC_AT91SAM9263=y
> -CONFIG_SOC_AT91SAM9RL=y
> -CONFIG_SOC_AT91SAM9G45=y
> -CONFIG_SOC_AT91SAM9X5=y
> -CONFIG_SOC_AT91SAM9N12=y
> -CONFIG_MACH_AT91RM9200_DT=y
> -CONFIG_MACH_AT91SAM9_DT=y
> +CONFIG_SOC_AT91SAM9=y
>  CONFIG_AT91_TIMER_HZ=128
>  CONFIG_AEABI=y
>  CONFIG_UACCESS_WITH_MEMCPY=y
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index c6956b863b9d..c6740e359a44 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -16,15 +16,6 @@ config HAVE_AT91_SMD
>  config HAVE_AT91_H32MX
>  	bool
>  
> -config SOC_AT91SAM9
> -	bool
> -	select ATMEL_AIC_IRQ
> -	select COMMON_CLK_AT91
> -	select CPU_ARM926T
> -	select GENERIC_CLOCKEVENTS
> -	select MEMORY
> -	select ATMEL_SDRAMC
> -
>  config SOC_SAMA5
>  	bool
>  	select ATMEL_AIC5_IRQ
> @@ -92,67 +83,36 @@ config SOC_AT91RM9200
>  	select GENERIC_CLOCKEVENTS
>  	select HAVE_AT91_USB_CLK
>  
> -config SOC_AT91SAM9260
> -	bool "AT91SAM9260, AT91SAM9XE or AT91SAM9G20"
> -	select SOC_AT91SAM9
> -	select HAVE_AT91_USB_CLK
> -	help
> -	  Select this if you are using one of Atmel's AT91SAM9260, AT91SAM9XE
> -	  or AT91SAM9G20 SoC.
> -
> -config SOC_AT91SAM9261
> -	bool "AT91SAM9261 or AT91SAM9G10"
> -	select HAVE_FB_ATMEL
> -	select SOC_AT91SAM9
> -	select HAVE_AT91_USB_CLK
> -	help
> -	  Select this if you are using one of Atmel's AT91SAM9261 or AT91SAM9G10 SoC.
> -
> -config SOC_AT91SAM9263
> -	bool "AT91SAM9263"
> -	select HAVE_FB_ATMEL
> -	select SOC_AT91SAM9
> -	select HAVE_AT91_USB_CLK
> -
> -config SOC_AT91SAM9RL
> -	bool "AT91SAM9RL"
> -	select HAVE_FB_ATMEL
> -	select SOC_AT91SAM9
> -	select HAVE_AT91_UTMI
> -
> -config SOC_AT91SAM9G45
> -	bool "AT91SAM9G45 or AT91SAM9M10 families"
> -	select HAVE_FB_ATMEL
> -	select SOC_AT91SAM9
> -	select HAVE_AT91_UTMI
> -	select HAVE_AT91_USB_CLK
> -	help
> -	  Select this if you are using one of Atmel's AT91SAM9G45 family SoC.
> -	  This support covers AT91SAM9G45, AT91SAM9G46, AT91SAM9M10 and AT91SAM9M11.
> -
> -config SOC_AT91SAM9X5
> -	bool "AT91SAM9x5 family"
> -	select HAVE_FB_ATMEL
> -	select SOC_AT91SAM9
> -	select HAVE_AT91_UTMI
> +config SOC_AT91SAM9
> +	bool "AT91SAM9"
> +	select ATMEL_AIC_IRQ
> +	select ATMEL_SDRAMC
> +	select COMMON_CLK_AT91
> +	select CPU_ARM926T
> +	select GENERIC_CLOCKEVENTS
>  	select HAVE_AT91_SMD
>  	select HAVE_AT91_USB_CLK
> -	help
> -	  Select this if you are using one of Atmel's AT91SAM9x5 family SoC.
> -	  This means that your SAM9 name finishes with a '5' (except if it is
> -	  AT91SAM9G45!).
> -	  This support covers AT91SAM9G15, AT91SAM9G25, AT91SAM9X25, AT91SAM9G35
> -	  and AT91SAM9X35.
> -
> -config SOC_AT91SAM9N12
> -	bool "AT91SAM9N12 family"
> +	select HAVE_AT91_UTMI
>  	select HAVE_FB_ATMEL
> -	select SOC_AT91SAM9
> -	select HAVE_AT91_USB_CLK
> +	select MEMORY
>  	help
> -	  Select this if you are using Atmel's AT91SAM9N12 SoC.
> -
> -# ----------------------------------------------------------
> +	  Select this if you are using one of those Atmel SoC:
> +	    AT91SAM9260
> +	    AT91SAM9261
> +	    AT91SAM9263
> +	    AT91SAM9G15
> +	    AT91SAM9G20
> +	    AT91SAM9G25
> +	    AT91SAM9G35
> +	    AT91SAM9G45
> +	    AT91SAM9G46
> +	    AT91SAM9M10
> +	    AT91SAM9M11
> +	    AT91SAM9N12
> +	    AT91SAM9RL
> +	    AT91SAM9X25
> +	    AT91SAM9X35
> +	    AT91SAM9XE
>  endif # SOC_SAM_V4_V5
>  
>  comment "AT91 Feature Selections"
> 


-- 
Nicolas Ferre
