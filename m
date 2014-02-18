Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaBRRmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:42:15 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36778 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbaBRRmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:42:10 -0500
Date: Tue, 18 Feb 2014 18:43:26 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 0/11] Detaching mounts on unlink
Message-ID: <20140218174326.GF4026@tucsk.piliscsaba.szeredi.hu>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
 <87a9kkax0j.fsf@xmission.com>
 <CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
 <8761v7h2pt.fsf@tw-ebiederman.twitter.com>
 <CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
 <87li281wx6.fsf_-_@xmission.com>
 <87ob28kqks.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ob28kqks.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 01:34:43PM -0800, Eric W. Biederman wrote:
> 
> The last round of this patchset the semantics of dropping mounts on
> unlink were agreed upon so long as we preserve the current semantics in
> a single mount namespace.
> 
> There are two big changes with this version of the patchset.
> 1) The test for a mount in the current mount namespace has been
>    rewritten so that it is actually correct and is now a drop in
>    replacement for d_mountpoint.  Removing the need for code changes
>    that could cause unitended regressions.
> 
> 2) This work has been comprehensivly extend to d_revalidate and
>    d_invalidate allowing some long standing bugs to be fixed at the end
>    of this patch series.
> 
> In net this should result in a kernel that is more comprehensible and
> maintainble as well as fixing some possible mount leaks, and removing
> the possibility of DOS attacks from evily placed mount points, in other
> mount namespaces.

This patchset looks good to me.  You can add

Reviewed-by: Miklos Szeredi <miklos@szeredi.hu>

Thanks,
Miklos

> 
> Eric W. Biederman (11):
>       vfs: Document the effect of d_revalidate on d_find_alias
>       vfs: More precise tests in d_invalidate
>       vfs: Don't allow overwriting mounts in the current mount namespace
>       vfs: Keep a list of mounts on a mount point
>       vfs: Add a function to lazily unmount all mounts from any dentry.
>       vfs: Lazily remove mounts on unlinked files and directories.
>       vfs: Remove unnecessary calls of check_submounts_and_drop
>       vfs: Merge check_submounts_and_drop and d_invalidate
>       vfs: Make d_invalidate return void
>       vfs: Remove d_drop calls from d_revalidate implementations
>       proc: Update proc_flush_task_mnt to use d_invalidate
> 
>  fs/afs/dir.c           |    5 --
>  fs/btrfs/ioctl.c       |    5 +--
>  fs/ceph/dir.c          |    1 -
>  fs/cifs/readdir.c      |    6 +--
>  fs/dcache.c            |  140 +++++++++++++++++-------------------------------
>  fs/fuse/dir.c          |    7 +--
>  fs/gfs2/dentry.c       |    3 -
>  fs/kernfs/dir.c        |   11 ----
>  fs/mount.h             |   13 +++++
>  fs/namei.c             |   28 ++++++----
>  fs/namespace.c         |   80 +++++++++++++++++++++++++++
>  fs/nfs/dir.c           |    7 +--
>  fs/proc/base.c         |   10 +---
>  fs/proc/fd.c           |    2 -
>  include/linux/dcache.h |    3 +-
>  15 files changed, 167 insertions(+), 154 deletions(-)
> 
> Eric
