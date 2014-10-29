Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934827AbaJ2Q4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 12:56:45 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42554 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934001AbaJ2Q4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 12:56:42 -0400
Message-ID: <54511C2E.50007@gmail.com>
Date: Wed, 29 Oct 2014 09:56:14 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>, tglx@linutronix.de,
        jason@lakedaemon.net, ralf@linux-mips.org
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        mbizon@freebox.fr, jogo@openwrt.org, linux-mips@linux-mips.org
Subject: Re: [PATCH 11/11] irqchip: Decouple bcm7120-l2 from brcmstb-l2
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <1414555138-6500-11-git-send-email-cernekee@gmail.com>
In-Reply-To: <1414555138-6500-11-git-send-email-cernekee@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 08:58 PM, Kevin Cernekee wrote:
> Some chips, such as BCM6328, only require the former driver.  Some
> BCM7xxx STB configurations only require the latter driver.  Treat them
> as two separate entities, and update the mach-bcm dependencies to
> reflect the change.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

> ---
>  arch/arm/mach-bcm/Kconfig        | 1 +
>  drivers/irqchip/Kconfig          | 5 +++++
>  drivers/irqchip/Makefile         | 4 ++--
>  drivers/irqchip/irq-bcm7120-l2.c | 2 +-
>  4 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
> index 2abad74..bf47eb0 100644
> --- a/arch/arm/mach-bcm/Kconfig
> +++ b/arch/arm/mach-bcm/Kconfig
> @@ -125,6 +125,7 @@ config ARCH_BRCMSTB
>  	select HAVE_ARM_ARCH_TIMER
>  	select BRCMSTB_GISB_ARB
>  	select BRCMSTB_L2_IRQ
> +	select BCM7120_L2_IRQ
>  	help
>  	  Say Y if you intend to run the kernel on a Broadcom ARM-based STB
>  	  chipset.
> diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> index 6a03c65..2d52b07 100644
> --- a/drivers/irqchip/Kconfig
> +++ b/drivers/irqchip/Kconfig
> @@ -51,6 +51,11 @@ config ATMEL_AIC5_IRQ
>  	select MULTI_IRQ_HANDLER
>  	select SPARSE_IRQ
>  
> +config BCM7120_L2_IRQ
> +	bool
> +	select GENERIC_IRQ_CHIP
> +	select IRQ_DOMAIN
> +
>  config BRCMSTB_L2_IRQ
>  	bool
>  	select GENERIC_IRQ_CHIP
> diff --git a/drivers/irqchip/Makefile b/drivers/irqchip/Makefile
> index 173bb5f..f0909d0 100644
> --- a/drivers/irqchip/Makefile
> +++ b/drivers/irqchip/Makefile
> @@ -35,6 +35,6 @@ obj-$(CONFIG_TB10X_IRQC)		+= irq-tb10x.o
>  obj-$(CONFIG_XTENSA)			+= irq-xtensa-pic.o
>  obj-$(CONFIG_XTENSA_MX)			+= irq-xtensa-mx.o
>  obj-$(CONFIG_IRQ_CROSSBAR)		+= irq-crossbar.o
> -obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o \
> -					   irq-bcm7120-l2.o
> +obj-$(CONFIG_BCM7120_L2_IRQ)		+= irq-bcm7120-l2.o
> +obj-$(CONFIG_BRCMSTB_L2_IRQ)		+= irq-brcmstb-l2.o
>  obj-$(CONFIG_KEYSTONE_IRQ)		+= irq-keystone.o
> diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
> index 734fece..91065b9 100644
> --- a/drivers/irqchip/irq-bcm7120-l2.c
> +++ b/drivers/irqchip/irq-bcm7120-l2.c
> @@ -247,5 +247,5 @@ out_unmap:
>  	kfree(data);
>  	return ret;
>  }
> -IRQCHIP_DECLARE(brcmstb_l2_intc, "brcm,bcm7120-l2-intc",
> +IRQCHIP_DECLARE(bcm7120_l2_intc, "brcm,bcm7120-l2-intc",
>  		bcm7120_l2_intc_of_init);
> 

