Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbaH1Mp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 08:45:58 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:61952 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaH1Mp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 08:45:57 -0400
Date: Thu, 28 Aug 2014 13:45:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/linux/mfd/ti_ssp.h: Remove unused header
Message-ID: <20140828124552.GU24579@lee--X1>
References: <1409226770-3317-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409226770-3317-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2014, Rasmus Villemoes wrote:

> The header file include/linux/mfd/ti_ssp.h does not seem to be used
> anywhere. It was orphaned by 3033ee62 "mfd: Remove obsolete ti-ssp
> driver". Remove it.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  include/linux/mfd/ti_ssp.h | 93 ----------------------------------------------
>  1 file changed, 93 deletions(-)
>  delete mode 100644 include/linux/mfd/ti_ssp.h

Patch applied with a properly formatted $SUBJECT line.

> diff --git a/include/linux/mfd/ti_ssp.h b/include/linux/mfd/ti_ssp.h
> deleted file mode 100644
> index dbb4b43..0000000
> --- a/include/linux/mfd/ti_ssp.h
> +++ /dev/null
> @@ -1,93 +0,0 @@
> -/*
> - * Sequencer Serial Port (SSP) driver for Texas Instruments' SoCs
> - *
> - * Copyright (C) 2010 Texas Instruments Inc
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
> -#ifndef __TI_SSP_H__
> -#define __TI_SSP_H__
> -
> -struct ti_ssp_dev_data {
> -	const char	*dev_name;
> -	void		*pdata;
> -	size_t		pdata_size;
> -};
> -
> -struct ti_ssp_data {
> -	unsigned long		out_clock;
> -	struct ti_ssp_dev_data	dev_data[2];
> -};
> -
> -struct ti_ssp_spi_data {
> -	unsigned long	iosel;
> -	int		num_cs;
> -	void		(*select)(int cs);
> -};
> -
> -/*
> - * Sequencer port IO pin configuration bits.  These do not correlate 1-1 with
> - * the hardware.  The iosel field in the port data combines iosel1 and iosel2,
> - * and is therefore not a direct map to register space.  It is best to use the
> - * macros below to construct iosel values.
> - *
> - * least significant 16 bits --> iosel1
> - * most significant 16 bits  --> iosel2
> - */
> -
> -#define SSP_IN			0x0000
> -#define SSP_DATA		0x0001
> -#define SSP_CLOCK		0x0002
> -#define SSP_CHIPSEL		0x0003
> -#define SSP_OUT			0x0004
> -#define SSP_PIN_SEL(pin, v)	((v) << ((pin) * 3))
> -#define SSP_PIN_MASK(pin)	SSP_PIN_SEL(pin, 0x7)
> -#define SSP_INPUT_SEL(pin)	((pin) << 16)
> -
> -/* Sequencer port config bits */
> -#define SSP_EARLY_DIN		BIT(8)
> -#define SSP_DELAY_DOUT		BIT(9)
> -
> -/* Sequence map definitions */
> -#define SSP_CLK_HIGH		BIT(0)
> -#define SSP_CLK_LOW		0
> -#define SSP_DATA_HIGH		BIT(1)
> -#define SSP_DATA_LOW		0
> -#define SSP_CS_HIGH		BIT(2)
> -#define SSP_CS_LOW		0
> -#define SSP_OUT_MODE		BIT(3)
> -#define SSP_IN_MODE		0
> -#define SSP_DATA_REG		BIT(4)
> -#define SSP_ADDR_REG		0
> -
> -#define SSP_OPCODE_DIRECT	((0x0) << 5)
> -#define SSP_OPCODE_TOGGLE	((0x1) << 5)
> -#define SSP_OPCODE_SHIFT	((0x2) << 5)
> -#define SSP_OPCODE_BRANCH0	((0x4) << 5)
> -#define SSP_OPCODE_BRANCH1	((0x5) << 5)
> -#define SSP_OPCODE_BRANCH	((0x6) << 5)
> -#define SSP_OPCODE_STOP		((0x7) << 5)
> -#define SSP_BRANCH(addr)	((addr) << 8)
> -#define SSP_COUNT(cycles)	((cycles) << 8)
> -
> -int ti_ssp_raw_read(struct device *dev);
> -int ti_ssp_raw_write(struct device *dev, u32 val);
> -int ti_ssp_load(struct device *dev, int offs, u32* prog, int len);
> -int ti_ssp_run(struct device *dev, u32 pc, u32 input, u32 *output);
> -int ti_ssp_set_mode(struct device *dev, int mode);
> -int ti_ssp_set_iosel(struct device *dev, u32 iosel);
> -
> -#endif /* __TI_SSP_H__ */

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
