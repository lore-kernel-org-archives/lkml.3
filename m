Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaKCKKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:10:44 -0500
Received: from verein.lst.de ([213.95.11.211]:48332 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbaKCKKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:10:43 -0500
Date: Mon, 3 Nov 2014 11:10:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>,
        Richard Weinberger <richard@nod.at>, ceph-devel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] blk-mq: allow direct dispatch to a driver specific
	workqueue
Message-ID: <20141103101039.GA10128@lst.de>
References: <1415003008-16683-1-git-send-email-hch@lst.de> <1415003008-16683-3-git-send-email-hch@lst.de> <CACVXFVMrW-GSa1YMuvGx=vvxxP2ePwxvTAKzdyv=ZYh6yf+Z5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVMrW-GSa1YMuvGx=vvxxP2ePwxvTAKzdyv=ZYh6yf+Z5g@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:40:47PM +0800, Ming Lei wrote:
> The above two aren't enough because the big problem is that
> drivers need a per-request work structure instead of 'hctx->run_work',
> otherwise there are at most NR_CPUS concurrent submissions.
> 
> So the per-request work structure should be exposed to blk-mq
> too for the kind of usage, such as .blk_mq_req_work(req) callback
> in case of BLK_MQ_F_WORKQUEUE.

Hmm.  Maybe a better option is to just add a flag to never defer
->queue_rq to a workqueue and let drivers handle the it?
