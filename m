Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab3EJIWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:22:39 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:57051 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3EJIWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:22:36 -0400
Message-ID: <518CAE4A.4060902@atmel.com>
Date: Fri, 10 May 2013 10:22:34 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: <linux-kernel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH 08/12] net/ethernet: MACB should depend on HAS_DMA
References: <1368133494-22198-1-git-send-email-geert@linux-m68k.org> <1368133494-22198-8-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1368133494-22198-8-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 23:04, Geert Uytterhoeven :
> If NO_DMA=y:
>
> drivers/built-in.o: In function `macb_free_consistent':
> drivers/net/ethernet/cadence/macb.c:878: undefined reference to `dma_free_coherent'
> drivers/net/ethernet/cadence/macb.c:883: undefined reference to `dma_free_coherent'
> drivers/net/ethernet/cadence/macb.c:888: undefined reference to `dma_free_coherent'
> drivers/built-in.o: In function `macb_alloc_consistent':
> drivers/net/ethernet/cadence/macb.c:905: undefined reference to `dma_alloc_coherent'
> drivers/built-in.o: In function `macb_tx_interrupt':
> drivers/net/ethernet/cadence/macb.c:515: undefined reference to `dma_unmap_single'
> drivers/built-in.o: In function `macb_tx_error_task':
> drivers/net/ethernet/cadence/macb.c:457: undefined reference to `dma_unmap_single'
> drivers/built-in.o: In function `macb_start_xmit':
> drivers/net/ethernet/cadence/macb.c:838: undefined reference to `dma_map_single'
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> ---
>   drivers/net/ethernet/cadence/Kconfig |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
> index 0d9d6e6..768285e 100644
> --- a/drivers/net/ethernet/cadence/Kconfig
> +++ b/drivers/net/ethernet/cadence/Kconfig
> @@ -31,6 +31,7 @@ config ARM_AT91_ETHER
>
>   config MACB
>   	tristate "Cadence MACB/GEM support"
> +	depends on HAS_DMA
>   	select PHYLIB
>   	---help---
>   	  The Cadence MACB ethernet interface is found on many Atmel AT32 and
>


-- 
Nicolas Ferre
