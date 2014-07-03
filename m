Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbaGCH6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:58:05 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:39283 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752907AbaGCH6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:58:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArhaAL0LtVN5LHZ8PGdsb2JhbABagw2DSoUIpBYBAgEBB5pVAYEIFwQBAQEBODWEAwEBBTocDxQQCAMYCSUPBSUDBxoTiEHHbxcYhViGDQGDJAeEQwWabJYMgVQr
Date: Thu, 3 Jul 2014 17:56:44 +1000
From: Dave Chinner <david@fromorbit.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, linux-kernel@vger.kernel.org,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        jason.low2@hp.com
Subject: Re: [regression, 3.16-rc] rwsem: optimistic spinning causing
 performance degradation
Message-ID: <20140703075644.GR4453@dastard>
References: <20140703023204.GN4453@dastard>
 <1404358268.23839.13.camel@buesod1.americas.hpqcorp.net>
 <20140703045933.GP4453@dastard>
 <20140703053911.GQ4453@dastard>
 <20140703073852.GV19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703073852.GV19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 09:38:52AM +0200, Peter Zijlstra wrote:
> On Thu, Jul 03, 2014 at 03:39:11PM +1000, Dave Chinner wrote:
> > There's another regression with the optimisitic spinning in rwsems
> > as well: it increases the size of the struct rw_semaphore by 16
> > bytes. That has increased the size of the struct xfs_inode by 32
> > bytes.
> > 
> > That's pretty damn significant - it's no uncommon to see machines
> > with tens of millions of cached XFS inodes, so increasing the size
> > of the inode by 4% is actually very significant. That's enough to go
> > from having a well balanced workload to not being able to fit the
> > working set of inodes in memory.
> > 
> > Filesystem developers will do almost anything to remove a few bytes
> > from the struct inode because inode cache footprint is extremely
> > important for performance. We also tend to get upset and
> > unreasonable when other people undo that hard work by making changes
> > that bloat the generic structures embedded in the inode
> > structures....
> 
> Jason Low actually did a patch, yesterday, to shrink rwsem back to its
> old size (on 64bit).

That's good to know. Thanks, Peter.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
