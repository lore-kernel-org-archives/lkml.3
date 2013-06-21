Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423146Ab3FUDtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 23:49:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:2202 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965832Ab3FUDta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 23:49:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,910,1363158000"; 
   d="scan'208";a="357165034"
Date: Fri, 21 Jun 2013 08:40:00 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: ste_dma40: Declare memcpy config as static
Message-ID: <20130621031000.GB23141@intel.com>
References: <1371719859-4600-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371719859-4600-1-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 11:17:39AM +0200, Fabio Baltieri wrote:
> Fix sparse warnings:
> 
> drivers/dma/ste_dma40.c:81:26: warning: symbol 'dma40_memcpy_conf_phy' was not declared. Should it be static?
> drivers/dma/ste_dma40.c:95:26: warning: symbol 'dma40_memcpy_conf_log' was not declared. Should it be static?
> 
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
Acked-by: Vinod Koul <vinod.koul@intel.com>

I guess this would be dependent on recent ste_dma40 patches so best way is
Linus's tree, right?

--
~Vinod
> ---
> 
> Hi Linus,
> 
> just a quick sparse error fixup on the dma driver.
> 
> Thanks,
> Fabio
> 
>  drivers/dma/ste_dma40.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index fa4f9a3..8f72085 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
> @@ -78,7 +78,7 @@ static int dma40_memcpy_channels[] = {
>  };
>  
>  /* Default configuration for physcial memcpy */
> -struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
> +static struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
>  	.mode = STEDMA40_MODE_PHYSICAL,
>  	.dir = DMA_MEM_TO_MEM,
>  
> @@ -92,7 +92,7 @@ struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
>  };
>  
>  /* Default configuration for logical memcpy */
> -struct stedma40_chan_cfg dma40_memcpy_conf_log = {
> +static struct stedma40_chan_cfg dma40_memcpy_conf_log = {
>  	.mode = STEDMA40_MODE_LOGICAL,
>  	.dir = DMA_MEM_TO_MEM,
>  
> -- 
> 1.8.2
> 

-- 
