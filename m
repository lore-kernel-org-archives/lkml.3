Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3LaQ1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 11:27:00 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48776 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3LaQ05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 11:26:57 -0500
Date: Tue, 31 Dec 2013 09:26:54 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v1 4/5] block: null_blk: fix queue leak inside removing
 device
Message-ID: <20131231162654.GI21823@kernel.dk>
References: <1388064698-27344-1-git-send-email-tom.leiming@gmail.com>
 <1388064698-27344-5-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388064698-27344-5-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26 2013, Ming Lei wrote:
> When queue_mode is NULL_Q_MQ and null_blk is being removed,
> blk_cleanup_queue() isn't called to cleanup queue, so the
> queue allocated won't be freed.
> 
> This patch calls blk_cleanup_queue() for MQ to drain all
> pending requests first and release the reference counter
> of queue kobject, then blk_mq_free_queue() will be called
> in queue kobject's release handler when queue kobject's
> reference counter drops to zero.

I have applied this to for-linus for 3.13, the other 4 will go into
3.14.

-- 
Jens Axboe

