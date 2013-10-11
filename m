Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3JKCyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 22:54:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:17595 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab3JKCyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 22:54:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1076,1371106800"; 
   d="scan'208";a="417521622"
Date: Fri, 11 Oct 2013 07:32:17 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: "Geyslan G. Bem" <geyslan@gmail.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        kernel-br@googlegroups.com
Subject: Re: [PATCH] dma: edma.c: remove edma_desc leakage
Message-ID: <20131011020216.GE2954@intel.com>
References: <1381184398-11307-1-git-send-email-geyslan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381184398-11307-1-git-send-email-geyslan@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 07:19:58PM -0300, Geyslan G. Bem wrote:
> Free memory allocated to edma_desc when failing to allocate slot.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
Applied thanks

~Vinod
> ---
>  drivers/dma/edma.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index ff50ff4..3aab605 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -306,6 +306,7 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
>  						EDMA_SLOT_ANY);
>  			if (echan->slot[i] < 0) {
>  				dev_err(dev, "Failed to allocate slot\n");
> +				kfree(edesc);
>  				return NULL;
>  			}
>  		}
> -- 
> 1.8.4
> 

-- 
