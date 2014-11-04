Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbaKDTzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:55:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaKDTzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:55:20 -0500
Date: Tue, 4 Nov 2014 20:55:14 +0100
From: Jan Kara <jack@suse.cz>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4 v3] fs: Remove i_devices from struct inode
Message-ID: <20141104195514.GA28531@quack.suse.cz>
References: <1415096851-17209-1-git-send-email-jack@suse.cz>
 <20141104153940.GH7996@ZenIV.linux.org.uk>
 <54592D49.4070704@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54592D49.4070704@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-11-14 11:47:21, Andy Lutomirski wrote:
> On 11/04/2014 07:39 AM, Al Viro wrote:
> > On Tue, Nov 04, 2014 at 11:27:27AM +0100, Jan Kara wrote:
> >>   Hello,
> >>
> >>   this patch set removes use of i_devices from block and character device
> >> code and thus we can remove the list head from struct inode thus saving two
> >> pointers in it. As Christoph has reviewed the series, can you please merge
> >> it Al? Thanks!
> >>
> >> Since v2 I've added reviewed-by tags from Christoph and changed one variable
> >> name in cdev_forget().
> >>
> >> Since v1 I have split the patches and properly handled character devices (I
> >> broke them last time as Christoph pointed out).
> > 
> > My problem with that is in buggered module refcounts (which was the reason
> > for doing those non-counting references back then).  Suppose you open
> > /dev/some_char_device and close it; having the module pinned down until
> > the inode of that sucker gets evicted by dcache/icache memory pressure
> > would be wrong - it _isn't_ in use, and there's no way short of forcing
> > the full eviction of VFS caches to get it possible to unload...
> > 
> 
> At the risk of asking what may be a rather dumb question...
> 
> Why do device node inodes need to be cached at all?  In other words,
> when you try open a device node, can't the kernel materialize the inode
> from just information that's in the dentry without touching the
> filesystem at all?  If that's true, couldn't all device inodes be
> dropped from icache as soon as they're unreferenced?
> 
> (Yes, there's mtime, but I never understood why tracking mtime on device
> nodes made any sense in the first place.)
  I can see a few reasons:
1) positive dentry without inode - no-no for dcache.
2) how would you get the information which device the dentry references?
3) what would you gain to outweight the complications and special code
   paths?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
