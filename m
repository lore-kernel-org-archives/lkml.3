Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab3BTWuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:50:03 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58939 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3BTWuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:50:01 -0500
Date: Wed, 20 Feb 2013 23:49:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Li Fei <fei.li@intel.com>,
        rjw@sisk.pl, len.brown@intel.com, mingo@redhat.com,
        peterz@infradead.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, gorcunov@openvz.org, rientjes@google.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        chuansheng.liu@intel.com, biao.wang@intel.com
Subject: Re: [PATCH] freezer: configure user space process frozen along with
 kernel threads
Message-ID: <20130220224954.GE23856@xo-6d-61-c0.localdomain>
References: <Pine.LNX.4.44L0.1302201541000.1671-100000@iolanthe.rowland.org>
 <87zjyyekh8.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zjyyekh8.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-02-20 13:36:19, Eric W. Biederman wrote:
> Alan Stern <stern@rowland.harvard.edu> writes:
> 
> > On Wed, 20 Feb 2013, Eric W. Biederman wrote:
> >
> >> >> Why can't the fuse filesystem freeze when there are requests pending?
> >> >
> >> > It _can_ freeze (that is, the fuse daemon can).  The problem is that
> >> > tasks _using_ the fuse filsystem can't if the daemon doesn't respond. 
> >> 
> >> Which is what I meant when I said that the fuse filesystem couldn't
> >> freeze.
> >
> > Oh, okay.  But it's no different from any other filesystem in that
> > respect.  Processes generally can't be frozen while they are waiting
> > for filesystem I/O to complete.  In many cases they can't receive 
> > signals either (they are in an uninterruptible wait state).
> 
> Ick.  So the process freezer and all network filesystems has problems?
> Especially nfs?

NFS was modified to react to kill -9 even with server dead.. and we used
same stuff.

How does it interact with mmap() I'm not actually sure. Miklos' arguments
say that can not work...

> > Processes can be frozen only by making explicit checks, and they 
> > mustn't be frozen while they are holding locks that would prevent other 
> > processes from reaching one of those checks.
> >
> >> At most I would suggest that processes be frozen in reverse priority
> >> order.  Which unless there is a priority inversion should solve this
> >> problem without an additional proc file.
> >
> > Do fuse daemons (and the processes they rely upon) run with elevated 
> > priority?
> 
> I don't know if the daemons are of an elevated scheduling priority today
> but if they aren't it is as easy to require an elevated scheduling
> priority as it is to require a magic freezer priority.  Furthermore if
> they don't run at an elevated priority there is the possibility of
> priority inversion.

I'm pretty sure we have priority inversion problems all over... but noone
really cares (as linux is not realtime and priorities are mostly not used).
But freezer turns bad scheduling into deadlocks...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
