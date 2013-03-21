Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab3CUJci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 05:32:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:42992 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757227Ab3CUJch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 05:32:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="217276748"
Date: Thu, 21 Mar 2013 14:37:37 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Syam Sidhardhan <syamsidhardh@gmail.com>
Cc: linux-kernel@vger.kernel.org, djbw@fb.com
Subject: Re: [PATCH] dma: imx-dma: Remove redundant NULL check before kfree
Message-ID: <20130321090737.GK10326@intel.com>
References: <1361747786-29597-1-git-send-email-s.syam@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361747786-29597-1-git-send-email-s.syam@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 04:46:26AM +0530, Syam Sidhardhan wrote:
> kfree on NULL pointer is a no-op.
> 
> Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
Applied thanks
> ---
>  drivers/dma/imx-dma.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index 70b8975..0988583 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -859,8 +859,7 @@ static struct dma_async_tx_descriptor *imxdma_prep_dma_cyclic(
>  
>  	desc = list_first_entry(&imxdmac->ld_free, struct imxdma_desc, node);
>  
> -	if (imxdmac->sg_list)
> -		kfree(imxdmac->sg_list);
> +	kfree(imxdmac->sg_list);
>  
>  	imxdmac->sg_list = kcalloc(periods + 1,
>  			sizeof(struct scatterlist), GFP_KERNEL);
> -- 
> 1.7.9.5
> 
