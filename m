Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbaIWULm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 16:11:42 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64654 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751735AbaIWULk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 16:11:40 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Aaron Lu <aaron.lu@intel.com>
Subject: Re: [RFC PATCH v2 07/16] gpio: Add support for unified device properties interface
Date: Tue, 23 Sep 2014 22:31:27 +0200
Message-ID: <2531965.8yTKWbxWX4@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140923161724.GA40700@core.coreip.homeip.net>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <20140923155202.GT1786@lahna.fi.intel.com> <20140923161724.GA40700@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 23, 2014 09:17:24 AM Dmitry Torokhov wrote:
> On Tue, Sep 23, 2014 at 06:52:02PM +0300, Mika Westerberg wrote:
> > On Tue, Sep 23, 2014 at 05:45:57PM +0200, Arnd Bergmann wrote:
> > > On Tuesday 23 September 2014 17:25:50 Linus Walleij wrote:
> > > > On Tue, Sep 16, 2014 at 1:52 PM, Mika Westerberg
> > > > <mika.westerberg@linux.intel.com> wrote:
> > > > 
> > > > > Some drivers need to deal with only firmware representation of its
> > > > > GPIOs. An example would be a GPIO button array driver where each button
> > > > > is described as a separate firmware node in device tree. Typically these
> > > > > child nodes do not have physical representation in the Linux device
> > > > > model.
> > > > >
> > > > > In order to help device drivers to handle such firmware child nodes we
> > > > > add dev[m]_node_get_named_gpiod() that takes a firmware node pointer as
> > > > > parameter, finds the GPIO using whatever is the underlying firmware
> > > > > method, and requests the GPIO properly.
> > > > >
> > > > > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > > 
> > > > I have a hard time figuring out if this is what we want for common
> > > > accessors between DT and ACPI.
> > > > 
> > > > Can I get some input from Grant, Arnd, Mark, Darren...?
> > > 
> > > I just took a brief look at this. My first impression is that the
> > > fw_dev_node structure is weird when all callers just do (in patch 2)
> > > 
> > > +	struct fw_dev_node fdn = {
> > > +		.of_node = dev->of_node,
> > > +		.acpi_node = ACPI_COMPANION(dev),
> > > +	};
> > > 
> > > I'd much rather see an interface that passes the 'struct device'
> > > pointer down to dev_get_named_gpiod() and all other exported
> > > functions, and then internally does the conversion at the point
> > > where the access is done.
> > 
> > Problem is that if you don't have the dev pointer in the first place.
> > Please look how leds-gpio.c or gpio_keys_polled.c are using this.
> > 
> > Of course you have the first level device but when you need to iterate
> > "leds" or "buttons" below where there is no Linux device available we
> > need something like this.
> 
> Maybe we should be passing the parent/owner device to the iterator
> functions?

Yes, we can do that.  That's one alternative for what we have in the current
set.

Rafael

