Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaJLUGL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:06:11 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:59545 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaJLUGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:06:08 -0400
Message-ID: <543ADF29.9090307@atmel.com>
Date: Sun, 12 Oct 2014 22:06:01 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>, <dmaengine@vger.kernel.org>
CC: Mark Brown <broonie@kernel.org>, <linux-spi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/12] spi/atmel: use dmaengine_terminate_all() API
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com> <1413042040-28222-7-git-send-email-vinod.koul@intel.com>
In-Reply-To: <1413042040-28222-7-git-send-email-vinod.koul@intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 17:40, Vinod Koul :
> The drivers should use dmaengine_terminate_all() API instead of
> accessing the device_control which will be deprecated soon
> 
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>

sure:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks Vinod.

Bye,

> ---
>  drivers/spi/spi-atmel.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
> index 113c83f..649dcb5 100644
> --- a/drivers/spi/spi-atmel.c
> +++ b/drivers/spi/spi-atmel.c
> @@ -482,11 +482,9 @@ error:
>  static void atmel_spi_stop_dma(struct atmel_spi *as)
>  {
>  	if (as->dma.chan_rx)
> -		as->dma.chan_rx->device->device_control(as->dma.chan_rx,
> -							DMA_TERMINATE_ALL, 0);
> +		dmaengine_terminate_all(as->dma.chan_rx);
>  	if (as->dma.chan_tx)
> -		as->dma.chan_tx->device->device_control(as->dma.chan_tx,
> -							DMA_TERMINATE_ALL, 0);
> +		dmaengine_terminate_all(as->dma.chan_tx);
>  }
>  
>  static void atmel_spi_release_dma(struct atmel_spi *as)
> 


-- 
Nicolas Ferre
