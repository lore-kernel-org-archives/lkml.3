Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaFJL2c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 07:28:32 -0400
Received: from verein.lst.de ([213.95.11.211]:39498 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbaFJL2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 07:28:31 -0400
Date: Tue, 10 Jun 2014 13:28:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] blk-mq: kick requeue list in blk_mq_requeue_request()
Message-ID: <20140610112827.GA359@lst.de>
References: <1402375925-21720-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402375925-21720-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 12:52:05PM +0800, Ming Lei wrote:
> blk_mq_requeue_request() should kick off the requeue list so
> that the request can be scheduled to queue finally.
> 
> In nvme conversion patch, blk_mq_requeue_request() is called
> to requeue failed request from completion handler, this patch
> fixes the issue and makes the block API working as expected.

I've intentionally kepts the two separate so that we can batch operations
and just do a single kick for multiple requeued commands.

