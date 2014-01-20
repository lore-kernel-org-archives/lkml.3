Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaATLCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 06:02:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:57484 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbaATLCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 06:02:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,689,1384329600"; 
   d="scan'208";a="467686457"
Date: Mon, 20 Jan 2014 15:30:45 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, dan.j.williams@intel.com
Subject: Re: [PATCH v2] dma: fix vchan_cookie_complete() debug print
Message-ID: <20140120100045.GA26823@intel.com>
References: <1386344529-25617-1-git-send-email-jonas.jensen@gmail.com>
 <1386581123-4706-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386581123-4706-1-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 10:25:23AM +0100, Jonas Jensen wrote:
> vchan_cookie_complete() is supposed to print the cookie value
> but it's always zero because:
> 
> dma_cookie_complete() is called prior to dev_vdbg()
> 
> Move the call, place it after dev_vdbg().
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
Applied, thanks

--
~Vinod
> ---
> 
> Notes:
>     Changes since v1:
>     
>     1. remove local dma_cookie_t
>     2. call dma_cookie_complete() after dev_vdbg()
>     
>     Applies to next-20131209
> 
>  drivers/dma/virt-dma.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/virt-dma.h b/drivers/dma/virt-dma.h
> index 85c19d6..7d6f611 100644
> --- a/drivers/dma/virt-dma.h
> +++ b/drivers/dma/virt-dma.h
> @@ -85,9 +85,9 @@ static inline void vchan_cookie_complete(struct virt_dma_desc *vd)
>  {
>  	struct virt_dma_chan *vc = to_virt_chan(vd->tx.chan);
>  
> -	dma_cookie_complete(&vd->tx);
>  	dev_vdbg(vc->chan.device->dev, "txd %p[%x]: marked complete\n",
>  		vd, vd->tx.cookie);
> +	dma_cookie_complete(&vd->tx);
>  	list_add_tail(&vd->node, &vc->desc_completed);
>  
>  	tasklet_schedule(&vc->task);
> -- 
> 1.8.2.1
> 

-- 
