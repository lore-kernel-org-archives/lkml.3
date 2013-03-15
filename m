Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab3COIPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 04:15:32 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48525 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753846Ab3COIP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 04:15:26 -0400
Message-ID: <1363335318.2459.4.camel@dabdike>
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        mszeredi@suse.cz
Date: Fri, 15 Mar 2013 08:15:18 +0000
In-Reply-To: <20130315051322.GX21522@ZenIV.linux.org.uk>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	 <20130313160854.54ac0491044371b4db214698@linux-foundation.org>
	 <CAJfpeguvhJaoSBDKEXoJFn_C=52aXbC9L2ALJvp6ekwEGyQX_g@mail.gmail.com>
	 <20130315012541.GU21522@ZenIV.linux.org.uk> <19058.1363320936@jrobl>
	 <20130315044411.GW21522@ZenIV.linux.org.uk> <20079.1363324154@jrobl>
	 <20130315051322.GX21522@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-15 at 05:13 +0000, Al Viro wrote:
> On Fri, Mar 15, 2013 at 02:09:14PM +0900, J. R. Okajima wrote:
> 
> > If so, it has a big disadvantage for the layer-fs (or branch-fs) to have
> > to implement a new method for whiteout.
> > 
> > Overlayfs implements whiteout as symlink+xattr which consumes an
> > inode. And you don't like it, right?
> > What I showed is another generic approach without xattr where the new
> > method to whiteout is unnecessary.
> 
> I'm yet to see the reason that would make implementing that method a big
> disadvantage, TBH...

It's the fact that a directory entry based whiteout limits the amount of
change to the VFS, but has to be supported by underlying filesystems.
The generic_dirent_fallthrough() mechanism is a nice way of hiding it,
but there are still quite a few fs specific mods in the union mount tree
because of this.  Having to modify filesystems to me indicates the
mechanism is a bit fragile.  If we could do whiteouts purely in the VFS,
so it would work for any filesystem (without needing filesystem
modifications) that would seem to be a more robust approach.  I'm not
saying we can definitely do this in an elegant way ... I'm just saying
that if someone comes up with it, it's obviously preferable.

James



