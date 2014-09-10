Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaIJTCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:02:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44111 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaIJTCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:02:50 -0400
Date: Wed, 10 Sep 2014 12:02:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 8/8] blk-mq: support per-distpatch_queue flush machinery
Message-ID: <20140910190247.GA28821@infradead.org>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
 <1410267949-21904-9-git-send-email-ming.lei@canonical.com>
 <20140909184856.GG16750@infradead.org>
 <CACVXFVNhmvy+aSgbJX8zgRVJQS0q6PWJLhmy_XVN_9YvSFdwag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNhmvy+aSgbJX8zgRVJQS0q6PWJLhmy_XVN_9YvSFdwag@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 09:40:11AM +0800, Ming Lei wrote:
> I am wondering we can do that because lifetime is totally different
> between flush requests and tag_set requests which are initialized
> before request queue is created.

We shouldn't do it in the tag sets, but where we allocate and free
each hctx: blk_mq_init_queue and blk_mq_free_hw_queues.

