Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbaJCX40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:56:26 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58890 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759235AbaJCX4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 19:56:24 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 04/15] ACPI: Document ACPI device specific properties
Date: Sat, 04 Oct 2014 02:16:24 +0200
Message-ID: <9976166.0Y4SbhjXQK@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141003134849.GL26643@leverpostej>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <20141002121508.GM1786@lahna.fi.intel.com> <20141003134849.GL26643@leverpostej>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 03, 2014 02:48:49 PM Mark Rutland wrote:
> On Thu, Oct 02, 2014 at 01:15:08PM +0100, Mika Westerberg wrote:
> > On Thu, Oct 02, 2014 at 01:51:24PM +0200, Arnd Bergmann wrote:
> > > On Thursday 02 October 2014 13:41:23 Mika Westerberg wrote:
> > > > On Wed, Oct 01, 2014 at 09:59:14AM +0200, Arnd Bergmann wrote:
> > > > > On Wednesday 01 October 2014 04:11:20 Rafael J. Wysocki wrote:
> > > > > > From: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > > 
> > > > > > +The referenced ACPI device is returned in args->adev if found.
> > > > > > +
> > > > > > +In addition to simple object references it is also possible to have object
> > > > > > +references with arguments. These are represented in ASL as follows:
> > > > > > +
> > > > > > +	Device (\_SB.PCI0.PWM)
> > > > > > +	{
> > > > > > +		Name (_DSD, Package () {
> > > > > > +			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > > > > > +			Package () {
> > > > > > +				Package () {"#pwm-cells", 2}
> > > > > > +			}
> > > > > > +		})
> > > > > > +	}
> > > > > > +
> > > > > 
> > > > > Similarly, the "#foo-cells" syntax is an artifact of the limitations of the
> > > > > DT syntax, and I'd assume there would be a better way to encode this
> > > > > in ACPI. Also, a "cell" in Open Firmware is defined as a big-endian
> > > > > 32-bit value, which doesn't directly correspond to something in ACPI,
> > > > > and the '#' character is an artifact of the use of the Forth language
> > > > > in Open Firmware, which you also don't have here.
> > > > 
> > > > Same here, we tried to make it follow closely the DT description. It is
> > > > probably not the best/optimal encoding for ACPI but it is documented
> > > > well in Documentation/devicetree/bindings so why not use it.
> > > > 
> > > > The summary email from Darren at KS also mentions that for the existing
> > > > drivers, the existing schemas should be common for both implementations [1].
> > > > 
> > > > For new bindings we probably should look out if they can be better
> > > > represented using ACPI types.
> > > > 
> > > > [1] http://lwn.net/Articles/609373/
> > > 
> > > I thought when we had discussed the subsystem specific bindings, the
> > > consensus there was to have subsystem specific accessors and
> > > properties/tables.
> > > 
> > > I would argue that for everything that ACPI already has (interrupts,
> > > registers, gpio, dmaengine, ...) the native method should be used,
> > > possibly using _DSD to provide naming for otherwise anonymous references.
> > 
> > Absolutely. That's precisely what we do in the GPIO patch of this
> > series. E.g we use ACPI GpioIo/GpioInt _CRS resources but give name to
> > the GPIOs with the help of _DSD.
> > 
> > For things that don't have correspondence in ACPI but have well defined
> > existing DT schema, like PWMs, we should follow that.
> 
> I'm rather concerned that while that's expedient for us, that's going to
> end up in the creation of Linux-only ACPI tables. If any other OS vendor
> decides they need to model this information and doesn't wnat to pick up
> Linux _DSD bindings, what happens if they try to get an explicit object
> model defined in ACPI for those objects?

That depends on whether or not systems with that model show up in the market.
If they do, we will do our best to support them.

We do that for Apple already as much as we practically can.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
