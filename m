Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaLCJx1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:53:27 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:21688 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaLCJxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:53:24 -0500
Message-ID: <547EDD91.2000000@atmel.com>
Date: Wed, 3 Dec 2014 10:53:21 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Olof Johansson" <olof@lixom.net>, <arm@kernel.org>
Subject: Re: [PATCH 7/8] pinctrl: at91: add registers definitions directly
 into driver
References: <e093d7cf37ec9ff24b0631b0a2e405a7cf7574db.1417541118.git.nicolas.ferre@atmel.com> <720f350230a76bb5df0beed7b9a1b7cfd01ab158.1417541118.git.nicolas.ferre@atmel.com>
In-Reply-To: <720f350230a76bb5df0beed7b9a1b7cfd01ab158.1417541118.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02/12/2014 18:27, Nicolas Ferre a écrit :
> As the old gpio.c driver is gone, we can merge the registers definitions with
> the pinctrl driver.
> This also allows us to empty the AT91 include/mach directory.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>

Please disregard this patch as a similar one is already queued in
pinctrl git tree (pinctrl: at91: use own header) by Alexandre.

The file will be removed after both arm-soc and pinctrl git tree are
pulled by Linus (T.).

So the -rc1 time-frame seems the good one for this kind of dead code
removal action...

Bye,


