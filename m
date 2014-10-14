Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbaJNM0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:26:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:64470 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbaJNM0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:26:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,717,1406617200"; 
   d="scan'208";a="588657173"
Date: Tue, 14 Oct 2014 17:21:18 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RESEND PATCH v2 1/4] dmaengine: pl330: Remove non-NULL check
 for pl330_submit_req parameters
Message-ID: <20141014115118.GG1638@intel.com>
References: <1411994541-31494-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411994541-31494-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 02:42:18PM +0200, Krzysztof Kozlowski wrote:
> The pl330_submit_req() checked supplied 'struct pl330_thread thrd' and
> 'struct dma_pl330_desc desc' parameters for non-NULL. However these
> checks are useless because supplied arguments won't be NULL.
even if we have some error or bug?

I would like this to be checked and complained loudly so we know something
is going wrong rather than assuming it will be correct always.

-- 
~Vinod
> 
> The pl330_submit_req() is called in only one place and:
> 1. 'desc' is already dereferenced in fill_queue() before calling
>    pl330_submit_req().
> 2. 'thrd' is always dereferenced after calling
>    fill_queue()->pl330_submit_req().
> 
> Removing the checks for non-NULL values fixes following warning:
> drivers/dma/pl330.c:1376 pl330_submit_req() warn: variable dereferenced before check 'thrd' (see line 1367)
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> 
> ---
> 
> Changes since v1:
> =================
> 1. Remove the checks for non-NULL completely instead of moving them
>    before dereference. Suggested by Lars-Peter Clausen.
> ---
>  drivers/dma/pl330.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index d5149aacd2fe..57049f84d0c0 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -1372,10 +1372,6 @@ static int pl330_submit_req(struct pl330_thread *thrd,
>  	u32 ccr;
>  	int ret = 0;
>  
> -	/* No Req or Unacquired Channel or DMAC */
> -	if (!desc || !thrd || thrd->free)
> -		return -EINVAL;
> -
>  	regs = thrd->dmac->base;
>  
>  	if (pl330->state == DYING
> -- 
> 1.9.1
> 

-- 
