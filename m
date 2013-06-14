Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3FNWME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 18:12:04 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:53552 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab3FNWMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 18:12:02 -0400
Message-ID: <51BB952C.2070209@atmel.com>
Date: Sat, 15 Jun 2013 00:11:56 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <ludovic.desroches@atmel.com>, <vinod.koul@intel.com>, <arnd@arndb.de>,
        <olof@lixom.net>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v3 1/2] ARM: at91: dt: add header to define at_hdmac configuration
References: <1371112779-22738-1-git-send-email-ludovic.desroches@atmel.com> <1371112779-22738-2-git-send-email-ludovic.desroches@atmel.com>
In-Reply-To: <1371112779-22738-2-git-send-email-ludovic.desroches@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/2013 10:39, ludovic.desroches@atmel.com :
> From: Ludovic Desroches <ludovic.desroches@atmel.com>
>
> DMA-cell content is a concatenation of several values. In order to keep this
> stuff human readable, macros are introduced.
>
> The values for the FIFO configuration are not the same as the ones used in the
> configuration register in order to keep backward compatibility. Most devices
> use the half FIFO configuration but USART ones have to use the ASAP
> configuration. This parameter was not initially planed to be into the at91 dma
> dt binding. The third cell will be used to store this parameter, it will
> become a concatenation of the FIFO configuration and of the peripheral ID. In
> order to keep backward compatibility i.e. FIFO configuration is equal to 0, we
> have to perform a translation since the value to put in the register to set
> half FIFO is 1.
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>

Of course:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

In addition to going through slave-dma Vinod's git tree, I also stack it 
on the AT91 DT branch so that it can go in arm-soc and prevent a 
dependency between the two trees that could lead to a build error...

Best regards,

> ---
>   include/dt-bindings/dma/at91.h | 27 +++++++++++++++++++++++++++
>   1 file changed, 27 insertions(+)
>   create mode 100644 include/dt-bindings/dma/at91.h
>
> diff --git a/include/dt-bindings/dma/at91.h b/include/dt-bindings/dma/at91.h
> new file mode 100644
> index 0000000..e835037
> --- /dev/null
> +++ b/include/dt-bindings/dma/at91.h
> @@ -0,0 +1,27 @@
> +/*
> + * This header provides macros for at91 dma bindings.
> + *
> + * Copyright (C) 2013 Ludovic Desroches <ludovic.desroches@atmel.com>
> + *
> + * GPLv2 only
> + */
> +
> +#ifndef __DT_BINDINGS_AT91_DMA_H__
> +#define __DT_BINDINGS_AT91_DMA_H__
> +
> +/*
> + * Source and/or destination peripheral ID
> + */
> +#define AT91_DMA_CFG_PER_ID_MASK	(0xff)
> +#define AT91_DMA_CFG_PER_ID(id)		(id & AT91_DMA_CFG_PER_ID_MASK)
> +
> +/*
> + * FIFO configuration: it defines when a request is serviced.
> + */
> +#define AT91_DMA_CFG_FIFOCFG_OFFSET	(8)
> +#define AT91_DMA_CFG_FIFOCFG_MASK	(0xf << AT91_DMA_CFG_FIFOCFG_OFFSET)
> +#define AT91_DMA_CFG_FIFOCFG_HALF	(0x0 << AT91_DMA_CFG_FIFOCFG_OFFSET)	/* half FIFO (default behavior) */
> +#define AT91_DMA_CFG_FIFOCFG_ALAP	(0x1 << AT91_DMA_CFG_FIFOCFG_OFFSET)	/* largest defined AHB burst */
> +#define AT91_DMA_CFG_FIFOCFG_ASAP	(0x2 << AT91_DMA_CFG_FIFOCFG_OFFSET)	/* single AHB access */
> +
> +#endif /* __DT_BINDINGS_AT91_DMA_H__ */
>


-- 
Nicolas Ferre
