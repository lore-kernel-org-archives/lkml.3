Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaETDST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 23:18:19 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:12386 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbaETDSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 23:18:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkHAPrIelN5LL1s/2dsb2JhbABZgwZRgnCnPwEBAQEBAQaaKQGBFRd0giUBAQQBOhwjBQsIAxgJJQ8FJQMhExuIHgfSaBcWhT+DXIRNAQFPB4MrgRUEmVmBPpFdg0krgTo
Date: Tue, 20 May 2014 13:18:02 +1000
From: Dave Chinner <david@fromorbit.com>
To: Daniel Phillips <daniel@phunq.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tux3@tux3.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Tux3 for review
Message-ID: <20140520031802.GF18954@dastard>
References: <5376B273.7000800@partner.samsung.com>
 <20140518235555.GC18954@dastard>
 <537AA802.408@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537AA802.408@phunq.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 05:55:30PM -0700, Daniel Phillips wrote:
> On 05/18/2014 04:55 PM, Dave Chinner wrote:
> >On Fri, May 16, 2014 at 05:50:59PM -0700, Daniel Phillips wrote:
> >static const struct inode_operations tux_file_iops = {
> >//      .permission     = ext4_permission,
> >         .setattr        = tux3_setattr,
> >         .getattr        = tux3_getattr,
> >#ifdef CONFIG_EXT4DEV_FS_XATTR
> >//      .setxattr       = generic_setxattr,
> >//      .getxattr       = generic_getxattr,
> >//      .listxattr      = ext4_listxattr,
> >//      .removexattr    = generic_removexattr,
> >#endif
> >//      .fallocate      = ext4_fallocate,
> >//      .fiemap         = ext4_fiemap,
> >         .update_time    = tux3_file_update_time,
> >};
> This was mentioned in the cover mail, it is our shorthand for
> "FIXME". I like that usage but if it is not to your taste we will
> change those to C99 comments.

I'm not commenting on the c99 comment style, I'm passing comment on
the fact that a filesystem that has commented out code from *other
filesystems* is in no shape to be merged.

> >The hacks around VFS and MM functionality need to have demonstrated
> >methods for being removed. We're not going to merge that page
> >forking stuff (like you were told at LSF 2013 more than a year ago:
> >http://lwn.net/Articles/548091/) without rigorous design review and
> >a demonstration of the solutions to all the hard corner cases it
> >has.
> Thank you. A design review, hack by hack, is exactly what we want.
> Would you prefer to do them all at once, or one at a time?

First you need to write the patches that we'll review. Then send
them once you have them functionally complete, working and ready to
go.

> >The current code doesn't solve them (e.g. direct IO doesn't
> >work in tux3), and there's no clear patch set we can review that
> >demonstrates how it is all supposed to work.
> If you don't mind, we will leave direct IO for after merge. Direct
> IO is an enterprise feature on our to-do list, but Implementing it
> right now does not seem like a good reason to continue working out
> of tree. We would be happy to discuss our approach to direct IO if
> you wish.

Except that Direct IO impacts on the design of the page forking code
(because of how things like get_user_pages() need to be aware of
page forking). So you need to have direct IO working to demonstrate
that the page forking design is sound.....

> >Now, one of the big features tux3 you hyped is built-in snapshotting
> >capability. All that talk efficient pointer trees (or whatever they
> >were called) and being so much better than ZFS/btrfs-like COW.
> >Well, I can't find it anywhere in the code - the only references to
> >snapshots are 5 comments like this:
> >
> >	* FIXME: what happen if snapshot was introduced?
> We decided to add the versioning after merge because there seems to
> be no shortage of people who are more interested in base
> functionality like performance and reliability than snapshotting.It

You completely missed my point. We don't *need* tux3 as it currently
implemented in the mainline tree. You keep saying "performance and
reliability" as reasons to merge code that is not clean, stable or
reliable, nor is the performance of that code at all proven to be
superior to the our supported production filesystems.

The development of btrfs has shown that moving prototype filesystems
into the main kernel tree does not lead stability, performance or
production readiness any faster than if they stayed as an
out-of-tree module until most of the development was complete. If
anything, merging into mainline reduces the speed at which a
filesystem can be brought to being feature complete and production
ready....

....

> As I said, the glaring omission is proper ENOSPC handling, which is
> work in progress. I do not view that as an obstacle to merging.
>
> After all, Btrfs did not have proper ENOSPC handling when it was
> merged.

Yup, and that was a big mistake. Hence not having working ENOSPC
detection is a major strike against merging a new filesystem now.

> The design is here:

So come back when you've implemented it properly and proven that you
have a sound design and clean implementation.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
