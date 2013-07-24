Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401Ab3GXDXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:23:22 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:21927 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780Ab3GXDXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:23:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqkIACpI71F5LPxH/2dsb2JhbABbgwaDJbkmhTmBExd0giQBAQU6HCMQCAMYCSUPBSUDIROID7gjFo4vgTUHhAADl16RToMmKoEs
Date: Wed, 24 Jul 2013 13:22:54 +1000
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.11-rc2
Message-ID: <20130724032254.GM19986@dastard>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
 <20130722012517.GD11674@dastard>
 <20130722040601.GK4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130722040601.GK4165@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 05:06:01AM +0100, Al Viro wrote:
> On Mon, Jul 22, 2013 at 11:25:17AM +1000, Dave Chinner wrote:
> 
> > I'll just point out that it can make the whole thing worse, too.
> > For example, for ext3/4, the tmpfile being created has to be added
> > to the orphan inode list which is protected by a filesystem global
> > mutex. Hence scalability of O_TMPFILE is massively limited on
> > ext3/ext4 due to architectural issues within ext3/4. Other
> > filesystems will be more efficient, but because they have more
> > scalable/complex orphan inode handling it's going to take longer to
> > implement O_TMPFILE support for them....
> 
> Um...  You do realize that the same architectural issues there will
> create exactly the same serialization when you are unlinking the
> sucker?  I.e. with the "pick the name, create and open, unlink" sequence
> ext[34] will insert that inode into the same orphan list, creating
> the same contention...

Yup.

But that is assuming that the unlink of the tmpfile happens
immediately after the open() and that's not necessarily the case for
all users of tmp files that might get converted to use O_TMPFILE,
and so a saying it is more efficient than traditional tmpfiles is
not necessarily correct.

Let's set expectations appropriately at the start, rather than have
people complain a year down the track that O_TMPFILE causes them
performance problems because they don't understand the limitations
of the implementations underlying it......

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
