Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab3FQNmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:42:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:7238 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab3FQNmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:42:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,881,1363158000"; 
   d="scan'208";a="354896759"
Date: Mon, 17 Jun 2013 18:32:30 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Xiang Wang <wangxfdu@gmail.com>
Cc: Dan Williams <djbw@fb.com>, linux-kernel@vger.kernel.org,
        cxie4@marvell.com, Xiang Wang <wangx@marvell.com>
Subject: Re: [PATCH] dma: mmp_pdma: fix a memory alloc error
Message-ID: <20130617130230.GX4107@intel.com>
References: <1369742713-13528-1-git-send-email-wangxfdu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369742713-13528-1-git-send-email-wangxfdu@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 08:05:13PM +0800, Xiang Wang wrote:
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
> index c26699f..76a8dcf 100644
> --- a/drivers/dma/mmp_pdma.c
> +++ b/drivers/dma/mmp_pdma.c
> @@ -801,7 +801,7 @@ static int mmp_pdma_probe(struct platform_device *op)
>  	}
>  
>  	pdev->phy = devm_kzalloc(pdev->dev,
> -		dma_channels * sizeof(struct mmp_pdma_chan), GFP_KERNEL);
> +		dma_channels * sizeof(struct mmp_pdma_phy), GFP_KERNEL);
why not sizeof(*pdev-phy), that way you dont make above error

--
~Vinod
