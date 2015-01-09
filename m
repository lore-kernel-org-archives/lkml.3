Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbbAIPOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:14:07 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:27883 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932149AbbAIPOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:14:05 -0500
Message-ID: <54AFF037.1000004@atmel.com>
Date: Fri, 9 Jan 2015 16:13:59 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>, <gregkh@linuxfoundation.org>,
        <wenyou.yang@atmel.com>, <ludovic.desroches@atmel.com>,
        <leilei.zhao@atmel.com>, <voice.shen@atmel.com>, <josh.wu@atmel.com>,
        <linux-serial@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/5] tty/serial: at91: use correct type for dma_sync_*_for_cpu()
 and dma_sync_*_for_device()
References: <cover.1418131298.git.cyrille.pitchen@atmel.com> <830a2b33ab0226405dc310c8a6d43731bf4ca8f9.1418131298.git.cyrille.pitchen@atmel.com>
In-Reply-To: <830a2b33ab0226405dc310c8a6d43731bf4ca8f9.1418131298.git.cyrille.pitchen@atmel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 09/12/2014 14:31, Cyrille Pitchen a écrit :
> dma_sync_*_for_cpu() and dma_sync_*_for_device() use 'enum dma_data_direction',
> not 'enum dma_transfer_direction'
> 
> Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>

Sure:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Here it's difficult to add a "stable" tag as the error was introduced by
several different patches.

Thanks.

> ---
>  drivers/tty/serial/atmel_serial.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
> index 4d848a2..756f567 100644
> --- a/drivers/tty/serial/atmel_serial.c
> +++ b/drivers/tty/serial/atmel_serial.c
> @@ -794,7 +794,7 @@ static void atmel_tx_dma(struct uart_port *port)
>  			return;
>  		}
>  
> -		dma_sync_sg_for_device(port->dev, sg, 1, DMA_MEM_TO_DEV);
> +		dma_sync_sg_for_device(port->dev, sg, 1, DMA_TO_DEVICE);
>  
>  		atmel_port->desc_tx = desc;
>  		desc->callback = atmel_complete_tx_dma;
> @@ -927,7 +927,7 @@ static void atmel_rx_from_dma(struct uart_port *port)
>  	dma_sync_sg_for_cpu(port->dev,
>  			    &atmel_port->sg_rx,
>  			    1,
> -			    DMA_DEV_TO_MEM);
> +			    DMA_FROM_DEVICE);
>  
>  	/*
>  	 * ring->head points to the end of data already written by the DMA.
> @@ -974,7 +974,7 @@ static void atmel_rx_from_dma(struct uart_port *port)
>  	dma_sync_sg_for_device(port->dev,
>  			       &atmel_port->sg_rx,
>  			       1,
> -			       DMA_DEV_TO_MEM);
> +			       DMA_FROM_DEVICE);
>  
>  	/*
>  	 * Drop the lock here since it might end up calling
> 


-- 
Nicolas Ferre
