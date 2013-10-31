Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3JaOKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 10:10:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43386 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416Ab3JaOKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:10:18 -0400
Date: Thu, 31 Oct 2013 08:10:16 -0600
From: axboe <axboe@kernel.dk>
To: NeilBrown <neilb@suse.de>
Cc: majianpeng <majianpeng@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 3/3] md/raid5: For stripe with R5_ReadNoMerge, we replace
 REQ_FLUSH with REQ_NOMERGE.
Message-ID: <20131031141016.GE10091@kernel.dk>
References: <2013103010414134402615@gmail.com>
 <20131031141056.1525429a@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031141056.1525429a@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31 2013, NeilBrown wrote:
> On Wed, 30 Oct 2013 10:41:46 +0800 majianpeng <majianpeng@gmail.com> wrote:
> 
> > For R5_ReadNoMerge,it mean this bio can't merge with other bios or
> > request.It used REQ_FLUSH to achieve this. But REQ_NOMERGE can do the
> > same work.
> > 
> > Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> > ---
> >  drivers/md/raid5.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index f8b9068..8e0aeaa 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -772,7 +772,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
> >  				bi->bi_sector = (sh->sector
> >  						 + rdev->data_offset);
> >  			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
> > -				bi->bi_rw |= REQ_FLUSH;
> > +				bi->bi_rw |= REQ_NOMERGE;
> >  
> >  			bi->bi_vcnt = 1;
> >  			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
> 
> Thanks.
> 
> I've queued this up pending Jens' acceptance of the other patches.

I've queued up the other two for 3.13.

-- 
Jens Axboe

