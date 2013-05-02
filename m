Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761484Ab3EBQ7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 12:59:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:41564 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761313Ab3EBQ6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 12:58:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,597,1363158000"; 
   d="scan'208";a="296628955"
Date: Thu, 2 May 2013 21:54:36 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Jon Hunter <jon-hunter@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dma: of: Fix of_node reference leak
Message-ID: <20130502162436.GL1960@intel.com>
References: <1366364534-3298-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366364534-3298-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 11:42:13AM +0200, Lars-Peter Clausen wrote:
> of_dma_request_slave_channel() currently does not drop the reference to the
> dma_spec of_node if no DMA controller matching the of_node could be found. This
> patch fixes it by always calling of_node_put().
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Applied both with minor typo fix in changelog for second.

Thanks
~Vinod
> ---
>  drivers/dma/of-dma.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
> index 8266893..2882403 100644
> --- a/drivers/dma/of-dma.c
> +++ b/drivers/dma/of-dma.c
> @@ -221,12 +221,13 @@ struct dma_chan *of_dma_request_slave_channel(struct device_node *np,
>  
>  		ofdma = of_dma_get_controller(&dma_spec);
>  
> -		if (!ofdma)
> -			continue;
> -
> -		chan = ofdma->of_dma_xlate(&dma_spec, ofdma);
> +		if (ofdma) {
> +			chan = ofdma->of_dma_xlate(&dma_spec, ofdma);
>  
> -		of_dma_put_controller(ofdma);
> +			of_dma_put_controller(ofdma);
> +		} else {
> +			chan = NULL;
> +		}
>  
>  		of_node_put(dma_spec.np);
>  
> -- 
> 1.8.0
> 
