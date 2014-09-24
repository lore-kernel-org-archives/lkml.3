Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbaIXKVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:21:15 -0400
Received: from verein.lst.de ([213.95.11.211]:52775 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbaIXKVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:21:13 -0400
Date: Wed, 24 Sep 2014 12:21:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 08/10] block: introduce 'blk_mq_ctx' parameter to
	blk_get_flush_queue
Message-ID: <20140924102112.GC19078@lst.de>
References: <1410786675-7761-1-git-send-email-ming.lei@canonical.com> <1410786675-7761-9-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410786675-7761-9-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 09:11:12PM +0800, Ming Lei wrote:
> This patch adds 'blk_mq_ctx' parameter to blk_get_flush_queue(),
> so that this function can find the corresponding blk_flush_queue
> bound with current mq context since the flush queue will become
> per hw-queue.
> 
> For legacy queue, the parameter can be simply 'NULL'.
> 
> For multiqueue case, the parameter should be set as the context
> from which the related request is originated. With this context
> info, the hw queue and related flush queue can be found easily.

I think this should be merged into the patch introducing
blk_get_flush_queue.
