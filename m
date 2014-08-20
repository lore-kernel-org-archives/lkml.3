Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaHTO12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:27:28 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:44153 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaHTO10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:27:26 -0400
Date: Wed, 20 Aug 2014 16:27:19 +0200
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Andreas Mohr <andi@lisas.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/2] SOUND: kill gameport bits
Message-ID: <20140820142719.GA15319@rhlx01.hs-esslingen.de>
References: <20140820024638.GA25240@rhlx01.hs-esslingen.de>
 <20140820051815.GA1109@core.coreip.homeip.net>
 <s5hwqa3hetu.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <s5hwqa3hetu.wl-tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for having introduced a cut in discussion threading (broken
formatting which caused In-Reply-To header loss).

Will add several slightly disconnected items in single mail
due to restricted environment.

On Wed, Aug 20, 2014 at 08:09:49AM +0200, Takashi Iwai wrote:
> At Tue, 19 Aug 2014 22:18:15 -0700,
> Dmitry Torokhov wrote:
> > 
> > Hi Andreas,
> > 
> > On Wed, Aug 20, 2014 at 04:46:38AM +0200, Andreas Mohr wrote:
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

BTW, I have a slightly extended vested interest in that topic since I
did initial joystick driver support on Wine, too...
(Read: there is the possibility of using many Windows apps with their
joystick support, too - not to mention the various arcade emulators
which probably have that as well).

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

He probably meant one issue filed about this problem here:
"Direct use of tsc: Analog joystick doesn't work properly with CPU
frequency scaling activated"
https://bugzilla.kernel.org/show_bug.cgi?id=12297
right?

> Hm, can't we just use the standard ktime for measuring the time diff?
> And, I guess only few programs care the speed parameter.

For clocksource matters, I've got an initial patch for Azt3328 which
adds its 1MHz timer as a clocksource, which probably means that on this
hardware the gameport would be accurate for both digital and non-digital
modes (not that that would help much for machines without this soundcard
which also don't sport a high-res timer...).

Since I've got some more patches waiting for some gameport compatible
soundcard devices, I should be able to take this opportunity to retest
gameport support, too...
And since there's in fact my VIA system which has my second azt3328 in
its single-slot PCI and which in fact probably is a cpufreq system,
I might be able to work on fixing the cpufreq timer issue (but if
Vojtech managed to golden his offer to work on a fix to this issue, I
would be far from unhappy :).



BTW, I think I spotted a bug in the gameport removal commit (one driver
did an if (!joystick) ... where the subsequent line was removed as well
even though logically it quite likely shouldn't).


>From my POV it would be much more favourable to do this relatively simple(??)
timer fix rather than removing an entire subsystem since it's partially(?)
broken.

Andreas Mohr
