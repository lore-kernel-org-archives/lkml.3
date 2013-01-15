Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab3AOU7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 15:59:18 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:45288 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025Ab3AOU7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 15:59:16 -0500
Date: Tue, 15 Jan 2013 12:59:12 -0800
From: Kent Overstreet <koverstreet@google.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        akpm@linux-foundation.org, tj@kernel.org, axboe@kernel.dk,
        snitzer@redhat.com, agk@redhat.com, neilb@suse.de
Subject: Re: Bcache v. whatever
Message-ID: <20130115205912.GA26407@google.com>
References: <20130114223202.GV26407@google.com>
 <1358241656.2383.2.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358241656.2383.2.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 09:20:56AM +0000, James Bottomley wrote:
> On Mon, 2013-01-14 at 14:32 -0800, Kent Overstreet wrote:
> > Bcache: a block layer SSD cache
> > 
> > Does writethrough and writeback, handles unclean shutdown, and has
> > various other nifty features. See the wiki and the documentation for
> > more:
> > 
> > http://bcache.evilpiepirate.org
> > 
> > Over the Christmas break I finally got the tree into a self contained
> > state that ought to be suitable for merging; this tree is fairly close
> > to the previous stable tree that people have been running on production
> > servers for awhile (and that I've been running on this workstation), 
> > 
> > So, I think this is ready for mainline and I'd like to get it in. I
> > should've tried to push it ages ago, but I was hoping to get in various
> > block layer cleanups first; I finally deided to work around them in the
> > meantime since I haven't had time to finish the block layer stuff.
> > 
> > Not everything has been addressed since I last posted for review
> > feedback - notably the closure code was controversial and for now I've
> > just moved that into drivers/block/bcache (though I've been refactoring
> > stuff to make it less asynchronous lately; most of that work is in the
> > testing/dev branches). The bigger issue IMO is the userspace interface -
> > I'd like to finish the md integration so it doesn't need userspace stuff
> > for probing/bootup. So, I'd be fine with it going into staging if that's
> > the consensus, but it's stable tested code.
> > 
> > The code is available at
> > http://evilpiepirate.org/git/linux-bcache.git bcache-for-upstream
> > 
> > This latest branch is on top of v3.8-rc3:
> 
> The guy to merge this is the maintainer in that layer, which is Alasdair
> Kergon.  I know you've been sending patches to the dm-devel list, what's
> the reason you didn't include him in the cc list?  Is there some type of
> political problem in dm?  From reading the list, it looks like your
> patches are being tested and progressing, so what am I missing?

That was merely an oversight - but, bcache is currently just another
block device, it doesn't plug into dm or md. There was some md
integration work started, and that's the one I'm more inclined to work
on personally (if and when I find the time).

So I'm not sure why it'd go in via dm, it seems to me it'd make just as
much sense for it to go in via Neil Brown's tree. Unless there's
something I'm missing?
