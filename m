Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab3GEHZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 03:25:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:55676 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab3GEHZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 03:25:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1000,1363158000"; 
   d="scan'208";a="365609486"
Date: Fri, 5 Jul 2013 12:15:49 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Xiang Wang <wangxfdu@gmail.com>
Cc: Dan Williams <djbw@fb.com>, linux-kernel@vger.kernel.org,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Subject: Re: [PATCH v2] dma: mmp_pdma: fix a memory alloc error
Message-ID: <20130705064549.GD10947@intel.com>
References: <1371536519-7837-1-git-send-email-wangxfdu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371536519-7837-1-git-send-email-wangxfdu@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 02:21:58PM +0800, Xiang Wang wrote:
> From: Xiang Wang <wangx@marvell.com>
> 
> pdev->phy is of type "struct mmp_pdma_phy *". But when
> allocating memory for it, "struct mmp_pdma_chan" is used
> by mistake.
> 
> Signed-off-by: Xiang Wang <wangx@marvell.com>
> ---
>  drivers/dma/mmp_pdma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
> index c26699f..18ac57f 100644
> --- a/drivers/dma/mmp_pdma.c
> +++ b/drivers/dma/mmp_pdma.c
> @@ -801,7 +801,7 @@ static int mmp_pdma_probe(struct platform_device *op)
>  	}
>  
>  	pdev->phy = devm_kzalloc(pdev->dev,
> -		dma_channels * sizeof(struct mmp_pdma_chan), GFP_KERNEL);
> +		dma_channels * sizeof(*pdev->phy), GFP_KERNEL);
While at it, can you make the flag GFP_NOWAIT. that is the recommendation for
dmac drivers

--
~Vinod
