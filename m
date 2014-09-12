Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaILPUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:20:15 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:32832 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaILPUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:20:13 -0400
Message-ID: <54130F2A.7060508@kernel.dk>
Date: Fri, 12 Sep 2014 09:20:10 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
CC: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 9/9] blk-mq: support per-distpatch_queue flush machinery
References: <1410533253-8045-1-git-send-email-ming.lei@canonical.com> <1410533253-8045-10-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1410533253-8045-10-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-12 08:47, Ming Lei wrote:
> @@ -31,7 +33,15 @@ extern struct ida blk_queue_ida;
>   static inline struct blk_flush_queue *blk_get_flush_queue(
>   		struct request_queue *q, struct blk_mq_ctx *ctx)
>   {
> -	return q->fq;
> +	struct blk_mq_hw_ctx *hctx;
> +
> +	if (!q->mq_ops)
> +		return q->fq;
> +
> +	WARN_ON(!ctx);
> +	hctx = q->mq_ops->map_queue(q, ctx->cpu);
> +
> +	return hctx->fq;

Kill the WARN_ON(), we'll know soon enough of this happens anyway.


-- 
Jens Axboe

