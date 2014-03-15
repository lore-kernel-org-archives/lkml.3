Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbaCOC5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 22:57:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:51612 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbaCOC5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 22:57:49 -0400
Message-ID: <1394852249.15098.75.camel@pasglop>
Subject: Re: linux-next: build failure after merge of the driver-core tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: Tejun Heo <tj@kernel.org>, Mark Brown <broonie@kernel.org>,
        Stewart Smith <stewart@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 15 Mar 2014 13:57:29 +1100
In-Reply-To: <20140315000343.GD5687@kroah.com>
References: <20140312005152.9ac4063f65dbd233f5d50b4d@kernel.org>
	 <20140312015021.GC10106@kroah.com> <1394596541.4840.70.camel@pasglop>
	 <20140312113742.GM28112@sirena.org.uk> <1394654396.4840.94.camel@pasglop>
	 <20140312200232.GA22332@htj.dyndns.org> <1394655292.4840.97.camel@pasglop>
	 <20140312202102.GB22332@htj.dyndns.org> <1394671056.4840.103.camel@pasglop>
	 <1394748895.15098.16.camel@pasglop> <20140315000343.GD5687@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-15 at 00:03 +0000, Greg KH wrote:
> On Fri, Mar 14, 2014 at 09:14:55AM +1100, Benjamin Herrenschmidt wrote:
> > On Thu, 2014-03-13 at 11:37 +1100, Benjamin Herrenschmidt wrote:
> > > On Wed, 2014-03-12 at 16:21 -0400, Tejun Heo wrote:
> > > > It's a series of rather complex patches.  I really don't think
> > > > duplicating them is a good idea.  We can either resurrect the old API
> > > > to kill it again or set up a merge branch which I don't think is too
> > > > unusual in situations like this.
> > > 
> > > Right, a topic branch that gets merged in both driver-core-next and
> > > powerpc-next.
> > 
> > Just want to make sure we agree ... ie, the offending commit is already
> > in powerpc-next on my side and I can't really back it out (I could
> > revert it though).
> 
> You can pull in driver-core-next into your tree if you want, it's not
> going to be reverted, and will be sent to Linus for 3.15-rc1, so you can
> base your work on it and fix up the api usage in your tree that way.

It's messy. Stephen really doesn't like if we pull each other trees like
that unless they are topic branches. He also doesn't like when we keep
pulling Linus in.

For example I purposefully kept powerpc -next on top of rc2. You seem to
regularly merge subsequent rc's into driver-core-next. So by pulling
your tree I would bring a whole lot of stuff on top of mine, which is
fine by git but makes histories more complicated and annoys Stephen.

I might still do it this time around, because the other solution for me
is revert + re-apply with fixups on top of a separate branch itself
derived from driver-core-next and send multiple pull requests to Linus,
and that's messy too. The question is which one is more :-)

Cheers,
Ben.

> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


