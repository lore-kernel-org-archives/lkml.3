Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbaBZMn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 07:43:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.131]:62368 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaBZMnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 07:43:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        Cyril Chemparathy <cyril@ti.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/5] ARM: davinci: remove tnetv107x support
Date: Wed, 26 Feb 2014 13:43:30 +0100
Message-Id: <1393418614-3968549-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393418614-3968549-1-git-send-email-arnd@arndb.de>
References: <1393418614-3968549-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:jhcMeKcn5d3h2nyqxF73L0pG3AV/cbBb1blcntRlA4E
 GT2uRk+O7OspYQ8nwMWqq9pVYKNQIsRqCyMeJyqlspPHsc2J64
 qZLXWR/4Mz/j1RV/iVNp8nManG034InpSPvFe6EiJOZuTspL8s
 1OMWwoe6CaZ2kYR6mOCjVoUWdBzzP0CxORNmJfPVRqnMPGXj53
 RTH0kJHKspgyXIU2HbZWAoui8j7CKlozJgLRx72DYHAyzViILU
 Gl7Lpr4GUbKyYzHOlszlMnYeiPhO92v3+kvAGerqFubls7R/Je
 Yc+nn5CV/+XUYvY50wf6luaCocCxgImN1udqvPj9XwOMzP3wDC
 91aPOWMxp8kCSBgFo71GLSoZ/htdwwh3QPbEMAF96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tnetv107x support does not compile, and seems to have been broken
for a while with nobody caring to fix it. So far everyone I asked
said it's probably dead and completely unused and will never again
be needed in a future kernel release, so let's delete it.

If someone finds a use for this code later and is able to get it
to work again, we can always revert the removal.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig.debug                          |  13 +-
 arch/arm/mach-davinci/Kconfig                   |  12 -
 arch/arm/mach-davinci/Makefile                  |   2 -
 arch/arm/mach-davinci/board-tnetv107x-evm.c     | 287 ---------
 arch/arm/mach-davinci/devices-tnetv107x.c       | 434 --------------
 arch/arm/mach-davinci/include/mach/cputype.h    |   8 -
 arch/arm/mach-davinci/include/mach/irqs.h       |  97 ---
 arch/arm/mach-davinci/include/mach/mux.h        | 269 ---------
 arch/arm/mach-davinci/include/mach/psc.h        |  47 --
 arch/arm/mach-davinci/include/mach/serial.h     |   8 -
 arch/arm/mach-davinci/include/mach/tnetv107x.h  |  61 --
 arch/arm/mach-davinci/include/mach/uncompress.h |   6 -
 arch/arm/mach-davinci/tnetv107x.c               | 766 ------------------------
 13 files changed, 1 insertion(+), 2009 deletions(-)
 delete mode 100644 arch/arm/mach-davinci/board-tnetv107x-evm.c
 delete mode 100644 arch/arm/mach-davinci/devices-tnetv107x.c
 delete mode 100644 arch/arm/mach-davinci/include/mach/tnetv107x.h
 delete mode 100644 arch/arm/mach-davinci/tnetv107x.c

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 0531da8..c29c395 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -171,15 +171,6 @@ choice
 		  Say Y here if you want the debug print routines to direct
 		  their output to UART0 serial port on DaVinci DMx devices.
 
-	config DEBUG_DAVINCI_TNETV107X_UART1
-		bool "Kernel low-level debugging on DaVinci TNETV107x using UART1"
-		depends on ARCH_DAVINCI_TNETV107X
-		select DEBUG_UART_8250
-		help
-		  Say Y here if you want the debug print routines to direct
-		  their output to UART1 serial port on DaVinci TNETV107X
-		  devices.
-
 	config DEBUG_ZYNQ_UART0
 		bool "Kernel low-level debugging on Xilinx Zynq using UART0"
 		depends on ARCH_ZYNQ
@@ -1014,7 +1005,6 @@ config DEBUG_UART_PHYS
 	default 0x02530c00 if DEBUG_KEYSTONE_UART0
 	default 0x02531000 if DEBUG_KEYSTONE_UART1
 	default 0x03010fe0 if ARCH_RPC
-	default 0x08108300 if DEBUG_DAVINCI_TNETV107X_UART1
 	default 0x10009000 if DEBUG_REALVIEW_STD_PORT || DEBUG_CNS3XXX || \
 				DEBUG_VEXPRESS_UART0_CA9
 	default 0x1010c000 if DEBUG_REALVIEW_PB1176_PORT
@@ -1110,7 +1100,6 @@ config DEBUG_UART_VIRT
 	default 0xfed12000 if ARCH_KIRKWOOD
 	default 0xfedc0000 if ARCH_EP93XX
 	default 0xfee003f8 if FOOTBRIDGE
-	default 0xfee08300 if DEBUG_DAVINCI_TNETV107X_UART1
 	default 0xfee20000 if DEBUG_NSPIRE_CLASSIC_UART || DEBUG_NSPIRE_CX_UART
 	default 0xfef36000 if DEBUG_HIGHBANK_UART
 	default 0xfee82340 if ARCH_IOP13XX
@@ -1135,7 +1124,7 @@ config DEBUG_UART_8250_WORD
 	default y if DEBUG_PICOXCELL_UART || DEBUG_SOCFPGA_UART || \
 		ARCH_KEYSTONE || \
 		DEBUG_DAVINCI_DMx_UART0 || DEBUG_DAVINCI_DA8XX_UART1 || \
-		DEBUG_DAVINCI_DA8XX_UART2 || DEBUG_DAVINCI_TNETV107X_UART1 || \
+		DEBUG_DAVINCI_DA8XX_UART2 || \
 		DEBUG_BCM_KONA_UART
 
 config DEBUG_UART_8250_FLOW_CONTROL
diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index a075b3e..3b98e34 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -51,11 +51,6 @@ config ARCH_DAVINCI_DM365
 	select AINTC
 	select ARCH_DAVINCI_DMx
 
-config ARCH_DAVINCI_TNETV107X
-	bool "TNETV107X based system"
-	select CPU_V6
-	select CP_INTC
-
 comment "DaVinci Board Type"
 
 config MACH_DA8XX_DT
@@ -220,13 +215,6 @@ config GPIO_PCA953X
 config KEYBOARD_GPIO_POLLED
 	default MACH_DAVINCI_DA850_EVM
 
-config MACH_TNETV107X
-	bool "TI TNETV107X Reference Platform"
-	default ARCH_DAVINCI_TNETV107X
-	depends on ARCH_DAVINCI_TNETV107X
-	help
-	  Say Y here to select the TI TNETV107X Evaluation Module.
-
 config MACH_MITYOMAPL138
 	bool "Critical Link MityDSP-L138/MityARM-1808 SoM"
 	depends on ARCH_DAVINCI_DA850
diff --git a/arch/arm/mach-davinci/Makefile b/arch/arm/mach-davinci/Makefile
index 63997a1..2204239 100644
--- a/arch/arm/mach-davinci/Makefile
+++ b/arch/arm/mach-davinci/Makefile
@@ -16,7 +16,6 @@ obj-$(CONFIG_ARCH_DAVINCI_DM646x)       += dm646x.o devices.o
 obj-$(CONFIG_ARCH_DAVINCI_DM365)	+= dm365.o devices.o
 obj-$(CONFIG_ARCH_DAVINCI_DA830)        += da830.o devices-da8xx.o
 obj-$(CONFIG_ARCH_DAVINCI_DA850)        += da850.o devices-da8xx.o
-obj-$(CONFIG_ARCH_DAVINCI_TNETV107X)    += tnetv107x.o devices-tnetv107x.o
 
 obj-$(CONFIG_AINTC)			+= irq.o
 obj-$(CONFIG_CP_INTC)			+= cp_intc.o
@@ -32,7 +31,6 @@ obj-$(CONFIG_MACH_DAVINCI_DM6467_EVM)	+= board-dm646x-evm.o cdce949.o
 obj-$(CONFIG_MACH_DAVINCI_DM365_EVM)	+= board-dm365-evm.o
 obj-$(CONFIG_MACH_DAVINCI_DA830_EVM)	+= board-da830-evm.o
 obj-$(CONFIG_MACH_DAVINCI_DA850_EVM)	+= board-da850-evm.o
-obj-$(CONFIG_MACH_TNETV107X)		+= board-tnetv107x-evm.o
 obj-$(CONFIG_MACH_MITYOMAPL138)		+= board-mityomapl138.o
 obj-$(CONFIG_MACH_OMAPL138_HAWKBOARD)	+= board-omapl138-hawk.o
 
