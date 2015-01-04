Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbbADUKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 15:10:30 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54168 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbbADUK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 15:10:29 -0500
Date: Sun, 4 Jan 2015 21:10:26 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: marc.zyngier@arm.com, rmk+kernel@arm.linux.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150104201026.GA23427@amd>
References: <20150104190123.GA20153@amd>
 <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2015-01-04 15:03:02, Nicolas Pitre wrote:
> On Sun, 4 Jan 2015, Pavel Machek wrote:
> 
> > 9fc2105aeaaf56b0cf75296a84702d0f9e64437b breaks audio in python, and
> > probably elsewhere, with message
> > 
> > FATAL: cannot locate cpu MHz in /proc/cpuinfo
> > 
> > I'm not the first one to hit it, see for example
> > 
> > https://theredblacktree.wordpress.com/2014/08/10/fatal-cannot-locate-cpu-mhz-in-proccpuinfo/
> > https://devtalk.nvidia.com/default/topic/765800/workaround-for-fatal-cannot-locate-cpu-mhz-in-proc-cpuinf/?offset=1
> > 
> > Reading original changelog, I have to say "Stop breaking working
> > setups. You know who you are!".
> > 
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> 
> NAK.
> 
> No setups actually relying on this completely fony bogomips value 
> bearing no links to hardware reality coule have been qualified as 
> "working".

You broke python-pyaudio in Debian 7.7, which is pretty new version...
I'm not saying something relies on the _exact_ value there, but the
change is bad.

> The bogomips entry was removed from /proc/cpuinfo in 2013.  We're now in 
> 2015.  You're apparently the first to suggest moving the kernel back to 
> providing random values via /proc/cpuinfo.  So this removal must not 
> have inconvenienced that many people in the end.

Take a look at links above. One broken system would be
enough... people noticed but did not complain on lkml.

> Broken applications appear to have been fixed already as mentioned via 
> those links you provided above.  So if you want a working setup, you may 
> stick with a kernel of the same vintage as your user space apps or 
> update the later.

That is not how kernel development should work. See

https://lkml.org/lkml/2012/12/23/75

> If that is still unacceptable to you for whatever reason, then the least 
> wrong compromize should be:
> 
> 	seq_printf(m, "BogoMIPS\t: 1.00\n");
> 
> That'D allow for those broken applications to run while making clear 
> that the provided value is phony. I was about to suggest 0.00 but that 
> could trigger a divide by zero error somewhere I suppose.

I don't know what 1.00 will cause, and neither do you, so what about
simply reverting the bad patch?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
