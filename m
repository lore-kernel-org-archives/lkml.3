Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423086Ab3FUJbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:31:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:23536 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758469Ab3FUJbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:31:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,911,1363158000"; 
   d="scan'208";a="258184144"
Date: Fri, 21 Jun 2013 14:22:08 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Qiao Zhou <zhouqiao@marvell.com>
Cc: djbw@fb.com, zhangfei.gao@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] dma: mmp_tdma: disable irq when disabling dma
 channel
Message-ID: <20130621085208.GE23141@intel.com>
References: <1371271908-29596-1-git-send-email-zhouqiao@marvell.com>
 <1371271908-29596-2-git-send-email-zhouqiao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371271908-29596-2-git-send-email-zhouqiao@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 12:51:48PM +0800, Qiao Zhou wrote:
> mask dma irq when disabling dma channel, so that interrupt status
> will not be set and interrupt won't come again.
> 
> Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
Applied, thanks

--
~Vinod
> ---
>  drivers/dma/mmp_tdma.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
> index 43d5a6c..9b93665 100644
> --- a/drivers/dma/mmp_tdma.c
> +++ b/drivers/dma/mmp_tdma.c
> @@ -154,6 +154,10 @@ static void mmp_tdma_disable_chan(struct mmp_tdma_chan *tdmac)
>  {
>  	writel(readl(tdmac->reg_base + TDCR) & ~TDCR_CHANEN,
>  					tdmac->reg_base + TDCR);
> +
> +	/* disable irq */
> +	writel(0, tdmac->reg_base + TDIMR);
> +
>  	tdmac->status = DMA_SUCCESS;
>  }
>  
> -- 
> 1.7.0.4
> 

-- 
