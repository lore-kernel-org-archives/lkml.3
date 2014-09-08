Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaIHNwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:52:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56539 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbaIHNwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:52:45 -0400
Date: Mon, 8 Sep 2014 15:52:42 +0200
From: Pavel Machek <pavel@denx.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Matti Vaittinen <matti.vaittinen@nsn.com>,
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
Message-ID: <20140908135242.GA21412@amd>
References: <20140828124237.GA29102@fi-ourus-dhcp00977.emea.nsn-net.net>
 <20140828125915.GJ14650@leverpostej>
 <20140828155157.GB23677@roeck-us.net>
 <20140828161025.GO14650@leverpostej>
 <20140828164825.GA12153@roeck-us.net>
 <20140828172842.GF12769@titan.lakedaemon.net>
 <20140828174034.GC15307@roeck-us.net>
 <20140829073413.GN4587@fi-ourus-dhcp00977.emea.nsn-net.net>
 <20140829104001.GB19424@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140829104001.GB19424@leverpostej>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I would suggest we have two properties that describe the resistor's
> rating and whether or not there is a diode:
> 
> trickle-resistor-ohms = <250>
> diode-connected;
> 
> That's easy for a human to write and/or validate, we can easily extend
> it in future, requires no proliferation of macros, and describes the
> hardware rather than telling software what to do.
> 
> The driver becomes a little more complicated, but gains sanity checking,
> which is a good thing.

Certainly looks better than register bit defines.

As rtc-bq32k has similar options, I'm interested, too. I believe we
should add

trickle-charge-enable;

(we may not want to charge at all), and I believe the diode should be

disconnect-diode;

... With diode connected, charge is slower, and that probably should
be the default value. We don't want to give too much current in
default case.  (bq32k has hard-coded resistor value for
diode/not-diode case).

Thanks and best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
