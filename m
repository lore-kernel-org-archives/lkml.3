Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaFNW0b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 18:26:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46982 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaFNW0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 18:26:30 -0400
Date: Sun, 15 Jun 2014 00:26:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Nishanth Menon <nm@ti.com>, dbaryshkov@gmail.com,
        Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        dwmw2@infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 2/2] power: twl4030_charger: attempt to power off in
 case of critical events
Message-ID: <20140614222606.GB1389@xo-6d-61-c0.localdomain>
References: <1401313610-14252-1-git-send-email-nm@ti.com>
 <1401313610-14252-3-git-send-email-nm@ti.com>
 <CANOLnOPb1xbqb5WXaK5-kdCezVuDhNxTtE5VV_MbCi4WTd2=oA@mail.gmail.com>
 <538F18B6.7070102@ti.com>
 <CANOLnOMbjpLd2mGcTRcR-+jcp80H1z7g4-eZ6yMJvovEB2__RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANOLnOMbjpLd2mGcTRcR-+jcp80H1z7g4-eZ6yMJvovEB2__RQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-06-05 01:30:40, Grazvydas Ignotas wrote:
> On Wed, Jun 4, 2014 at 4:01 PM, Nishanth Menon <nm@ti.com> wrote:
> > On 06/04/2014 05:04 AM, Grazvydas Ignotas wrote:
> >> On Thu, May 29, 2014 at 12:46 AM, Nishanth Menon <nm@ti.com> wrote:
> >> often while charging on hot summer day. I'd prefer my pandora to not
> >> shutdown in such case, it could just stop charging instead.
> > Yeah, We could call
> >   twl4030_charger_enable_ac(false);
> >   twl4030_charger_enable_usb(bci, false);
> >
> > But then, is that sufficient?
> > From the TRM:
> > 7.5.8 Battery Temperature Out-of-Range Detection
> > Battery temperature out-of-range detection detects whether the battery
> > temperature is within a specific
> > range. Detection is possible for two temperature ranges. When the
> > battery temperature is not in the
> > 2???50°C range or is in the 3???43°C range, the TBATOR1 and TBATOR2 status
> > bits rise and an interrupt is
> > generated.
> > This MADC monitoring function can be enabled by writing to the
> > TBATOR1EN (BCIMFEN2[3]) and
> > TBATOR2EN (BCIMFEN2[1]) fields.
> >
> > Battery pack at high temperature is a risk, no? and it may not be just
> > charger that might be causing such a condition. Is'nt it safer to shut
> > the device down in such a case?
> 
> I don't know, so far nobody has complained about the battery exploding
> and anybody getting hurt, but it would make the device unusable for
> people in hot climates. From what I remember the automatic charge is
> stopped automatically on this condition, as some people complained
> they couldn't charge their device and saw these messages in dmesg. I
> guess mainline could choose the safer option and shutdown, no strong
> opinion about this.

Li-ions have strong casing -- battery will not explode, just will grow a bit. And
50C will probably not make it explode immediately, just shorten its life a lot.

If your battery is close enough to CPU (for example), it should be something else
that heats it up. I think that shutdown by default is a good idea.

If particular hardware triggers this a lot _and_ there are no components (CPU, hdd) 
heating the battery, you may want to just stop charging... but do it per-machine
...

Actually, you probably want to stop charging at 37C or so, to stop triggering this...

										Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
