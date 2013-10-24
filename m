Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab3JXJjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:39:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51768 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab3JXJjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:39:46 -0400
Date: Thu, 24 Oct 2013 02:39:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 02/11] smp: don't warn about csd->flags having
 CSD_FLAG_LOCK cleared for !wait
Message-ID: <20131024093945.GA9433@infradead.org>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
 <1382606764-8309-3-git-send-email-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382606764-8309-3-git-send-email-axboe@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 10:25:55AM +0100, Jens Axboe wrote:
> blk-mq reuses the request potentially immediately, since the most
> cache hot is always given out first. This means that rq->csd could
> be reused between csd->func() being called and csd_unlock() being
> called. This isn't a problem, since we never use wait == 1 for
> the smp call function. Add CSD_FLAG_WAIT to be able to tell the
> difference, retaining the warning for other cases.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Looks fine, but I'd be tempted to just delete the WARN_ON and add a
comment similar to the commit message there.

