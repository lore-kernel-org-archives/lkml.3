Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab3HAWiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:38:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39871 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab3HAWiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:38:04 -0400
Date: Thu, 1 Aug 2013 23:37:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, Jens Axboe <axboe@kernel.dk>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH RFC 47/51] ARM: 7794/1: block: Rename parameter
	dma_mask to max_addr for blk_queue_bounce_limit()
Message-ID: <20130801223732.GM23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk> <E1V51FC-0006uT-GG@rmk-PC.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1V51FC-0006uT-GG@rmk-PC.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, these last patches were of course sent my me and not Santosh.

On Thu, Aug 01, 2013 at 11:21:14PM +0100, Santosh Shilimkar wrote:
> The blk_queue_bounce_limit() API parameter 'dma_mask' is actually the
> maximum address the device can handle rather than a dma_mask. Rename
> it accordingly to avoid it being interpreted as dma_mask.
> 
> No functional change.
> 
> The idea is to fix the bad assumptions about dma_mask wherever it could
> be miss-interpreted.
> 
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  block/blk-settings.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index c50ecf0..026c151 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -195,17 +195,17 @@ EXPORT_SYMBOL(blk_queue_make_request);
>  /**
>   * blk_queue_bounce_limit - set bounce buffer limit for queue
>   * @q: the request queue for the device
> - * @dma_mask: the maximum address the device can handle
> + * @max_addr: the maximum address the device can handle
>   *
>   * Description:
>   *    Different hardware can have different requirements as to what pages
>   *    it can do I/O directly to. A low level driver can call
>   *    blk_queue_bounce_limit to have lower memory pages allocated as bounce
> - *    buffers for doing I/O to pages residing above @dma_mask.
> + *    buffers for doing I/O to pages residing above @max_addr.
>   **/
> -void blk_queue_bounce_limit(struct request_queue *q, u64 dma_mask)
> +void blk_queue_bounce_limit(struct request_queue *q, u64 max_addr)
>  {
> -	unsigned long b_pfn = dma_mask >> PAGE_SHIFT;
> +	unsigned long b_pfn = max_addr >> PAGE_SHIFT;
>  	int dma = 0;
>  
>  	q->bounce_gfp = GFP_NOIO;
> -- 
> 1.7.4.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
