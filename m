Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3COTLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:11:24 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:54889 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab3COTLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:11:23 -0400
MIME-Version: 1.0
In-Reply-To: <20079.1363324154@jrobl>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<20130313160854.54ac0491044371b4db214698@linux-foundation.org>
	<CAJfpeguvhJaoSBDKEXoJFn_C=52aXbC9L2ALJvp6ekwEGyQX_g@mail.gmail.com>
	<20130315012541.GU21522@ZenIV.linux.org.uk>
	<19058.1363320936@jrobl>
	<20130315044411.GW21522@ZenIV.linux.org.uk>
	<20079.1363324154@jrobl>
Date: Fri, 15 Mar 2013 12:11:21 -0700
X-Google-Sender-Auth: 5T9SglnIhd73Lm_oanjQjAZK7g8
Message-ID: <CA+55aFxd_jSc75pfhNQ6jTbwcQkDfNqALMNThYtgBsH0Z7tA4Q@mail.gmail.com>
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, Robo Bot <apw@canonical.com>,
        Felix Fietkau <nbd@openwrt.org>, Neil Brown <neilb@suse.de>,
        Jordi Pujol <jordipujolp@gmail.com>, ezk@fsl.cs.sunysb.edu,
        David Howells <dhowells@redhat.com>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 10:09 PM, J. R. Okajima <hooanon05@yahoo.co.jp> wrote:
>
> "no inodes at all"?
> Are you assuming the implementation in dcache only (with a new d_type
> flag)? And it is up to the real fs (layer or branch) whether it consumes
> inode or not?

Yes. That would be lovely. And trivial for most filesystems to support.

Sure, you could have an inode if you need to (not all filesystems may
have a flag in the directory entry), so it would look like "mknod()"
for the filesystem. But the filesystem might decide to never actually
create the inode at all if it reconizes the node as a whiteout node.

I think we should do this. Yes, it requires filesystem work, but in
the long run it's the right thing to do, and the filesystem work is
likely very very simple. Besides, we probably only need to support a
few filesystems for it to be already useful. What filesystems do the
people who use unionfs actually use today?

Also note that it's only the "upper layer" filesystem that needs
whiteout nodes. So it's not "all filesystems involved with overlayfs",
it's only the upper ones. And they have to already support xattr, so
I'm assuming in practice we're talking only a few cases, right? Just
tmpfs, ext3, ext4 probably covers most cases..

And it would get rid of all the horrible security check changes for
xattrs, no? So we'd really end up with a noticeably cleaner model.

              Linus
