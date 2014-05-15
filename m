Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaEOXT0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 19:19:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754031AbaEOXTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 19:19:24 -0400
Date: Fri, 16 May 2014 01:19:09 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, sandeen@redhat.com,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140515231908.GB24089@mguzik.redhat.com>
References: <20140514112619.GA10637@mguzik.redhat.com>
 <20140514113945.GC5824@quack.suse.cz>
 <20140514220052.GD5421@dastard>
 <20140514223745.GF5421@dastard>
 <5373F0D6.4090600@redhat.com>
 <alpine.LFD.2.00.1405151213160.2112@localhost.localdomain>
 <20140515104746.GF10637@mguzik.redhat.com>
 <20140515222135.GZ26353@dastard>
 <20140515223439.GA24089@mguzik.redhat.com>
 <20140515225141.GA26353@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140515225141.GA26353@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 08:51:41AM +1000, Dave Chinner wrote:
> On Fri, May 16, 2014 at 12:34:40AM +0200, Mateusz Guzik wrote:
> > On Fri, May 16, 2014 at 08:21:35AM +1000, Dave Chinner wrote:
> > > > IOW, a new column in mountinfo. For frozen filesystems it would contain
> > > > 'frozen_by=[%s]:[%d]' (escaped comm, pid).
> > > 
> > > I really don't see that the process that froze the filesystem is
> > > particularly useful - it many cases that process is long gone (e.g.
> > > fsfreeze is being used to allow a HW array to take a snapshot). Just
> > > the fact it is in the process of freezing (if stuck, stack trace in
> > > sysrq-w should be present) or frozen (freezing process may be long
> > > gone, and is mostly irrelevant because you're now tracking down why
> > > a thaw hasn't happened)...
> > 
> > There are deamons which perform freezing and unfreezing on their own.
> > Thus storing the name along with pid helps to determine whether someone
> > went behind such daemon's back, or maybe it's the daemon which "forgot" to
> > unfreeze after all.
> 
> Such a daemon should be logging the fact that it's freezing and
> thawing the filesystem. The kernel is not the place to track what
> buggy userspace applications are doing wrong.
> 

Except there is no log entry if /var got frozen (and this is not an
imaginary example). Grabbig a debugger to inspect daemon's state is not
exactly what your typical support associate can or should do.

But this was a side request, I'm not going to argue about including
this since turns out there is a better way.

Somewhere in the thread an idea to log long-standing freezes was
mentioned which would provide sufficient information as far as
troubleshooting this stuff is concerned.

Thanks and sorry :->
-- 
Mateusz Guzik
