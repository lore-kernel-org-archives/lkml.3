Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab3IWKxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:53:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:51927 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab3IWKx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:53:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,961,1371106800"; 
   d="scan'208";a="407622516"
Date: Mon, 23 Sep 2013 15:32:53 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: djbw@fb.com, grant.likely@linaro.org, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH -next] dma: mmp_pdma: use list_move instead of
 list_del/list_add
Message-ID: <20130923100253.GG17188@intel.com>
References: <CAPgLHd9SeN1OdCKqTP2w_rFi3TWD=b+7vL4iwx53KwnMF23Nxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd9SeN1OdCKqTP2w_rFi3TWD=b+7vL4iwx53KwnMF23Nxg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 02:07:20PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using list_move() instead of list_del() + list_add().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Applied, thanks

~Vinod
> ---
>  drivers/dma/mmp_pdma.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
> index ff8d7827..558994f 100644
> --- a/drivers/dma/mmp_pdma.c
> +++ b/drivers/dma/mmp_pdma.c
> @@ -798,8 +798,7 @@ static void dma_do_tasklet(unsigned long data)
>  		 * move the descriptors to a temporary list so we can drop
>  		 * the lock during the entire cleanup operation
>  		 */
> -		list_del(&desc->node);
> -		list_add(&desc->node, &chain_cleanup);
> +		list_move(&desc->node, &chain_cleanup);
>  
>  		/*
>  		 * Look for the first list entry which has the ENDIRQEN flag
> 

-- 
