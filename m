Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab3E3SjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:39:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:31781 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278Ab3E3SjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:39:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,772,1363158000"; 
   d="scan'208";a="345813491"
Date: Thu, 30 May 2013 23:31:26 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Denis Efremov <yefremov.denis@gmail.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, Dan Williams <djbw@fb.com>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH 09/21] dw_dmac: remove inline marking of EXPORT_SYMBOL
 functions
Message-ID: <20130530180126.GG3767@intel.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
 <1368091192-10245-4-git-send-email-yefremov.denis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368091192-10245-4-git-send-email-yefremov.denis@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 01:19:40PM +0400, Denis Efremov wrote:
> EXPORT_SYMBOL and inline directives are contradictory to each other.
> The patch fixes this inconsistency.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
Applied, thanks

--
~Vinod
> ---
>  drivers/dma/dw_dmac.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 43a5329..a526bb9 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -574,14 +574,14 @@ static void dwc_handle_error(struct dw_dma *dw, struct dw_dma_chan *dwc)
>  
>  /* --------------------- Cyclic DMA API extensions -------------------- */
>  
> -inline dma_addr_t dw_dma_get_src_addr(struct dma_chan *chan)
> +dma_addr_t dw_dma_get_src_addr(struct dma_chan *chan)
>  {
>  	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
>  	return channel_readl(dwc, SAR);
>  }
>  EXPORT_SYMBOL(dw_dma_get_src_addr);
>  
> -inline dma_addr_t dw_dma_get_dst_addr(struct dma_chan *chan)
> +dma_addr_t dw_dma_get_dst_addr(struct dma_chan *chan)
>  {
>  	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
>  	return channel_readl(dwc, DAR);
> -- 
> 1.8.1.4
> 

-- 