diff --git a/arch/arm/mach-davinci/board-tnetv107x-evm.c b/arch/arm/mach-davinci/board-tnetv107x-evm.c
deleted file mode 100644
index 78ea395..0000000
--- a/arch/arm/mach-davinci/board-tnetv107x-evm.c
+++ /dev/null
@@ -1,287 +0,0 @@
-/*
- * Texas Instruments TNETV107X EVM Board Support
- *
- * Copyright (C) 2010 Texas Instruments
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/console.h>
-#include <linux/dma-mapping.h>
-#include <linux/interrupt.h>
-#include <linux/gpio.h>
-#include <linux/delay.h>
-#include <linux/platform_device.h>
-#include <linux/ratelimit.h>
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/partitions.h>
-#include <linux/input.h>
-#include <linux/input/matrix_keypad.h>
-#include <linux/spi/spi.h>
-#include <linux/platform_data/edma.h>
-
-#include <asm/mach/arch.h>
-#include <asm/mach-types.h>
-
-#include <mach/irqs.h>
-#include <mach/mux.h>
-#include <mach/cp_intc.h>
-#include <mach/tnetv107x.h>
-
-#define EVM_MMC_WP_GPIO		21
-#define EVM_MMC_CD_GPIO		24
-#define EVM_SPI_CS_GPIO		54
-
-static int initialize_gpio(int gpio, char *desc)
-{
-	int ret;
-
-	ret = gpio_request(gpio, desc);
-	if (ret < 0) {
-		pr_err_ratelimited("cannot open %s gpio\n", desc);
-		return -ENOSYS;
-	}
-	gpio_direction_input(gpio);
-	return gpio;
-}
-
-static int mmc_get_cd(int index)
-{
-	static int gpio;
-
-	if (!gpio)
-		gpio = initialize_gpio(EVM_MMC_CD_GPIO, "mmc card detect");
-
-	if (gpio < 0)
-		return gpio;
-
-	return gpio_get_value(gpio) ? 0 : 1;
-}
-
-static int mmc_get_ro(int index)
-{
-	static int gpio;
-
-	if (!gpio)
-		gpio = initialize_gpio(EVM_MMC_WP_GPIO, "mmc write protect");
-
-	if (gpio < 0)
-		return gpio;
-
-	return gpio_get_value(gpio) ? 1 : 0;
-}
-
-static struct davinci_mmc_config mmc_config = {
-	.get_cd		= mmc_get_cd,
-	.get_ro		= mmc_get_ro,
-	.wires		= 4,
-	.max_freq	= 50000000,
-	.caps		= MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED,
-};
-
-static const short sdio1_pins[] __initconst = {
-	TNETV107X_SDIO1_CLK_1,		TNETV107X_SDIO1_CMD_1,
-	TNETV107X_SDIO1_DATA0_1,	TNETV107X_SDIO1_DATA1_1,
-	TNETV107X_SDIO1_DATA2_1,	TNETV107X_SDIO1_DATA3_1,
-	TNETV107X_GPIO21,		TNETV107X_GPIO24,
-	-1
-};
-
-static const short uart1_pins[] __initconst = {
-	TNETV107X_UART1_RD,		TNETV107X_UART1_TD,
-	-1
-};
-
-static const short ssp_pins[] __initconst = {
-	TNETV107X_SSP0_0, TNETV107X_SSP0_1, TNETV107X_SSP0_2,
-	TNETV107X_SSP1_0, TNETV107X_SSP1_1, TNETV107X_SSP1_2,
-	TNETV107X_SSP1_3, -1
-};
-
-static struct mtd_partition nand_partitions[] = {
-	/* bootloader (U-Boot, etc) in first 12 sectors */
-	{
-		.name		= "bootloader",
-		.offset		= 0,
-		.size		= (12*SZ_128K),
-		.mask_flags	= MTD_WRITEABLE,	/* force read-only */
-	},
-	/* bootloader params in the next sector */
-	{
-		.name		= "params",
-		.offset		= MTDPART_OFS_NXTBLK,
-		.size		= SZ_128K,
-		.mask_flags	= MTD_WRITEABLE,	/* force read-only */
-	},
-	/* kernel */
-	{
-		.name		= "kernel",
-		.offset		= MTDPART_OFS_NXTBLK,
-		.size		= SZ_4M,
-		.mask_flags	= 0,
-	},
-	/* file system */
-	{
-		.name		= "filesystem",
-		.offset		= MTDPART_OFS_NXTBLK,
-		.size		= MTDPART_SIZ_FULL,
-		.mask_flags	= 0,
-	}
-};
-
-static struct davinci_nand_pdata nand_config = {
-	.mask_cle	= 0x4000,
-	.mask_ale	= 0x2000,
-	.parts		= nand_partitions,
-	.nr_parts	= ARRAY_SIZE(nand_partitions),
-	.ecc_mode	= NAND_ECC_HW,
-	.bbt_options	= NAND_BBT_USE_FLASH,
-	.ecc_bits	= 1,
-};
-
-static struct davinci_uart_config serial_config __initconst = {
-	.enabled_uarts	= BIT(1),
-};
-
-static const uint32_t keymap[] = {
-	KEY(0, 0, KEY_NUMERIC_1),
-	KEY(0, 1, KEY_NUMERIC_2),
-	KEY(0, 2, KEY_NUMERIC_3),
-	KEY(0, 3, KEY_FN_F1),
-	KEY(0, 4, KEY_MENU),
-
-	KEY(1, 0, KEY_NUMERIC_4),
-	KEY(1, 1, KEY_NUMERIC_5),
-	KEY(1, 2, KEY_NUMERIC_6),
-	KEY(1, 3, KEY_UP),
-	KEY(1, 4, KEY_FN_F2),
-
-	KEY(2, 0, KEY_NUMERIC_7),
-	KEY(2, 1, KEY_NUMERIC_8),
-	KEY(2, 2, KEY_NUMERIC_9),
-	KEY(2, 3, KEY_LEFT),
-	KEY(2, 4, KEY_ENTER),
-
-	KEY(3, 0, KEY_NUMERIC_STAR),
-	KEY(3, 1, KEY_NUMERIC_0),
-	KEY(3, 2, KEY_NUMERIC_POUND),
-	KEY(3, 3, KEY_DOWN),
-	KEY(3, 4, KEY_RIGHT),
-
-	KEY(4, 0, KEY_FN_F3),
-	KEY(4, 1, KEY_FN_F4),
-	KEY(4, 2, KEY_MUTE),
-	KEY(4, 3, KEY_HOME),
-	KEY(4, 4, KEY_BACK),
-
-	KEY(5, 0, KEY_VOLUMEDOWN),
-	KEY(5, 1, KEY_VOLUMEUP),
-	KEY(5, 2, KEY_F1),
-	KEY(5, 3, KEY_F2),
-	KEY(5, 4, KEY_F3),
-};
-
-static const struct matrix_keymap_data keymap_data = {
-	.keymap		= keymap,
-	.keymap_size	= ARRAY_SIZE(keymap),
-};
-
-static struct matrix_keypad_platform_data keypad_config = {
-	.keymap_data	= &keymap_data,
-	.num_row_gpios	= 6,
-	.num_col_gpios	= 5,
-	.debounce_ms	= 0, /* minimum */
-	.active_low	= 0, /* pull up realization */
-	.no_autorepeat	= 0,
-};
-
-static void spi_select_device(int cs)
-{
-	static int gpio;
-
-	if (!gpio) {
-		int ret;
-		ret = gpio_request(EVM_SPI_CS_GPIO, "spi chipsel");
-		if (ret < 0) {
-			pr_err("cannot open spi chipsel gpio\n");
-			gpio = -ENOSYS;
-			return;
-		} else {
-			gpio = EVM_SPI_CS_GPIO;
-			gpio_direction_output(gpio, 0);
-		}
-	}
-
-	if (gpio < 0)
-		return;
-
-	return gpio_set_value(gpio, cs ? 1 : 0);
-}
-
-static struct ti_ssp_spi_data spi_master_data = {
-	.num_cs	= 2,
-	.select	= spi_select_device,
-	.iosel	= SSP_PIN_SEL(0, SSP_CLOCK)	| SSP_PIN_SEL(1, SSP_DATA) |
-		  SSP_PIN_SEL(2, SSP_CHIPSEL)	| SSP_PIN_SEL(3, SSP_IN)   |
-		  SSP_INPUT_SEL(3),
-};
-
-static struct ti_ssp_data ssp_config = {
-	.out_clock	= 250 * 1000,
-	.dev_data	= {
-		[1] = {
-			.dev_name = "ti-ssp-spi",
-			.pdata = &spi_master_data,
-			.pdata_size = sizeof(spi_master_data),
-		},
-	},
-};
-
-static struct tnetv107x_device_info evm_device_info __initconst = {
-	.serial_config		= &serial_config,
-	.mmc_config[1]		= &mmc_config,	/* controller 1 */
-	.nand_config[0]		= &nand_config,	/* chip select 0 */
-	.keypad_config		= &keypad_config,
-	.ssp_config		= &ssp_config,
-};
-
-static struct spi_board_info spi_info[] __initconst = {
-};
-
-static __init void tnetv107x_evm_board_init(void)
-{
-	davinci_cfg_reg_list(sdio1_pins);
-	davinci_cfg_reg_list(uart1_pins);
-	davinci_cfg_reg_list(ssp_pins);
-
-	tnetv107x_devices_init(&evm_device_info);
-
-	spi_register_board_info(spi_info, ARRAY_SIZE(spi_info));
-}
-
-#ifdef CONFIG_SERIAL_8250_CONSOLE
-static int __init tnetv107x_evm_console_init(void)
-{
-	return add_preferred_console("ttyS", 0, "115200");
-}
-console_initcall(tnetv107x_evm_console_init);
-#endif
-
-MACHINE_START(TNETV107X, "TNETV107X EVM")
-	.atag_offset	= 0x100,
-	.map_io		= tnetv107x_init,
-	.init_irq	= cp_intc_init,
-	.init_time	= davinci_timer_init,
-	.init_machine	= tnetv107x_evm_board_init,
-	.init_late	= davinci_init_late,
-	.dma_zone_size	= SZ_128M,
-	.restart	= tnetv107x_restart,
-MACHINE_END
diff --git a/arch/arm/mach-davinci/devices-tnetv107x.c b/arch/arm/mach-davinci/devices-tnetv107x.c
deleted file mode 100644
index 01d8686..0000000
--- a/arch/arm/mach-davinci/devices-tnetv107x.c
+++ /dev/null
@@ -1,434 +0,0 @@
-/*
- * Texas Instruments TNETV107X SoC devices
- *
- * Copyright (C) 2010 Texas Instruments
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/dma-mapping.h>
-#include <linux/clk.h>
-#include <linux/slab.h>
-#include <linux/platform_data/edma.h>
-
-#include <mach/common.h>
-#include <mach/irqs.h>
-#include <mach/tnetv107x.h>
-
-#include "clock.h"
-
-/* Base addresses for on-chip devices */
-#define TNETV107X_TPCC_BASE			0x01c00000
-#define TNETV107X_TPTC0_BASE			0x01c10000
-#define TNETV107X_TPTC1_BASE			0x01c10400
-#define TNETV107X_WDOG_BASE			0x08086700
-#define TNETV107X_TSC_BASE			0x08088500
-#define TNETV107X_SDIO0_BASE			0x08088700
-#define TNETV107X_SDIO1_BASE			0x08088800
-#define TNETV107X_KEYPAD_BASE			0x08088a00
-#define TNETV107X_SSP_BASE			0x08088c00
-#define TNETV107X_ASYNC_EMIF_CNTRL_BASE		0x08200000
-#define TNETV107X_ASYNC_EMIF_DATA_CE0_BASE	0x30000000
-#define TNETV107X_ASYNC_EMIF_DATA_CE1_BASE	0x40000000
-#define TNETV107X_ASYNC_EMIF_DATA_CE2_BASE	0x44000000
-#define TNETV107X_ASYNC_EMIF_DATA_CE3_BASE	0x48000000
-
-/* TNETV107X specific EDMA3 information */
-#define EDMA_TNETV107X_NUM_DMACH	64
-#define EDMA_TNETV107X_NUM_TCC		64
-#define EDMA_TNETV107X_NUM_PARAMENTRY	128
-#define EDMA_TNETV107X_NUM_EVQUE	2
-#define EDMA_TNETV107X_NUM_TC		2
-#define EDMA_TNETV107X_CHMAP_EXIST	0
-#define EDMA_TNETV107X_NUM_REGIONS	4
-#define TNETV107X_DMACH2EVENT_MAP0	0x3C0CE000u
-#define TNETV107X_DMACH2EVENT_MAP1	0x000FFFFFu
-
-#define TNETV107X_DMACH_SDIO0_RX		26
-#define TNETV107X_DMACH_SDIO0_TX		27
-#define TNETV107X_DMACH_SDIO1_RX		28
-#define TNETV107X_DMACH_SDIO1_TX		29
-
-static s8 edma_tc_mapping[][2] = {
-	/* event queue no	TC no	*/
-	{	 0,		 0	},
-	{	 1,		 1	},
-	{	-1,		-1	}
-};
-
-static s8 edma_priority_mapping[][2] = {
-	/* event queue no	Prio	*/
-	{	 0,		 3	},
-	{	 1,		 7	},
-	{	-1,		-1	}
-};
-
-static struct edma_soc_info edma_cc0_info = {
-	.n_channel		= EDMA_TNETV107X_NUM_DMACH,
-	.n_region		= EDMA_TNETV107X_NUM_REGIONS,
-	.n_slot			= EDMA_TNETV107X_NUM_PARAMENTRY,
-	.n_tc			= EDMA_TNETV107X_NUM_TC,
-	.n_cc			= 1,
-	.queue_tc_mapping	= edma_tc_mapping,
-	.queue_priority_mapping	= edma_priority_mapping,
-	.default_queue		= EVENTQ_1,
-};
-
-static struct edma_soc_info *tnetv107x_edma_info[EDMA_MAX_CC] = {
-	&edma_cc0_info,
-};
-
-static struct resource edma_resources[] = {
-	{
-		.name	= "edma_cc0",
-		.start	= TNETV107X_TPCC_BASE,
-		.end	= TNETV107X_TPCC_BASE + SZ_32K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	{
-		.name	= "edma_tc0",
-		.start	= TNETV107X_TPTC0_BASE,
-		.end	= TNETV107X_TPTC0_BASE + SZ_1K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	{
-		.name	= "edma_tc1",
-		.start	= TNETV107X_TPTC1_BASE,
-		.end	= TNETV107X_TPTC1_BASE + SZ_1K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	{
-		.name	= "edma0",
-		.start	= IRQ_TNETV107X_TPCC,
-		.flags	= IORESOURCE_IRQ,
-	},
-	{
-		.name	= "edma0_err",
-		.start	= IRQ_TNETV107X_TPCC_ERR,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device edma_device = {
-	.name		= "edma",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(edma_resources),
-	.resource	= edma_resources,
-	.dev.platform_data = tnetv107x_edma_info,
-};
-
-static struct plat_serial8250_port serial0_platform_data[] = {
-	{
-		.mapbase	= TNETV107X_UART0_BASE,
-		.irq		= IRQ_TNETV107X_UART0,
-		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST |
-					UPF_FIXED_TYPE | UPF_IOREMAP,
-		.type		= PORT_AR7,
-		.iotype		= UPIO_MEM32,
-		.regshift	= 2,
-	},
-	{
-		.flags	= 0,
-	}
-};
-static struct plat_serial8250_port serial1_platform_data[] = {
-	{
-		.mapbase	= TNETV107X_UART1_BASE,
-		.irq		= IRQ_TNETV107X_UART1,
-		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST |
-					UPF_FIXED_TYPE | UPF_IOREMAP,
-		.type		= PORT_AR7,
-		.iotype		= UPIO_MEM32,
-		.regshift	= 2,
-	},
-	{
-		.flags	= 0,
-	}
-};
-static struct plat_serial8250_port serial2_platform_data[] = {
-	{
-		.mapbase	= TNETV107X_UART2_BASE,
-		.irq		= IRQ_TNETV107X_UART2,
-		.flags		= UPF_BOOT_AUTOCONF | UPF_SKIP_TEST |
-					UPF_FIXED_TYPE | UPF_IOREMAP,
-		.type		= PORT_AR7,
-		.iotype		= UPIO_MEM32,
-		.regshift	= 2,
-	},
-	{
-		.flags	= 0,
-	}
-};
-
-
-struct platform_device tnetv107x_serial_device[] = {
-	{
-		.name			= "serial8250",
-		.id			= PLAT8250_DEV_PLATFORM,
-		.dev.platform_data	= serial0_platform_data,
-	},
-	{
-		.name			= "serial8250",
-		.id			= PLAT8250_DEV_PLATFORM1,
-		.dev.platform_data	= serial1_platform_data,
-	},
-	{
-		.name			= "serial8250",
-		.id			= PLAT8250_DEV_PLATFORM2,
-		.dev.platform_data	= serial2_platform_data,
-	},
-	{
-	}
-};
-
-static struct resource mmc0_resources[] = {
-	{ /* Memory mapped registers */
-		.start	= TNETV107X_SDIO0_BASE,
-		.end	= TNETV107X_SDIO0_BASE + 0x0ff,
-		.flags	= IORESOURCE_MEM
-	},
-	{ /* MMC interrupt */
-		.start	= IRQ_TNETV107X_MMC0,
-		.flags	= IORESOURCE_IRQ
-	},
-	{ /* SDIO interrupt */
-		.start	= IRQ_TNETV107X_SDIO0,
-		.flags	= IORESOURCE_IRQ
-	},
-	{ /* DMA RX */
-		.start	= EDMA_CTLR_CHAN(0, TNETV107X_DMACH_SDIO0_RX),
-		.flags	= IORESOURCE_DMA
-	},
-	{ /* DMA TX */
-		.start	= EDMA_CTLR_CHAN(0, TNETV107X_DMACH_SDIO0_TX),
-		.flags	= IORESOURCE_DMA
-	},
-};
-
-static struct resource mmc1_resources[] = {
-	{ /* Memory mapped registers */
-		.start	= TNETV107X_SDIO1_BASE,
-		.end	= TNETV107X_SDIO1_BASE + 0x0ff,
-		.flags	= IORESOURCE_MEM
-	},
-	{ /* MMC interrupt */
-		.start	= IRQ_TNETV107X_MMC1,
-		.flags	= IORESOURCE_IRQ
-	},
-	{ /* SDIO interrupt */
-		.start	= IRQ_TNETV107X_SDIO1,
-		.flags	= IORESOURCE_IRQ
-	},
-	{ /* DMA RX */
-		.start	= EDMA_CTLR_CHAN(0, TNETV107X_DMACH_SDIO1_RX),
-		.flags	= IORESOURCE_DMA
-	},
-	{ /* DMA TX */
-		.start	= EDMA_CTLR_CHAN(0, TNETV107X_DMACH_SDIO1_TX),
-		.flags	= IORESOURCE_DMA
-	},
-};
-
-static u64 mmc0_dma_mask = DMA_BIT_MASK(32);
-static u64 mmc1_dma_mask = DMA_BIT_MASK(32);
-
-static struct platform_device mmc_devices[2] = {
-	{
-		.name		= "dm6441-mmc",
-		.id		= 0,
-		.dev		= {
-			.dma_mask		= &mmc0_dma_mask,
-			.coherent_dma_mask	= DMA_BIT_MASK(32),
-		},
-		.num_resources	= ARRAY_SIZE(mmc0_resources),
-		.resource	= mmc0_resources
-	},
-	{
-		.name		= "dm6441-mmc",
-		.id		= 1,
-		.dev		= {
-			.dma_mask		= &mmc1_dma_mask,
-			.coherent_dma_mask	= DMA_BIT_MASK(32),
-		},
-		.num_resources	= ARRAY_SIZE(mmc1_resources),
-		.resource	= mmc1_resources
-	},
-};
-
-static const u32 emif_windows[] = {
-	TNETV107X_ASYNC_EMIF_DATA_CE0_BASE, TNETV107X_ASYNC_EMIF_DATA_CE1_BASE,
-	TNETV107X_ASYNC_EMIF_DATA_CE2_BASE, TNETV107X_ASYNC_EMIF_DATA_CE3_BASE,
-};
-
-static const u32 emif_window_sizes[] = { SZ_256M, SZ_64M, SZ_64M, SZ_64M };
-
-static struct resource wdt_resources[] = {
-	{
-		.start	= TNETV107X_WDOG_BASE,
-		.end	= TNETV107X_WDOG_BASE + SZ_4K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-struct platform_device tnetv107x_wdt_device = {
-	.name		= "tnetv107x_wdt",
-	.id		= 0,
-	.num_resources	= ARRAY_SIZE(wdt_resources),
-	.resource	= wdt_resources,
-};
-
-static int __init nand_init(int chipsel, struct davinci_nand_pdata *data)
-{
-	struct resource res[2];
-	struct platform_device *pdev;
-	u32	range;
-	int	ret;
-
-	/* Figure out the resource range from the ale/cle masks */
-	range = max(data->mask_cle, data->mask_ale);
-	range = PAGE_ALIGN(range + 4) - 1;
-
-	if (range >= emif_window_sizes[chipsel])
-		return -EINVAL;
-
-	pdev = kzalloc(sizeof(*pdev), GFP_KERNEL);
-	if (!pdev)
-		return -ENOMEM;
-
-	pdev->name		= "davinci_nand";
-	pdev->id		= chipsel;
-	pdev->dev.platform_data	= data;
-
-	memset(res, 0, sizeof(res));
-
-	res[0].start	= emif_windows[chipsel];
-	res[0].end	= res[0].start + range;
-	res[0].flags	= IORESOURCE_MEM;
-
-	res[1].start	= TNETV107X_ASYNC_EMIF_CNTRL_BASE;
-	res[1].end	= res[1].start + SZ_4K - 1;
-	res[1].flags	= IORESOURCE_MEM;
-
-	ret = platform_device_add_resources(pdev, res, ARRAY_SIZE(res));
-	if (ret < 0) {
-		kfree(pdev);
-		return ret;
-	}
-
-	return platform_device_register(pdev);
-}
-
-static struct resource keypad_resources[] = {
-	{
-		.start	= TNETV107X_KEYPAD_BASE,
-		.end	= TNETV107X_KEYPAD_BASE + 0xff,
-		.flags	= IORESOURCE_MEM,
-	},
-	{
-		.start	= IRQ_TNETV107X_KEYPAD,
-		.flags	= IORESOURCE_IRQ,
-		.name	= "press",
-	},
-	{
-		.start	= IRQ_TNETV107X_KEYPAD_FREE,
-		.flags	= IORESOURCE_IRQ,
-		.name	= "release",
-	},
-};
-
-static struct platform_device keypad_device = {
-	.name		= "tnetv107x-keypad",
-	.num_resources	= ARRAY_SIZE(keypad_resources),
-	.resource	= keypad_resources,
-};
-
-static struct resource tsc_resources[] = {
-	{
-		.start	= TNETV107X_TSC_BASE,
-		.end	= TNETV107X_TSC_BASE + 0xff,
-		.flags	= IORESOURCE_MEM,
-	},
-	{
-		.start	= IRQ_TNETV107X_TSC,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device tsc_device = {
-	.name		= "tnetv107x-ts",
-	.num_resources	= ARRAY_SIZE(tsc_resources),
-	.resource	= tsc_resources,
-};
-
-static struct resource ssp_resources[] = {
-	{
-		.start	= TNETV107X_SSP_BASE,
-		.end	= TNETV107X_SSP_BASE + 0x1ff,
-		.flags	= IORESOURCE_MEM,
-	},
-	{
-		.start	= IRQ_TNETV107X_SSP,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device ssp_device = {
-	.name		= "ti-ssp",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(ssp_resources),
-	.resource	= ssp_resources,
-};
-
-void __init tnetv107x_devices_init(struct tnetv107x_device_info *info)
-{
-	int i, error;
-	struct clk *tsc_clk;
-
-	/*
-	 * The reset defaults for tnetv107x tsc clock divider is set too high.
-	 * This forces the clock down to a range that allows the ADC to
-	 * complete sample conversion in time.
-	 */
-	tsc_clk = clk_get(NULL, "sys_tsc_clk");
-	if (!IS_ERR(tsc_clk)) {
-		error = clk_set_rate(tsc_clk, 5000000);
-		WARN_ON(error < 0);
-		clk_put(tsc_clk);
-	}
-
-	platform_device_register(&edma_device);
-	platform_device_register(&tnetv107x_wdt_device);
-	platform_device_register(&tsc_device);
-
-	if (info->serial_config)
-		davinci_serial_init(tnetv107x_serial_device);
-
-	for (i = 0; i < 2; i++)
-		if (info->mmc_config[i]) {
-			mmc_devices[i].dev.platform_data = info->mmc_config[i];
-			platform_device_register(&mmc_devices[i]);
-		}
-
-	for (i = 0; i < 4; i++)
-		if (info->nand_config[i])
-			nand_init(i, info->nand_config[i]);
-
-	if (info->keypad_config) {
-		keypad_device.dev.platform_data = info->keypad_config;
-		platform_device_register(&keypad_device);
-	}
-
-	if (info->ssp_config) {
-		ssp_device.dev.platform_data = info->ssp_config;
-		platform_device_register(&ssp_device);
-	}
-}
diff --git a/arch/arm/mach-davinci/include/mach/cputype.h b/arch/arm/mach-davinci/include/mach/cputype.h
index 957fb87..1fc84e2 100644
--- a/arch/arm/mach-davinci/include/mach/cputype.h
+++ b/arch/arm/mach-davinci/include/mach/cputype.h
@@ -33,7 +33,6 @@ struct davinci_id {
 #define	DAVINCI_CPU_ID_DM365		0x03650000
 #define	DAVINCI_CPU_ID_DA830		0x08300000
 #define	DAVINCI_CPU_ID_DA850		0x08500000
-#define	DAVINCI_CPU_ID_TNETV107X	0x0b8a0000
 
 #define IS_DAVINCI_CPU(type, id)					\
 static inline int is_davinci_ ##type(void)				\
@@ -47,7 +46,6 @@ IS_DAVINCI_CPU(dm355, DAVINCI_CPU_ID_DM355)
 IS_DAVINCI_CPU(dm365, DAVINCI_CPU_ID_DM365)
 IS_DAVINCI_CPU(da830, DAVINCI_CPU_ID_DA830)
 IS_DAVINCI_CPU(da850, DAVINCI_CPU_ID_DA850)
-IS_DAVINCI_CPU(tnetv107x, DAVINCI_CPU_ID_TNETV107X)
 
 #ifdef CONFIG_ARCH_DAVINCI_DM644x
 #define cpu_is_davinci_dm644x() is_davinci_dm644x()
@@ -85,10 +83,4 @@ IS_DAVINCI_CPU(tnetv107x, DAVINCI_CPU_ID_TNETV107X)
 #define cpu_is_davinci_da850() 0
 #endif
 
-#ifdef CONFIG_ARCH_DAVINCI_TNETV107X
-#define cpu_is_davinci_tnetv107x() is_davinci_tnetv107x()
-#else
-#define cpu_is_davinci_tnetv107x() 0
-#endif
-
 #endif
diff --git a/arch/arm/mach-davinci/include/mach/irqs.h b/arch/arm/mach-davinci/include/mach/irqs.h
index ec76c77..354af71 100644
--- a/arch/arm/mach-davinci/include/mach/irqs.h
+++ b/arch/arm/mach-davinci/include/mach/irqs.h
@@ -401,103 +401,6 @@
 
 #define DA850_N_CP_INTC_IRQ		101
 
-
-/* TNETV107X specific interrupts */
-#define IRQ_TNETV107X_TDM1_TXDMA		0
-#define IRQ_TNETV107X_EXT_INT_0			1
-#define IRQ_TNETV107X_EXT_INT_1			2
-#define IRQ_TNETV107X_GPIO_INT12		3
-#define IRQ_TNETV107X_GPIO_INT13		4
-#define IRQ_TNETV107X_TIMER_0_TINT12		5
-#define IRQ_TNETV107X_TIMER_1_TINT12		6
-#define IRQ_TNETV107X_UART0			7
-#define IRQ_TNETV107X_TDM1_RXDMA		8
-#define IRQ_TNETV107X_MCDMA_INT0		9
-#define IRQ_TNETV107X_MCDMA_INT1		10
-#define IRQ_TNETV107X_TPCC			11
-#define IRQ_TNETV107X_TPCC_INT0			12
-#define IRQ_TNETV107X_TPCC_INT1			13
-#define IRQ_TNETV107X_TPCC_INT2			14
-#define IRQ_TNETV107X_TPCC_INT3			15
-#define IRQ_TNETV107X_TPTC0			16
-#define IRQ_TNETV107X_TPTC1			17
-#define IRQ_TNETV107X_TIMER_0_TINT34		18
-#define IRQ_TNETV107X_ETHSS			19
-#define IRQ_TNETV107X_TIMER_1_TINT34		20
-#define IRQ_TNETV107X_DSP2ARM_INT0		21
-#define IRQ_TNETV107X_DSP2ARM_INT1		22
-#define IRQ_TNETV107X_ARM_NPMUIRQ		23
-#define IRQ_TNETV107X_USB1			24
-#define IRQ_TNETV107X_VLYNQ			25
-#define IRQ_TNETV107X_UART0_DMATX		26
-#define IRQ_TNETV107X_UART0_DMARX		27
-#define IRQ_TNETV107X_TDM1_TXMCSP		28
-#define IRQ_TNETV107X_SSP			29
-#define IRQ_TNETV107X_MCDMA_INT2		30
-#define IRQ_TNETV107X_MCDMA_INT3		31
-#define IRQ_TNETV107X_TDM_CODECIF_EOT		32
-#define IRQ_TNETV107X_IMCOP_SQR_ARM		33
-#define IRQ_TNETV107X_USB0			34
-#define IRQ_TNETV107X_USB_CDMA			35
-#define IRQ_TNETV107X_LCD			36
-#define IRQ_TNETV107X_KEYPAD			37
-#define IRQ_TNETV107X_KEYPAD_FREE		38
-#define IRQ_TNETV107X_RNG			39
-#define IRQ_TNETV107X_PKA			40
-#define IRQ_TNETV107X_TDM0_TXDMA		41
-#define IRQ_TNETV107X_TDM0_RXDMA		42
-#define IRQ_TNETV107X_TDM0_TXMCSP		43
-#define IRQ_TNETV107X_TDM0_RXMCSP		44
-#define IRQ_TNETV107X_TDM1_RXMCSP		45
-#define IRQ_TNETV107X_SDIO1			46
-#define IRQ_TNETV107X_SDIO0			47
-#define IRQ_TNETV107X_TSC			48
-#define IRQ_TNETV107X_TS			49
-#define IRQ_TNETV107X_UART1			50
-#define IRQ_TNETV107X_MBX_LITE			51
-#define IRQ_TNETV107X_GPIO_INT00		52
-#define IRQ_TNETV107X_GPIO_INT01		53
-#define IRQ_TNETV107X_GPIO_INT02		54
-#define IRQ_TNETV107X_GPIO_INT03		55
-#define IRQ_TNETV107X_UART2			56
-#define IRQ_TNETV107X_UART2_DMATX		57
-#define IRQ_TNETV107X_UART2_DMARX		58
-#define IRQ_TNETV107X_IMCOP_IMX			59
-#define IRQ_TNETV107X_IMCOP_VLCD		60
-#define IRQ_TNETV107X_AES			61
-#define IRQ_TNETV107X_DES			62
-#define IRQ_TNETV107X_SHAMD5			63
-#define IRQ_TNETV107X_TPCC_ERR			68
-#define IRQ_TNETV107X_TPCC_PROT			69
-#define IRQ_TNETV107X_TPTC0_ERR			70
-#define IRQ_TNETV107X_TPTC1_ERR			71
-#define IRQ_TNETV107X_UART0_ERR			72
-#define IRQ_TNETV107X_UART1_ERR			73
-#define IRQ_TNETV107X_AEMIF_ERR			74
-#define IRQ_TNETV107X_DDR_ERR			75
-#define IRQ_TNETV107X_WDTARM_INT0		76
-#define IRQ_TNETV107X_MCDMA_ERR			77
-#define IRQ_TNETV107X_GPIO_ERR			78
-#define IRQ_TNETV107X_MPU_ADDR			79
-#define IRQ_TNETV107X_MPU_PROT			80
-#define IRQ_TNETV107X_IOPU_ADDR			81
-#define IRQ_TNETV107X_IOPU_PROT			82
-#define IRQ_TNETV107X_KEYPAD_ADDR_ERR		83
-#define IRQ_TNETV107X_WDT0_ADDR_ERR		84
-#define IRQ_TNETV107X_WDT1_ADDR_ERR		85
-#define IRQ_TNETV107X_CLKCTL_ADDR_ERR		86
-#define IRQ_TNETV107X_PLL_UNLOCK		87
-#define IRQ_TNETV107X_WDTDSP_INT0		88
-#define IRQ_TNETV107X_SEC_CTRL_VIOLATION	89
-#define IRQ_TNETV107X_KEY_MNG_VIOLATION		90
-#define IRQ_TNETV107X_PBIST_CPU			91
-#define IRQ_TNETV107X_WDTARM			92
-#define IRQ_TNETV107X_PSC			93
-#define IRQ_TNETV107X_MMC0			94
-#define IRQ_TNETV107X_MMC1			95
-
-#define TNETV107X_N_CP_INTC_IRQ			96
-
 /* da850 currently has the most gpio pins (144) */
 #define DAVINCI_N_GPIO			144
 /* da850 currently has the most irqs so use DA850_N_CP_INTC_IRQ */
diff --git a/arch/arm/mach-davinci/include/mach/mux.h b/arch/arm/mach-davinci/include/mach/mux.h
index 9e95b8a..631655e 100644
--- a/arch/arm/mach-davinci/include/mach/mux.h
+++ b/arch/arm/mach-davinci/include/mach/mux.h
@@ -972,275 +972,6 @@ enum davinci_da850_index {
 	DA850_VPIF_CLKO3,
 };
 
-enum davinci_tnetv107x_index {
-	TNETV107X_ASR_A00,
-	TNETV107X_GPIO32,
-	TNETV107X_ASR_A01,
-	TNETV107X_GPIO33,
-	TNETV107X_ASR_A02,
-	TNETV107X_GPIO34,
-	TNETV107X_ASR_A03,
-	TNETV107X_GPIO35,
-	TNETV107X_ASR_A04,
-	TNETV107X_GPIO36,
-	TNETV107X_ASR_A05,
-	TNETV107X_GPIO37,
-	TNETV107X_ASR_A06,
-	TNETV107X_GPIO38,
-	TNETV107X_ASR_A07,
-	TNETV107X_GPIO39,
-	TNETV107X_ASR_A08,
-	TNETV107X_GPIO40,
-	TNETV107X_ASR_A09,
-	TNETV107X_GPIO41,
-	TNETV107X_ASR_A10,
-	TNETV107X_GPIO42,
-	TNETV107X_ASR_A11,
-	TNETV107X_BOOT_STRP_0,
-	TNETV107X_ASR_A12,
-	TNETV107X_BOOT_STRP_1,
-	TNETV107X_ASR_A13,
-	TNETV107X_GPIO43,
-	TNETV107X_ASR_A14,
-	TNETV107X_GPIO44,
-	TNETV107X_ASR_A15,
-	TNETV107X_GPIO45,
-	TNETV107X_ASR_A16,
-	TNETV107X_GPIO46,
-	TNETV107X_ASR_A17,
-	TNETV107X_GPIO47,
-	TNETV107X_ASR_A18,
-	TNETV107X_GPIO48,
-	TNETV107X_SDIO1_DATA3_0,
-	TNETV107X_ASR_A19,
-	TNETV107X_GPIO49,
-	TNETV107X_SDIO1_DATA2_0,
-	TNETV107X_ASR_A20,
-	TNETV107X_GPIO50,
-	TNETV107X_SDIO1_DATA1_0,
-	TNETV107X_ASR_A21,
-	TNETV107X_GPIO51,
-	TNETV107X_SDIO1_DATA0_0,
-	TNETV107X_ASR_A22,
-	TNETV107X_GPIO52,
-	TNETV107X_SDIO1_CMD_0,
-	TNETV107X_ASR_A23,
-	TNETV107X_GPIO53,
-	TNETV107X_SDIO1_CLK_0,
-	TNETV107X_ASR_BA_1,
-	TNETV107X_GPIO54,
-	TNETV107X_SYS_PLL_CLK,
-	TNETV107X_ASR_CS0,
-	TNETV107X_ASR_CS1,
-	TNETV107X_ASR_CS2,
-	TNETV107X_TDM_PLL_CLK,
-	TNETV107X_ASR_CS3,
-	TNETV107X_ETH_PHY_CLK,
-	TNETV107X_ASR_D00,
-	TNETV107X_GPIO55,
-	TNETV107X_ASR_D01,
-	TNETV107X_GPIO56,
-	TNETV107X_ASR_D02,
-	TNETV107X_GPIO57,
-	TNETV107X_ASR_D03,
-	TNETV107X_GPIO58,
-	TNETV107X_ASR_D04,
-	TNETV107X_GPIO59_0,
-	TNETV107X_ASR_D05,
-	TNETV107X_GPIO60_0,
-	TNETV107X_ASR_D06,
-	TNETV107X_GPIO61_0,
-	TNETV107X_ASR_D07,
-	TNETV107X_GPIO62_0,
-	TNETV107X_ASR_D08,
-	TNETV107X_GPIO63_0,
-	TNETV107X_ASR_D09,
-	TNETV107X_GPIO64_0,
-	TNETV107X_ASR_D10,
-	TNETV107X_SDIO1_DATA3_1,
-	TNETV107X_ASR_D11,
-	TNETV107X_SDIO1_DATA2_1,
-	TNETV107X_ASR_D12,
-	TNETV107X_SDIO1_DATA1_1,
-	TNETV107X_ASR_D13,
-	TNETV107X_SDIO1_DATA0_1,
-	TNETV107X_ASR_D14,
-	TNETV107X_SDIO1_CMD_1,
-	TNETV107X_ASR_D15,
-	TNETV107X_SDIO1_CLK_1,
-	TNETV107X_ASR_OE,
-	TNETV107X_BOOT_STRP_2,
-	TNETV107X_ASR_RNW,
-	TNETV107X_GPIO29_0,
-	TNETV107X_ASR_WAIT,
-	TNETV107X_GPIO30_0,
-	TNETV107X_ASR_WE,
-	TNETV107X_BOOT_STRP_3,
-	TNETV107X_ASR_WE_DQM0,
-	TNETV107X_GPIO31,
-	TNETV107X_LCD_PD17_0,
-	TNETV107X_ASR_WE_DQM1,
-	TNETV107X_ASR_BA0_0,
-	TNETV107X_VLYNQ_CLK,
-	TNETV107X_GPIO14,
-	TNETV107X_LCD_PD19_0,
-	TNETV107X_VLYNQ_RXD0,
-	TNETV107X_GPIO15,
-	TNETV107X_LCD_PD20_0,
-	TNETV107X_VLYNQ_RXD1,
-	TNETV107X_GPIO16,
-	TNETV107X_LCD_PD21_0,
-	TNETV107X_VLYNQ_TXD0,
-	TNETV107X_GPIO17,
-	TNETV107X_LCD_PD22_0,
-	TNETV107X_VLYNQ_TXD1,
-	TNETV107X_GPIO18,
-	TNETV107X_LCD_PD23_0,
-	TNETV107X_SDIO0_CLK,
-	TNETV107X_GPIO19,
-	TNETV107X_SDIO0_CMD,
-	TNETV107X_GPIO20,
-	TNETV107X_SDIO0_DATA0,
-	TNETV107X_GPIO21,
-	TNETV107X_SDIO0_DATA1,
-	TNETV107X_GPIO22,
-	TNETV107X_SDIO0_DATA2,
-	TNETV107X_GPIO23,
-	TNETV107X_SDIO0_DATA3,
-	TNETV107X_GPIO24,
-	TNETV107X_EMU0,
-	TNETV107X_EMU1,
-	TNETV107X_RTCK,
-	TNETV107X_TRST_N,
-	TNETV107X_TCK,
-	TNETV107X_TDI,
-	TNETV107X_TDO,
-	TNETV107X_TMS,
-	TNETV107X_TDM1_CLK,
-	TNETV107X_TDM1_RX,
-	TNETV107X_TDM1_TX,
-	TNETV107X_TDM1_FS,
-	TNETV107X_KEYPAD_R0,
-	TNETV107X_KEYPAD_R1,
-	TNETV107X_KEYPAD_R2,
-	TNETV107X_KEYPAD_R3,
-	TNETV107X_KEYPAD_R4,
-	TNETV107X_KEYPAD_R5,
-	TNETV107X_KEYPAD_R6,
-	TNETV107X_GPIO12,
-	TNETV107X_KEYPAD_R7,
-	TNETV107X_GPIO10,
-	TNETV107X_KEYPAD_C0,
-	TNETV107X_KEYPAD_C1,
-	TNETV107X_KEYPAD_C2,
-	TNETV107X_KEYPAD_C3,
-	TNETV107X_KEYPAD_C4,
-	TNETV107X_KEYPAD_C5,
-	TNETV107X_KEYPAD_C6,
-	TNETV107X_GPIO13,
-	TNETV107X_TEST_CLK_IN,
-	TNETV107X_KEYPAD_C7,
-	TNETV107X_GPIO11,
-	TNETV107X_SSP0_0,
-	TNETV107X_SCC_DCLK,
-	TNETV107X_LCD_PD20_1,
-	TNETV107X_SSP0_1,
-	TNETV107X_SCC_CS_N,
-	TNETV107X_LCD_PD21_1,
-	TNETV107X_SSP0_2,
-	TNETV107X_SCC_D,
-	TNETV107X_LCD_PD22_1,
-	TNETV107X_SSP0_3,
-	TNETV107X_SCC_RESETN,
-	TNETV107X_LCD_PD23_1,
-	TNETV107X_SSP1_0,
-	TNETV107X_GPIO25,
-	TNETV107X_UART2_CTS,
-	TNETV107X_SSP1_1,
-	TNETV107X_GPIO26,
-	TNETV107X_UART2_RD,
-	TNETV107X_SSP1_2,
-	TNETV107X_GPIO27,
-	TNETV107X_UART2_RTS,
-	TNETV107X_SSP1_3,
-	TNETV107X_GPIO28,
-	TNETV107X_UART2_TD,
-	TNETV107X_UART0_CTS,
-	TNETV107X_UART0_RD,
-	TNETV107X_UART0_RTS,
-	TNETV107X_UART0_TD,
-	TNETV107X_UART1_RD,
-	TNETV107X_UART1_TD,
-	TNETV107X_LCD_AC_NCS,
-	TNETV107X_LCD_HSYNC_RNW,
-	TNETV107X_LCD_VSYNC_A0,
-	TNETV107X_LCD_MCLK,
-	TNETV107X_LCD_PD16_0,
-	TNETV107X_LCD_PCLK_E,
-	TNETV107X_LCD_PD00,
-	TNETV107X_LCD_PD01,
-	TNETV107X_LCD_PD02,
-	TNETV107X_LCD_PD03,
-	TNETV107X_LCD_PD04,
-	TNETV107X_LCD_PD05,
-	TNETV107X_LCD_PD06,
-	TNETV107X_LCD_PD07,
-	TNETV107X_LCD_PD08,
-	TNETV107X_GPIO59_1,
-	TNETV107X_LCD_PD09,
-	TNETV107X_GPIO60_1,
-	TNETV107X_LCD_PD10,
-	TNETV107X_ASR_BA0_1,
-	TNETV107X_GPIO61_1,
-	TNETV107X_LCD_PD11,
-	TNETV107X_GPIO62_1,
-	TNETV107X_LCD_PD12,
-	TNETV107X_GPIO63_1,
-	TNETV107X_LCD_PD13,
-	TNETV107X_GPIO64_1,
-	TNETV107X_LCD_PD14,
-	TNETV107X_GPIO29_1,
-	TNETV107X_LCD_PD15,
-	TNETV107X_GPIO30_1,
-	TNETV107X_EINT0,
-	TNETV107X_GPIO08,
-	TNETV107X_EINT1,
-	TNETV107X_GPIO09,
-	TNETV107X_GPIO00,
-	TNETV107X_LCD_PD20_2,
-	TNETV107X_TDM_CLK_IN_2,
-	TNETV107X_GPIO01,
-	TNETV107X_LCD_PD21_2,
-	TNETV107X_24M_CLK_OUT_1,
-	TNETV107X_GPIO02,
-	TNETV107X_LCD_PD22_2,
-	TNETV107X_GPIO03,
-	TNETV107X_LCD_PD23_2,
-	TNETV107X_GPIO04,
-	TNETV107X_LCD_PD16_1,
-	TNETV107X_USB0_RXERR,
-	TNETV107X_GPIO05,
-	TNETV107X_LCD_PD17_1,
-	TNETV107X_TDM_CLK_IN_1,
-	TNETV107X_GPIO06,
-	TNETV107X_LCD_PD18,
-	TNETV107X_24M_CLK_OUT_2,
-	TNETV107X_GPIO07,
-	TNETV107X_LCD_PD19_1,
-	TNETV107X_USB1_RXERR,
-	TNETV107X_ETH_PLL_CLK,
-	TNETV107X_MDIO,
-	TNETV107X_MDC,
-	TNETV107X_AIC_MUTE_STAT_N,
-	TNETV107X_TDM0_CLK,
-	TNETV107X_AIC_HNS_EN_N,
-	TNETV107X_TDM0_FS,
-	TNETV107X_AIC_HDS_EN_STAT_N,
-	TNETV107X_TDM0_TX,
-	TNETV107X_AIC_HNF_EN_STAT_N,
-	TNETV107X_TDM0_RX,
-};
-
 #define PINMUX(x)		(4 * (x))
 
 #ifdef CONFIG_DAVINCI_MUX
diff --git a/arch/arm/mach-davinci/include/mach/psc.h b/arch/arm/mach-davinci/include/mach/psc.h
index 0a22710..99d47cf 100644
--- a/arch/arm/mach-davinci/include/mach/psc.h
+++ b/arch/arm/mach-davinci/include/mach/psc.h
@@ -182,53 +182,6 @@
 #define DA8XX_LPSC1_CR_P3_SS		26
 #define DA8XX_LPSC1_L3_CBA_RAM		31
 
-/* TNETV107X LPSC Assignments */
-#define TNETV107X_LPSC_ARM			0
-#define TNETV107X_LPSC_GEM			1
-#define TNETV107X_LPSC_DDR2_PHY			2
-#define TNETV107X_LPSC_TPCC			3
-#define TNETV107X_LPSC_TPTC0			4
-#define TNETV107X_LPSC_TPTC1			5
-#define TNETV107X_LPSC_RAM			6
-#define TNETV107X_LPSC_MBX_LITE			7
-#define TNETV107X_LPSC_LCD			8
-#define TNETV107X_LPSC_ETHSS			9
-#define TNETV107X_LPSC_AEMIF			10
-#define TNETV107X_LPSC_CHIP_CFG			11
-#define TNETV107X_LPSC_TSC			12
-#define TNETV107X_LPSC_ROM			13
-#define TNETV107X_LPSC_UART2			14
-#define TNETV107X_LPSC_PKTSEC			15
-#define TNETV107X_LPSC_SECCTL			16
-#define TNETV107X_LPSC_KEYMGR			17
-#define TNETV107X_LPSC_KEYPAD			18
-#define TNETV107X_LPSC_GPIO			19
-#define TNETV107X_LPSC_MDIO			20
-#define TNETV107X_LPSC_SDIO0			21
-#define TNETV107X_LPSC_UART0			22
-#define TNETV107X_LPSC_UART1			23
-#define TNETV107X_LPSC_TIMER0			24
-#define TNETV107X_LPSC_TIMER1			25
-#define TNETV107X_LPSC_WDT_ARM			26
-#define TNETV107X_LPSC_WDT_DSP			27
-#define TNETV107X_LPSC_SSP			28
-#define TNETV107X_LPSC_TDM0			29
-#define TNETV107X_LPSC_VLYNQ			30
-#define TNETV107X_LPSC_MCDMA			31
-#define TNETV107X_LPSC_USB0			32
-#define TNETV107X_LPSC_TDM1			33
-#define TNETV107X_LPSC_DEBUGSS			34
-#define TNETV107X_LPSC_ETHSS_RGMII		35
-#define TNETV107X_LPSC_SYSTEM			36
-#define TNETV107X_LPSC_IMCOP			37
-#define TNETV107X_LPSC_SPARE			38
-#define TNETV107X_LPSC_SDIO1			39
-#define TNETV107X_LPSC_USB1			40
-#define TNETV107X_LPSC_USBSS			41
-#define TNETV107X_LPSC_DDR2_EMIF1_VRST		42
-#define TNETV107X_LPSC_DDR2_EMIF2_VCTL_RST	43
-#define TNETV107X_LPSC_MAX			44
-
 /* PSC register offsets */
 #define EPCPR		0x070
 #define PTCMD		0x120
diff --git a/arch/arm/mach-davinci/include/mach/serial.h b/arch/arm/mach-davinci/include/mach/serial.h
index ce402cd..d4b4aa87 100644
--- a/arch/arm/mach-davinci/include/mach/serial.h
+++ b/arch/arm/mach-davinci/include/mach/serial.h
@@ -23,14 +23,6 @@
 #define DA8XX_UART1_BASE	(IO_PHYS + 0x10c000)
 #define DA8XX_UART2_BASE	(IO_PHYS + 0x10d000)
 
-#define TNETV107X_UART0_BASE	0x08108100
-#define TNETV107X_UART1_BASE	0x08088400
-#define TNETV107X_UART2_BASE	0x08108300
-
-#define TNETV107X_UART0_VIRT	IOMEM(0xfee08100)
-#define TNETV107X_UART1_VIRT	IOMEM(0xfed88400)
-#define TNETV107X_UART2_VIRT	IOMEM(0xfee08300)
-
 /* DaVinci UART register offsets */
 #define UART_DAVINCI_PWREMU		0x0c
 #define UART_DM646X_SCR			0x10
diff --git a/arch/arm/mach-davinci/include/mach/tnetv107x.h b/arch/arm/mach-davinci/include/mach/tnetv107x.h
deleted file mode 100644
index 494fcf5..0000000
--- a/arch/arm/mach-davinci/include/mach/tnetv107x.h
+++ /dev/null
@@ -1,61 +0,0 @@
-/*
- * Texas Instruments TNETV107X SoC Specific Defines
- *
- * Copyright (C) 2010 Texas Instruments
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-#ifndef __ASM_ARCH_DAVINCI_TNETV107X_H
-#define __ASM_ARCH_DAVINCI_TNETV107X_H
-
-#include <asm/sizes.h>
-
-#define TNETV107X_DDR_BASE	0x80000000
-
-/*
- * Fixed mapping for early init starts here. If low-level debug is enabled,
- * this area also gets mapped via io_pg_offset and io_phys by the boot code.
- * To fit in with the io_pg_offset calculation, the io base address selected
- * here _must_ be a multiple of 2^20.
- */
-#define TNETV107X_IO_BASE	0x08000000
-#define TNETV107X_IO_VIRT	(IO_VIRT + SZ_1M)
-
-#define TNETV107X_N_GPIO	65
-
-#ifndef __ASSEMBLY__
-
-#include <linux/serial_8250.h>
-#include <linux/input/matrix_keypad.h>
-#include <linux/mfd/ti_ssp.h>
-#include <linux/reboot.h>
-
-#include <linux/platform_data/mmc-davinci.h>
-#include <linux/platform_data/mtd-davinci.h>
-#include <mach/serial.h>
-
-struct tnetv107x_device_info {
-	struct davinci_mmc_config	*mmc_config[2];  /* 2 controllers */
-	struct davinci_nand_pdata	*nand_config[4]; /* 4 chipsels */
-	struct matrix_keypad_platform_data *keypad_config;
-	struct ti_ssp_data		*ssp_config;
-};
-
-extern struct platform_device tnetv107x_wdt_device;
-extern struct platform_device tnetv107x_serial_device[];
-
-extern void tnetv107x_init(void);
-extern void tnetv107x_devices_init(struct tnetv107x_device_info *);
-extern void tnetv107x_irq_init(void);
-void tnetv107x_restart(enum reboot_mode mode, const char *cmd);
-
-#endif
-
-#endif /* __ASM_ARCH_DAVINCI_TNETV107X_H */
diff --git a/arch/arm/mach-davinci/include/mach/uncompress.h b/arch/arm/mach-davinci/include/mach/uncompress.h
index f49c2916..8fb97b9 100644
--- a/arch/arm/mach-davinci/include/mach/uncompress.h
+++ b/arch/arm/mach-davinci/include/mach/uncompress.h
@@ -68,9 +68,6 @@ static inline void set_uart_info(u32 phys)
 #define DEBUG_LL_DA8XX(machine, port)				\
 	_DEBUG_LL_ENTRY(machine, DA8XX_UART##port##_BASE)
 
-#define DEBUG_LL_TNETV107X(machine, port)			\
-	_DEBUG_LL_ENTRY(machine, TNETV107X_UART##port##_BASE)
-
 static inline void __arch_decomp_setup(unsigned long arch_id)
 {
 	/*
@@ -94,9 +91,6 @@ static inline void __arch_decomp_setup(unsigned long arch_id)
 		DEBUG_LL_DA8XX(davinci_da850_evm,	2);
 		DEBUG_LL_DA8XX(mityomapl138,		1);
 		DEBUG_LL_DA8XX(omapl138_hawkboard,	2);
-
-		/* TNETV107x boards */
-		DEBUG_LL_TNETV107X(tnetv107x,		1);
 	} while (0);
 }
 
diff --git a/arch/arm/mach-davinci/tnetv107x.c b/arch/arm/mach-davinci/tnetv107x.c
deleted file mode 100644
index f4d7fbb..0000000
--- a/arch/arm/mach-davinci/tnetv107x.c
+++ /dev/null
@@ -1,766 +0,0 @@
-/*
- * Texas Instruments TNETV107X SoC Support
- *
- * Copyright (C) 2010 Texas Instruments
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation version 2.
- *
- * This program is distributed "as is" WITHOUT ANY WARRANTY of any
- * kind, whether express or implied; without even the implied warranty
- * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- */
-#include <linux/gpio.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/clk.h>
-#include <linux/io.h>
-#include <linux/err.h>
-#include <linux/platform_device.h>
-#include <linux/reboot.h>
-
-#include <asm/mach/map.h>
-
-#include <mach/common.h>
-#include <mach/time.h>
-#include <mach/cputype.h>
-#include <mach/psc.h>
-#include <mach/cp_intc.h>
-#include <mach/irqs.h>
-#include <mach/hardware.h>
-#include <mach/tnetv107x.h>
-#include <mach/gpio-davinci.h>
-
-#include "clock.h"
-#include "mux.h"
-
-/* Base addresses for on-chip devices */
-#define TNETV107X_INTC_BASE			0x03000000
-#define TNETV107X_TIMER0_BASE			0x08086500
-#define TNETV107X_TIMER1_BASE			0x08086600
-#define TNETV107X_CHIP_CFG_BASE			0x08087000
-#define TNETV107X_GPIO_BASE			0x08088000
-#define TNETV107X_CLOCK_CONTROL_BASE		0x0808a000
-#define TNETV107X_PSC_BASE			0x0808b000
-
-/* Reference clock frequencies */
-#define OSC_FREQ_ONCHIP		(24000 * 1000)
-#define OSC_FREQ_OFFCHIP_SYS	(25000 * 1000)
-#define OSC_FREQ_OFFCHIP_ETH	(25000 * 1000)
-#define OSC_FREQ_OFFCHIP_TDM	(19200 * 1000)
-
-#define N_PLLS	3
-
-/* Clock Control Registers */
-struct clk_ctrl_regs {
-	u32	pll_bypass;
-	u32	_reserved0;
-	u32	gem_lrst;
-	u32	_reserved1;
-	u32	pll_unlock_stat;
-	u32	sys_unlock;
-	u32	eth_unlock;
-	u32	tdm_unlock;
-};
-
-/* SSPLL Registers */
-struct sspll_regs {
-	u32	modes;
-	u32	post_div;
-	u32	pre_div;
-	u32	mult_factor;
-	u32	divider_range;
-	u32	bw_divider;
-	u32	spr_amount;
-	u32	spr_rate_div;
-	u32	diag;
-};
-
-/* Watchdog Timer Registers */
-struct wdt_regs {
-	u32	kick_lock;
-	u32	kick;
-	u32	change_lock;
-	u32	change ;
-	u32	disable_lock;
-	u32	disable;
-	u32	prescale_lock;
-	u32	prescale;
-};
-
-static struct clk_ctrl_regs __iomem *clk_ctrl_regs;
-
-static struct sspll_regs __iomem *sspll_regs[N_PLLS];
-static int sspll_regs_base[N_PLLS] = { 0x40, 0x80, 0xc0 };
-
-/* PLL bypass bit shifts in clk_ctrl_regs->pll_bypass register */
-static u32 bypass_mask[N_PLLS] = { BIT(0), BIT(2), BIT(1) };
-
-/* offchip (external) reference clock frequencies */
-static u32 pll_ext_freq[] = {
-	OSC_FREQ_OFFCHIP_SYS,
-	OSC_FREQ_OFFCHIP_TDM,
-	OSC_FREQ_OFFCHIP_ETH
-};
-
-/* PSC control registers */
-static u32 psc_regs[] = { TNETV107X_PSC_BASE };
-
-/* Host map for interrupt controller */
-static u32 intc_host_map[] = { 0x01010000, 0x01010101, -1 };
-
-static unsigned long clk_sspll_recalc(struct clk *clk);
-
-/* Level 1 - the PLLs */
-#define define_pll_clk(cname, pll, divmask, base)	\
-	static struct pll_data pll_##cname##_data = {	\
-		.num		= pll,			\
-		.div_ratio_mask	= divmask,		\
-		.phys_base	= base +		\
-			TNETV107X_CLOCK_CONTROL_BASE,	\
-	};						\
-	static struct clk pll_##cname##_clk = {		\
-		.name		= "pll_" #cname "_clk",	\
-		.pll_data	= &pll_##cname##_data,	\
-		.flags		= CLK_PLL,		\
-		.recalc		= clk_sspll_recalc,	\
-	}
-
-define_pll_clk(sys, 0, 0x1ff, 0x600);
-define_pll_clk(tdm, 1, 0x0ff, 0x200);
-define_pll_clk(eth, 2, 0x0ff, 0x400);
-
-/* Level 2 - divided outputs from the PLLs */
-#define define_pll_div_clk(pll, cname, div)			\
-	static struct clk pll##_##cname##_clk = {		\
-		.name		= #pll "_" #cname "_clk",	\
-		.parent		= &pll_##pll##_clk,		\
-		.flags		= CLK_PLL,			\
-		.div_reg	= PLLDIV##div,			\
-		.set_rate	= davinci_set_sysclk_rate,	\
-	}
-
-define_pll_div_clk(sys, arm1176,	1);
-define_pll_div_clk(sys, dsp,		2);
-define_pll_div_clk(sys, ddr,		3);
-define_pll_div_clk(sys, full,		4);
-define_pll_div_clk(sys, lcd,		5);
-define_pll_div_clk(sys, vlynq_ref,	6);
-define_pll_div_clk(sys, tsc,		7);
-define_pll_div_clk(sys, half,		8);
-
-define_pll_div_clk(eth, 5mhz,		1);
-define_pll_div_clk(eth, 50mhz,		2);
-define_pll_div_clk(eth, 125mhz,		3);
-define_pll_div_clk(eth, 250mhz,		4);
-define_pll_div_clk(eth, 25mhz,		5);
-
-define_pll_div_clk(tdm, 0,		1);
-define_pll_div_clk(tdm, extra,		2);
-define_pll_div_clk(tdm, 1,		3);
-
-
-/* Level 3 - LPSC gated clocks */
-#define __lpsc_clk(cname, _parent, mod, flg)		\
-	static struct clk clk_##cname = {		\
-		.name		= #cname,		\
-		.parent		= &_parent,		\
-		.lpsc		= TNETV107X_LPSC_##mod,\
-		.flags		= flg,			\
-	}
-
-#define lpsc_clk_enabled(cname, parent, mod)		\
-	__lpsc_clk(cname, parent, mod, ALWAYS_ENABLED)
-
-#define lpsc_clk(cname, parent, mod)			\
-	__lpsc_clk(cname, parent, mod, 0)
-
-lpsc_clk_enabled(arm,		sys_arm1176_clk, ARM);
-lpsc_clk_enabled(gem,		sys_dsp_clk,	GEM);
-lpsc_clk_enabled(ddr2_phy,	sys_ddr_clk,	DDR2_PHY);
-lpsc_clk_enabled(tpcc,		sys_full_clk,	TPCC);
-lpsc_clk_enabled(tptc0,		sys_full_clk,	TPTC0);
-lpsc_clk_enabled(tptc1,		sys_full_clk,	TPTC1);
-lpsc_clk_enabled(ram,		sys_full_clk,	RAM);
-lpsc_clk_enabled(aemif,		sys_full_clk,	AEMIF);
-lpsc_clk_enabled(chipcfg,	sys_half_clk,	CHIP_CFG);
-lpsc_clk_enabled(rom,		sys_half_clk,	ROM);
-lpsc_clk_enabled(secctl,	sys_half_clk,	SECCTL);
-lpsc_clk_enabled(keymgr,	sys_half_clk,	KEYMGR);
-lpsc_clk_enabled(gpio,		sys_half_clk,	GPIO);
-lpsc_clk_enabled(debugss,	sys_half_clk,	DEBUGSS);
-lpsc_clk_enabled(system,	sys_half_clk,	SYSTEM);
-lpsc_clk_enabled(ddr2_vrst,	sys_ddr_clk,	DDR2_EMIF1_VRST);
-lpsc_clk_enabled(ddr2_vctl_rst,	sys_ddr_clk,	DDR2_EMIF2_VCTL_RST);
-lpsc_clk_enabled(wdt_arm,	sys_half_clk,	WDT_ARM);
-lpsc_clk_enabled(timer1,	sys_half_clk,	TIMER1);
-
-lpsc_clk(mbx_lite,	sys_arm1176_clk,	MBX_LITE);
-lpsc_clk(ethss,		eth_125mhz_clk,		ETHSS);
-lpsc_clk(tsc,		sys_tsc_clk,		TSC);
-lpsc_clk(uart0,		sys_half_clk,		UART0);
-lpsc_clk(uart1,		sys_half_clk,		UART1);
-lpsc_clk(uart2,		sys_half_clk,		UART2);
-lpsc_clk(pktsec,	sys_half_clk,		PKTSEC);
-lpsc_clk(keypad,	sys_half_clk,		KEYPAD);
-lpsc_clk(mdio,		sys_half_clk,		MDIO);
-lpsc_clk(sdio0,		sys_half_clk,		SDIO0);
-lpsc_clk(sdio1,		sys_half_clk,		SDIO1);
-lpsc_clk(timer0,	sys_half_clk,		TIMER0);
-lpsc_clk(wdt_dsp,	sys_half_clk,		WDT_DSP);
-lpsc_clk(ssp,		sys_half_clk,		SSP);
-lpsc_clk(tdm0,		tdm_0_clk,		TDM0);
-lpsc_clk(tdm1,		tdm_1_clk,		TDM1);
-lpsc_clk(vlynq,		sys_vlynq_ref_clk,	VLYNQ);
-lpsc_clk(mcdma,		sys_half_clk,		MCDMA);
-lpsc_clk(usbss,		sys_half_clk,		USBSS);
-lpsc_clk(usb0,		clk_usbss,		USB0);
-lpsc_clk(usb1,		clk_usbss,		USB1);
-lpsc_clk(ethss_rgmii,	eth_250mhz_clk,		ETHSS_RGMII);
-lpsc_clk(imcop,		sys_dsp_clk,		IMCOP);
-lpsc_clk(spare,		sys_half_clk,		SPARE);
-
-/* LCD needs a full power down to clear controller state */
-__lpsc_clk(lcd, sys_lcd_clk, LCD, PSC_SWRSTDISABLE);
-
-
-/* Level 4 - leaf clocks for LPSC modules shared across drivers */
-static struct clk clk_rng = { .name = "rng", .parent = &clk_pktsec };
-static struct clk clk_pka = { .name = "pka", .parent = &clk_pktsec };
-
-static struct clk_lookup clks[] = {
-	CLK(NULL,		"pll_sys_clk",		&pll_sys_clk),
-	CLK(NULL,		"pll_eth_clk",		&pll_eth_clk),
-	CLK(NULL,		"pll_tdm_clk",		&pll_tdm_clk),
-	CLK(NULL,		"sys_arm1176_clk",	&sys_arm1176_clk),
-	CLK(NULL,		"sys_dsp_clk",		&sys_dsp_clk),
-	CLK(NULL,		"sys_ddr_clk",		&sys_ddr_clk),
-	CLK(NULL,		"sys_full_clk",		&sys_full_clk),
-	CLK(NULL,		"sys_lcd_clk",		&sys_lcd_clk),
-	CLK(NULL,		"sys_vlynq_ref_clk",	&sys_vlynq_ref_clk),
-	CLK(NULL,		"sys_tsc_clk",		&sys_tsc_clk),
-	CLK(NULL,		"sys_half_clk",		&sys_half_clk),
-	CLK(NULL,		"eth_5mhz_clk",		&eth_5mhz_clk),
-	CLK(NULL,		"eth_50mhz_clk",	&eth_50mhz_clk),
-	CLK(NULL,		"eth_125mhz_clk",	&eth_125mhz_clk),
-	CLK(NULL,		"eth_250mhz_clk",	&eth_250mhz_clk),
-	CLK(NULL,		"eth_25mhz_clk",	&eth_25mhz_clk),
-	CLK(NULL,		"tdm_0_clk",		&tdm_0_clk),
-	CLK(NULL,		"tdm_extra_clk",	&tdm_extra_clk),
-	CLK(NULL,		"tdm_1_clk",		&tdm_1_clk),
-	CLK(NULL,		"clk_arm",		&clk_arm),
-	CLK(NULL,		"clk_gem",		&clk_gem),
-	CLK(NULL,		"clk_ddr2_phy",		&clk_ddr2_phy),
-	CLK(NULL,		"clk_tpcc",		&clk_tpcc),
-	CLK(NULL,		"clk_tptc0",		&clk_tptc0),
-	CLK(NULL,		"clk_tptc1",		&clk_tptc1),
-	CLK(NULL,		"clk_ram",		&clk_ram),
-	CLK(NULL,		"clk_mbx_lite",		&clk_mbx_lite),
-	CLK("tnetv107x-fb.0",	NULL,			&clk_lcd),
-	CLK(NULL,		"clk_ethss",		&clk_ethss),
-	CLK(NULL,		"aemif",		&clk_aemif),
-	CLK(NULL,		"clk_chipcfg",		&clk_chipcfg),
-	CLK("tnetv107x-ts.0",	NULL,			&clk_tsc),
-	CLK(NULL,		"clk_rom",		&clk_rom),
-	CLK("serial8250.2",     NULL,			&clk_uart2),
-	CLK(NULL,		"clk_pktsec",		&clk_pktsec),
-	CLK("tnetv107x-rng.0",	NULL,			&clk_rng),
-	CLK("tnetv107x-pka.0",	NULL,			&clk_pka),
-	CLK(NULL,		"clk_secctl",		&clk_secctl),
-	CLK(NULL,		"clk_keymgr",		&clk_keymgr),
-	CLK("tnetv107x-keypad.0", NULL,			&clk_keypad),
-	CLK(NULL,		"clk_gpio",		&clk_gpio),
-	CLK(NULL,		"clk_mdio",		&clk_mdio),
-	CLK("dm6441-mmc.0",	NULL,			&clk_sdio0),
-	CLK("serial8250.0",	NULL,			&clk_uart0),
-	CLK("serial8250.1",	NULL,			&clk_uart1),
-	CLK(NULL,		"timer0",		&clk_timer0),
-	CLK(NULL,		"timer1",		&clk_timer1),
-	CLK("tnetv107x_wdt.0",	NULL,			&clk_wdt_arm),
-	CLK(NULL,		"clk_wdt_dsp",		&clk_wdt_dsp),
-	CLK("ti-ssp",		NULL,			&clk_ssp),
-	CLK(NULL,		"clk_tdm0",		&clk_tdm0),
-	CLK(NULL,		"clk_vlynq",		&clk_vlynq),
-	CLK(NULL,		"clk_mcdma",		&clk_mcdma),
-	CLK(NULL,		"clk_usbss",		&clk_usbss),
-	CLK(NULL,		"clk_usb0",		&clk_usb0),
-	CLK(NULL,		"clk_usb1",		&clk_usb1),
-	CLK(NULL,		"clk_tdm1",		&clk_tdm1),
-	CLK(NULL,		"clk_debugss",		&clk_debugss),
-	CLK(NULL,		"clk_ethss_rgmii",	&clk_ethss_rgmii),
-	CLK(NULL,		"clk_system",		&clk_system),
-	CLK(NULL,		"clk_imcop",		&clk_imcop),
-	CLK(NULL,		"clk_spare",		&clk_spare),
-	CLK("dm6441-mmc.1",	NULL,			&clk_sdio1),
-	CLK(NULL,		"clk_ddr2_vrst",	&clk_ddr2_vrst),
-	CLK(NULL,		"clk_ddr2_vctl_rst",	&clk_ddr2_vctl_rst),
-	CLK(NULL,		NULL,			NULL),
-};
-
-static const struct mux_config pins[] = {
-#ifdef CONFIG_DAVINCI_MUX
-	MUX_CFG(TNETV107X, ASR_A00,		0, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO32,		0, 0, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A01,		0, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO33,		0, 5, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A02,		0, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO34,		0, 10, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A03,		0, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO35,		0, 15, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A04,		0, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO36,		0, 20, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A05,		0, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO37,		0, 25, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A06,		1, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO38,		1, 0, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A07,		1, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO39,		1, 5, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A08,		1, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO40,		1, 10, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A09,		1, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO41,		1, 15, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A10,		1, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO42,		1, 20, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A11,		1, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, BOOT_STRP_0,		1, 25, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A12,		2, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, BOOT_STRP_1,		2, 0, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A13,		2, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO43,		2, 5, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A14,		2, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO44,		2, 10, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A15,		2, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO45,		2, 15, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A16,		2, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO46,		2, 20, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A17,		2, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO47,		2, 25, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_A18,		3, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO48,		3, 0, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, SDIO1_DATA3_0,	3, 0, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_A19,		3, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO49,		3, 5, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, SDIO1_DATA2_0,	3, 5, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_A20,		3, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO50,		3, 10, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, SDIO1_DATA1_0,	3, 10, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_A21,		3, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO51,		3, 15, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, SDIO1_DATA0_0,	3, 15, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_A22,		3, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO52,		3, 20, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, SDIO1_CMD_0,		3, 20, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_A23,		3, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO53,		3, 25, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, SDIO1_CLK_0,		3, 25, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_BA_1,		4, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO54,		4, 0, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, SYS_PLL_CLK,		4, 0, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_CS0,		4, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, ASR_CS1,		4, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, ASR_CS2,		4, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, TDM_PLL_CLK,		4, 15, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_CS3,		4, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, ETH_PHY_CLK,		4, 20, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, ASR_D00,		4, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO55,		4, 25, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_D01,		5, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO56,		5, 0, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_D02,		5, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO57,		5, 5, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_D03,		5, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO58,		5, 10, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_D04,		5, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO59_0,		5, 15, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_D05,		5, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO60_0,		5, 20, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_D06,		5, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO61_0,		5, 25, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_D07,		6, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO62_0,		6, 0, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_D08,		6, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO63_0,		6, 5, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_D09,		6, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO64_0,		6, 10, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_D10,		6, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, SDIO1_DATA3_1,	6, 15, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_D11,		6, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, SDIO1_DATA2_1,	6, 20, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_D12,		6, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, SDIO1_DATA1_1,	6, 25, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_D13,		7, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, SDIO1_DATA0_1,	7, 0, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_D14,		7, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, SDIO1_CMD_1,		7, 5, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_D15,		7, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, SDIO1_CLK_1,		7, 10, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_OE,		7, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, BOOT_STRP_2,		7, 15, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_RNW,		7, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO29_0,		7, 20, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_WAIT,		7, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO30_0,		7, 25, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_WE,		8, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, BOOT_STRP_3,		8, 0, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, ASR_WE_DQM0,		8, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO31,		8, 5, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, LCD_PD17_0,		8, 5, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, ASR_WE_DQM1,		8, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, ASR_BA0_0,		8, 10, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, VLYNQ_CLK,		9, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO14,		9, 0, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, LCD_PD19_0,		9, 0, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, VLYNQ_RXD0,		9, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO15,		9, 5, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, LCD_PD20_0,		9, 5, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, VLYNQ_RXD1,		9, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO16,		9, 10, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, LCD_PD21_0,		9, 10, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, VLYNQ_TXD0,		9, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO17,		9, 15, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, LCD_PD22_0,		9, 15, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, VLYNQ_TXD1,		9, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO18,		9, 20, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, LCD_PD23_0,		9, 20, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, SDIO0_CLK,		10, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO19,		10, 0, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, SDIO0_CMD,		10, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO20,		10, 5, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, SDIO0_DATA0,		10, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO21,		10, 10, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, SDIO0_DATA1,		10, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO22,		10, 15, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, SDIO0_DATA2,		10, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO23,		10, 20, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, SDIO0_DATA3,		10, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO24,		10, 25, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, EMU0,		11, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, EMU1,		11, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, RTCK,		12, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, TRST_N,		12, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, TCK,			12, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, TDI,			12, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, TDO,			12, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, TMS,			12, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, TDM1_CLK,		13, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, TDM1_RX,		13, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, TDM1_TX,		13, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, TDM1_FS,		13, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, KEYPAD_R0,		14, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, KEYPAD_R1,		14, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, KEYPAD_R2,		14, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, KEYPAD_R3,		14, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, KEYPAD_R4,		14, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, KEYPAD_R5,		14, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, KEYPAD_R6,		15, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO12,		15, 0, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, KEYPAD_R7,		15, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO10,		15, 5, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, KEYPAD_C0,		15, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, KEYPAD_C1,		15, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, KEYPAD_C2,		15, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, KEYPAD_C3,		15, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, KEYPAD_C4,		16, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, KEYPAD_C5,		16, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, KEYPAD_C6,		16, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO13,		16, 10, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, TEST_CLK_IN,		16, 10, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, KEYPAD_C7,		16, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO11,		16, 15, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, SSP0_0,		17, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, SCC_DCLK,		17, 0, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, LCD_PD20_1,		17, 0, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, SSP0_1,		17, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, SCC_CS_N,		17, 5, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, LCD_PD21_1,		17, 5, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, SSP0_2,		17, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, SCC_D,		17, 10, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, LCD_PD22_1,		17, 10, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, SSP0_3,		17, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, SCC_RESETN,		17, 15, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, LCD_PD23_1,		17, 15, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, SSP1_0,		18, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO25,		18, 0, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, UART2_CTS,		18, 0, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, SSP1_1,		18, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO26,		18, 5, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, UART2_RD,		18, 5, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, SSP1_2,		18, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO27,		18, 10, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, UART2_RTS,		18, 10, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, SSP1_3,		18, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO28,		18, 15, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, UART2_TD,		18, 15, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, UART0_CTS,		19, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, UART0_RD,		19, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, UART0_RTS,		19, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, UART0_TD,		19, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, UART1_RD,		19, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, UART1_TD,		19, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_AC_NCS,		20, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_HSYNC_RNW,	20, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_VSYNC_A0,	20, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_MCLK,		20, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD16_0,		20, 15, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, LCD_PCLK_E,		20, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD00,		20, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD01,		21, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD02,		21, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD03,		21, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD04,		21, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD05,		21, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD06,		21, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD07,		22, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD08,		22, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO59_1,		22, 5, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, LCD_PD09,		22, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO60_1,		22, 10, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, LCD_PD10,		22, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, ASR_BA0_1,		22, 15, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, GPIO61_1,		22, 15, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, LCD_PD11,		22, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO62_1,		22, 20, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, LCD_PD12,		22, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO63_1,		22, 25, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, LCD_PD13,		23, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO64_1,		23, 0, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, LCD_PD14,		23, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO29_1,		23, 5, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, LCD_PD15,		23, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO30_1,		23, 10, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, EINT0,		24, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO08,		24, 0, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, EINT1,		24, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, GPIO09,		24, 5, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, GPIO00,		24, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD20_2,		24, 10, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, TDM_CLK_IN_2,	24, 10, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, GPIO01,		24, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD21_2,		24, 15, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, 24M_CLK_OUT_1,	24, 15, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, GPIO02,		24, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD22_2,		24, 20, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, GPIO03,		24, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD23_2,		24, 25, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, GPIO04,		25, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD16_1,		25, 0, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, USB0_RXERR,		25, 0, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, GPIO05,		25, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD17_1,		25, 5, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, TDM_CLK_IN_1,	25, 5, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, GPIO06,		25, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD18,		25, 10, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, 24M_CLK_OUT_2,	25, 10, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, GPIO07,		25, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, LCD_PD19_1,		25, 15, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, USB1_RXERR,		25, 15, 0x1f, 0x0c, false)
-	MUX_CFG(TNETV107X, ETH_PLL_CLK,		25, 15, 0x1f, 0x1c, false)
-	MUX_CFG(TNETV107X, MDIO,		26, 0, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, MDC,			26, 5, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, AIC_MUTE_STAT_N,	26, 10, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, TDM0_CLK,		26, 10, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, AIC_HNS_EN_N,	26, 15, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, TDM0_FS,		26, 15, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, AIC_HDS_EN_STAT_N,	26, 20, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, TDM0_TX,		26, 20, 0x1f, 0x04, false)
-	MUX_CFG(TNETV107X, AIC_HNF_EN_STAT_N,	26, 25, 0x1f, 0x00, false)
-	MUX_CFG(TNETV107X, TDM0_RX,		26, 25, 0x1f, 0x04, false)
-#endif
-};
-
-/* FIQ are pri 0-1; otherwise 2-7, with 7 lowest priority */
-static u8 irq_prios[TNETV107X_N_CP_INTC_IRQ] = {
-	/* fill in default priority 7 */
-	[0 ... (TNETV107X_N_CP_INTC_IRQ - 1)]	= 7,
-	/* now override as needed, e.g. [xxx] = 5 */
-};
-
-/* Contents of JTAG ID register used to identify exact cpu type */
-static struct davinci_id ids[] = {
-	{
-		.variant	= 0x0,
-		.part_no	= 0xb8a1,
-		.manufacturer	= 0x017,
-		.cpu_id		= DAVINCI_CPU_ID_TNETV107X,
-		.name		= "tnetv107x rev 1.0",
-	},
-	{
-		.variant	= 0x1,
-		.part_no	= 0xb8a1,
-		.manufacturer	= 0x017,
-		.cpu_id		= DAVINCI_CPU_ID_TNETV107X,
-		.name		= "tnetv107x rev 1.1/1.2",
-	},
-};
-
-static struct davinci_timer_instance timer_instance[2] = {
-	{
-		.base		= TNETV107X_TIMER0_BASE,
-		.bottom_irq	= IRQ_TNETV107X_TIMER_0_TINT12,
-		.top_irq	= IRQ_TNETV107X_TIMER_0_TINT34,
-	},
-	{
-		.base		= TNETV107X_TIMER1_BASE,
-		.bottom_irq	= IRQ_TNETV107X_TIMER_1_TINT12,
-		.top_irq	= IRQ_TNETV107X_TIMER_1_TINT34,
-	},
-};
-
-static struct davinci_timer_info timer_info = {
-	.timers		= timer_instance,
-	.clockevent_id	= T0_BOT,
-	.clocksource_id	= T0_TOP,
-};
-
-/*
- * TNETV107X platforms do not use the static mappings from Davinci
- * IO_PHYS/IO_VIRT. This SOC's interesting MMRs are at different addresses,
- * and changing IO_PHYS would break away from existing Davinci SOCs.
- *
- * The primary impact of the current model is that IO_ADDRESS() is not to be
- * used to map registers on TNETV107X.
- *
- * 1.	The first chunk is for INTC:  This needs to be mapped in via iotable
- *	because ioremap() does not seem to be operational at the time when
- *	irqs are initialized.  Without this, consistent dma init bombs.
- *
- * 2.	The second chunk maps in register areas that need to be populated into
- *	davinci_soc_info.  Note that alignment restrictions come into play if
- *	low-level debug is enabled (see note in <mach/tnetv107x.h>).
- */
-static struct map_desc io_desc[] = {
-	{	/* INTC */
-		.virtual	= IO_VIRT,
-		.pfn		= __phys_to_pfn(TNETV107X_INTC_BASE),
-		.length		= SZ_16K,
-		.type		= MT_DEVICE
-	},
-	{	/* Most of the rest */
-		.virtual	= TNETV107X_IO_VIRT,
-		.pfn		= __phys_to_pfn(TNETV107X_IO_BASE),
-		.length		= IO_SIZE - SZ_1M,
-		.type		= MT_DEVICE
-	},
-};
-
-static unsigned long clk_sspll_recalc(struct clk *clk)
-{
-	int		pll;
-	unsigned long	mult = 0, prediv = 1, postdiv = 1;
-	unsigned long	ref = OSC_FREQ_ONCHIP, ret;
-	u32		tmp;
-
-	if (WARN_ON(!clk->pll_data))
-		return clk->rate;
-
-	if (!clk_ctrl_regs) {
-		void __iomem *tmp;
-
-		tmp = ioremap(TNETV107X_CLOCK_CONTROL_BASE, SZ_4K);
-
-		if (WARN(!tmp, "failed ioremap for clock control regs\n"))
-			return clk->parent ? clk->parent->rate : 0;
-
-		for (pll = 0; pll < N_PLLS; pll++)
-			sspll_regs[pll] = tmp + sspll_regs_base[pll];
-
-		clk_ctrl_regs = tmp;
-	}
-
-	pll = clk->pll_data->num;
-
-	tmp = __raw_readl(&clk_ctrl_regs->pll_bypass);
-	if (!(tmp & bypass_mask[pll])) {
-		mult	= __raw_readl(&sspll_regs[pll]->mult_factor);
-		prediv	= __raw_readl(&sspll_regs[pll]->pre_div) + 1;
-		postdiv	= __raw_readl(&sspll_regs[pll]->post_div) + 1;
-	}
-
-	tmp = __raw_readl(clk->pll_data->base + PLLCTL);
-	if (tmp & PLLCTL_CLKMODE)
-		ref = pll_ext_freq[pll];
-
-	clk->pll_data->input_rate = ref;
-
-	tmp = __raw_readl(clk->pll_data->base + PLLCTL);
-	if (!(tmp & PLLCTL_PLLEN))
-		return ref;
-
-	ret = ref;
-	if (mult)
-		ret += ((unsigned long long)ref * mult) / 256;
-
-	ret /= (prediv * postdiv);
-
-	return ret;
-}
-
-static void tnetv107x_watchdog_reset(struct platform_device *pdev)
-{
-	struct wdt_regs __iomem *regs;
-
-	regs = ioremap(pdev->resource[0].start, SZ_4K);
-
-	/* disable watchdog */
-	__raw_writel(0x7777, &regs->disable_lock);
-	__raw_writel(0xcccc, &regs->disable_lock);
-	__raw_writel(0xdddd, &regs->disable_lock);
-	__raw_writel(0, &regs->disable);
-
-	/* program prescale */
-	__raw_writel(0x5a5a, &regs->prescale_lock);
-	__raw_writel(0xa5a5, &regs->prescale_lock);
-	__raw_writel(0, &regs->prescale);
-
-	/* program countdown */
-	__raw_writel(0x6666, &regs->change_lock);
-	__raw_writel(0xbbbb, &regs->change_lock);
-	__raw_writel(1, &regs->change);
-
-	/* enable watchdog */
-	__raw_writel(0x7777, &regs->disable_lock);
-	__raw_writel(0xcccc, &regs->disable_lock);
-	__raw_writel(0xdddd, &regs->disable_lock);
-	__raw_writel(1, &regs->disable);
-
-	/* kick */
-	__raw_writel(0x5555, &regs->kick_lock);
-	__raw_writel(0xaaaa, &regs->kick_lock);
-	__raw_writel(1, &regs->kick);
-}
-
-void tnetv107x_restart(enum reboot_mode mode, const char *cmd)
-{
-	tnetv107x_watchdog_reset(&tnetv107x_wdt_device);
-}
-
-static struct davinci_soc_info tnetv107x_soc_info = {
-	.io_desc		= io_desc,
-	.io_desc_num		= ARRAY_SIZE(io_desc),
-	.ids			= ids,
-	.ids_num		= ARRAY_SIZE(ids),
-	.jtag_id_reg		= TNETV107X_CHIP_CFG_BASE + 0x018,
-	.cpu_clks		= clks,
-	.psc_bases		= psc_regs,
-	.psc_bases_num		= ARRAY_SIZE(psc_regs),
-	.pinmux_base		= TNETV107X_CHIP_CFG_BASE + 0x150,
-	.pinmux_pins		= pins,
-	.pinmux_pins_num	= ARRAY_SIZE(pins),
-	.intc_type		= DAVINCI_INTC_TYPE_CP_INTC,
-	.intc_base		= TNETV107X_INTC_BASE,
-	.intc_irq_prios		= irq_prios,
-	.intc_irq_num		= TNETV107X_N_CP_INTC_IRQ,
-	.intc_host_map		= intc_host_map,
-	.gpio_base		= TNETV107X_GPIO_BASE,
-	.gpio_type		= GPIO_TYPE_TNETV107X,
-	.gpio_num		= TNETV107X_N_GPIO,
-	.timer_info		= &timer_info,
-	.serial_dev		= tnetv107x_serial_device,
-};
-
-void __init tnetv107x_init(void)
-{
-	davinci_common_init(&tnetv107x_soc_info);
-}
-- 
1.8.3.2

