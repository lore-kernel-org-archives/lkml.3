Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbbAOQ3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:29:31 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:61430 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbbAOQ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:29:30 -0500
Message-ID: <54B7EAE4.3020107@linaro.org>
Date: Thu, 15 Jan 2015 17:29:24 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v3 8/8] ARM: at91: remove useless include
References: <1421077023-30954-1-git-send-email-alexandre.belloni@free-electrons.com> <1421077023-30954-9-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1421077023-30954-9-git-send-email-alexandre.belloni@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 04:37 PM, Alexandre Belloni wrote:
> Both drivers using the system timer are now converted to an MFD. mach/at91_st.h
> is now useless.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
>   arch/arm/mach-at91/include/mach/at91_st.h | 61 -------------------------------
>   1 file changed, 61 deletions(-)
>   delete mode 100644 arch/arm/mach-at91/include/mach/at91_st.h
>
> diff --git a/arch/arm/mach-at91/include/mach/at91_st.h b/arch/arm/mach-at91/include/mach/at91_st.h
> deleted file mode 100644
> index 67fdbd13c3ed..000000000000
> --- a/arch/arm/mach-at91/include/mach/at91_st.h
> +++ /dev/null
> @@ -1,61 +0,0 @@
> -/*
> - * arch/arm/mach-at91/include/mach/at91_st.h
> - *
> - * Copyright (C) 2005 Ivan Kokshaysky
> - * Copyright (C) SAN People
> - *
> - * System Timer (ST) - System peripherals registers.
> - * Based on AT91RM9200 datasheet revision E.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - */
> -
> -#ifndef AT91_ST_H
> -#define AT91_ST_H
> -
> -#ifndef __ASSEMBLY__
> -extern void __iomem *at91_st_base;
> -
> -#define at91_st_read(field) \
> -	__raw_readl(at91_st_base + field)
> -
> -#define at91_st_write(field, value) \
> -	__raw_writel(value, at91_st_base + field)
> -#else
> -.extern at91_st_base
> -#endif
> -
> -#define	AT91_ST_CR		0x00			/* Control Register */
> -#define 	AT91_ST_WDRST		(1 << 0)		/* Watchdog Timer Restart */
> -
> -#define	AT91_ST_PIMR		0x04			/* Period Interval Mode Register */
> -#define		AT91_ST_PIV		(0xffff <<  0)		/* Period Interval Value */
> -
> -#define	AT91_ST_WDMR		0x08			/* Watchdog Mode Register */
> -#define		AT91_ST_WDV		(0xffff <<  0)		/* Watchdog Counter Value */
> -#define		AT91_ST_RSTEN		(1	<< 16)		/* Reset Enable */
> -#define		AT91_ST_EXTEN		(1	<< 17)		/* External Signal Assertion Enable */
> -
> -#define	AT91_ST_RTMR		0x0c			/* Real-time Mode Register */
> -#define		AT91_ST_RTPRES		(0xffff <<  0)		/* Real-time Prescalar Value */
> -
> -#define	AT91_ST_SR		0x10			/* Status Register */
> -#define		AT91_ST_PITS		(1 << 0)		/* Period Interval Timer Status */
> -#define		AT91_ST_WDOVF		(1 << 1) 		/* Watchdog Overflow */
> -#define		AT91_ST_RTTINC		(1 << 2) 		/* Real-time Timer Increment */
> -#define		AT91_ST_ALMS		(1 << 3) 		/* Alarm Status */
> -
> -#define	AT91_ST_IER		0x14			/* Interrupt Enable Register */
> -#define	AT91_ST_IDR		0x18			/* Interrupt Disable Register */
> -#define	AT91_ST_IMR		0x1c			/* Interrupt Mask Register */
> -
> -#define	AT91_ST_RTAR		0x20			/* Real-time Alarm Register */
> -#define		AT91_ST_ALMV		(0xfffff << 0)		/* Alarm Value */
> -
> -#define	AT91_ST_CRTR		0x24			/* Current Real-time Register */
> -#define		AT91_ST_CRTV		(0xfffff << 0)		/* Current Real-Time Value */
> -
> -#endif
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

