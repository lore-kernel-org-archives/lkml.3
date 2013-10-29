Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab3J2NVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:21:30 -0400
Received: from fifo99.com ([67.223.236.141]:39757 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867Ab3J2NV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:21:27 -0400
Date: Tue, 29 Oct 2013 06:21:01 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: David Brown <davidb@codeaurora.org>
Cc: Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] ARM: msm: Remove 7x00 support
Message-ID: <20131029132043.GA28165@fifo99.com>
References: <1382993006-27359-1-git-send-email-davidb@codeaurora.org>
 <1382993006-27359-3-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382993006-27359-3-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


That's not very nice .. You know there is a device connect with this
that several of us have..


On Mon, Oct 28, 2013 at 01:43:24PM -0700, David Brown wrote:
> Support for the MSM7x00 SoCs was added starting in 2008 based on code
> from Google's Android kernels.  Platform support is fairly minimal,
> and there have primarily been trivial and cleanup changes to this
> code.
> 
> This code has not been converted to device tree, and is hindering
> supporting multi-platform on ARM.  If someone wishes to continue
> support for this target, patches that provide devicetree and
> multi-platform support can start by re-adding these files.
> 
> Signed-off-by: David Brown <davidb@codeaurora.org>
> ---
> Note that this patch was made with -D.  I can send the full patch on
> request, and have also made the tree available at: 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git for-3.14/big-cleanup
> 
>  arch/arm/mach-msm/Kconfig                       |  32 +-
>  arch/arm/mach-msm/Makefile                      |   4 -
>  arch/arm/mach-msm/board-halibut.c               | 110 ------
>  arch/arm/mach-msm/board-trout-gpio.c            | 233 ------------
>  arch/arm/mach-msm/board-trout-mmc.c             | 185 ---------
>  arch/arm/mach-msm/board-trout-panel.c           | 292 --------------
>  arch/arm/mach-msm/board-trout.c                 | 113 ------
>  arch/arm/mach-msm/board-trout.h                 | 162 --------
>  arch/arm/mach-msm/devices-msm7x00.c             | 480 ------------------------
>  arch/arm/mach-msm/include/mach/irqs-7x00.h      |  75 ----
>  arch/arm/mach-msm/include/mach/msm_iomap-7x00.h | 108 ------
>  arch/arm/mach-msm/irq.c                         | 151 --------
>  12 files changed, 1 insertion(+), 1944 deletions(-)
>  delete mode 100644 arch/arm/mach-msm/board-halibut.c
>  delete mode 100644 arch/arm/mach-msm/board-trout-gpio.c
>  delete mode 100644 arch/arm/mach-msm/board-trout-mmc.c
>  delete mode 100644 arch/arm/mach-msm/board-trout-panel.c
>  delete mode 100644 arch/arm/mach-msm/board-trout.c
>  delete mode 100644 arch/arm/mach-msm/board-trout.h
>  delete mode 100644 arch/arm/mach-msm/devices-msm7x00.c
>  delete mode 100644 arch/arm/mach-msm/include/mach/irqs-7x00.h
>  delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
>  delete mode 100644 arch/arm/mach-msm/irq.c
> 
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index 2586c28..d43d20c 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -5,19 +5,9 @@ comment "Qualcomm MSM SoC Type"
>  
>  choice
>  	prompt "Qualcomm MSM SoC Type"
> -	default ARCH_MSM7X00A
> +	default ARCH_MSM7X30
>  	depends on !ARCH_MSM_DT
>  
> -config ARCH_MSM7X00A
> -	bool "MSM7x00A / MSM7x01A"
> -	select ARCH_MSM_ARM11
> -	select CPU_V6
> -	select GPIO_MSM_V1
> -	select MACH_TROUT if !MACH_HALIBUT
> -	select MSM_PROC_COMM
> -	select MSM_SMD
> -	select MSM_SMD_PKG3
> -
>  config ARCH_MSM7X30
>  	bool "MSM7x30"
>  	select ARCH_MSM_SCORPION
> @@ -70,9 +60,6 @@ config MSM_HAS_DEBUG_UART_HS
>  config MSM_SOC_REV_A
>  	bool
>  
> -config  ARCH_MSM_ARM11
> -	bool
> -
>  config  ARCH_MSM_SCORPION
>  	bool
>  
> @@ -82,20 +69,6 @@ config  MSM_VIC
>  menu "Qualcomm MSM Board Type"
>  	depends on !ARCH_MSM_DT
>  
> -config MACH_HALIBUT
> -	depends on ARCH_MSM
> -	depends on ARCH_MSM7X00A
> -	bool "Halibut Board (QCT SURF7201A)"
> -	help
> -	  Support for the Qualcomm SURF7201A eval board.
> -
> -config MACH_TROUT
> -	depends on ARCH_MSM
> -	depends on ARCH_MSM7X00A
> -	bool "HTC Dream (aka trout)"
> -	help
> -	  Support for the HTC Dream, T-Mobile G1, Android ADP1 devices.
> -
>  config MACH_MSM7X30_SURF
>  	depends on ARCH_MSM7X30
>  	bool "MSM7x30 SURF"
> @@ -117,9 +90,6 @@ config MACH_QSD8X50A_ST1_5
>  
>  endmenu
>  
> -config MSM_SMD_PKG3
> -	bool
> -
>  config MSM_PROC_COMM
>  	bool
>  
> diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
> index 7ed4c1b..c7a5b53 100644
> --- a/arch/arm/mach-msm/Makefile
> +++ b/arch/arm/mach-msm/Makefile
> @@ -3,7 +3,6 @@ obj-y += clock.o
>  
>  obj-$(CONFIG_MSM_VIC) += irq-vic.o
>  
> -obj-$(CONFIG_ARCH_MSM7X00A) += irq.o
>  obj-$(CONFIG_ARCH_QSD8X50) += sirc.o
>  
>  obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
> @@ -21,9 +20,6 @@ CFLAGS_scm.o :=$(call as-instr,.arch_extension sec,-DREQUIRES_SEC=1)
>  obj-$(CONFIG_HOTPLUG_CPU) += hotplug.o
>  obj-$(CONFIG_SMP) += headsmp.o platsmp.o
>  
> -obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o devices-msm7x00.o
> -obj-$(CONFIG_MACH_TROUT) += board-trout.o board-trout-gpio.o board-trout-mmc.o board-trout-panel.o devices-msm7x00.o
> -obj-$(CONFIG_MACH_HALIBUT) += board-halibut.o devices-msm7x00.o
>  obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
>  obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
>  obj-$(CONFIG_ARCH_MSM_DT) += board-dt.o
> diff --git a/arch/arm/mach-msm/board-halibut.c b/arch/arm/mach-msm/board-halibut.c
> deleted file mode 100644
> index a775298..0000000
> diff --git a/arch/arm/mach-msm/board-trout-gpio.c b/arch/arm/mach-msm/board-trout-gpio.c
> deleted file mode 100644
> index 87e1d01..0000000
> diff --git a/arch/arm/mach-msm/board-trout-mmc.c b/arch/arm/mach-msm/board-trout-mmc.c
> deleted file mode 100644
> index 3723e55..0000000
> diff --git a/arch/arm/mach-msm/board-trout-panel.c b/arch/arm/mach-msm/board-trout-panel.c
> deleted file mode 100644
> index 77b0a26..0000000
> diff --git a/arch/arm/mach-msm/board-trout.c b/arch/arm/mach-msm/board-trout.c
> deleted file mode 100644
> index ccf6621..0000000
> diff --git a/arch/arm/mach-msm/board-trout.h b/arch/arm/mach-msm/board-trout.h
> deleted file mode 100644
> index b2379ed..0000000
> diff --git a/arch/arm/mach-msm/devices-msm7x00.c b/arch/arm/mach-msm/devices-msm7x00.c
> deleted file mode 100644
> index d83404d..0000000
> diff --git a/arch/arm/mach-msm/include/mach/irqs-7x00.h b/arch/arm/mach-msm/include/mach/irqs-7x00.h
> deleted file mode 100644
> index f1fe706..0000000
> diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x00.h
> deleted file mode 100644
> index 67dc0e9..0000000
> diff --git a/arch/arm/mach-msm/irq.c b/arch/arm/mach-msm/irq.c
> deleted file mode 100644
> index ea514be..0000000
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
