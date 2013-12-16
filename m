Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3LPKVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:21:21 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:39706 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab3LPKVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:21:17 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 16 Dec 2013 02:21:06 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dmaengine@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers: dma: Mark functions as static in dma_v3.c
Message-ID: <20131216102106.GA22119@leaf>
References: <dba654dc34646dda2998dbf7b08d7ce3c160ff8c.1387188138.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dba654dc34646dda2998dbf7b08d7ce3c160ff8c.1387188138.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 03:40:40PM +0530, Rashika Kheria wrote:
> Mark the functions ioat3_prep_xor_val(), ioat3_prep_pq_val() and
> ioat3_prep_pqxor_val() as static in dma_v3.c because they are not used
> outside this file.
> 
> This eliminates the following warnings in dma_v3.c:
> drivers/dma/ioat/dma_v3.c:741:1: warning: no previous prototype for ‘ioat3_prep_xor_val’ [-Wmissing-prototypes]
> drivers/dma/ioat/dma_v3.c:1092:1: warning: no previous prototype for ‘ioat3_prep_pq_val’ [-Wmissing-prototypes]
> drivers/dma/ioat/dma_v3.c:1134:1: warning: no previous prototype for ‘ioat3_prep_pqxor_val’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/dma/ioat/dma_v3.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
> index 820817e9..07038ca 100644
> --- a/drivers/dma/ioat/dma_v3.c
> +++ b/drivers/dma/ioat/dma_v3.c
> @@ -737,7 +737,7 @@ ioat3_prep_xor(struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
>  	return __ioat3_prep_xor_lock(chan, NULL, dest, src, src_cnt, len, flags);
>  }
>  
> -struct dma_async_tx_descriptor *
> +static struct dma_async_tx_descriptor *
>  ioat3_prep_xor_val(struct dma_chan *chan, dma_addr_t *src,
>  		    unsigned int src_cnt, size_t len,
>  		    enum sum_check_flags *result, unsigned long flags)
> @@ -1088,7 +1088,7 @@ ioat3_prep_pq(struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
>  	}
>  }
>  
> -struct dma_async_tx_descriptor *
> +static struct dma_async_tx_descriptor *
>  ioat3_prep_pq_val(struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
>  		  unsigned int src_cnt, const unsigned char *scf, size_t len,
>  		  enum sum_check_flags *pqres, unsigned long flags)
> @@ -1130,7 +1130,7 @@ ioat3_prep_pqxor(struct dma_chan *chan, dma_addr_t dst, dma_addr_t *src,
>  				     flags);
>  }
>  
> -struct dma_async_tx_descriptor *
> +static struct dma_async_tx_descriptor *
>  ioat3_prep_pqxor_val(struct dma_chan *chan, dma_addr_t *src,
>  		     unsigned int src_cnt, size_t len,
>  		     enum sum_check_flags *result, unsigned long flags)
> -- 
> 1.7.9.5
> 
