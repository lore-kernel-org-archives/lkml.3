Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab3CPN4A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 09:56:00 -0400
Received: from mail01-md.ns.itscom.net ([175.177.155.111]:57189 "EHLO
	mail01-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab3CPNz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 09:55:58 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        mszeredi@suse.cz
In-Reply-To: <20130315203018.GZ21522@ZenIV.linux.org.uk>
References: <20130313160854.54ac0491044371b4db214698@linux-foundation.org> <CAJfpeguvhJaoSBDKEXoJFn_C=52aXbC9L2ALJvp6ekwEGyQX_g@mail.gmail.com> <20130315012541.GU21522@ZenIV.linux.org.uk> <19058.1363320936@jrobl> <20130315044411.GW21522@ZenIV.linux.org.uk> <20079.1363324154@jrobl> <20130315051322.GX21522@ZenIV.linux.org.uk> <1363335318.2459.4.camel@dabdike> <20130315121220.GY21522@ZenIV.linux.org.uk> <29608.1363373838@jrobl> <20130315203018.GZ21522@ZenIV.linux.org.uk>
Date: Sat, 16 Mar 2013 22:55:53 +0900
Message-ID: <8431.1363442153@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
> Sure - btrfs happens to have an interesting limit on the number of
> links to the same object located in one directory.

It doesn't matter.
On every filesystem, the link count has its upper limit eventually. When
vfs_link() for whiteout returns EMLINK, aufs removes the whiteout-src
file and creates a new one internally and asynchronously. Completing a
new whiteout-src, aufs will go back to the link approach. The actual
link count when EMLINK returned does not matter.

Some filesystems don't support link(2). For such fs, user should tell
aufs that the layer-fs has no link, and aufs will always create whiteout
as a size-zeroed regular file instead of hardlink. Otherwise user cannot
remove a file logically (rm(1) will return ENOTSUP or EPERM.).


> And yes, it is an independent primitive.  What I really don't understand
> is WTF is so attractive about not having to touch individual filesystems;
> it's not particulary hard to do for any fs we might care about...

Hmm, aufs might have lived too long time as outside mainline. The
whiteout approach aufs took is non-modifying the underlying fs. And I
thought it is essentially important for new fs, otherwise it would be
harder to be merged.


J. R. Okajima
