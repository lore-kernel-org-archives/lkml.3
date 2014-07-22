Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaGVJN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:13:27 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:34831 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbaGVJNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:13:25 -0400
Date: Tue, 22 Jul 2014 11:13:28 +0200
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] drivers/i2c/busses: use correct type for
 dma_map/unmap
Message-ID: <20140722091328.GD2349@ldesroches-Latitude-E6320>
Mail-Followup-To: Wolfram Sang <wsa@the-dreams.de>,
	linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1405935725-10457-1-git-send-email-wsa@the-dreams.de>
 <1405935725-10457-2-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1405935725-10457-2-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 11:42:03AM +0200, Wolfram Sang wrote:
> dma_{un}map_* uses 'enum dma_data_direction' not 'enum dma_transfer_direction'.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>

Thanks Wolfram.

> ---
>  drivers/i2c/busses/i2c-at91.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
> index e95f9ba96790..83c989382be9 100644
> --- a/drivers/i2c/busses/i2c-at91.c
> +++ b/drivers/i2c/busses/i2c-at91.c
> @@ -210,7 +210,7 @@ static void at91_twi_write_data_dma_callback(void *data)
>  	struct at91_twi_dev *dev = (struct at91_twi_dev *)data;
>  
>  	dma_unmap_single(dev->dev, sg_dma_address(&dev->dma.sg),
> -			 dev->buf_len, DMA_MEM_TO_DEV);
> +			 dev->buf_len, DMA_TO_DEVICE);
>  
>  	at91_twi_write(dev, AT91_TWI_CR, AT91_TWI_STOP);
>  }
> @@ -289,7 +289,7 @@ static void at91_twi_read_data_dma_callback(void *data)
>  	struct at91_twi_dev *dev = (struct at91_twi_dev *)data;
>  
>  	dma_unmap_single(dev->dev, sg_dma_address(&dev->dma.sg),
> -			 dev->buf_len, DMA_DEV_TO_MEM);
> +			 dev->buf_len, DMA_FROM_DEVICE);
>  
>  	/* The last two bytes have to be read without using dma */
>  	dev->buf += dev->buf_len - 2;
> -- 
> 2.0.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
