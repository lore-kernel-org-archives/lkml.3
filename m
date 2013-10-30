Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab3J3IwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 04:52:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab3J3Iv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 04:51:56 -0400
Date: Wed, 30 Oct 2013 16:51:24 +0800
From: Asias He <asias@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] virtio_blk: blk-mq support
Message-ID: <20131030085124.GA30084@hj.localdomain>
References: <20131025130459.730903511@bombadil.infradead.org>
 <20131025130735.637242058@bombadil.infradead.org>
 <87ob6aglgl.fsf@rustcorp.com.au>
 <20131028085206.GB31270@infradead.org>
 <527029C9.2030102@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <527029C9.2030102@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jens,

On Tue, Oct 29, 2013 at 03:34:01PM -0600, Jens Axboe wrote:
> On 10/28/2013 02:52 AM, Christoph Hellwig wrote:
> > On Mon, Oct 28, 2013 at 01:17:54PM +1030, Rusty Russell wrote:
> >> Let's pretend I'm stupid.
> >>
> >> We don't actually have multiple queues through to the host, but we're
> >> pretending to, because it makes the block layer go faster?
> >>
> >> Do I want to know *why* it's faster?  Or should I look the other way?
> > 
> > You shouldn't.  To how multiple queues benefit here I'd like to defer to
> > Jens, given the single workqueue I don't really know where to look here.
> 
> The 4 was chosen to "have some number of multiple queues" and to be able
> to exercise that part, no real performance testing was done by me after
> the implementation to verify whether it was faster at 1, 2, 4, or
> others. But it was useful for that! For merging, we can easily just make
> it 1 since that's the most logical transformation. I can set some time
> aside to play with multiple queues and see if we gain anything, but that
> can be done post merge.
> 
> > The real benefit that unfortunately wasn't obvious from the description
> > is that even with just a single queue the blk-multiqueue infrastructure
> > will be a lot faster, because it is designed in a much more streaminline
> > fashion and avoids lots of lock roundtrips both during submission itself
> > and for submission vs complettion.  Back when I tried to get virtio-blk
> > to perform well on high-end flash (the work that Asias took over later)
> > the queue_lock contention was the major issue in virtio-blk and this
> > patch gets rid of that even with a single queue.
> > 
> > A good example are the patches from Nick to move scsi drivers over to
> > the infrastructure that only support a single queue.  Even that gave
> > over a 10 fold improvement over the old code.
> > 
> > Unfortunately I do not have access to this kind of hardware at the
> > moment, but I'd love to see if Asias or anyone at Red Hat could redo
> > those old numbers.
> 
> I've got a variety of fast devices, so should be able to run that.
> Asias, let me know what your position is, it'd be great to have
> independent results.

I'd love to run the test but I do not have fast devices around. It would
be nice if Nick can give a try ;-)

1) Set .nr_hw_queues to 1 instead 4 for now.
2) Drop some more unused code in the other mail I sent

Otherwise, feel free to add:

Acked-by: Asias He <asias@redhat.com>

> -- 
> Jens Axboe
> 

-- 
Asias
