Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaHTFu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 01:50:58 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:57933 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaHTFu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 01:50:56 -0400
Date: Wed, 20 Aug 2014 07:50:50 +0200
From: Andreas Mohr <andi@lisas.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 1/2] SOUND: kill gameport bits
Message-ID: <20140820055050.GA25445@rhlx01.hs-esslingen.de>
References: <20140820024638.GA25240@rhlx01.hs-esslingen.de>
 <20140820051815.GA1109@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820051815.GA1109@core.coreip.homeip.net>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 10:18:15PM -0700, Dmitry Torokhov wrote:
> Hi Andreas,
> 
> On Wed, Aug 20, 2014 at 04:46:38AM +0200, Andreas Mohr wrote:
> 
> > Hi,
> > 
> > > Gameport support hasn't been working well ever since cpufreq became
> > > mainstream and it becomes increasingly hard to find hardware and
> > > software
> > > that would run on such old hardware.
> > 
> > Given that I'm puzzled why one would want to deprecate a whole subsystem
> > which appears to be supported by a whole 14 different PCI sound card
> > drivers (where the ones I'm owning hardware of are intended to be in
> > active maintenance)
> 
> Are you actively testing gameport interfaces with real joysticks/gamepads on
> these cards? And what software is still in use that runs on these old boxes
> (with mainline kernel)?

Well, I did test some games with real joysticks
e.g. in order to implement working Digital Enhanced Game Port support
(where BTW the couple cards/driver combos which support that
should also be completely unaffected by cpufreq
since its delay accounting is digital).


> > and only 3 ISA-based ones, I'm missing several
> > details and justifications of that decision here (perhaps there was a
> > prior discussion/activity that I'm missing?).
> 
> There was a post to linux-input a few days ago when I ased if anyone woudl cry
> over gameport going away.

Missed that one (not subscribed), sorry.

> > Also, I'm left wondering why e.g. my Athlon XP system (a very popular
> > choice for longer times) would be affected by Cpufreq...
> > And there are no details on how exactly cpufreq is a problem or how this
> > timing issue could be fixed...
> 
> If you take a look at gameport_measure_speed() in gameport.c you will see that
> it counts cycles for timing, which obviously does not work that well when CPU
> frequency changes.

Yup, but at least not for the candidates above.

> The bugs have been opened in bugzilla/reported on lists ages ago but nobody
> stepped up to fix that.

Ouch.
I'm afraid I don't have any cpufreq-supporting hardware (hint, hint)
which would enable me to work on it, though.

> > The obvious workaround for such an ensuing dearth of hardware support
> > could be USB 15-pin gameport adapters - but are they even supported on
> > Linux? Haven't seen info on this...
> > And even if supported, these adapters (at least the non-perfect ones, as
> > can be seen from reviews on a well-known online shop site) are said to
> > be hit-or-miss.

> They have better chance of being supported ;) I had a couple a few years back
> and they did work for me.

Good to know. I took a note to buy a good adapter as well.

> > If we keep removing functionality like this, then why stop short of
> > removing x86 32bit as a whole? By having Linux support nicely restricted
> > to hardware made within the last 5 years, we would surely be doing the
> > planned-obsolescence Micro$oft "ecosystem" (what was ecological about
> > this again?) a huge favour...
> 
> I really do not care about Microsoft and favors, I just go by the fact that
> this hardware is becoming naturally extinct. And not only hardware, but also
> software that uses it. Do you still play a lot of games with joysticks on such
> hardware?

Not me (I'm a developer). But other people probably would be inclined to
do so, as long as sufficient support remains in place,
on an architecture which is still in very wide use.
And this case here (as opposed to e.g. the NI5010 ISA BNC network
card where it was arguably very likely that it was totally unused)
seems like a self-fulfilling prophecy...

Andreas Mohr

-- 
GNU/Linux. It's not the software that's free, it's you.
