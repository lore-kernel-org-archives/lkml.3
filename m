Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab3GAMth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 08:49:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50388 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3GAMtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 08:49:35 -0400
Date: Mon, 1 Jul 2013 14:49:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130701124933.GA6480@amd.pavel.ucw.cz>
References: <20130627002255.GA16553@redhat.com>
 <20130627075543.GA32195@dastard>
 <20130627100612.GA29338@dastard>
 <20130627125218.GB32195@dastard>
 <20130627152151.GA11551@redhat.com>
 <20130628011301.GC32195@dastard>
 <20130628035825.GC29338@dastard>
 <20130629201311.GA23838@redhat.com>
 <CA+55aFz8rz=c8DsNHpBJW1K=FH-ztuPAMNOoGfM6HQyZByQ9mQ@mail.gmail.com>
 <20130629234449.GA30554@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130629234449.GA30554@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2013-06-29 19:44:49, Dave Jones wrote:
> On Sat, Jun 29, 2013 at 03:23:48PM -0700, Linus Torvalds wrote:
> 
>  > > So with that patch, those two boxes have now been fuzzing away for
>  > > over 24hrs without seeing that specific sync related bug.
>  > 
>  > Ok, so at least that confirms that yes, the problem is the excessive
>  > contention on inode_sb_list_lock.
>  > 
>  > Ugh. There's no way we can do that patch by DaveC for 3.10. Not only
>  > is it scary, Andi pointed out that it's actively buggy and will miss
>  > inodes that need writeback due to moving things to private lists.
>  > 
>  > So I suspect we'll have to do 3.10 with this starvation issue in
>  > place, and mark for stable backporting whatever eventual fix we find.
> 
> Given I'm the only person who seems to have been bitten by this,
> I suspect it's not going to be a big deal.  Worst case we can tell
> people "yeah, just disable the soft watchdog until this is fixed".

Actually... I don't think you are alone. I was doing big dd's in
attempt to debug the bad sectors (on 3.10-rc), and got soft-lockups
too... by stuff as simple as "read the disk in the background and try
to work" and "write zeros to disk in the background and try to work".

But as machine survived, I figured out I was simply loading machine
too much.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
