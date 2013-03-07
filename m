Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab3CGMws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 07:52:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:60456 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab3CGMwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 07:52:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,802,1355126400"; 
   d="scan'208";a="266021602"
Date: Thu, 7 Mar 2013 17:57:59 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: djbw@fb.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ioatdma: make debug output more readable
Message-ID: <20130307122759.GI13370@intel.com>
References: <20130304175954.9792.19327.stgit@djiang5-linux2.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130304175954.9792.19327.stgit@djiang5-linux2.ch.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 10:59:54AM -0700, Dave Jiang wrote:
> Making OP field a hex instead of integer to make it more readable. Also add
> the dump out of the NEXT field.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Applied thanks

> ---
>  drivers/dma/ioat/dma.h    |    2 +-
>  drivers/dma/ioat/dma_v3.c |    3 ++-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
> index 53a4cbb..95ae7b3 100644
> --- a/drivers/dma/ioat/dma.h
> +++ b/drivers/dma/ioat/dma.h
> @@ -179,7 +179,7 @@ __dump_desc_dbg(struct ioat_chan_common *chan, struct ioat_dma_descriptor *hw,
>  	struct device *dev = to_dev(chan);
>  
>  	dev_dbg(dev, "desc[%d]: (%#llx->%#llx) cookie: %d flags: %#x"
> -		" ctl: %#x (op: %d int_en: %d compl: %d)\n", id,
> +		" ctl: %#10.8x (op: %#x int_en: %d compl: %d)\n", id,
>  		(unsigned long long) tx->phys,
>  		(unsigned long long) hw->next, tx->cookie, tx->flags,
>  		hw->ctl, hw->ctl_f.op, hw->ctl_f.int_en, hw->ctl_f.compl_write);
> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> index 53ea4bd..ce6fcee 100644
> --- a/drivers/dma/ioat/dma_v3.c
> +++ b/drivers/dma/ioat/dma_v3.c
> @@ -605,7 +605,7 @@ dump_pq_desc_dbg(struct ioat2_dma_chan *ioat, struct ioat_ring_ent *desc, struct
>  	int i;
>  
>  	dev_dbg(dev, "desc[%d]: (%#llx->%#llx) flags: %#x"
> -		" sz: %#x ctl: %#x (op: %d int: %d compl: %d pq: '%s%s' src_cnt: %d)\n",
> +		" sz: %#10.8x ctl: %#x (op: %#x int: %d compl: %d pq: '%s%s' src_cnt: %d)\n",
>  		desc_id(desc), (unsigned long long) desc->txd.phys,
>  		(unsigned long long) (pq_ex ? pq_ex->next : pq->next),
>  		desc->txd.flags, pq->size, pq->ctl, pq->ctl_f.op, pq->ctl_f.int_en,
> @@ -617,6 +617,7 @@ dump_pq_desc_dbg(struct ioat2_dma_chan *ioat, struct ioat_ring_ent *desc, struct
>  			(unsigned long long) pq_get_src(descs, i), pq->coef[i]);
>  	dev_dbg(dev, "\tP: %#llx\n", pq->p_addr);
>  	dev_dbg(dev, "\tQ: %#llx\n", pq->q_addr);
> +	dev_dbg(dev, "\tNEXT: %#llx\n", pq->next);
>  }
>  
>  static struct dma_async_tx_descriptor *
> 
