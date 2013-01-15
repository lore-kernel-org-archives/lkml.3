Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab3AOVSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:18:42 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49556 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab3AOVSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:18:41 -0500
Date: Tue, 15 Jan 2013 13:18:37 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        akpm@linux-foundation.org, tj@kernel.org, axboe@kernel.dk,
        James.Bottomley@hansenpartnership.com, snitzer@redhat.com
Subject: Re: Bcache v. whatever
Message-ID: <20130115211837.GB26407@google.com>
References: <20130114223202.GV26407@google.com>
 <20130115014931.GA19373@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130115014931.GA19373@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 05:49:31PM -0800, Greg KH wrote:
> On Mon, Jan 14, 2013 at 02:32:02PM -0800, Kent Overstreet wrote:
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
> 
> If it goes into staging, I need a reason why it can't be merged into the
> "real" part of the kernel, and what will be done to get it there.

I don't personally see why it can't, but maybe other people will chime
in. There's certainly still stuff to do (something this size is never
finished) but I'm not abandoning the code.

> Oh, and you will need to get acks from the people who's symbols you are
> wanting to export, usually staging patches are self-contained.

Yeah, good point. I'll mail out those patches now.
