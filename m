Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282Ab3HSJmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:42:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:33701 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab3HSJmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:42:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,912,1367996400"; 
   d="scan'208";a="283762628"
Date: Mon, 19 Aug 2013 14:28:57 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 04/27] drivers/dma: don't check resource with
 devm_ioremap_resource
Message-ID: <20130819085857.GY32147@intel.com>
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de>
 <1374602524-3398-5-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374602524-3398-5-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 08:01:37PM +0200, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Sorry looks like I missed this and instead applied a similar patch from Julia
last week. I should have taken this instead. My bad...

~Vinod
> ---
> Please apply via the subsystem-tree.
> 
>  drivers/dma/mmp_pdma.c |    3 ---
>  drivers/dma/mmp_tdma.c |    3 ---
>  2 files changed, 6 deletions(-)
> 
> diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
> index c26699f..7eba967 100644
> --- a/drivers/dma/mmp_pdma.c
> +++ b/drivers/dma/mmp_pdma.c
> @@ -778,9 +778,6 @@ static int mmp_pdma_probe(struct platform_device *op)
>  	pdev->dev = &op->dev;
>  
>  	iores = platform_get_resource(op, IORESOURCE_MEM, 0);
> -	if (!iores)
> -		return -EINVAL;
> -
>  	pdev->base = devm_ioremap_resource(pdev->dev, iores);
>  	if (IS_ERR(pdev->base))
>  		return PTR_ERR(pdev->base);
> diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
> index 9b93665..1f1885a 100644
> --- a/drivers/dma/mmp_tdma.c
> +++ b/drivers/dma/mmp_tdma.c
> @@ -549,9 +549,6 @@ static int mmp_tdma_probe(struct platform_device *pdev)
>  	}
>  
>  	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!iores)
> -		return -EINVAL;
> -
>  	tdev->base = devm_ioremap_resource(&pdev->dev, iores);
>  	if (IS_ERR(tdev->base))
>  		return PTR_ERR(tdev->base);
> -- 
> 1.7.10.4
> 

-- 
