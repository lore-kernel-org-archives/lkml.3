Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaATKaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 05:30:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:58064 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbaATKaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 05:30:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,689,1384329600"; 
   d="scan'208";a="461569962"
Date: Mon, 20 Jan 2014 14:58:29 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/25] drivers/dma: fix error return code
Message-ID: <20140120092829.GU26823@intel.com>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
 <1388357260-4843-9-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388357260-4843-9-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 29, 2013 at 11:47:23PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Set the return variable to an error code as done elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
> 
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Applied, thanks

--
~Vinod
> 
> ---
> Not tested.
> 
>  drivers/dma/cppi41.c      |    4 +++-
>  drivers/dma/ppc4xx/adma.c |    1 +
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
> index c29dacf..c18aebf 100644
> --- a/drivers/dma/cppi41.c
> +++ b/drivers/dma/cppi41.c
> @@ -972,8 +972,10 @@ static int cppi41_dma_probe(struct platform_device *pdev)
>  		goto err_chans;
>  
>  	irq = irq_of_parse_and_map(dev->of_node, 0);
> -	if (!irq)
> +	if (!irq) {
> +		ret = -EINVAL;
>  		goto err_irq;
> +	}
>  
>  	cppi_writel(USBSS_IRQ_PD_COMP, cdd->usbss_mem + USBSS_IRQ_ENABLER);
>  
> diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
> index 8bba298..ce7a8d7 100644
> --- a/drivers/dma/ppc4xx/adma.c
> +++ b/drivers/dma/ppc4xx/adma.c
> @@ -4114,6 +4114,7 @@ static int ppc440spe_adma_probe(struct platform_device *ofdev)
>  	regs = ioremap(res.start, resource_size(&res));
>  	if (!regs) {
>  		dev_err(&ofdev->dev, "failed to ioremap regs!\n");
> +		ret = -ENOMEM;
>  		goto err_regs_alloc;
>  	}
>  
> 

-- 
