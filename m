Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab3COFJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:09:21 -0400
Received: from mail02-md.ns.itscom.net ([175.177.155.112]:49663 "EHLO
	mail02-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab3COFJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:09:19 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        mszeredi@suse.cz
In-Reply-To: <20130315044411.GW21522@ZenIV.linux.org.uk>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu> <20130313160854.54ac0491044371b4db214698@linux-foundation.org> <CAJfpeguvhJaoSBDKEXoJFn_C=52aXbC9L2ALJvp6ekwEGyQX_g@mail.gmail.com> <20130315012541.GU21522@ZenIV.linux.org.uk> <19058.1363320936@jrobl> <20130315044411.GW21522@ZenIV.linux.org.uk>
Date: Fri, 15 Mar 2013 14:09:14 +0900
Message-ID: <20079.1363324154@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
> > +- whiteout is hardlinked in order to reduce the consumption of inodes
> > +  on branch
>
> *blink* Whiteouts have no inodes at all.  Filesystem has an additional
> kind of directory entries, recognizable as whiteouts.  How they are
> done is up to filesystem in question.

"no inodes at all"?
Are you assuming the implementation in dcache only (with a new d_type
flag)? And it is up to the real fs (layer or branch) whether it consumes
inode or not?
If so, it has a big disadvantage for the layer-fs (or branch-fs) to have
to implement a new method for whiteout.

Overlayfs implements whiteout as symlink+xattr which consumes an
inode. And you don't like it, right?
What I showed is another generic approach without xattr where the new
method to whiteout is unnecessary.


> > +The whiteout in aufs is very similar to Unionfs's. That is represented
> > +by its filename. UnionMount takes an approach of a file mode, but I am
> > +afraid several utilities (find(1) or something) will have to support it.
>
> Why the devil should find(1) even see them?

It is the case when find(1) for the layer-fs/branch-fs directly.


J. R. Okajima
