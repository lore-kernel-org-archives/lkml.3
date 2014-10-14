Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbaJNMhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:37:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:33250 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276AbaJNMhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:37:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,717,1406617200"; 
   d="scan'208";a="588662560"
Date: Tue, 14 Oct 2014 17:32:48 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RESEND PATCH v2 2/4] dmaengine: pl330: Remove unused 'regs'
 variable in pl330_submit_req()
Message-ID: <20141014120248.GH1638@intel.com>
References: <1411994541-31494-1-git-send-email-k.kozlowski@samsung.com>
 <1411994541-31494-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411994541-31494-2-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 02:42:19PM +0200, Krzysztof Kozlowski wrote:
> The 'void __iomem *regs' is not used in pl330_submit_req() function.
> Remove it.
Applied, thanks


-- 
~Vinod

> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> ---
> 
> Changes since v1:
> =================
> 1. New patch.
> ---
>  drivers/dma/pl330.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 57049f84d0c0..28e3775888a6 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -1367,13 +1367,10 @@ static int pl330_submit_req(struct pl330_thread *thrd,
>  	struct pl330_dmac *pl330 = thrd->dmac;
>  	struct _xfer_spec xs;
>  	unsigned long flags;
> -	void __iomem *regs;
>  	unsigned idx;
>  	u32 ccr;
>  	int ret = 0;
>  
> -	regs = thrd->dmac->base;
> -
>  	if (pl330->state == DYING
>  		|| pl330->dmac_tbd.reset_chan & (1 << thrd->id)) {
>  		dev_info(thrd->dmac->ddma.dev, "%s:%d\n",
> -- 
> 1.9.1
> 

-- 
