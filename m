Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbaAIU7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 15:59:11 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:55521 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaAIU6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 15:58:49 -0500
Message-ID: <52CF0D85.7060905@bjorling.me>
Date: Thu, 09 Jan 2014 21:58:45 +0100
From: Matias Bjorling <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Muthu Kumar <muthu.lkml@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        tom.leiming@gmail.com
Subject: Re: [block:for-3.14/core] blk-mq: Compile fix for null_blk
References: <CAFR8uedovPTT0562nZSAfatjqqhyi8WXRdHj5wa9oCkVbzrBag@mail.gmail.com>
In-Reply-To: <CAFR8uedovPTT0562nZSAfatjqqhyi8WXRdHj5wa9oCkVbzrBag@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 07:54 PM, Muthu Kumar wrote:
> Jens,
>
> Compiling null_blk.ko failed with error that blk_mq_free_queue() was
> defined implicitly. So, moved the declaration from block/blk-mq.h to
> include/linux/blk-mq.h and exported it.
>

The patch from Ming Lei is missing in -rc6

4af48694451676403188a62385dd1a2849fc05c5
block: null_blk: fix queue leak inside removing device

Its queued for -rc7. It removes the usage of blk_mq_free_queue in blk_null.

> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
>
> ----------------------
>
>   block/blk-mq.c         |    1 +
>   block/blk-mq.h         |    1 -
>   include/linux/blk-mq.h |    1 +
>   3 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 57039fc..3e08b87 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1422,6 +1422,7 @@ void blk_mq_free_queue(struct request_queue *q)
>          list_del_init(&q->all_q_node);
>          mutex_unlock(&all_q_mutex);
>   }
> +EXPORT_SYMBOL(blk_mq_free_queue);
>
>   /* Basically redo blk_mq_init_queue with queue frozen */
>   static void blk_mq_queue_reinit(struct request_queue *q)
> diff --git a/block/blk-mq.h b/block/blk-mq.h
> index 5c39179..35ff4f7 100644
> --- a/block/blk-mq.h
> +++ b/block/blk-mq.h
> @@ -28,7 +28,6 @@ void blk_mq_run_request(struct request *rq, bool
> run_queue, bool async);
>   void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async);
>   void blk_mq_init_flush(struct request_queue *q);
>   void blk_mq_drain_queue(struct request_queue *q);
> -void blk_mq_free_queue(struct request_queue *q);
>
>   /*
>    * CPU hotplug helpers
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 851d34b..51109b8 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -113,6 +113,7 @@ enum {
>   };
>
>   struct request_queue *blk_mq_init_queue(struct blk_mq_reg *, void *);
> +void blk_mq_free_queue(struct request_queue *q);
>   int blk_mq_register_disk(struct gendisk *);
>   void blk_mq_unregister_disk(struct gendisk *);
>   void blk_mq_init_commands(struct request_queue *, void (*init)(void
> *data, struct blk_mq_hw_ctx *, struct request *, unsigned int), void
> *data);
>

