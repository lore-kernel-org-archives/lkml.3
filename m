Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbaIHO6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:58:34 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56174 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238AbaIHO6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:58:32 -0400
Date: Mon, 8 Sep 2014 15:58:25 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Pavel Machek <pavel@denx.de>
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
Message-ID: <20140908145825.GO12081@leverpostej>
References: <20140828124237.GA29102@fi-ourus-dhcp00977.emea.nsn-net.net>
 <20140828125915.GJ14650@leverpostej>
 <20140828155157.GB23677@roeck-us.net>
 <20140828161025.GO14650@leverpostej>
 <20140828164825.GA12153@roeck-us.net>
 <20140828172842.GF12769@titan.lakedaemon.net>
 <20140828174034.GC15307@roeck-us.net>
 <20140829073413.GN4587@fi-ourus-dhcp00977.emea.nsn-net.net>
 <20140829104001.GB19424@leverpostej>
 <20140908135242.GA21412@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908135242.GA21412@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 02:52:42PM +0100, Pavel Machek wrote:
> Hi!
> 
> > I would suggest we have two properties that describe the resistor's
> > rating and whether or not there is a diode:
> > 
> > trickle-resistor-ohms = <250>
> > diode-connected;
> > 
> > That's easy for a human to write and/or validate, we can easily extend
> > it in future, requires no proliferation of macros, and describes the
> > hardware rather than telling software what to do.
> > 
> > The driver becomes a little more complicated, but gains sanity checking,
> > which is a good thing.
> 
> Certainly looks better than register bit defines.
> 
> As rtc-bq32k has similar options, I'm interested, too. I believe we
> should add
> 
> trickle-charge-enable;
> 
> (we may not want to charge at all), and I believe the diode should be
> 
> disconnect-diode;
> 
> ... With diode connected, charge is slower, and that probably should
> be the default value. We don't want to give too much current in
> default case.  (bq32k has hard-coded resistor value for
> diode/not-diode case).

I agree that if one case is less likely to be problematic / damaging
that should be the default.

Mark.
