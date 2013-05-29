Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965955Ab3E2NES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:04:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53319 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934624Ab3E2NER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:04:17 -0400
Date: Wed, 29 May 2013 15:03:40 +0200
From: Jens Axboe <axboe@kernel.dk>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: Kent Overstreet <koverstreet@google.com>,
        Calvin Owens <jcalvinowens@gmail.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>,
        majianpeng@gmail.com
Subject: Re: [PATCH] md: Partially revert 2f6db2a7, which broke raid5
Message-ID: <20130529130340.GC22724@kernel.dk>
References: <20130517213223.GA2530@gmail.com>
 <20130518070515.GL19781@kernel.dk>
 <20130519175145.GC19194@moria.home.lan>
 <20130529124357.GA15210@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529124357.GA15210@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29 2013, Richard W.M. Jones wrote:
> 
> On Sun, May 19, 2013 at 10:51:45AM -0700, Kent Overstreet wrote:
> > Sorry for the delay - been vacationing. Reproduced the original bug,
> > here's a patch that fixes it:
> > 
> > 
> > commit 402f5db3708b2062795a384a3d8397cf702e27bc
> > Author: Kent Overstreet <koverstreet@google.com>
> > Date:   Sun May 19 10:27:07 2013 -0700
> > 
> >     raid5: Initialize bi_vcnt
> >     
> >     The patch that converted raid5 to use bio_reset() forgot to initialize
> >     bi_vcnt.
> >     
> >     Signed-off-by: Kent Overstreet <koverstreet@google.com>
> >     Cc: NeilBrown <neilb@suse.de>
> >     Cc: Jens Axboe <axboe@kernel.dk>
> >     Cc: linux-raid@vger.kernel.org
> > 
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 9359828..753f318 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -664,6 +664,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
> >  			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
> >  				bi->bi_rw |= REQ_FLUSH;
> >  
> > +			bi->bi_vcnt = 1;
> >  			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
> >  			bi->bi_io_vec[0].bv_offset = 0;
> >  			bi->bi_size = STRIPE_SIZE;
> > @@ -701,6 +702,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
> >  			else
> >  				rbi->bi_sector = (sh->sector
> >  						  + rrdev->data_offset);
> > +			rbi->bi_vcnt = 1;
> >  			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
> >  			rbi->bi_io_vec[0].bv_offset = 0;
> >  			rbi->bi_size = STRIPE_SIZE;
> 
> Ditto to the previous follow up.  We've been tracking this
> bug for nearly a month:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=962079
> 
> Please include this (or the other) patch to fix it.

I'm assuming both Kent and I are waiting for Neil to pick it up. Neil, I
can include this in my next round going upstream, just let me know. It
should have been sent upstream a while back, sorry guys.

-- 
Jens Axboe

