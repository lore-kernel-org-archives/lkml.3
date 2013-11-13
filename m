Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab3KMLPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:15:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:15635 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758654Ab3KMLPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:15:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="408027340"
Date: Wed, 13 Nov 2013 15:49:36 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] dmaengine: edma: double free on error in
 edma_prep_slave_sg()
Message-ID: <20131113101936.GW8834@intel.com>
References: <20131113074446.GC25541@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113074446.GC25541@elgon.mountain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 10:44:46AM +0300, Dan Carpenter wrote:
> We accidentally applied two correct but duplicative fixes for a memory
> leak here:
> 4b6271a64463 ('dma: edma: Fix memory leak')
> 2f6d8fad0a16 ('dma: edma.c: remove edma_desc leakage')
Thanks Dan,

I already send the same fix today morning. This was reported by Wing-Keung
sometime back

--
~Vinod
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
> index ea4abaa..9c8103d 100644
> --- a/drivers/dma/edma.c
> +++ b/drivers/dma/edma.c
> @@ -420,7 +420,6 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
>  				edma_alloc_slot(EDMA_CTLR(echan->ch_num),
>  						EDMA_SLOT_ANY);
>  			if (echan->slot[i] < 0) {
> -				kfree(edesc);
>  				dev_err(dev, "Failed to allocate slot\n");
>  				kfree(edesc);
>  				return NULL;
> --
> To unsubscribe from this list: send the line "unsubscribe dmaengine" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
