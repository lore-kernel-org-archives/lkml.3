Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbaDMBay (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 21:30:54 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:53573 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaDMBax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 21:30:53 -0400
Date: Sat, 12 Apr 2014 18:30:49 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
        David Herrmann <dh.herrmann@gmail.com>, akpm@linux-foundation.org,
        jslaby@suse.cz, Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
        Niels de Vos <devos@fedoraproject.org>,
        linux-arm-kernel@lists.infradead.org,
        Steev Klimaszewski <steev@genesi-usa.com>, blogic@openwrt.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH] Route keyboard LEDs through the generic LEDs layer.
Message-ID: <20140413013049.GB28990@core.coreip.homeip.net>
References: <20140331122323.GC6044@type.bordeaux.inria.fr>
 <20140407021015.GA8518@core.coreip.homeip.net>
 <20140407075423.GZ7179@type.wlan.youpi.perso.aquilenet.fr>
 <20140408083940.GA22855@core.coreip.homeip.net>
 <20140412100934.GA7196@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140412100934.GA7196@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 12:09:34PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > > This permits to reassign keyboard LEDs to something else than keyboard "leds"
> > > > > state, by adding keyboard led and modifier triggers connected to a series
> > > > > of VT input LEDs, themselves connected to VT input triggers, which
> > > > > per-input device LEDs use by default.  Userland can thus easily change the LED
> > > > > behavior of (a priori) all input devices, or of particular input devices.
> > > > > 
> > > > 
> > > > I still have the same concern that I believe I already mentioned a while
> > > > ago: how do we reconcile the LED control via triggers with LED control
> > > > done through event devices?
> 
> I think we should deprecate LED controls using event devices. We have
> nice API for LEDs, and it is not in input.
> 
> 
> 
> 
> > > > Currently, as far as I can see, they will be
> > > > clashing with each other. I.e. if I remap my capslock led to be the new
> > > > shiftlock and then userspace writes EV_LED/LED_CAPSL it would light up
> > > > my new "shift lock", right?
> > > 
> > > Well, yes, sure, if you shoot in your foot it will hurt :) (although
> > > here the damage is really small, it is just LED lighting or not).
> > 
> > This is not about amount of damage but the overall correctness of the
> > implementation. I'd rather not have a solution with known holes, if
> > possible.
> 
> I'd say that applications using direct EV_LED interface should just
> stop doing it. Yes, you can probably use led API and still toggle the
> led using gpio api behind leds back (not tested, perhaps there are
> interlocks that prevent that)... and it is same situation with
> EV_LED. We should just teach applications not to do that.
> 
> Would solution where EV_LED would be ignored when there's non-default
> trigger selected work for you?

Not ignored but rather routed to the LED that is currently selected for
given function. This way if I re-purposed CapsLock LED for Wifi and do
not provide a replacement EV_LED will be effectively dropped, but if I
switch CapsLock with NumLock I want the event to affect the appropriate
LED.

Thanks.

-- 
Dmitry
