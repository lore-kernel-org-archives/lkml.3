Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab3K1G66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 01:58:58 -0500
Received: from mga09.intel.com ([134.134.136.24]:7872 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab3K1G6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 01:58:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,789,1378882800"; 
   d="scan'208";a="416360728"
Date: Thu, 28 Nov 2013 11:31:49 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dmaengine@vger.kernel.org,
        nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH] dmaengine: at_hdmac: remove unused function
Message-ID: <20131128060149.GP8834@intel.com>
References: <1385491415-31325-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385491415-31325-1-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 10:43:35AM -0800, Olof Johansson wrote:
> commit 54f8d501e8428 ('dmaengine: remove DMA unmap from drivers')
> refactored some code which resulted in an unused function in the at_hdmac
> driver:
> 
> drivers/dma/at_hdmac_regs.h:350:23: warning: 'chan2parent' defined but
>     not used [-Wunused-function]
> 
> Fixes: 54f8d501e8428 ('dmaengine: remove DMA unmap from drivers')
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Vinod Koul <vinod.koul@Intel.com>

> ---
> 
> Dan,
> 
> Looks like you fixed up the DesignWare driver for the same issue but
> this needs it to.
> 
>  drivers/dma/at_hdmac_regs.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/dma/at_hdmac_regs.h b/drivers/dma/at_hdmac_regs.h
> index f31d647acdfa..2787aba60c6b 100644
> --- a/drivers/dma/at_hdmac_regs.h
> +++ b/drivers/dma/at_hdmac_regs.h
> @@ -347,10 +347,6 @@ static struct device *chan2dev(struct dma_chan *chan)
>  {
>  	return &chan->dev->device;
>  }
> -static struct device *chan2parent(struct dma_chan *chan)
> -{
> -	return chan->dev->device.parent;
> -}
>  
>  #if defined(VERBOSE_DEBUG)
>  static void vdbg_dump_regs(struct at_dma_chan *atchan)
> -- 
> 1.8.4.1.601.g02b3b1d
> 
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
