Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaLAQP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:15:26 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:51045 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaLAQPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:15:19 -0500
Message-ID: <547C9415.8090900@atmel.com>
Date: Mon, 1 Dec 2014 17:15:17 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Olof Johansson <olof@lixom.net>, <arm@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: cleanup for 3.19 #4
References: <1417176632-15929-1-git-send-email-nicolas.ferre@atmel.com> <201411282152.08438.arnd@arndb.de>
In-Reply-To: <201411282152.08438.arnd@arndb.de>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 28/11/2014 21:52, Arnd Bergmann a écrit :
> On Friday 28 November 2014, Nicolas Ferre wrote:
>> Arnd, Olof, Kevin,
>>
>> I think it's interesting to remove all the !DT stuff in one kernel revision, so
>> I'd like this pull-request to be integrated to 3.19 as well.
>>
>> This is the last series of patches that removes the non-Device-Tree board
>> support for older Atmel SoCs.
>> Several files beyond at91rm9200 are touched this time as I tried to remove the
>> biggest parts that were related to !DT SoC initializations.
>>
>> The diffstat is also pretty big as a lot of at91rm9200 boards were remaining.
>>
>> This PR is based on at91-cleanup3 that I sent a couple of days ago, so I think
>> that you can take both in a raw.
>>
>> Thanks, best regards,
>>
>> The following changes since commit 4fdfb67f24b64844ac110622bb51b2ee0f894492:
>>
>>   ARM: at91/Kconfig: remove useless fbdev Kconfig options (2014-11-21 12:18:40 +0100)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-cleanup4
>>
>> for you to fetch changes up to 4a109c50d1958a2783df01980b55508fe47bb79c:
>>
>>   ARM: at91: remove unused IRQ function declarations (2014-11-27 16:33:06 +0100)
>>
>> ----------------------------------------------------------------
>> Fourth batch of cleanup/SoC for 3.19:
>> - removal of legacy board support for the last SoC having board C files: at91rm9200
>> - removal or modification of some Kconfig options
>> - switch to USE_OF for all the AT91 SoCs
>> - removal of the old AT91-specific clocks and IRQ drivers
>>
> 
> I've pulled it into next/cleanup and played a little more with it,
> lookig for more obsolete code, and whatever is still needed for
> multiplatform support.
> 
> Please have a look at the patch below and see if you still want to
> submit some of the cleanups for 3.19. I'd certainly still take
> some of the dead code elimination. The driver changes below
> are all trivial, you may want to send that to the respective
> subsystem maintainers to simplify the step of turning on
> ARCH_MULTIPLATFORM in 3.20.
> 
> The multiplatform support is just for demonstration, and we should
> probably do as discussed and not introduce the ARCH_AT91_SINGLE
> option, although we could also do it if you really want to.

Brilliant!
I split your patch below and see if I can send some more bits soon.

> Finally, I found one bug: at91sam9261_ioremap_registers was
> removed and now nothing calls at91_ioremap_matrix(), but the udc
> driver still accesses it. This means that the at91_udc driver
> is already broken on sam9261 and sam9g10 with DT, independent
> of multiplatform or not. You may want to fix that.

Okay. Thanks for having catch that.


> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
>  arch/arm/Kconfig                                |   2 +-
>  arch/arm/mach-at91/Kconfig                      |  28 +-
>  arch/arm/mach-at91/Makefile                     |   7 +-
>  arch/arm/mach-at91/at91rm9200_time.c            |  23 -
>  arch/arm/mach-at91/board-dt-sam9.c              |   1 -
>  arch/arm/mach-at91/board.h                      | 123 ---
>  arch/arm/mach-at91/generic.h                    |  36 -
>  arch/arm/mach-at91/gpio.c                       | 982 ------------------------
>  arch/arm/mach-at91/gpio.h                       | 214 ------
>  arch/arm/mach-at91/include/mach/atmel-mci.h     |  17 -
>  arch/arm/mach-at91/include/mach/cpu.h           |   2 -
>  arch/arm/mach-at91/leds.c                       |  56 --
>  arch/arm/mach-at91/pm.c                         |  11 +-
>  arch/arm/mach-at91/setup.c                      |  96 +--
>  arch/arm/mach-at91/soc.h                        |   6 -
>  arch/avr32/mach-at32ap/at32ap700x.c             |   1 -
>  arch/avr32/mach-at32ap/include/mach/atmel-mci.h |  17 -
>  drivers/ata/Kconfig                             |   2 +-
>  drivers/clocksource/timer-atmel-pit.c           |  32 -
>  drivers/mmc/host/atmel-mci.c                    |   1 -
>  drivers/pcmcia/Kconfig                          |   2 +-
>  drivers/pinctrl/pinctrl-at91.c                  |   4 +-
>  drivers/rtc/rtc-at91sam9.c                      |  21 +-
>  drivers/usb/gadget/udc/Kconfig                  |   2 +-
>  drivers/usb/host/ohci-at91.c                    |   4 -
>  include/linux/atmel-mci.h                       |  12 +
>  sound/atmel/ac97c.c                             |   6 +-
>  sound/soc/atmel/sam9g20_wm8731.c                |   1 -
>  28 files changed, 71 insertions(+), 1638 deletions(-)
> 
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index fd4515ca8358..b446e953f8d0 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -371,7 +371,7 @@ config ARCH_VERSATILE
>  	help
>  	  This enables support for ARM Ltd Versatile board.
>  
> -config ARCH_AT91
> +config ARCH_AT91_SINGLE
>  	bool "Atmel AT91"
>  	select ARCH_REQUIRE_GPIOLIB
>  	select CLKDEV_LOOKUP
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 231893d71658..6475587f48bc 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -1,3 +1,15 @@
> +config ARCH_AT91
> +	bool "Atmel AT91" if ARCH_MULTI_V4_V5 || ARCH_MULTI_V7
> +	default ARCH_AT91_SINGLE
> +	select ARCH_REQUIRE_GPIOLIB
> +	select CLKDEV_LOOKUP
> +	select IRQ_DOMAIN
> +	select PINCTRL
> +	select PINCTRL_AT91
> +	help
> +	  This enables support for systems based on Atmel
> +	  AT91RM9200, AT91SAM9 and SAMA5 processors.
> +
>  if ARCH_AT91
>  
>  config HAVE_AT91_UTMI
> @@ -52,12 +64,14 @@ choice
>  
>  config SOC_SAM_V4_V5
>  	bool "ARM9 AT91SAM9/AT91RM9200"
> +	depends on ARCH_AT91_SINGLE || ARCH_MULTI_V4_V5
>  	help
>  	  Select this if you are using one of Atmel's AT91SAM9 or
>  	  AT91RM9200 SoC.
>  
>  config SOC_SAM_V7
>  	bool "Cortex A5"
> +	depends on ARCH_AT91_SINGLE || ARCH_MULTI_V7
>  	help
>  	  Select this if you are using one of Atmel's SAMA5D3 SoC.
>  
> @@ -97,6 +111,7 @@ endif
>  if SOC_SAM_V4_V5
>  config SOC_AT91RM9200
>  	bool "AT91RM9200"
> +	depends on ARCH_AT91_SINGLE || ARCH_MULTI_V4
>  	select ATMEL_AIC_IRQ
>  	select COMMON_CLK_AT91
>  	select CPU_ARM920T
> @@ -106,6 +121,7 @@ config SOC_AT91RM9200
>  
>  config SOC_AT91SAM9260
>  	bool "AT91SAM9260, AT91SAM9XE or AT91SAM9G20"
> +	depends on ARCH_AT91_SINGLE || ARCH_MULTI_V5
>  	select HAVE_AT91_DBGU0
>  	select SOC_AT91SAM9
>  	select HAVE_AT91_USB_CLK
> @@ -115,6 +131,7 @@ config SOC_AT91SAM9260
>  
>  config SOC_AT91SAM9261
>  	bool "AT91SAM9261 or AT91SAM9G10"
> +	depends on ARCH_AT91_SINGLE || ARCH_MULTI_V5
>  	select HAVE_AT91_DBGU0
>  	select HAVE_FB_ATMEL
>  	select SOC_AT91SAM9
> @@ -124,6 +141,7 @@ config SOC_AT91SAM9261
>  
>  config SOC_AT91SAM9263
>  	bool "AT91SAM9263"
> +	depends on ARCH_AT91_SINGLE || ARCH_MULTI_V5
>  	select HAVE_AT91_DBGU1
>  	select HAVE_FB_ATMEL
>  	select SOC_AT91SAM9
> @@ -131,6 +149,7 @@ config SOC_AT91SAM9263
>  
>  config SOC_AT91SAM9RL
>  	bool "AT91SAM9RL"
> +	depends on ARCH_AT91_SINGLE || ARCH_MULTI_V5
>  	select HAVE_AT91_DBGU0
>  	select HAVE_FB_ATMEL
>  	select SOC_AT91SAM9
> @@ -138,6 +157,7 @@ config SOC_AT91SAM9RL
>  
>  config SOC_AT91SAM9G45
>  	bool "AT91SAM9G45 or AT91SAM9M10 families"
> +	depends on ARCH_AT91_SINGLE || ARCH_MULTI_V5
>  	select HAVE_AT91_DBGU1
>  	select HAVE_FB_ATMEL
>  	select SOC_AT91SAM9
> @@ -149,6 +169,7 @@ config SOC_AT91SAM9G45
>  
>  config SOC_AT91SAM9X5
>  	bool "AT91SAM9x5 family"
> +	depends on ARCH_AT91_SINGLE || ARCH_MULTI_V5
>  	select HAVE_AT91_DBGU0
>  	select HAVE_FB_ATMEL
>  	select SOC_AT91SAM9
> @@ -164,6 +185,7 @@ config SOC_AT91SAM9X5
>  
>  config SOC_AT91SAM9N12
>  	bool "AT91SAM9N12 family"
> +	depends on ARCH_AT91_SINGLE || ARCH_MULTI_V5
>  	select HAVE_AT91_DBGU0
>  	select HAVE_FB_ATMEL
>  	select SOC_AT91SAM9
> @@ -177,15 +199,13 @@ endif # SOC_SAM_V4_V5
>  comment "Generic Board Type"
>  
>  config MACH_AT91RM9200_DT
> -	bool "Atmel AT91RM9200 Evaluation Kits with device-tree support"
> -	depends on SOC_AT91RM9200
> +	def_bool SOC_AT91RM9200
>  	help
>  	  Select this if you want to experiment device-tree with
>  	  an Atmel RM9200 Evaluation Kit.
>  
>  config MACH_AT91SAM9_DT
> -	bool "Atmel AT91SAM Evaluation Kits with device-tree support"
> -	depends on SOC_AT91SAM9
> +	def_bool SOC_AT91SAM9
>  	help
>  	  Select this if you want to experiment device-tree with
>  	  an Atmel Evaluation Kit.
> diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
> index 2371b8845bf5..e58a7363dc8c 100644
> --- a/arch/arm/mach-at91/Makefile
> +++ b/arch/arm/mach-at91/Makefile
> @@ -1,8 +1,10 @@
>  #
>  # Makefile for the linux kernel.
>  #
> +ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include
> +asflags-$(CONFIG_ARCH_MULTIPLATFORM) := -I$(srctree)/$(src)/include
>  
> -obj-y		:= gpio.o setup.o sysirq_mask.o
> +obj-y		:= setup.o sysirq_mask.o
>  
>  obj-$(CONFIG_SOC_AT91SAM9)	+= sam9_smc.o
>  
> @@ -25,9 +27,6 @@ obj-$(CONFIG_MACH_AT91SAM9_DT) += board-dt-sam9.o
>  # SAMA5 board with device-tree
>  obj-$(CONFIG_SOC_SAMA5)		+= board-dt-sama5.o
>  
> -# Drivers
> -obj-y				+= leds.o
> -
>  # Power Management
>  obj-$(CONFIG_PM)		+= pm.o
>  obj-$(CONFIG_AT91_SLOW_CLOCK)	+= pm_slowclock.o
> diff --git a/arch/arm/mach-at91/at91rm9200_time.c b/arch/arm/mach-at91/at91rm9200_time.c
> index 7fd13aef9827..51761f8927b7 100644
> --- a/arch/arm/mach-at91/at91rm9200_time.c
> +++ b/arch/arm/mach-at91/at91rm9200_time.c
> @@ -183,7 +183,6 @@ static struct clock_event_device clkevt = {
>  void __iomem *at91_st_base;
>  EXPORT_SYMBOL_GPL(at91_st_base);
>  
> -#ifdef CONFIG_OF
>  static struct of_device_id at91rm9200_st_timer_ids[] = {
>  	{ .compatible = "atmel,at91rm9200-st" },
>  	{ /* sentinel */ }
> @@ -219,28 +218,6 @@ node_err:
>  err:
>  	return -EINVAL;
>  }
> -#else
> -static int __init of_at91rm9200_st_init(void)
> -{
> -	return -EINVAL;
> -}
> -#endif
> -
> -void __init at91rm9200_ioremap_st(u32 addr)
> -{
> -#ifdef CONFIG_OF
> -	struct device_node *np;
> -
> -	np = of_find_matching_node(NULL, at91rm9200_st_timer_ids);
> -	if (np) {
> -		of_node_put(np);
> -		return;
> -	}
> -#endif
> -	at91_st_base = ioremap(addr, 256);
> -	if (!at91_st_base)
> -		panic("Impossible to ioremap ST\n");
> -}
>  
>  /*
>   * ST (system timer) module supports both clockevents and clocksource.
> diff --git a/arch/arm/mach-at91/board-dt-sam9.c b/arch/arm/mach-at91/board-dt-sam9.c
> index 67c1bcbf0ed9..f99246aa9b38 100644
> --- a/arch/arm/mach-at91/board-dt-sam9.c
> +++ b/arch/arm/mach-at91/board-dt-sam9.c
> @@ -21,7 +21,6 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include "board.h"
>  #include "generic.h"
>  
>  static const char *at91_dt_board_compat[] __initdata = {
> diff --git a/arch/arm/mach-at91/board.h b/arch/arm/mach-at91/board.h
> deleted file mode 100644
> index d268ec3781dd..000000000000
> --- a/arch/arm/mach-at91/board.h
> +++ /dev/null
> @@ -1,123 +0,0 @@
> -/*
> - * arch/arm/mach-at91/include/mach/board.h
> - *
> - *  Copyright (C) 2005 HP Labs
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> - */
> -
> -/*
> - * These are data structures found in platform_device.dev.platform_data,
> - * and describing board-specific data needed by drivers.  For example,
> - * which pin is used for a given GPIO role.
> - *
> - * In 2.6, drivers should strongly avoid board-specific knowledge so
> - * that supporting new boards normally won't require driver patches.
> - * Most board-specific knowledge should be in arch/.../board-*.c files.
> - */
> -
> -#ifndef __ASM_ARCH_BOARD_H
> -#define __ASM_ARCH_BOARD_H
> -
> -#include <linux/platform_data/atmel.h>
> -
> - /* USB Device */
> -extern void __init at91_add_device_udc(struct at91_udc_data *data);
> -
> - /* USB High Speed Device */
> -extern void __init at91_add_device_usba(struct usba_platform_data *data);
> -
> - /* Compact Flash */
> -extern void __init at91_add_device_cf(struct at91_cf_data *data);
> -
> - /* MMC / SD */
> -  /* atmel-mci platform config */
> -extern void __init at91_add_device_mci(short mmc_id, struct mci_platform_data *data);
> -
> -extern void __init at91_add_device_eth(struct macb_platform_data *data);
> -
> - /* USB Host */
> -extern void __init at91_add_device_usbh(struct at91_usbh_data *data);
> -extern void __init at91_add_device_usbh_ohci(struct at91_usbh_data *data);
> -extern void __init at91_add_device_usbh_ehci(struct at91_usbh_data *data);
> -
> -extern void __init at91_add_device_nand(struct atmel_nand_data *data);
> -
> - /* I2C*/
> -extern void __init at91_add_device_i2c(struct i2c_board_info *devices, int nr_devices);
> -
> - /* SPI */
> -extern void __init at91_add_device_spi(struct spi_board_info *devices, int nr_devices);
> -
> - /* Serial */
> -#define ATMEL_UART_CTS	0x01
> -#define ATMEL_UART_RTS	0x02
> -#define ATMEL_UART_DSR	0x04
> -#define ATMEL_UART_DTR	0x08
> -#define ATMEL_UART_DCD	0x10
> -#define ATMEL_UART_RI	0x20
> -
> -extern void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins);
> -
> -extern struct platform_device *atmel_default_console_device;
> -
> -extern void __init at91_add_device_serial(void);
> -
> -/*
> - * PWM
> - */
> -#define AT91_PWM0	0
> -#define AT91_PWM1	1
> -#define AT91_PWM2	2
> -#define AT91_PWM3	3
> -
> -extern void __init at91_add_device_pwm(u32 mask);
> -
> -/*
> - * SSC -- accessed through ssc_request(id).  Drivers don't bind to SSC
> - * platform devices.  Their SSC ID is part of their configuration data,
> - * along with information about which SSC signals they should use.
> - */
> -#define ATMEL_SSC_TK	0x01
> -#define ATMEL_SSC_TF	0x02
> -#define ATMEL_SSC_TD	0x04
> -#define ATMEL_SSC_TX	(ATMEL_SSC_TK | ATMEL_SSC_TF | ATMEL_SSC_TD)
> -
> -#define ATMEL_SSC_RK	0x10
> -#define ATMEL_SSC_RF	0x20
> -#define ATMEL_SSC_RD	0x40
> -#define ATMEL_SSC_RX	(ATMEL_SSC_RK | ATMEL_SSC_RF | ATMEL_SSC_RD)
> -
> -extern void __init at91_add_device_ssc(unsigned id, unsigned pins);
> -
> - /* LCD Controller */
> -struct atmel_lcdfb_pdata;
> -extern void __init at91_add_device_lcdc(struct atmel_lcdfb_pdata *data);
> -
> - /* AC97 */
> -extern void __init at91_add_device_ac97(struct ac97c_platform_data *data);
> -
> - /* ISI */
> -struct isi_platform_data;
> -extern void __init at91_add_device_isi(struct isi_platform_data *data,
> -		bool use_pck_as_mck);
> -
> -/* CAN */
> -extern void __init at91_add_device_can(struct at91_can_data *data);
> -
> - /* LEDs */
> -extern void __init at91_gpio_leds(struct gpio_led *leds, int nr);
> -
> -#endif
> diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
> index eb81940f9848..0fff39e85f76 100644
> --- a/arch/arm/mach-at91/generic.h
> +++ b/arch/arm/mach-at91/generic.h
> @@ -21,53 +21,17 @@ extern void __init at91_init_sram(int bank, unsigned long base,
>  				  unsigned int length);
>  
>   /* Processors */
> -extern void __init at91rm9200_set_type(int type);
> -extern void __init at91_initialize(unsigned long main_clock);
>  extern void __init at91rm9200_dt_initialize(void);
>  extern void __init at91_dt_initialize(void);
>  
>   /* Interrupts */
> -extern void __init at91_init_irq_default(void);
> -extern void __init at91_init_interrupts(unsigned int priority[]);
>  extern void __init at91_sysirq_mask_rtc(u32 rtc_base);
>  extern void __init at91_sysirq_mask_rtt(u32 rtt_base);
>  
> - /* Devices */
> -extern void __init at91_register_devices(void);
> -
>   /* Timer */
> -extern void __init at91_init_time(void);
> -extern void at91rm9200_ioremap_st(u32 addr);
>  extern void at91rm9200_timer_init(void);
> -extern void at91sam926x_ioremap_pit(u32 addr);
> -extern void at91sam926x_pit_init(int irq);
> -
> - /* Power Management */
> -extern void at91_irq_suspend(void);
> -extern void at91_irq_resume(void);
>  
>  /* idle */
>  extern void at91sam9_idle(void);
>  
> -/* Matrix */
> -extern void at91_ioremap_matrix(u32 base_addr);
> -
> -/* Ram Controler */
> -extern void at91_ioremap_ramc(int id, u32 addr, u32 size);
> -
> - /* GPIO */
> -#define AT91RM9200_PQFP		3	/* AT91RM9200 PQFP package has 3 banks */
> -#define AT91RM9200_BGA		4	/* AT91RM9200 BGA package has 4 banks */
> -
> -struct at91_gpio_bank {
> -	unsigned short id;		/* peripheral ID */
> -	unsigned long regbase;		/* offset from system peripheral base */
> -};
> -extern void __init at91_gpio_init(struct at91_gpio_bank *, int nr_banks);
> -extern void __init at91_gpio_irq_setup(void);
> -extern int  __init at91_gpio_of_irq_setup(struct device_node *node,
> -					  struct device_node *parent);
> -
> -extern u32 at91_get_extern_irq(void);
> -
>  #endif /* _AT91_GENERIC_H */
> diff --git a/arch/arm/mach-at91/gpio.c b/arch/arm/mach-at91/gpio.c
> deleted file mode 100644
> index d3f05aaad8ba..000000000000
> --- a/arch/arm/mach-at91/gpio.c
> +++ /dev/null
> @@ -1,982 +0,0 @@
> -/*
> - * linux/arch/arm/mach-at91/gpio.c
> - *
> - * Copyright (C) 2005 HP Labs
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - */
> -
> -#include <linux/clk.h>
> -#include <linux/errno.h>
> -#include <linux/device.h>
> -#include <linux/gpio.h>
> -#include <linux/interrupt.h>
> -#include <linux/irq.h>
> -#include <linux/debugfs.h>
> -#include <linux/seq_file.h>
> -#include <linux/kernel.h>
> -#include <linux/list.h>
> -#include <linux/module.h>
> -#include <linux/io.h>
> -#include <linux/irqdomain.h>
> -#include <linux/irqchip/chained_irq.h>
> -#include <linux/of_address.h>
> -
> -#include <mach/hardware.h>
> -#include <mach/at91_pio.h>
> -
> -#include "generic.h"
> -#include "gpio.h"
> -
> -#define MAX_NB_GPIO_PER_BANK	32
> -
> -struct at91_gpio_chip {
> -	struct gpio_chip	chip;
> -	struct at91_gpio_chip	*next;		/* Bank sharing same clock */
> -	int			pioc_hwirq;	/* PIO bank interrupt identifier on AIC */
> -	int			pioc_virq;	/* PIO bank Linux virtual interrupt */
> -	int			pioc_idx;	/* PIO bank index */
> -	void __iomem		*regbase;	/* PIO bank virtual address */
> -	struct clk		*clock;		/* associated clock */
> -	struct irq_domain	*domain;	/* associated irq domain */
> -};
> -
> -#define to_at91_gpio_chip(c) container_of(c, struct at91_gpio_chip, chip)
> -
> -static int at91_gpiolib_request(struct gpio_chip *chip, unsigned offset);
> -static void at91_gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip);
> -static void at91_gpiolib_set(struct gpio_chip *chip, unsigned offset, int val);
> -static int at91_gpiolib_get(struct gpio_chip *chip, unsigned offset);
> -static int at91_gpiolib_get_direction(struct gpio_chip *chip, unsigned offset);
> -static int at91_gpiolib_direction_output(struct gpio_chip *chip,
> -					 unsigned offset, int val);
> -static int at91_gpiolib_direction_input(struct gpio_chip *chip,
> -					unsigned offset);
> -static int at91_gpiolib_to_irq(struct gpio_chip *chip, unsigned offset);
> -
> -#define AT91_GPIO_CHIP(name)						\
> -	{								\
> -		.chip = {						\
> -			.label		  = name,			\
> -			.request	  = at91_gpiolib_request,	\
> -			.get_direction    = at91_gpiolib_get_direction, \
> -			.direction_input  = at91_gpiolib_direction_input, \
> -			.direction_output = at91_gpiolib_direction_output, \
> -			.get		  = at91_gpiolib_get,		\
> -			.set		  = at91_gpiolib_set,		\
> -			.dbg_show	  = at91_gpiolib_dbg_show,	\
> -			.to_irq		  = at91_gpiolib_to_irq,	\
> -			.ngpio		  = MAX_NB_GPIO_PER_BANK,	\
> -		},							\
> -	}
> -
> -static struct at91_gpio_chip gpio_chip[] = {
> -	AT91_GPIO_CHIP("pioA"),
> -	AT91_GPIO_CHIP("pioB"),
> -	AT91_GPIO_CHIP("pioC"),
> -	AT91_GPIO_CHIP("pioD"),
> -	AT91_GPIO_CHIP("pioE"),
> -};
> -
> -static int gpio_banks;
> -static unsigned long at91_gpio_caps;
> -
> -/* All PIO controllers support PIO3 features */
> -#define AT91_GPIO_CAP_PIO3	(1 <<  0)
> -
> -#define has_pio3()	(at91_gpio_caps & AT91_GPIO_CAP_PIO3)
> -
> -/*--------------------------------------------------------------------------*/
> -
> -static inline void __iomem *pin_to_controller(unsigned pin)
> -{
> -	pin /= MAX_NB_GPIO_PER_BANK;
> -	if (likely(pin < gpio_banks))
> -		return gpio_chip[pin].regbase;
> -
> -	return NULL;
> -}
> -
> -static inline unsigned pin_to_mask(unsigned pin)
> -{
> -	return 1 << (pin % MAX_NB_GPIO_PER_BANK);
> -}
> -
> -
> -static char peripheral_function(void __iomem *pio, unsigned mask)
> -{
> -	char	ret = 'X';
> -	u8	select;
> -
> -	if (pio) {
> -		if (has_pio3()) {
> -			select = !!(__raw_readl(pio + PIO_ABCDSR1) & mask);
> -			select |= (!!(__raw_readl(pio + PIO_ABCDSR2) & mask) << 1);
> -			ret = 'A' + select;
> -		} else {
> -			ret = __raw_readl(pio + PIO_ABSR) & mask ?
> -							'B' : 'A';
> -		}
> -	}
> -
> -	return ret;
> -}
> -
> -/*--------------------------------------------------------------------------*/
> -
> -/* Not all hardware capabilities are exposed through these calls; they
> - * only encapsulate the most common features and modes.  (So if you
> - * want to change signals in groups, do it directly.)
> - *
> - * Bootloaders will usually handle some of the pin multiplexing setup.
> - * The intent is certainly that by the time Linux is fully booted, all
> - * pins should have been fully initialized.  These setup calls should
> - * only be used by board setup routines, or possibly in driver probe().
> - *
> - * For bootloaders doing all that setup, these calls could be inlined
> - * as NOPs so Linux won't duplicate any setup code
> - */
> -
> -
> -/*
> - * mux the pin to the "GPIO" peripheral role.
> - */
> -int __init_or_module at91_set_GPIO_periph(unsigned pin, int use_pullup)
> -{
> -	void __iomem	*pio = pin_to_controller(pin);
> -	unsigned	mask = pin_to_mask(pin);
> -
> -	if (!pio)
> -		return -EINVAL;
> -	__raw_writel(mask, pio + PIO_IDR);
> -	__raw_writel(mask, pio + (use_pullup ? PIO_PUER : PIO_PUDR));
> -	__raw_writel(mask, pio + PIO_PER);
> -	return 0;
> -}
> -EXPORT_SYMBOL(at91_set_GPIO_periph);
> -
> -
> -/*
> - * mux the pin to the "A" internal peripheral role.
> - */
> -int __init_or_module at91_set_A_periph(unsigned pin, int use_pullup)
> -{
> -	void __iomem	*pio = pin_to_controller(pin);
> -	unsigned	mask = pin_to_mask(pin);
> -
> -	if (!pio)
> -		return -EINVAL;
> -
> -	__raw_writel(mask, pio + PIO_IDR);
> -	__raw_writel(mask, pio + (use_pullup ? PIO_PUER : PIO_PUDR));
> -	if (has_pio3()) {
> -		__raw_writel(__raw_readl(pio + PIO_ABCDSR1) & ~mask,
> -							pio + PIO_ABCDSR1);
> -		__raw_writel(__raw_readl(pio + PIO_ABCDSR2) & ~mask,
> -							pio + PIO_ABCDSR2);
> -	} else {
> -		__raw_writel(mask, pio + PIO_ASR);
> -	}
> -	__raw_writel(mask, pio + PIO_PDR);
> -	return 0;
> -}
> -EXPORT_SYMBOL(at91_set_A_periph);
> -
> -
> -/*
> - * mux the pin to the "B" internal peripheral role.
> - */
> -int __init_or_module at91_set_B_periph(unsigned pin, int use_pullup)
> -{
> -	void __iomem	*pio = pin_to_controller(pin);
> -	unsigned	mask = pin_to_mask(pin);
> -
> -	if (!pio)
> -		return -EINVAL;
> -
> -	__raw_writel(mask, pio + PIO_IDR);
> -	__raw_writel(mask, pio + (use_pullup ? PIO_PUER : PIO_PUDR));
> -	if (has_pio3()) {
> -		__raw_writel(__raw_readl(pio + PIO_ABCDSR1) | mask,
> -							pio + PIO_ABCDSR1);
> -		__raw_writel(__raw_readl(pio + PIO_ABCDSR2) & ~mask,
> -							pio + PIO_ABCDSR2);
> -	} else {
> -		__raw_writel(mask, pio + PIO_BSR);
> -	}
> -	__raw_writel(mask, pio + PIO_PDR);
> -	return 0;
> -}
> -EXPORT_SYMBOL(at91_set_B_periph);
> -
> -
> -/*
> - * mux the pin to the "C" internal peripheral role.
> - */
> -int __init_or_module at91_set_C_periph(unsigned pin, int use_pullup)
> -{
> -	void __iomem	*pio = pin_to_controller(pin);
> -	unsigned	mask = pin_to_mask(pin);
> -
> -	if (!pio || !has_pio3())
> -		return -EINVAL;
> -
> -	__raw_writel(mask, pio + PIO_IDR);
> -	__raw_writel(mask, pio + (use_pullup ? PIO_PUER : PIO_PUDR));
> -	__raw_writel(__raw_readl(pio + PIO_ABCDSR1) & ~mask, pio + PIO_ABCDSR1);
> -	__raw_writel(__raw_readl(pio + PIO_ABCDSR2) | mask, pio + PIO_ABCDSR2);
> -	__raw_writel(mask, pio + PIO_PDR);
> -	return 0;
> -}
> -EXPORT_SYMBOL(at91_set_C_periph);
> -
> -
> -/*
> - * mux the pin to the "D" internal peripheral role.
> - */
> -int __init_or_module at91_set_D_periph(unsigned pin, int use_pullup)
> -{
> -	void __iomem	*pio = pin_to_controller(pin);
> -	unsigned	mask = pin_to_mask(pin);
> -
> -	if (!pio || !has_pio3())
> -		return -EINVAL;
> -
> -	__raw_writel(mask, pio + PIO_IDR);
> -	__raw_writel(mask, pio + (use_pullup ? PIO_PUER : PIO_PUDR));
> -	__raw_writel(__raw_readl(pio + PIO_ABCDSR1) | mask, pio + PIO_ABCDSR1);
> -	__raw_writel(__raw_readl(pio + PIO_ABCDSR2) | mask, pio + PIO_ABCDSR2);
> -	__raw_writel(mask, pio + PIO_PDR);
> -	return 0;
> -}
> -EXPORT_SYMBOL(at91_set_D_periph);
> -
> -
> -/*
> - * mux the pin to the gpio controller (instead of "A", "B", "C"
> - * or "D" peripheral), and configure it for an input.
> - */
> -int __init_or_module at91_set_gpio_input(unsigned pin, int use_pullup)
> -{
> -	void __iomem	*pio = pin_to_controller(pin);
> -	unsigned	mask = pin_to_mask(pin);
> -
> -	if (!pio)
> -		return -EINVAL;
> -
> -	__raw_writel(mask, pio + PIO_IDR);
> -	__raw_writel(mask, pio + (use_pullup ? PIO_PUER : PIO_PUDR));
> -	__raw_writel(mask, pio + PIO_ODR);
> -	__raw_writel(mask, pio + PIO_PER);
> -	return 0;
> -}
> -EXPORT_SYMBOL(at91_set_gpio_input);
> -
> -
> -/*
> - * mux the pin to the gpio controller (instead of "A", "B", "C"
> - * or "D" peripheral), and configure it for an output.
> - */
> -int __init_or_module at91_set_gpio_output(unsigned pin, int value)
> -{
> -	void __iomem	*pio = pin_to_controller(pin);
> -	unsigned	mask = pin_to_mask(pin);
> -
> -	if (!pio)
> -		return -EINVAL;
> -
> -	__raw_writel(mask, pio + PIO_IDR);
> -	__raw_writel(mask, pio + PIO_PUDR);
> -	__raw_writel(mask, pio + (value ? PIO_SODR : PIO_CODR));
> -	__raw_writel(mask, pio + PIO_OER);
> -	__raw_writel(mask, pio + PIO_PER);
> -	return 0;
> -}
> -EXPORT_SYMBOL(at91_set_gpio_output);
> -
> -
> -/*
> - * enable/disable the glitch filter; mostly used with IRQ handling.
> - */
> -int __init_or_module at91_set_deglitch(unsigned pin, int is_on)
> -{
> -	void __iomem	*pio = pin_to_controller(pin);
> -	unsigned	mask = pin_to_mask(pin);
> -
> -	if (!pio)
> -		return -EINVAL;
> -
> -	if (has_pio3() && is_on)
> -		__raw_writel(mask, pio + PIO_IFSCDR);
> -	__raw_writel(mask, pio + (is_on ? PIO_IFER : PIO_IFDR));
> -	return 0;
> -}
> -EXPORT_SYMBOL(at91_set_deglitch);
> -
> -/*
> - * enable/disable the debounce filter;
> - */
> -int __init_or_module at91_set_debounce(unsigned pin, int is_on, int div)
> -{
> -	void __iomem	*pio = pin_to_controller(pin);
> -	unsigned	mask = pin_to_mask(pin);
> -
> -	if (!pio || !has_pio3())
> -		return -EINVAL;
> -
> -	if (is_on) {
> -		__raw_writel(mask, pio + PIO_IFSCER);
> -		__raw_writel(div & PIO_SCDR_DIV, pio + PIO_SCDR);
> -		__raw_writel(mask, pio + PIO_IFER);
> -	} else {
> -		__raw_writel(mask, pio + PIO_IFDR);
> -	}
> -	return 0;
> -}
> -EXPORT_SYMBOL(at91_set_debounce);
> -
> -/*
> - * enable/disable the multi-driver; This is only valid for output and
> - * allows the output pin to run as an open collector output.
> - */
> -int __init_or_module at91_set_multi_drive(unsigned pin, int is_on)
> -{
> -	void __iomem	*pio = pin_to_controller(pin);
> -	unsigned	mask = pin_to_mask(pin);
> -
> -	if (!pio)
> -		return -EINVAL;
> -
> -	__raw_writel(mask, pio + (is_on ? PIO_MDER : PIO_MDDR));
> -	return 0;
> -}
> -EXPORT_SYMBOL(at91_set_multi_drive);
> -
> -/*
> - * enable/disable the pull-down.
> - * If pull-up already enabled while calling the function, we disable it.
> - */
> -int __init_or_module at91_set_pulldown(unsigned pin, int is_on)
> -{
> -	void __iomem	*pio = pin_to_controller(pin);
> -	unsigned	mask = pin_to_mask(pin);
> -
> -	if (!pio || !has_pio3())
> -		return -EINVAL;
> -
> -	/* Disable pull-up anyway */
> -	__raw_writel(mask, pio + PIO_PUDR);
> -	__raw_writel(mask, pio + (is_on ? PIO_PPDER : PIO_PPDDR));
> -	return 0;
> -}
> -EXPORT_SYMBOL(at91_set_pulldown);
> -
> -/*
> - * disable Schmitt trigger
> - */
> -int __init_or_module at91_disable_schmitt_trig(unsigned pin)
> -{
> -	void __iomem	*pio = pin_to_controller(pin);
> -	unsigned	mask = pin_to_mask(pin);
> -
> -	if (!pio || !has_pio3())
> -		return -EINVAL;
> -
> -	__raw_writel(__raw_readl(pio + PIO_SCHMITT) | mask, pio + PIO_SCHMITT);
> -	return 0;
> -}
> -EXPORT_SYMBOL(at91_disable_schmitt_trig);
> -
> -/*
> - * assuming the pin is muxed as a gpio output, set its value.
> - */
> -int at91_set_gpio_value(unsigned pin, int value)
> -{
> -	void __iomem	*pio = pin_to_controller(pin);
> -	unsigned	mask = pin_to_mask(pin);
> -
> -	if (!pio)
> -		return -EINVAL;
> -	__raw_writel(mask, pio + (value ? PIO_SODR : PIO_CODR));
> -	return 0;
> -}
> -EXPORT_SYMBOL(at91_set_gpio_value);
> -
> -
> -/*
> - * read the pin's value (works even if it's not muxed as a gpio).
> - */
> -int at91_get_gpio_value(unsigned pin)
> -{
> -	void __iomem	*pio = pin_to_controller(pin);
> -	unsigned	mask = pin_to_mask(pin);
> -	u32		pdsr;
> -
> -	if (!pio)
> -		return -EINVAL;
> -	pdsr = __raw_readl(pio + PIO_PDSR);
> -	return (pdsr & mask) != 0;
> -}
> -EXPORT_SYMBOL(at91_get_gpio_value);
> -
> -/*--------------------------------------------------------------------------*/
> -
> -#ifdef CONFIG_PM
> -
> -static u32 wakeups[MAX_GPIO_BANKS];
> -static u32 backups[MAX_GPIO_BANKS];
> -
> -static int gpio_irq_set_wake(struct irq_data *d, unsigned state)
> -{
> -	struct at91_gpio_chip *at91_gpio = irq_data_get_irq_chip_data(d);
> -	unsigned	mask = 1 << d->hwirq;
> -	unsigned	bank = at91_gpio->pioc_idx;
> -
> -	if (unlikely(bank >= MAX_GPIO_BANKS))
> -		return -EINVAL;
> -
> -	if (state)
> -		wakeups[bank] |= mask;
> -	else
> -		wakeups[bank] &= ~mask;
> -
> -	irq_set_irq_wake(at91_gpio->pioc_virq, state);
> -
> -	return 0;
> -}
> -
> -void at91_gpio_suspend(void)
> -{
> -	int i;
> -
> -	for (i = 0; i < gpio_banks; i++) {
> -		void __iomem	*pio = gpio_chip[i].regbase;
> -
> -		backups[i] = __raw_readl(pio + PIO_IMR);
> -		__raw_writel(backups[i], pio + PIO_IDR);
> -		__raw_writel(wakeups[i], pio + PIO_IER);
> -
> -		if (!wakeups[i]) {
> -			clk_unprepare(gpio_chip[i].clock);
> -			clk_disable(gpio_chip[i].clock);
> -		} else {
> -#ifdef CONFIG_PM_DEBUG
> -			printk(KERN_DEBUG "GPIO-%c may wake for %08x\n", 'A'+i, wakeups[i]);
> -#endif
> -		}
> -	}
> -}
> -
> -void at91_gpio_resume(void)
> -{
> -	int i;
> -
> -	for (i = 0; i < gpio_banks; i++) {
> -		void __iomem	*pio = gpio_chip[i].regbase;
> -
> -		if (!wakeups[i]) {
> -			if (clk_prepare(gpio_chip[i].clock) == 0)
> -				clk_enable(gpio_chip[i].clock);
> -		}
> -
> -		__raw_writel(wakeups[i], pio + PIO_IDR);
> -		__raw_writel(backups[i], pio + PIO_IER);
> -	}
> -}
> -
> -#else
> -#define gpio_irq_set_wake	NULL
> -#endif
> -
> -
> -/* Several AIC controller irqs are dispatched through this GPIO handler.
> - * To use any AT91_PIN_* as an externally triggered IRQ, first call
> - * at91_set_gpio_input() then maybe enable its glitch filter.
> - * Then just request_irq() with the pin ID; it works like any ARM IRQ
> - * handler.
> - * First implementation always triggers on rising and falling edges
> - * whereas the newer PIO3 can be additionally configured to trigger on
> - * level, edge with any polarity.
> - *
> - * Alternatively, certain pins may be used directly as IRQ0..IRQ6 after
> - * configuring them with at91_set_a_periph() or at91_set_b_periph().
> - * IRQ0..IRQ6 should be configurable, e.g. level vs edge triggering.
> - */
> -
> -static void gpio_irq_mask(struct irq_data *d)
> -{
> -	struct at91_gpio_chip *at91_gpio = irq_data_get_irq_chip_data(d);
> -	void __iomem	*pio = at91_gpio->regbase;
> -	unsigned	mask = 1 << d->hwirq;
> -
> -	if (pio)
> -		__raw_writel(mask, pio + PIO_IDR);
> -}
> -
> -static void gpio_irq_unmask(struct irq_data *d)
> -{
> -	struct at91_gpio_chip *at91_gpio = irq_data_get_irq_chip_data(d);
> -	void __iomem	*pio = at91_gpio->regbase;
> -	unsigned	mask = 1 << d->hwirq;
> -
> -	if (pio)
> -		__raw_writel(mask, pio + PIO_IER);
> -}
> -
> -static int gpio_irq_type(struct irq_data *d, unsigned type)
> -{
> -	switch (type) {
> -	case IRQ_TYPE_NONE:
> -	case IRQ_TYPE_EDGE_BOTH:
> -		return 0;
> -	default:
> -		return -EINVAL;
> -	}
> -}
> -
> -/* Alternate irq type for PIO3 support */
> -static int alt_gpio_irq_type(struct irq_data *d, unsigned type)
> -{
> -	struct at91_gpio_chip *at91_gpio = irq_data_get_irq_chip_data(d);
> -	void __iomem	*pio = at91_gpio->regbase;
> -	unsigned	mask = 1 << d->hwirq;
> -
> -	switch (type) {
> -	case IRQ_TYPE_EDGE_RISING:
> -		__raw_writel(mask, pio + PIO_ESR);
> -		__raw_writel(mask, pio + PIO_REHLSR);
> -		break;
> -	case IRQ_TYPE_EDGE_FALLING:
> -		__raw_writel(mask, pio + PIO_ESR);
> -		__raw_writel(mask, pio + PIO_FELLSR);
> -		break;
> -	case IRQ_TYPE_LEVEL_LOW:
> -		__raw_writel(mask, pio + PIO_LSR);
> -		__raw_writel(mask, pio + PIO_FELLSR);
> -		break;
> -	case IRQ_TYPE_LEVEL_HIGH:
> -		__raw_writel(mask, pio + PIO_LSR);
> -		__raw_writel(mask, pio + PIO_REHLSR);
> -		break;
> -	case IRQ_TYPE_EDGE_BOTH:
> -		/*
> -		 * disable additional interrupt modes:
> -		 * fall back to default behavior
> -		 */
> -		__raw_writel(mask, pio + PIO_AIMDR);
> -		return 0;
> -	case IRQ_TYPE_NONE:
> -	default:
> -		pr_warn("AT91: No type for irq %d\n", gpio_to_irq(d->irq));
> -		return -EINVAL;
> -	}
> -
> -	/* enable additional interrupt modes */
> -	__raw_writel(mask, pio + PIO_AIMER);
> -
> -	return 0;
> -}
> -
> -static struct irq_chip gpio_irqchip = {
> -	.name		= "GPIO",
> -	.irq_disable	= gpio_irq_mask,
> -	.irq_mask	= gpio_irq_mask,
> -	.irq_unmask	= gpio_irq_unmask,
> -	/* .irq_set_type is set dynamically */
> -	.irq_set_wake	= gpio_irq_set_wake,
> -};
> -
> -static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
> -{
> -	struct irq_chip *chip = irq_desc_get_chip(desc);
> -	struct irq_data *idata = irq_desc_get_irq_data(desc);
> -	struct at91_gpio_chip *at91_gpio = irq_data_get_irq_chip_data(idata);
> -	void __iomem	*pio = at91_gpio->regbase;
> -	unsigned long	isr;
> -	int		n;
> -
> -	chained_irq_enter(chip, desc);
> -	for (;;) {
> -		/* Reading ISR acks pending (edge triggered) GPIO interrupts.
> -		 * When there none are pending, we're finished unless we need
> -		 * to process multiple banks (like ID_PIOCDE on sam9263).
> -		 */
> -		isr = __raw_readl(pio + PIO_ISR) & __raw_readl(pio + PIO_IMR);
> -		if (!isr) {
> -			if (!at91_gpio->next)
> -				break;
> -			at91_gpio = at91_gpio->next;
> -			pio = at91_gpio->regbase;
> -			continue;
> -		}
> -
> -		n = find_first_bit(&isr, BITS_PER_LONG);
> -		while (n < BITS_PER_LONG) {
> -			generic_handle_irq(irq_find_mapping(at91_gpio->domain, n));
> -			n = find_next_bit(&isr, BITS_PER_LONG, n + 1);
> -		}
> -	}
> -	chained_irq_exit(chip, desc);
> -	/* now it may re-trigger */
> -}
> -
> -/*--------------------------------------------------------------------------*/
> -
> -#ifdef CONFIG_DEBUG_FS
> -
> -static void gpio_printf(struct seq_file *s, void __iomem *pio, unsigned mask)
> -{
> -	char	*trigger = NULL;
> -	char	*polarity = NULL;
> -
> -	if (__raw_readl(pio + PIO_IMR) & mask) {
> -		if (!has_pio3() || !(__raw_readl(pio + PIO_AIMMR) & mask )) {
> -			trigger = "edge";
> -			polarity = "both";
> -		} else {
> -			if (__raw_readl(pio + PIO_ELSR) & mask) {
> -				trigger = "level";
> -				polarity = __raw_readl(pio + PIO_FRLHSR) & mask ?
> -					"high" : "low";
> -			} else {
> -				trigger = "edge";
> -				polarity = __raw_readl(pio + PIO_FRLHSR) & mask ?
> -						"rising" : "falling";
> -			}
> -		}
> -		seq_printf(s, "IRQ:%s-%s\t", trigger, polarity);
> -	} else {
> -		seq_printf(s, "GPIO:%s\t\t",
> -				__raw_readl(pio + PIO_PDSR) & mask ? "1" : "0");
> -	}
> -}
> -
> -static int at91_gpio_show(struct seq_file *s, void *unused)
> -{
> -	int bank, j;
> -
> -	/* print heading */
> -	seq_printf(s, "Pin\t");
> -	for (bank = 0; bank < gpio_banks; bank++) {
> -		seq_printf(s, "PIO%c\t\t", 'A' + bank);
> -	};
> -	seq_printf(s, "\n\n");
> -
> -	/* print pin status */
> -	for (j = 0; j < 32; j++) {
> -		seq_printf(s, "%i:\t", j);
> -
> -		for (bank = 0; bank < gpio_banks; bank++) {
> -			unsigned	pin  = (32 * bank) + j;
> -			void __iomem	*pio = pin_to_controller(pin);
> -			unsigned	mask = pin_to_mask(pin);
> -
> -			if (__raw_readl(pio + PIO_PSR) & mask)
> -				gpio_printf(s, pio, mask);
> -			else
> -				seq_printf(s, "%c\t\t",
> -						peripheral_function(pio, mask));
> -		}
> -
> -		seq_printf(s, "\n");
> -	}
> -
> -	return 0;
> -}
> -
> -static int at91_gpio_open(struct inode *inode, struct file *file)
> -{
> -	return single_open(file, at91_gpio_show, NULL);
> -}
> -
> -static const struct file_operations at91_gpio_operations = {
> -	.open		= at91_gpio_open,
> -	.read		= seq_read,
> -	.llseek		= seq_lseek,
> -	.release	= single_release,
> -};
> -
> -static int __init at91_gpio_debugfs_init(void)
> -{
> -	/* /sys/kernel/debug/at91_gpio */
> -	(void) debugfs_create_file("at91_gpio", S_IFREG | S_IRUGO, NULL, NULL, &at91_gpio_operations);
> -	return 0;
> -}
> -postcore_initcall(at91_gpio_debugfs_init);
> -
> -#endif
> -
> -/*--------------------------------------------------------------------------*/
> -
> -/*
> - * This lock class tells lockdep that GPIO irqs are in a different
> - * category than their parents, so it won't report false recursion.
> - */
> -static struct lock_class_key gpio_lock_class;
> -
> -/*
> - * irqdomain initialization: pile up irqdomains on top of AIC range
> - */
> -static void __init at91_gpio_irqdomain(struct at91_gpio_chip *at91_gpio)
> -{
> -	int irq_base;
> -
> -	irq_base = irq_alloc_descs(-1, 0, at91_gpio->chip.ngpio, 0);
> -	if (irq_base < 0)
> -		panic("at91_gpio.%d: error %d: couldn't allocate IRQ numbers.\n",
> -			at91_gpio->pioc_idx, irq_base);
> -	at91_gpio->domain = irq_domain_add_legacy(NULL, at91_gpio->chip.ngpio,
> -						  irq_base, 0,
> -						  &irq_domain_simple_ops, NULL);
> -	if (!at91_gpio->domain)
> -		panic("at91_gpio.%d: couldn't allocate irq domain.\n",
> -			at91_gpio->pioc_idx);
> -}
> -
> -/*
> - * Called from the processor-specific init to enable GPIO interrupt support.
> - */
> -void __init at91_gpio_irq_setup(void)
> -{
> -	unsigned		pioc;
> -	int			gpio_irqnbr = 0;
> -	struct at91_gpio_chip	*this, *prev;
> -
> -	/* Setup proper .irq_set_type function */
> -	if (has_pio3())
> -		gpio_irqchip.irq_set_type = alt_gpio_irq_type;
> -	else
> -		gpio_irqchip.irq_set_type = gpio_irq_type;
> -
> -	for (pioc = 0, this = gpio_chip, prev = NULL;
> -			pioc++ < gpio_banks;
> -			prev = this, this++) {
> -		int offset;
> -
> -		__raw_writel(~0, this->regbase + PIO_IDR);
> -
> -		/* setup irq domain for this GPIO controller */
> -		at91_gpio_irqdomain(this);
> -
> -		for (offset = 0; offset < this->chip.ngpio; offset++) {
> -			unsigned int virq = irq_find_mapping(this->domain, offset);
> -			irq_set_lockdep_class(virq, &gpio_lock_class);
> -
> -			/*
> -			 * Can use the "simple" and not "edge" handler since it's
> -			 * shorter, and the AIC handles interrupts sanely.
> -			 */
> -			irq_set_chip_and_handler(virq, &gpio_irqchip,
> -						 handle_simple_irq);
> -			set_irq_flags(virq, IRQF_VALID);
> -			irq_set_chip_data(virq, this);
> -
> -			gpio_irqnbr++;
> -		}
> -
> -		/* The toplevel handler handles one bank of GPIOs, except
> -		 * on some SoC it can handles up to three...
> -		 * We only set up the handler for the first of the list.
> -		 */
> -		if (prev && prev->next == this)
> -			continue;
> -
> -		this->pioc_virq = irq_create_mapping(NULL, this->pioc_hwirq);
> -		irq_set_chip_data(this->pioc_virq, this);
> -		irq_set_chained_handler(this->pioc_virq, gpio_irq_handler);
> -	}
> -	pr_info("AT91: %d gpio irqs in %d banks\n", gpio_irqnbr, gpio_banks);
> -}
> -
> -/* gpiolib support */
> -static int at91_gpiolib_request(struct gpio_chip *chip, unsigned offset)
> -{
> -	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
> -	void __iomem *pio = at91_gpio->regbase;
> -	unsigned mask = 1 << offset;
> -
> -	__raw_writel(mask, pio + PIO_PER);
> -	return 0;
> -}
> -
> -static int at91_gpiolib_get_direction(struct gpio_chip *chip, unsigned offset)
> -{
> -	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
> -	void __iomem *pio = at91_gpio->regbase;
> -	unsigned mask = 1 << offset;
> -	u32 osr;
> -
> -	osr = __raw_readl(pio + PIO_OSR);
> -	return !(osr & mask);
> -}
> -
> -static int at91_gpiolib_direction_input(struct gpio_chip *chip,
> -					unsigned offset)
> -{
> -	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
> -	void __iomem *pio = at91_gpio->regbase;
> -	unsigned mask = 1 << offset;
> -
> -	__raw_writel(mask, pio + PIO_ODR);
> -	return 0;
> -}
> -
> -static int at91_gpiolib_direction_output(struct gpio_chip *chip,
> -					 unsigned offset, int val)
> -{
> -	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
> -	void __iomem *pio = at91_gpio->regbase;
> -	unsigned mask = 1 << offset;
> -
> -	__raw_writel(mask, pio + (val ? PIO_SODR : PIO_CODR));
> -	__raw_writel(mask, pio + PIO_OER);
> -	return 0;
> -}
> -
> -static int at91_gpiolib_get(struct gpio_chip *chip, unsigned offset)
> -{
> -	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
> -	void __iomem *pio = at91_gpio->regbase;
> -	unsigned mask = 1 << offset;
> -	u32 pdsr;
> -
> -	pdsr = __raw_readl(pio + PIO_PDSR);
> -	return (pdsr & mask) != 0;
> -}
> -
> -static void at91_gpiolib_set(struct gpio_chip *chip, unsigned offset, int val)
> -{
> -	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
> -	void __iomem *pio = at91_gpio->regbase;
> -	unsigned mask = 1 << offset;
> -
> -	__raw_writel(mask, pio + (val ? PIO_SODR : PIO_CODR));
> -}
> -
> -static void at91_gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
> -{
> -	int i;
> -
> -	for (i = 0; i < chip->ngpio; i++) {
> -		unsigned pin = chip->base + i;
> -		void __iomem *pio = pin_to_controller(pin);
> -		unsigned mask = pin_to_mask(pin);
> -		const char *gpio_label;
> -
> -		gpio_label = gpiochip_is_requested(chip, i);
> -		if (gpio_label) {
> -			seq_printf(s, "[%s] GPIO%s%d: ",
> -				   gpio_label, chip->label, i);
> -			if (__raw_readl(pio + PIO_PSR) & mask)
> -				seq_printf(s, "[gpio] %s\n",
> -					   at91_get_gpio_value(pin) ?
> -					   "set" : "clear");
> -			else
> -				seq_printf(s, "[periph %c]\n",
> -					   peripheral_function(pio, mask));
> -		}
> -	}
> -}
> -
> -static int at91_gpiolib_to_irq(struct gpio_chip *chip, unsigned offset)
> -{
> -	struct at91_gpio_chip *at91_gpio = to_at91_gpio_chip(chip);
> -	int virq;
> -
> -	if (offset < chip->ngpio)
> -		virq = irq_create_mapping(at91_gpio->domain, offset);
> -	else
> -		virq = -ENXIO;
> -
> -	dev_dbg(chip->dev, "%s: request IRQ for GPIO %d, return %d\n",
> -				chip->label, offset + chip->base, virq);
> -	return virq;
> -}
> -
> -static int __init at91_gpio_setup_clk(int idx)
> -{
> -	struct at91_gpio_chip *at91_gpio = &gpio_chip[idx];
> -
> -	/* retreive PIO controller's clock */
> -	at91_gpio->clock = clk_get_sys(NULL, at91_gpio->chip.label);
> -	if (IS_ERR(at91_gpio->clock)) {
> -		pr_err("at91_gpio.%d, failed to get clock, ignoring.\n", idx);
> -		goto err;
> -	}
> -
> -	if (clk_prepare(at91_gpio->clock))
> -		goto clk_prep_err;
> -
> -	/* enable PIO controller's clock */
> -	if (clk_enable(at91_gpio->clock)) {
> -		pr_err("at91_gpio.%d, failed to enable clock, ignoring.\n", idx);
> -		goto clk_err;
> -	}
> -
> -	return 0;
> -
> -clk_err:
> -	clk_unprepare(at91_gpio->clock);
> -clk_prep_err:
> -	clk_put(at91_gpio->clock);
> -err:
> -	return -EINVAL;
> -}
> -
> -static void __init at91_gpio_init_one(int idx, u32 regbase, int pioc_hwirq)
> -{
> -	struct at91_gpio_chip *at91_gpio = &gpio_chip[idx];
> -
> -	at91_gpio->chip.base = idx * MAX_NB_GPIO_PER_BANK;
> -	at91_gpio->pioc_hwirq = pioc_hwirq;
> -	at91_gpio->pioc_idx = idx;
> -
> -	at91_gpio->regbase = ioremap(regbase, 512);
> -	if (!at91_gpio->regbase) {
> -		pr_err("at91_gpio.%d, failed to map registers, ignoring.\n", idx);
> -		return;
> -	}
> -
> -	if (at91_gpio_setup_clk(idx))
> -		goto ioremap_err;
> -
> -	gpio_banks = max(gpio_banks, idx + 1);
> -	return;
> -
> -ioremap_err:
> -	iounmap(at91_gpio->regbase);
> -}
> -
> -/*
> - * Called from the processor-specific init to enable GPIO pin support.
> - */
> -void __init at91_gpio_init(struct at91_gpio_bank *data, int nr_banks)
> -{
> -	unsigned i;
> -	struct at91_gpio_chip *at91_gpio, *last = NULL;
> -
> -	BUG_ON(nr_banks > MAX_GPIO_BANKS);
> -
> -	if (of_have_populated_dt())
> -		return;
> -
> -	for (i = 0; i < nr_banks; i++)
> -		at91_gpio_init_one(i, data[i].regbase, data[i].id);
> -
> -	for (i = 0; i < gpio_banks; i++) {
> -		at91_gpio = &gpio_chip[i];
> -
> -		/*
> -		 * GPIO controller are grouped on some SoC:
> -		 * PIOC, PIOD and PIOE can share the same IRQ line
> -		 */
> -		if (last && last->pioc_hwirq == at91_gpio->pioc_hwirq)
> -			last->next = at91_gpio;
> -		last = at91_gpio;
> -
> -		gpiochip_add(&at91_gpio->chip);
> -	}
> -}
> diff --git a/arch/arm/mach-at91/gpio.h b/arch/arm/mach-at91/gpio.h
> deleted file mode 100644
> index eed465ab0dd7..000000000000
> --- a/arch/arm/mach-at91/gpio.h
> +++ /dev/null
> @@ -1,214 +0,0 @@
> -/*
> - * arch/arm/mach-at91/include/mach/gpio.h
> - *
> - *  Copyright (C) 2005 HP Labs
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
> - */
> -
> -#ifndef __ASM_ARCH_AT91RM9200_GPIO_H
> -#define __ASM_ARCH_AT91RM9200_GPIO_H
> -
> -#include <linux/kernel.h>
> -#include <asm/irq.h>
> -
> -#define MAX_GPIO_BANKS		5
> -#define NR_BUILTIN_GPIO		(MAX_GPIO_BANKS * 32)
> -
> -/* these pin numbers double as IRQ numbers, like AT91xxx_ID_* values */
> -
> -#define	AT91_PIN_PA0	(0x00 + 0)
> -#define	AT91_PIN_PA1	(0x00 + 1)
> -#define	AT91_PIN_PA2	(0x00 + 2)
> -#define	AT91_PIN_PA3	(0x00 + 3)
> -#define	AT91_PIN_PA4	(0x00 + 4)
> -#define	AT91_PIN_PA5	(0x00 + 5)
> -#define	AT91_PIN_PA6	(0x00 + 6)
> -#define	AT91_PIN_PA7	(0x00 + 7)
> -#define	AT91_PIN_PA8	(0x00 + 8)
> -#define	AT91_PIN_PA9	(0x00 + 9)
> -#define	AT91_PIN_PA10	(0x00 + 10)
> -#define	AT91_PIN_PA11	(0x00 + 11)
> -#define	AT91_PIN_PA12	(0x00 + 12)
> -#define	AT91_PIN_PA13	(0x00 + 13)
> -#define	AT91_PIN_PA14	(0x00 + 14)
> -#define	AT91_PIN_PA15	(0x00 + 15)
> -#define	AT91_PIN_PA16	(0x00 + 16)
> -#define	AT91_PIN_PA17	(0x00 + 17)
> -#define	AT91_PIN_PA18	(0x00 + 18)
> -#define	AT91_PIN_PA19	(0x00 + 19)
> -#define	AT91_PIN_PA20	(0x00 + 20)
> -#define	AT91_PIN_PA21	(0x00 + 21)
> -#define	AT91_PIN_PA22	(0x00 + 22)
> -#define	AT91_PIN_PA23	(0x00 + 23)
> -#define	AT91_PIN_PA24	(0x00 + 24)
> -#define	AT91_PIN_PA25	(0x00 + 25)
> -#define	AT91_PIN_PA26	(0x00 + 26)
> -#define	AT91_PIN_PA27	(0x00 + 27)
> -#define	AT91_PIN_PA28	(0x00 + 28)
> -#define	AT91_PIN_PA29	(0x00 + 29)
> -#define	AT91_PIN_PA30	(0x00 + 30)
> -#define	AT91_PIN_PA31	(0x00 + 31)
> -
> -#define	AT91_PIN_PB0	(0x20 + 0)
> -#define	AT91_PIN_PB1	(0x20 + 1)
> -#define	AT91_PIN_PB2	(0x20 + 2)
> -#define	AT91_PIN_PB3	(0x20 + 3)
> -#define	AT91_PIN_PB4	(0x20 + 4)
> -#define	AT91_PIN_PB5	(0x20 + 5)
> -#define	AT91_PIN_PB6	(0x20 + 6)
> -#define	AT91_PIN_PB7	(0x20 + 7)
> -#define	AT91_PIN_PB8	(0x20 + 8)
> -#define	AT91_PIN_PB9	(0x20 + 9)
> -#define	AT91_PIN_PB10	(0x20 + 10)
> -#define	AT91_PIN_PB11	(0x20 + 11)
> -#define	AT91_PIN_PB12	(0x20 + 12)
> -#define	AT91_PIN_PB13	(0x20 + 13)
> -#define	AT91_PIN_PB14	(0x20 + 14)
> -#define	AT91_PIN_PB15	(0x20 + 15)
> -#define	AT91_PIN_PB16	(0x20 + 16)
> -#define	AT91_PIN_PB17	(0x20 + 17)
> -#define	AT91_PIN_PB18	(0x20 + 18)
> -#define	AT91_PIN_PB19	(0x20 + 19)
> -#define	AT91_PIN_PB20	(0x20 + 20)
> -#define	AT91_PIN_PB21	(0x20 + 21)
> -#define	AT91_PIN_PB22	(0x20 + 22)
> -#define	AT91_PIN_PB23	(0x20 + 23)
> -#define	AT91_PIN_PB24	(0x20 + 24)
> -#define	AT91_PIN_PB25	(0x20 + 25)
> -#define	AT91_PIN_PB26	(0x20 + 26)
> -#define	AT91_PIN_PB27	(0x20 + 27)
> -#define	AT91_PIN_PB28	(0x20 + 28)
> -#define	AT91_PIN_PB29	(0x20 + 29)
> -#define	AT91_PIN_PB30	(0x20 + 30)
> -#define	AT91_PIN_PB31	(0x20 + 31)
> -
> -#define	AT91_PIN_PC0	(0x40 + 0)
> -#define	AT91_PIN_PC1	(0x40 + 1)
> -#define	AT91_PIN_PC2	(0x40 + 2)
> -#define	AT91_PIN_PC3	(0x40 + 3)
> -#define	AT91_PIN_PC4	(0x40 + 4)
> -#define	AT91_PIN_PC5	(0x40 + 5)
> -#define	AT91_PIN_PC6	(0x40 + 6)
> -#define	AT91_PIN_PC7	(0x40 + 7)
> -#define	AT91_PIN_PC8	(0x40 + 8)
> -#define	AT91_PIN_PC9	(0x40 + 9)
> -#define	AT91_PIN_PC10	(0x40 + 10)
> -#define	AT91_PIN_PC11	(0x40 + 11)
> -#define	AT91_PIN_PC12	(0x40 + 12)
> -#define	AT91_PIN_PC13	(0x40 + 13)
> -#define	AT91_PIN_PC14	(0x40 + 14)
> -#define	AT91_PIN_PC15	(0x40 + 15)
> -#define	AT91_PIN_PC16	(0x40 + 16)
> -#define	AT91_PIN_PC17	(0x40 + 17)
> -#define	AT91_PIN_PC18	(0x40 + 18)
> -#define	AT91_PIN_PC19	(0x40 + 19)
> -#define	AT91_PIN_PC20	(0x40 + 20)
> -#define	AT91_PIN_PC21	(0x40 + 21)
> -#define	AT91_PIN_PC22	(0x40 + 22)
> -#define	AT91_PIN_PC23	(0x40 + 23)
> -#define	AT91_PIN_PC24	(0x40 + 24)
> -#define	AT91_PIN_PC25	(0x40 + 25)
> -#define	AT91_PIN_PC26	(0x40 + 26)
> -#define	AT91_PIN_PC27	(0x40 + 27)
> -#define	AT91_PIN_PC28	(0x40 + 28)
> -#define	AT91_PIN_PC29	(0x40 + 29)
> -#define	AT91_PIN_PC30	(0x40 + 30)
> -#define	AT91_PIN_PC31	(0x40 + 31)
> -
> -#define	AT91_PIN_PD0	(0x60 + 0)
> -#define	AT91_PIN_PD1	(0x60 + 1)
> -#define	AT91_PIN_PD2	(0x60 + 2)
> -#define	AT91_PIN_PD3	(0x60 + 3)
> -#define	AT91_PIN_PD4	(0x60 + 4)
> -#define	AT91_PIN_PD5	(0x60 + 5)
> -#define	AT91_PIN_PD6	(0x60 + 6)
> -#define	AT91_PIN_PD7	(0x60 + 7)
> -#define	AT91_PIN_PD8	(0x60 + 8)
> -#define	AT91_PIN_PD9	(0x60 + 9)
> -#define	AT91_PIN_PD10	(0x60 + 10)
> -#define	AT91_PIN_PD11	(0x60 + 11)
> -#define	AT91_PIN_PD12	(0x60 + 12)
> -#define	AT91_PIN_PD13	(0x60 + 13)
> -#define	AT91_PIN_PD14	(0x60 + 14)
> -#define	AT91_PIN_PD15	(0x60 + 15)
> -#define	AT91_PIN_PD16	(0x60 + 16)
> -#define	AT91_PIN_PD17	(0x60 + 17)
> -#define	AT91_PIN_PD18	(0x60 + 18)
> -#define	AT91_PIN_PD19	(0x60 + 19)
> -#define	AT91_PIN_PD20	(0x60 + 20)
> -#define	AT91_PIN_PD21	(0x60 + 21)
> -#define	AT91_PIN_PD22	(0x60 + 22)
> -#define	AT91_PIN_PD23	(0x60 + 23)
> -#define	AT91_PIN_PD24	(0x60 + 24)
> -#define	AT91_PIN_PD25	(0x60 + 25)
> -#define	AT91_PIN_PD26	(0x60 + 26)
> -#define	AT91_PIN_PD27	(0x60 + 27)
> -#define	AT91_PIN_PD28	(0x60 + 28)
> -#define	AT91_PIN_PD29	(0x60 + 29)
> -#define	AT91_PIN_PD30	(0x60 + 30)
> -#define	AT91_PIN_PD31	(0x60 + 31)
> -
> -#define	AT91_PIN_PE0	(0x80 + 0)
> -#define	AT91_PIN_PE1	(0x80 + 1)
> -#define	AT91_PIN_PE2	(0x80 + 2)
> -#define	AT91_PIN_PE3	(0x80 + 3)
> -#define	AT91_PIN_PE4	(0x80 + 4)
> -#define	AT91_PIN_PE5	(0x80 + 5)
> -#define	AT91_PIN_PE6	(0x80 + 6)
> -#define	AT91_PIN_PE7	(0x80 + 7)
> -#define	AT91_PIN_PE8	(0x80 + 8)
> -#define	AT91_PIN_PE9	(0x80 + 9)
> -#define	AT91_PIN_PE10	(0x80 + 10)
> -#define	AT91_PIN_PE11	(0x80 + 11)
> -#define	AT91_PIN_PE12	(0x80 + 12)
> -#define	AT91_PIN_PE13	(0x80 + 13)
> -#define	AT91_PIN_PE14	(0x80 + 14)
> -#define	AT91_PIN_PE15	(0x80 + 15)
> -#define	AT91_PIN_PE16	(0x80 + 16)
> -#define	AT91_PIN_PE17	(0x80 + 17)
> -#define	AT91_PIN_PE18	(0x80 + 18)
> -#define	AT91_PIN_PE19	(0x80 + 19)
> -#define	AT91_PIN_PE20	(0x80 + 20)
> -#define	AT91_PIN_PE21	(0x80 + 21)
> -#define	AT91_PIN_PE22	(0x80 + 22)
> -#define	AT91_PIN_PE23	(0x80 + 23)
> -#define	AT91_PIN_PE24	(0x80 + 24)
> -#define	AT91_PIN_PE25	(0x80 + 25)
> -#define	AT91_PIN_PE26	(0x80 + 26)
> -#define	AT91_PIN_PE27	(0x80 + 27)
> -#define	AT91_PIN_PE28	(0x80 + 28)
> -#define	AT91_PIN_PE29	(0x80 + 29)
> -#define	AT91_PIN_PE30	(0x80 + 30)
> -#define	AT91_PIN_PE31	(0x80 + 31)
> -
> -#ifndef __ASSEMBLY__
> -/* setup setup routines, called from board init or driver probe() */
> -extern int __init_or_module at91_set_GPIO_periph(unsigned pin, int use_pullup);
> -extern int __init_or_module at91_set_A_periph(unsigned pin, int use_pullup);
> -extern int __init_or_module at91_set_B_periph(unsigned pin, int use_pullup);
> -extern int __init_or_module at91_set_C_periph(unsigned pin, int use_pullup);
> -extern int __init_or_module at91_set_D_periph(unsigned pin, int use_pullup);
> -extern int __init_or_module at91_set_gpio_input(unsigned pin, int use_pullup);
> -extern int __init_or_module at91_set_gpio_output(unsigned pin, int value);
> -extern int __init_or_module at91_set_deglitch(unsigned pin, int is_on);
> -extern int __init_or_module at91_set_debounce(unsigned pin, int is_on, int div);
> -extern int __init_or_module at91_set_multi_drive(unsigned pin, int is_on);
> -extern int __init_or_module at91_set_pulldown(unsigned pin, int is_on);
> -extern int __init_or_module at91_disable_schmitt_trig(unsigned pin);
> -
> -/* callable at any time */
> -extern int at91_set_gpio_value(unsigned pin, int value);
> -extern int at91_get_gpio_value(unsigned pin);
> -
> -/* callable only from core power-management code */
> -extern void at91_gpio_suspend(void);
> -extern void at91_gpio_resume(void);
> -
> -#endif	/* __ASSEMBLY__ */
> -
> -#endif
> diff --git a/arch/arm/mach-at91/include/mach/atmel-mci.h b/arch/arm/mach-at91/include/mach/atmel-mci.h
> index 3069e4135573..e69de29bb2d1 100644
> --- a/arch/arm/mach-at91/include/mach/atmel-mci.h
> +++ b/arch/arm/mach-at91/include/mach/atmel-mci.h
> @@ -1,17 +0,0 @@
> -#ifndef __MACH_ATMEL_MCI_H
> -#define __MACH_ATMEL_MCI_H
> -
> -#include <linux/platform_data/dma-atmel.h>
> -
> -/**
> - * struct mci_dma_data - DMA data for MCI interface
> - */
> -struct mci_dma_data {
> -	struct at_dma_slave	sdata;
> -};
> -
> -/* accessor macros */
> -#define	slave_data_ptr(s)	(&(s)->sdata)
> -#define find_slave_dev(s)	((s)->sdata.dma_dev)
> -
> -#endif /* __MACH_ATMEL_MCI_H */
> diff --git a/arch/arm/mach-at91/include/mach/cpu.h b/arch/arm/mach-at91/include/mach/cpu.h
> index 61914fb35f5d..438e64a613b8 100644
> --- a/arch/arm/mach-at91/include/mach/cpu.h
> +++ b/arch/arm/mach-at91/include/mach/cpu.h
> @@ -134,8 +134,6 @@ struct at91_socinfo {
>  };
>  
>  extern struct at91_socinfo at91_soc_initdata;
> -const char *at91_get_soc_type(struct at91_socinfo *c);
> -const char *at91_get_soc_subtype(struct at91_socinfo *c);
>  
>  static inline int at91_soc_is_detected(void)
>  {
> diff --git a/arch/arm/mach-at91/leds.c b/arch/arm/mach-at91/leds.c
> deleted file mode 100644
> index eb22e3357e87..000000000000
> --- a/arch/arm/mach-at91/leds.c
> +++ /dev/null
> @@ -1,56 +0,0 @@
> -/*
> - * LED driver for Atmel AT91-based boards.
> - *
> - *  Copyright (C) SAN People (Pty) Ltd
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version
> - * 2 of the License, or (at your option) any later version.
> -*/
> -
> -#include <linux/gpio.h>
> -#include <linux/kernel.h>
> -#include <linux/module.h>
> -#include <linux/init.h>
> -#include <linux/platform_device.h>
> -
> -#include "board.h"
> -#include "gpio.h"
> -
> -
> -/* ------------------------------------------------------------------------- */
> -
> -#if defined(CONFIG_NEW_LEDS)
> -
> -/*
> - * New cross-platform LED support.
> - */
> -
> -static struct gpio_led_platform_data led_data;
> -
> -static struct platform_device at91_gpio_leds_device = {
> -	.name			= "leds-gpio",
> -	.id			= -1,
> -	.dev.platform_data	= &led_data,
> -};
> -
> -void __init at91_gpio_leds(struct gpio_led *leds, int nr)
> -{
> -	int i;
> -
> -	if (!nr)
> -		return;
> -
> -	for (i = 0; i < nr; i++)
> -		at91_set_gpio_output(leds[i].gpio, leds[i].active_low);
> -
> -	led_data.leds = leds;
> -	led_data.num_leds = nr;
> -	platform_device_register(&at91_gpio_leds_device);
> -}
> -
> -#else
> -void __init at91_gpio_leds(struct gpio_led *leds, int nr) {}
> -#endif
> -
> diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
> index a42360f69127..9b15169a1c62 100644
> --- a/arch/arm/mach-at91/pm.c
> +++ b/arch/arm/mach-at91/pm.c
> @@ -31,7 +31,6 @@
>  
>  #include "generic.h"
>  #include "pm.h"
> -#include "gpio.h"
>  
>  static void (*at91_pm_standby)(void);
>  
> @@ -130,10 +129,7 @@ extern u32 at91_slow_clock_sz;
>  
>  static int at91_pm_enter(suspend_state_t state)
>  {
> -	if (of_have_populated_dt())
> -		at91_pinctrl_gpio_suspend();
> -	else
> -		at91_gpio_suspend();
> +	at91_pinctrl_gpio_suspend();
>  
>  	switch (state) {
>  		/*
> @@ -201,10 +197,7 @@ static int at91_pm_enter(suspend_state_t state)
>  error:
>  	target_state = PM_SUSPEND_ON;
>  
> -	if (of_have_populated_dt())
> -		at91_pinctrl_gpio_resume();
> -	else
> -		at91_gpio_resume();
> +	at91_pinctrl_gpio_resume();
>  	return 0;
>  }
>  
> diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
> index 6c3013e3309b..c15f4de92208 100644
> --- a/arch/arm/mach-at91/setup.c
> +++ b/arch/arm/mach-at91/setup.c
> @@ -31,42 +31,9 @@ struct at91_init_soc __initdata at91_boot_soc;
>  struct at91_socinfo at91_soc_initdata;
>  EXPORT_SYMBOL(at91_soc_initdata);
>  
> -void __init at91rm9200_set_type(int type)
> -{
> -	if (type == ARCH_REVISON_9200_PQFP)
> -		at91_soc_initdata.subtype = AT91_SOC_RM9200_PQFP;
> -	else
> -		at91_soc_initdata.subtype = AT91_SOC_RM9200_BGA;
> -
> -	pr_info("filled in soc subtype: %s\n",
> -		at91_get_soc_subtype(&at91_soc_initdata));
> -}
> -
> -void __init at91_init_irq_default(void)
> -{
> -	at91_init_interrupts(at91_boot_soc.default_irq_priority);
> -}
> -
> -void __init at91_init_interrupts(unsigned int *priority)
> -{
> -	/* Enable GPIO interrupts */
> -	at91_gpio_irq_setup();
> -}
> -
>  void __iomem *at91_ramc_base[2];
>  EXPORT_SYMBOL_GPL(at91_ramc_base);
>  
> -void __init at91_ioremap_ramc(int id, u32 addr, u32 size)
> -{
> -	if (id < 0 || id > 1) {
> -		pr_emerg("Wrong RAM controller id (%d), cannot continue\n", id);
> -		BUG();
> -	}
> -	at91_ramc_base[id] = ioremap(addr, size);
> -	if (!at91_ramc_base[id])
> -		panic(pr_fmt("Impossible to ioremap ramc.%d 0x%x\n"), id, addr);
> -}
> -
>  static struct map_desc sram_desc[2] __initdata;
>  
>  void __init at91_init_sram(int bank, unsigned long base, unsigned int length)
> @@ -313,12 +280,6 @@ static const char *soc_name[] = {
>  	[AT91_SOC_UNKNOWN]	= "Unknown",
>  };
>  
> -const char *at91_get_soc_type(struct at91_socinfo *c)
> -{
> -	return soc_name[c->type];
> -}
> -EXPORT_SYMBOL(at91_get_soc_type);
> -
>  static const char *soc_subtype_name[] = {
>  	[AT91_SOC_RM9200_BGA]	= "at91rm9200 BGA",
>  	[AT91_SOC_RM9200_PQFP]	= "at91rm9200 PQFP",
> @@ -345,12 +306,6 @@ static const char *soc_subtype_name[] = {
>  	[AT91_SOC_SUBTYPE_UNKNOWN] = "Unknown",
>  };
>  
> -const char *at91_get_soc_subtype(struct at91_socinfo *c)
> -{
> -	return soc_subtype_name[c->subtype];
> -}
> -EXPORT_SYMBOL(at91_get_soc_subtype);
> -
>  void __init at91_map_io(void)
>  {
>  	/* Map peripherals */
> @@ -366,11 +321,10 @@ void __init at91_map_io(void)
>  	if (!at91_soc_is_detected())
>  		panic(pr_fmt("Impossible to detect the SOC type"));
>  
> -	pr_info("Detected soc type: %s\n",
> -		at91_get_soc_type(&at91_soc_initdata));
> +	pr_info("Detected soc type: %s\n", soc_name[at91_soc_initdata.type]);
>  	if (at91_soc_initdata.subtype != AT91_SOC_SUBTYPE_NONE)
>  		pr_info("Detected soc subtype: %s\n",
> -			at91_get_soc_subtype(&at91_soc_initdata));
> +			soc_subtype_name[at91_soc_initdata.type]);
>  
>  	if (!at91_soc_is_enabled())
>  		panic(pr_fmt("Soc not enabled"));
> @@ -392,10 +346,10 @@ void __init at91_alt_map_io(void)
>  		panic("AT91: Impossible to detect the SOC type");
>  
>  	pr_info("AT91: Detected soc type: %s\n",
> -		at91_get_soc_type(&at91_soc_initdata));
> +		soc_name[at91_soc_initdata.type]);
>  	if (at91_soc_initdata.subtype != AT91_SOC_SUBTYPE_NONE)
>  		pr_info("AT91: Detected soc subtype: %s\n",
> -			at91_get_soc_subtype(&at91_soc_initdata));
> +			soc_subtype_name[at91_soc_initdata.type]);
>  
>  	if (!at91_soc_is_enabled())
>  		panic("AT91: Soc not enabled");
> @@ -404,17 +358,6 @@ void __init at91_alt_map_io(void)
>  		at91_boot_soc.map_io();
>  }
>  
> -void __iomem *at91_matrix_base;
> -EXPORT_SYMBOL_GPL(at91_matrix_base);
> -
> -void __init at91_ioremap_matrix(u32 base_addr)
> -{
> -	at91_matrix_base = ioremap(base_addr, 512);
> -	if (!at91_matrix_base)
> -		panic(pr_fmt("Impossible to ioremap at91_matrix_base\n"));
> -}
> -
> -#if defined(CONFIG_OF)
>  static struct of_device_id ramc_ids[] = {
>  	{ .compatible = "atmel,at91rm9200-sdramc", .data = at91rm9200_standby },
>  	{ .compatible = "atmel,at91sam9260-sdramc", .data = at91sam9_sdram_standby },
> @@ -456,10 +399,6 @@ void __init at91rm9200_dt_initialize(void)
>  {
>  	at91_dt_ramc();
>  
> -	/* Register the processor-specific clocks */
> -	if (at91_boot_soc.register_clocks)
> -		at91_boot_soc.register_clocks();
> -
>  	at91_boot_soc.init();
>  }
>  
> @@ -467,33 +406,6 @@ void __init at91_dt_initialize(void)
>  {
>  	at91_dt_ramc();
>  
> -	/* Register the processor-specific clocks */
> -	if (at91_boot_soc.register_clocks)
> -		at91_boot_soc.register_clocks();
> -
>  	if (at91_boot_soc.init)
>  		at91_boot_soc.init();
>  }
> -#endif
> -
> -void __init at91_initialize(unsigned long main_clock)
> -{
> -	at91_boot_soc.ioremap_registers();
> -
> -	/* Register the processor-specific clocks */
> -	at91_boot_soc.register_clocks();
> -
> -	at91_boot_soc.init();
> -
> -	pinctrl_provide_dummies();
> -}
> -
> -void __init at91_register_devices(void)
> -{
> -	at91_boot_soc.register_devices();
> -}
> -
> -void __init at91_init_time(void)
> -{
> -	at91_boot_soc.init_time();
> -}
> diff --git a/arch/arm/mach-at91/soc.h b/arch/arm/mach-at91/soc.h
> index 9a8fd97a8bef..ae6c0b2f1146 100644
> --- a/arch/arm/mach-at91/soc.h
> +++ b/arch/arm/mach-at91/soc.h
> @@ -6,14 +6,8 @@
>  
>  struct at91_init_soc {
>  	int builtin;
> -	u32 extern_irq;
> -	unsigned int *default_irq_priority;
>  	void (*map_io)(void);
> -	void (*ioremap_registers)(void);
> -	void (*register_clocks)(void);
> -	void (*register_devices)(void);
>  	void (*init)(void);
> -	void (*init_time)(void);
>  };
>  
>  extern struct at91_init_soc at91_boot_soc;
> diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> index 37b75602adf6..e88e386c9d7b 100644
> --- a/arch/avr32/mach-at32ap/at32ap700x.c
> +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> @@ -17,7 +17,6 @@
>  #include <linux/spi/spi.h>
>  #include <linux/usb/atmel_usba_udc.h>
>  
> -#include <mach/atmel-mci.h>
>  #include <linux/atmel-mci.h>
>  
>  #include <asm/io.h>
> diff --git a/arch/avr32/mach-at32ap/include/mach/atmel-mci.h b/arch/avr32/mach-at32ap/include/mach/atmel-mci.h
> index 11d7f4b28dc8..e69de29bb2d1 100644
> --- a/arch/avr32/mach-at32ap/include/mach/atmel-mci.h
> +++ b/arch/avr32/mach-at32ap/include/mach/atmel-mci.h
> @@ -1,17 +0,0 @@
> -#ifndef __MACH_ATMEL_MCI_H
> -#define __MACH_ATMEL_MCI_H
> -
> -#include <linux/platform_data/dma-dw.h>
> -
> -/**
> - * struct mci_dma_data - DMA data for MCI interface
> - */
> -struct mci_dma_data {
> -	struct dw_dma_slave	sdata;
> -};
> -
> -/* accessor macros */
> -#define	slave_data_ptr(s)	(&(s)->sdata)
> -#define find_slave_dev(s)	((s)->sdata.dma_dev)
> -
> -#endif /* __MACH_ATMEL_MCI_H */
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index cd4cccbfd2ab..a5af3056e467 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -834,7 +834,7 @@ config PATA_AT32
>  
>  config PATA_AT91
>  	tristate "PATA support for AT91SAM9260"
> -	depends on ARM && SOC_AT91SAM9
> +	depends on ARM && SOC_AT91SAM9 && !ARCH_MULTIPLATFORM
>  	help
>  	  This option enables support for IDE devices on the Atmel AT91SAM9260 SoC.
>  
> diff --git a/drivers/clocksource/timer-atmel-pit.c b/drivers/clocksource/timer-atmel-pit.c
> index d5289098b3df..b5b4d4585c9a 100644
> --- a/drivers/clocksource/timer-atmel-pit.c
> +++ b/drivers/clocksource/timer-atmel-pit.c
> @@ -262,35 +262,3 @@ static void __init at91sam926x_pit_dt_init(struct device_node *node)
>  }
>  CLOCKSOURCE_OF_DECLARE(at91sam926x_pit, "atmel,at91sam9260-pit",
>  		       at91sam926x_pit_dt_init);
> -
> -static void __iomem *pit_base_addr;
> -
> -void __init at91sam926x_pit_init(int irq)
> -{
> -	struct pit_data *data;
> -
> -	data = kzalloc(sizeof(*data), GFP_KERNEL);
> -	if (!data)
> -		panic(pr_fmt("Unable to allocate memory\n"));
> -
> -	data->base = pit_base_addr;
> -
> -	data->mck = clk_get(NULL, "mck");
> -	if (IS_ERR(data->mck))
> -		panic(pr_fmt("Unable to get mck clk\n"));
> -
> -	data->irq = irq;
> -
> -	at91sam926x_pit_common_init(data);
> -}
> -
> -void __init at91sam926x_ioremap_pit(u32 addr)
> -{
> -	if (of_have_populated_dt())
> -		return;
> -
> -	pit_base_addr = ioremap(addr, 16);
> -
> -	if (!pit_base_addr)
> -		panic(pr_fmt("Impossible to ioremap PIT\n"));
> -}
> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
> index 77250d4b1979..449554245675 100644
> --- a/drivers/mmc/host/atmel-mci.c
> +++ b/drivers/mmc/host/atmel-mci.c
> @@ -34,7 +34,6 @@
>  #include <linux/mmc/host.h>
>  #include <linux/mmc/sdio.h>
>  
> -#include <mach/atmel-mci.h>
>  #include <linux/atmel-mci.h>
>  #include <linux/atmel_pdc.h>
>  
> diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
> index b0ce7cdee0c2..eea2348b5448 100644
> --- a/drivers/pcmcia/Kconfig
> +++ b/drivers/pcmcia/Kconfig
> @@ -277,7 +277,7 @@ config BFIN_CFPCMCIA
>  
>  config AT91_CF
>  	tristate "AT91 CompactFlash Controller"
> -	depends on PCMCIA && ARCH_AT91
> +	depends on PCMCIA && ARCH_AT91 && !ARCH_MULTIPLATFORM
>  	help
>  	  Say Y here to support the CompactFlash controller on AT91 chips.
>  	  Or choose M to compile the driver as a module named "at91_cf".
> diff --git a/arch/arm/mach-at91/include/mach/at91_pio.h b/drivers/pinctrl/at91_pio.h
> similarity index 100%
> rename from arch/arm/mach-at91/include/mach/at91_pio.h
> rename to drivers/pinctrl/at91_pio.h
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index 354a81d40925..a193614ce14c 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -25,9 +25,7 @@
>  /* Since we request GPIOs from ourself */
>  #include <linux/pinctrl/consumer.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/at91_pio.h>
> -
> +#include "at91_pio.h"
>  #include "core.h"
>  
>  #define MAX_GPIO_BANKS		5
> diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
> index 596374304532..847f268ffaf7 100644
> --- a/drivers/rtc/rtc-at91sam9.c
> +++ b/drivers/rtc/rtc-at91sam9.c
> @@ -22,9 +22,24 @@
>  #include <linux/platform_data/atmel.h>
>  #include <linux/io.h>
>  
> -#include <mach/at91_rtt.h>
> -#include <mach/cpu.h>
> -#include <mach/hardware.h>
> +#define AT91_SLOW_CLOCK              32768
> +
> +#define AT91_RTT_MR		0x00			/* Real-time Mode Register */
> +#define		AT91_RTT_RTPRES		(0xffff << 0)		/* Real-time Timer Prescaler Value */
> +#define		AT91_RTT_ALMIEN		(1 << 16)		/* Alarm Interrupt Enable */
> +#define		AT91_RTT_RTTINCIEN	(1 << 17)		/* Real Time Timer Increment Interrupt Enable */
> +#define		AT91_RTT_RTTRST		(1 << 18)		/* Real Time Timer Restart */
> +
> +#define AT91_RTT_AR		0x04			/* Real-time Alarm Register */
> +#define		AT91_RTT_ALMV		(0xffffffff)		/* Alarm Value */
> +
> +#define AT91_RTT_VR		0x08			/* Real-time Value Register */
> +#define		AT91_RTT_CRTV		(0xffffffff)		/* Current Real-time Value */
> +
> +#define AT91_RTT_SR		0x0c			/* Real-time Status Register */
> +#define		AT91_RTT_ALMS		(1 << 0)		/* Real-time Alarm Status */
> +#define		AT91_RTT_RTTINC		(1 << 1)		/* Real-time Timer Increment */
> +
>  
>  /*
>   * This driver uses two configurable hardware resources that live in the
> diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/Kconfig
> index 217365d35a25..36e22816d62e 100644
> --- a/drivers/usb/gadget/udc/Kconfig
> +++ b/drivers/usb/gadget/udc/Kconfig
> @@ -31,7 +31,7 @@ menu "USB Peripheral Controller"
>  
>  config USB_AT91
>  	tristate "Atmel AT91 USB Device Port"
> -	depends on ARCH_AT91
> +	depends on ARCH_AT91 && !ARCH_MULTIPLATFORM
>  	help
>  	   Many Atmel AT91 processors (such as the AT91RM2000) have a
>  	   full speed USB Device Port with support for five configurable
> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
> index e49eb4f90f5d..6181549883af 100644
> --- a/drivers/usb/host/ohci-at91.c
> +++ b/drivers/usb/host/ohci-at91.c
> @@ -24,12 +24,8 @@
>  #include <linux/usb.h>
>  #include <linux/usb/hcd.h>
>  
> -#include <mach/hardware.h>
>  #include <asm/gpio.h>
>  
> -#include <mach/cpu.h>
> -
> -
>  #include "ohci.h"
>  
>  #define valid_port(index)	((index) >= 0 && (index) < AT91_MAX_USBH_PORTS)
> diff --git a/include/linux/atmel-mci.h b/include/linux/atmel-mci.h
> index 91b77f8d495d..af427a7d3685 100644
> --- a/include/linux/atmel-mci.h
> +++ b/include/linux/atmel-mci.h
> @@ -1,8 +1,20 @@
>  #ifndef __LINUX_ATMEL_MCI_H
>  #define __LINUX_ATMEL_MCI_H
>  
> +#include <linux/platform_data/dma-dw.h>
>  #include <linux/types.h>
>  
> +/**
> + * struct mci_dma_data - DMA data for MCI interface
> + */
> +struct mci_dma_data {
> +	struct dw_dma_slave	sdata;
> +};
> +
> +/* accessor macros */
> +#define	slave_data_ptr(s)	(&(s)->sdata)
> +#define find_slave_dev(s)	((s)->sdata.dma_dev)
> +
>  #define ATMCI_MAX_NR_SLOTS	2
>  
>  /**
> diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
> index b59427d5a697..83975f8d5947 100644
> --- a/sound/atmel/ac97c.c
> +++ b/sound/atmel/ac97c.c
> @@ -34,10 +34,10 @@
>  #include <linux/platform_data/dma-dw.h>
>  #include <linux/dma/dw.h>
>  
> +#ifdef CONFIG_AVR32
>  #include <mach/cpu.h>
> -
> -#ifdef CONFIG_ARCH_AT91
> -#include <mach/hardware.h>
> +#else
> +#define cpu_is_at32ap7000() (0)
>  #endif
>  
>  #include "ac97c.h"
> diff --git a/sound/soc/atmel/sam9g20_wm8731.c b/sound/soc/atmel/sam9g20_wm8731.c
> index bb1149126c54..9945ea603279 100644
> --- a/sound/soc/atmel/sam9g20_wm8731.c
> +++ b/sound/soc/atmel/sam9g20_wm8731.c
> @@ -47,7 +47,6 @@
>  #include <sound/soc.h>
>  
>  #include <asm/mach-types.h>
> -#include <mach/hardware.h>
>  
>  #include "../codecs/wm8731.h"
>  #include "atmel-pcm.h"
> 


-- 
Nicolas Ferre
