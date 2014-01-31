Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845AbaAaPIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:08:15 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:45650 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722AbaAaPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:08:12 -0500
Date: Fri, 31 Jan 2014 16:08:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] block: Stop abusing rq->csd.list in blk-softirq
Message-ID: <20140131150805.GA21061@localhost.localdomain>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
 <1387831171-5264-3-git-send-email-jack@suse.cz>
 <20140130123917.GA5339@localhost.localdomain>
 <20140130154523.GC12687@quack.suse.cz>
 <20140130170119.GB5339@localhost.localdomain>
 <20140130221241.GB31225@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140130221241.GB31225@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 11:12:41PM +0100, Jan Kara wrote:
> On Thu 30-01-14 18:01:20, Frederic Weisbecker wrote:
> > On Thu, Jan 30, 2014 at 04:45:23PM +0100, Jan Kara wrote:
> > >   Hi,
> > > 
> > > On Thu 30-01-14 13:39:18, Frederic Weisbecker wrote:
> > > > I'm currently working on some cleanups on IPI code too and working on top
> > > > of these patches, just have a few comments:
> > >   Great, thanks!
> > > 
> > > > On Mon, Dec 23, 2013 at 09:39:23PM +0100, Jan Kara wrote:
> > > > > Abusing rq->csd.list for a list of requests to complete is rather ugly.
> > > > > Especially since using queuelist should be safe and much cleaner.
> > > > 
> > > > It would be nice to have a few more details that explain why doing so is safe
> > > > wrt a block request lifecycle. At least something that tells why rq->queuelist
> > > > can't be ever used concurrently by the time we send the IPI and we trigger/raise
> > > > the softirq.
> > >   Sure. Should I send the patch to you with an updated changelog and added
> > > comment you requested?
> > 
> > Yeah that would be nice!
>   OK, the updated patch is attached.

Applied, thanks!

Note that the llist use in smp.c patch from Christoph has been merged
upstream today. But it keeps list_head in a union so I applied your changes
that:

1) remove list_head from smp.c
2) use llist_for_each_entry_safe()

in seperate delta patches. Anyway, I'll send the series soonish.
