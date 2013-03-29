Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab3C2WnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 18:43:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54865 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756935Ab3C2WnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 18:43:12 -0400
Date: Fri, 29 Mar 2013 23:18:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Olof Johansson <olof@lixom.net>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.9-rc1 regression in arm dtb build
Message-ID: <20130329221814.GA6606@amd.pavel.ucw.cz>
References: <20130307144506.GB7344@amd.pavel.ucw.cz>
 <5138FDAE.8060202@wwwdotorg.org>
 <20130311050546.GA21863@quad.lixom.net>
 <CACxGe6vkC7fjzf1-+K8O81+w=jQ63PvuTEhSPyitEBA9XiKYnw@mail.gmail.com>
 <20130328092916.GA11187@amd.pavel.ucw.cz>
 <51545870.4010209@wwwdotorg.org>
 <20130328193323.GA25166@amd.pavel.ucw.cz>
 <20130328195456.GA22527@quad.lixom.net>
 <5155C9C6.4070702@wwwdotorg.org>
 <CAOesGMj5yN_-Xvks=tYqYw1M1mre-uKQFCTXOe_gPE=abqF_GA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMj5yN_-Xvks=tYqYw1M1mre-uKQFCTXOe_gPE=abqF_GA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> This takes care of the "make dtbs" case (or just "make" case), but not
> >> when you build a specific target.
> >
> > I guess to really solve this, we need the following changes:
> >
> > In the all kernels:
> >
> > For both arch/*/boot and arch/*/boot/dts: clean removes *.dtb
> >
> > In kernels that build *.dtb in the new location:
> >
> > make dtbs and make foo.dtb both rm ../*.dtb
> 
> I don't think this is useful. If you're building a specific dtb
> target, there should be no expectation that other dtb files should
> automatically be removed.

So... how do the scripts find that script location changed?

You do make foo.dtb.

There's nice foo.dtb waiting in arch/arm/boot/, only that it is
outdated. You use it, and it does not work.

> The original complaint was that make clean didn't remove the old dtb
> files. That's been resolved with the provided patch.

No, original complaint was that it is very very easy to use stale
files. "make clean" not removing them is just a part of problem.

> > In kernels that build *.dtb in the old location:
> >
> > make dtbs and make foo.dtb both rm dts/*.dtb
> >
> > Is that too much to retrofit into all the stable kernels?
> 
> I also don't think this is worth the effort. If you're going to check
> out old and new kernels in the same tree, you should probably get into
> the habit of using git clean.

Since when? make is expected to handle build dependencies. If you are
doing git bisect, make clean is going to slow you down, escpecially at
the end of cycle.

> Perhaps we need a "dtb_install" target instead, so people stop copying
> from the source directories.

dtb_install would be nice. But it will not help with current
problem...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
