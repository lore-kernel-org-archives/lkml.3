Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3L0CVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 21:21:55 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42343 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3L0CVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 21:21:54 -0500
Date: Thu, 26 Dec 2013 21:21:42 -0500
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org,
        Linux-pm mailing list <linux-pm@vger.kernel.org>
Subject: Re: No freezing of kernel threads (was: Re: [GIT PULL] libata fixes
 for v3.13-rc5)
Message-ID: <20131227022142.GD16483@htj.dyndns.org>
References: <20131226190120.GC16483@htj.dyndns.org>
 <Pine.LNX.4.44L0.1312262048540.29101-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1312262048540.29101-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 26, 2013 at 09:14:49PM -0500, Alan Stern wrote:
> I can't disagree with this.  But the design may well be perfectly
> adequate for some use cases.  Given a workqueue or kthread which should
> not operate during system sleep, we have to:
> 
> 	Tell the wq/thread to stop running because a sleep is about
> 	to start, and
> 
> 	Provide a function the wq/thread can call to put itself on 
> 	hold for the duration of the sleep.
> 
> The freezer does both these things pretty efficiently.  Problems may

I don't even like the interface itself.  It's too implicit and spread
all over the place - we basically had to spread it all over the wait
interfaces, and the implementation is far more involved than called
for.  I don't know how you're defining "efficiently" but that isn't a
word I'd use to describe the freezer.

> So you're suggesting changing the kthread to a workqueue thread, but
> keeping the existing list of scheduled events instead of relying on the
> workqueue's own queue of work items?  What's the advantage?  Making
> such a change wouldn't simplify anything.

Well, that'd be an easy first step which does away with the dedicated
kthread, likely reduces cache footprint and allows use of wq
synchronization / freezing constructs which are easier to deal with.
More involved conversion would of course be doable but even simple
conversion seems like a win.

Thanks.

-- 
tejun
