Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934620Ab3BNNnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 08:43:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:4686 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934079Ab3BNNnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 08:43:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,665,1355126400"; 
   d="scan'208";a="291096128"
Date: Thu, 14 Feb 2013 19:12:19 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Cong Ding <dinggnu@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dma: of-dma.c: fix memory leakage
Message-ID: <20130214134219.GC29960@intel.com>
References: <1358600805-20193-1-git-send-email-dinggnu@gmail.com>
 <50FC6EB1.4050704@gmail.com>
 <20130122101053.GA2427@gmail.com>
 <20130212174025.GB17659@intel.com>
 <20130214101610.GA29017@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214101610.GA29017@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 11:16:10AM +0100, Cong Ding wrote:
> The memory allocated to ofdma might be a leakage when error occurs.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
Applied, thanks

--
~Vinod
> ---
>  drivers/dma/of-dma.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
> index 59631b2..583e50e3 100644
> --- a/drivers/dma/of-dma.c
> +++ b/drivers/dma/of-dma.c
> @@ -107,6 +107,7 @@ int of_dma_controller_register(struct device_node *np,
>  	if (!nbcells) {
>  		pr_err("%s: #dma-cells property is missing or invalid\n",
>  		       __func__);
> +		kfree(ofdma);
>  		return -EINVAL;
>  	}
>  
> -- 
> 1.7.9.5
> 
