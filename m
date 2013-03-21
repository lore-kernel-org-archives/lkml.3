Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab3CUItO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 04:49:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:6328 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755050Ab3CUItM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 04:49:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="305507337"
Date: Thu, 21 Mar 2013 13:54:09 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: maxin.john@enea.com, s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] dma: ipu: ipu_idmac: Fix section mismatch
Message-ID: <20130321082409.GI10326@intel.com>
References: <1363132417-15273-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363132417-15273-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 08:53:37PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Since commit 84c1e63c12 (dma: Remove erroneous __exit and __exit_p() references)
> the following section mismatch happens:
> 
> WARNING: drivers/built-in.o(.text+0x20f94): Section mismatch in reference from the function ipu_remove() to the function .exit.text:ipu_idmac_exit()
> The function ipu_remove() references a function in an exit section.
> Often the function ipu_idmac_exit() has valid usage outside the exit section
> and the fix is to remove the __exit annotation of ipu_idmac_exit.
> 
> Remove the '__exit' annotation from ipu_idmac_exit in order to fix it. 
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Applied Thanks

--
~Vinod
> ---
>  drivers/dma/ipu/ipu_idmac.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
> index d6d5d7e..d39c2cd 100644
> --- a/drivers/dma/ipu/ipu_idmac.c
> +++ b/drivers/dma/ipu/ipu_idmac.c
> @@ -1642,7 +1642,7 @@ static int __init ipu_idmac_init(struct ipu *ipu)
>  	return dma_async_device_register(&idmac->dma);
>  }
>  
> -static void __exit ipu_idmac_exit(struct ipu *ipu)
> +static void ipu_idmac_exit(struct ipu *ipu)
>  {
>  	int i;
>  	struct idmac *idmac = &ipu->idmac;
> -- 
> 1.7.9.5
> 
