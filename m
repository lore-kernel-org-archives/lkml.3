Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaKRRG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:06:57 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58846 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506AbaKRRGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:06:55 -0500
Date: Tue, 18 Nov 2014 17:07:18 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Neil Brown <neilb@suse.de>,
        linux-unionfs@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: How to cope with two incompatible overlayfs formats out in the
 wild
Message-ID: <20141118170718.GH8154@bark>
References: <CAJfpegtG68g=dDi7j-WfhkuJidZRBg46vyuWg8CTrW3TrW_nYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtG68g=dDi7j-WfhkuJidZRBg46vyuWg8CTrW3TrW_nYw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 03:28:03PM +0100, Miklos Szeredi wrote:
> [CC-ing mailing lists, Al and Linus for wider exposure]
> 
> This issue is this: Ubuntu and SUSE carry an "old" format of overlayfs
> while mainline has a "new" format.  The differences are:
> 
>  - whiteouts are represented differently (symlink + xattr in the old
> format, chardev in the new)
> 
>  - new one needs a "workdir" mount option, which points to a directory
> on the same filesystem as upperdir.  If upperdir was the root of the
> filesystem then it needs to be moved into a subdir to make space for
> the work directory.
> 
> Migrating from old to new is not a big issue, but Ubuntu people have
> expressed concerns about systems with mixed kernel versions and want
> to support the old format alongside the new.
> 
> This can all be done with out-of-tree code.
> 
> So from mainline we need two things:
> 
>   - when mounting distinguish between old and new format.
> 
>   - userspace can detect which formats are supported by the kernel.
> 
> If we'd have a different filesystem type for the old and new formats,
> then that would solve both (checking /proc/filesystems would indicate
> which one is supported).
> 
> Unfortunately that would mean having to change "overlayfs" type to
> something else in 3.18.  Question is, is there some sane name which
> would fit?  "overlayfs2" is perhaps the best, but I'm not overly
> enthusiastic about it.
> 
> Any other ideas?

ext4 makes use of feature flags in /sys/fs/ext4/features.  Perhaps we could
make use of this, say /sys/fs/overlayfs/features/{workdir,whiteout-chrdev},
or a even some kind of version in /sys/fs/overlayfs/version.

The presence of /sys/fs/overlayfs itself might be enought to assume the
presence of support for the new format.

-apw
