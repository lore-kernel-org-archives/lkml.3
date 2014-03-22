Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaCVMdZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 08:33:25 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:53375 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaCVMdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 08:33:24 -0400
Message-ID: <532D8354.7090909@kernel.org>
Date: Sat, 22 Mar 2014 12:34:28 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 06/15] iio: adc: at91: remove unused include from include/mach
References: <1395064628-644-1-git-send-email-alexandre.belloni@free-electrons.com> <1395064628-644-7-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1395064628-644-7-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/03/14 13:56, Alexandre Belloni wrote:
> That include file is now only used by the at91_adc driver, remove it from
> include/mach for better driver separation.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>
> ---
>   arch/arm/mach-at91/include/mach/at91_adc.h | 120 -----------------------------
>   drivers/iio/adc/at91_adc.c                 | 103 ++++++++++++++++++++++++-
>   2 files changed, 102 insertions(+), 121 deletions(-)
>   delete mode 100644 arch/arm/mach-at91/include/mach/at91_adc.h
>
> diff --git a/arch/arm/mach-at91/include/mach/at91_adc.h b/arch/arm/mach-at91/include/mach/at91_adc.h
> deleted file mode 100644
> index 7d80396346b2..000000000000
> --- a/arch/arm/mach-at91/include/mach/at91_adc.h
> +++ /dev/null
> @@ -1,120 +0,0 @@
> -/*
> - * arch/arm/mach-at91/include/mach/at91_adc.h
> - *
> - * Copyright (C) SAN People
> - *
> - * Analog-to-Digital Converter (ADC) registers.
> - * Based on AT91SAM9260 datasheet revision D.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - */
> -
> -#ifndef AT91_ADC_H
> -#define AT91_ADC_H
> -
> -#define AT91_ADC_CR		0x00		/* Control Register */
> -#define		AT91_ADC_SWRST		(1 << 0)	/* Software Reset */
> -#define		AT91_ADC_START		(1 << 1)	/* Start Conversion */
> -
> -#define AT91_ADC_MR		0x04		/* Mode Register */
> -#define		AT91_ADC_TSAMOD		(3 << 0)	/* ADC mode */
> -#define		AT91_ADC_TSAMOD_ADC_ONLY_MODE		(0 << 0)	/* ADC Mode */
> -#define		AT91_ADC_TSAMOD_TS_ONLY_MODE		(1 << 0)	/* Touch Screen Only Mode */
> -#define		AT91_ADC_TRGEN		(1 << 0)	/* Trigger Enable */
> -#define		AT91_ADC_TRGSEL		(7 << 1)	/* Trigger Selection */
> -#define			AT91_ADC_TRGSEL_TC0		(0 << 1)
> -#define			AT91_ADC_TRGSEL_TC1		(1 << 1)
> -#define			AT91_ADC_TRGSEL_TC2		(2 << 1)
> -#define			AT91_ADC_TRGSEL_EXTERNAL	(6 << 1)
> -#define		AT91_ADC_LOWRES		(1 << 4)	/* Low Resolution */
> -#define		AT91_ADC_SLEEP		(1 << 5)	/* Sleep Mode */
> -#define		AT91_ADC_PENDET		(1 << 6)	/* Pen contact detection enable */
> -#define		AT91_ADC_PRESCAL_9260	(0x3f << 8)	/* Prescalar Rate Selection */
> -#define		AT91_ADC_PRESCAL_9G45	(0xff << 8)
> -#define			AT91_ADC_PRESCAL_(x)	((x) << 8)
> -#define		AT91_ADC_STARTUP_9260	(0x1f << 16)	/* Startup Up Time */
> -#define		AT91_ADC_STARTUP_9G45	(0x7f << 16)
> -#define		AT91_ADC_STARTUP_9X5	(0xf << 16)
> -#define			AT91_ADC_STARTUP_(x)	((x) << 16)
> -#define		AT91_ADC_SHTIM		(0xf  << 24)	/* Sample & Hold Time */
> -#define			AT91_ADC_SHTIM_(x)	((x) << 24)
> -#define		AT91_ADC_PENDBC		(0x0f << 28)	/* Pen Debounce time */
> -#define			AT91_ADC_PENDBC_(x)	((x) << 28)
> -
> -#define AT91_ADC_TSR		0x0C
> -#define		AT91_ADC_TSR_SHTIM	(0xf  << 24)	/* Sample & Hold Time */
> -#define			AT91_ADC_TSR_SHTIM_(x)	((x) << 24)
> -
> -#define AT91_ADC_CHER		0x10		/* Channel Enable Register */
> -#define AT91_ADC_CHDR		0x14		/* Channel Disable Register */
> -#define AT91_ADC_CHSR		0x18		/* Channel Status Register */
> -#define		AT91_ADC_CH(n)		(1 << (n))	/* Channel Number */
> -
> -#define AT91_ADC_SR		0x1C		/* Status Register */
> -#define		AT91_ADC_EOC(n)		(1 << (n))	/* End of Conversion on Channel N */
> -#define		AT91_ADC_OVRE(n)	(1 << ((n) + 8))/* Overrun Error on Channel N */
> -#define		AT91_ADC_DRDY		(1 << 16)	/* Data Ready */
> -#define		AT91_ADC_GOVRE		(1 << 17)	/* General Overrun Error */
> -#define		AT91_ADC_ENDRX		(1 << 18)	/* End of RX Buffer */
> -#define		AT91_ADC_RXFUFF		(1 << 19)	/* RX Buffer Full */
> -
> -#define AT91_ADC_SR_9X5		0x30		/* Status Register for 9x5 */
> -#define		AT91_ADC_SR_DRDY_9X5	(1 << 24)	/* Data Ready */
> -
> -#define AT91_ADC_LCDR		0x20		/* Last Converted Data Register */
> -#define		AT91_ADC_LDATA		(0x3ff)
> -
> -#define AT91_ADC_IER		0x24		/* Interrupt Enable Register */
> -#define AT91_ADC_IDR		0x28		/* Interrupt Disable Register */
> -#define AT91_ADC_IMR		0x2C		/* Interrupt Mask Register */
> -#define		AT91RL_ADC_IER_PEN	(1 << 20)
> -#define		AT91RL_ADC_IER_NOPEN	(1 << 21)
> -#define		AT91_ADC_IER_PEN	(1 << 29)
> -#define		AT91_ADC_IER_NOPEN	(1 << 30)
> -#define		AT91_ADC_IER_XRDY	(1 << 20)
> -#define		AT91_ADC_IER_YRDY	(1 << 21)
> -#define		AT91_ADC_IER_PRDY	(1 << 22)
> -#define		AT91_ADC_ISR_PENS	(1 << 31)
> -
> -#define AT91_ADC_CHR(n)		(0x30 + ((n) * 4))	/* Channel Data Register N */
> -#define		AT91_ADC_DATA		(0x3ff)
> -
> -#define AT91_ADC_CDR0_9X5	(0x50)			/* Channel Data Register 0 for 9X5 */
> -
> -#define AT91_ADC_ACR		0x94	/* Analog Control Register */
> -#define		AT91_ADC_ACR_PENDETSENS	(0x3 << 0)	/* pull-up resistor */
> -
> -#define AT91_ADC_TSMR		0xB0
> -#define		AT91_ADC_TSMR_TSMODE	(3 << 0)	/* Touch Screen Mode */
> -#define			AT91_ADC_TSMR_TSMODE_NONE		(0 << 0)
> -#define			AT91_ADC_TSMR_TSMODE_4WIRE_NO_PRESS	(1 << 0)
> -#define			AT91_ADC_TSMR_TSMODE_4WIRE_PRESS	(2 << 0)
> -#define			AT91_ADC_TSMR_TSMODE_5WIRE		(3 << 0)
> -#define		AT91_ADC_TSMR_TSAV	(3 << 4)	/* Averages samples */
> -#define			AT91_ADC_TSMR_TSAV_(x)		((x) << 4)
> -#define		AT91_ADC_TSMR_SCTIM	(0x0f << 16)	/* Switch closure time */
> -#define		AT91_ADC_TSMR_PENDBC	(0x0f << 28)	/* Pen Debounce time */
> -#define			AT91_ADC_TSMR_PENDBC_(x)	((x) << 28)
> -#define		AT91_ADC_TSMR_NOTSDMA	(1 << 22)	/* No Touchscreen DMA */
> -#define		AT91_ADC_TSMR_PENDET_DIS	(0 << 24)	/* Pen contact detection disable */
> -#define		AT91_ADC_TSMR_PENDET_ENA	(1 << 24)	/* Pen contact detection enable */
> -
> -#define AT91_ADC_TSXPOSR	0xB4
> -#define AT91_ADC_TSYPOSR	0xB8
> -#define AT91_ADC_TSPRESSR	0xBC
> -
> -#define AT91_ADC_TRGR_9260	AT91_ADC_MR
> -#define AT91_ADC_TRGR_9G45	0x08
> -#define AT91_ADC_TRGR_9X5	0xC0
> -
> -/* Trigger Register bit field */
> -#define		AT91_ADC_TRGR_TRGPER	(0xffff << 16)
> -#define			AT91_ADC_TRGR_TRGPER_(x)	((x) << 16)
> -#define		AT91_ADC_TRGR_TRGMOD	(0x7 << 0)
> -#define			AT91_ADC_TRGR_NONE		(0 << 0)
> -#define			AT91_ADC_TRGR_MOD_PERIOD_TRIG	(5 << 0)
> -
> -#endif
> diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
> index c0e4206e34e5..a51b8badbf8e 100644
> --- a/drivers/iio/adc/at91_adc.c
> +++ b/drivers/iio/adc/at91_adc.c
> @@ -31,7 +31,108 @@
>   #include <linux/iio/trigger_consumer.h>
>   #include <linux/iio/triggered_buffer.h>
>
> -#include <mach/at91_adc.h>
> +/* Registers */
> +#define AT91_ADC_CR		0x00		/* Control Register */
> +#define		AT91_ADC_SWRST		(1 << 0)	/* Software Reset */
> +#define		AT91_ADC_START		(1 << 1)	/* Start Conversion */
> +
> +#define AT91_ADC_MR		0x04		/* Mode Register */
> +#define		AT91_ADC_TSAMOD		(3 << 0)	/* ADC mode */
> +#define		AT91_ADC_TSAMOD_ADC_ONLY_MODE		(0 << 0)	/* ADC Mode */
> +#define		AT91_ADC_TSAMOD_TS_ONLY_MODE		(1 << 0)	/* Touch Screen Only Mode */
> +#define		AT91_ADC_TRGEN		(1 << 0)	/* Trigger Enable */
> +#define		AT91_ADC_TRGSEL		(7 << 1)	/* Trigger Selection */
> +#define			AT91_ADC_TRGSEL_TC0		(0 << 1)
> +#define			AT91_ADC_TRGSEL_TC1		(1 << 1)
> +#define			AT91_ADC_TRGSEL_TC2		(2 << 1)
> +#define			AT91_ADC_TRGSEL_EXTERNAL	(6 << 1)
> +#define		AT91_ADC_LOWRES		(1 << 4)	/* Low Resolution */
> +#define		AT91_ADC_SLEEP		(1 << 5)	/* Sleep Mode */
> +#define		AT91_ADC_PENDET		(1 << 6)	/* Pen contact detection enable */
> +#define		AT91_ADC_PRESCAL_9260	(0x3f << 8)	/* Prescalar Rate Selection */
> +#define		AT91_ADC_PRESCAL_9G45	(0xff << 8)
> +#define			AT91_ADC_PRESCAL_(x)	((x) << 8)
> +#define		AT91_ADC_STARTUP_9260	(0x1f << 16)	/* Startup Up Time */
> +#define		AT91_ADC_STARTUP_9G45	(0x7f << 16)
> +#define		AT91_ADC_STARTUP_9X5	(0xf << 16)
> +#define			AT91_ADC_STARTUP_(x)	((x) << 16)
> +#define		AT91_ADC_SHTIM		(0xf  << 24)	/* Sample & Hold Time */
> +#define			AT91_ADC_SHTIM_(x)	((x) << 24)
> +#define		AT91_ADC_PENDBC		(0x0f << 28)	/* Pen Debounce time */
> +#define			AT91_ADC_PENDBC_(x)	((x) << 28)
> +
> +#define AT91_ADC_TSR		0x0C
> +#define		AT91_ADC_TSR_SHTIM	(0xf  << 24)	/* Sample & Hold Time */
> +#define			AT91_ADC_TSR_SHTIM_(x)	((x) << 24)
> +
> +#define AT91_ADC_CHER		0x10		/* Channel Enable Register */
> +#define AT91_ADC_CHDR		0x14		/* Channel Disable Register */
> +#define AT91_ADC_CHSR		0x18		/* Channel Status Register */
> +#define		AT91_ADC_CH(n)		(1 << (n))	/* Channel Number */
> +
> +#define AT91_ADC_SR		0x1C		/* Status Register */
> +#define		AT91_ADC_EOC(n)		(1 << (n))	/* End of Conversion on Channel N */
> +#define		AT91_ADC_OVRE(n)	(1 << ((n) + 8))/* Overrun Error on Channel N */
> +#define		AT91_ADC_DRDY		(1 << 16)	/* Data Ready */
> +#define		AT91_ADC_GOVRE		(1 << 17)	/* General Overrun Error */
> +#define		AT91_ADC_ENDRX		(1 << 18)	/* End of RX Buffer */
> +#define		AT91_ADC_RXFUFF		(1 << 19)	/* RX Buffer Full */
> +
> +#define AT91_ADC_SR_9X5		0x30		/* Status Register for 9x5 */
> +#define		AT91_ADC_SR_DRDY_9X5	(1 << 24)	/* Data Ready */
> +
> +#define AT91_ADC_LCDR		0x20		/* Last Converted Data Register */
> +#define		AT91_ADC_LDATA		(0x3ff)
> +
> +#define AT91_ADC_IER		0x24		/* Interrupt Enable Register */
> +#define AT91_ADC_IDR		0x28		/* Interrupt Disable Register */
> +#define AT91_ADC_IMR		0x2C		/* Interrupt Mask Register */
> +#define		AT91RL_ADC_IER_PEN	(1 << 20)
> +#define		AT91RL_ADC_IER_NOPEN	(1 << 21)
> +#define		AT91_ADC_IER_PEN	(1 << 29)
> +#define		AT91_ADC_IER_NOPEN	(1 << 30)
> +#define		AT91_ADC_IER_XRDY	(1 << 20)
> +#define		AT91_ADC_IER_YRDY	(1 << 21)
> +#define		AT91_ADC_IER_PRDY	(1 << 22)
> +#define		AT91_ADC_ISR_PENS	(1 << 31)
> +
> +#define AT91_ADC_CHR(n)		(0x30 + ((n) * 4))	/* Channel Data Register N */
> +#define		AT91_ADC_DATA		(0x3ff)
> +
> +#define AT91_ADC_CDR0_9X5	(0x50)			/* Channel Data Register 0 for 9X5 */
> +
> +#define AT91_ADC_ACR		0x94	/* Analog Control Register */
> +#define		AT91_ADC_ACR_PENDETSENS	(0x3 << 0)	/* pull-up resistor */
> +
> +#define AT91_ADC_TSMR		0xB0
> +#define		AT91_ADC_TSMR_TSMODE	(3 << 0)	/* Touch Screen Mode */
> +#define			AT91_ADC_TSMR_TSMODE_NONE		(0 << 0)
> +#define			AT91_ADC_TSMR_TSMODE_4WIRE_NO_PRESS	(1 << 0)
> +#define			AT91_ADC_TSMR_TSMODE_4WIRE_PRESS	(2 << 0)
> +#define			AT91_ADC_TSMR_TSMODE_5WIRE		(3 << 0)
> +#define		AT91_ADC_TSMR_TSAV	(3 << 4)	/* Averages samples */
> +#define			AT91_ADC_TSMR_TSAV_(x)		((x) << 4)
> +#define		AT91_ADC_TSMR_SCTIM	(0x0f << 16)	/* Switch closure time */
> +#define		AT91_ADC_TSMR_PENDBC	(0x0f << 28)	/* Pen Debounce time */
> +#define			AT91_ADC_TSMR_PENDBC_(x)	((x) << 28)
> +#define		AT91_ADC_TSMR_NOTSDMA	(1 << 22)	/* No Touchscreen DMA */
> +#define		AT91_ADC_TSMR_PENDET_DIS	(0 << 24)	/* Pen contact detection disable */
> +#define		AT91_ADC_TSMR_PENDET_ENA	(1 << 24)	/* Pen contact detection enable */
> +
> +#define AT91_ADC_TSXPOSR	0xB4
> +#define AT91_ADC_TSYPOSR	0xB8
> +#define AT91_ADC_TSPRESSR	0xBC
> +
> +#define AT91_ADC_TRGR_9260	AT91_ADC_MR
> +#define AT91_ADC_TRGR_9G45	0x08
> +#define AT91_ADC_TRGR_9X5	0xC0
> +
> +/* Trigger Register bit field */
> +#define		AT91_ADC_TRGR_TRGPER	(0xffff << 16)
> +#define			AT91_ADC_TRGR_TRGPER_(x)	((x) << 16)
> +#define		AT91_ADC_TRGR_TRGMOD	(0x7 << 0)
> +#define			AT91_ADC_TRGR_NONE		(0 << 0)
> +#define			AT91_ADC_TRGR_MOD_PERIOD_TRIG	(5 << 0)
>
>   #define AT91_ADC_CHAN(st, ch) \
>   	(st->registers->channel_base + (ch * 4))
>

