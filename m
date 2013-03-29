Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab3C2XeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 19:34:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:57463 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757244Ab3C2XeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 19:34:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,375,1363158000"; 
   d="scan'208";a="277821020"
Date: Sat, 30 Mar 2013 04:37:18 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dan Williams <djbw@fb.com>, Jon Hunter <jon-hunter@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: of: Remove unnecessary list_empty check
Message-ID: <20130329230718.GC10326@intel.com>
References: <1364217862-32677-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364217862-32677-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 02:24:22PM +0100, Lars-Peter Clausen wrote:
> list_for_each_entry is able to handle empty lists just fine, there is no need
> to make sure that the list is non empty.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Applied thanks
> ---
>  drivers/dma/of-dma.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
> index 7cad4d7..6679020 100644
> --- a/drivers/dma/of-dma.c
> +++ b/drivers/dma/of-dma.c
> @@ -36,11 +36,6 @@ static struct of_dma *of_dma_get_controller(struct of_phandle_args *dma_spec)
>  
>  	spin_lock(&of_dma_lock);
>  
> -	if (list_empty(&of_dma_list)) {
> -		spin_unlock(&of_dma_lock);
> -		return NULL;
> -	}
> -
>  	list_for_each_entry(ofdma, &of_dma_list, of_dma_controllers)
>  		if ((ofdma->of_node == dma_spec->np) &&
>  		    (ofdma->of_dma_nbcells == dma_spec->args_count)) {
> -- 
> 1.8.0
> 
