Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaHTOsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:48:32 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:51839 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaHTOsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:48:30 -0400
Date: Wed, 20 Aug 2014 07:48:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/2] SOUND: kill gameport bits
Message-ID: <20140820144746.GA18099@core.coreip.homeip.net>
References: <20140820024638.GA25240@rhlx01.hs-esslingen.de>
 <20140820051815.GA1109@core.coreip.homeip.net>
 <s5hwqa3hetu.wl-tiwai@suse.de>
 <20140820142719.GA15319@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820142719.GA15319@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 04:27:19PM +0200, Andreas Mohr wrote:
> > > > Also, I'm left wondering why e.g. my Athlon XP system (a very popular
> > > > choice for longer times) would be affected by Cpufreq...
> > > > And there are no details on how exactly cpufreq is a problem or how this
> > > > timing issue could be fixed...
> > > 
> > > If you take a look at gameport_measure_speed() in gameport.c you will see that
> > > it counts cycles for timing, which obviously does not work that well when CPU
> > > frequency changes.
> > > 
> > > The bugs have been opened in bugzilla/reported on lists ages ago but nobody
> > > stepped up to fix that.
> 
> He probably meant one issue filed about this problem here:
> "Direct use of tsc: Analog joystick doesn't work properly with CPU
> frequency scaling activated"
> https://bugzilla.kernel.org/show_bug.cgi?id=12297
> right?

Right. There is also about a3d joystick not workign and I think a few others.

> 
> > Hm, can't we just use the standard ktime for measuring the time diff?
> > And, I guess only few programs care the speed parameter.
> 
> For clocksource matters, I've got an initial patch for Azt3328 which
> adds its 1MHz timer as a clocksource, which probably means that on this
> hardware the gameport would be accurate for both digital and non-digital
> modes (not that that would help much for machines without this soundcard
> which also don't sport a high-res timer...).
> 
> Since I've got some more patches waiting for some gameport compatible
> soundcard devices, I should be able to take this opportunity to retest
> gameport support, too...
> And since there's in fact my VIA system which has my second azt3328 in
> its single-slot PCI and which in fact probably is a cpufreq system,
> I might be able to work on fixing the cpufreq timer issue (but if
> Vojtech managed to golden his offer to work on a fix to this issue, I
> would be far from unhappy :).
> 
> 
> 
> BTW, I think I spotted a bug in the gameport removal commit (one driver
> did an if (!joystick) ... where the subsequent line was removed as well
> even though logically it quite likely shouldn't).
> 
> 
> From my POV it would be much more favourable to do this relatively simple(??)
> timer fix rather than removing an entire subsystem since it's partially(?)
> broken.

Fair enough. If you send me patches that fixes issues then I do not see any
problem with it staying in. Vojtech also promised to dig out his old hardware.

Thanks.

-- 
Dmitry
