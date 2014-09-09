Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbaIILwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:52:24 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:16950 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaIILwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:52:21 -0400
Message-ID: <540EE9F1.4030301@atmel.com>
Date: Tue, 9 Sep 2014 13:52:17 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        <linux-kbuild@vger.kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>,
        Ryan Mallon <rmallon@gmail.com>, Tony Lindgren <tony@atomide.com>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>,
        "Hartley Sweeten" <hsweeten@visionengravers.com>,
        <linux-samsung-soc@vger.kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        Greg Ungerer <gerg@uclinux.org>, <linux-omap@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] kbuild: remove unnecessary variable initializaions
References: <1410258381-7088-1-git-send-email-yamada.m@jp.panasonic.com> <1410258381-7088-3-git-send-email-yamada.m@jp.panasonic.com>
In-Reply-To: <1410258381-7088-3-git-send-email-yamada.m@jp.panasonic.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 12:26, Masahiro Yamada :
> Clearing obj-y, obj-m, obj-n, obj- in each Makefile is
> a useless habit.
> 
> They are non-exported variables; therefore they are always empty
> whenever descending into each subdirectory.
> (Moreorver, obj-y and obj-m are also set to empty at the beginning
> of scripts/Makefile.build)
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> ---
> 
>  arch/arm/mach-at91/Makefile       | 3 ---
>  arch/arm/mach-ebsa110/Makefile    | 3 ---
>  arch/arm/mach-ep93xx/Makefile     | 3 ---
>  arch/arm/mach-exynos/Makefile     | 5 -----
>  arch/arm/mach-footbridge/Makefile | 3 ---
>  arch/arm/mach-iop13xx/Makefile    | 5 -----
>  arch/arm/mach-iop32x/Makefile     | 3 ---
>  arch/arm/mach-iop33x/Makefile     | 3 ---
>  arch/arm/mach-ks8695/Makefile     | 3 ---
>  arch/arm/mach-rpc/Makefile        | 4 ----
>  arch/arm/mach-s3c24xx/Makefile    | 5 -----
>  arch/arm/mach-s3c64xx/Makefile    | 5 -----
>  arch/arm/mach-s5pv210/Makefile    | 5 -----
>  arch/arm/mach-sa1100/Makefile     | 3 ---
>  arch/arm/mach-u300/Makefile       | 3 ---
>  arch/arm/plat-iop/Makefile        | 6 ------
>  arch/arm/plat-omap/Makefile       | 3 ---
>  arch/arm/plat-samsung/Makefile    | 4 ----
>  18 files changed, 69 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
> index 78e9cec..75033839 100644
> --- a/arch/arm/mach-at91/Makefile
> +++ b/arch/arm/mach-at91/Makefile
> @@ -3,9 +3,6 @@
>  #
>  
>  obj-y		:= irq.o gpio.o setup.o sysirq_mask.o
> -obj-m		:=
> -obj-n		:=
> -obj-		:=

I agree:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

But I have patches that will mess with these changes already queued for
3.18. You may have to signal these conflicts when carrying the patch
upstream.

Thanks, best regards,

