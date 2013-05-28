Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835Ab3E1WEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 18:04:15 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:61112 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757809Ab3E1WEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 18:04:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4OABwppVF5La3j/2dsb2JhbABZgwm9MYUcBAGBBRd0giMBAQU6HDMIAxgJJQ8FJQMhARKIDLt5Fo1qgSSCc2EDlzqRQYMhKg
Date: Wed, 29 May 2013 08:04:09 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, xfs@oss.sgi.com,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.10-rc3 xfs mount/recovery failure & ext fsck hang.
Message-ID: <20130528220409.GD29338@dastard>
References: <20130528161230.GA7577@redhat.com>
 <20130528211012.GX29466@dastard>
 <20130528211544.GB24342@redhat.com>
 <20130528213248.GC29338@dastard>
 <20130528214137.GC24342@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130528214137.GC24342@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 05:41:37PM -0400, Dave Jones wrote:
> On Wed, May 29, 2013 at 07:32:48AM +1000, Dave Chinner wrote:
>  > On Tue, May 28, 2013 at 05:15:44PM -0400, Dave Jones wrote:
>  > > On Wed, May 29, 2013 at 07:10:12AM +1000, Dave Chinner wrote:
>  > >  > On Tue, May 28, 2013 at 12:12:30PM -0400, Dave Jones wrote:
>  > >  > > box crashed, and needed rebooting. On next bootup, when it found the dirty partition,
>  > >  > > xfs chose to spew and then hang instead of replaying the journal and mounting :(
>  > >  > > 
>  > >  > > [   14.694731] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, debug enabled
>  > >  > > [   14.722328] XFS (sda2): Mounting Filesystem
>  > >  > > [   14.757801] XFS (sda2): Starting recovery (logdev: internal)
>  > >  > > [   14.782049] XFS: Assertion failed: fs_is_ok, file: fs/xfs/xfs_dir2_data.c, line: 169
>  > >  > 
>  > >  > A directory block has an entry that is not in the hash index.
>  > >  > Either there's an underlying corruption on disk, or there's an
>  > >  > inconsistency in what has been logged and so an entire change has
>  > >  > not been replayed. Hence the post recovery verification has thrown a
>  > >  > corruption error....
>  > >  > 
>  > >  > If you haven't already repaired the filesystem, can you send me a
>  > >  > metadump of the filesystem in question?
>  > > 
>  > > Sorry, too late. If I can repro, I'll do so next time.
>  > > FYI, I ran xfs_repair and it just hung. Wouldn't even answer ctrl-c.
>  > > Rebooted, and then it mounted and recovered just fine!
>  > 
>  > Strange. I can't think of any reason outside a kernel problem for
>  > xfs_repair going into an uninterruptible sleep. Did it happen after
>  > the repair completed (i.e. after phase 7)? If so, then closing the
>  > block device might have tripped the same problem that fsck.ext2
>  > hit....
> 
> didn't even get that far. It opened the block dev, and then just sat there.
> I left it for a few minutes before deciding it was hung.
> And of course, this is an SSD, so there was no way I could tell if there
> was any IO going on by sound/feel/lights.

OK. Normally when it hangs you can kill it or ctrl-c out because it
gets stuck on a futex. You can then run xfs_repair -P to turn off
threading (and speed :() to avoid such hangs. but given that you
couldn't kill it, it doesn't sound like that sort of problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
