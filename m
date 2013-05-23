Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959Ab3EWQ6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:58:01 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28053 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759810Ab3EWQ56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:57:58 -0400
X-IronPort-AV: E=Sophos;i="4.87,729,1363158000"; 
   d="scan'208";a="50134674"
Message-ID: <519E4A94.5080703@codeaurora.org>
Date: Thu, 23 May 2013 09:57:56 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rohit Vaswani <rvaswani@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: msm: Remove gpiomux-v2 and re-organize MSM_GPIOMUX
 configs
References: <1369268964-28304-1-git-send-email-rvaswani@codeaurora.org> <1369268964-28304-2-git-send-email-rvaswani@codeaurora.org>
In-Reply-To: <1369268964-28304-2-git-send-email-rvaswani@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/13 17:29, Rohit Vaswani wrote:
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index fceb093..614e41e 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -48,9 +48,7 @@ config ARCH_MSM8X60
>  	select CPU_V7
>  	select GPIO_MSM_V2
>  	select HAVE_SMP
> -	select MSM_GPIOMUX
>  	select MSM_SCM if SMP
> -	select MSM_V2_TLMM
>  	select USE_OF
>  
>  config ARCH_MSM8960
> @@ -58,9 +56,8 @@ config ARCH_MSM8960
>  	select ARM_GIC
>  	select CPU_V7
>  	select HAVE_SMP
> -	select MSM_GPIOMUX
> +	select GPIO_MSM_V2
>  	select MSM_SCM if SMP
> -	select MSM_V2_TLMM
>  	select USE_OF
>  
>  config MSM_HAS_DEBUG_UART_HS
> @@ -124,10 +121,10 @@ config MSM_SMD
>  	bool
>  
>  config MSM_GPIOMUX
> -	bool
> -
> -config MSM_V2_TLMM
> -	bool
> +	depends on !(ARCH_MSM8X60 || ARCH_MSM8960)

This list will keep getting bigger over time. Please just keep it a
hidden option and don't select it on 8x60/8960.

> +	bool "MSM V1 TLMM GPIOMUX architecture"
> +	help
> +	  Support for MSM V1 TLMM GPIOMUX architecture.
>  
>  config MSM_SCM
>  	bool
> diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
> index 17519fa..1a26d04 100644
> --- a/arch/arm/mach-msm/Makefile
> +++ b/arch/arm/mach-msm/Makefile
> @@ -27,7 +27,5 @@ obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
>  obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
>  obj-$(CONFIG_ARCH_MSM8X60) += board-dt-8660.o
>  obj-$(CONFIG_ARCH_MSM8960) += board-dt-8960.o
> -
> -obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-v1.o gpiomux.o
> -obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-v1.o gpiomux.o
> -obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-8x60.o gpiomux-v2.o gpiomux.o
> +obj-$(CONFIG_MSM_GPIOMUX) += gpiomux.o
> +obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o

Did you mean to delete gpiomux-v1.c as well?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

