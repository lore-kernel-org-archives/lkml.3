Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab3JEKuQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 06:50:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56221 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3JEKuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 06:50:14 -0400
Date: Sat, 5 Oct 2013 03:50:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] [PATCH 2/5] revert: "blk-mq: blk-mq should free bios
 in pass through case"
Message-ID: <20131005105008.GA19022@infradead.org>
References: <20131004134908.231874670@bombadil.infradead.org>
 <20131004135014.524075942@bombadil.infradead.org>
 <524EFD55.4050701@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524EFD55.4050701@cs.wisc.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 12:39:33PM -0500, Mike Christie wrote:
> Sorry, messed up function name. I meant blk_end_request*.
> 
> For blk_execute_rq_nowait/blk_execute_rq and normal request use, the
> lower levels free the bios as they are completed by one of the
> blk_finish_request* calls. The caller of of
> blk_execute_rq_nowait/blk_execute_rq does not have to worry about
> freeing bios. It just frees the request when it is done with it.

Are you talking about bios or requests?  All these functions deal with
requests, so the talk of bios really confuses me.

That beeing said the old ones all require the caller to free the
request, and complicate that with the useless refcounting that my patch
3 removes.  Take a look at the other patches how all the calling
conventions can be nicely unified.

