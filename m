Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403Ab3CMWxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 18:53:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933390Ab3CMWxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 18:53:23 -0400
Date: Wed, 13 Mar 2013 15:53:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, apw@canonical.com, nbd@openwrt.org, neilb@suse.de,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, dhowells@redhat.com,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: [PATCH 5/9] overlay filesystem
Message-Id: <20130313155321.7cfcf7b725f247c3b02bf0d3@linux-foundation.org>
In-Reply-To: <1363184193-1796-6-git-send-email-miklos@szeredi.hu>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<1363184193-1796-6-git-send-email-miklos@szeredi.hu>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Mar 2013 15:16:29 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> Overlayfs allows one, usually read-write, directory tree to be
> overlaid onto another, read-only directory tree.  All modifications
> go to the upper, writable layer.
> 
> This type of mechanism is most often used for live CDs but there's a
> wide variety of other uses.
> 
> The implementation differs from other "union filesystem"
> implementations in that after a file is opened all operations go
> directly to the underlying, lower or upper, filesystems.  This
> simplifies the implementation and allows native performance in these
> cases.

Well that's an implementation detail.  I'm sure that people would like
to see a longer description of how this fs differs from others and the
pros and cons of the various approaches.

Is overlayfs equal or superior to all other union filesystems in all
respects?  If not, what are its shortcomings and why do you expect that
users will find them tolerable?

> The dentry tree is duplicated from the underlying filesystems, this
> enables fast cached lookups without adding special support into the
> VFS.  This uses slightly more memory than union mounts, but dentries
> are relatively small.
> 
> Currently inodes are duplicated as well, but it is a possible
> optimization to share inodes for non-directories.
> 
> Opening non directories results in the open forwarded to the
> underlying filesystem.  This makes the behavior very similar to union
> mounts (with the same limitations vs. fchmod/fchown on O_RDONLY file
> descriptors).
> 
> Usage:
> 
>   mount -t overlay -olowerdir=/lower,upperdir=/upper overlay /mnt
> 
> Supported:
> 
>  - all operations
> 
> Missing:
> 
>  - Currently a crash in the middle of copy-up, rename, unlink, rmdir or create
>    over a whiteout may result in filesystem corruption on the overlay level.
>    IOW these operations need to become atomic or at least the corruption needs
>    to be detected.

I for one have forgotten what "whiteout" means in this context. 
Perhaps a lengthier description of this fs would be helpful...
