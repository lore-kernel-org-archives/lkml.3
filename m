Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435AbaEPOyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:54:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48743 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475AbaEPOyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:54:52 -0400
Date: Fri, 16 May 2014 07:54:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] virtio_blk: fix race between start and stop queue
Message-ID: <20140516145450.GA5939@infradead.org>
References: <1400157181-17800-1-git-send-email-tom.leiming@gmail.com>
 <53762662.2050702@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53762662.2050702@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 08:53:22AM -0600, Jens Axboe wrote:
> >This patch fixes the problem by starting/stopping blk-mq
> >with holding vq_lock.
> 
> Why not just use blk_mq_start_hw_queues()?

That would kick off a work item on every I/O completion, something
you didn't particularly like in scsi-mq :)

