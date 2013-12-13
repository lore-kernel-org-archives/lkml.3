Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab3LMOK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:10:59 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:62412 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab3LMOK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:10:57 -0500
Date: Fri, 13 Dec 2013 09:10:52 -0500
From: Matt Porter <mporter@linaro.org>
To: Marc Carino <marc.ceeeee@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Christian Daudt <bcm@fixthebug.org>,
        Arnd Bergmann <arnd@arndb.de>, Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] ARM: brcmstb: add infrastructure for ARM-based
 Broadcom STB SoCs
Message-ID: <20131213141052.GA23499@beef>
References: <1385511748-27869-1-git-send-email-marc.ceeeee@gmail.com>
 <1385511748-27869-2-git-send-email-marc.ceeeee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385511748-27869-2-git-send-email-marc.ceeeee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 04:22:23PM -0800, Marc Carino wrote:
> The BCM7xxx series of Broadcom SoCs are used primarily in set-top boxes.
> 
> This patch adds machine support for the ARM-based Broadcom SoCs.
> 
> Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>

<snip>

> diff --git a/arch/arm/mach-bcm/brcmstb.h b/arch/arm/mach-bcm/brcmstb.h
> new file mode 100644
> index 0000000..d08dffc
> --- /dev/null
> +++ b/arch/arm/mach-bcm/brcmstb.h
> @@ -0,0 +1,70 @@
> +/*
> + * Copyright (C) 2013 Broadcom Corporation
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __BRCMSTB_H__
> +#define __BRCMSTB_H__
> +
> +#if !defined(__ASSEMBLY__)
> +#include <linux/smp.h>
> +#endif
> +
> +#define BRCMSTB_PERIPH_VIRT				0xfc000000
> +#define BRCMSTB_PERIPH_PHYS				0xf0000000
> +#define BRCMSTB_PERIPH_LENGTH				0x02000000
> +
> +#define BVIRTADDR(x)	(BRCMSTB_PERIPH_VIRT + ((x) & 0x0fffffff))
> +#define BPHYSADDR(x)	((x) + BRCMSTB_PERIPH_PHYS)
> +
> +#define BCHP_UARTA_REG_START				0x00406b00
> +
> +#define BCHP_IRQ0_IRQEN					0x00406780
> +#define BCHP_IRQ0_IRQEN_uarta_irqen_MASK		0x00010000
> +#define BCHP_IRQ0_IRQEN_uartb_irqen_MASK		0x00020000
> +#define BCHP_IRQ0_IRQEN_uartc_irqen_MASK		0x00040000

These need to be all uppercase. Using bitops might be nice too.

-Matt
