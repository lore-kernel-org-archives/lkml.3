Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbaGYI6J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:58:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:38789 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbaGYI6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:58:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,729,1400050800"; 
   d="scan'208";a="461254829"
Date: Fri, 25 Jul 2014 14:21:48 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Mark Brown <broonie@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dmaengine: Clarify device parameter for
 dma_sync_*_for_*()
Message-ID: <20140725085148.GN8181@intel.com>
References: <1405094182-13962-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405094182-13962-1-git-send-email-geert+renesas@glider.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 05:56:21PM +0200, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> v2:
>   - New
> ---
>  Documentation/dmaengine.txt | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/dmaengine.txt b/Documentation/dmaengine.txt
> index 879b6e31e2da..87d3f192e160 100644
> --- a/Documentation/dmaengine.txt
> +++ b/Documentation/dmaengine.txt
> @@ -100,8 +100,10 @@ The slave DMA usage consists of following steps:
>     The peripheral driver is expected to have mapped the scatterlist for
>     the DMA operation prior to calling device_prep_slave_sg, and must
>     keep the scatterlist mapped until the DMA operation has completed.
> -   The scatterlist must be mapped using the DMA struct device.  So,
> -   normal setup should look like this:
> +   The scatterlist must be mapped using the DMA struct device.
> +   If a mapping needs to be synchronized later, dma_sync_*_for_*() must be
> +   called using the DMA struct device, too.
> +   So, normal setup should look like this:
>  
>  	nr_sg = dma_map_sg(chan->device->dev, sgl, sg_len);
>  	if (nr_sg == 0)
> -- 
> 1.9.1
> 
Applied, thanks

-- 
~Vinod
