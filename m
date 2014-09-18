Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbaIRSJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:09:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48918 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532AbaIRSJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:09:28 -0400
Date: Thu, 18 Sep 2014 19:09:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: linux-next: manual merge of the usb-gadget tree with the vfs tree
Message-ID: <20140918180921.GA7996@ZenIV.linux.org.uk>
References: <20140917161658.2e4eb3f1@canb.auug.org.au>
 <20140917153400.GA8140@saruman.home>
 <20140918171226.GE4537@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918171226.GE4537@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 12:12:26PM -0500, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Sep 17, 2014 at 10:34:00AM -0500, Felipe Balbi wrote:
> > On Wed, Sep 17, 2014 at 04:16:58PM +1000, Stephen Rothwell wrote:
> > > Hi Felipe,
> > > 
> > > Today's linux-next merge of the usb-gadget tree got a conflict in
> > > drivers/usb/gadget/function/f_fs.c between commit 8322215aa91c ("f_fs:
> > 
> > I can't find this commit on linux-usb. In fact, googling for it the only
> > reference I find to that commit is this very thread. I would strong
> > suggest that it be removed from the tree as it, apparently, went in
> > without any review. Sure, it's a simple change, but it needs to be
> > reviewed and needs to be sent to proper maintainers.
> > 
> > Unless I'm missing something, of course, but I could not find any other
> > references to this commit.
> > 
> > Al, was this commit sent to any mailing list ?
> 
> a gentle ping here

<looks at #for-next>

Oh, bugger...  I see what has happened - there's a local queue with a lot
of pending cleanups; this (and several around it) got into the wrong queue
and leaked into #for-next.  My apologies; I can certainly take this stuff
out.  It is an obvious patch, and the only reason why it's there at all
is that it's a part of preliminary cleanups for sorting the
d_add/d_splice_alias/d_materialise_unique/d_instantiate/d_add_unique
mess out.  That almost certainly will be a part of the next cycle, in
the first place, and this particular commit isn't even a prereq - it's just
something that fell out of grep while sorting out the calling conventions
for those guys (what's locked, what is or isn't hashed, etc.)

So I've no problems whatsoever either with ripping it out of -next and moving
it to the local queue until the next cycle, or throwing it your way and waiting
for it to hit the mainline.  Both f_fs and gadgetfs commits should go your
way, right?  Just tell which way you prefer them handled...  Again, I hadn't
planned to push those; there's no reason not to, but they can certainly sit
around for longer.  Sorry about the mess...
