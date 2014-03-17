Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbaCQSe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 14:34:29 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53790 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756419AbaCQSe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 14:34:27 -0400
X-Sasl-enc: bguqbgeKWPqE+c6owRmV5rmE+L48zBDMvUnTPMXh5ZMM 1395081266
Date: Mon, 17 Mar 2014 11:36:27 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Mark Brown <broonie@kernel.org>,
        Stewart Smith <stewart@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20140317183627.GF10565@kroah.com>
References: <1394654396.4840.94.camel@pasglop>
 <20140312200232.GA22332@htj.dyndns.org>
 <1394655292.4840.97.camel@pasglop>
 <20140312202102.GB22332@htj.dyndns.org>
 <1394671056.4840.103.camel@pasglop>
 <1394748895.15098.16.camel@pasglop>
 <20140315000343.GD5687@kroah.com>
 <1394852249.15098.75.camel@pasglop>
 <20140315052942.GA30262@kroah.com>
 <20140317101621.92f0d6d9bab79a0ea24fe37b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317101621.92f0d6d9bab79a0ea24fe37b@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 10:16:21AM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Sat, 15 Mar 2014 05:29:42 +0000 Greg KH <greg@kroah.com> wrote:
> >
> > On Sat, Mar 15, 2014 at 01:57:29PM +1100, Benjamin Herrenschmidt wrote:
> > > 
> > > It's messy. Stephen really doesn't like if we pull each other trees like
> > > that unless they are topic branches. He also doesn't like when we keep
> > > pulling Linus in.
> > 
> > I only pull Linus in after a -rc in which I have merged patches with him
> > for that "topic".  Otherwise I end up with merge issues, and for testing
> > reasons, I want those fixes from Linus and from me, in order to keep
> > people from hitting the same already-fixes issues.
> 
> Maybe you should consider instead just merging the branch you asked
> Linus' to merge instead of back merging his whole -rc ... especially when
> the merge commit message is usually just something like "We want those
> fixes here for testing and development" which doesn't actually tell us
> anything very useful.
> 
> Your trees always have lots of back merges of Linus' tree in them and I
> don't know why Linus has not complained about it before now (or at least
> explained to you why we normally don't do that).

No, I don't like merging at "unknown" points in the tree, I only merge
back at the -rc point as that is a "known good" version of Linus's tree.

And I only do the merge if I have patches that have been accepted in
Linus's tree for that tree (usb, staging, tty, etc.) as almost always,
if I don't, I get merge issues (as you find out all the time), and those
bugfixes that go into Linus's tree, I want them in the -next branch as
well so that the developers running those branches don't have the
problems that those fixes resolved.

> > Just take my tree, it's not a big deal,
> 
> Except, of course, you are completely discounting any testing that Ben
> has done on his tree that could be invalidated and/or complicated by
> pulling in so much more of Linus' tree at this point of the cycle.  And
> it complicates the git history even more than just your trees already do.

If Ben's testing is somehow "invalidated" by moving to a newer -rc
release, then when would that testing have ever happened?  -rc merges
should always be safe to do, otherwise you probably have problems in
your code that Linus will later run into when you ask him to pull for
-rc1.

thanks,

greg k-h
