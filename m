Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967793Ab3E3Hbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:31:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab3E3Hba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:31:30 -0400
Date: Thu, 30 May 2013 08:31:21 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <koverstreet@google.com>,
        Calvin Owens <jcalvinowens@gmail.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, majianpeng@gmail.com
Subject: Re: [PATCH] md: Partially revert 2f6db2a7, which broke raid5
Message-ID: <20130530073120.GP4515@redhat.com>
References: <20130517213223.GA2530@gmail.com>
 <20130518070515.GL19781@kernel.dk>
 <20130519175145.GC19194@moria.home.lan>
 <20130529124357.GA15210@redhat.com>
 <20130529130340.GC22724@kernel.dk>
 <20130530092243.52fa17c3@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130530092243.52fa17c3@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 09:22:43AM +1000, NeilBrown wrote:
> On Wed, 29 May 2013 15:03:40 +0200 Jens Axboe <axboe@kernel.dk> wrote:
> 
> > On Wed, May 29 2013, Richard W.M. Jones wrote:
> > > 
> > > On Sun, May 19, 2013 at 10:51:45AM -0700, Kent Overstreet wrote:
> > > > Sorry for the delay - been vacationing. Reproduced the original bug,
> > > > here's a patch that fixes it:
> > > > 
> > > > 
> > > > commit 402f5db3708b2062795a384a3d8397cf702e27bc
> > > > Author: Kent Overstreet <koverstreet@google.com>
> > > > Date:   Sun May 19 10:27:07 2013 -0700
> > > > 
> > > >     raid5: Initialize bi_vcnt
> > > >     
> > > >     The patch that converted raid5 to use bio_reset() forgot to initialize
> > > >     bi_vcnt.
> > > >     
> > > >     Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > > >     Cc: NeilBrown <neilb@suse.de>
> > > >     Cc: Jens Axboe <axboe@kernel.dk>
> > > >     Cc: linux-raid@vger.kernel.org
> > > > 
> > > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > > index 9359828..753f318 100644
> > > > --- a/drivers/md/raid5.c
> > > > +++ b/drivers/md/raid5.c
> > > > @@ -664,6 +664,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
> > > >  			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
> > > >  				bi->bi_rw |= REQ_FLUSH;
> > > >  
> > > > +			bi->bi_vcnt = 1;
> > > >  			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
> > > >  			bi->bi_io_vec[0].bv_offset = 0;
> > > >  			bi->bi_size = STRIPE_SIZE;
> > > > @@ -701,6 +702,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
> > > >  			else
> > > >  				rbi->bi_sector = (sh->sector
> > > >  						  + rrdev->data_offset);
> > > > +			rbi->bi_vcnt = 1;
> > > >  			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
> > > >  			rbi->bi_io_vec[0].bv_offset = 0;
> > > >  			rbi->bi_size = STRIPE_SIZE;
> > > 
> > > Ditto to the previous follow up.  We've been tracking this
> > > bug for nearly a month:
> > > 
> > > https://bugzilla.redhat.com/show_bug.cgi?id=962079
> > > 
> > > Please include this (or the other) patch to fix it.
> > 
> > I'm assuming both Kent and I are waiting for Neil to pick it up. Neil, I
> > can include this in my next round going upstream, just let me know. It
> > should have been sent upstream a while back, sorry guys.
> > 
> 
> Seems you were waiting for me, and I was waiting for you :-)
> 
> Yes: please include it with your next round.  Thanks!

BTW I tested this patch and it works, so:

Tested-by: Richard W.M. Jones <rjones@redhat.com>

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Fedora Windows cross-compiler. Compile Windows programs, test, and
build Windows installers. Over 100 libraries supported.
http://fedoraproject.org/wiki/MinGW
