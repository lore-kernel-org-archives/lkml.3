Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab3CUGxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 02:53:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:6080 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab3CUGxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 02:53:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="306237618"
Date: Thu, 21 Mar 2013 11:58:23 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        thierry.reding@avionic-design.de
Subject: Re: [PATCH Resend] dma: pl330: Convert to devm_ioremap_resource()
Message-ID: <20130321062822.GE10326@intel.com>
References: <1362387987-26718-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362387987-26718-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 02:36:27PM +0530, Sachin Kamat wrote:
> Use the newly introduced devm_ioremap_resource() instead of
> devm_request_and_ioremap() which provides more consistent error handling.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
Applied thanks
> ---
>  drivers/dma/pl330.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 7181531..10005ec 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -26,6 +26,7 @@
>  #include <linux/scatterlist.h>
>  #include <linux/of.h>
>  #include <linux/of_dma.h>
> +#include <linux/err.h>
>  
>  #include "dmaengine.h"
>  #define PL330_MAX_CHAN		8
> @@ -2904,9 +2905,9 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>  	pi->mcbufsz = pdat ? pdat->mcbuf_sz : 0;
>  
>  	res = &adev->res;
> -	pi->base = devm_request_and_ioremap(&adev->dev, res);
> -	if (!pi->base)
> -		return -ENXIO;
> +	pi->base = devm_ioremap_resource(&adev->dev, res);
> +	if (IS_ERR(pi->base))
> +		return PTR_ERR(pi->base);
>  
>  	amba_set_drvdata(adev, pdmac);
>  
> -- 
> 1.7.4.1
> 
