Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab3K1G5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 01:57:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:34988 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab3K1G5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 01:57:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,789,1378882800"; 
   d="scan'208";a="441459450"
Date: Thu, 28 Nov 2013 11:30:43 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: pl08x: fix conversioin for generic unmap
 data
Message-ID: <20131128060043.GO8834@intel.com>
References: <1385528004-19423-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385528004-19423-1-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 08:53:24PM -0800, Olof Johansson wrote:
> commit d38a8c622a1b ('dmaengine: prepare for generic 'unmap' data')
> added a generic unmap call but used the wrong argument for it. Fix it.
> 
> Fixes: d38a8c622a1b ('dmaengine: prepare for generic 'unmap' data')
> Signed-off-by: Olof Johansson <olof@lixom.net>
Acked-by: Vinod Koul <vinod.koul@Intel.com>

> ---
> 
> I can't actually tell what the intent of d38a8cc622a1b and how mappings
> are expected to be managed, but it's obviously passing the wrong thing
> in here so it seems like the appropriate fix.
> 
>  drivers/dma/amba-pl08x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
> index 16a2aa28f856..ec4ee5c1fe9d 100644
> --- a/drivers/dma/amba-pl08x.c
> +++ b/drivers/dma/amba-pl08x.c
> @@ -1169,7 +1169,7 @@ static void pl08x_desc_free(struct virt_dma_desc *vd)
>  	struct pl08x_txd *txd = to_pl08x_txd(&vd->tx);
>  	struct pl08x_dma_chan *plchan = to_pl08x_chan(vd->tx.chan);
>  
> -	dma_descriptor_unmap(txd);
> +	dma_descriptor_unmap(&vd->tx);
>  	if (!txd->done)
>  		pl08x_release_mux(plchan);
>  
> -- 
> 1.8.4.1.601.g02b3b1d
> 

-- 
