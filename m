Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaIONaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 09:30:18 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:23627 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaIONaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 09:30:16 -0400
Message-ID: <5416E9E6.6090601@atmel.com>
Date: Mon, 15 Sep 2014 15:30:14 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <tanzilli@acmesystems.it>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH] ARM: at91: board file for Acme Systems Fox G20
References: <1410787655-28263-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1410787655-28263-1-git-send-email-nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I should have added a little "remove" in the subject: already corrected
in my tree...

On 15/09/2014 15:27, Nicolas Ferre :
> As Acme Systems Fox G20 is available in Device Tree flavor and that we plan to
> remove all the board files soon, we can remove this one without problem.
> If you use this board, please use a DT-enabled at91sam9g20 kernel with
> at91-foxg20.dts.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/mach-at91/Kconfig.non_dt |   6 -
>  arch/arm/mach-at91/Makefile       |   1 -
>  arch/arm/mach-at91/board-foxg20.c | 272 --------------------------------------
>  3 files changed, 279 deletions(-)
>  delete mode 100644 arch/arm/mach-at91/board-foxg20.c
> 
> diff --git a/arch/arm/mach-at91/Kconfig.non_dt b/arch/arm/mach-at91/Kconfig.non_dt
> index 44ace320d2e1..a2ee352a8904 100644
> --- a/arch/arm/mach-at91/Kconfig.non_dt
> +++ b/arch/arm/mach-at91/Kconfig.non_dt
> @@ -212,12 +212,6 @@ config MACH_CPU9G20
>  	  Select this if you are using a Eukrea Electromatique's
>  	  CPU9G20 Board <http://www.eukrea.com/>
>  
> -config MACH_ACMENETUSFOXG20
> -	bool "Acme Systems srl FOX Board G20"
> -	help
> -	  Select this if you are using Acme Systems
> -	  FOX Board G20 <http://www.acmesystems.it>
> -
>  config MACH_PORTUXG20
>  	bool "taskit PortuxG20"
>  	help
> diff --git a/arch/arm/mach-at91/Makefile b/arch/arm/mach-at91/Makefile
> index 78e9cec282f4..e8efcb00ca94 100644
> --- a/arch/arm/mach-at91/Makefile
> +++ b/arch/arm/mach-at91/Makefile
> @@ -69,7 +69,6 @@ obj-$(CONFIG_MACH_AT91SAM9RLEK)	+= board-sam9rlek.o
>  # AT91SAM9G20 board-specific support
>  obj-$(CONFIG_MACH_AT91SAM9G20EK) += board-sam9g20ek.o
>  obj-$(CONFIG_MACH_CPU9G20)	+= board-cpu9krea.o
> -obj-$(CONFIG_MACH_ACMENETUSFOXG20) += board-foxg20.o
>  obj-$(CONFIG_MACH_STAMP9G20)	+= board-stamp9g20.o
>  obj-$(CONFIG_MACH_PORTUXG20)	+= board-stamp9g20.o
>  obj-$(CONFIG_MACH_PCONTROL_G20)	+= board-pcontrol-g20.o board-stamp9g20.o
> diff --git a/arch/arm/mach-at91/board-foxg20.c b/arch/arm/mach-at91/board-foxg20.c
> deleted file mode 100644
> index 8b22c60bb238..000000000000
> --- a/arch/arm/mach-at91/board-foxg20.c
> +++ /dev/null
> @@ -1,272 +0,0 @@
> -/*
> - *  Copyright (C) 2005 SAN People
> - *  Copyright (C) 2008 Atmel
> - *  Copyright (C) 2010 Lee McLoughlin - lee@lmmrtech.com
> - *  Copyright (C) 2010 Sergio Tanzilli - tanzilli@acmesystems.it
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
> -#include <linux/types.h>
> -#include <linux/init.h>
> -#include <linux/mm.h>
> -#include <linux/module.h>
> -#include <linux/platform_device.h>
> -#include <linux/spi/spi.h>
> -#include <linux/spi/at73c213.h>
> -#include <linux/gpio.h>
> -#include <linux/gpio_keys.h>
> -#include <linux/input.h>
> -#include <linux/clk.h>
> -#include <linux/w1-gpio.h>
> -
> -#include <mach/hardware.h>
> -#include <asm/setup.h>
> -#include <asm/mach-types.h>
> -#include <asm/irq.h>
> -
> -#include <asm/mach/arch.h>
> -#include <asm/mach/map.h>
> -#include <asm/mach/irq.h>
> -
> -#include <mach/at91sam9_smc.h>
> -
> -#include "at91_aic.h"
> -#include "board.h"
> -#include "sam9_smc.h"
> -#include "generic.h"
> -#include "gpio.h"
> -
> -/*
> - * The FOX Board G20 hardware comes as the "Netus G20" board with
> - * just the cpu, ram, dataflash and two header connectors.
> - * This is plugged into the FOX Board which provides the ethernet,
> - * usb, rtc, leds, switch, ...
> - *
> - * For more info visit: http://www.acmesystems.it/foxg20
> - */
> -
> -
> -static void __init foxg20_init_early(void)
> -{
> -	/* Initialize processor: 18.432 MHz crystal */
> -	at91_initialize(18432000);
> -}
> -
> -/*
> - * USB Host port
> - */
> -static struct at91_usbh_data __initdata foxg20_usbh_data = {
> -	.ports		= 2,
> -	.vbus_pin	= {-EINVAL, -EINVAL},
> -	.overcurrent_pin= {-EINVAL, -EINVAL},
> -};
> -
> -/*
> - * USB Device port
> - */
> -static struct at91_udc_data __initdata foxg20_udc_data = {
> -	.vbus_pin	= AT91_PIN_PC6,
> -	.pullup_pin	= -EINVAL,		/* pull-up driven by UDC */
> -};
> -
> -
> -/*
> - * SPI devices.
> - */
> -static struct spi_board_info foxg20_spi_devices[] = {
> -#if !IS_ENABLED(CONFIG_MMC_ATMELMCI)
> -	{
> -		.modalias	= "mtd_dataflash",
> -		.chip_select	= 1,
> -		.max_speed_hz	= 15 * 1000 * 1000,
> -		.bus_num	= 0,
> -	},
> -#endif
> -};
> -
> -
> -/*
> - * MACB Ethernet device
> - */
> -static struct macb_platform_data __initdata foxg20_macb_data = {
> -	.phy_irq_pin	= AT91_PIN_PA7,
> -	.is_rmii	= 1,
> -};
> -
> -/*
> - * MCI (SD/MMC)
> - * det_pin, wp_pin and vcc_pin are not connected
> - */
> -static struct mci_platform_data __initdata foxg20_mci0_data = {
> -	.slot[1] = {
> -		.bus_width	= 4,
> -		.detect_pin	= -EINVAL,
> -		.wp_pin		= -EINVAL,
> -	},
> -};
> -
> -
> -/*
> - * LEDs
> - */
> -static struct gpio_led foxg20_leds[] = {
> -	{	/* user led, red */
> -		.name			= "user_led",
> -		.gpio			= AT91_PIN_PC7,
> -		.active_low		= 0,
> -		.default_trigger	= "heartbeat",
> -	},
> -};
> -
> -
> -/*
> - * GPIO Buttons
> - */
> -#if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
> -static struct gpio_keys_button foxg20_buttons[] = {
> -	{
> -		.gpio		= AT91_PIN_PC4,
> -		.code		= BTN_1,
> -		.desc		= "Button 1",
> -		.active_low	= 1,
> -		.wakeup		= 1,
> -	},
> -};
> -
> -static struct gpio_keys_platform_data foxg20_button_data = {
> -	.buttons	= foxg20_buttons,
> -	.nbuttons	= ARRAY_SIZE(foxg20_buttons),
> -};
> -
> -static struct platform_device foxg20_button_device = {
> -	.name		= "gpio-keys",
> -	.id		= -1,
> -	.num_resources	= 0,
> -	.dev		= {
> -		.platform_data	= &foxg20_button_data,
> -	}
> -};
> -
> -static void __init foxg20_add_device_buttons(void)
> -{
> -	at91_set_gpio_input(AT91_PIN_PC4, 1);	/* btn1 */
> -	at91_set_deglitch(AT91_PIN_PC4, 1);
> -
> -	platform_device_register(&foxg20_button_device);
> -}
> -#else
> -static void __init foxg20_add_device_buttons(void) {}
> -#endif
> -
> -
> -#if defined(CONFIG_W1_MASTER_GPIO) || defined(CONFIG_W1_MASTER_GPIO_MODULE)
> -static struct w1_gpio_platform_data w1_gpio_pdata = {
> -	/* If you choose to use a pin other than PB16 it needs to be 3.3V */
> -	.pin		= AT91_PIN_PB16,
> -	.is_open_drain  = 1,
> -	.ext_pullup_enable_pin	= -EINVAL,
> -};
> -
> -static struct platform_device w1_device = {
> -	.name			= "w1-gpio",
> -	.id			= -1,
> -	.dev.platform_data	= &w1_gpio_pdata,
> -};
> -
> -static void __init at91_add_device_w1(void)
> -{
> -	at91_set_GPIO_periph(w1_gpio_pdata.pin, 1);
> -	at91_set_multi_drive(w1_gpio_pdata.pin, 1);
> -	platform_device_register(&w1_device);
> -}
> -
> -#endif
> -
> -
> -static struct i2c_board_info __initdata foxg20_i2c_devices[] = {
> -	{
> -		I2C_BOARD_INFO("24c512", 0x50),
> -	},
> -};
> -
> -
> -static void __init foxg20_board_init(void)
> -{
> -	/* Serial */
> -	/* DBGU on ttyS0. (Rx & Tx only) */
> -	at91_register_uart(0, 0, 0);
> -
> -	/* USART0 on ttyS1. (Rx, Tx, CTS, RTS, DTR, DSR, DCD, RI) */
> -	at91_register_uart(AT91SAM9260_ID_US0, 1,
> -				ATMEL_UART_CTS
> -				| ATMEL_UART_RTS
> -				| ATMEL_UART_DTR
> -				| ATMEL_UART_DSR
> -				| ATMEL_UART_DCD
> -				| ATMEL_UART_RI);
> -
> -	/* USART1 on ttyS2. (Rx, Tx, RTS, CTS) */
> -	at91_register_uart(AT91SAM9260_ID_US1, 2,
> -		ATMEL_UART_CTS
> -		| ATMEL_UART_RTS);
> -
> -	/* USART2 on ttyS3. (Rx & Tx only) */
> -	at91_register_uart(AT91SAM9260_ID_US2, 3, 0);
> -
> -	/* USART3 on ttyS4. (Rx, Tx, RTS, CTS) */
> -	at91_register_uart(AT91SAM9260_ID_US3, 4,
> -		ATMEL_UART_CTS
> -		| ATMEL_UART_RTS);
> -
> -	/* USART4 on ttyS5. (Rx & Tx only) */
> -	at91_register_uart(AT91SAM9260_ID_US4, 5, 0);
> -
> -	/* USART5 on ttyS6. (Rx & Tx only) */
> -	at91_register_uart(AT91SAM9260_ID_US5, 6, 0);
> -
> -	/* Set the internal pull-up resistor on DRXD */
> -	at91_set_A_periph(AT91_PIN_PB14, 1);
> -	at91_add_device_serial();
> -	/* USB Host */
> -	at91_add_device_usbh(&foxg20_usbh_data);
> -	/* USB Device */
> -	at91_add_device_udc(&foxg20_udc_data);
> -	/* SPI */
> -	at91_add_device_spi(foxg20_spi_devices, ARRAY_SIZE(foxg20_spi_devices));
> -	/* Ethernet */
> -	at91_add_device_eth(&foxg20_macb_data);
> -	/* MMC */
> -	at91_add_device_mci(0, &foxg20_mci0_data);
> -	/* I2C */
> -	at91_add_device_i2c(foxg20_i2c_devices, ARRAY_SIZE(foxg20_i2c_devices));
> -	/* LEDs */
> -	at91_gpio_leds(foxg20_leds, ARRAY_SIZE(foxg20_leds));
> -	/* Push Buttons */
> -	foxg20_add_device_buttons();
> -#if defined(CONFIG_W1_MASTER_GPIO) || defined(CONFIG_W1_MASTER_GPIO_MODULE)
> -	at91_add_device_w1();
> -#endif
> -}
> -
> -MACHINE_START(ACMENETUSFOXG20, "Acme Systems srl FOX Board G20")
> -	/* Maintainer: Sergio Tanzilli */
> -	.init_time	= at91sam926x_pit_init,
> -	.map_io		= at91_map_io,
> -	.handle_irq	= at91_aic_handle_irq,
> -	.init_early	= foxg20_init_early,
> -	.init_irq	= at91_init_irq_default,
> -	.init_machine	= foxg20_board_init,
> -MACHINE_END
> 


-- 
Nicolas Ferre
