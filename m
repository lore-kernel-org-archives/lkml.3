Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaHTGbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:31:36 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57165 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaHTGbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:31:35 -0400
Date: Tue, 19 Aug 2014 23:31:30 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/2] SOUND: kill gameport bits
Message-ID: <20140820063130.GA11226@core.coreip.homeip.net>
References: <20140820024638.GA25240@rhlx01.hs-esslingen.de>
 <20140820051815.GA1109@core.coreip.homeip.net>
 <s5hwqa3hetu.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hwqa3hetu.wl-tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 08:09:49AM +0200, Takashi Iwai wrote:
> At Tue, 19 Aug 2014 22:18:15 -0700,
> Dmitry Torokhov wrote:
> > 
> > Hi Andreas,
> > 
> > On Wed, Aug 20, 2014 at 04:46:38AM +0200, Andreas Mohr wrote:
> > 
> > > Hi,
> > > 
> > > > Gameport support hasn't been working well ever since cpufreq became
> > > > mainstream and it becomes increasingly hard to find hardware and
> > > > software
> > > > that would run on such old hardware.
> > > 
> > > Given that I'm puzzled why one would want to deprecate a whole subsystem
> > > which appears to be supported by a whole 14 different PCI sound card
> > > drivers (where the ones I'm owning hardware of are intended to be in
> > > active maintenance)
> > 
> > Are you actively testing gameport interfaces with real joysticks/gamepads on
> > these cards? And what software is still in use that runs on these old boxes
> > (with mainline kernel)?
> 
> MPlayer and some programs have the joystick interface (even often
> activated as default), IIRC.  I don't use it.  But I tested it
> sometime ago.

But we are not dropping joystick support, you can still use USB, BT, etc
joysticks. It is only gameport joysticks that I think are pretty much extinct
by now.

> 
> > > and only 3 ISA-based ones, I'm missing several
> > > details and justifications of that decision here (perhaps there was a
> > > prior discussion/activity that I'm missing?).
> > 
> > There was a post to linux-input a few days ago when I ased if anyone woudl cry
> > over gameport going away.
> 
> Well, asking the usage in the devel ML isn't enough, I'm afraid.
> ML is only for a small group of developers, where no user cares unless
> they hit a problem.

That is true, but what is better venue? Even disabling in Kconfig won't help
much as distros will re-enable it and users do not compile their own kernels.

> 
> > > Also, I'm left wondering why e.g. my Athlon XP system (a very popular
> > > choice for longer times) would be affected by Cpufreq...
> > > And there are no details on how exactly cpufreq is a problem or how this
> > > timing issue could be fixed...
> > 
> > If you take a look at gameport_measure_speed() in gameport.c you will see that
> > it counts cycles for timing, which obviously does not work that well when CPU
> > frequency changes.
> > 
> > The bugs have been opened in bugzilla/reported on lists ages ago but nobody
> > stepped up to fix that.
> 
> Hm, can't we just use the standard ktime for measuring the time diff?

We could use high-res timers, if they are available. Are they available on such
old hardware and are they sufficiently fast to provide needed timings? I
definitely do not have any hardware to est with.

> And, I guess only few programs care the speed parameter.

It is not programs that care about speed parameter, it is joystick kernel
drivers that need it to time access.

> 
> 
> > > The obvious workaround for such an ensuing dearth of hardware support
> > > could be USB 15-pin gameport adapters - but are they even supported on
> > > Linux? Haven't seen info on this...
> > > And even if supported, these adapters (at least the non-perfect ones, as
> > > can be seen from reviews on a well-known online shop site) are said to
> > > be hit-or-miss.
> > > 
> > > http://www.flightsim.com/vbfs/showthread.php?238938-joystick-GamePort-to-USB-adapter-question
> > > http://reviews.thesource.ca/9026/2600164/nexxtech-usb-gameport-adapter-reviews/reviews.htm
> > > 
> > 
> > They have better chance of being supported ;) I had a couple a few years back
> > and they did work for me.
> > 
> > > If we keep removing functionality like this, then why stop short of
> > > removing x86 32bit as a whole? By having Linux support nicely restricted
> > > to hardware made within the last 5 years, we would surely be doing the
> > > planned-obsolescence Micro$oft "ecosystem" (what was ecological about
> > > this again?) a huge favour...
> > 
> > I really do not care about Microsoft and favors, I just go by the fact that
> > this hardware is becoming naturally extinct. And not only hardware, but also
> > software that uses it. Do you still play a lot of games with joysticks on such
> > hardware?
> 
> IMO, the number of users is less relevant for such an action.  Even if
> there're only a few users, users do exist.
> 
> But, if the code maintenance becomes a too big burden, it's time to
> think of code removal.  Is this the case?  Really difficult to keep
> the code?

We can keep it, but it is pretty much broken, so why?

Thanks.

-- 
Dmitry
