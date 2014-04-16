Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422655AbaDPXiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:38:15 -0400
Received: from toccata.ens-lyon.fr ([140.77.166.68]:55417 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161169AbaDPXiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:38:10 -0400
Date: Thu, 17 Apr 2014 01:38:01 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, David Herrmann <dh.herrmann@gmail.com>,
        akpm@linux-foundation.org, jslaby@suse.cz,
        Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
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
Message-ID: <20140416233801.GF5545@type.youpi.perso.aquilenet.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Pavel Machek <pavel@ucw.cz>, David Herrmann <dh.herrmann@gmail.com>,
	akpm@linux-foundation.org, jslaby@suse.cz,
	Bryan Wu <cooloney@gmail.com>, rpurdie@rpsys.net,
	linux-kernel@vger.kernel.org, Evan Broder <evan@ebroder.net>,
	Arnaud Patard <arnaud.patard@rtp-net.org>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Matt Sealey <matt@genesi-usa.com>, Rob Clark <robdclark@gmail.com>,
	Niels de Vos <devos@fedoraproject.org>,
	linux-arm-kernel@lists.infradead.org,
	Steev Klimaszewski <steev@genesi-usa.com>, blogic@openwrt.org,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140413013049.GB28990@core.coreip.homeip.net>
 <20140413012557.GA28990@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21+34 (58baf7c9f32f) (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Dmitry Torokhov, le Sat 12 Apr 2014 18:25:57 -0700, a écrit :
> On Fri, Apr 11, 2014 at 08:12:02AM +0200, Samuel Thibault wrote:
> > I'm sorry this went out with a few mistakes.
> > 
> > Samuel Thibault, le Wed 09 Apr 2014 01:33:06 +0200, a écrit :
> > > Dmitry Torokhov, le Tue 08 Apr 2014 01:39:40 -0700, a écrit :
> > > > It is not about the VT, I am talking about pure input core. If I
> > > > repurpose CapsLock LED for my WiFi indicator I do not want to go into
> > > > other programs and teach them that they should stay away from trying to
> > > > control this LED.
> > > 
> > > Err, but even without talking about repurposing Capslock LED for WiFi...
> > > How is managed the conflict between the normal capslock behavior and
> > > other programs' action on the underlying input device?  I don't think
> > > this patch does not introduce the problem.
> > 
> > I of course meant "I don't think this patch introduces the problem".
> 
> The difference in my eyes is that with old interface both players knew
> that they would be affecting (and potentially interfering) with the
> state of CapsLock LED. With your proposed changes users of old
> interfaces have no idea if they are actually toggling CapsLock LED or if
> they are affecting something that is no longer a CapsLock LED.

Mmm, I thought you were talking about evdev programs (which would always
get to manipulate the hardware capslock leds anyway)?

Are you here talking about KDSETLEDS?  This is a very odd ioctl
actually.  Its name suggests that its purpose is to just light LEDs,
but AFAIK it is essentially used by users to change the status of the
keyboard state, and the LED change is just a side effect for them.  So
if e.g. the numlock LED is repurposed to wifi, should KDSETLEDS really
just switch on the LED (thus defeating the wifi purpose), while the user
probably used setleds +num only to get its numlock enabled by default
(and doesn't care about seeing that on the keyboard, on the contrary, he
preferred to see the wifi state).

> > > How to decide which one to prioritize?
> > > 
> > > Is it just because console-setup happens to repurpose the capslock LED
> > > key that applications should suddenly not have capslock LED control
> > > at all?  That's contradictory with the use case you have given.
> > 
> > Oops, not the use case you have given, but a typical use-case of wanting
> > to use a program which does nice things with the capslock LED, and then
> > having to teach console-setup not to repurpose the capslock LED.
> 
> I believe that applications should be able to control sate of CapsLock
> and other LEDs and that the affected LED should not be the physical LED
> but rather LED that is currently tied to CapsLock trigger (if any).

Which kind of applications are you talking about?  What I have heard
from users was that they either wanted to have an effect on the physical
LED, or on the keyboard state, but not really "on the LED which shows
the keyboard state", which would just be a side consequence of what they
really want to achieve.

> This
> way everything works as is by default and if I decide to have my
> physical CapsLock LED to be repurposed for Wifi or HDD activity or
> whatever I do not need to teach unrelated applications to stop touching
> it.

Again, which applications are you thinking about precisely?  If a
user has an application which wants to really show something on the
capslock LED, then the user's intent was really the physical LED, and he
hurted himself in the foot.  Otherwise, what was the intention of the
application?  I don't understand why an application would want to light
"the LED which shows the capslock state", and not simply the keyboard
capslock status (which thus may or may not be reflected on some physical
LED, depending whether some LED is plugged on the keyboard capslock
status).

> > > That
> > > leads me into believing that we should not try to push a hard rule, and
> > > just let the user manage what accesses it.  We could indeed make the VT
> > > always take priority, but then that would probably break some existing
> > > applications.
> > 
> > Such as the example above, with the capslock LED.
> 
> I am not saying that VT shoudl have priority, I am saying we need to
> come up with implementation that does not result in inconsistent
> behavior.

Ok, but for now I don't see in which exact case we'd have an
inconsistency.

Dmitry Torokhov, le Sat 12 Apr 2014 18:30:49 -0700, a écrit :
> > I'd say that applications using direct EV_LED interface should just
> > stop doing it. Yes, you can probably use led API and still toggle the
> > led using gpio api behind leds back (not tested, perhaps there are
> > interlocks that prevent that)... and it is same situation with
> > EV_LED. We should just teach applications not to do that.
> > 
> > Would solution where EV_LED would be ignored when there's non-default
> > trigger selected work for you?
> 
> Not ignored but rather routed to the LED that is currently selected for
> given function. This way if I re-purposed CapsLock LED for Wifi and do
> not provide a replacement EV_LED will be effectively dropped, but if I
> switch CapsLock with NumLock I want the event to affect the appropriate
> LED.

Err, but are we really talking about the same layer?  I thought
EV_LED was meant to drive hardware, not to drive any kind of software
abstraction on top of it.  Adding an indirection to what EV_LED actually
means at least surely needs quite some heavy patching in the input
layer, I'm not even sure I really want to dive into that.

Adding an indirection there also looks to me like confusing the picture
even more.  The way I see it is (using a monospace font):

kbd state -> kbd led -> kbd trigger -> vt led -> vt trigger -> input led
  ^^                                ^^                      ^^    ^^
KDSETLED                            XX                      YY   EV_LED

XX is vt::capsl/trigger, and YY is input*::capsl/trigger. Applications
can either modify the keyboard state through KDSETLED, which may or may
not be shown by some LEDs depending on XX and YY, or modify the hardware
leds through EV_LED, which thus doesn't care about XX and YY.

The only "case" I see "broken" is applications which would be using
KDSETLED to just flash some keyboard LEDs (and happen to also tamper
with keyboard state...). With a default configuration they will still
work.  If the LEDs are repurposed, the application effect won't show up
(unless the scroll/caps/num still appear in the LED reassignation, and
then the application effect will show up, with the repurpose exchanges).

In the end, I really don't see which use case you are thinking about
precisely.

Samuel
