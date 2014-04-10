Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbaDJWke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 18:40:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58276 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845AbaDJWkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 18:40:32 -0400
Message-ID: <53471DC5.4090001@ti.com>
Date: Thu, 10 Apr 2014 17:40:05 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <dan.j.williams@intel.com>,
        <vinod.koul@intel.com>, <nsekhar@ti.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@linaro.org>
Subject: Re: [PATCH v2 10/14] dma: edma: Simplify direction configuration
 in edma_config_pset()
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com> <1396357575-30585-11-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1396357575-30585-11-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 08:06 AM, Peter Ujfalusi wrote:
> We only support DEV_TO_MEM or MEM_TO_DEV directions with edma driver and the
> check for the direction has been already done in the function calling
> edma_config_pset().
> The error reporting is redundant and also the "else if ()" can be removed.
> 

NAK. Please don't do this. I have been working on MEM_TO_MEM support as
well so leave it as it is for future.

Thanks,
-Joel

> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/dma/edma.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index 855766672aa9..d954099650ae 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -372,14 +372,12 @@ static int edma_config_pset(struct dma_chan *chan, struct edmacc_param *pset,
>  		src_cidx = cidx;
>  		dst_bidx = 0;
>  		dst_cidx = 0;
> -	} else if (direction == DMA_DEV_TO_MEM)  {
> +	} else {
> +		/* DMA_DEV_TO_MEM */
>  		src_bidx = 0;
>  		src_cidx = 0;
>  		dst_bidx = acnt;
>  		dst_cidx = cidx;
> -	} else {
> -		dev_err(dev, "%s: direction not implemented yet\n", __func__);
> -		return -EINVAL;
>  	}
>  
>  	pset->opt = EDMA_TCC(EDMA_CHAN_SLOT(echan->ch_num));
> 

