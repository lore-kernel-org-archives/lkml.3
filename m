Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab3GLXdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 19:33:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53889 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3GLXdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 19:33:04 -0400
Date: Sat, 13 Jul 2013 01:33:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, akpm@linux-foundation.org,
        jslaby@suse.cz, rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
        Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org,
        Steev Klimaszewski <steev@genesi-usa.com>
Subject: Re: [PATCH] Route kbd LEDs through the generic LEDs layer
Message-ID: <20130712233301.GA3646@amd.pavel.ucw.cz>
References: <201011111440.07882.dmitry.torokhov@gmail.com>
 <20110102090935.GV32469@atrey.karlin.mff.cuni.cz>
 <20110102103210.GA25662@core.coreip.homeip.net>
 <20110102225741.GX5480@const.famille.thibault.fr>
 <20110112182702.GA9168@core.coreip.homeip.net>
 <20111114040613.GA4992@type.famille.thibault.fr>
 <20121221003449.GA6999@type.youpi.perso.aquilenet.fr>
 <20130707101028.GD5651@type.youpi.perso.aquilenet.fr>
 <20130712113655.GA4227@amd.pavel.ucw.cz>
 <20130712124242.GA5876@type>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130712124242.GA5876@type>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > This permits to reassign keyboard LEDs to something else than keyboard "leds"
> > > state, by adding keyboard led and modifier triggers connected to a series
> > > of VT input LEDs, themselves connected to VT input triggers, which
> > > per-input device LEDs use by default.  Userland can thus easily change the LED
> > > behavior of (a priori) all input devices, or of particular input devices.
> > 
> > Nice! Leds now have proper /sys interface.
> > 
> > But... I boot up, switch from X to console, press capslock, and no
> > reaction anywhere.
> 
> Is it working without the patch?  Console-setup for instance is known to
> have broken the capslock LED, which is precisely one of the reasons for
> this patch, which will provide console-setup with a way to bring back
> caps lock working properly.

You are right, it was broken before.

> At any rate, please provide way more information about your keyboard
> and LED configuration (output of dumpkeys, dmesg, content of
> /sys/class/leds/*/trigger, etc.), as things are just working fine for me
> (just like it has been for the past two years).

Well... I just verified, and it works "as well as before", which it
should.

> > Note that this is notebook with usb keyboard plugged in (and two
> > monitors), but I believe this worked before...
> 
> Things work fine with my USB keyboard too, is this perhaps using an odd
> driver which would not expose LEDs in a standard way?

No, everything works as well as it did. Feel free to add:

Tested-by: Pavel Machek <pavel@ucw.cz>

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
