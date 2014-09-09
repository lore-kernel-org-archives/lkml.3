Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbaIIFSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 01:18:46 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:47811 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaIIFSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 01:18:44 -0400
Date: Tue, 9 Sep 2014 09:22:06 +0300
From: Matti Vaittinen <matti.vaittinen@nsn.com>
To: ext Mark Rutland <mark.rutland@arm.com>
Cc: Pavel Machek <pavel@denx.de>, ext Guenter Roeck <linux@roeck-us.net>,
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
Message-ID: <20140909062158.GB21342@fi-ourus-dhcp00977.emea.nsn-net.net>
References: <20140828125915.GJ14650@leverpostej>
 <20140828155157.GB23677@roeck-us.net>
 <20140828161025.GO14650@leverpostej>
 <20140828164825.GA12153@roeck-us.net>
 <20140828172842.GF12769@titan.lakedaemon.net>
 <20140828174034.GC15307@roeck-us.net>
 <20140829073413.GN4587@fi-ourus-dhcp00977.emea.nsn-net.net>
 <20140829104001.GB19424@leverpostej>
 <20140908135242.GA21412@amd>
 <20140908145825.GO12081@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908145825.GO12081@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 2438
X-purgate-ID: 151667::1410239877-00002A30-EBEE8CC2/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 03:58:25PM +0100, ext Mark Rutland wrote:
> On Mon, Sep 08, 2014 at 02:52:42PM +0100, Pavel Machek wrote:
> > > I would suggest we have two properties that describe the resistor's
> > > rating and whether or not there is a diode:
> > > 
> > > trickle-resistor-ohms = <250>
> > > diode-connected;
> > > 
> > > That's easy for a human to write and/or validate, we can easily extend
> > > it in future, requires no proliferation of macros, and describes the
> > > hardware rather than telling software what to do.
> > > 
> > > The driver becomes a little more complicated, but gains sanity checking,
> > > which is a good thing.
> > 
> > Certainly looks better than register bit defines.
> > 
> > As rtc-bq32k has similar options, I'm interested, too. I believe we
> > should add
> > 
> > trickle-charge-enable;

I am unsure about this. It makes sense for devices where we cannot
select resistor but just enable or disable charger. Is there any such
devices? For devices like ds1339 this makes no sense. For them it is
simpler to just enable the charger if resistor value is specified, and
default the charger to be off. But I do not see a problem in supporting
the trickle-charge-enable; for devices needing this (independently from
the ds1307 driver).

> > 
> > (we may not want to charge at all), and I believe the diode should be
> > 
> > disconnect-diode;
> > 
> > ... With diode connected, charge is slower, and that probably should
> > be the default value. We don't want to give too much current in
> > default case.  (bq32k has hard-coded resistor value for
> > diode/not-diode case).
> 
> I agree that if one case is less likely to be problematic / damaging
> that should be the default.

_Maybe_ 
diode-connected = <1>; or 
diode-connected = <0>; 
or both
diode-connected; and 
diode-disconnected;
could be used and let the driver to choose the defaults? But yes, I have
no problem with inverting the default to be diode-connected.

Then one question regarding the "process". Now if I cook up fourth patch
with inverted diode-connected default for ds1339, should I collect new
acks for this new patch? (V3 was acked by Alessandro and Jason.) I assume 
yes.

> 
> Mark.

-- 
=============================================

Matti Vaittinen
Senile SW Specialist
FINLAND 

~~ When things go utterly wrong vim users can always type :help! ~~

