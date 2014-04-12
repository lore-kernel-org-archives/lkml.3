Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbaDLKJi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 06:09:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39723 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756020AbaDLKJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 06:09:36 -0400
Date: Sat, 12 Apr 2014 12:09:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
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
Message-ID: <20140412100934.GA7196@amd.pavel.ucw.cz>
References: <20140331122323.GC6044@type.bordeaux.inria.fr>
 <20140407021015.GA8518@core.coreip.homeip.net>
 <20140407075423.GZ7179@type.wlan.youpi.perso.aquilenet.fr>
 <20140408083940.GA22855@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408083940.GA22855@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > This permits to reassign keyboard LEDs to something else than keyboard "leds"
> > > > state, by adding keyboard led and modifier triggers connected to a series
> > > > of VT input LEDs, themselves connected to VT input triggers, which
> > > > per-input device LEDs use by default.  Userland can thus easily change the LED
> > > > behavior of (a priori) all input devices, or of particular input devices.
> > > > 
> > > 
> > > I still have the same concern that I believe I already mentioned a while
> > > ago: how do we reconcile the LED control via triggers with LED control
> > > done through event devices?

I think we should deprecate LED controls using event devices. We have
nice API for LEDs, and it is not in input.




> > > Currently, as far as I can see, they will be
> > > clashing with each other. I.e. if I remap my capslock led to be the new
> > > shiftlock and then userspace writes EV_LED/LED_CAPSL it would light up
> > > my new "shift lock", right?
> > 
> > Well, yes, sure, if you shoot in your foot it will hurt :) (although
> > here the damage is really small, it is just LED lighting or not).
> 
> This is not about amount of damage but the overall correctness of the
> implementation. I'd rather not have a solution with known holes, if
> possible.

I'd say that applications using direct EV_LED interface should just
stop doing it. Yes, you can probably use led API and still toggle the
led using gpio api behind leds back (not tested, perhaps there are
interlocks that prevent that)... and it is same situation with
EV_LED. We should just teach applications not to do that.

Would solution where EV_LED would be ignored when there's non-default
trigger selected work for you?

> > My goal, at the beginning, was to be able to fix the console-setup
> > bug.  That was that console-setup wants to use, for the capslock key,
> > something else than the capslock mechanism hard-wired in the kernel,
> > so as to get way more fine-grain control over how caps is handled.
> > But then the capslock LED would not lit any more.  By remapping the
> > VT-level capslock led to the foo-lock used by console-setup, one gets
> > back capslock LEDs of all keyboards working back as expected by the
> > user.  I also use it for getting a group LED, just like I have on X,
> > to know which keyboard layout group I am in.  People using non-latin
> > layouts really need that.
> 
> I understand the desire, however I still wonder if we should be
> extending legacy VT given that David wants to move it all to
> userspace.

It looks like legacy VT is going to stay here for long long time...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
