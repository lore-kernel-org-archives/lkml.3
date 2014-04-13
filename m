Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaDMB0j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 21:26:39 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:61654 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaDMB0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 21:26:01 -0400
Date: Sat, 12 Apr 2014 18:25:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
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
Subject: Re: [PATCH] Route keyboard LEDs through the generic LEDs layer.
Message-ID: <20140413012557.GA28990@core.coreip.homeip.net>
References: <20140331122323.GC6044@type.bordeaux.inria.fr>
 <20140407021015.GA8518@core.coreip.homeip.net>
 <20140407075423.GZ7179@type.wlan.youpi.perso.aquilenet.fr>
 <20140408083940.GA22855@core.coreip.homeip.net>
 <20140408233306.GJ27820@type.youpi.perso.aquilenet.fr>
 <20140411061202.GA8321@type>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140411061202.GA8321@type>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 08:12:02AM +0200, Samuel Thibault wrote:
> Hello,
> 
> I'm sorry this went out with a few mistakes.
> 
> Samuel Thibault, le Wed 09 Apr 2014 01:33:06 +0200, a écrit :
> > Dmitry Torokhov, le Tue 08 Apr 2014 01:39:40 -0700, a écrit :
> > > It is not about the VT, I am talking about pure input core. If I
> > > repurpose CapsLock LED for my WiFi indicator I do not want to go into
> > > other programs and teach them that they should stay away from trying to
> > > control this LED.
> > 
> > Err, but even without talking about repurposing Capslock LED for WiFi...
> > How is managed the conflict between the normal capslock behavior and
> > other programs' action on the underlying input device?  I don't think
> > this patch does not introduce the problem.
> 
> I of course meant "I don't think this patch introduces the problem".

The difference in my eyes is that with old interface both players knew
that they would be affecting (and potentially interfering) with the
state of CapsLock LED. With your proposed changes users of old
interfaces have no idea if they are actually toggling CapsLock LED or if
they are affecting something that is no longer a CapsLock LED.

> 
> > How to decide which one to prioritize?
> > 
> > Is it just because console-setup happens to repurpose the capslock LED
> > key that applications should suddenly not have capslock LED control
> > at all?  That's contradictory with the use case you have given.
> 
> Oops, not the use case you have given, but a typical use-case of wanting
> to use a program which does nice things with the capslock LED, and then
> having to teach console-setup not to repurpose the capslock LED.

I believe that applications should be able to control sate of CapsLock
and other LEDs and that the affected LED should not be the physical LED
but rather LED that is currently tied to CapsLock trigger (if any). This
way everything works as is by default and if I decide to have my
physical CapsLock LED to be repurposed for Wifi or HDD activity or
whatever I do not need to teach unrelated applications to stop touching
it.

> 
> > That
> > leads me into believing that we should not try to push a hard rule, and
> > just let the user manage what accesses it.  We could indeed make the VT
> > always take priority, but then that would probably break some existing
> > applications.
> 
> Such as the example above, with the capslock LED.

I am not saying that VT shoudl have priority, I am saying we need to
come up with implementation that does not result in inconsistent
behavior.

Thanks.

-- 
Dmitry