>  obj-$(CONFIG_OLD_CLK_AT91)	+= clock.o
>  obj-$(CONFIG_AT91_SAM9_ALT_RESET) += at91sam9_alt_reset.o
> diff --git a/arch/arm/mach-ebsa110/Makefile b/arch/arm/mach-ebsa110/Makefile
> index 935e4af..a7d68c1 100644
> --- a/arch/arm/mach-ebsa110/Makefile
> +++ b/arch/arm/mach-ebsa110/Makefile
> @@ -5,6 +5,3 @@
>  # Object file lists.
>  
>  obj-y			:= core.o io.o leds.o
> -obj-m			:=
> -obj-n			:=
> -obj-			:=
> diff --git a/arch/arm/mach-ep93xx/Makefile b/arch/arm/mach-ep93xx/Makefile
> index 0dc51f9..78d427b 100644
> --- a/arch/arm/mach-ep93xx/Makefile
> +++ b/arch/arm/mach-ep93xx/Makefile
> @@ -2,9 +2,6 @@
>  # Makefile for the linux kernel.
>  #
>  obj-y			:= core.o clock.o
> -obj-m			:=
> -obj-n			:=
> -obj-			:=
>  
>  obj-$(CONFIG_EP93XX_DMA)	+= dma.o
>  
> diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
> index 788f26d..27ae614 100644
> --- a/arch/arm/mach-exynos/Makefile
> +++ b/arch/arm/mach-exynos/Makefile
> @@ -7,11 +7,6 @@
>  
>  ccflags-$(CONFIG_ARCH_MULTIPLATFORM) += -I$(srctree)/$(src)/include -I$(srctree)/arch/arm/plat-samsung/include
>  
> -obj-y				:=
> -obj-m				:=
> -obj-n				:=
> -obj-				:=
> -
>  # Core
>  
>  obj-$(CONFIG_ARCH_EXYNOS)	+= exynos.o pmu.o exynos-smc.o firmware.o
> diff --git a/arch/arm/mach-footbridge/Makefile b/arch/arm/mach-footbridge/Makefile
> index c3faa3b..e83d5c8 100644
> --- a/arch/arm/mach-footbridge/Makefile
> +++ b/arch/arm/mach-footbridge/Makefile
> @@ -5,9 +5,6 @@
>  # Object file lists.
>  
>  obj-y			:= common.o dma.o isa-irq.o
> -obj-m			:=
> -obj-n			:=
> -obj-			:=
>  
>  pci-y			+= dc21285.o
>  pci-$(CONFIG_ARCH_CATS) += cats-pci.o
> diff --git a/arch/arm/mach-iop13xx/Makefile b/arch/arm/mach-iop13xx/Makefile
> index cad015f..a3d9260 100644
> --- a/arch/arm/mach-iop13xx/Makefile
> +++ b/arch/arm/mach-iop13xx/Makefile
> @@ -1,8 +1,3 @@
> -obj-y			:=
> -obj-m			:=
> -obj-n			:=
> -obj-			:=
> -
>  obj-$(CONFIG_ARCH_IOP13XX) += setup.o
>  obj-$(CONFIG_ARCH_IOP13XX) += irq.o
>  obj-$(CONFIG_ARCH_IOP13XX) += pci.o
> diff --git a/arch/arm/mach-iop32x/Makefile b/arch/arm/mach-iop32x/Makefile
> index cfdf8a1..2d4010a 100644
> --- a/arch/arm/mach-iop32x/Makefile
> +++ b/arch/arm/mach-iop32x/Makefile
> @@ -3,9 +3,6 @@
>  #
>  
>  obj-y			:= irq.o
> -obj-m			:=
> -obj-n			:=
> -obj-			:=
>  
>  obj-$(CONFIG_MACH_GLANTANK) += glantank.o
>  obj-$(CONFIG_ARCH_IQ80321) += iq80321.o
> diff --git a/arch/arm/mach-iop33x/Makefile b/arch/arm/mach-iop33x/Makefile
> index 90081d8..e95db30 100644
> --- a/arch/arm/mach-iop33x/Makefile
> +++ b/arch/arm/mach-iop33x/Makefile
> @@ -3,9 +3,6 @@
>  #
>  
>  obj-y			:= irq.o uart.o
> -obj-m			:=
> -obj-n			:=
> -obj-			:=
>  
>  obj-$(CONFIG_ARCH_IQ80331) += iq80331.o
>  obj-$(CONFIG_MACH_IQ80332) += iq80332.o
> diff --git a/arch/arm/mach-ks8695/Makefile b/arch/arm/mach-ks8695/Makefile
> index e370caf..8ecb797 100644
> --- a/arch/arm/mach-ks8695/Makefile
> +++ b/arch/arm/mach-ks8695/Makefile
> @@ -4,9 +4,6 @@
>  #
>  
>  obj-y				:= cpu.o irq.o time.o devices.o
> -obj-m				:=
> -obj-n				:=
> -obj-				:=
>  
>  # PCI support is optional
>  obj-$(CONFIG_PCI)		+= pci.o
> diff --git a/arch/arm/mach-rpc/Makefile b/arch/arm/mach-rpc/Makefile
> index 992e28b..2ebc687 100644
> --- a/arch/arm/mach-rpc/Makefile
> +++ b/arch/arm/mach-rpc/Makefile
> @@ -5,7 +5,3 @@
>  # Object file lists.
>  
>  obj-y			:= dma.o ecard.o fiq.o irq.o riscpc.o time.o
> -obj-m			:=
> -obj-n			:=
> -obj-			:=
> -
> diff --git a/arch/arm/mach-s3c24xx/Makefile b/arch/arm/mach-s3c24xx/Makefile
> index 2235d0d..b920716 100644
> --- a/arch/arm/mach-s3c24xx/Makefile
> +++ b/arch/arm/mach-s3c24xx/Makefile
> @@ -7,11 +7,6 @@
>  #
>  # Licensed under GPLv2
>  
> -obj-y				:=
> -obj-m				:=
> -obj-n				:=
> -obj-				:=
> -
>  # core
>  
>  obj-y				+= common.o
> diff --git a/arch/arm/mach-s3c64xx/Makefile b/arch/arm/mach-s3c64xx/Makefile
> index 58069a7..12f67b6 100644
> --- a/arch/arm/mach-s3c64xx/Makefile
> +++ b/arch/arm/mach-s3c64xx/Makefile
> @@ -5,11 +5,6 @@
>  #
>  # Licensed under GPLv2
>  
> -obj-y				:=
> -obj-m				:=
> -obj-n				:=
> -obj-				:=
> -
>  # Core
>  
>  obj-y				+= common.o
> diff --git a/arch/arm/mach-s5pv210/Makefile b/arch/arm/mach-s5pv210/Makefile
> index 7dc2d0e..72b9e96 100644
> --- a/arch/arm/mach-s5pv210/Makefile
> +++ b/arch/arm/mach-s5pv210/Makefile
> @@ -7,11 +7,6 @@
>  
>  ccflags-$(CONFIG_ARCH_MULTIPLATFORM) += -I$(srctree)/$(src)/include -I$(srctree)/arch/arm/plat-samsung/include
>  
> -obj-y				:=
> -obj-m				:=
> -obj-n				:=
> -obj-				:=
> -
>  # Core
>  
>  obj-$(CONFIG_PM_SLEEP)		+= pm.o sleep.o
> diff --git a/arch/arm/mach-sa1100/Makefile b/arch/arm/mach-sa1100/Makefile
> index 2732eef..f1114d1 100644
> --- a/arch/arm/mach-sa1100/Makefile
> +++ b/arch/arm/mach-sa1100/Makefile
> @@ -4,9 +4,6 @@
>  
>  # Common support
>  obj-y := clock.o generic.o irq.o time.o #nmi-oopser.o
> -obj-m :=
> -obj-n :=
> -obj-  :=
>  
>  # Specific board support
>  obj-$(CONFIG_SA1100_ASSABET)		+= assabet.o
> diff --git a/arch/arm/mach-u300/Makefile b/arch/arm/mach-u300/Makefile
> index 3ec74ac..87d37de 100644
> --- a/arch/arm/mach-u300/Makefile
> +++ b/arch/arm/mach-u300/Makefile
> @@ -3,9 +3,6 @@
>  #
>  
>  obj-y		:= core.o
> -obj-m		:=
> -obj-n		:=
> -obj-		:=
>  
>  obj-$(CONFIG_MACH_U300_SPIDUMMY)  += dummyspichip.o
>  obj-$(CONFIG_REGULATOR_AB3100)    += regulator.o
> diff --git a/arch/arm/plat-iop/Makefile b/arch/arm/plat-iop/Makefile
> index 224e56c..f2af203 100644
> --- a/arch/arm/plat-iop/Makefile
> +++ b/arch/arm/plat-iop/Makefile
> @@ -2,8 +2,6 @@
>  # Makefile for the linux kernel.
>  #
>  
> -obj-y :=
> -
>  # IOP32X
>  obj-$(CONFIG_ARCH_IOP32X) += i2c.o
>  obj-$(CONFIG_ARCH_IOP32X) += pci.o
> @@ -27,7 +25,3 @@ obj-$(CONFIG_ARCH_IOP33X) += restart.o
>  # IOP13XX
>  obj-$(CONFIG_ARCH_IOP13XX) += cp6.o
>  obj-$(CONFIG_ARCH_IOP13XX) += time.o
> -
> -obj-m                  :=
> -obj-n                  :=
> -obj-                   :=
> diff --git a/arch/arm/plat-omap/Makefile b/arch/arm/plat-omap/Makefile
> index 0b01b68..97a50e8 100644
> --- a/arch/arm/plat-omap/Makefile
> +++ b/arch/arm/plat-omap/Makefile
> @@ -6,9 +6,6 @@ ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/arch/arm/plat-omap/include
>  
>  # Common support
>  obj-y := sram.o dma.o counter_32k.o
> -obj-m :=
> -obj-n :=
> -obj-  :=
>  
>  # omap_device support (OMAP2+ only at the moment)
>  
> diff --git a/arch/arm/plat-samsung/Makefile b/arch/arm/plat-samsung/Makefile
> index a402262..f0a0084 100644
> --- a/arch/arm/plat-samsung/Makefile
> +++ b/arch/arm/plat-samsung/Makefile
> @@ -6,10 +6,6 @@
>  
>  ccflags-$(CONFIG_ARCH_MULTI_V7) += -I$(srctree)/$(src)/include
>  
> -obj-y				:=
> -obj-m				:=
> -obj-				:=
> -
>  # Objects we always build independent of SoC choice
>  
>  obj-y				+= init.o cpu.o
> 


-- 
Nicolas Ferre
