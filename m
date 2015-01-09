Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbbAIPlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:41:31 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:37909 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762AbbAIPl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:41:29 -0500
Message-ID: <54AFF6A6.4060204@atmel.com>
Date: Fri, 9 Jan 2015 16:41:26 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>, <gregkh@linuxfoundation.org>,
        <wenyou.yang@atmel.com>, <ludovic.desroches@atmel.com>,
        <leilei.zhao@atmel.com>, <voice.shen@atmel.com>, <josh.wu@atmel.com>,
        <linux-serial@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/5] tty/serial: at91: fix typo and indentation
References: <cover.1418131298.git.cyrille.pitchen@atmel.com> <faa94cfe2de1047de096b51c780f6e408aced2fb.1418131298.git.cyrille.pitchen@atmel.com>
In-Reply-To: <faa94cfe2de1047de096b51c780f6e408aced2fb.1418131298.git.cyrille.pitchen@atmel.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 09/12/2014 14:31, Cyrille Pitchen a écrit :
> Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

thanks Cyrille. Bye.

> ---
>  drivers/tty/serial/atmel_serial.c | 40 +++++++++++++++++++++------------------
>  1 file changed, 22 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
> index 9e0c636..846552b 100644
> --- a/drivers/tty/serial/atmel_serial.c
> +++ b/drivers/tty/serial/atmel_serial.c
> @@ -738,7 +738,11 @@ static void atmel_complete_tx_dma(void *arg)
>  	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
>  		uart_write_wakeup(port);
>  
> -	/* Do we really need this? */
> +	/*
> +	 * xmit is a circular buffer so, if we have just send data from
> +	 * xmit->tail to the end of xmit->buf, now we have to transmit the
> +	 * remaining data from the beginning of xmit->buf to xmit->head.
> +	 */
>  	if (!uart_circ_empty(xmit))
>  		tasklet_schedule(&atmel_port->tasklet);
>  
> @@ -797,11 +801,11 @@ static void atmel_tx_dma(struct uart_port *port)
>  		BUG_ON(!sg_dma_len(sg));
>  
>  		desc = dmaengine_prep_slave_sg(chan,
> -						sg,
> -						1,
> -						DMA_MEM_TO_DEV,
> -						DMA_PREP_INTERRUPT |
> -						DMA_CTRL_ACK);
> +					       sg,
> +					       1,
> +					       DMA_MEM_TO_DEV,
> +					       DMA_PREP_INTERRUPT |
> +					       DMA_CTRL_ACK);
>  		if (!desc) {
>  			dev_err(port->dev, "Failed to send via dma!\n");
>  			return;
> @@ -1025,13 +1029,13 @@ static int atmel_prepare_rx_dma(struct uart_port *port)
>  	/* UART circular rx buffer is an aligned page. */
>  	BUG_ON((int)port->state->xmit.buf & ~PAGE_MASK);
>  	sg_set_page(&atmel_port->sg_rx,
> -			virt_to_page(ring->buf),
> -			ATMEL_SERIAL_RINGSIZE,
> -			(int)ring->buf & ~PAGE_MASK);
> -			nent = dma_map_sg(port->dev,
> -					&atmel_port->sg_rx,
> -					1,
> -					DMA_FROM_DEVICE);
> +		    virt_to_page(ring->buf),
> +		    ATMEL_SERIAL_RINGSIZE,
> +		    (int)ring->buf & ~PAGE_MASK);
> +	nent = dma_map_sg(port->dev,
> +			  &atmel_port->sg_rx,
> +			  1,
> +			  DMA_FROM_DEVICE);
>  
>  	if (!nent) {
>  		dev_dbg(port->dev, "need to release resource of dma\n");
> @@ -1060,11 +1064,11 @@ static int atmel_prepare_rx_dma(struct uart_port *port)
>  	 * each one is half ring buffer size
>  	 */
>  	desc = dmaengine_prep_dma_cyclic(atmel_port->chan_rx,
> -				sg_dma_address(&atmel_port->sg_rx),
> -				sg_dma_len(&atmel_port->sg_rx),
> -				sg_dma_len(&atmel_port->sg_rx)/2,
> -				DMA_DEV_TO_MEM,
> -				DMA_PREP_INTERRUPT);
> +					 sg_dma_address(&atmel_port->sg_rx),
> +					 sg_dma_len(&atmel_port->sg_rx),
> +					 sg_dma_len(&atmel_port->sg_rx)/2,
> +					 DMA_DEV_TO_MEM,
> +					 DMA_PREP_INTERRUPT);
>  	desc->callback = atmel_complete_rx_dma;
>  	desc->callback_param = port;
>  	atmel_port->desc_rx = desc;
> 


-- 
Nicolas Ferre
