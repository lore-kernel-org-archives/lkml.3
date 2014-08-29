Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaH2Gnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 02:43:55 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:52054 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaH2Gnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 02:43:53 -0400
Date: Fri, 29 Aug 2014 10:34:25 +0300
From: Matti Vaittinen <matti.vaittinen@nsn.com>
To: ext Guenter Roeck <linux@roeck-us.net>
Cc: Jason Cooper <jason@lakedaemon.net>, Mark Rutland <mark.rutland@arm.com>,
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
Message-ID: <20140829073413.GN4587@fi-ourus-dhcp00977.emea.nsn-net.net>
References: <20140828124237.GA29102@fi-ourus-dhcp00977.emea.nsn-net.net>
 <20140828125915.GJ14650@leverpostej>
 <20140828155157.GB23677@roeck-us.net>
 <20140828161025.GO14650@leverpostej>
 <20140828164825.GA12153@roeck-us.net>
 <20140828172842.GF12769@titan.lakedaemon.net>
 <20140828174034.GC15307@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140828174034.GC15307@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 4436
X-purgate-ID: 151667::1409293793-0000061C-8D63229D/0/0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 10:40:34AM -0700, ext Guenter Roeck wrote:
> On Thu, Aug 28, 2014 at 01:28:42PM -0400, Jason Cooper wrote:
> > On Thu, Aug 28, 2014 at 09:48:25AM -0700, Guenter Roeck wrote:
> > > On Thu, Aug 28, 2014 at 05:10:25PM +0100, Mark Rutland wrote:
> > > > On Thu, Aug 28, 2014 at 04:51:57PM +0100, Guenter Roeck wrote:
> > > > > On Thu, Aug 28, 2014 at 01:59:15PM +0100, Mark Rutland wrote:
> > > > > > On Thu, Aug 28, 2014 at 01:42:44PM +0100, Matti Vaittinen wrote:
> > > > > > > Patch adding support for specifying trickle charger setup from device
> > > > > > > tree. Patch is based on linux-next tree.
> > > > > > > 
> > > > > > > 
> > > > > > > Some DS13XX devices have "trickle chargers". Introduce a device tree binding
> > > > > > > for specifying the setup and register values.
> > > > > > > 
> > > > > > > +++ b/Documentation/devicetree/bindings/rtc/dallas,ds1339.txt
> > > > > > > @@ -0,0 +1,19 @@
> > > > > > > +* Dallas DS1339		I2C Serial Real-Time Clock
> > > > > > > +
> > > > > > > +Required properties:
> > > > > > > +- compatible: Should contain "dallas,ds1339".
> > > > > > > +- reg: I2C address for chip
> > > > > > > +
> > > > > > > +Optional properties:
> > > > > > > +- trickle_setup : Used Trickle Charger configuration,
> > > > > > > +        corresponding to 5 lowest bits in trickle charger register.
> > > > > > 
> > > > > The value is provided via platform data, so it is platform specific
> > > > > and presumably needs to be configurable. I did, however, not find
> > > > > a single in-kernel driver which is actually setting it.
> > > > > So this is a good question.
> > > > 
> > > > I'm uncomfortable adding a field we don't understand to DT.
> > > > 
> > > > Is there any publicly-available documentation for the device?
> > > > 
> > > 
> > > Lots ;-)
> > > 
> > > http://datasheets.maximintegrated.com/en/ds/DS1307.pdf
> > > http://datasheets.maximintegrated.com/en/ds/DS1337.pdf
> > > http://datasheets.maximintegrated.com/en/ds/DS1338.pdf
> > > http://datasheets.maximintegrated.com/en/ds/DS1339.pdf
> > > http://datasheets.maximintegrated.com/en/ds/DS1340.pdf
> > > http://datasheets.maximintegrated.com/en/ds/DS1388.pdf
> > > http://datasheets.maximintegrated.com/en/ds/DS3231.pdf
> > > 
> > > Code suggests that DS1339, DS1339, and DS1340 have the register.
> > > 
> > > Looking into the datasheets, the configuration consists of two parts:
> > > - diode connected or not
> > > - trickle charger resistor value (250, 2000, or 4000 ohm)
> > > 
> > > Given that, it seems to me that those values should be configured
> > > explicitly instead of using a binary value, and that the driver
> > > should perform the conversion from dt entry to register value.
> > 
> > iiuc, there is no way for the kernel to determine what is being trickle
> > charged, and thus no way to determine how it should set this register.
> > 
> > It may be a bit of overkill, but I think a DT macro would be the most
> > maintainable solution here:
> > 
> > #define DS1339_TRCKL_DIODE   0x08
> > #define DS1339_TRCKL_NODIODE 0x04
> > #define DS1339_TRCKL_R250    0x01
> > #define DS1339_TRCKL_R2000   0x02
> > #define DS1339_TRCKL_R4000   0x03
> > 
> > trickle_setup = <DS1339_TRCKL_DIODE | DS1339_TRCKL_R250>;
> > 
> > And the driver would take care of oring it with the enable pattern.
> > 
> 
> Yes, that sounds reasonable as well.
> 
I thought of this too. However the ds1307 seems to be designed to work
with bunch of chips. What then when next chip supported by this driver
introduces 75, 1000 and 5000 ohm resistors? Or something else. (Or add
some other configuration). I do not see this approach to be maintainable
in long run. I see strong possibility of polluting dt with endless 
amount of defines. Furthermore I believe the benefits of these defines
would be negligible compared to effort maintaining defines and
documentation of them causes. Surely the one who needs to add dt node
for this chip in his board's dt has the manual for the chip he has on
board. Especially so if he knows the trickle charger there and wants to
configure it. The plain resistor type still gives zero information
without knowing the other details.

-- 
=============================================

Matti Vaittinen
Senile SW Specialist
FINLAND 

~~ When things go utterly wrong vim users can always type :help! ~~

