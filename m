Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab3KMJU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 04:20:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:14361 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339Ab3KMJUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 04:20:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434454313"
Date: Wed, 13 Nov 2013 13:54:44 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dmaengine: ipu: fix warnings from 64-bit
 dma_addr_t printouts
Message-ID: <20131113082444.GQ8834@intel.com>
References: <1384324244-11330-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384324244-11330-1-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 10:30:43PM -0800, Olof Johansson wrote:
> This resolves a number of warnings such as the below when building with
> 64-bit dma_addr_t on arm:
> 
> drivers/dma/ipu/ipu_idmac.c:1235:2: warning: format '%x' expects argument
>   of type 'unsigned int', but argument 5 has type 'dma_addr_t' [-Wformat=]
> 
> ..by upcasting to u64 and using %llx.

Applied both

Thanks
~Vinod

> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>  drivers/dma/ipu/ipu_idmac.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
> index cb9c0bc..128ca14 100644
> --- a/drivers/dma/ipu/ipu_idmac.c
> +++ b/drivers/dma/ipu/ipu_idmac.c
> @@ -1232,8 +1232,10 @@ static irqreturn_t idmac_interrupt(int irq, void *dev_id)
>  	desc = list_entry(ichan->queue.next, struct idmac_tx_desc, list);
>  	descnew = desc;
>  
> -	dev_dbg(dev, "IDMAC irq %d, dma 0x%08x, next dma 0x%08x, current %d, curbuf 0x%08x\n",
> -		irq, sg_dma_address(*sg), sgnext ? sg_dma_address(sgnext) : 0, ichan->active_buffer, curbuf);
> +	dev_dbg(dev, "IDMAC irq %d, dma %#llx, next dma %#llx, current %d, curbuf %#x\n",
> +		irq, (u64)sg_dma_address(*sg),
> +		sgnext ? (u64)sg_dma_address(sgnext) : 0,
> +		ichan->active_buffer, curbuf);
>  
>  	/* Find the descriptor of sgnext */
>  	sgnew = idmac_sg_next(ichan, &descnew, *sg);
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
