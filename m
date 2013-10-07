Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab3JGTeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:34:00 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37380 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab3JGTd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:33:59 -0400
Date: Mon, 7 Oct 2013 12:33:58 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk-mq: fix blk_mq_start_stopped_hw_queues from irq
 context
Message-ID: <20131007193358.GA14511@infradead.org>
References: <20131006170956.GA30544@infradead.org>
 <20131006181013.GE8252@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131006181013.GE8252@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 12:10:13PM -0600, Jens Axboe wrote:
> Thanks, applied. Might not be a bad idea to just mimic the run queue
> API, and provide a blk_mq_start_hw_queue(hctx, is_async) instead.

I have to see I really don't like this is_async, I'd much preper to
untangle those into separate versions further up the stack similar to
how the old blk_run_queue variants work.

But that'll have to wait a bit anyway, at least until you made a
decision on the plugging patch.

