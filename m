Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab3HZJPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 05:15:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:15728 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822Ab3HZJPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 05:15:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,956,1367996400"; 
   d="scan'208";a="368475845"
Date: Mon, 26 Aug 2013 14:00:28 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Wei Yongjun <weiyj.lk@gmail.com>, Felipe Balbi <balbi@ti.com>
Cc: djbw@fb.com, grant.likely@linaro.org, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH -next] dma: cppi41: fix error return code in
 cppi41_dma_probe()
Message-ID: <20130826083028.GL2748@intel.com>
References: <CAPgLHd_uc8t_Q7QAq+FzdMZjo0VRYfqXMfk=zy5O+LwWhhGsTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd_uc8t_Q7QAq+FzdMZjo0VRYfqXMfk=zy5O+LwWhhGsTQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 10:59:15AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -EINVAL in the irq parse and map error handling
> case instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

This need to go thru USB tree

Acked-by Vinod Koul <vinod.koul@intel.com>

~Vinod
> ---
>  drivers/dma/cppi41.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
> index 5dcebca..49ea05a 100644
> --- a/drivers/dma/cppi41.c
> +++ b/drivers/dma/cppi41.c
> @@ -973,8 +973,10 @@ static int cppi41_dma_probe(struct platform_device *pdev)
>  		goto err_chans;
>  
>  	irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
> -	if (!irq)
> +	if (!irq) {
> +		ret = -EINVAL;
>  		goto err_irq;
> +	}
>  
>  	cppi_writel(USBSS_IRQ_PD_COMP, cdd->usbss_mem + USBSS_IRQ_ENABLER);
>  
> 

-- 
