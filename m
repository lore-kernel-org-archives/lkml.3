Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaHTGjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:39:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38551 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaHTGjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:39:42 -0400
Date: Wed, 20 Aug 2014 08:39:51 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 1/2] SOUND: kill gameport bits
Message-ID: <20140820063951.GA6791@suse.cz>
References: <20140820024638.GA25240@rhlx01.hs-esslingen.de>
 <20140820051815.GA1109@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820051815.GA1109@core.coreip.homeip.net>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 10:18:15PM -0700, Dmitry Torokhov wrote:

> Are you actively testing gameport interfaces with real joysticks/gamepads on
> these cards? And what software is still in use that runs on these old boxes
> (with mainline kernel)?

I still do have a huge box of gameport hardware in my office, it's just
that I haven't opened it for a number of years. However, if this thread
spurred enough interest in gameport devices, I would be willing to open
it and do the needed fixes.

If not, I think dropping makes sense. I still would shed a tear for all
those weird devices in the box, and possibly design an ATMega-based
USB<->Gameport adapter that actually works and supports even the digital
joysticks.

> > Also, I'm left wondering why e.g. my Athlon XP system (a very popular
> > choice for longer times) would be affected by Cpufreq...
> > And there are no details on how exactly cpufreq is a problem or how this
> > timing issue could be fixed...
> 
> If you take a look at gameport_measure_speed() in gameport.c you will see that
> it counts cycles for timing, which obviously does not work that well when CPU
> frequency changes.
> 
> The bugs have been opened in bugzilla/reported on lists ages ago but nobody
> stepped up to fix that.

It wouldn't be hard to fix: That code was developed when the timing
infrastructure in the kernel was non-existent, making use of it today
would make things a lot easier.

> > The obvious workaround for such an ensuing dearth of hardware support
> > could be USB 15-pin gameport adapters - but are they even supported on
> > Linux? Haven't seen info on this...
> > And even if supported, these adapters (at least the non-perfect ones, as
> > can be seen from reviews on a well-known online shop site) are said to
> > be hit-or-miss.
> > 
> > http://www.flightsim.com/vbfs/showthread.php?238938-joystick-GamePort-to-USB-adapter-question
> > http://reviews.thesource.ca/9026/2600164/nexxtech-usb-gameport-adapter-reviews/reviews.htm
> > 
> 
> They have better chance of being supported ;) I had a couple a few years back
> and they did work for me.

They do work for analog joysticks if you don't want any extended
functionality. I have a couple in said box.

-- 
Vojtech Pavlik
Director SuSE Labs
