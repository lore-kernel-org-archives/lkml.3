Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbaIQQoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:44:06 -0400
Received: from verein.lst.de ([213.95.11.211]:39884 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334AbaIQQoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:44:04 -0400
Date: Wed, 17 Sep 2014 18:44:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@canonical.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] blk-mq: fix race between timeout and queue_rq
Message-ID: <20140917164400.GA18472@lst.de>
References: <1410947278-15733-1-git-send-email-ming.lei@canonical.com> <1410947278-15733-2-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410947278-15733-2-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 05:47:57PM +0800, Ming Lei wrote:
> Either the request is from requeue or just being allocated from
> tag pool, its REQ_ATOM_STARTED flag has been cleared already, so
> don't test it in blk_mq_start_request().
> 
> One memory barrier is needed between writing rq->deadline and
> setting REQ_ATOM_STARTED so that timeout can't happen too early
> if timeout handler reads obsolete rq->deadline caused by out
> of order of the two writes.

Looks reasonable to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>
