Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbaCOF2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 01:28:44 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58490 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738AbaCOF2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 01:28:42 -0400
X-Sasl-enc: 6wXZqWflqJIcGuiJGuolwr8tNRVHlJ2DF9yxdH2/kw1L 1394861321
Date: Sat, 15 Mar 2014 05:29:42 +0000
From: Greg KH <greg@kroah.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Tejun Heo <tj@kernel.org>, Mark Brown <broonie@kernel.org>,
        Stewart Smith <stewart@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-ID: <20140315052942.GA30262@kroah.com>
References: <1394596541.4840.70.camel@pasglop>
 <20140312113742.GM28112@sirena.org.uk>
 <1394654396.4840.94.camel@pasglop>
 <20140312200232.GA22332@htj.dyndns.org>
 <1394655292.4840.97.camel@pasglop>
 <20140312202102.GB22332@htj.dyndns.org>
 <1394671056.4840.103.camel@pasglop>
 <1394748895.15098.16.camel@pasglop>
 <20140315000343.GD5687@kroah.com>
 <1394852249.15098.75.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394852249.15098.75.camel@pasglop>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 01:57:29PM +1100, Benjamin Herrenschmidt wrote:
> On Sat, 2014-03-15 at 00:03 +0000, Greg KH wrote:
> > On Fri, Mar 14, 2014 at 09:14:55AM +1100, Benjamin Herrenschmidt wrote:
> > > On Thu, 2014-03-13 at 11:37 +1100, Benjamin Herrenschmidt wrote:
> > > > On Wed, 2014-03-12 at 16:21 -0400, Tejun Heo wrote:
> > > > > It's a series of rather complex patches.  I really don't think
> > > > > duplicating them is a good idea.  We can either resurrect the old API
> > > > > to kill it again or set up a merge branch which I don't think is too
> > > > > unusual in situations like this.
> > > > 
> > > > Right, a topic branch that gets merged in both driver-core-next and
> > > > powerpc-next.
> > > 
> > > Just want to make sure we agree ... ie, the offending commit is already
> > > in powerpc-next on my side and I can't really back it out (I could
> > > revert it though).
> > 
> > You can pull in driver-core-next into your tree if you want, it's not
> > going to be reverted, and will be sent to Linus for 3.15-rc1, so you can
> > base your work on it and fix up the api usage in your tree that way.
> 
> It's messy. Stephen really doesn't like if we pull each other trees like
> that unless they are topic branches. He also doesn't like when we keep
> pulling Linus in.

I only pull Linus in after a -rc in which I have merged patches with him
for that "topic".  Otherwise I end up with merge issues, and for testing
reasons, I want those fixes from Linus and from me, in order to keep
people from hitting the same already-fixes issues.

> For example I purposefully kept powerpc -next on top of rc2. You seem to
> regularly merge subsequent rc's into driver-core-next. So by pulling
> your tree I would bring a whole lot of stuff on top of mine, which is
> fine by git but makes histories more complicated and annoys Stephen.
> 
> I might still do it this time around, because the other solution for me
> is revert + re-apply with fixups on top of a separate branch itself
> derived from driver-core-next and send multiple pull requests to Linus,
> and that's messy too. The question is which one is more :-)

Just take my tree, it's not a big deal, I'll merge first with Linus if
you want and then everything is simple.

thanks,

greg k-h-
