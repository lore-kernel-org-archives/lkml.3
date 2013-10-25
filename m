Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3JYNoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:44:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36141 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab3JYNoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:44:15 -0400
Date: Fri, 25 Oct 2013 14:44:10 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Asias He <asias@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] blk-mq: add blk_mq_stop_hw_queues
Message-ID: <20131025134410.GB2815@kernel.dk>
References: <20131025130459.730903511@bombadil.infradead.org>
 <20131025130735.440114225@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025130735.440114225@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25 2013, Christoph Hellwig wrote:
> Add a helper to iterate over all hw queues and stop them.  This is useful
> for driver that implement PM suspend functionality.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-mq.c         |   12 ++++++++++++
>  include/linux/blk-mq.h |    1 +
>  2 files changed, 13 insertions(+)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index f21ec96..04050a3 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -679,6 +679,18 @@ void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx)
>  }
>  EXPORT_SYMBOL(blk_mq_start_hw_queue);
>  
> +void blk_mq_stop_hw_queues(struct request_queue *q)
> +{
> +	struct blk_mq_hw_ctx *hctx;
> +	int i;
> +
> +	queue_for_each_hw_ctx(q, hctx, i) {
> +		cancel_delayed_work(&hctx->delayed_work);
> +		set_bit(BLK_MQ_S_STOPPED, &hctx->state);
> +	}

I changed this to call blk_mq_stop_hw_queue() instead.

-- 
Jens Axboe

