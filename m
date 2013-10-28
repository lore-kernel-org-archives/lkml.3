Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab3J1Is1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 04:48:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37471 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3J1Is0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:48:26 -0400
Date: Mon, 28 Oct 2013 01:48:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>, linux-kernel@vger.kernel.org
Subject: Re: blk-mq flush fix
Message-ID: <20131028084821.GA31270@infradead.org>
References: <20131026114612.GA8576@infradead.org>
 <20131026153124.GA22227@infradead.org>
 <20131027222914.GG22549@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027222914.GG22549@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 10:29:25PM +0000, Jens Axboe wrote:
> On Sat, Oct 26 2013, Christoph Hellwig wrote:
> > I think this variant of the patch from Alexander should fix the issue
> > in a minimally invasive way.  Longer term I'd prefer to use q->flush_rq
> > like in the non-mq case by copying over the context and tag information.
> 
> This one is pretty simple, we could definitely use it as a band aid. I
> too would greatly prefer using the static ->flush_rq instead. Just have
> it marked to bypass most of the free logic.

We already bypass the free logical by setting and end_io callback for
a while, similar to what the old code does.  Maybe it's not all that
hard to prealloc the request, let me give a sping.  Using the static
allocated one will be hard due to the driver-specific extra data,
though.

> I'll add this one.

Gimme another day or so to figure this out.
