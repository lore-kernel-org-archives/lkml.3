Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbbARMyM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 07:54:12 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:51519 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbbARMyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 07:54:08 -0500
Date: Sun, 18 Jan 2015 12:53:52 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 03/12] mfd: syscon: Add atmel-smc registers definition
Message-ID: <20150118125352.GY3574@x1>
References: <1421252524-24452-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1421252524-24452-4-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421252524-24452-4-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015, Alexandre Belloni wrote:

> From: Boris Brezillon <boris.brezillon@free-electrons.com>
> 
> Atmel AT91 SoCs have a memory range reserved for SMC (Static Memory
> Controller) configuration.
> Expose those registers so that drivers can make use of the smc syscon
> declared in at91 DTs.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> ---
>  include/linux/mfd/syscon/atmel-smc.h | 173 +++++++++++++++++++++++++++++++++++
>  1 file changed, 173 insertions(+)
>  create mode 100644 include/linux/mfd/syscon/atmel-smc.h

Applied, thanks.
 
> diff --git a/include/linux/mfd/syscon/atmel-smc.h b/include/linux/mfd/syscon/atmel-smc.h
> new file mode 100644
> index 000000000000..be6ebe64eebe
> --- /dev/null
> +++ b/include/linux/mfd/syscon/atmel-smc.h
> @@ -0,0 +1,173 @@
> +/*
> + * Atmel SMC (Static Memory Controller) register offsets and bit definitions.
> + *
> + * Copyright (C) 2014 Atmel
> + * Copyright (C) 2014 Free Electrons
> + *
> + * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef _LINUX_MFD_SYSCON_ATMEL_SMC_H_
> +#define _LINUX_MFD_SYSCON_ATMEL_SMC_H_
> +
> +#include <linux/kernel.h>
> +#include <linux/regmap.h>
> +
> +#define AT91SAM9_SMC_GENERIC		0x00
> +#define AT91SAM9_SMC_GENERIC_BLK_SZ	0x10
> +
> +#define SAMA5_SMC_GENERIC		0x600
> +#define SAMA5_SMC_GENERIC_BLK_SZ	0x14
> +
> +#define AT91SAM9_SMC_SETUP(o)		((o) + 0x00)
> +#define AT91SAM9_SMC_NWESETUP(x)	(x)
> +#define AT91SAM9_SMC_NCS_WRSETUP(x)	((x) << 8)
> +#define AT91SAM9_SMC_NRDSETUP(x)	((x) << 16)
> +#define AT91SAM9_SMC_NCS_NRDSETUP(x)	((x) << 24)
> +
> +#define AT91SAM9_SMC_PULSE(o)		((o) + 0x04)
> +#define AT91SAM9_SMC_NWEPULSE(x)	(x)
> +#define AT91SAM9_SMC_NCS_WRPULSE(x)	((x) << 8)
> +#define AT91SAM9_SMC_NRDPULSE(x)	((x) << 16)
> +#define AT91SAM9_SMC_NCS_NRDPULSE(x)	((x) << 24)
> +
> +#define AT91SAM9_SMC_CYCLE(o)		((o) + 0x08)
> +#define AT91SAM9_SMC_NWECYCLE(x)	(x)
> +#define AT91SAM9_SMC_NRDCYCLE(x)	((x) << 16)
> +
> +#define AT91SAM9_SMC_MODE(o)		((o) + 0x0c)
> +#define SAMA5_SMC_MODE(o)		((o) + 0x10)
> +#define AT91_SMC_READMODE		BIT(0)
> +#define AT91_SMC_READMODE_NCS		(0 << 0)
> +#define AT91_SMC_READMODE_NRD		(1 << 0)
> +#define AT91_SMC_WRITEMODE		BIT(1)
> +#define AT91_SMC_WRITEMODE_NCS		(0 << 1)
> +#define AT91_SMC_WRITEMODE_NWE		(1 << 1)
> +#define AT91_SMC_EXNWMODE		GENMASK(5, 4)
> +#define AT91_SMC_EXNWMODE_DISABLE	(0 << 4)
> +#define AT91_SMC_EXNWMODE_FROZEN	(2 << 4)
> +#define AT91_SMC_EXNWMODE_READY		(3 << 4)
> +#define AT91_SMC_BAT			BIT(8)
> +#define AT91_SMC_BAT_SELECT		(0 << 8)
> +#define AT91_SMC_BAT_WRITE		(1 << 8)
> +#define AT91_SMC_DBW			GENMASK(13, 12)
> +#define AT91_SMC_DBW_8			(0 << 12)
> +#define AT91_SMC_DBW_16			(1 << 12)
> +#define AT91_SMC_DBW_32			(2 << 12)
> +#define AT91_SMC_TDF			GENMASK(19, 16)
> +#define AT91_SMC_TDF_(x)		((((x) - 1) << 16) & AT91_SMC_TDF)
> +#define AT91_SMC_TDF_MAX		16
> +#define AT91_SMC_TDFMODE_OPTIMIZED	BIT(20)
> +#define AT91_SMC_PMEN			BIT(24)
> +#define AT91_SMC_PS			GENMASK(29, 28)
> +#define AT91_SMC_PS_4			(0 << 28)
> +#define AT91_SMC_PS_8			(1 << 28)
> +#define AT91_SMC_PS_16			(2 << 28)
> +#define AT91_SMC_PS_32			(3 << 28)
> +
> +
> +/*
> + * This function converts a setup timing expressed in nanoseconds into an
> + * encoded value that can be written in the SMC_SETUP register.
> + *
> + * The following formula is described in atmel datasheets (section
> + * "SMC Setup Register"):
> + *
> + * setup length = (128* SETUP[5] + SETUP[4:0])
> + *
> + * where setup length is the timing expressed in cycles.
> + */
> +static inline u32 at91sam9_smc_setup_ns_to_cycles(unsigned int clk_rate,
> +						  u32 timing_ns)
> +{
> +	u32 clk_period = DIV_ROUND_UP(NSEC_PER_SEC, clk_rate);
> +	u32 coded_cycles = 0;
> +	u32 cycles;
> +
> +	cycles = DIV_ROUND_UP(timing_ns, clk_period);
> +	if (cycles / 32) {
> +		coded_cycles |= 1 << 5;
> +		if (cycles < 128)
> +			cycles = 0;
> +	}
> +
> +	coded_cycles |= cycles % 32;
> +
> +	return coded_cycles;
> +}
> +
> +/*
> + * This function converts a pulse timing expressed in nanoseconds into an
> + * encoded value that can be written in the SMC_PULSE register.
> + *
> + * The following formula is described in atmel datasheets (section
> + * "SMC Pulse Register"):
> + *
> + * pulse length = (256* PULSE[6] + PULSE[5:0])
> + *
> + * where pulse length is the timing expressed in cycles.
> + */
> +static inline u32 at91sam9_smc_pulse_ns_to_cycles(unsigned int clk_rate,
> +						  u32 timing_ns)
> +{
> +	u32 clk_period = DIV_ROUND_UP(NSEC_PER_SEC, clk_rate);
> +	u32 coded_cycles = 0;
> +	u32 cycles;
> +
> +	cycles = DIV_ROUND_UP(timing_ns, clk_period);
> +	if (cycles / 64) {
> +		coded_cycles |= 1 << 6;
> +		if (cycles < 256)
> +			cycles = 0;
> +	}
> +
> +	coded_cycles |= cycles % 64;
> +
> +	return coded_cycles;
> +}
> +
> +/*
> + * This function converts a cycle timing expressed in nanoseconds into an
> + * encoded value that can be written in the SMC_CYCLE register.
> + *
> + * The following formula is described in atmel datasheets (section
> + * "SMC Cycle Register"):
> + *
> + * cycle length = (CYCLE[8:7]*256 + CYCLE[6:0])
> + *
> + * where cycle length is the timing expressed in cycles.
> + */
> +static inline u32 at91sam9_smc_cycle_ns_to_cycles(unsigned int clk_rate,
> +						  u32 timing_ns)
> +{
> +	u32 clk_period = DIV_ROUND_UP(NSEC_PER_SEC, clk_rate);
> +	u32 coded_cycles = 0;
> +	u32 cycles;
> +
> +	cycles = DIV_ROUND_UP(timing_ns, clk_period);
> +	if (cycles / 128) {
> +		coded_cycles = cycles / 256;
> +		cycles %= 256;
> +		if (cycles >= 128) {
> +			coded_cycles++;
> +			cycles = 0;
> +		}
> +
> +		if (coded_cycles > 0x3) {
> +			coded_cycles = 0x3;
> +			cycles = 0x7f;
> +		}
> +
> +		coded_cycles <<= 7;
> +	}
> +
> +	coded_cycles |= cycles % 128;
> +
> +	return coded_cycles;
> +}
> +
> +#endif /* _LINUX_MFD_SYSCON_ATMEL_SMC_H_ */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
