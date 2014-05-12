Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbaELKCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 06:02:20 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:35744 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaELKCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 06:02:19 -0400
Message-ID: <53709C1D.6050005@huawei.com>
Date: Mon, 12 May 2014 18:02:05 +0800
From: Weng Meiling <wengmeiling.weng@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Li Zefan <lizefan@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        Huang Qiang <h.huangqiang@huawei.com>
Subject: Re: block: correct the blk drain name comment
References: <537096C7.7040500@huawei.com>
In-Reply-To: <537096C7.7040500@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.24.66]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore the message， I forget to modify the SOB message.
Sorry for this.

Thanks!
Weng Meiling
On 2014/5/12 17:39, Weng Meiling wrote:
> After patch commit 807592a4fafb("block: Let blk_drain_queue() caller
> obtain the queue lock") the function blk_drain_queue() had been renamed
> to __blk_drain_queue(), so correct the related comments.
> 
> Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
> ---
>  block/blk-cgroup.c     | 2 +-
>  block/blk-core.c       | 2 +-
>  include/linux/blkdev.h | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index e4a4145..8234eb1 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -856,7 +856,7 @@ int blkcg_init_queue(struct request_queue *q)
>   * blkcg_drain_queue - drain blkcg part of request_queue
>   * @q: request_queue to drain
>   *
> - * Called from blk_drain_queue().  Responsible for draining blkcg part.
> + * Called from __blk_drain_queue().  Responsible for draining blkcg part.
>   */
>  void blkcg_drain_queue(struct request_queue *q)
>  {
> diff --git a/block/blk-core.c b/block/blk-core.c
> index a0e3096..f62d8a0 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -279,7 +279,7 @@ inline void __blk_run_queue_uncond(struct request_queue *q)
>  	 * Some request_fn implementations, e.g. scsi_request_fn(), unlock
>  	 * the queue lock internally. As a result multiple threads may be
>  	 * running such a request function concurrently. Keep track of the
> -	 * number of active request_fn invocations such that blk_drain_queue()
> +	 * number of active request_fn invocations such that __blk_drain_queue()
>  	 * can wait until all these request_fn calls have finished.
>  	 */
>  	q->request_fn_active++;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 0d84981..4835cc9 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -421,7 +421,7 @@ struct request_queue {
>  	unsigned int		nr_sorted;
>  	unsigned int		in_flight[2];
>  	/*
> -	 * Number of active block driver functions for which blk_drain_queue()
> +	 * Number of active block driver functions for which __blk_drain_queue()
>  	 * must wait. Must be incremented around functions that unlock the
>  	 * queue_lock internally, e.g. scsi_request_fn().
>  	 */
> 


