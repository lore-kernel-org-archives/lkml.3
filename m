Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3COS51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:57:27 -0400
Received: from mail01-md.ns.itscom.net ([175.177.155.111]:49085 "EHLO
	mail01-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab3COS5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:57:22 -0400
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
In-Reply-To: <20130315121220.GY21522@ZenIV.linux.org.uk>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu> <20130313160854.54ac0491044371b4db214698@linux-foundation.org> <CAJfpeguvhJaoSBDKEXoJFn_C=52aXbC9L2ALJvp6ekwEGyQX_g@mail.gmail.com> <20130315012541.GU21522@ZenIV.linux.org.uk> <19058.1363320936@jrobl> <20130315044411.GW21522@ZenIV.linux.org.uk> <20079.1363324154@jrobl> <20130315051322.GX21522@ZenIV.linux.org.uk> <1363335318.2459.4.camel@dabdike> <20130315121220.GY21522@ZenIV.linux.org.uk>
Date: Sat, 16 Mar 2013 03:57:18 +0900
Message-ID: <29608.1363373838@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
> The trouble with such mechanisms is that they tend to end up depending on
> fairly non-trivial properties of underlying fs.  Try aufs one on btrfs,
> see how soon you spot the problem.  It's nice when a method turns out
> to be really redundant and implementable in uniform way via other methods
> present; see fh_to_dentry history for example of situation where it hadn't...

Hmm, I could not see problem around aufs using btrfs as the upper RW
branch, tested on linux-3.9-rc2.
Would you describe more specifically?
Some of my local tests didn't pass due to an error return from
btrfs. For example, repeat "ln fileA $very_loooong_filename", then btrfs
returns EMLINK so soon.

And aufs refers the common set of inode attribute. I mean attrs declared
in VFS. Also I know some filesystems don't maintain attrs on each
operation. For such fs, aufs calls vfs_getattr() internally.


J. R. Okajima
