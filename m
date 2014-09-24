Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbaIXK0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:26:36 -0400
Received: from verein.lst.de ([213.95.11.211]:52792 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaIXK0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:26:35 -0400
Date: Wed, 24 Sep 2014 12:26:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 10/10] blk-mq: support per-distpatch_queue flush
	machinery
Message-ID: <20140924102632.GE19078@lst.de>
References: <1410786675-7761-1-git-send-email-ming.lei@canonical.com> <1410786675-7761-11-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410786675-7761-11-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +struct blk_flush_queue *blk_alloc_flush_queue(struct request_queue *q,
> +		struct blk_mq_hw_ctx *hctx, int cmd_size)

I still think this should pass in the numa node instead of the hctx, and
allow node-local allocation for the old code as well.  As mentioned earlier
initializing mq_flush_lock for the !mq case is harmless. 


We also should document it where cleary somewhere that for devices that
have flushes enabled ->init_request can be called for more requests than
the queue depth, as drivers might allocate some sort of pool for them.
