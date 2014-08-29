Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbaH2MZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 08:25:15 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:36690 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaH2MZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 08:25:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19bxP7/iqorQf+fJG/9SBvvXTA+8sjwn4M=
X-DKIM: OpenDKIM Filter v2.0.1 titan CBDE05D2548
Date: Fri, 29 Aug 2014 08:24:52 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Matti Vaittinen <matti.vaittinen@nsn.com>,
        ext Guenter Roeck <linux@roeck-us.net>,
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
Message-ID: <20140829122452.GA3683@titan.lakedaemon.net>
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
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 11:40:02AM +0100, Mark Rutland wrote:
> On Fri, Aug 29, 2014 at 08:34:25AM +0100, Matti Vaittinen wrote:
> > On Thu, Aug 28, 2014 at 10:40:34AM -0700, ext Guenter Roeck wrote:
> > > On Thu, Aug 28, 2014 at 01:28:42PM -0400, Jason Cooper wrote:
> > > > On Thu, Aug 28, 2014 at 09:48:25AM -0700, Guenter Roeck wrote:
> > > > > On Thu, Aug 28, 2014 at 05:10:25PM +0100, Mark Rutland wrote:
> > > > > > On Thu, Aug 28, 2014 at 04:51:57PM +0100, Guenter Roeck wrote:
> > > > > > > On Thu, Aug 28, 2014 at 01:59:15PM +0100, Mark Rutland wrote:
> > > > > > > > On Thu, Aug 28, 2014 at 01:42:44PM +0100, Matti Vaittinen wrote:
> > > > > > > > > Patch adding support for specifying trickle charger setup from device
> > > > > > > > > tree. Patch is based on linux-next tree.
> > > > > > > > > 
> > > > > > > > > 
> > > > > > > > > Some DS13XX devices have "trickle chargers". Introduce a device tree binding
> > > > > > > > > for specifying the setup and register values.
> > > > > > > > > 
> > > > > > > > > +++ b/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
> > > > > > > > > @@ -0,0 +1,19 @@
> > > > > > > > > +* Dallas DS1339		I2C Serial Real-Time Clock
> > > > > > > > > +
> > > > > > > > > +Required properties:
> > > > > > > > > +- compatible: Should contain "dallas,ds1339".
> > > > > > > > > +- reg: I2C address for chip
> > > > > > > > > +
> > > > > > > > > +Optional properties:
> > > > > > > > > +- trickle_setup : Used Trickle Charger configuration,
> > > > > > > > > +        corresponding to 5 lowest bits in trickle charger register.
> > > > > > > > 
> > > > > > > The value is provided via platform data, so it is platform specific
> > > > > > > and presumably needs to be configurable. I did, however, not find
> > > > > > > a single in-kernel driver which is actually setting it.
> > > > > > > So this is a good question.
> > > > > > 
> > > > > > I'm uncomfortable adding a field we don't understand to DT.
> > > > > > 
> > > > > > Is there any publicly-available documentation for the device?
> > > > > > 
> > > > > 
> > > > > Lots ;-)
> > > > > 
> > > > > http://datasheets.maximintegrated.com/en/ds/DS1307.pdf
> > > > > http://datasheets.maximintegrated.com/en/ds/DS1337.pdf
> > > > > http://datasheets.maximintegrated.com/en/ds/DS1338.pdf
> > > > > http://datasheets.maximintegrated.com/en/ds/DS1339.pdf
> > > > > http://datasheets.maximintegrated.com/en/ds/DS1340.pdf
> > > > > http://datasheets.maximintegrated.com/en/ds/DS1388.pdf
> > > > > http://datasheets.maximintegrated.com/en/ds/DS3231.pdf
> > > > > 
> > > > > Code suggests that DS1339, DS1339, and DS1340 have the register.
> > > > > 
> > > > > Looking into the datasheets, the configuration consists of two parts:
> > > > > - diode connected or not
> > > > > - trickle charger resistor value (250, 2000, or 4000 ohm)
> > > > > 
> > > > > Given that, it seems to me that those values should be configured
> > > > > explicitly instead of using a binary value, and that the driver
> > > > > should perform the conversion from dt entry to register value.
> > > > 
> > > > iiuc, there is no way for the kernel to determine what is being trickle
> > > > charged, and thus no way to determine how it should set this register.
> > > > 
> > > > It may be a bit of overkill, but I think a DT macro would be the most
> > > > maintainable solution here:
> > > > 
> > > > #define DS1339_TRCKL_DIODE   0x08
> > > > #define DS1339_TRCKL_NODIODE 0x04
> > > > #define DS1339_TRCKL_R250    0x01
> > > > #define DS1339_TRCKL_R2000   0x02
> > > > #define DS1339_TRCKL_R4000   0x03
> > > > 
> > > > trickle_setup = <DS1339_TRCKL_DIODE | DS1339_TRCKL_R250>;
> > > > 
> > > > And the driver would take care of oring it with the enable pattern.
> > > > 
> > > 
> > > Yes, that sounds reasonable as well.
> > > 
> > I thought of this too. However the ds1307 seems to be designed to work
> > with bunch of chips. What then when next chip supported by this driver
> > introduces 75, 1000 and 5000 ohm resistors? Or something else. (Or add
> > some other configuration). I do not see this approach to be
> > maintainable in long run.
> 
> If a new chip comes out with new features, the driver will need an
> update anyhow. We have no guarantee that the register placement will be
> the same, let alone the layout.

Yes, I'm reminded of our conversations a year ago in Edinburgh.  It's
impossible to engineer a perfect, future-proof binding.  But that
being said...

> If and when said new chip comes out we allocate a new compatible string.
> If it's compatible iwith (i.e. is a superset of) an existing device's
> programming model, we add that existing string as a fallback in the
> compatible list so old kernels can drive the subset of features they
> understand.
> 
> > I see strong possibility of polluting dt with endless amount of
> > defines. Furthermore I believe the benefits of these defines would be
> > negligible compared to effort maintaining defines and documentation of
> > them causes. Surely the one who needs to add dt node for this chip in
> > his board's dt has the manual for the chip he has on board. Especially
> > so if he knows the trickle charger there and wants to configure it.
> > The plain resistor type still gives zero information without knowing
> > the other details.
> 
> I would rather that the driver had some idea of what it were doing
> rather than being a glorified copy routine.
> 
> I would suggest we have two properties that describe the resistor's
> rating and whether or not there is a diode:
> 
> trickle-resistor-ohms = <250>
> diode-connected;

I much prefer this solution over my own suggestion.  With one small
change, s/diode-connected/trickle-diode-enable/  Does that sound ok?

> That's easy for a human to write and/or validate, we can easily extend
> it in future, requires no proliferation of macros, and describes the
> hardware rather than telling software what to do.
> 
> The driver becomes a little more complicated, but gains sanity checking,
> which is a good thing.
> 
> I'm still worried that we have no idea what the device is intended to
> charge. Surely that's important?

In the docs it said a variety of batteries and supercaps.  Yeah, not
much help...

thx,

Jason.
