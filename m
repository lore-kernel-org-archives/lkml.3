Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaH1R3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 13:29:01 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:60821 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751244AbaH1R27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 13:28:59 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18L0kCQrDxEhHaqEIkn80qI6vX9l8CD31Y=
X-DKIM: OpenDKIM Filter v2.0.1 titan 2C87B5D1B75
Date: Thu, 28 Aug 2014 13:28:42 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Matti Vaittinen <matti.vaittinen@nsn.com>,
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
Message-ID: <20140828172842.GF12769@titan.lakedaemon.net>
References: <20140828124237.GA29102@fi-ourus-dhcp00977.emea.nsn-net.net>
 <20140828125915.GJ14650@leverpostej>
 <20140828155157.GB23677@roeck-us.net>
 <20140828161025.GO14650@leverpostej>
 <20140828164825.GA12153@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140828164825.GA12153@roeck-us.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 09:48:25AM -0700, Guenter Roeck wrote:
> On Thu, Aug 28, 2014 at 05:10:25PM +0100, Mark Rutland wrote:
> > On Thu, Aug 28, 2014 at 04:51:57PM +0100, Guenter Roeck wrote:
> > > On Thu, Aug 28, 2014 at 01:59:15PM +0100, Mark Rutland wrote:
> > > > On Thu, Aug 28, 2014 at 01:42:44PM +0100, Matti Vaittinen wrote:
> > > > > Patch adding support for specifying trickle charger setup from device
> > > > > tree. Patch is based on linux-next tree.
> > > > > 
> > > > > 
> > > > > Some DS13XX devices have "trickle chargers". Introduce a device tree binding
> > > > > for specifying the setup and register values.
> > > > > 
> > > > > Signed-off-by: Matti Vaittinen <matti.vaittinen@nsn.com>
> > > > > ---
> > > > >  .../devicetree/bindings/i2c/trivial-devices.txt    |  1 -
> > > > >  .../devicetree/bindings/rtc/dallas,ds1339.txt      | 19 ++++++++++
> > > > >  drivers/rtc/rtc-ds1307.c                           | 44 ++++++++++++++++++++--
> > > > >  3 files changed, 59 insertions(+), 5 deletions(-)
> > > > >  create mode 100644 Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
> > > > > 
> > > > > diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> > > > > index 6af570e..e9206a4 100644
> > > > > --- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> > > > > +++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> > > > > @@ -35,7 +35,6 @@ catalyst,24c32		i2c serial eeprom
> > > > >  cirrus,cs42l51		Cirrus Logic CS42L51 audio codec
> > > > >  dallas,ds1307		64 x 8, Serial, I2C Real-Time Clock
> > > > >  dallas,ds1338		I2C RTC with 56-Byte NV RAM
> > > > > -dallas,ds1339		I2C Serial Real-Time Clock
> > > > >  dallas,ds1340		I2C RTC with Trickle Charger
> > > > >  dallas,ds1374		I2C, 32-Bit Binary Counter Watchdog RTC with Trickle Charger and Reset Input/Output
> > > > >  dallas,ds1631		High-Precision Digital Thermometer
> > > > > diff --git a/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt b/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
> > > > > new file mode 100644
> > > > > index 0000000..9faf40e
> > > > > --- /dev/null
> > > > > +++ b/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
> > > > > @@ -0,0 +1,19 @@
> > > > > +* Dallas DS1339		I2C Serial Real-Time Clock
> > > > > +
> > > > > +Required properties:
> > > > > +- compatible: Should contain "dallas,ds1339".
> > > > > +- reg: I2C address for chip
> > > > > +
> > > > > +Optional properties:
> > > > > +- trickle_setup : Used Trickle Charger configuration,
> > > > > +        corresponding to 5 lowest bits in trickle charger register.
> > > > 
> > > The value is provided via platform data, so it is platform specific
> > > and presumably needs to be configurable. I did, however, not find
> > > a single in-kernel driver which is actually setting it.
> > > So this is a good question.
> > 
> > I'm uncomfortable adding a field we don't understand to DT.
> > 
> > Is there any publicly-available documentation for the device?
> > 
> 
> Lots ;-)
> 
> http://datasheets.maximintegrated.com/en/ds/DS1307.pdf
> http://datasheets.maximintegrated.com/en/ds/DS1337.pdf
> http://datasheets.maximintegrated.com/en/ds/DS1338.pdf
> http://datasheets.maximintegrated.com/en/ds/DS1339.pdf
> http://datasheets.maximintegrated.com/en/ds/DS1340.pdf
> http://datasheets.maximintegrated.com/en/ds/DS1388.pdf
> http://datasheets.maximintegrated.com/en/ds/DS3231.pdf
> 
> Code suggests that DS1339, DS1339, and DS1340 have the register.
> 
> Looking into the datasheets, the configuration consists of two parts:
> - diode connected or not
> - trickle charger resistor value (250, 2000, or 4000 ohm)
> 
> Given that, it seems to me that those values should be configured
> explicitly instead of using a binary value, and that the driver
> should perform the conversion from dt entry to register value.

iiuc, there is no way for the kernel to determine what is being trickle
charged, and thus no way to determine how it should set this register.

It may be a bit of overkill, but I think a DT macro would be the most
maintainable solution here:

#define DS1339_TRCKL_DIODE   0x08
#define DS1339_TRCKL_NODIODE 0x04
#define DS1339_TRCKL_R250    0x01
#define DS1339_TRCKL_R2000   0x02
#define DS1339_TRCKL_R4000   0x03

trickle_setup = <DS1339_TRCKL_DIODE | DS1339_TRCKL_R250>;

And the driver would take care of oring it with the enable pattern.

thx,

Jason.
