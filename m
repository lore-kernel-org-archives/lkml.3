Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaKCLMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:12:52 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:14209 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaKCLMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:12:49 -0500
Message-ID: <5457632C.5020002@atmel.com>
Date: Mon, 3 Nov 2014 12:12:44 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Vinod Koul <vinod.koul@intel.com>, <dmaengine@vger.kernel.org>
CC: <lars@metafoo.de>, Russell King <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-arm-kernel@lists.infradead.org>,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= <antoine@free-electrons.com>
Subject: Re: [PATCH v4 02/58] serial: at91: Use dmaengine_slave_config API
References: <1414531573-18807-1-git-send-email-maxime.ripard@free-electrons.com> <1414531573-18807-3-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1414531573-18807-3-git-send-email-maxime.ripard@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/2014 22:25, Maxime Ripard :
> We are removing the dmaengine_device_control API, that shouldn't even have been
> exposed in the first place. Change the callers to use the proper API.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks, Maxime. Do I have to carry the patch myself or is it part of a
series?

Bye,

> ---
>  drivers/tty/serial/atmel_serial.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
> index edde3eca055d..10e6b382d68f 100644
> --- a/drivers/tty/serial/atmel_serial.c
> +++ b/drivers/tty/serial/atmel_serial.c
> @@ -862,9 +862,8 @@ static int atmel_prepare_tx_dma(struct uart_port *port)
>  	config.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
>  	config.dst_addr = port->mapbase + ATMEL_US_THR;
>  
> -	ret = dmaengine_device_control(atmel_port->chan_tx,
> -					DMA_SLAVE_CONFIG,
> -					(unsigned long)&config);
> +	ret = dmaengine_slave_config(atmel_port->chan_tx,
> +				     &config);
>  	if (ret) {
>  		dev_err(port->dev, "DMA tx slave configuration failed\n");
>  		goto chan_err;
> @@ -1026,9 +1025,8 @@ static int atmel_prepare_rx_dma(struct uart_port *port)
>  	config.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
>  	config.src_addr = port->mapbase + ATMEL_US_RHR;
>  
> -	ret = dmaengine_device_control(atmel_port->chan_rx,
> -					DMA_SLAVE_CONFIG,
> -					(unsigned long)&config);
> +	ret = dmaengine_slave_config(atmel_port->chan_rx,
> +				     &config);
>  	if (ret) {
>  		dev_err(port->dev, "DMA rx slave configuration failed\n");
>  		goto chan_err;
> 


-- 
Nicolas Ferre