> ---
>  arch/arm/mach-at91/include/mach/at91_pio.h | 80 ------------------------------
>  drivers/pinctrl/pinctrl-at91.c             | 65 ++++++++++++++++++++++--
>  2 files changed, 62 insertions(+), 83 deletions(-)
>  delete mode 100644 arch/arm/mach-at91/include/mach/at91_pio.h
> 
> diff --git a/arch/arm/mach-at91/include/mach/at91_pio.h b/arch/arm/mach-at91/include/mach/at91_pio.h
> deleted file mode 100644
> index 7b7366253ceb..000000000000
> --- a/arch/arm/mach-at91/include/mach/at91_pio.h
> +++ /dev/null
> @@ -1,80 +0,0 @@
> -/*
> - * arch/arm/mach-at91/include/mach/at91_pio.h
> - *
> - * Copyright (C) 2005 Ivan Kokshaysky
> - * Copyright (C) SAN People
> - *
> - * Parallel I/O Controller (PIO) - System peripherals registers.
> - * Based on AT91RM9200 datasheet revision E.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - */
> -
> -#ifndef AT91_PIO_H
> -#define AT91_PIO_H
> -
> -#define PIO_PER		0x00	/* Enable Register */
> -#define PIO_PDR		0x04	/* Disable Register */
> -#define PIO_PSR		0x08	/* Status Register */
> -#define PIO_OER		0x10	/* Output Enable Register */
> -#define PIO_ODR		0x14	/* Output Disable Register */
> -#define PIO_OSR		0x18	/* Output Status Register */
> -#define PIO_IFER	0x20	/* Glitch Input Filter Enable */
> -#define PIO_IFDR	0x24	/* Glitch Input Filter Disable */
> -#define PIO_IFSR	0x28	/* Glitch Input Filter Status */
> -#define PIO_SODR	0x30	/* Set Output Data Register */
> -#define PIO_CODR	0x34	/* Clear Output Data Register */
> -#define PIO_ODSR	0x38	/* Output Data Status Register */
> -#define PIO_PDSR	0x3c	/* Pin Data Status Register */
> -#define PIO_IER		0x40	/* Interrupt Enable Register */
> -#define PIO_IDR		0x44	/* Interrupt Disable Register */
> -#define PIO_IMR		0x48	/* Interrupt Mask Register */
> -#define PIO_ISR		0x4c	/* Interrupt Status Register */
> -#define PIO_MDER	0x50	/* Multi-driver Enable Register */
> -#define PIO_MDDR	0x54	/* Multi-driver Disable Register */
> -#define PIO_MDSR	0x58	/* Multi-driver Status Register */
> -#define PIO_PUDR	0x60	/* Pull-up Disable Register */
> -#define PIO_PUER	0x64	/* Pull-up Enable Register */
> -#define PIO_PUSR	0x68	/* Pull-up Status Register */
> -#define PIO_ASR		0x70	/* Peripheral A Select Register */
> -#define PIO_ABCDSR1	0x70	/* Peripheral ABCD Select Register 1 [some sam9 only] */
> -#define PIO_BSR		0x74	/* Peripheral B Select Register */
> -#define PIO_ABCDSR2	0x74	/* Peripheral ABCD Select Register 2 [some sam9 only] */
> -#define PIO_ABSR	0x78	/* AB Status Register */
> -#define PIO_IFSCDR	0x80	/* Input Filter Slow Clock Disable Register */
> -#define PIO_IFSCER	0x84	/* Input Filter Slow Clock Enable Register */
> -#define PIO_IFSCSR	0x88	/* Input Filter Slow Clock Status Register */
> -#define PIO_SCDR	0x8c	/* Slow Clock Divider Debouncing Register */
> -#define		PIO_SCDR_DIV	(0x3fff <<  0)		/* Slow Clock Divider Mask */
> -#define PIO_PPDDR	0x90	/* Pad Pull-down Disable Register */
> -#define PIO_PPDER	0x94	/* Pad Pull-down Enable Register */
> -#define PIO_PPDSR	0x98	/* Pad Pull-down Status Register */
> -#define PIO_OWER	0xa0	/* Output Write Enable Register */
> -#define PIO_OWDR	0xa4	/* Output Write Disable Register */
> -#define PIO_OWSR	0xa8	/* Output Write Status Register */
> -#define PIO_AIMER	0xb0	/* Additional Interrupt Modes Enable Register */
> -#define PIO_AIMDR	0xb4	/* Additional Interrupt Modes Disable Register */
> -#define PIO_AIMMR	0xb8	/* Additional Interrupt Modes Mask Register */
> -#define PIO_ESR		0xc0	/* Edge Select Register */
> -#define PIO_LSR		0xc4	/* Level Select Register */
> -#define PIO_ELSR	0xc8	/* Edge/Level Status Register */
> -#define PIO_FELLSR	0xd0	/* Falling Edge/Low Level Select Register */
> -#define PIO_REHLSR	0xd4	/* Rising Edge/ High Level Select Register */
> -#define PIO_FRLHSR	0xd8	/* Fall/Rise - Low/High Status Register */
> -#define PIO_SCHMITT	0x100	/* Schmitt Trigger Register */
> -
> -#define ABCDSR_PERIPH_A	0x0
> -#define ABCDSR_PERIPH_B	0x1
> -#define ABCDSR_PERIPH_C	0x2
> -#define ABCDSR_PERIPH_D	0x3
> -
> -#define SAMA5D3_PIO_DRIVER1		0x118  /*PIO Driver 1 register offset*/
> -#define SAMA5D3_PIO_DRIVER2		0x11C  /*PIO Driver 2 register offset*/
> -
> -#define AT91SAM9X5_PIO_DRIVER1	0x114  /*PIO Driver 1 register offset*/
> -#define AT91SAM9X5_PIO_DRIVER2	0x118  /*PIO Driver 2 register offset*/
> -
> -#endif
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index 354a81d40925..47d755861b5a 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -25,11 +25,70 @@
>  /* Since we request GPIOs from ourself */
>  #include <linux/pinctrl/consumer.h>
>  
> -#include <mach/hardware.h>
> -#include <mach/at91_pio.h>
> -
>  #include "core.h"
>  
> +/* PIO register definitions */
> +#define PIO_PER		0x00	/* Enable Register */
> +#define PIO_PDR		0x04	/* Disable Register */
> +#define PIO_PSR		0x08	/* Status Register */
> +#define PIO_OER		0x10	/* Output Enable Register */
> +#define PIO_ODR		0x14	/* Output Disable Register */
> +#define PIO_OSR		0x18	/* Output Status Register */
> +#define PIO_IFER	0x20	/* Glitch Input Filter Enable */
> +#define PIO_IFDR	0x24	/* Glitch Input Filter Disable */
> +#define PIO_IFSR	0x28	/* Glitch Input Filter Status */
> +#define PIO_SODR	0x30	/* Set Output Data Register */
> +#define PIO_CODR	0x34	/* Clear Output Data Register */
> +#define PIO_ODSR	0x38	/* Output Data Status Register */
> +#define PIO_PDSR	0x3c	/* Pin Data Status Register */
> +#define PIO_IER		0x40	/* Interrupt Enable Register */
> +#define PIO_IDR		0x44	/* Interrupt Disable Register */
> +#define PIO_IMR		0x48	/* Interrupt Mask Register */
> +#define PIO_ISR		0x4c	/* Interrupt Status Register */
> +#define PIO_MDER	0x50	/* Multi-driver Enable Register */
> +#define PIO_MDDR	0x54	/* Multi-driver Disable Register */
> +#define PIO_MDSR	0x58	/* Multi-driver Status Register */
> +#define PIO_PUDR	0x60	/* Pull-up Disable Register */
> +#define PIO_PUER	0x64	/* Pull-up Enable Register */
> +#define PIO_PUSR	0x68	/* Pull-up Status Register */
> +#define PIO_ASR		0x70	/* Peripheral A Select Register */
> +#define PIO_ABCDSR1	0x70	/* Peripheral ABCD Select Register 1 [some SoCs only] */
> +#define PIO_BSR		0x74	/* Peripheral B Select Register */
> +#define PIO_ABCDSR2	0x74	/* Peripheral ABCD Select Register 2 [some SoCs only] */
> +#define PIO_ABSR	0x78	/* AB Status Register */
> +#define PIO_IFSCDR	0x80	/* Input Filter Slow Clock Disable Register */
> +#define PIO_IFSCER	0x84	/* Input Filter Slow Clock Enable Register */
> +#define PIO_IFSCSR	0x88	/* Input Filter Slow Clock Status Register */
> +#define PIO_SCDR	0x8c	/* Slow Clock Divider Debouncing Register */
> +#define		PIO_SCDR_DIV	(0x3fff <<  0)		/* Slow Clock Divider Mask */
> +#define PIO_PPDDR	0x90	/* Pad Pull-down Disable Register */
> +#define PIO_PPDER	0x94	/* Pad Pull-down Enable Register */
> +#define PIO_PPDSR	0x98	/* Pad Pull-down Status Register */
> +#define PIO_OWER	0xa0	/* Output Write Enable Register */
> +#define PIO_OWDR	0xa4	/* Output Write Disable Register */
> +#define PIO_OWSR	0xa8	/* Output Write Status Register */
> +#define PIO_AIMER	0xb0	/* Additional Interrupt Modes Enable Register */
> +#define PIO_AIMDR	0xb4	/* Additional Interrupt Modes Disable Register */
> +#define PIO_AIMMR	0xb8	/* Additional Interrupt Modes Mask Register */
> +#define PIO_ESR		0xc0	/* Edge Select Register */
> +#define PIO_LSR		0xc4	/* Level Select Register */
> +#define PIO_ELSR	0xc8	/* Edge/Level Status Register */
> +#define PIO_FELLSR	0xd0	/* Falling Edge/Low Level Select Register */
> +#define PIO_REHLSR	0xd4	/* Rising Edge/ High Level Select Register */
> +#define PIO_FRLHSR	0xd8	/* Fall/Rise - Low/High Status Register */
> +#define PIO_SCHMITT	0x100	/* Schmitt Trigger Register */
> +
> +#define ABCDSR_PERIPH_A	0x0
> +#define ABCDSR_PERIPH_B	0x1
> +#define ABCDSR_PERIPH_C	0x2
> +#define ABCDSR_PERIPH_D	0x3
> +
> +#define SAMA5D3_PIO_DRIVER1		0x118  /*PIO Driver 1 register offset*/
> +#define SAMA5D3_PIO_DRIVER2		0x11C  /*PIO Driver 2 register offset*/
> +
> +#define AT91SAM9X5_PIO_DRIVER1	0x114  /*PIO Driver 1 register offset*/
> +#define AT91SAM9X5_PIO_DRIVER2	0x118  /*PIO Driver 2 register offset*/
> +
>  #define MAX_GPIO_BANKS		5
>  #define MAX_NB_GPIO_PER_BANK	32
>  
> 


-- 
Nicolas Ferre
