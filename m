Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab3JHSjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 14:39:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46678 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3JHSjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 14:39:52 -0400
Date: Tue, 8 Oct 2013 12:39:49 -0600
From: Jens Axboe <axboe@kernel.dk>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH RFC 0/2] Convert from bio-based to blk-mq
Message-ID: <20131008183949.GB23288@kernel.dk>
References: <1381224862-5299-1-git-send-email-m@bjorling.me>
 <20131008131036.GC7422@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131008131036.GC7422@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08 2013, Matthew Wilcox wrote:
> On Tue, Oct 08, 2013 at 11:34:20AM +0200, Matias Bjørling wrote:
> > The nvme driver implements itself as a bio-based driver. This primarily because
> > of high lock congestion for high-performance nvm devices. To remove the
> > congestion, a multi-queue block layer is being implemented.
> 
> Um, no.  You'll crater performance by adding another memory allocation
> (of the struct request).  multi-queue is not the solution.

That's a rather "jump to conclusions" statement to make. As Matias
mentioned, there are no extra fast path allocations. Once the tagging is
converted as well, I'd be surprised if it performs worse than before.
And that on top of a net reduction in code.

blk-mq might not be perfect as it stands, but it's a helluva lot better
than a bunch of flash based drivers with lots of duplicated code and
mechanisms. We need to move away from that.

-- 
Jens Axboe

