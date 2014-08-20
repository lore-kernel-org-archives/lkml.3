Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaHTV4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 17:56:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34704 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbaHTV4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 17:56:21 -0400
Date: Wed, 20 Aug 2014 23:56:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Valdis.Kletnieks@vt.edu
Cc: linux-fsdevel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Nick Krause <xerofoiffy@gmail.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] spi: Remove unused definitions
Message-ID: <20140820215618.GA744@amd>
References: <1407347597-2168-1-git-send-email-xerofoiffy@gmail.com>
 <17153.1407349640@turing-police.cc.vt.edu>
 <20140820202235.GA28350@xo-6d-61-c0.localdomain>
 <26099.1408569162@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26099.1408569162@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-08-20 17:12:42, Valdis.Kletnieks@vt.edu wrote:
> (Adding Al Viro and linux-fsdevel, dropping Mark Brown and the SPI list, because this is
> heading off in a different direction now)
> 
> On Wed, 20 Aug 2014 22:26:02 +0200, Pavel Machek said:
> > On Wed 2014-08-06 14:27:20, Valdis.Kletnieks@vt.edu wrote:
> > > On Wed, 06 Aug 2014 13:53:17 -0400, Nick Krause said:
> > > > Remove unused definition which cause the following warnings
> > > >
> > > > drivers/spi/spi-omap-100k.c:73:0: warning: "WRITE" redefined [enabled by default]
> > > > include/linux/fs.h:193:0: note: this is the location of the previous definition
> > > > drivers/spi/spi-omap-100k.c:74:0: warning: "READ" redefined [enabled by default]
> > > > include/linux/fs.h:192:0: note: this is the location of the previous definition
> > >
> > > > -#define WRITE 0
> > > > -#define READ  1
> > >
> > > NAK.  Full stop.  These are potentially used in an inner macro someplace, and by
> > > removing these, the conflicting values from fs.h will be used instead.
> > >
> > > #define READ                    0
> > > #define WRITE                   RW_MASK
> > >
> > > So if there *is* a use in an inner macro, you just screwed the pooch
> > > and introduced a bug in this "clean up" - somebody will be expecting to see
> > > a 0 for a READ, and will receive a 1 instead.  This can't end well.
> >
> > Actually.. having macros called READ and WRITE in fs.h is already something I'd say
> > can't end well. Can we rename those?
> 
> I had the same thought, but other than a test rename to XYZZY_READ and PLUGH_WRITE
> and doing a 'make allmodconfig' and seeing what throws an error, I'm not sure how
> to track down all the users.  On my fairly stripped-down .config, I have:
> 
> [/usr/src/linux-next] find * -name '.*.cmd' | wc -l
> 4671
> [/usr/src/linux-next] find * -name '.*.cmd' | xargs grep include/linux/fs.h | wc -l
> 2339
> 
> Which is telling me that pretty much half the world ends up including fs.h indirectly.

Yep.

I hope sh math emulator does not include fs.h.

arch/sh/math-emu/math.c:#define READ(d,a)       ({if(get_user(d, (typeof (d)*)a)

> Now for the mandatory bikeshedding:
> 
> What do we want to rename them to? :)

REQ_ prefix would fit there well, I'd say.
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
