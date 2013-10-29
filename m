Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab3J2VQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:16:47 -0400
Received: from fifo99.com ([67.223.236.141]:57464 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab3J2VQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:16:45 -0400
Date: Tue, 29 Oct 2013 14:15:54 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: David Brown <davidb@codeaurora.org>
Cc: Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] ARM: msm: Remove 7x30 supporty
Message-ID: <20131029211554.GA16284@fifo99.com>
References: <1382993006-27359-1-git-send-email-davidb@codeaurora.org>
 <1382993006-27359-4-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382993006-27359-4-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Why wouldn't you just update it to use the device tree ? There are lots
of phones our there using 7x30 .. 

This is one that Qualcomm specifically upstreamed, so what was the point
of upstreaming it ?

On Mon, Oct 28, 2013 at 01:43:25PM -0700, David Brown wrote:
> The MSM7x30 SoC support was added in 2009 based on code from Google's
> Android kernels.  Platform support is fairly minimal, and the only
> changes that have been made have been trivial and cleanup changes.
> 
> This code has not been converted to device tree, and is hindering
> supporting multiple-platform on ARM.  If someone wishes to continue
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
>  arch/arm/mach-msm/Kconfig                       |  19 +-
>  arch/arm/mach-msm/Makefile                      |   2 -
>  arch/arm/mach-msm/board-msm7x30.c               | 157 ---------------
>  arch/arm/mach-msm/devices-msm7x30.c             | 246 ------------------------
>  arch/arm/mach-msm/include/mach/irqs-7x30.h      | 153 ---------------
>  arch/arm/mach-msm/include/mach/msm_iomap-7x30.h | 103 ----------
>  6 files changed, 1 insertion(+), 679 deletions(-)
>  delete mode 100644 arch/arm/mach-msm/board-msm7x30.c
>  delete mode 100644 arch/arm/mach-msm/devices-msm7x30.c
>  delete mode 100644 arch/arm/mach-msm/include/mach/irqs-7x30.h
>  delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
> 
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index d43d20c..c9c113d 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -5,20 +5,9 @@ comment "Qualcomm MSM SoC Type"
>  
>  choice
>  	prompt "Qualcomm MSM SoC Type"
> -	default ARCH_MSM7X30
> +	default ARCH_QSD8X50
>  	depends on !ARCH_MSM_DT
>  
> -config ARCH_MSM7X30
> -	bool "MSM7x30"
> -	select ARCH_MSM_SCORPION
> -	select CPU_V7
> -	select GPIO_MSM_V1
> -	select MACH_MSM7X30_SURF # if !
> -	select MSM_GPIOMUX
> -	select MSM_PROC_COMM
> -	select MSM_SMD
> -	select MSM_VIC
> -
>  config ARCH_QSD8X50
>  	bool "QSD8X50"
>  	select ARCH_MSM_SCORPION
> @@ -69,12 +58,6 @@ config  MSM_VIC
>  menu "Qualcomm MSM Board Type"
>  	depends on !ARCH_MSM_DT
>  
> -config MACH_MSM7X30_SURF
> -	depends on ARCH_MSM7X30
> -	bool "MSM7x30 SURF"
> -	help
> -	  Support for the Qualcomm MSM7x30 SURF eval board.
> -
>  config MACH_QSD8X50_SURF
>  	depends on ARCH_QSD8X50
>  	bool "QSD8x50 SURF"
> diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
> index c7a5b53..4bc7ee4 100644
> --- a/arch/arm/mach-msm/Makefile
> +++ b/arch/arm/mach-msm/Makefile
> @@ -8,7 +8,6 @@ obj-$(CONFIG_ARCH_QSD8X50) += sirc.o
>  obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
>  
>  obj-$(CONFIG_ARCH_MSM7X00A) += dma.o io.o
> -obj-$(CONFIG_ARCH_MSM7X30) += dma.o io.o
>  obj-$(CONFIG_ARCH_QSD8X50) += dma.o io.o
>  
>  obj-$(CONFIG_MSM_SMD) += smd.o smd_debug.o
> @@ -20,7 +19,6 @@ CFLAGS_scm.o :=$(call as-instr,.arch_extension sec,-DREQUIRES_SEC=1)
>  obj-$(CONFIG_HOTPLUG_CPU) += hotplug.o
>  obj-$(CONFIG_SMP) += headsmp.o platsmp.o
>  
> -obj-$(CONFIG_ARCH_MSM7X30) += board-msm7x30.o devices-msm7x30.o
>  obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
>  obj-$(CONFIG_ARCH_MSM_DT) += board-dt.o
>  obj-$(CONFIG_MSM_GPIOMUX) += gpiomux.o
> diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
> deleted file mode 100644
> index f9af5a4..0000000
> diff --git a/arch/arm/mach-msm/devices-msm7x30.c b/arch/arm/mach-msm/devices-msm7x30.c
> deleted file mode 100644
> index c15ea8a..0000000
> diff --git a/arch/arm/mach-msm/include/mach/irqs-7x30.h b/arch/arm/mach-msm/include/mach/irqs-7x30.h
> deleted file mode 100644
> index 1f15902..0000000
> diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h b/arch/arm/mach-msm/include/mach/msm_iomap-7x30.h
> deleted file mode 100644
> index 198202c..0000000
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
