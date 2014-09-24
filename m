Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaIXPVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:21:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49469 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaIXPVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:21:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140924102632.GE19078@lst.de>
References: <1410786675-7761-1-git-send-email-ming.lei@canonical.com>
	<1410786675-7761-11-git-send-email-ming.lei@canonical.com>
	<20140924102632.GE19078@lst.de>
Date: Wed, 24 Sep 2014 23:21:13 +0800
Message-ID: <CACVXFVOM_K_9ogwsBJ+2wTK-D-wbVVkOK3=60tgoTKsnTS+33g@mail.gmail.com>
Subject: Re: [PATCH v4 10/10] blk-mq: support per-distpatch_queue flush machinery
From: Ming Lei <ming.lei@canonical.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 6:26 PM, Christoph Hellwig <hch@lst.de> wrote:
>> +struct blk_flush_queue *blk_alloc_flush_queue(struct request_queue *q,
>> +             struct blk_mq_hw_ctx *hctx, int cmd_size)
>
> I still think this should pass in the numa node instead of the hctx, and
> allow node-local allocation for the old code as well.

We can do that, but have to pass NUMA_NO_NODE for old code
since blk_init_allocated_queue() doesn't provide node information
yet.

> As mentioned earlier
> initializing mq_flush_lock for the !mq case is harmless.

q->mq_ops is another friend for the purpose, :-)

>
> We also should document it where cleary somewhere that for devices that
> have flushes enabled ->init_request can be called for more requests than
> the queue depth, as drivers might allocate some sort of pool for them.

That does make sense.

Thanks,
