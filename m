Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab3J2VTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 17:19:12 -0400
Received: from fifo99.com ([67.223.236.141]:58045 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab3J2VTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 17:19:11 -0400
Date: Tue, 29 Oct 2013 14:19:02 -0700
From: Daniel Walker <dwalker@fifo99.com>
To: David Brown <davidb@codeaurora.org>
Cc: Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] ARM: msm: Remove 8x50 support
Message-ID: <20131029211901.GB16284@fifo99.com>
References: <1382993006-27359-1-git-send-email-davidb@codeaurora.org>
 <1382993006-27359-5-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382993006-27359-5-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Isn't this the Nexus one platform ? Same as the last one , why don't you
just update it to use the device tree? This doesn't seem like it would
be all that difficult. 



On Mon, Oct 28, 2013 at 01:43:26PM -0700, David Brown wrote:
> The MSM8x50 SoC support was added in 2010 based on code from Google's
> Android kernels.  Platform support is fairly minimal, and the only
> changes that have been made have been trivial and cleanup changes.
> 
> This code has not been converted to device tree, and is hindering
> support for the multi-platform kernel on ARM.  If someone wishes to
> continue support for this target, patches that provide devicetree and
> multi-platform support can start by re-adding these files.
> 
> Signed-off-by: David Brown <davidb@codeaurora.org>
> ---
> Note that this patch was made with -D.  I can send the full patch on
> request, and have also made the tree available at: 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git for-3.14/big-cleanup
> 
>  arch/arm/mach-msm/Kconfig                       |   57 --
>  arch/arm/mach-msm/Makefile                      |   14 -
>  arch/arm/mach-msm/board-qsd8x50.c               |  213 -----
>  arch/arm/mach-msm/clock-pcom.c                  |  177 ----
>  arch/arm/mach-msm/clock-pcom.h                  |  145 ----
>  arch/arm/mach-msm/devices-qsd8x50.c             |  388 ---------
>  arch/arm/mach-msm/devices.h                     |   53 --
>  arch/arm/mach-msm/dma.c                         |  295 -------
>  arch/arm/mach-msm/gpiomux-8x50.c                |   51 --
>  arch/arm/mach-msm/gpiomux-v1.h                  |   67 --
>  arch/arm/mach-msm/gpiomux.c                     |  111 ---
>  arch/arm/mach-msm/gpiomux.h                     |   84 --
>  arch/arm/mach-msm/include/mach/entry-macro.S    |   36 -
>  arch/arm/mach-msm/include/mach/hardware.h       |   18 -
>  arch/arm/mach-msm/include/mach/irqs-8x50.h      |   88 --
>  arch/arm/mach-msm/include/mach/irqs.h           |   37 -
>  arch/arm/mach-msm/include/mach/msm_gpiomux.h    |   38 -
>  arch/arm/mach-msm/include/mach/msm_iomap-8x50.h |  125 ---
>  arch/arm/mach-msm/include/mach/msm_iomap.h      |   53 --
>  arch/arm/mach-msm/include/mach/msm_smd.h        |  109 ---
>  arch/arm/mach-msm/include/mach/sirc.h           |   98 ---
>  arch/arm/mach-msm/include/mach/vreg.h           |   29 -
>  arch/arm/mach-msm/io.c                          |  161 ----
>  arch/arm/mach-msm/irq-vic.c                     |  363 --------
>  arch/arm/mach-msm/last_radio_log.c              |   71 --
>  arch/arm/mach-msm/proc_comm.c                   |  129 ---
>  arch/arm/mach-msm/proc_comm.h                   |  258 ------
>  arch/arm/mach-msm/sirc.c                        |  172 ----
>  arch/arm/mach-msm/smd.c                         | 1035 -----------------------
>  arch/arm/mach-msm/smd_debug.c                   |  311 -------
>  arch/arm/mach-msm/smd_private.h                 |  403 ---------
>  arch/arm/mach-msm/vreg.c                        |  220 -----
>  32 files changed, 5409 deletions(-)
>  delete mode 100644 arch/arm/mach-msm/board-qsd8x50.c
>  delete mode 100644 arch/arm/mach-msm/clock-pcom.c
>  delete mode 100644 arch/arm/mach-msm/clock-pcom.h
>  delete mode 100644 arch/arm/mach-msm/devices-qsd8x50.c
>  delete mode 100644 arch/arm/mach-msm/devices.h
>  delete mode 100644 arch/arm/mach-msm/dma.c
>  delete mode 100644 arch/arm/mach-msm/gpiomux-8x50.c
>  delete mode 100644 arch/arm/mach-msm/gpiomux-v1.h
>  delete mode 100644 arch/arm/mach-msm/gpiomux.c
>  delete mode 100644 arch/arm/mach-msm/gpiomux.h
>  delete mode 100644 arch/arm/mach-msm/include/mach/entry-macro.S
>  delete mode 100644 arch/arm/mach-msm/include/mach/hardware.h
>  delete mode 100644 arch/arm/mach-msm/include/mach/irqs-8x50.h
>  delete mode 100644 arch/arm/mach-msm/include/mach/irqs.h
>  delete mode 100644 arch/arm/mach-msm/include/mach/msm_gpiomux.h
>  delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
>  delete mode 100644 arch/arm/mach-msm/include/mach/msm_iomap.h
>  delete mode 100644 arch/arm/mach-msm/include/mach/msm_smd.h
>  delete mode 100644 arch/arm/mach-msm/include/mach/sirc.h
>  delete mode 100644 arch/arm/mach-msm/include/mach/vreg.h
>  delete mode 100644 arch/arm/mach-msm/io.c
>  delete mode 100644 arch/arm/mach-msm/irq-vic.c
>  delete mode 100644 arch/arm/mach-msm/last_radio_log.c
>  delete mode 100644 arch/arm/mach-msm/proc_comm.c
>  delete mode 100644 arch/arm/mach-msm/proc_comm.h
>  delete mode 100644 arch/arm/mach-msm/sirc.c
>  delete mode 100644 arch/arm/mach-msm/smd.c
>  delete mode 100644 arch/arm/mach-msm/smd_debug.c
>  delete mode 100644 arch/arm/mach-msm/smd_private.h
>  delete mode 100644 arch/arm/mach-msm/vreg.c
> 
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index c9c113d..cb239ca 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -3,24 +3,6 @@ if ARCH_MSM
>  comment "Qualcomm MSM SoC Type"
>  	depends on ARCH_MSM_DT
>  
> -choice
> -	prompt "Qualcomm MSM SoC Type"
> -	default ARCH_QSD8X50
> -	depends on !ARCH_MSM_DT
> -
> -config ARCH_QSD8X50
> -	bool "QSD8X50"
> -	select ARCH_MSM_SCORPION
> -	select CPU_V7
> -	select GPIO_MSM_V1
> -	select MACH_QSD8X50_SURF if !MACH_QSD8X50A_ST1_5
> -	select MSM_GPIOMUX
> -	select MSM_PROC_COMM
> -	select MSM_SMD
> -	select MSM_VIC
> -
> -endchoice
> -
>  config ARCH_MSM8X60
>  	bool "MSM8X60"
>  	select ARM_GIC
> @@ -46,45 +28,6 @@ config ARCH_MSM_DT
>  config MSM_HAS_DEBUG_UART_HS
>  	bool
>  
> -config MSM_SOC_REV_A
> -	bool
> -
> -config  ARCH_MSM_SCORPION
> -	bool
> -
> -config  MSM_VIC
> -	bool
> -
> -menu "Qualcomm MSM Board Type"
> -	depends on !ARCH_MSM_DT
> -
> -config MACH_QSD8X50_SURF
> -	depends on ARCH_QSD8X50
> -	bool "QSD8x50 SURF"
> -	help
> -	  Support for the Qualcomm QSD8x50 SURF eval board.
> -
> -config MACH_QSD8X50A_ST1_5
> -	depends on ARCH_QSD8X50
> -	bool "QSD8x50A ST1.5"
> -	select MSM_SOC_REV_A
> -	help
> -	  Support for the Qualcomm ST1.5.
> -
> -endmenu
> -
> -config MSM_PROC_COMM
> -	bool
> -
> -config MSM_SMD
> -	bool
> -
> -config MSM_GPIOMUX
> -	bool
> -	depends on !ARCH_MSM_DT
> -	help
> -	  Support for MSM V1 TLMM GPIOMUX architecture.
> -
>  config MSM_SCM
>  	bool
>  endif
> diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
> index 4bc7ee4..0fa24f9 100644
> --- a/arch/arm/mach-msm/Makefile
> +++ b/arch/arm/mach-msm/Makefile
> @@ -1,17 +1,6 @@
>  obj-y += timer.o
>  obj-y += clock.o
>  
> -obj-$(CONFIG_MSM_VIC) += irq-vic.o
> -
> -obj-$(CONFIG_ARCH_QSD8X50) += sirc.o
> -
> -obj-$(CONFIG_MSM_PROC_COMM) += proc_comm.o clock-pcom.o vreg.o
> -
> -obj-$(CONFIG_ARCH_MSM7X00A) += dma.o io.o
> -obj-$(CONFIG_ARCH_QSD8X50) += dma.o io.o
> -
> -obj-$(CONFIG_MSM_SMD) += smd.o smd_debug.o
> -obj-$(CONFIG_MSM_SMD) += last_radio_log.o
>  obj-$(CONFIG_MSM_SCM) += scm.o scm-boot.o
>  
>  CFLAGS_scm.o :=$(call as-instr,.arch_extension sec,-DREQUIRES_SEC=1)
> @@ -19,7 +8,4 @@ CFLAGS_scm.o :=$(call as-instr,.arch_extension sec,-DREQUIRES_SEC=1)
>  obj-$(CONFIG_HOTPLUG_CPU) += hotplug.o
>  obj-$(CONFIG_SMP) += headsmp.o platsmp.o
>  
> -obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
>  obj-$(CONFIG_ARCH_MSM_DT) += board-dt.o
> -obj-$(CONFIG_MSM_GPIOMUX) += gpiomux.o
> -obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o
> diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
> deleted file mode 100644
> index 5f933bc..0000000
> diff --git a/arch/arm/mach-msm/clock-pcom.c b/arch/arm/mach-msm/clock-pcom.c
> deleted file mode 100644
> index 9a80449..0000000
> diff --git a/arch/arm/mach-msm/clock-pcom.h b/arch/arm/mach-msm/clock-pcom.h
> deleted file mode 100644
> index 5bb164f..0000000
> diff --git a/arch/arm/mach-msm/devices-qsd8x50.c b/arch/arm/mach-msm/devices-qsd8x50.c
> deleted file mode 100644
> index 9e1e9ce..0000000
> diff --git a/arch/arm/mach-msm/devices.h b/arch/arm/mach-msm/devices.h
> deleted file mode 100644
> index dccefad..0000000
> diff --git a/arch/arm/mach-msm/dma.c b/arch/arm/mach-msm/dma.c
> deleted file mode 100644
> index f8f6adf..0000000
> diff --git a/arch/arm/mach-msm/gpiomux-8x50.c b/arch/arm/mach-msm/gpiomux-8x50.c
> deleted file mode 100644
> index f7a4ea5..0000000
> diff --git a/arch/arm/mach-msm/gpiomux-v1.h b/arch/arm/mach-msm/gpiomux-v1.h
> deleted file mode 100644
> index 71d86fe..0000000
> diff --git a/arch/arm/mach-msm/gpiomux.c b/arch/arm/mach-msm/gpiomux.c
> deleted file mode 100644
> index 2b8e2d2..0000000
> diff --git a/arch/arm/mach-msm/gpiomux.h b/arch/arm/mach-msm/gpiomux.h
> deleted file mode 100644
> index 4410d77..0000000
> diff --git a/arch/arm/mach-msm/include/mach/entry-macro.S b/arch/arm/mach-msm/include/mach/entry-macro.S
> deleted file mode 100644
> index f2ae908..0000000
> diff --git a/arch/arm/mach-msm/include/mach/hardware.h b/arch/arm/mach-msm/include/mach/hardware.h
> deleted file mode 100644
> index 2d12609..0000000
> diff --git a/arch/arm/mach-msm/include/mach/irqs-8x50.h b/arch/arm/mach-msm/include/mach/irqs-8x50.h
> deleted file mode 100644
> index 26adbe0..0000000
> diff --git a/arch/arm/mach-msm/include/mach/irqs.h b/arch/arm/mach-msm/include/mach/irqs.h
> deleted file mode 100644
> index 164d355..0000000
> diff --git a/arch/arm/mach-msm/include/mach/msm_gpiomux.h b/arch/arm/mach-msm/include/mach/msm_gpiomux.h
> deleted file mode 100644
> index 0c7d393..0000000
> diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x50.h
> deleted file mode 100644
> index 0faa894..0000000
> diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
> deleted file mode 100644
> index 0e4f491..0000000
> diff --git a/arch/arm/mach-msm/include/mach/msm_smd.h b/arch/arm/mach-msm/include/mach/msm_smd.h
> deleted file mode 100644
> index 029463e..0000000
> diff --git a/arch/arm/mach-msm/include/mach/sirc.h b/arch/arm/mach-msm/include/mach/sirc.h
> deleted file mode 100644
> index ef55868..0000000
> diff --git a/arch/arm/mach-msm/include/mach/vreg.h b/arch/arm/mach-msm/include/mach/vreg.h
> deleted file mode 100644
> index 6626e78..0000000
> diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
> deleted file mode 100644
> index adc8971..0000000
> diff --git a/arch/arm/mach-msm/irq-vic.c b/arch/arm/mach-msm/irq-vic.c
> deleted file mode 100644
> index 1b54f80..0000000
> diff --git a/arch/arm/mach-msm/last_radio_log.c b/arch/arm/mach-msm/last_radio_log.c
> deleted file mode 100644
> index 9c392a2..0000000
> diff --git a/arch/arm/mach-msm/proc_comm.c b/arch/arm/mach-msm/proc_comm.c
> deleted file mode 100644
> index 507f5ca..0000000
> diff --git a/arch/arm/mach-msm/proc_comm.h b/arch/arm/mach-msm/proc_comm.h
> deleted file mode 100644
> index e8d043a..0000000
> diff --git a/arch/arm/mach-msm/sirc.c b/arch/arm/mach-msm/sirc.c
> deleted file mode 100644
> index 689e78c..0000000
> diff --git a/arch/arm/mach-msm/smd.c b/arch/arm/mach-msm/smd.c
> deleted file mode 100644
> index b1588a1..0000000
> diff --git a/arch/arm/mach-msm/smd_debug.c b/arch/arm/mach-msm/smd_debug.c
> deleted file mode 100644
> index 8056b3e..0000000
> diff --git a/arch/arm/mach-msm/smd_private.h b/arch/arm/mach-msm/smd_private.h
> deleted file mode 100644
> index 727bfe6..0000000
> diff --git a/arch/arm/mach-msm/vreg.c b/arch/arm/mach-msm/vreg.c
> deleted file mode 100644
> index bd66ed0..0000000
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
