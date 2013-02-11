Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab3BKKxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 05:53:21 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47093 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3BKKxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 05:53:17 -0500
Date: Mon, 11 Feb 2013 11:53:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Goswin von Brederlow <goswin-v-b@web.de>, Li Fei <fei.li@intel.com>,
        len.brown@intel.com, mingo@redhat.com, peterz@infradead.org,
        biao.wang@intel.com, linux-pm@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Subject: Re: Getting rid of freezer for suspend [was Re: [fuse-devel]
 [PATCH] fuse: make fuse daemon frozen along with kernel threads]
Message-ID: <20130211105314.GA32322@amd.pavel.ucw.cz>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <3938124.8eafYb16IB@vostro.rjw.lan>
 <20130210185504.GA17268@amd.pavel.ucw.cz>
 <2964781.rPUOipNRNb@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2964781.rPUOipNRNb@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > > The whole memory shrinking we do for hibernation is now done by allocating
> > > > > > memory, so the freezer is not necessary for *that* and there's *zero*
> > > > > > difference between suspend and hibernation with respect to why the freezer is
> > > > > > used.
> > > > > 
> > > > > Funny. Freezer was put there so that hibernation image was safe to
> > > > > write out. You need disk subsystems in workable state for hibernation.
> > > > 
> > > > I'm not really sure what you're talking about.  Why do you think the freezer is
> > > > necessary for that?
> > 
> > Well, from freezer you need:
> > 
> > 1) user process frozen.
> > 
> > 2) essential locks _not_ held so that block devices are still functional.
> > 
> > > > > mmap... what is problem with mmap? For suspend, memory is powered, so
> > > > > you can permit people changing it.
> > > > 
> > > > Suppose mmap is used to make the registers of some device available to user
> > > > space.  Yes, that can happen.
> > 
> > "Don't do it, then". Yes, can happen, but hopefully is not too common
> > these days. [And... freezer doing 1) but not 2) would be enough to
> > handle that. Freezer doing 1) but not 2) would also be simpler...]
> 
> Again, I'm not sure what you mean.
> 
> Are you trying to say that it would be OK to freeze user space tasks in
> the D state?

Yes. For suspend, that should pretty much work. (With caveats, as
Miklos noticed).

Unfortunately, that is not going to be too easy for hibernation.

We could mae the situation easier by specifying we only support
hibernation to local SATA or SCSI disk, not over NBD, iSCSI,
etc... That would reduce number of locks that need to be available for
hibernation.

Unfortunately, uswsusp did not make that easy as userland may want to
do arbitrary stuff with the image.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
