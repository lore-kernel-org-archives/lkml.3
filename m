Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab3KDDcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 22:32:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52870 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab3KDDcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 22:32:23 -0500
Date: Sun, 3 Nov 2013 20:32:19 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: Re: linux-next: build failure after merge of the block tree
Message-ID: <20131104033219.GE14163@kernel.dk>
References: <20131104141345.b2699b2cc7cdc347c5735c5a@canb.auug.org.au>
 <20131104032341.GD14163@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131104032341.GD14163@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03 2013, Jens Axboe wrote:
> On Mon, Nov 04 2013, Stephen Rothwell wrote:
> > Hi Jens,
> > 
> > [I merged the block tree *before* the aio-direct tree today ...]
> > 
> > After merging the block tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > In file included from include/linux/blkdev.h:18:0,
> >                  from drivers/block/ps3disk.c:22:
> > drivers/block/ps3disk.c: In function 'ps3disk_scatter_gather':
> > include/linux/bio.h:239:9: error: incompatible types when assigning to type 'struct bio_vec *' from type 'struct bio_vec'
> >    ((bvl = bio_iter_iovec((bio), (iter))), 1);  \
> >          ^
> > include/linux/bio.h:243:2: note: in expansion of macro '__bio_for_each_segment'
> >   __bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
> >   ^
> > include/linux/blkdev.h:748:3: note: in expansion of macro 'bio_for_each_segment'
> >    bio_for_each_segment(bvl, _iter.bio, _iter.iter)
> >    ^
> > drivers/block/ps3disk.c:102:2: note: in expansion of macro 'rq_for_each_segment'
> >   rq_for_each_segment(bvec, req, iter) {
> >   ^
> > include/linux/bio.h:239:41: warning: left-hand operand of comma expression has no effect [-Wunused-value]
> >    ((bvl = bio_iter_iovec((bio), (iter))), 1);  \
> >                                          ^
> > include/linux/bio.h:243:2: note: in expansion of macro '__bio_for_each_segment'
> >   __bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
> >   ^
> > include/linux/blkdev.h:748:3: note: in expansion of macro 'bio_for_each_segment'
> >    bio_for_each_segment(bvl, _iter.bio, _iter.iter)
> >    ^
> > drivers/block/ps3disk.c:102:2: note: in expansion of macro 'rq_for_each_segment'
> >   rq_for_each_segment(bvec, req, iter) {
> >   ^
> > include/linux/bio.h:240:45: error: request for member 'bv_len' in something not a structure or union
> >        bio_advance_iter((bio), &(iter), (bvl).bv_len))
> >                                              ^
> > include/linux/bio.h:243:2: note: in expansion of macro '__bio_for_each_segment'
> >   __bio_for_each_segment(bvl, bio, iter, (bio)->bi_iter)
> >   ^
> > include/linux/blkdev.h:748:3: note: in expansion of macro 'bio_for_each_segment'
> >    bio_for_each_segment(bvl, _iter.bio, _iter.iter)
> >    ^
> > drivers/block/ps3disk.c:102:2: note: in expansion of macro 'rq_for_each_segment'
> >   rq_for_each_segment(bvec, req, iter) {
> >   ^
> > 
> > I am not quite sure which commit caused this (maybe ed2d2f9a8265 ("block:
> > Abstract out bvec iterator")?).  I have used the block tree from
> > next-20131031 again for today.
> 
> Don't have ppc64 cross compiling handy, but the below should do the
> trick.

Checked, works for me. Committed and for-next branch updated.

-- 
Jens Axboe

