Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaH1PwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:52:08 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46374 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaH1PwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:52:06 -0400
Date: Thu, 28 Aug 2014 08:51:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Matti Vaittinen <matti.vaittinen@nsn.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
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
Message-ID: <20140828155157.GB23677@roeck-us.net>
References: <20140828124237.GA29102@fi-ourus-dhcp00977.emea.nsn-net.net>
 <20140828125915.GJ14650@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140828125915.GJ14650@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 01:59:15PM +0100, Mark Rutland wrote:
> On Thu, Aug 28, 2014 at 01:42:44PM +0100, Matti Vaittinen wrote:
> > Patch adding support for specifying trickle charger setup from device
> > tree. Patch is based on linux-next tree.
> > 
> > 
> > Some DS13XX devices have "trickle chargers". Introduce a device tree binding
> > for specifying the setup and register values.
> > 
> > Signed-off-by: Matti Vaittinen <matti.vaittinen@nsn.com>
> > ---
> >  .../devicetree/bindings/i2c/trivial-devices.txt    |  1 -
> >  .../devicetree/bindings/rtc/dallas,ds1339.txt      | 19 ++++++++++
> >  drivers/rtc/rtc-ds1307.c                           | 44 ++++++++++++++++++++--
> >  3 files changed, 59 insertions(+), 5 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> > index 6af570e..e9206a4 100644
> > --- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> > +++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> > @@ -35,7 +35,6 @@ catalyst,24c32		i2c serial eeprom
> >  cirrus,cs42l51		Cirrus Logic CS42L51 audio codec
> >  dallas,ds1307		64 x 8, Serial, I2C Real-Time Clock
> >  dallas,ds1338		I2C RTC with 56-Byte NV RAM
> > -dallas,ds1339		I2C Serial Real-Time Clock
> >  dallas,ds1340		I2C RTC with Trickle Charger
> >  dallas,ds1374		I2C, 32-Bit Binary Counter Watchdog RTC with Trickle Charger and Reset Input/Output
> >  dallas,ds1631		High-Precision Digital Thermometer
> > diff --git a/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt b/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
> > new file mode 100644
> > index 0000000..9faf40e
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
> > @@ -0,0 +1,19 @@
> > +* Dallas DS1339		I2C Serial Real-Time Clock
> > +
> > +Required properties:
> > +- compatible: Should contain "dallas,ds1339".
> > +- reg: I2C address for chip
> > +
> > +Optional properties:
> > +- trickle_setup : Used Trickle Charger configuration,
> > +        corresponding to 5 lowest bits in trickle charger register.
> 
The value is provided via platform data, so it is platform specific
and presumably needs to be configurable. I did, however, not find
a single in-kernel driver which is actually setting it.
So this is a good question.

> s/_/-/ in property names please.
> 
> What do these bits do? is there any documentation available?
> 
> Why do they need to be in the DT?
> 
> Why do we not have a higher-level description?
> 
> > +- trickle_reg   : Trickle charger register address. Defaults to 0x10 for ds1339.
> 
> Is this expected to change? Why does this need to be in the DT?
> 
A quick look into the code suggests that this is a chip specific register,
and the register address is set by the driver depending on the chip type.
I don't think it should be configurable via dt.

Guenter
