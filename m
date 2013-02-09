Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab3BIRtP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 12:49:15 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36183 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401Ab3BIRtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 12:49:13 -0500
Date: Sat, 9 Feb 2013 18:49:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Li Fei <fei.li@intel.com>, rjw@sisk.pl,
        len.brown@intel.com, mingo@redhat.com, peterz@infradead.org,
        biao.wang@intel.com, linux-pm@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Subject: Re: [fuse-devel] [PATCH] fuse: make fuse daemon frozen along with
 kernel threads
Message-ID: <20130209174910.GA28370@amd.pavel.ucw.cz>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <CAJfpegvJD75ahBViUqAwVTBLuF5yrxOcVvzYHmcsTgwxX+7Oqg@mail.gmail.com>
 <20130207084144.GB6168@frosties>
 <CAJfpegv1-Db+0DxZ8QUQv9BJiEBG3-8a2YaOVMbkb=Y7m+3DTw@mail.gmail.com>
 <20130208141123.GA29460@frosties>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208141123.GA29460@frosties>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > The only way to *reliably* freeze fuse filesystems is to let it freeze
> > even if there are outstanding requests.  But that's the hardest to
> > implement, because then it needs to allow freezing of tasks waiting on
> > i_mutex, for example, which is currently not possible.  But this is
> > the only way I see that would not have unsolvable corner cases that
> > prop up at the worst moment.
> > 
> > And yes, it would be prudent to  wait some time for pending requests
> > to finish before freezing.  But it's not a requirement, things
> > *should* work without that: suspending a machine is just like a very
> > long pause by the CPU, as long as no hardware is involved.  And with
> > fuse filesystems there is no hardware involved directly by definition.
> > 
> > But I'm open to ideas and at this stage I think even patches that
> > improve the situation for the majority of the cases would be
> > acceptable, since this is turning out to be a major problem for a lot
> > of people.
> 
> For shutdown in userspace there is the sendsigs.omit.d/ to avoid the
> problem of halting/killing processes of the fuse filesystems (or other
> services) prematurely. I guess something similar needs to be done for
> freeze. The fuse filesystem has to tell the kernel what is up.

Would it be feasible to create some kind of fuse-stop-script.sh, and
run it before suspend (from userspace)? It should be pretty similar to
sendsigs.omit.d/ mechanism AFAICT.

I'm sorry, freezer is not too suitable for fuse.

(BTW: for suspend, we may be able to improve it so that it is possible
to remove freezer from it. For hibernation, it would be very hard.)
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
