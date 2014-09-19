Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbaISRsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 13:48:10 -0400
Received: from verein.lst.de ([213.95.11.211]:44328 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107AbaISRsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:48:09 -0400
Date: Fri, 19 Sep 2014 19:48:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-mq: auto-start hw queue in requeue
Message-ID: <20140919174806.GA19983@lst.de>
References: <1411136570-23439-1-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411136570-23439-1-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 10:22:50PM +0800, Ming Lei wrote:
> Requests often need to be retried because of timeout, hardware
> busy or sort of reasons via blk_mq_requeue_request(), but at
> that time dispatch queue may have been stopped.
> 
> This patch starts the dispatch queue automatically in requeue's
> work handler, and fixes scsi-mq's timeout issue, which can be
> triggered if there are two or more requests timedout.

Sounds like blk_mq_requeue_work should simply call void
blk_mq_start_hw_queues where it calls blk_mq_run_queues currently.

