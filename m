Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaI2U1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:27:03 -0400
Received: from pegasus3.altlinux.org ([194.107.17.103]:35742 "EHLO
	pegasus3.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaI2U1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:27:01 -0400
Date: Tue, 30 Sep 2014 00:26:59 +0400
From: "Dmitry V. Levin" <ldv@altlinux.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND v3 PATCH 3/3] vfs: make mounts and mountstats honor root dir like mountinfo does
Message-ID: <20140929202659.GA16292@altlinux.org>
References: <20140929180523.GC15829@altlinux.org> <20140929183222.GJ7996@ZenIV.linux.org.uk> <20140929184333.GD15829@altlinux.org> <20140929193329.GL7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929193329.GL7996@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 08:33:29PM +0100, Al Viro wrote:
> On Mon, Sep 29, 2014 at 10:43:33PM +0400, Dmitry V. Levin wrote:
> > On Mon, Sep 29, 2014 at 07:32:22PM +0100, Al Viro wrote:
> > > On Mon, Sep 29, 2014 at 10:05:23PM +0400, Dmitry V. Levin wrote:
> > > > Date: Wed, 17 Oct 2012 20:29:55 +0400
> > > > 
> > > > Change show_vfsmnt() and show_vfsstat() to show mountpoints relative
> > > > to the root directory and skip mountpoints outside of chroot jail
> > > > the same way as show_mountinfo() does.
> > > 
> > > Sigh...  Repeat after me:  We  Do  Not  Break  Userland.  Care to explain
> > > why that change won't do just that?
> > 
> > This is definitely an information leak, and I cannot imagine how these
> > unaccessible entries listed in /proc/self/mounts and /proc/self/mountstats
> > could be used sanely.
> 
> How do you think any existing script running chrooted is going to parse
> /proc/mounts?  One obvious way is to filter on known prefix and strip it
> away.  With your change it will instantly break.  Moreover, any script
> working with *new* semantics will break as soon as you boot an older
> kernel.

If a script relies on this behaviour, it is likely to be broken already
because the kernel strips chroot prefix somehow (I've just checked back to
2.6.32).  The main purpose of this patch is to exclude from listing those
mount points that do not belong to the chroot at all.

> Existing behaviour had been there since mid-90s (at least) and I'm absolutely
> certain that such scripts do exist.  I know that, since I had to write such.

I'm very curious, what could your scripts do with paths outside chroot,
assuming that prefix removal was done by the kernel?

> Again, we do not break userland.

Occasionally, we do.  If you say there was no chroot prefix removal in the
kernel before, and there seems to be a prefix removal for at least 5 years,
then there must have been a break some years ago that went unnoticed.


-- 
ldv
