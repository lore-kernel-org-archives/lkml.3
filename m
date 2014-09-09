Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbaIILea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:34:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35642 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbaIILe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:34:28 -0400
Date: Tue, 9 Sep 2014 13:34:25 +0200
From: Pavel Machek <pavel@denx.de>
To: Matti Vaittinen <matti.vaittinen@nsn.com>
Cc: ext Mark Rutland <mark.rutland@arm.com>,
        ext Guenter Roeck <linux@roeck-us.net>,
        Jason Cooper <jason@lakedaemon.net>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "arno@natisbad.org" <arno@natisbad.org>,
        "jgunthorpe@obsidianresearch.com" <jgunthorpe@obsidianresearch.com>,
        "san@rosetechnology.dk" <san@rosetechnology.dk>,
        "hs@denx.de" <hs@denx.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Sverdlin Alexander <alexander.sverdlin@nsn.com>
Subject: Re: [PATCH] rtc: ds1307: add trickle charger device tree binding
Message-ID: <20140909113425.GC15404@amd>
References: <20140828155157.GB23677@roeck-us.net>
 <20140828161025.GO14650@leverpostej>
 <20140828164825.GA12153@roeck-us.net>
 <20140828172842.GF12769@titan.lakedaemon.net>
 <20140828174034.GC15307@roeck-us.net>
 <20140829073413.GN4587@fi-ourus-dhcp00977.emea.nsn-net.net>
 <20140829104001.GB19424@leverpostej>
 <20140908135242.GA21412@amd>
 <20140908145825.GO12081@leverpostej>
 <20140909062158.GB21342@fi-ourus-dhcp00977.emea.nsn-net.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909062158.GB21342@fi-ourus-dhcp00977.emea.nsn-net.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > trickle-resistor-ohms = <250>
> > > > diode-connected;
> > > > 
> > > > That's easy for a human to write and/or validate, we can easily extend
> > > > it in future, requires no proliferation of macros, and describes the
> > > > hardware rather than telling software what to do.
> > > > 
> > > > The driver becomes a little more complicated, but gains sanity checking,
> > > > which is a good thing.
> > > 
> > > Certainly looks better than register bit defines.
> > > 
> > > As rtc-bq32k has similar options, I'm interested, too. I believe we
> > > should add
> > > 
> > > trickle-charge-enable;
> 
> I am unsure about this. It makes sense for devices where we cannot
> select resistor but just enable or disable charger. Is there any such
> devices? For devices like ds1339 this makes no sense. For them it is
> simpler to just enable the charger if resistor value is specified, and
> default the charger to be off. But I do not see a problem in supporting
> the trickle-charge-enable; for devices needing this (independently from
> the ds1307 driver).

Ok, just cc me on next version of the driver, and I'll adjust bq32k to
be similar.

> > > (we may not want to charge at all), and I believe the diode should be
> > > 
> > > disconnect-diode;
> > > 
> > > ... With diode connected, charge is slower, and that probably should
> > > be the default value. We don't want to give too much current in
> > > default case.  (bq32k has hard-coded resistor value for
> > > diode/not-diode case).
> > 
> > I agree that if one case is less likely to be problematic / damaging
> > that should be the default.
> 
> _Maybe_ 
> diode-connected = <1>; or 
> diode-connected = <0>; 

That should work.

Actually, make it "connect-diode = <0/1>;", because hardware can
actually select if the diode is connected or not.

> Then one question regarding the "process". Now if I cook up fourth patch
> with inverted diode-connected default for ds1339, should I collect new
> acks for this new patch? (V3 was acked by Alessandro and Jason.) I assume 
> yes.

It depends if patch changed "a lot". I guess you can keep the acks.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
