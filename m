Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab3F3Ce2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 22:34:28 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:8717 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751Ab3F3Ce1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 22:34:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuQLAPaXz1F5LakP/2dsb2JhbABZgwm6aoUfBAF+F3SCIwEBBTocIxAIAxgJJQ8FJQMhE4gOulAWjiuBHQeDBGMDl0eRRoMjKg
Date: Sun, 30 Jun 2013 12:34:24 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130630023424.GA27780@dastard>
References: <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627100612.GA29338@dastard>
 <20130627125218.GB32195@dastard>
 <20130627152151.GA11551@redhat.com>
 <20130628011301.GC32195@dastard>
 <20130628035825.GC29338@dastard>
 <20130629201311.GA23838@redhat.com>
 <CA+55aFz8rz=c8DsNHpBJW1K=FH-ztuPAMNOoGfM6HQyZByQ9mQ@mail.gmail.com>
 <20130630020531.GA20046@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130630020531.GA20046@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 30, 2013 at 12:05:31PM +1000, Dave Chinner wrote:
> On Sat, Jun 29, 2013 at 03:23:48PM -0700, Linus Torvalds wrote:
> > On Sat, Jun 29, 2013 at 1:13 PM, Dave Jones <davej@redhat.com> wrote:
> > >
> > > So with that patch, those two boxes have now been fuzzing away for
> > > over 24hrs without seeing that specific sync related bug.
> > 
> > Ok, so at least that confirms that yes, the problem is the excessive
> > contention on inode_sb_list_lock.
> > 
> > Ugh. There's no way we can do that patch by DaveC for 3.10. Not only
> > is it scary, Andi pointed out that it's actively buggy and will miss
> > inodes that need writeback due to moving things to private lists.
> 
> Right - it was just a quick hack for proof of concept... :)
> 
> > So I suspect we'll have to do 3.10 with this starvation issue in
> > place, and mark for stable backporting whatever eventual fix we find.
> 
> I can reproduce the contention problem on both 3.8 and 3.9 kernels,
> so this isn't a recent regression, and as such it's likely I'll be
> able to reproduce it on any kernel since the global inode_lock
> breakup was done back in 2.6.38.

Just as a data point - I just found a machine running a 3.4 kernel
and I can reproduce the inode_sb_list_lock contention problem on it,
too. It's definitely not a new problem...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
