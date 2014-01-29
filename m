Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaA2MKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 07:10:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:16815 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaA2MKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 07:10:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,741,1384329600"; 
   d="scan'208";a="472601418"
Date: Wed, 29 Jan 2014 17:39:41 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Joe Perches <joe@perches.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Mack <zonque@gmail.com>, Xiang Wang <wangx@marvell.com>,
        Zhangfei Gao <zhangfei.gao@marvell.com>
Subject: Re: [PATCH] dmaengine: mmp_pdma: fix mismerge
Message-ID: <20140129120941.GK10628@intel.com>
References: <3546714.4OTE6dW34L@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3546714.4OTE6dW34L@wuerfel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 09:45:38PM +0100, Arnd Bergmann wrote:
> The merge between 2b7f65b11d87f "mmp_pdma: Style neatening" and
> 8010dad55a0ab0 "dma: add dma_get_any_slave_channel(), for use in of_xlate()"
> caused a build error by leaving obsolete code in place:
> 
>   mmp_pdma.c: In function 'mmp_pdma_dma_xlate':
>   mmp_pdma.c:909:31: error: 'candidate' undeclared
>   mmp_pdma.c:912:3: error: label 'retry' used but not defined
>   mmp_pdma.c:901:24: warning: unused variable 'c' [-Wunused-variable]
> 
> This removes the extraneous lines.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Applied thanks

--
~Vinod
> 
> diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
> index 32e58ee..69c6a12 100644
> --- a/drivers/dma/mmp_pdma.c
> +++ b/drivers/dma/mmp_pdma.c
> @@ -898,19 +898,11 @@ static struct dma_chan *mmp_pdma_dma_xlate(struct of_phandle_args *dma_spec,
>  {
>  	struct mmp_pdma_device *d = ofdma->of_dma_data;
>  	struct dma_chan *chan;
> -	struct mmp_pdma_chan *c;
>  
>  	chan = dma_get_any_slave_channel(&d->device);
>  	if (!chan)
>  		return NULL;
>  
> -	/* dma_get_slave_channel will return NULL if we lost a race between
> -	 * the lookup and the reservation */
> -	chan = dma_get_slave_channel(candidate);
> -
> -	if (!chan)
> -		goto retry;
> -
>  	to_mmp_pdma_chan(chan)->drcmr = dma_spec->args[0];
>  
>  	return chan;
> 

-- 
