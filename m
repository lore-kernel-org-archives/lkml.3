Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab3FLKbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:31:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:32752 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741Ab3FLKbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:31:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,851,1363158000"; 
   d="scan'208";a="315801572"
Date: Wed, 12 Jun 2013 15:21:29 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Qiao Zhou <zhouqiao@marvell.com>
Cc: djbw@fb.com, zhangfei.gao@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: mmp_tdma: kill tasklet when free dma channel
Message-ID: <20130612095128.GT4107@intel.com>
References: <1370605240-19768-1-git-send-email-zhouqiao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370605240-19768-1-git-send-email-zhouqiao@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 07:40:40PM +0800, Qiao Zhou wrote:
> kill tasklet task when free dam channel, otherwise the task may
typo			      ^^^^

> run after related resource is released, then unknown things may
> happen.
Well, why would tasklet run when channel is freed. You are supposed to cleanup
the DMA channel on free. Ensure all transaction are aborted

Sounds like masking some issue

--
~Vinod
> 
> Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
> ---
>  drivers/dma/mmp_tdma.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
> index 43d5a6c..2622b2a 100644
> --- a/drivers/dma/mmp_tdma.c
> +++ b/drivers/dma/mmp_tdma.c
> @@ -333,6 +333,9 @@ static void mmp_tdma_free_chan_resources(struct dma_chan *chan)
>  
>  	if (tdmac->irq)
>  		devm_free_irq(tdmac->dev, tdmac->irq, tdmac);
> +
> +	tasklet_kill(&tdmac->tasklet);
> +
>  	mmp_tdma_free_descriptor(tdmac);
>  	return;
>  }
> -- 
> 1.7.0.4
> 

-- 
