Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab3EJIWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:22:24 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:26918 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab3EJIWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:22:21 -0400
Message-ID: <518CAE3B.1090205@atmel.com>
Date: Fri, 10 May 2013 10:22:19 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: <linux-kernel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH 07/12] net/ethernet: ARM_AT91_ETHER should depend on HAS_DMA
References: <1368133494-22198-1-git-send-email-geert@linux-m68k.org> <1368133494-22198-7-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1368133494-22198-7-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2013 23:04, Geert Uytterhoeven :
> If NO_DMA=y:
>
> drivers/built-in.o: In function `at91ether_start':
> drivers/net/ethernet/cadence/at91_ether.c:49: undefined reference to `dma_alloc_coherent'
> drivers/net/ethernet/cadence/at91_ether.c:60: undefined reference to `dma_free_coherent'
> drivers/built-in.o: In function `at91ether_interrupt':
> drivers/net/ethernet/cadence/at91_ether.c:250: undefined reference to `dma_unmap_single'
> drivers/built-in.o: In function `at91ether_start_xmit':
> drivers/net/ethernet/cadence/at91_ether.c:169: undefined reference to `dma_map_single'
> drivers/built-in.o: In function `at91ether_close':
> drivers/net/ethernet/cadence/at91_ether.c:145: undefined reference to `dma_free_coherent'
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> ---
>   drivers/net/ethernet/cadence/Kconfig |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
> index 1194446..0d9d6e6 100644
> --- a/drivers/net/ethernet/cadence/Kconfig
> +++ b/drivers/net/ethernet/cadence/Kconfig
> @@ -22,7 +22,7 @@ if NET_CADENCE
>
>   config ARM_AT91_ETHER
>   	tristate "AT91RM9200 Ethernet support"
> -	depends on GENERIC_HARDIRQS
> +	depends on GENERIC_HARDIRQS && HAS_DMA
>   	select NET_CORE
>   	select MACB
>   	---help---
>


-- 
Nicolas Ferre
