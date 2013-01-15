Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128Ab3AOXPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:15:47 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52585 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933709Ab3AOXPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 18:15:44 -0500
Message-ID: <1358291738.10591.23.camel@dabdike.int.hansenpartnership.com>
Subject: Re: Bcache v. whatever
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        akpm@linux-foundation.org, tj@kernel.org, axboe@kernel.dk,
        snitzer@redhat.com, agk@redhat.com, neilb@suse.de
Date: Tue, 15 Jan 2013 23:15:38 +0000
In-Reply-To: <20130115205912.GA26407@google.com>
References: <20130114223202.GV26407@google.com>
	 <1358241656.2383.2.camel@dabdike.int.hansenpartnership.com>
	 <20130115205912.GA26407@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-15 at 12:59 -0800, Kent Overstreet wrote:
> On Tue, Jan 15, 2013 at 09:20:56AM +0000, James Bottomley wrote:
> > On Mon, 2013-01-14 at 14:32 -0800, Kent Overstreet wrote:
> > > Bcache: a block layer SSD cache
> > > 
> > > Does writethrough and writeback, handles unclean shutdown, and has
> > > various other nifty features. See the wiki and the documentation for
> > > more:
> > > 
> > > http://bcache.evilpiepirate.org
> > > 
> > > Over the Christmas break I finally got the tree into a self contained
> > > state that ought to be suitable for merging; this tree is fairly close
> > > to the previous stable tree that people have been running on production
> > > servers for awhile (and that I've been running on this workstation), 
> > > 
> > > So, I think this is ready for mainline and I'd like to get it in. I
> > > should've tried to push it ages ago, but I was hoping to get in various
> > > block layer cleanups first; I finally deided to work around them in the
> > > meantime since I haven't had time to finish the block layer stuff.
> > > 
> > > Not everything has been addressed since I last posted for review
> > > feedback - notably the closure code was controversial and for now I've
> > > just moved that into drivers/block/bcache (though I've been refactoring
> > > stuff to make it less asynchronous lately; most of that work is in the
> > > testing/dev branches). The bigger issue IMO is the userspace interface -
> > > I'd like to finish the md integration so it doesn't need userspace stuff
> > > for probing/bootup. So, I'd be fine with it going into staging if that's
> > > the consensus, but it's stable tested code.
> > > 
> > > The code is available at
> > > http://evilpiepirate.org/git/linux-bcache.git bcache-for-upstream
> > > 
> > > This latest branch is on top of v3.8-rc3:
> > 
> > The guy to merge this is the maintainer in that layer, which is Alasdair
> > Kergon.  I know you've been sending patches to the dm-devel list, what's
> > the reason you didn't include him in the cc list?  Is there some type of
> > political problem in dm?  From reading the list, it looks like your
> > patches are being tested and progressing, so what am I missing?
> 
> That was merely an oversight - but, bcache is currently just another
> block device, it doesn't plug into dm or md. There was some md
> integration work started, and that's the one I'm more inclined to work
> on personally (if and when I find the time).

I think md integration would be a bit of a mistake, since md is pretty
much only a raid engine at this point in time.  There are also a couple
of other dm cache targets, so it would be nice to have one rather than
three.  This all, however, seems to be under discussion on the dm list.

> So I'm not sure why it'd go in via dm, it seems to me it'd make just as
> much sense for it to go in via Neil Brown's tree. Unless there's
> something I'm missing?

Um, well there's no caching patches in the md tree; it's RAID only.  The
basic caching stuff is all in the dm tree, which is why it's the natural
one.

It seems to me that your stuff is progressing on the dm list, so I don't
really see a need to circumvent the process in the dm tree ... unless
there's some problem I'm not seeing?

James


