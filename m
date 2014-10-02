Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaJBMPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:15:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:11265 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbaJBMPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:15:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,638,1406617200"; 
   d="scan'208";a="612073775"
Date: Thu, 2 Oct 2014 15:15:08 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 04/15] ACPI: Document ACPI device specific properties
Message-ID: <20141002121508.GM1786@lahna.fi.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <1979325.jM0BQzDCTX@wuerfel>
 <20141002104123.GJ1786@lahna.fi.intel.com>
 <2466832.0XJezjdvYs@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2466832.0XJezjdvYs@wuerfel>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 01:51:24PM +0200, Arnd Bergmann wrote:
> On Thursday 02 October 2014 13:41:23 Mika Westerberg wrote:
> > On Wed, Oct 01, 2014 at 09:59:14AM +0200, Arnd Bergmann wrote:
> > > On Wednesday 01 October 2014 04:11:20 Rafael J. Wysocki wrote:
> > > > From: Mika Westerberg <mika.westerberg@linux.intel.com>
> > 
> > > > +The referenced ACPI device is returned in args->adev if found.
> > > > +
> > > > +In addition to simple object references it is also possible to have object
> > > > +references with arguments. These are represented in ASL as follows:
> > > > +
> > > > +	Device (\_SB.PCI0.PWM)
> > > > +	{
> > > > +		Name (_DSD, Package () {
> > > > +			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> > > > +			Package () {
> > > > +				Package () {"#pwm-cells", 2}
> > > > +			}
> > > > +		})
> > > > +	}
> > > > +
> > > 
> > > Similarly, the "#foo-cells" syntax is an artifact of the limitations of the
> > > DT syntax, and I'd assume there would be a better way to encode this
> > > in ACPI. Also, a "cell" in Open Firmware is defined as a big-endian
> > > 32-bit value, which doesn't directly correspond to something in ACPI,
> > > and the '#' character is an artifact of the use of the Forth language
> > > in Open Firmware, which you also don't have here.
> > 
> > Same here, we tried to make it follow closely the DT description. It is
> > probably not the best/optimal encoding for ACPI but it is documented
> > well in Documentation/devicetree/bindings so why not use it.
> > 
> > The summary email from Darren at KS also mentions that for the existing
> > drivers, the existing schemas should be common for both implementations [1].
> > 
> > For new bindings we probably should look out if they can be better
> > represented using ACPI types.
> > 
> > [1] http://lwn.net/Articles/609373/
> 
> I thought when we had discussed the subsystem specific bindings, the
> consensus there was to have subsystem specific accessors and
> properties/tables.
> 
> I would argue that for everything that ACPI already has (interrupts,
> registers, gpio, dmaengine, ...) the native method should be used,
> possibly using _DSD to provide naming for otherwise anonymous references.

Absolutely. That's precisely what we do in the GPIO patch of this
series. E.g we use ACPI GpioIo/GpioInt _CRS resources but give name to
the GPIOs with the help of _DSD.

For things that don't have correspondence in ACPI but have well defined
existing DT schema, like PWMs, we should follow that.
