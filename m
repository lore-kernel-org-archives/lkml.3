Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaEPAjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 20:39:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916AbaEPAjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 20:39:42 -0400
Date: Fri, 16 May 2014 02:39:27 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, sandeen@redhat.com,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH V2 2/2] fs: print a message when freezing/unfreezing
 filesystems
Message-ID: <20140516003926.GC24089@mguzik.redhat.com>
References: <20140514220052.GD5421@dastard>
 <20140514223745.GF5421@dastard>
 <5373F0D6.4090600@redhat.com>
 <alpine.LFD.2.00.1405151213160.2112@localhost.localdomain>
 <20140515104746.GF10637@mguzik.redhat.com>
 <20140515222135.GZ26353@dastard>
 <20140515223439.GA24089@mguzik.redhat.com>
 <20140515225141.GA26353@dastard>
 <20140515231908.GB24089@mguzik.redhat.com>
 <20140516001156.GI5421@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140516001156.GI5421@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 10:11:56AM +1000, Dave Chinner wrote:
> On Fri, May 16, 2014 at 01:19:09AM +0200, Mateusz Guzik wrote:
> > Except there is no log entry if /var got frozen (and this is not an
> > imaginary example).
> 
> Freezing the filesystem that the freezing daemon logs to is, well, a
> major application architecture fail. Sorry, catering for the lowest
> common denominator (i.e. stupidity) is not an valid argument for
> adding stuff to the kernel....
> 

I'm only saying what you can encounter in varous companies. If aiding this
problem the way I proposed is not a good idea (and it turns out there is
a much better way), I'm not insisting.

> > Grabbig a debugger to inspect daemon's state is not
> > exactly what your typical support associate can or should do.
> 
> No, but they can read /proc/self/mountinfo, and grab sysrq-w output.
> And they should be able to read that and tell that there is a freeze
> hang from that info. This "filesystem hang triage 101" stuff....
> 
> > But this was a side request, I'm not going to argue about including
> > this since turns out there is a better way.
> > 
> > Somewhere in the thread an idea to log long-standing freezes was
> > mentioned which would provide sufficient information as far as
> 
> You've already got the hung task timer firing when a fs is frozen
> for too long. You'll see processes hung in sb_write_wait(), and that
> tells you the filesystem is frozen. Then look at
> /proc/self/mountinfo to find which fs is frozen....
> 

But additional question was what initiated the freeze and it is not
answered by this. Hopefully a warning for long-standing freezes will be
implemented and that will answer the question.

Once more, I'm fine with mere 'frozen' in mountinfo, so I suggest we
drop this now side subject. If you really want to continue we can
discuss this in private. :->

-- 
Mateusz Guzik
