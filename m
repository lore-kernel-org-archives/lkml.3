Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbaDPGoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 02:44:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:47643 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbaDPGoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 02:44:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,870,1389772800"; 
   d="scan'208";a="521820179"
Date: Wed, 16 Apr 2014 12:04:27 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Yuan Yao <yao.yuan@freescale.com>
Cc: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jingchang.lu@freecsale.com
Subject: Re: [PATCH] dma: fix eDMA driver as a subsys_initcall
Message-ID: <20140416063427.GK32284@intel.com>
References: <1396585675-32729-1-git-send-email-yao.yuan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396585675-32729-1-git-send-email-yao.yuan@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 12:27:55PM +0800, Yuan Yao wrote:
> Because of some driver base on DMA, changed the initcall order as subsys_initcall.

Changelog could have mentioned "which" driver and elobrated on it
> 
> Signed-off-by: Yuan Yao <yao.yuan@freescale.com>

Applied, nevertheless

-- 
~Vinod
> ---
>  drivers/dma/fsl-edma.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c
> index 381e793..b396a7f 100644
> --- a/drivers/dma/fsl-edma.c
> +++ b/drivers/dma/fsl-edma.c
> @@ -968,7 +968,17 @@ static struct platform_driver fsl_edma_driver = {
>  	.remove		= fsl_edma_remove,
>  };
>  
> -module_platform_driver(fsl_edma_driver);
> +static int __init fsl_edma_init(void)
> +{
> +	return platform_driver_register(&fsl_edma_driver);
> +}
> +subsys_initcall(fsl_edma_init);
> +
> +static void __exit fsl_edma_exit(void)
> +{
> +	platform_driver_unregister(&fsl_edma_driver);
> +}
> +module_exit(fsl_edma_exit);
>  
>  MODULE_ALIAS("platform:fsl-edma");
>  MODULE_DESCRIPTION("Freescale eDMA engine driver");
> -- 
> 1.8.4
> 
> 

-- 
