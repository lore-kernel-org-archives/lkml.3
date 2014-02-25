Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaBYEOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 23:14:19 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:58719 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780AbaBYEOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 23:14:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak8KAJUXDFN5LJYe/2dsb2JhbABZgwY7qUMDkweFVYEYF3SCJQEBBTocIxAIAw4KCSUPBSUDIROIBMZ6FxaOTgeDJIEUBJgzilKHVoFvgVIo
Date: Tue, 25 Feb 2014 15:13:46 +1100
From: Dave Chinner <david@fromorbit.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Namjae Jeon <linkinjeon@gmail.com>, viro@zeniv.linux.org.uk, bpm@sgi.com,
        tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz,
        mtk.manpages@gmail.com, lczerner@redhat.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH v5 0/10] fs: Introduce new flag(FALLOC_FL_COLLAPSE_RANGE)
 for fallocate
Message-ID: <20140225041346.GA29907@dastard>
References: <1392741436-19995-1-git-send-email-linkinjeon@gmail.com>
 <20140224005710.GH4317@dastard>
 <20140225141601.358f6e3df2660d4af44da876@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140225141601.358f6e3df2660d4af44da876@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 02:16:01PM +1100, Stephen Rothwell wrote:
> Hi Dave,
> 
> On Mon, 24 Feb 2014 11:57:10 +1100 Dave Chinner <david@fromorbit.com> wrote:
> >
> > > Namjae Jeon (10):
> > >   fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
> > >   xfs: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
> > 
> > I've pushed these to the following branch:
> > 
> > 	git://oss.sgi.com/xfs/xfs.git xfs-collapse-range
> > 
> > And so they'll be in tomorrow's linux-next tree.
> > 
> > >   ext4: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
> > 
> > I've left this one alone for the ext4 guys to sort out.
> 
> So presumably that xfs tree branch is now completely stable and so Ted
> could just merge that branch into the ext4 tree as well and put the ext4
> part on top of that in his tree.

Well, for some definition of stable. Right now it's just a topic
branch that is merged into the for-next branch, so in theory it is
still just a set of pending changes in a branch in a repo that has
been pushed to linux-next for testing.

That said, I don't see that branch changing unless we find bugs in
the code or a problem with the API needs fixing, at which point I
would add more commits to it and rebase the for-next branch that you
are pulling into the linux-next tree.

Realistically, I'm waiting for Lukas to repost his other pending
fallocate changes (the zero range changes) so I can pull the VFS and
XFS bits of that into the XFS tree and I can test them together
before I'll call the xfs-collapse-range stable and ready to be
merged into some other tree...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
