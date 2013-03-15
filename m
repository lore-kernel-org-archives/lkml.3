Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3COMMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:12:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59680 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab3COMMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:12:31 -0400
Date: Fri, 15 Mar 2013 12:12:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        mszeredi@suse.cz
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
Message-ID: <20130315121220.GY21522@ZenIV.linux.org.uk>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
 <20130313160854.54ac0491044371b4db214698@linux-foundation.org>
 <CAJfpeguvhJaoSBDKEXoJFn_C=52aXbC9L2ALJvp6ekwEGyQX_g@mail.gmail.com>
 <20130315012541.GU21522@ZenIV.linux.org.uk>
 <19058.1363320936@jrobl>
 <20130315044411.GW21522@ZenIV.linux.org.uk>
 <20079.1363324154@jrobl>
 <20130315051322.GX21522@ZenIV.linux.org.uk>
 <1363335318.2459.4.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363335318.2459.4.camel@dabdike>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 08:15:18AM +0000, James Bottomley wrote:

> It's the fact that a directory entry based whiteout limits the amount of
> change to the VFS, but has to be supported by underlying filesystems.
> The generic_dirent_fallthrough() mechanism is a nice way of hiding it,
> but there are still quite a few fs specific mods in the union mount tree
> because of this.  Having to modify filesystems to me indicates the
> mechanism is a bit fragile.  If we could do whiteouts purely in the VFS,
> so it would work for any filesystem (without needing filesystem
> modifications) that would seem to be a more robust approach.  I'm not
> saying we can definitely do this in an elegant way ... I'm just saying
> that if someone comes up with it, it's obviously preferable.

The trouble with such mechanisms is that they tend to end up depending on
fairly non-trivial properties of underlying fs.  Try aufs one on btrfs,
see how soon you spot the problem.  It's nice when a method turns out
to be really redundant and implementable in uniform way via other methods
present; see fh_to_dentry history for example of situation where it hadn't...
