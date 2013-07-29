Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab3G2HGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:06:52 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:53354 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755321Ab3G2HGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:06:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At4HAAYT9lF5LPxH/2dsb2JhbABbgwa5KYUygRMXdIIkAQEEATocIxAIAxgJJQ8FJQMhE4gKBbdtFo9nB4QHA5dekU2DJio
Date: Mon, 29 Jul 2013 17:06:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: davej@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, hch@lst.de,
        jack@suse.cz, curtw@google.com, jaxboe@fusionio.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC fs] v2 Make sync() satisfy many requests with one
 invocation
Message-ID: <20130729070643.GH21982@dastard>
References: <20130726232852.GA15147@linux.vnet.ibm.com>
 <20130727025703.GF21982@dastard>
 <20130727040524.GC26694@linux.vnet.ibm.com>
 <20130727062101.GG21982@dastard>
 <20130727112628.GE26694@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130727112628.GE26694@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 04:26:28AM -0700, Paul E. McKenney wrote:
> On Sat, Jul 27, 2013 at 04:21:01PM +1000, Dave Chinner wrote:
> > On Fri, Jul 26, 2013 at 09:05:24PM -0700, Paul E. McKenney wrote:
> > > Could you please send your patches over to Dave Jones right now?  I am
> > > getting quite tired of getting RCU CPU stall warning complaints from
> > > him that turn out to be due to highly contended sync() system calls.
> > 
> > Then ignore them until the code is ready - it'll be 3.12 before the
> > fixes are merged, anyway, because the lock contention fix requires
> > infrastructure that is currently in mmotm that is queued for 3.12
> > (i.e. the per-node list infrastructure) to fix a whole bunch of
> > other, more critical VFS lock contention problems. Seeing as a new
> > mmotm went out last week, I should have the patches ready for review
> > early next week.
> > 
> > FWIW, we (as in XFS filesystem testers) regularly run tests that
> > have hundreds of concurrent sys_sync() calls running at the same
> > time. e.g. xfstests::xfs/297 runs a 1000 fsstress processes while
> > freezing and unfreezing the filesystem, and that usually shows
> > hundreds of threads running sys_sync concurrently after a short
> > amount of runtime. So it's pretty clear that what Dave is seeing
> > is not necessarily representative of what happens when there ar lots
> > of sys_sync() calls run concurrently.
> 
> So Dave might be finding an additional problem.  ;-)

Dave will always find problems. If you want something broken, give
it to Dave and he'll hand it back in pieces. :)

> > BTW, concurrent syncfs() calls are going to have exactly the same
> > problem as concurrent sync() calls, as is any other operation that
> > results in a walk of the per-superblock inodes list.
> 
> Yep!  Your upcoming patch addresses these as well?

Yes, it does.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
