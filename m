Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab3GPGun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 02:50:43 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:52449 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695Ab3GPGum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 02:50:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuokADbs5FF5LK4r/2dsb2JhbABagwY0riQCjlKFMAQBgQ8XdIIjAQEFOhwjEAgDGAklDwUlAyETh34DDg2tNReIVBaMfYE0gR0Hg3gDl1uRToMkKg
Date: Tue, 16 Jul 2013 16:50:11 +1000
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130716065010.GG11674@dastard>
References: <20130716015305.GB30569@redhat.com>
 <CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
 <20130716023847.GA31481@redhat.com>
 <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
 <20130716060351.GE11674@dastard>
 <20130716061601.GM4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716061601.GM4165@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 07:16:02AM +0100, Al Viro wrote:
> On Tue, Jul 16, 2013 at 04:03:51PM +1000, Dave Chinner wrote:
> 
> > I posted patches to fix this i_mutex/i_iolock inversion a couple of
> > years ago (july 2011):
> > 
> > https://lkml.org/lkml/2011/7/18/4
> > 
> > And V2 was posted here and reviewed (aug 2011):
> > 
> > http://xfs.9218.n7.nabble.com/PATCH-0-2-splice-i-mutex-vs-splice-write-deadlock-V2-tt4072.html#none
> 
> Unless I'm misreading the patch, you end up doing file_remove_suid()
> without holding i_mutex at all...

+       xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
+       ret = file_remove_suid(out);

Actaully, xfs_rw_ilock() takes the i_mutex due to teh exclusive locking ebing
done, so that's all fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
