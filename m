Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaJAQrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:47:17 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:45572 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaJAQrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:47:14 -0400
Message-ID: <542C300B.9070703@atmel.com>
Date: Wed, 1 Oct 2014 18:47:07 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: at91: remove at91sam9rl legacy board support
References: <1412181710-21193-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1412181710-21193-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 18:41, Alexandre Belloni :
> Remove legacy support for at91sam9rl boards.
> This include board files removal plus all legacy code for non DT boards
> support.

I add a little sentence, just to avoid confusion:
"Use the Device Tree for running this board with newer kernels."

> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Now I queue it on top of at91-3.18-soc3

Thanks, best regards,


> ---
>  arch/arm/configs/at91sam9rl_defconfig   |   83 --
>  arch/arm/mach-at91/Kconfig.non_dt       |   18 -
>  arch/arm/mach-at91/Makefile             |    4 -
>  arch/arm/mach-at91/at91sam9rl.c         |  336 +--------
>  arch/arm/mach-at91/at91sam9rl_devices.c | 1260 -------------------------------
>  arch/arm/mach-at91/board-sam9rlek.c     |  332 --------
>  6 files changed, 2 insertions(+), 2031 deletions(-)
>  delete mode 100644 arch/arm/configs/at91sam9rl_defconfig
>  delete mode 100644 arch/arm/mach-at91/at91sam9rl_devices.c
>  delete mode 100644 arch/arm/mach-at91/board-sam9rlek.c
> 
> diff --git a/arch/arm/configs/at91sam9rl_defconfig b/arch/arm/configs/at91sam9rl_defconfig
> deleted file mode 100644
> index 5d7797d43d23..000000000000
> --- a/arch/arm/configs/at91sam9rl_defconfig
> +++ /dev/null
> @@ -1,83 +0,0 @@
> -# CONFIG_LOCALVERSION_AUTO is not set
> -# CONFIG_SWAP is not set
> -CONFIG_SYSVIPC=y
> -CONFIG_LOG_BUF_SHIFT=14
> -CONFIG_EMBEDDED=y
> -CONFIG_BLK_DEV_INITRD=y
> -CONFIG_SLAB=y
> -CONFIG_MODULES=y
> -CONFIG_MODULE_UNLOAD=y
> -# CONFIG_BLK_DEV_BSG is not set
> -# CONFIG_IOSCHED_DEADLINE is not set
> -# CONFIG_IOSCHED_CFQ is not set
> -CONFIG_ARCH_AT91=y
> -CONFIG_ARCH_AT91SAM9RL=y
> -CONFIG_MACH_AT91SAM9RLEK=y
> -# CONFIG_ARM_THUMB is not set
> -CONFIG_AEABI=y
> -CONFIG_ZBOOT_ROM_TEXT=0x0
> -CONFIG_ZBOOT_ROM_BSS=0x0
> -CONFIG_CMDLINE="mem=64M console=ttyS0,115200 initrd=0x21100000,17105363 root=/dev/ram0 rw"
> -CONFIG_AUTO_ZRELADDR=y
> -CONFIG_NET=y
> -CONFIG_UNIX=y
> -CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> -CONFIG_DEVTMPFS=y
> -CONFIG_DEVTMPFS_MOUNT=y
> -CONFIG_MTD=y
> -CONFIG_MTD_CMDLINE_PARTS=y
> -CONFIG_MTD_BLOCK=y
> -CONFIG_MTD_DATAFLASH=y
> -CONFIG_MTD_NAND=y
> -CONFIG_MTD_NAND_ATMEL=y
> -CONFIG_MTD_UBI=y
> -CONFIG_BLK_DEV_LOOP=y
> -CONFIG_BLK_DEV_RAM=y
> -CONFIG_BLK_DEV_RAM_COUNT=4
> -CONFIG_BLK_DEV_RAM_SIZE=24576
> -CONFIG_SCSI=y
> -CONFIG_BLK_DEV_SD=y
> -CONFIG_SCSI_MULTI_LUN=y
> -# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
> -CONFIG_INPUT_MOUSEDEV_SCREEN_X=320
> -CONFIG_INPUT_MOUSEDEV_SCREEN_Y=240
> -CONFIG_INPUT_EVDEV=y
> -# CONFIG_INPUT_KEYBOARD is not set
> -# CONFIG_INPUT_MOUSE is not set
> -CONFIG_INPUT_TOUCHSCREEN=y
> -# CONFIG_SERIO is not set
> -CONFIG_SERIAL_ATMEL=y
> -CONFIG_SERIAL_ATMEL_CONSOLE=y
> -# CONFIG_HW_RANDOM is not set
> -CONFIG_I2C=y
> -CONFIG_I2C_CHARDEV=y
> -CONFIG_I2C_GPIO=y
> -CONFIG_SPI=y
> -CONFIG_SPI_ATMEL=y
> -# CONFIG_HWMON is not set
> -CONFIG_WATCHDOG=y
> -CONFIG_WATCHDOG_NOWAYOUT=y
> -CONFIG_AT91SAM9X_WATCHDOG=y
> -CONFIG_FB=y
> -CONFIG_FB_ATMEL=y
> -CONFIG_MMC=y
> -CONFIG_MMC_ATMELMCI=m
> -CONFIG_RTC_CLASS=y
> -CONFIG_RTC_DRV_AT91SAM9=y
> -CONFIG_IIO=y
> -CONFIG_AT91_ADC=y
> -CONFIG_EXT2_FS=y
> -CONFIG_MSDOS_FS=y
> -CONFIG_VFAT_FS=y
> -CONFIG_TMPFS=y
> -CONFIG_UBIFS_FS=y
> -CONFIG_CRAMFS=y
> -CONFIG_NLS_CODEPAGE_437=y
> -CONFIG_NLS_CODEPAGE_850=y
> -CONFIG_NLS_ISO8859_1=y
> -CONFIG_NLS_ISO8859_15=y
> -CONFIG_NLS_UTF8=y
> -CONFIG_DEBUG_KERNEL=y
> -CONFIG_DEBUG_INFO=y
> -CONFIG_DEBUG_USER=y
> -CONFIG_DEBUG_LL=y
> diff --git a/arch/arm/mach-at91/Kconfig.non_dt b/arch/arm/mach-at91/Kconfig.non_dt
> index e860f7a716c7..a97b1b328853 100644
> --- a/arch/arm/mach-at91/Kconfig.non_dt
> +++ b/arch/arm/mach-at91/Kconfig.non_dt
> @@ -30,11 +30,6 @@ config ARCH_AT91SAM9263
>  	select SOC_AT91SAM9263
>  	select AT91_USE_OLD_CLK
>  
> -config ARCH_AT91SAM9RL
> -	bool "AT91SAM9RL"
> -	select SOC_AT91SAM9RL
> -	select AT91_USE_OLD_CLK
> -
>  endchoice
>  
>  config ARCH_AT91SAM9G20
> @@ -277,19 +272,6 @@ endif
>  
>  # ----------------------------------------------------------
>  
> -if ARCH_AT91SAM9RL
> -
> -comment "AT91SAM9RL Board Type"
> -
> -config MACH_AT91SAM9RLEK
> -	bool "Atmel AT91SAM9RL-EK Evaluation Kit"
> -	help
> -	  Select this if you are using Atmel's AT91SAM9RL-EK Evaluation Kit.
> -
> -endif
> -
> -# ----------------------------------------------------------
> -
>  if ARCH_AT91X40
>  
>  comment "AT91X40 Board Type"
> diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
> index fe91af789ce5..fb4825019ad3 100644
> --- a/arch/arm/mach-at91/Makefile
> +++ b/arch/arm/mach-at91/Makefile
> @@ -29,7 +29,6 @@ obj-$(CONFIG_ARCH_AT91RM9200)	+= at91rm9200_devices.o
>  obj-$(CONFIG_ARCH_AT91SAM9260)	+= at91sam9260_devices.o
>  obj-$(CONFIG_ARCH_AT91SAM9261)	+= at91sam9261_devices.o
>  obj-$(CONFIG_ARCH_AT91SAM9263)	+= at91sam9263_devices.o
> -obj-$(CONFIG_ARCH_AT91SAM9RL)	+= at91sam9rl_devices.o
>  obj-$(CONFIG_ARCH_AT91X40)	+= at91x40.o at91x40_time.o
>  
>  # AT91RM9200 board-specific support
> @@ -62,9 +61,6 @@ obj-$(CONFIG_MACH_AT91SAM9G10EK) += board-sam9261ek.o
>  # AT91SAM9263 board-specific support
>  obj-$(CONFIG_MACH_AT91SAM9263EK) += board-sam9263ek.o
>  
> -# AT91SAM9RL board-specific support
> -obj-$(CONFIG_MACH_AT91SAM9RLEK)	+= board-sam9rlek.o
> -
>  # AT91SAM9G20 board-specific support
>  obj-$(CONFIG_MACH_AT91SAM9G20EK) += board-sam9g20ek.o
>  obj-$(CONFIG_MACH_CPU9G20)	+= board-cpu9krea.o
> diff --git a/arch/arm/mach-at91/at91sam9rl.c b/arch/arm/mach-at91/at91sam9rl.c
> index 878d5015daab..9a0818c044c5 100644
> --- a/arch/arm/mach-at91/at91sam9rl.c
> +++ b/arch/arm/mach-at91/at91sam9rl.c
> @@ -9,284 +9,14 @@
>   * more details.
>   */
>  
> -#include <linux/module.h>
> -#include <linux/clk/at91_pmc.h>
> -
> -#include <asm/proc-fns.h>
> -#include <asm/irq.h>
> -#include <asm/mach/arch.h>
> -#include <asm/mach/map.h>
>  #include <asm/system_misc.h>
> -#include <mach/cpu.h>
> +
>  #include <mach/at91_dbgu.h>
> -#include <mach/at91sam9rl.h>
> +#include <mach/cpu.h>
>  #include <mach/hardware.h>
>  
> -#include "at91_aic.h"
> -#include "at91_rstc.h"
>  #include "soc.h"
>  #include "generic.h"
> -#include "sam9_smc.h"
> -#include "pm.h"
> -
> -/* --------------------------------------------------------------------
> - *  Clocks
> - * -------------------------------------------------------------------- */
> -#if defined(CONFIG_OLD_CLK_AT91)
> -#include "clock.h"
> -
> -/*
> - * The peripheral clocks.
> - */
> -static struct clk pioA_clk = {
> -	.name		= "pioA_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_PIOA,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk pioB_clk = {
> -	.name		= "pioB_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_PIOB,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk pioC_clk = {
> -	.name		= "pioC_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_PIOC,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk pioD_clk = {
> -	.name		= "pioD_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_PIOD,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk usart0_clk = {
> -	.name		= "usart0_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_US0,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk usart1_clk = {
> -	.name		= "usart1_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_US1,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk usart2_clk = {
> -	.name		= "usart2_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_US2,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk usart3_clk = {
> -	.name		= "usart3_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_US3,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk mmc_clk = {
> -	.name		= "mci_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_MCI,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk twi0_clk = {
> -	.name		= "twi0_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_TWI0,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk twi1_clk = {
> -	.name		= "twi1_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_TWI1,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk spi_clk = {
> -	.name		= "spi_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_SPI,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk ssc0_clk = {
> -	.name		= "ssc0_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_SSC0,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk ssc1_clk = {
> -	.name		= "ssc1_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_SSC1,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk tc0_clk = {
> -	.name		= "tc0_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_TC0,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk tc1_clk = {
> -	.name		= "tc1_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_TC1,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk tc2_clk = {
> -	.name		= "tc2_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_TC2,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk pwm_clk = {
> -	.name		= "pwm_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_PWMC,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk tsc_clk = {
> -	.name		= "tsc_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_TSC,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk dma_clk = {
> -	.name		= "dma_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_DMA,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk udphs_clk = {
> -	.name		= "udphs_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_UDPHS,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk lcdc_clk = {
> -	.name		= "lcdc_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_LCDC,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk ac97_clk = {
> -	.name		= "ac97_clk",
> -	.pmc_mask	= 1 << AT91SAM9RL_ID_AC97C,
> -	.type		= CLK_TYPE_PERIPHERAL,
> -};
> -static struct clk adc_op_clk = {
> -	.name		= "adc_op_clk",
> -	.type		= CLK_TYPE_PERIPHERAL,
> -	.rate_hz	= 1000000,
> -};
> -
> -static struct clk *periph_clocks[] __initdata = {
> -	&pioA_clk,
> -	&pioB_clk,
> -	&pioC_clk,
> -	&pioD_clk,
> -	&usart0_clk,
> -	&usart1_clk,
> -	&usart2_clk,
> -	&usart3_clk,
> -	&mmc_clk,
> -	&twi0_clk,
> -	&twi1_clk,
> -	&spi_clk,
> -	&ssc0_clk,
> -	&ssc1_clk,
> -	&tc0_clk,
> -	&tc1_clk,
> -	&tc2_clk,
> -	&pwm_clk,
> -	&tsc_clk,
> -	&dma_clk,
> -	&udphs_clk,
> -	&lcdc_clk,
> -	&ac97_clk,
> -	&adc_op_clk,
> -	// irq0
> -};
> -
> -static struct clk_lookup periph_clocks_lookups[] = {
> -	CLKDEV_CON_DEV_ID("hclk", "at91sam9rl-lcdfb.0", &lcdc_clk),
> -	CLKDEV_CON_DEV_ID("hclk", "atmel_usba_udc", &utmi_clk),
> -	CLKDEV_CON_DEV_ID("pclk", "atmel_usba_udc", &udphs_clk),
> -	CLKDEV_CON_DEV_ID("t0_clk", "atmel_tcb.0", &tc0_clk),
> -	CLKDEV_CON_DEV_ID("t1_clk", "atmel_tcb.0", &tc1_clk),
> -	CLKDEV_CON_DEV_ID("t2_clk", "atmel_tcb.0", &tc2_clk),
> -	CLKDEV_CON_DEV_ID("pclk", "at91rm9200_ssc.0", &ssc0_clk),
> -	CLKDEV_CON_DEV_ID("pclk", "at91rm9200_ssc.1", &ssc1_clk),
> -	CLKDEV_CON_DEV_ID("pclk", "fffc0000.ssc", &ssc0_clk),
> -	CLKDEV_CON_DEV_ID("pclk", "fffc4000.ssc", &ssc1_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9g20.0", &twi0_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "i2c-at91sam9g20.1", &twi1_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "at91sam9rl-pwm", &pwm_clk),
> -	CLKDEV_CON_ID("pioA", &pioA_clk),
> -	CLKDEV_CON_ID("pioB", &pioB_clk),
> -	CLKDEV_CON_ID("pioC", &pioC_clk),
> -	CLKDEV_CON_ID("pioD", &pioD_clk),
> -	/* more lookup table for DT entries */
> -	CLKDEV_CON_DEV_ID("usart", "fffff200.serial", &mck),
> -	CLKDEV_CON_DEV_ID("usart", "fffb0000.serial", &usart0_clk),
> -	CLKDEV_CON_DEV_ID("usart", "ffffb400.serial", &usart1_clk),
> -	CLKDEV_CON_DEV_ID("usart", "ffffb800.serial", &usart2_clk),
> -	CLKDEV_CON_DEV_ID("usart", "ffffbc00.serial", &usart3_clk),
> -	CLKDEV_CON_DEV_ID("t0_clk", "fffa0000.timer", &tc0_clk),
> -	CLKDEV_CON_DEV_ID("t1_clk", "fffa0000.timer", &tc1_clk),
> -	CLKDEV_CON_DEV_ID("t2_clk", "fffa0000.timer", &tc2_clk),
> -	CLKDEV_CON_DEV_ID("mci_clk", "fffa4000.mmc", &mmc_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "fffa8000.i2c", &twi0_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "fffac000.i2c", &twi1_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "fffc8000.pwm", &pwm_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "ffffc800.pwm", &pwm_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "fffff400.gpio", &pioA_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "fffff600.gpio", &pioB_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "fffff800.gpio", &pioC_clk),
> -	CLKDEV_CON_DEV_ID(NULL, "fffffa00.gpio", &pioD_clk),
> -	CLKDEV_CON_ID("adc_clk", &tsc_clk),
> -};
> -
> -static struct clk_lookup usart_clocks_lookups[] = {
> -	CLKDEV_CON_DEV_ID("usart", "atmel_usart.0", &mck),
> -	CLKDEV_CON_DEV_ID("usart", "atmel_usart.1", &usart0_clk),
> -	CLKDEV_CON_DEV_ID("usart", "atmel_usart.2", &usart1_clk),
> -	CLKDEV_CON_DEV_ID("usart", "atmel_usart.3", &usart2_clk),
> -	CLKDEV_CON_DEV_ID("usart", "atmel_usart.4", &usart3_clk),
> -};
> -
> -/*
> - * The two programmable clocks.
> - * You must configure pin multiplexing to bring these signals out.
> - */
> -static struct clk pck0 = {
> -	.name		= "pck0",
> -	.pmc_mask	= AT91_PMC_PCK0,
> -	.type		= CLK_TYPE_PROGRAMMABLE,
> -	.id		= 0,
> -};
> -static struct clk pck1 = {
> -	.name		= "pck1",
> -	.pmc_mask	= AT91_PMC_PCK1,
> -	.type		= CLK_TYPE_PROGRAMMABLE,
> -	.id		= 1,
> -};
> -
> -static void __init at91sam9rl_register_clocks(void)
> -{
> -	int i;
> -
> -	for (i = 0; i < ARRAY_SIZE(periph_clocks); i++)
> -		clk_register(periph_clocks[i]);
> -
> -	clkdev_add_table(periph_clocks_lookups,
> -			 ARRAY_SIZE(periph_clocks_lookups));
> -	clkdev_add_table(usart_clocks_lookups,
> -			 ARRAY_SIZE(usart_clocks_lookups));
> -
> -	clk_register(&pck0);
> -	clk_register(&pck1);
> -}
> -#endif
> -
> -/* --------------------------------------------------------------------
> - *  GPIO
> - * -------------------------------------------------------------------- */
> -
> -static struct at91_gpio_bank at91sam9rl_gpio[] __initdata = {
> -	{
> -		.id		= AT91SAM9RL_ID_PIOA,
> -		.regbase	= AT91SAM9RL_BASE_PIOA,
> -	}, {
> -		.id		= AT91SAM9RL_ID_PIOB,
> -		.regbase	= AT91SAM9RL_BASE_PIOB,
> -	}, {
> -		.id		= AT91SAM9RL_ID_PIOC,
> -		.regbase	= AT91SAM9RL_BASE_PIOC,
> -	}, {
> -		.id		= AT91SAM9RL_ID_PIOD,
> -		.regbase	= AT91SAM9RL_BASE_PIOD,
> -	}
> -};
>  
>  /* --------------------------------------------------------------------
>   *  AT91SAM9RL processor initialization
> @@ -309,17 +39,6 @@ static void __init at91sam9rl_map_io(void)
>  	at91_init_sram(0, AT91SAM9RL_SRAM_BASE, sram_size);
>  }
>  
> -static void __init at91sam9rl_ioremap_registers(void)
> -{
> -	at91_ioremap_shdwc(AT91SAM9RL_BASE_SHDWC);
> -	at91_ioremap_rstc(AT91SAM9RL_BASE_RSTC);
> -	at91_ioremap_ramc(0, AT91SAM9RL_BASE_SDRAMC, 512);
> -	at91sam926x_ioremap_pit(AT91SAM9RL_BASE_PIT);
> -	at91sam9_ioremap_smc(0, AT91SAM9RL_BASE_SMC);
> -	at91_ioremap_matrix(AT91SAM9RL_BASE_MATRIX);
> -	at91_pm_set_standby(at91sam9_sdram_standby);
> -}
> -
>  static void __init at91sam9rl_initialize(void)
>  {
>  	arm_pm_idle = at91sam9_idle;
> @@ -327,60 +46,9 @@ static void __init at91sam9rl_initialize(void)
>  
>  	at91_sysirq_mask_rtc(AT91SAM9RL_BASE_RTC);
>  	at91_sysirq_mask_rtt(AT91SAM9RL_BASE_RTT);
> -
> -	/* Register GPIO subsystem */
> -	at91_gpio_init(at91sam9rl_gpio, 4);
>  }
>  
> -/* --------------------------------------------------------------------
> - *  Interrupt initialization
> - * -------------------------------------------------------------------- */
> -
> -/*
> - * The default interrupt priority levels (0 = lowest, 7 = highest).
> - */
> -static unsigned int at91sam9rl_default_irq_priority[NR_AIC_IRQS] __initdata = {
> -	7,	/* Advanced Interrupt Controller */
> -	7,	/* System Peripherals */
> -	1,	/* Parallel IO Controller A */
> -	1,	/* Parallel IO Controller B */
> -	1,	/* Parallel IO Controller C */
> -	1,	/* Parallel IO Controller D */
> -	5,	/* USART 0 */
> -	5,	/* USART 1 */
> -	5,	/* USART 2 */
> -	5,	/* USART 3 */
> -	0,	/* Multimedia Card Interface */
> -	6,	/* Two-Wire Interface 0 */
> -	6,	/* Two-Wire Interface 1 */
> -	5,	/* Serial Peripheral Interface */
> -	4,	/* Serial Synchronous Controller 0 */
> -	4,	/* Serial Synchronous Controller 1 */
> -	0,	/* Timer Counter 0 */
> -	0,	/* Timer Counter 1 */
> -	0,	/* Timer Counter 2 */
> -	0,
> -	0,	/* Touch Screen Controller */
> -	0,	/* DMA Controller */
> -	2,	/* USB Device High speed port */
> -	2,	/* LCD Controller */
> -	6,	/* AC97 Controller */
> -	0,
> -	0,
> -	0,
> -	0,
> -	0,
> -	0,
> -	0,	/* Advanced Interrupt Controller */
> -};
> -
>  AT91_SOC_START(at91sam9rl)
>  	.map_io = at91sam9rl_map_io,
> -	.default_irq_priority = at91sam9rl_default_irq_priority,
> -	.extern_irq = (1 << AT91SAM9RL_ID_IRQ0),
> -	.ioremap_registers = at91sam9rl_ioremap_registers,
> -#if defined(CONFIG_OLD_CLK_AT91)
> -	.register_clocks = at91sam9rl_register_clocks,
> -#endif
>  	.init = at91sam9rl_initialize,
>  AT91_SOC_END
> diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
> deleted file mode 100644
> index 37d1c9ed4562..000000000000
> --- a/arch/arm/mach-at91/at91sam9rl_devices.c
> +++ /dev/null
> @@ -1,1260 +0,0 @@
> -/*
> - *  Copyright (C) 2007 Atmel Corporation
> - *
> - * This file is subject to the terms and conditions of the GNU General Public
> - * License.  See the file COPYING in the main directory of this archive for
> - * more details.
> - */
> -
> -#include <asm/mach/arch.h>
> -#include <asm/mach/map.h>
> -
> -#include <linux/dma-mapping.h>
> -#include <linux/gpio.h>
> -#include <linux/platform_device.h>
> -#include <linux/i2c-gpio.h>
> -
> -#include <linux/fb.h>
> -#include <video/atmel_lcdc.h>
> -
> -#include <mach/at91sam9rl.h>
> -#include <mach/at91sam9rl_matrix.h>
> -#include <mach/at91_matrix.h>
> -#include <mach/at91sam9_smc.h>
> -#include <mach/hardware.h>
> -#include <linux/platform_data/dma-atmel.h>
> -#include <linux/platform_data/at91_adc.h>
> -
> -#include "board.h"
> -#include "generic.h"
> -#include "gpio.h"
> -
> -
> -/* --------------------------------------------------------------------
> - *  HDMAC - AHB DMA Controller
> - * -------------------------------------------------------------------- */
> -
> -#if defined(CONFIG_AT_HDMAC) || defined(CONFIG_AT_HDMAC_MODULE)
> -static u64 hdmac_dmamask = DMA_BIT_MASK(32);
> -
> -static struct resource hdmac_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9RL_BASE_DMA,
> -		.end	= AT91SAM9RL_BASE_DMA + SZ_512 - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[2] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_DMA,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_DMA,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static struct platform_device at_hdmac_device = {
> -	.name		= "at91sam9rl_dma",
> -	.id		= -1,
> -	.dev		= {
> -				.dma_mask		= &hdmac_dmamask,
> -				.coherent_dma_mask	= DMA_BIT_MASK(32),
> -	},
> -	.resource	= hdmac_resources,
> -	.num_resources	= ARRAY_SIZE(hdmac_resources),
> -};
> -
> -void __init at91_add_device_hdmac(void)
> -{
> -	platform_device_register(&at_hdmac_device);
> -}
> -#else
> -void __init at91_add_device_hdmac(void) {}
> -#endif
> -
> -/* --------------------------------------------------------------------
> - *  USB HS Device (Gadget)
> - * -------------------------------------------------------------------- */
> -
> -#if defined(CONFIG_USB_ATMEL_USBA) || defined(CONFIG_USB_ATMEL_USBA_MODULE)
> -
> -static struct resource usba_udc_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9RL_UDPHS_FIFO,
> -		.end	= AT91SAM9RL_UDPHS_FIFO + SZ_512K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= AT91SAM9RL_BASE_UDPHS,
> -		.end	= AT91SAM9RL_BASE_UDPHS + SZ_1K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[2] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_UDPHS,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_UDPHS,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -#define EP(nam, idx, maxpkt, maxbk, dma, isoc)			\
> -	[idx] = {						\
> -		.name		= nam,				\
> -		.index		= idx,				\
> -		.fifo_size	= maxpkt,			\
> -		.nr_banks	= maxbk,			\
> -		.can_dma	= dma,				\
> -		.can_isoc	= isoc,				\
> -	}
> -
> -static struct usba_ep_data usba_udc_ep[] __initdata = {
> -	EP("ep0", 0, 64, 1, 0, 0),
> -	EP("ep1", 1, 1024, 2, 1, 1),
> -	EP("ep2", 2, 1024, 2, 1, 1),
> -	EP("ep3", 3, 1024, 3, 1, 0),
> -	EP("ep4", 4, 1024, 3, 1, 0),
> -	EP("ep5", 5, 1024, 3, 1, 1),
> -	EP("ep6", 6, 1024, 3, 1, 1),
> -};
> -
> -#undef EP
> -
> -/*
> - * pdata doesn't have room for any endpoints, so we need to
> - * append room for the ones we need right after it.
> - */
> -static struct {
> -	struct usba_platform_data pdata;
> -	struct usba_ep_data ep[7];
> -} usba_udc_data;
> -
> -static struct platform_device at91_usba_udc_device = {
> -	.name		= "atmel_usba_udc",
> -	.id		= -1,
> -	.dev		= {
> -				.platform_data	= &usba_udc_data.pdata,
> -	},
> -	.resource	= usba_udc_resources,
> -	.num_resources	= ARRAY_SIZE(usba_udc_resources),
> -};
> -
> -void __init at91_add_device_usba(struct usba_platform_data *data)
> -{
> -	/*
> -	 * Invalid pins are 0 on AT91, but the usba driver is shared
> -	 * with AVR32, which use negative values instead. Once/if
> -	 * gpio_is_valid() is ported to AT91, revisit this code.
> -	 */
> -	usba_udc_data.pdata.vbus_pin = -EINVAL;
> -	usba_udc_data.pdata.num_ep = ARRAY_SIZE(usba_udc_ep);
> -	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));
> -
> -	if (data && gpio_is_valid(data->vbus_pin)) {
> -		at91_set_gpio_input(data->vbus_pin, 0);
> -		at91_set_deglitch(data->vbus_pin, 1);
> -		usba_udc_data.pdata.vbus_pin = data->vbus_pin;
> -	}
> -
> -	/* Pullup pin is handled internally by USB device peripheral */
> -
> -	platform_device_register(&at91_usba_udc_device);
> -}
> -#else
> -void __init at91_add_device_usba(struct usba_platform_data *data) {}
> -#endif
> -
> -
> -/* --------------------------------------------------------------------
> - *  MMC / SD
> - * -------------------------------------------------------------------- */
> -
> -#if IS_ENABLED(CONFIG_MMC_ATMELMCI)
> -static u64 mmc_dmamask = DMA_BIT_MASK(32);
> -static struct mci_platform_data mmc_data;
> -
> -static struct resource mmc_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9RL_BASE_MCI,
> -		.end	= AT91SAM9RL_BASE_MCI + SZ_16K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_MCI,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_MCI,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static struct platform_device at91sam9rl_mmc_device = {
> -	.name		= "atmel_mci",
> -	.id		= -1,
> -	.dev		= {
> -				.dma_mask		= &mmc_dmamask,
> -				.coherent_dma_mask	= DMA_BIT_MASK(32),
> -				.platform_data		= &mmc_data,
> -	},
> -	.resource	= mmc_resources,
> -	.num_resources	= ARRAY_SIZE(mmc_resources),
> -};
> -
> -void __init at91_add_device_mci(short mmc_id, struct mci_platform_data *data)
> -{
> -	if (!data)
> -		return;
> -
> -	if (data->slot[0].bus_width) {
> -		/* input/irq */
> -		if (gpio_is_valid(data->slot[0].detect_pin)) {
> -			at91_set_gpio_input(data->slot[0].detect_pin, 1);
> -			at91_set_deglitch(data->slot[0].detect_pin, 1);
> -		}
> -		if (gpio_is_valid(data->slot[0].wp_pin))
> -			at91_set_gpio_input(data->slot[0].wp_pin, 1);
> -
> -		/* CLK */
> -		at91_set_A_periph(AT91_PIN_PA2, 0);
> -
> -		/* CMD */
> -		at91_set_A_periph(AT91_PIN_PA1, 1);
> -
> -		/* DAT0, maybe DAT1..DAT3 */
> -		at91_set_A_periph(AT91_PIN_PA0, 1);
> -		if (data->slot[0].bus_width == 4) {
> -			at91_set_A_periph(AT91_PIN_PA3, 1);
> -			at91_set_A_periph(AT91_PIN_PA4, 1);
> -			at91_set_A_periph(AT91_PIN_PA5, 1);
> -		}
> -
> -		mmc_data = *data;
> -		platform_device_register(&at91sam9rl_mmc_device);
> -	}
> -}
> -#else
> -void __init at91_add_device_mci(short mmc_id, struct mci_platform_data *data) {}
> -#endif
> -
> -
> -/* --------------------------------------------------------------------
> - *  NAND / SmartMedia
> - * -------------------------------------------------------------------- */
> -
> -#if defined(CONFIG_MTD_NAND_ATMEL) || defined(CONFIG_MTD_NAND_ATMEL_MODULE)
> -static struct atmel_nand_data nand_data;
> -
> -#define NAND_BASE	AT91_CHIPSELECT_3
> -
> -static struct resource nand_resources[] = {
> -	[0] = {
> -		.start	= NAND_BASE,
> -		.end	= NAND_BASE + SZ_256M - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= AT91SAM9RL_BASE_ECC,
> -		.end	= AT91SAM9RL_BASE_ECC + SZ_512 - 1,
> -		.flags	= IORESOURCE_MEM,
> -	}
> -};
> -
> -static struct platform_device atmel_nand_device = {
> -	.name		= "atmel_nand",
> -	.id		= -1,
> -	.dev		= {
> -				.platform_data	= &nand_data,
> -	},
> -	.resource	= nand_resources,
> -	.num_resources	= ARRAY_SIZE(nand_resources),
> -};
> -
> -void __init at91_add_device_nand(struct atmel_nand_data *data)
> -{
> -	unsigned long csa;
> -
> -	if (!data)
> -		return;
> -
> -	csa = at91_matrix_read(AT91_MATRIX_EBICSA);
> -	at91_matrix_write(AT91_MATRIX_EBICSA, csa | AT91_MATRIX_CS3A_SMC_SMARTMEDIA);
> -
> -	/* enable pin */
> -	if (gpio_is_valid(data->enable_pin))
> -		at91_set_gpio_output(data->enable_pin, 1);
> -
> -	/* ready/busy pin */
> -	if (gpio_is_valid(data->rdy_pin))
> -		at91_set_gpio_input(data->rdy_pin, 1);
> -
> -	/* card detect pin */
> -	if (gpio_is_valid(data->det_pin))
> -		at91_set_gpio_input(data->det_pin, 1);
> -
> -	at91_set_A_periph(AT91_PIN_PB4, 0);		/* NANDOE */
> -	at91_set_A_periph(AT91_PIN_PB5, 0);		/* NANDWE */
> -
> -	nand_data = *data;
> -	platform_device_register(&atmel_nand_device);
> -}
> -
> -#else
> -void __init at91_add_device_nand(struct atmel_nand_data *data) {}
> -#endif
> -
> -
> -/* --------------------------------------------------------------------
> - *  TWI (i2c)
> - * -------------------------------------------------------------------- */
> -
> -/*
> - * Prefer the GPIO code since the TWI controller isn't robust
> - * (gets overruns and underruns under load) and can only issue
> - * repeated STARTs in one scenario (the driver doesn't yet handle them).
> - */
> -#if defined(CONFIG_I2C_GPIO) || defined(CONFIG_I2C_GPIO_MODULE)
> -
> -static struct i2c_gpio_platform_data pdata = {
> -	.sda_pin		= AT91_PIN_PA23,
> -	.sda_is_open_drain	= 1,
> -	.scl_pin		= AT91_PIN_PA24,
> -	.scl_is_open_drain	= 1,
> -	.udelay			= 2,		/* ~100 kHz */
> -};
> -
> -static struct platform_device at91sam9rl_twi_device = {
> -	.name			= "i2c-gpio",
> -	.id			= 0,
> -	.dev.platform_data	= &pdata,
> -};
> -
> -void __init at91_add_device_i2c(struct i2c_board_info *devices, int nr_devices)
> -{
> -	at91_set_GPIO_periph(AT91_PIN_PA23, 1);		/* TWD (SDA) */
> -	at91_set_multi_drive(AT91_PIN_PA23, 1);
> -
> -	at91_set_GPIO_periph(AT91_PIN_PA24, 1);		/* TWCK (SCL) */
> -	at91_set_multi_drive(AT91_PIN_PA24, 1);
> -
> -	i2c_register_board_info(0, devices, nr_devices);
> -	platform_device_register(&at91sam9rl_twi_device);
> -}
> -
> -#elif defined(CONFIG_I2C_AT91) || defined(CONFIG_I2C_AT91_MODULE)
> -
> -static struct resource twi_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9RL_BASE_TWI0,
> -		.end	= AT91SAM9RL_BASE_TWI0 + SZ_16K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_TWI0,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_TWI0,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static struct platform_device at91sam9rl_twi_device = {
> -	.name		= "i2c-at91sam9g20",
> -	.id		= 0,
> -	.resource	= twi_resources,
> -	.num_resources	= ARRAY_SIZE(twi_resources),
> -};
> -
> -void __init at91_add_device_i2c(struct i2c_board_info *devices, int nr_devices)
> -{
> -	/* pins used for TWI interface */
> -	at91_set_A_periph(AT91_PIN_PA23, 0);		/* TWD */
> -	at91_set_multi_drive(AT91_PIN_PA23, 1);
> -
> -	at91_set_A_periph(AT91_PIN_PA24, 0);		/* TWCK */
> -	at91_set_multi_drive(AT91_PIN_PA24, 1);
> -
> -	i2c_register_board_info(0, devices, nr_devices);
> -	platform_device_register(&at91sam9rl_twi_device);
> -}
> -#else
> -void __init at91_add_device_i2c(struct i2c_board_info *devices, int nr_devices) {}
> -#endif
> -
> -
> -/* --------------------------------------------------------------------
> - *  SPI
> - * -------------------------------------------------------------------- */
> -
> -#if defined(CONFIG_SPI_ATMEL) || defined(CONFIG_SPI_ATMEL_MODULE)
> -static u64 spi_dmamask = DMA_BIT_MASK(32);
> -
> -static struct resource spi_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9RL_BASE_SPI,
> -		.end	= AT91SAM9RL_BASE_SPI + SZ_16K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_SPI,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_SPI,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static struct platform_device at91sam9rl_spi_device = {
> -	.name		= "atmel_spi",
> -	.id		= 0,
> -	.dev		= {
> -				.dma_mask		= &spi_dmamask,
> -				.coherent_dma_mask	= DMA_BIT_MASK(32),
> -	},
> -	.resource	= spi_resources,
> -	.num_resources	= ARRAY_SIZE(spi_resources),
> -};
> -
> -static const unsigned spi_standard_cs[4] = { AT91_PIN_PA28, AT91_PIN_PB7, AT91_PIN_PD8, AT91_PIN_PD9 };
> -
> -
> -void __init at91_add_device_spi(struct spi_board_info *devices, int nr_devices)
> -{
> -	int i;
> -	unsigned long cs_pin;
> -
> -	at91_set_A_periph(AT91_PIN_PA25, 0);	/* MISO */
> -	at91_set_A_periph(AT91_PIN_PA26, 0);	/* MOSI */
> -	at91_set_A_periph(AT91_PIN_PA27, 0);	/* SPCK */
> -
> -	/* Enable SPI chip-selects */
> -	for (i = 0; i < nr_devices; i++) {
> -		if (devices[i].controller_data)
> -			cs_pin = (unsigned long) devices[i].controller_data;
> -		else
> -			cs_pin = spi_standard_cs[devices[i].chip_select];
> -
> -		if (!gpio_is_valid(cs_pin))
> -			continue;
> -
> -		/* enable chip-select pin */
> -		at91_set_gpio_output(cs_pin, 1);
> -
> -		/* pass chip-select pin to driver */
> -		devices[i].controller_data = (void *) cs_pin;
> -	}
> -
> -	spi_register_board_info(devices, nr_devices);
> -	platform_device_register(&at91sam9rl_spi_device);
> -}
> -#else
> -void __init at91_add_device_spi(struct spi_board_info *devices, int nr_devices) {}
> -#endif
> -
> -
> -/* --------------------------------------------------------------------
> - *  AC97
> - * -------------------------------------------------------------------- */
> -
> -#if defined(CONFIG_SND_ATMEL_AC97C) || defined(CONFIG_SND_ATMEL_AC97C_MODULE)
> -static u64 ac97_dmamask = DMA_BIT_MASK(32);
> -static struct ac97c_platform_data ac97_data;
> -
> -static struct resource ac97_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9RL_BASE_AC97C,
> -		.end	= AT91SAM9RL_BASE_AC97C + SZ_16K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_AC97C,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_AC97C,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static struct platform_device at91sam9rl_ac97_device = {
> -	.name		= "atmel_ac97c",
> -	.id		= 0,
> -	.dev		= {
> -				.dma_mask		= &ac97_dmamask,
> -				.coherent_dma_mask	= DMA_BIT_MASK(32),
> -				.platform_data		= &ac97_data,
> -	},
> -	.resource	= ac97_resources,
> -	.num_resources	= ARRAY_SIZE(ac97_resources),
> -};
> -
> -void __init at91_add_device_ac97(struct ac97c_platform_data *data)
> -{
> -	if (!data)
> -		return;
> -
> -	at91_set_A_periph(AT91_PIN_PD1, 0);	/* AC97FS */
> -	at91_set_A_periph(AT91_PIN_PD2, 0);	/* AC97CK */
> -	at91_set_A_periph(AT91_PIN_PD3, 0);	/* AC97TX */
> -	at91_set_A_periph(AT91_PIN_PD4, 0);	/* AC97RX */
> -
> -	/* reset */
> -	if (gpio_is_valid(data->reset_pin))
> -		at91_set_gpio_output(data->reset_pin, 0);
> -
> -	ac97_data = *data;
> -	platform_device_register(&at91sam9rl_ac97_device);
> -}
> -#else
> -void __init at91_add_device_ac97(struct ac97c_platform_data *data) {}
> -#endif
> -
> -
> -/* --------------------------------------------------------------------
> - *  LCD Controller
> - * -------------------------------------------------------------------- */
> -
> -#if defined(CONFIG_FB_ATMEL) || defined(CONFIG_FB_ATMEL_MODULE)
> -static u64 lcdc_dmamask = DMA_BIT_MASK(32);
> -static struct atmel_lcdfb_pdata lcdc_data;
> -
> -static struct resource lcdc_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9RL_LCDC_BASE,
> -		.end	= AT91SAM9RL_LCDC_BASE + SZ_4K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_LCDC,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_LCDC,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static struct platform_device at91_lcdc_device = {
> -	.name		= "at91sam9rl-lcdfb",
> -	.id		= 0,
> -	.dev		= {
> -				.dma_mask		= &lcdc_dmamask,
> -				.coherent_dma_mask	= DMA_BIT_MASK(32),
> -				.platform_data		= &lcdc_data,
> -	},
> -	.resource	= lcdc_resources,
> -	.num_resources	= ARRAY_SIZE(lcdc_resources),
> -};
> -
> -void __init at91_add_device_lcdc(struct atmel_lcdfb_pdata *data)
> -{
> -	if (!data) {
> -		return;
> -	}
> -
> -	at91_set_B_periph(AT91_PIN_PC1, 0);	/* LCDPWR */
> -	at91_set_A_periph(AT91_PIN_PC5, 0);	/* LCDHSYNC */
> -	at91_set_A_periph(AT91_PIN_PC6, 0);	/* LCDDOTCK */
> -	at91_set_A_periph(AT91_PIN_PC7, 0);	/* LCDDEN */
> -	at91_set_A_periph(AT91_PIN_PC3, 0);	/* LCDCC */
> -	at91_set_B_periph(AT91_PIN_PC9, 0);	/* LCDD3 */
> -	at91_set_B_periph(AT91_PIN_PC10, 0);	/* LCDD4 */
> -	at91_set_B_periph(AT91_PIN_PC11, 0);	/* LCDD5 */
> -	at91_set_B_periph(AT91_PIN_PC12, 0);	/* LCDD6 */
> -	at91_set_B_periph(AT91_PIN_PC13, 0);	/* LCDD7 */
> -	at91_set_B_periph(AT91_PIN_PC15, 0);	/* LCDD11 */
> -	at91_set_B_periph(AT91_PIN_PC16, 0);	/* LCDD12 */
> -	at91_set_B_periph(AT91_PIN_PC17, 0);	/* LCDD13 */
> -	at91_set_B_periph(AT91_PIN_PC18, 0);	/* LCDD14 */
> -	at91_set_B_periph(AT91_PIN_PC19, 0);	/* LCDD15 */
> -	at91_set_B_periph(AT91_PIN_PC20, 0);	/* LCDD18 */
> -	at91_set_B_periph(AT91_PIN_PC21, 0);	/* LCDD19 */
> -	at91_set_B_periph(AT91_PIN_PC22, 0);	/* LCDD20 */
> -	at91_set_B_periph(AT91_PIN_PC23, 0);	/* LCDD21 */
> -	at91_set_B_periph(AT91_PIN_PC24, 0);	/* LCDD22 */
> -	at91_set_B_periph(AT91_PIN_PC25, 0);	/* LCDD23 */
> -
> -	lcdc_data = *data;
> -	platform_device_register(&at91_lcdc_device);
> -}
> -#else
> -void __init at91_add_device_lcdc(struct atmel_lcdfb_pdata *data) {}
> -#endif
> -
> -
> -/* --------------------------------------------------------------------
> - *  Timer/Counter block
> - * -------------------------------------------------------------------- */
> -
> -#ifdef CONFIG_ATMEL_TCLIB
> -
> -static struct resource tcb_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9RL_BASE_TCB0,
> -		.end	= AT91SAM9RL_BASE_TCB0 + SZ_16K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_TC0,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_TC0,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -	[2] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_TC1,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_TC1,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -	[3] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_TC2,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_TC2,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static struct platform_device at91sam9rl_tcb_device = {
> -	.name		= "atmel_tcb",
> -	.id		= 0,
> -	.resource	= tcb_resources,
> -	.num_resources	= ARRAY_SIZE(tcb_resources),
> -};
> -
> -static void __init at91_add_device_tc(void)
> -{
> -	platform_device_register(&at91sam9rl_tcb_device);
> -}
> -#else
> -static void __init at91_add_device_tc(void) { }
> -#endif
> -
> -
> -/* --------------------------------------------------------------------
> - *  ADC and Touchscreen
> - * -------------------------------------------------------------------- */
> -
> -#if IS_ENABLED(CONFIG_AT91_ADC)
> -static struct at91_adc_data adc_data;
> -
> -static struct resource adc_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9RL_BASE_TSC,
> -		.end	= AT91SAM9RL_BASE_TSC + SZ_16K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_TSC,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_TSC,
> -		.flags	= IORESOURCE_IRQ,
> -	}
> -};
> -
> -static struct platform_device at91_adc_device = {
> -	.name           = "at91sam9rl-adc",
> -	.id             = -1,
> -	.dev            = {
> -		.platform_data  = &adc_data,
> -	},
> -	.resource       = adc_resources,
> -	.num_resources  = ARRAY_SIZE(adc_resources),
> -};
> -
> -static struct at91_adc_trigger at91_adc_triggers[] = {
> -	[0] = {
> -		.name = "external-rising",
> -		.value = 1,
> -		.is_external = true,
> -	},
> -	[1] = {
> -		.name = "external-falling",
> -		.value = 2,
> -		.is_external = true,
> -	},
> -	[2] = {
> -		.name = "external-any",
> -		.value = 3,
> -		.is_external = true,
> -	},
> -	[3] = {
> -		.name = "continuous",
> -		.value = 6,
> -		.is_external = false,
> -	},
> -};
> -
> -void __init at91_add_device_adc(struct at91_adc_data *data)
> -{
> -	if (!data)
> -		return;
> -
> -	if (test_bit(0, &data->channels_used))
> -		at91_set_A_periph(AT91_PIN_PA17, 0);
> -	if (test_bit(1, &data->channels_used))
> -		at91_set_A_periph(AT91_PIN_PA18, 0);
> -	if (test_bit(2, &data->channels_used))
> -		at91_set_A_periph(AT91_PIN_PA19, 0);
> -	if (test_bit(3, &data->channels_used))
> -		at91_set_A_periph(AT91_PIN_PA20, 0);
> -	if (test_bit(4, &data->channels_used))
> -		at91_set_A_periph(AT91_PIN_PD6, 0);
> -	if (test_bit(5, &data->channels_used))
> -		at91_set_A_periph(AT91_PIN_PD7, 0);
> -
> -	if (data->use_external_triggers)
> -		at91_set_A_periph(AT91_PIN_PB15, 0);
> -
> -	data->startup_time = 40;
> -	data->trigger_number = 4;
> -	data->trigger_list = at91_adc_triggers;
> -
> -	adc_data = *data;
> -	platform_device_register(&at91_adc_device);
> -}
> -#else
> -void __init at91_add_device_adc(struct at91_adc_data *data) {}
> -#endif
> -
> -/* --------------------------------------------------------------------
> - *  RTC
> - * -------------------------------------------------------------------- */
> -
> -#if defined(CONFIG_RTC_DRV_AT91RM9200) || defined(CONFIG_RTC_DRV_AT91RM9200_MODULE)
> -static struct platform_device at91sam9rl_rtc_device = {
> -	.name		= "at91_rtc",
> -	.id		= -1,
> -	.num_resources	= 0,
> -};
> -
> -static void __init at91_add_device_rtc(void)
> -{
> -	platform_device_register(&at91sam9rl_rtc_device);
> -}
> -#else
> -static void __init at91_add_device_rtc(void) {}
> -#endif
> -
> -
> -/* --------------------------------------------------------------------
> - *  RTT
> - * -------------------------------------------------------------------- */
> -
> -static struct resource rtt_resources[] = {
> -	{
> -		.start	= AT91SAM9RL_BASE_RTT,
> -		.end	= AT91SAM9RL_BASE_RTT + SZ_16 - 1,
> -		.flags	= IORESOURCE_MEM,
> -	}, {
> -		.flags	= IORESOURCE_MEM,
> -	}, {
> -		.flags  = IORESOURCE_IRQ,
> -	}
> -};
> -
> -static struct platform_device at91sam9rl_rtt_device = {
> -	.name		= "at91_rtt",
> -	.id		= 0,
> -	.resource	= rtt_resources,
> -};
> -
> -#if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
> -static void __init at91_add_device_rtt_rtc(void)
> -{
> -	at91sam9rl_rtt_device.name = "rtc-at91sam9";
> -	/*
> -	 * The second resource is needed:
> -	 * GPBR will serve as the storage for RTC time offset
> -	 */
> -	at91sam9rl_rtt_device.num_resources = 3;
> -	rtt_resources[1].start = AT91SAM9RL_BASE_GPBR +
> -				 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR;
> -	rtt_resources[1].end = rtt_resources[1].start + 3;
> -	rtt_resources[2].start = NR_IRQS_LEGACY + AT91_ID_SYS;
> -	rtt_resources[2].end = NR_IRQS_LEGACY + AT91_ID_SYS;
> -}
> -#else
> -static void __init at91_add_device_rtt_rtc(void)
> -{
> -	/* Only one resource is needed: RTT not used as RTC */
> -	at91sam9rl_rtt_device.num_resources = 1;
> -}
> -#endif
> -
> -static void __init at91_add_device_rtt(void)
> -{
> -	at91_add_device_rtt_rtc();
> -	platform_device_register(&at91sam9rl_rtt_device);
> -}
> -
> -
> -/* --------------------------------------------------------------------
> - *  Watchdog
> - * -------------------------------------------------------------------- */
> -
> -#if defined(CONFIG_AT91SAM9X_WATCHDOG) || defined(CONFIG_AT91SAM9X_WATCHDOG_MODULE)
> -static struct resource wdt_resources[] = {
> -	{
> -		.start	= AT91SAM9RL_BASE_WDT,
> -		.end	= AT91SAM9RL_BASE_WDT + SZ_16 - 1,
> -		.flags	= IORESOURCE_MEM,
> -	}
> -};
> -
> -static struct platform_device at91sam9rl_wdt_device = {
> -	.name		= "at91_wdt",
> -	.id		= -1,
> -	.resource	= wdt_resources,
> -	.num_resources	= ARRAY_SIZE(wdt_resources),
> -};
> -
> -static void __init at91_add_device_watchdog(void)
> -{
> -	platform_device_register(&at91sam9rl_wdt_device);
> -}
> -#else
> -static void __init at91_add_device_watchdog(void) {}
> -#endif
> -
> -
> -/* --------------------------------------------------------------------
> - *  PWM
> - * --------------------------------------------------------------------*/
> -
> -#if IS_ENABLED(CONFIG_PWM_ATMEL)
> -static struct resource pwm_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9RL_BASE_PWMC,
> -		.end	= AT91SAM9RL_BASE_PWMC + SZ_16K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_PWMC,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_PWMC,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static struct platform_device at91sam9rl_pwm0_device = {
> -	.name	= "at91sam9rl-pwm",
> -	.id	= -1,
> -	.resource	= pwm_resources,
> -	.num_resources	= ARRAY_SIZE(pwm_resources),
> -};
> -
> -void __init at91_add_device_pwm(u32 mask)
> -{
> -	if (mask & (1 << AT91_PWM0))
> -		at91_set_B_periph(AT91_PIN_PB8, 1);	/* enable PWM0 */
> -
> -	if (mask & (1 << AT91_PWM1))
> -		at91_set_B_periph(AT91_PIN_PB9, 1);	/* enable PWM1 */
> -
> -	if (mask & (1 << AT91_PWM2))
> -		at91_set_B_periph(AT91_PIN_PD5, 1);	/* enable PWM2 */
> -
> -	if (mask & (1 << AT91_PWM3))
> -		at91_set_B_periph(AT91_PIN_PD8, 1);	/* enable PWM3 */
> -
> -	platform_device_register(&at91sam9rl_pwm0_device);
> -}
> -#else
> -void __init at91_add_device_pwm(u32 mask) {}
> -#endif
> -
> -
> -/* --------------------------------------------------------------------
> - *  SSC -- Synchronous Serial Controller
> - * -------------------------------------------------------------------- */
> -
> -#if defined(CONFIG_ATMEL_SSC) || defined(CONFIG_ATMEL_SSC_MODULE)
> -static u64 ssc0_dmamask = DMA_BIT_MASK(32);
> -
> -static struct resource ssc0_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9RL_BASE_SSC0,
> -		.end	= AT91SAM9RL_BASE_SSC0 + SZ_16K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_SSC0,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_SSC0,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static struct platform_device at91sam9rl_ssc0_device = {
> -	.name	= "at91rm9200_ssc",
> -	.id	= 0,
> -	.dev	= {
> -		.dma_mask		= &ssc0_dmamask,
> -		.coherent_dma_mask	= DMA_BIT_MASK(32),
> -	},
> -	.resource	= ssc0_resources,
> -	.num_resources	= ARRAY_SIZE(ssc0_resources),
> -};
> -
> -static inline void configure_ssc0_pins(unsigned pins)
> -{
> -	if (pins & ATMEL_SSC_TF)
> -		at91_set_A_periph(AT91_PIN_PC0, 1);
> -	if (pins & ATMEL_SSC_TK)
> -		at91_set_A_periph(AT91_PIN_PC1, 1);
> -	if (pins & ATMEL_SSC_TD)
> -		at91_set_A_periph(AT91_PIN_PA15, 1);
> -	if (pins & ATMEL_SSC_RD)
> -		at91_set_A_periph(AT91_PIN_PA16, 1);
> -	if (pins & ATMEL_SSC_RK)
> -		at91_set_B_periph(AT91_PIN_PA10, 1);
> -	if (pins & ATMEL_SSC_RF)
> -		at91_set_B_periph(AT91_PIN_PA22, 1);
> -}
> -
> -static u64 ssc1_dmamask = DMA_BIT_MASK(32);
> -
> -static struct resource ssc1_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9RL_BASE_SSC1,
> -		.end	= AT91SAM9RL_BASE_SSC1 + SZ_16K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_SSC1,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_SSC1,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static struct platform_device at91sam9rl_ssc1_device = {
> -	.name	= "at91rm9200_ssc",
> -	.id	= 1,
> -	.dev	= {
> -		.dma_mask		= &ssc1_dmamask,
> -		.coherent_dma_mask	= DMA_BIT_MASK(32),
> -	},
> -	.resource	= ssc1_resources,
> -	.num_resources	= ARRAY_SIZE(ssc1_resources),
> -};
> -
> -static inline void configure_ssc1_pins(unsigned pins)
> -{
> -	if (pins & ATMEL_SSC_TF)
> -		at91_set_B_periph(AT91_PIN_PA29, 1);
> -	if (pins & ATMEL_SSC_TK)
> -		at91_set_B_periph(AT91_PIN_PA30, 1);
> -	if (pins & ATMEL_SSC_TD)
> -		at91_set_B_periph(AT91_PIN_PA13, 1);
> -	if (pins & ATMEL_SSC_RD)
> -		at91_set_B_periph(AT91_PIN_PA14, 1);
> -	if (pins & ATMEL_SSC_RK)
> -		at91_set_B_periph(AT91_PIN_PA9, 1);
> -	if (pins & ATMEL_SSC_RF)
> -		at91_set_B_periph(AT91_PIN_PA8, 1);
> -}
> -
> -/*
> - * SSC controllers are accessed through library code, instead of any
> - * kind of all-singing/all-dancing driver.  For example one could be
> - * used by a particular I2S audio codec's driver, while another one
> - * on the same system might be used by a custom data capture driver.
> - */
> -void __init at91_add_device_ssc(unsigned id, unsigned pins)
> -{
> -	struct platform_device *pdev;
> -
> -	/*
> -	 * NOTE: caller is responsible for passing information matching
> -	 * "pins" to whatever will be using each particular controller.
> -	 */
> -	switch (id) {
> -	case AT91SAM9RL_ID_SSC0:
> -		pdev = &at91sam9rl_ssc0_device;
> -		configure_ssc0_pins(pins);
> -		break;
> -	case AT91SAM9RL_ID_SSC1:
> -		pdev = &at91sam9rl_ssc1_device;
> -		configure_ssc1_pins(pins);
> -		break;
> -	default:
> -		return;
> -	}
> -
> -	platform_device_register(pdev);
> -}
> -
> -#else
> -void __init at91_add_device_ssc(unsigned id, unsigned pins) {}
> -#endif
> -
> -
> -/* --------------------------------------------------------------------
> - *  UART
> - * -------------------------------------------------------------------- */
> -
> -#if defined(CONFIG_SERIAL_ATMEL)
> -static struct resource dbgu_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9RL_BASE_DBGU,
> -		.end	= AT91SAM9RL_BASE_DBGU + SZ_512 - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= NR_IRQS_LEGACY + AT91_ID_SYS,
> -		.end	= NR_IRQS_LEGACY + AT91_ID_SYS,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static struct atmel_uart_data dbgu_data = {
> -	.use_dma_tx	= 0,
> -	.use_dma_rx	= 0,		/* DBGU not capable of receive DMA */
> -};
> -
> -static u64 dbgu_dmamask = DMA_BIT_MASK(32);
> -
> -static struct platform_device at91sam9rl_dbgu_device = {
> -	.name		= "atmel_usart",
> -	.id		= 0,
> -	.dev		= {
> -				.dma_mask		= &dbgu_dmamask,
> -				.coherent_dma_mask	= DMA_BIT_MASK(32),
> -				.platform_data		= &dbgu_data,
> -	},
> -	.resource	= dbgu_resources,
> -	.num_resources	= ARRAY_SIZE(dbgu_resources),
> -};
> -
> -static inline void configure_dbgu_pins(void)
> -{
> -	at91_set_A_periph(AT91_PIN_PA21, 0);		/* DRXD */
> -	at91_set_A_periph(AT91_PIN_PA22, 1);		/* DTXD */
> -}
> -
> -static struct resource uart0_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9RL_BASE_US0,
> -		.end	= AT91SAM9RL_BASE_US0 + SZ_16K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_US0,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_US0,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static struct atmel_uart_data uart0_data = {
> -	.use_dma_tx	= 1,
> -	.use_dma_rx	= 1,
> -};
> -
> -static u64 uart0_dmamask = DMA_BIT_MASK(32);
> -
> -static struct platform_device at91sam9rl_uart0_device = {
> -	.name		= "atmel_usart",
> -	.id		= 1,
> -	.dev		= {
> -				.dma_mask		= &uart0_dmamask,
> -				.coherent_dma_mask	= DMA_BIT_MASK(32),
> -				.platform_data		= &uart0_data,
> -	},
> -	.resource	= uart0_resources,
> -	.num_resources	= ARRAY_SIZE(uart0_resources),
> -};
> -
> -static inline void configure_usart0_pins(unsigned pins)
> -{
> -	at91_set_A_periph(AT91_PIN_PA6, 1);		/* TXD0 */
> -	at91_set_A_periph(AT91_PIN_PA7, 0);		/* RXD0 */
> -
> -	if (pins & ATMEL_UART_RTS)
> -		at91_set_A_periph(AT91_PIN_PA9, 0);	/* RTS0 */
> -	if (pins & ATMEL_UART_CTS)
> -		at91_set_A_periph(AT91_PIN_PA10, 0);	/* CTS0 */
> -	if (pins & ATMEL_UART_DSR)
> -		at91_set_A_periph(AT91_PIN_PD14, 0);	/* DSR0 */
> -	if (pins & ATMEL_UART_DTR)
> -		at91_set_A_periph(AT91_PIN_PD15, 0);	/* DTR0 */
> -	if (pins & ATMEL_UART_DCD)
> -		at91_set_A_periph(AT91_PIN_PD16, 0);	/* DCD0 */
> -	if (pins & ATMEL_UART_RI)
> -		at91_set_A_periph(AT91_PIN_PD17, 0);	/* RI0 */
> -}
> -
> -static struct resource uart1_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9RL_BASE_US1,
> -		.end	= AT91SAM9RL_BASE_US1 + SZ_16K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_US1,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_US1,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static struct atmel_uart_data uart1_data = {
> -	.use_dma_tx	= 1,
> -	.use_dma_rx	= 1,
> -};
> -
> -static u64 uart1_dmamask = DMA_BIT_MASK(32);
> -
> -static struct platform_device at91sam9rl_uart1_device = {
> -	.name		= "atmel_usart",
> -	.id		= 2,
> -	.dev		= {
> -				.dma_mask		= &uart1_dmamask,
> -				.coherent_dma_mask	= DMA_BIT_MASK(32),
> -				.platform_data		= &uart1_data,
> -	},
> -	.resource	= uart1_resources,
> -	.num_resources	= ARRAY_SIZE(uart1_resources),
> -};
> -
> -static inline void configure_usart1_pins(unsigned pins)
> -{
> -	at91_set_A_periph(AT91_PIN_PA11, 1);		/* TXD1 */
> -	at91_set_A_periph(AT91_PIN_PA12, 0);		/* RXD1 */
> -
> -	if (pins & ATMEL_UART_RTS)
> -		at91_set_B_periph(AT91_PIN_PA18, 0);	/* RTS1 */
> -	if (pins & ATMEL_UART_CTS)
> -		at91_set_B_periph(AT91_PIN_PA19, 0);	/* CTS1 */
> -}
> -
> -static struct resource uart2_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9RL_BASE_US2,
> -		.end	= AT91SAM9RL_BASE_US2 + SZ_16K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_US2,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_US2,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static struct atmel_uart_data uart2_data = {
> -	.use_dma_tx	= 1,
> -	.use_dma_rx	= 1,
> -};
> -
> -static u64 uart2_dmamask = DMA_BIT_MASK(32);
> -
> -static struct platform_device at91sam9rl_uart2_device = {
> -	.name		= "atmel_usart",
> -	.id		= 3,
> -	.dev		= {
> -				.dma_mask		= &uart2_dmamask,
> -				.coherent_dma_mask	= DMA_BIT_MASK(32),
> -				.platform_data		= &uart2_data,
> -	},
> -	.resource	= uart2_resources,
> -	.num_resources	= ARRAY_SIZE(uart2_resources),
> -};
> -
> -static inline void configure_usart2_pins(unsigned pins)
> -{
> -	at91_set_A_periph(AT91_PIN_PA13, 1);		/* TXD2 */
> -	at91_set_A_periph(AT91_PIN_PA14, 0);		/* RXD2 */
> -
> -	if (pins & ATMEL_UART_RTS)
> -		at91_set_A_periph(AT91_PIN_PA29, 0);	/* RTS2 */
> -	if (pins & ATMEL_UART_CTS)
> -		at91_set_A_periph(AT91_PIN_PA30, 0);	/* CTS2 */
> -}
> -
> -static struct resource uart3_resources[] = {
> -	[0] = {
> -		.start	= AT91SAM9RL_BASE_US3,
> -		.end	= AT91SAM9RL_BASE_US3 + SZ_16K - 1,
> -		.flags	= IORESOURCE_MEM,
> -	},
> -	[1] = {
> -		.start	= NR_IRQS_LEGACY + AT91SAM9RL_ID_US3,
> -		.end	= NR_IRQS_LEGACY + AT91SAM9RL_ID_US3,
> -		.flags	= IORESOURCE_IRQ,
> -	},
> -};
> -
> -static struct atmel_uart_data uart3_data = {
> -	.use_dma_tx	= 1,
> -	.use_dma_rx	= 1,
> -};
> -
> -static u64 uart3_dmamask = DMA_BIT_MASK(32);
> -
> -static struct platform_device at91sam9rl_uart3_device = {
> -	.name		= "atmel_usart",
> -	.id		= 4,
> -	.dev		= {
> -				.dma_mask		= &uart3_dmamask,
> -				.coherent_dma_mask	= DMA_BIT_MASK(32),
> -				.platform_data		= &uart3_data,
> -	},
> -	.resource	= uart3_resources,
> -	.num_resources	= ARRAY_SIZE(uart3_resources),
> -};
> -
> -static inline void configure_usart3_pins(unsigned pins)
> -{
> -	at91_set_A_periph(AT91_PIN_PB0, 1);		/* TXD3 */
> -	at91_set_A_periph(AT91_PIN_PB1, 0);		/* RXD3 */
> -
> -	if (pins & ATMEL_UART_RTS)
> -		at91_set_B_periph(AT91_PIN_PD4, 0);	/* RTS3 */
> -	if (pins & ATMEL_UART_CTS)
> -		at91_set_B_periph(AT91_PIN_PD3, 0);	/* CTS3 */
> -}
> -
> -static struct platform_device *__initdata at91_uarts[ATMEL_MAX_UART];	/* the UARTs to use */
> -
> -void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins)
> -{
> -	struct platform_device *pdev;
> -	struct atmel_uart_data *pdata;
> -
> -	switch (id) {
> -		case 0:		/* DBGU */
> -			pdev = &at91sam9rl_dbgu_device;
> -			configure_dbgu_pins();
> -			break;
> -		case AT91SAM9RL_ID_US0:
> -			pdev = &at91sam9rl_uart0_device;
> -			configure_usart0_pins(pins);
> -			break;
> -		case AT91SAM9RL_ID_US1:
> -			pdev = &at91sam9rl_uart1_device;
> -			configure_usart1_pins(pins);
> -			break;
> -		case AT91SAM9RL_ID_US2:
> -			pdev = &at91sam9rl_uart2_device;
> -			configure_usart2_pins(pins);
> -			break;
> -		case AT91SAM9RL_ID_US3:
> -			pdev = &at91sam9rl_uart3_device;
> -			configure_usart3_pins(pins);
> -			break;
> -		default:
> -			return;
> -	}
> -	pdata = pdev->dev.platform_data;
> -	pdata->num = portnr;		/* update to mapped ID */
> -
> -	if (portnr < ATMEL_MAX_UART)
> -		at91_uarts[portnr] = pdev;
> -}
> -
> -void __init at91_add_device_serial(void)
> -{
> -	int i;
> -
> -	for (i = 0; i < ATMEL_MAX_UART; i++) {
> -		if (at91_uarts[i])
> -			platform_device_register(at91_uarts[i]);
> -	}
> -}
> -#else
> -void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins) {}
> -void __init at91_add_device_serial(void) {}
> -#endif
> -
> -
> -/* -------------------------------------------------------------------- */
> -
> -/*
> - * These devices are always present and don't need any board-specific
> - * setup.
> - */
> -static int __init at91_add_standard_devices(void)
> -{
> -	at91_add_device_hdmac();
> -	at91_add_device_rtc();
> -	at91_add_device_rtt();
> -	at91_add_device_watchdog();
> -	at91_add_device_tc();
> -	return 0;
> -}
> -
> -arch_initcall(at91_add_standard_devices);
> diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
> deleted file mode 100644
> index b64648b4a1fc..000000000000
> --- a/arch/arm/mach-at91/board-sam9rlek.c
> +++ /dev/null
> @@ -1,332 +0,0 @@
> -/*
> - *  Copyright (C) 2005 SAN People
> - *  Copyright (C) 2007 Atmel Corporation
> - *
> - * This file is subject to the terms and conditions of the GNU General Public
> - * License.  See the file COPYING in the main directory of this archive for
> - * more details.
> - */
> -
> -#include <linux/types.h>
> -#include <linux/gpio.h>
> -#include <linux/init.h>
> -#include <linux/mm.h>
> -#include <linux/module.h>
> -#include <linux/platform_device.h>
> -#include <linux/spi/spi.h>
> -#include <linux/fb.h>
> -#include <linux/clk.h>
> -#include <linux/input.h>
> -#include <linux/gpio_keys.h>
> -#include <linux/platform_data/at91_adc.h>
> -
> -#include <video/atmel_lcdc.h>
> -
> -#include <asm/setup.h>
> -#include <asm/mach-types.h>
> -#include <asm/irq.h>
> -
> -#include <asm/mach/arch.h>
> -#include <asm/mach/map.h>
> -#include <asm/mach/irq.h>
> -
> -#include <mach/hardware.h>
> -#include <mach/at91sam9_smc.h>
> -
> -
> -#include "at91_aic.h"
> -#include "at91_shdwc.h"
> -#include "board.h"
> -#include "sam9_smc.h"
> -#include "generic.h"
> -#include "gpio.h"
> -
> -
> -static void __init ek_init_early(void)
> -{
> -	/* Initialize processor: 12.000 MHz crystal */
> -	at91_initialize(12000000);
> -}
> -
> -/*
> - * USB HS Device port
> - */
> -static struct usba_platform_data __initdata ek_usba_udc_data = {
> -	.vbus_pin	= AT91_PIN_PA8,
> -};
> -
> -
> -/*
> - * MCI (SD/MMC)
> - */
> -static struct mci_platform_data __initdata mci0_data = {
> -	.slot[0] = {
> -		.bus_width	= 4,
> -		.detect_pin	= AT91_PIN_PA15,
> -		.wp_pin		= -EINVAL,
> -	},
> -};
> -
> -
> -/*
> - * NAND flash
> - */
> -static struct mtd_partition __initdata ek_nand_partition[] = {
> -	{
> -		.name	= "Partition 1",
> -		.offset	= 0,
> -		.size	= SZ_256K,
> -	},
> -	{
> -		.name	= "Partition 2",
> -		.offset	= MTDPART_OFS_NXTBLK,
> -		.size	= MTDPART_SIZ_FULL,
> -	},
> -};
> -
> -static struct atmel_nand_data __initdata ek_nand_data = {
> -	.ale		= 21,
> -	.cle		= 22,
> -	.det_pin	= -EINVAL,
> -	.rdy_pin	= AT91_PIN_PD17,
> -	.enable_pin	= AT91_PIN_PB6,
> -	.ecc_mode	= NAND_ECC_SOFT,
> -	.on_flash_bbt	= 1,
> -	.parts		= ek_nand_partition,
> -	.num_parts	= ARRAY_SIZE(ek_nand_partition),
> -};
> -
> -static struct sam9_smc_config __initdata ek_nand_smc_config = {
> -	.ncs_read_setup		= 0,
> -	.nrd_setup		= 1,
> -	.ncs_write_setup	= 0,
> -	.nwe_setup		= 1,
> -
> -	.ncs_read_pulse		= 3,
> -	.nrd_pulse		= 3,
> -	.ncs_write_pulse	= 3,
> -	.nwe_pulse		= 3,
> -
> -	.read_cycle		= 5,
> -	.write_cycle		= 5,
> -
> -	.mode			= AT91_SMC_READMODE | AT91_SMC_WRITEMODE | AT91_SMC_EXNWMODE_DISABLE | AT91_SMC_DBW_8,
> -	.tdf_cycles		= 2,
> -};
> -
> -static void __init ek_add_device_nand(void)
> -{
> -	/* configure chip-select 3 (NAND) */
> -	sam9_smc_configure(0, 3, &ek_nand_smc_config);
> -
> -	at91_add_device_nand(&ek_nand_data);
> -}
> -
> -
> -/*
> - * SPI devices
> - */
> -static struct spi_board_info ek_spi_devices[] = {
> -	{	/* DataFlash chip */
> -		.modalias	= "mtd_dataflash",
> -		.chip_select	= 0,
> -		.max_speed_hz	= 15 * 1000 * 1000,
> -		.bus_num	= 0,
> -	},
> -};
> -
> -
> -/*
> - * LCD Controller
> - */
> -#if defined(CONFIG_FB_ATMEL) || defined(CONFIG_FB_ATMEL_MODULE)
> -static struct fb_videomode at91_tft_vga_modes[] = {
> -	{
> -		.name		= "TX09D50VM1CCA @ 60",
> -		.refresh	= 60,
> -		.xres		= 240,		.yres		= 320,
> -		.pixclock	= KHZ2PICOS(4965),
> -
> -		.left_margin	= 1,		.right_margin	= 33,
> -		.upper_margin	= 1,		.lower_margin	= 0,
> -		.hsync_len	= 5,		.vsync_len	= 1,
> -
> -		.sync		= FB_SYNC_HOR_HIGH_ACT | FB_SYNC_VERT_HIGH_ACT,
> -		.vmode		= FB_VMODE_NONINTERLACED,
> -	},
> -};
> -
> -static struct fb_monspecs at91fb_default_monspecs = {
> -	.manufacturer	= "HIT",
> -	.monitor	= "TX09D50VM1CCA",
> -
> -	.modedb		= at91_tft_vga_modes,
> -	.modedb_len	= ARRAY_SIZE(at91_tft_vga_modes),
> -	.hfmin		= 15000,
> -	.hfmax		= 64000,
> -	.vfmin		= 50,
> -	.vfmax		= 150,
> -};
> -
> -#define AT91SAM9RL_DEFAULT_LCDCON2	(ATMEL_LCDC_MEMOR_LITTLE \
> -					| ATMEL_LCDC_DISTYPE_TFT \
> -					| ATMEL_LCDC_CLKMOD_ALWAYSACTIVE)
> -
> -static void at91_lcdc_power_control(struct atmel_lcdfb_pdata *pdata, int on)
> -{
> -	if (on)
> -		at91_set_gpio_value(AT91_PIN_PC1, 0);	/* power up */
> -	else
> -		at91_set_gpio_value(AT91_PIN_PC1, 1);	/* power down */
> -}
> -
> -/* Driver datas */
> -static struct atmel_lcdfb_pdata __initdata ek_lcdc_data = {
> -	.lcdcon_is_backlight            = true,
> -	.default_bpp			= 16,
> -	.default_dmacon			= ATMEL_LCDC_DMAEN,
> -	.default_lcdcon2		= AT91SAM9RL_DEFAULT_LCDCON2,
> -	.default_monspecs		= &at91fb_default_monspecs,
> -	.atmel_lcdfb_power_control	= at91_lcdc_power_control,
> -	.guard_time			= 1,
> -	.lcd_wiring_mode		= ATMEL_LCDC_WIRING_RGB,
> -};
> -
> -#else
> -static struct atmel_lcdfb_pdata __initdata ek_lcdc_data;
> -#endif
> -
> -
> -/*
> - * AC97
> - * reset_pin is not connected: NRST
> - */
> -static struct ac97c_platform_data ek_ac97_data = {
> -	.reset_pin	= -EINVAL,
> -};
> -
> -
> -/*
> - * LEDs
> - */
> -static struct gpio_led ek_leds[] = {
> -	{	/* "bottom" led, green, userled1 to be defined */
> -		.name			= "ds1",
> -		.gpio			= AT91_PIN_PD15,
> -		.active_low		= 1,
> -		.default_trigger	= "none",
> -	},
> -	{	/* "bottom" led, green, userled2 to be defined */
> -		.name			= "ds2",
> -		.gpio			= AT91_PIN_PD16,
> -		.active_low		= 1,
> -		.default_trigger	= "none",
> -	},
> -	{	/* "power" led, yellow */
> -		.name			= "ds3",
> -		.gpio			= AT91_PIN_PD14,
> -		.default_trigger	= "heartbeat",
> -	}
> -};
> -
> -
> -/*
> - * ADC + Touchscreen
> - */
> -static struct at91_adc_data ek_adc_data = {
> -	.channels_used = BIT(0) | BIT(1) | BIT(2) | BIT(3) | BIT(4) | BIT(5),
> -	.use_external_triggers = true,
> -	.vref = 3300,
> -	.touchscreen_type = ATMEL_ADC_TOUCHSCREEN_4WIRE,
> -};
> -
> -
> -/*
> - * GPIO Buttons
> - */
> -#if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
> -static struct gpio_keys_button ek_buttons[] = {
> -	{
> -		.gpio		= AT91_PIN_PB0,
> -		.code		= BTN_2,
> -		.desc		= "Right Click",
> -		.active_low	= 1,
> -		.wakeup		= 1,
> -	},
> -	{
> -		.gpio		= AT91_PIN_PB1,
> -		.code		= BTN_1,
> -		.desc		= "Left Click",
> -		.active_low	= 1,
> -		.wakeup		= 1,
> -	}
> -};
> -
> -static struct gpio_keys_platform_data ek_button_data = {
> -	.buttons	= ek_buttons,
> -	.nbuttons	= ARRAY_SIZE(ek_buttons),
> -};
> -
> -static struct platform_device ek_button_device = {
> -	.name		= "gpio-keys",
> -	.id		= -1,
> -	.num_resources	= 0,
> -	.dev		= {
> -		.platform_data	= &ek_button_data,
> -	}
> -};
> -
> -static void __init ek_add_device_buttons(void)
> -{
> -	at91_set_gpio_input(AT91_PIN_PB1, 1);	/* btn1 */
> -	at91_set_deglitch(AT91_PIN_PB1, 1);
> -	at91_set_gpio_input(AT91_PIN_PB0, 1);	/* btn2 */
> -	at91_set_deglitch(AT91_PIN_PB0, 1);
> -
> -	platform_device_register(&ek_button_device);
> -}
> -#else
> -static void __init ek_add_device_buttons(void) {}
> -#endif
> -
> -
> -static void __init ek_board_init(void)
> -{
> -	/* Serial */
> -	/* DBGU on ttyS0. (Rx & Tx only) */
> -	at91_register_uart(0, 0, 0);
> -
> -	/* USART0 on ttyS1. (Rx, Tx, CTS, RTS) */
> -	at91_register_uart(AT91SAM9RL_ID_US0, 1, ATMEL_UART_CTS | ATMEL_UART_RTS);
> -	at91_add_device_serial();
> -	/* USB HS */
> -	at91_add_device_usba(&ek_usba_udc_data);
> -	/* I2C */
> -	at91_add_device_i2c(NULL, 0);
> -	/* NAND */
> -	ek_add_device_nand();
> -	/* SPI */
> -	at91_add_device_spi(ek_spi_devices, ARRAY_SIZE(ek_spi_devices));
> -	/* MMC */
> -	at91_add_device_mci(0, &mci0_data);
> -	/* LCD Controller */
> -	at91_add_device_lcdc(&ek_lcdc_data);
> -	/* AC97 */
> -	at91_add_device_ac97(&ek_ac97_data);
> -	/* Touch Screen Controller + ADC */
> -	at91_add_device_adc(&ek_adc_data);
> -	/* LEDs */
> -	at91_gpio_leds(ek_leds, ARRAY_SIZE(ek_leds));
> -	/* Push Buttons */
> -	ek_add_device_buttons();
> -}
> -
> -MACHINE_START(AT91SAM9RLEK, "Atmel AT91SAM9RL-EK")
> -	/* Maintainer: Atmel */
> -	.init_time	= at91sam926x_pit_init,
> -	.map_io		= at91_map_io,
> -	.handle_irq	= at91_aic_handle_irq,
> -	.init_early	= ek_init_early,
> -	.init_irq	= at91_init_irq_default,
> -	.init_machine	= ek_board_init,
> -MACHINE_END
> 


-- 
Nicolas Ferre
