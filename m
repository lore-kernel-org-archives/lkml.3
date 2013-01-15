Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab3AOBsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 20:48:42 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55017 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab3AOBsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 20:48:41 -0500
Date: Mon, 14 Jan 2013 17:49:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        akpm@linux-foundation.org, tj@kernel.org, axboe@kernel.dk,
        James.Bottomley@hansenpartnership.com, snitzer@redhat.com
Subject: Re: Bcache v. whatever
Message-ID: <20130115014931.GA19373@kroah.com>
References: <20130114223202.GV26407@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130114223202.GV26407@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 02:32:02PM -0800, Kent Overstreet wrote:
> Bcache: a block layer SSD cache
> 
> Does writethrough and writeback, handles unclean shutdown, and has
> various other nifty features. See the wiki and the documentation for
> more:
> 
> http://bcache.evilpiepirate.org
> 
> Over the Christmas break I finally got the tree into a self contained
> state that ought to be suitable for merging; this tree is fairly close
> to the previous stable tree that people have been running on production
> servers for awhile (and that I've been running on this workstation), 
> 
> So, I think this is ready for mainline and I'd like to get it in. I
> should've tried to push it ages ago, but I was hoping to get in various
> block layer cleanups first; I finally deided to work around them in the
> meantime since I haven't had time to finish the block layer stuff.
> 
> Not everything has been addressed since I last posted for review
> feedback - notably the closure code was controversial and for now I've
> just moved that into drivers/block/bcache (though I've been refactoring
> stuff to make it less asynchronous lately; most of that work is in the
> testing/dev branches). The bigger issue IMO is the userspace interface -
> I'd like to finish the md integration so it doesn't need userspace stuff
> for probing/bootup. So, I'd be fine with it going into staging if that's
> the consensus, but it's stable tested code.

If it goes into staging, I need a reason why it can't be merged into the
"real" part of the kernel, and what will be done to get it there.

Oh, and you will need to get acks from the people who's symbols you are
wanting to export, usually staging patches are self-contained.

thanks,

greg k-h
