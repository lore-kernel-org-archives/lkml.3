Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaDZQqJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 12:46:09 -0400
Received: from fieldses.org ([174.143.236.118]:47619 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbaDZQqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 12:46:07 -0400
Date: Sat, 26 Apr 2014 12:46:05 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] please pull file locking changes for v3.15 (pile #2)
Message-ID: <20140426164605.GB11272@fieldses.org>
References: <20140424074557.57f91e16@tlielax.poochiereds.net>
 <20140425095739.GB22295@fieldses.org>
 <20140425063918.0ecbac20@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140425063918.0ecbac20@tlielax.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 06:39:18AM -0400, Jeff Layton wrote:
> On Fri, 25 Apr 2014 05:57:39 -0400
> "J. Bruce Fields" <bfields@fieldses.org> wrote:
> 
> > On Thu, Apr 24, 2014 at 07:45:57AM -0400, Jeff Layton wrote:
> > > 
> > > The following changes since commit 55101e2d6ce1c780f6ee8fee5f37306971aac6cd:
> > > 
> > >   Merge git://git.kernel.org/pub/scm/virt/kvm/kvm (2014-04-14 16:21:28 -0700)
> > > 
> > > are available in the git repository at:
> > > 
> > > 
> > >   git://git.samba.org/jlayton/linux.git tags/locks-v3.15-2
> > > 
> > > for you to fetch changes up to cff2fce58b2b0f59089e7edcdc38803d65057b9f:
> > > 
> > >   locks: rename FL_FILE_PVT and IS_FILE_PVT to use "*_OFDLCK" instead (2014-04-23 16:17:03 -0400)
> > > 
> > > ----------------------------------------------------------------
> > > File locking related bugfixes for v3.15 (pile #2)
> > > 
> > > - fix for a long-standing bug in __break_lease that can cause soft lockups
> > > - renaming of file-private locks to "open file description" locks, and the
> > >   command macros to more visually distinct names.
> > > 
> > > The fix for __break_lease is also in the pile of patches for which Bruce
> > > sent a pull request, but I assume that your merge procedure will handle
> > > that correctly.
> > > 
> > > For the other patches, I don't like the fact that we need to rename this
> > > stuff at this late stage, but it should be settled now (hopefully).
> > > 
> > > ----------------------------------------------------------------
> > > Jeff Layton (3):
> > >       locks: allow __break_lease to sleep even when break_time is 0
> > >       locks: rename file-private locks to "open file description locks"
> > 
> > Nit: they're "descriptors", not "descriptions".
> > 
> > But since that only affects comments and changelogs (not even the macros
> > names, which are using OFD), that's a very nitty nit....
> > 
> > --b.
> > 
> 
> No, they are _descriptions_. The descriptor is the number you get back
> from doing something like an open(). The description is the thing that
> the descriptor points to. This is the terminology that POSIX uses, and
> is what was recommended by the glibc and manpages maintainers.

Whoops, I'm pretty sure I'd seen that explained before and just forgot.
Thanks to you and Christoph for setting me straight!

> The glibc doc patches lay this out in detail. I'm not terribly thrilled
> with the name either, fwiw, but it is better than file-private.

Sure.

--b.

> 
> > >       locks: rename FL_FILE_PVT and IS_FILE_PVT to use "*_OFDLCK" instead
> > > 
> > >  arch/arm/kernel/sys_oabi-compat.c |  6 +++---
> > >  fs/compat.c                       | 14 +++++++-------
> > >  fs/fcntl.c                        | 12 ++++++------
> > >  fs/locks.c                        | 55 +++++++++++++++++++++++++++----------------------------
> > >  include/linux/fs.h                |  2 +-
> > >  include/uapi/asm-generic/fcntl.h  | 20 ++++++++++----------
> > >  security/selinux/hooks.c          |  6 +++---
> > >  7 files changed, 57 insertions(+), 58 deletions(-)
> > > 
> > > -- 
> > > Jeff Layton <jlayton@redhat.com>
> 
> 
> -- 
> Jeff Layton <jlayton@redhat.com>
