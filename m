Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaEZCkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 22:40:55 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:60759 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750901AbaEZCky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 22:40:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AppMANeoglN5LL1sPGdsb2JhbABZDoJ5iEuiUwEBAQEBAQaYCgGBBhcDAQEBATg1giUBAQUnExwzCAMYCSUPBSUDBxoBEohB1z0XFoU/iQSEQAEDmXKLGIsIUis
Date: Mon, 26 May 2014 12:40:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Plamen Petrov <plamen.sisi@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        sandeen@redhat.com
Subject: Re: [PATCH] do_mounts: try all available filesystems before panicking
Message-ID: <20140526024051.GU8554@dastard>
References: <1399314889-9829-1-git-send-email-plamen.sisi@gmail.com>
 <CA+55aFwxF2xnYerLdJZ2gQdZizK3953L16X5KkUAqD-YePausQ@mail.gmail.com>
 <20140525211129.GA5243@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140525211129.GA5243@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2014 at 05:11:30PM -0400, Theodore Ts'o wrote:
> On Sun, May 25, 2014 at 01:04:09PM -0700, Linus Torvalds wrote:
> > 
> > The fact is, I think xfs is just buggy. Returning 38 (ENOSYS) is
> > totally insane. "No such system call"? Somebody is on some bad bad
> > drugs. Not that the mount_block_root() loop and error handling might
> > not be a good thing to perhaps tweak _too_, but at the very least your
> > patch means that now it no longer prints out the error number at all.
> 
> There's only a single instance of ENOSYS in fs/xfs/xfs_mount.c:
> 
> 	/*
> 	 * We must be able to do sector-sized and sector-aligned IO.
> 	 */
> 	if (sector_size > sbp->sb_sectsize) {
> 		if (loud)
> 			xfs_warn(mp, "device supports %u byte sectors (not %u)",
> 				sector_size, sbp->sb_sectsize);
> 		error = ENOSYS;
> 		goto release_buf;
> 	}
> 
> Plamen, does changing the ENOSYS to EINVAL above fix things for you?
> 
> > Anyway, I'm also not seeing why that xfs error would be new to 3.14,
> > though.. Adding the XFS people to the cc.
> 
> If I had to guess, commit daba5427d is new to 3.14, and it might
> explain the change in behavior.

Yup, it's buggy, though not in an obvious way. I'll have a patch for
it soon.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
