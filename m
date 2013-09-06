Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054Ab3IFKKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 06:10:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab3IFKKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 06:10:07 -0400
Date: Fri, 6 Sep 2013 06:11:13 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, rui.xiang@huawei.com,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/3] autofs4 - fix device ioctl mount lookup
Message-ID: <20130906061113.18638eb0@corrin.poochiereds.net>
In-Reply-To: <1378457659.2311.23.camel@perseus.fritz.box>
References: <20130904005456.5025.94309.stgit@perseus.fritz.box>
	<20130904010301.GE13318@ZenIV.linux.org.uk>
	<20130904020013.GF13318@ZenIV.linux.org.uk>
	<CA+55aFwF+dqSMyGE+3LamM+qSDymieyReYB+RPb8fHTTmntgqw@mail.gmail.com>
	<20130904022617.GG13318@ZenIV.linux.org.uk>
	<20130904024230.GH13318@ZenIV.linux.org.uk>
	<1378456682.2311.21.camel@perseus.fritz.box>
	<1378457659.2311.23.camel@perseus.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Sep 2013 16:54:19 +0800
Ian Kent <raven@themaw.net> wrote:

> 
> Sorry, I should have added Jeff to the cc for this post.
> 
> On Fri, 2013-09-06 at 16:38 +0800, Ian Kent wrote:
> > On Wed, 2013-09-04 at 03:42 +0100, Al Viro wrote:
> > > On Wed, Sep 04, 2013 at 03:26:17AM +0100, Al Viro wrote:
> > > > I've applied slightly modified variant of Jeff's "vfs: allow umount to handle
> > > > mountpoints without revalidating them" (modified by just leaving the
> > > > struct path filled with mountpoint and leaving the equivalent of follow_mount()
> > > > to caller) to the local queue and I'm pretty sure that it's what we want
> > > > here as well.
> > > 
> > > ... and killed the modifications since the result ends up uglier for
> > > caller(s) anyway.  Reapplied as-is.
> > 
> > Looks like Jeff's patch has been merged, commit 8033426e6.
> > 
> > Revalidation isn't the only thing not done on the last component using
> > Jeff's user_path_umountat() path walk. It also bypasses the managed
> > dentry code for the last component, which is why it's what I need as
> > well.
> > 
> > Encoding umount in the name seems misleading as to what it really does
> > as would encoding unmanaged or similar since that doesn't properly cover
> > it either.
> > 
> > I can rename it in a patch to solve my autofs problem, so how about
> > something like user_path_simple_last(), other suggestions anyone?
> > 
> > Ian
> 
> 

Since the purpose is to find mountpoints, maybe user_path_mntpoint()?

-- 
Jeff Layton <jlayton@redhat.com>
