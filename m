Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab3IRPit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:38:49 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34258 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751657Ab3IRPir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:38:47 -0400
Date: Wed, 18 Sep 2013 16:38:28 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [RFC PATCH 5/6] extcon-gpio: Describe devicetree bindings
Message-ID: <20130918153828.GB17453@e106331-lin.cambridge.arm.com>
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
 <1377836978-24082-6-git-send-email-linux@roeck-us.net>
 <20130912164100.GF22013@e106331-lin.cambridge.arm.com>
 <20130912165304.GA12202@roeck-us.net>
 <20130916142147.GF30650@e106331-lin.cambridge.arm.com>
 <20130916151953.GA5801@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916151953.GA5801@roeck-us.net>
Thread-Topic: [RFC PATCH 5/6] extcon-gpio: Describe devicetree bindings
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 04:19:53PM +0100, Guenter Roeck wrote:
> On Mon, Sep 16, 2013 at 03:21:47PM +0100, Mark Rutland wrote:
> > On Thu, Sep 12, 2013 at 05:53:04PM +0100, Guenter Roeck wrote:
> > > On Thu, Sep 12, 2013 at 05:41:00PM +0100, Mark Rutland wrote:
> > > > On Fri, Aug 30, 2013 at 05:29:37AM +0100, Guenter Roeck wrote:
> > > > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > > > ---
> > > > >  .../devicetree/bindings/extcon/extcon-gpio         |   23 ++++++++++++++++++++
> > > > >  1 file changed, 23 insertions(+)
> > > > >  create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio
> > > > > 
> > > > > diff --git a/Documentation/devicetree/bindings/extcon/extcon-gpio b/Documentation/devicetree/bindings/extcon/extcon-gpio
> > > > > new file mode 100644
> > > > > index 0000000..091ddc6
> > > > > --- /dev/null
> > > > > +++ b/Documentation/devicetree/bindings/extcon/extcon-gpio
> > > > > @@ -0,0 +1,23 @@
> > > > > +Device-Tree bindings for extcon/extcon-gpio driver
> > > > 
> > > > Bindings shouldn't refer to Linux-specifics like particular drivers.
> > > > What class of hardware are you actually trying to describe?
> > > > 
> > > Agreed. Question is where to put the bindings, as they are not really 
> > > specific to the extcon driver. The extcon driver merely implements 
> > > the bindings. This is why the "compatible" statement reads "gpio-connector"
> > > and not "extcon-something".
> > > 
> > > The bindings describe a connector managed through gpio pins.
> > 
> > Ok, then that's what the binding document should state.
> > 
> > > 
> > > > > +
> > > > > +Required properties:
> > > > > +	- compatible = "gpio-connector";
> > > > > +	- presence-detect-gpios - presence detect gpio pin
> > > > > +
> > > > > +Optional properties:
> > > > > +	- debounce-interval - debounce interval in milli-seconds
> > > > > +	- state-on - on (connected) state
> > > > > +	- state-off - off (disconnected) state
> > > > > +	  Depending on the type of connector or cable, states may
> > > > > +	  for example be reported as "connected"/"disconnected"
> > > > > +	  or "inserted"/"removed".
> > > > 
> > > > I don't understand what the state-* properties describe. Do these
> > > > provide semantic information to drivers? What is the full set of valid
> > > > values?
> > > > 
> > > That is merely text which is ultimately passed on to the user.
> > > Guess 'semantic information' might be a way to phrase it.
> > 
> > Where do these end up appearing to the user? Through names in the
> 
> Yes.
> 
> > filesystem? That's an ABI, which should be thoroughly described...
> > 
> Tricky, as I can not really describe how the extcon driver implements it.
> I can add something like above explanation, ie that the implementation is
> expected to pass the property to the user. Would that be acceptable ?
> 
> > If it's arbitrary, why is it necessary at all? Surely sensible names for
> > the state of the connector can be coded in the driver for the device
> > attached to said connectors (which can be consistent and later changed
> > if necessary)...
> > 
> Good point. I took a "hint" from the implementation in the extcon driver,
> which lets one do that. But doesn't your comment apply to pretty much all
> "label" and similar properties in the various devicetree descriptions ?

I am also very much not a fan of those properties. They all give an
ill-defined ABI where Linux-specific details are in the DT. I don't see
why such properties should be necessary when it's possible to write
drivers in such a way as to not require them.

> 
> > > 
> > > > > +
> > > > > +Example node:
> > > > > +
> > > > > +	some-connector {
> > > > > +		compatible = "gpio-connector";
> > > > > +		presence-detect-gpios = <&gpio1 7 1>;
> > > > > +		debounce-interval = <1>;
> > > > > +		state-on = "connected";
> > > > > +		state-on = "disconnected";
> > 
> > I don't think that's a valid dts. I assume the second is meant to be
> > "state-off"?
> > 
> Yes, obviously.
> 
> > > > > +	};
> > > > 
> > > > I'm not sure how much value this adds to bindings over describing the
> > > > gpios directly. This seems to add a layer of indirection because of
> > > > Linux internals.
> > > > 
> > > Not sure I understand what you mean with "describing the gpios directly".
> > > Can you elaborate and/or provide an example ?
> > 
> > Take a look at the MMC bindings [1], specifically the cd-gpios and
> > wp-gpios properties. I don't see why the connection of the GPIO needs to
> > be described by a wrapper device that doesn't really exist, when it can
> > be described directly.
> > 
> Question is - described to what or for what ? 
> 
> I think what you are saying is that describing a generic connector via
> devicetree is not acceptable, even though it _does_ describe hardware.
> I would have to describe a specific connector for a specific hardware
> instead, which in turn would need its own driver. Is that correct ?

Regardless of how the connector is described, the block of hardware it
connects to will have to be described, and some description of the
connector will be necessary (either in the node for the block, or by
phandle to a node for the connector). I agree that having a combined IP
block + connector driver for each permutation is not good.

What I'm worried about is that we're pushing bindings for simple cases
(i.e. presences detect for single connectors detected via GPIOs) that we
have other mechanisms for describing (e.g. directly describing said
GPIOs), without considering the more general case and designing the
bindings to support that more general case from the start. We'll end up
designing bindings that are not flexible enough to describe the cases
that we already know exist, and then we'll have real pain attempting to
retrofit those cases into the binding.

The only existing consumer of extcon dt bindings seems to be omap-usb,
which seems to want a single extcon device describing the "USB" and
"USB-HOST" cables. I'm not happy with this binding staying in mainline
as-is, as it makes several assumptions that limits how future extcon
bindings can be implemented:
* It assumes an extcon provider (for lack of a better name) only has at
  most one cable of each type.
* It assumes the same extcon provider provides all cables required.
* It assumes extcon providers are referred to by phandle only (no
  additional cells of identifying information).

I think we need to consider the general case first, where a device
monitors the state of multiple cables, which may be of uniform or
disparate types.

I think it makes more sense to have a clk or gpio style binding, e.g.

gpio: {
	...
};

cables: some-extcon-provider {
	compatible = "vendor,cable-detect";
	/*
	 * This cable detector provides state detection for a power
	 * cable (0), and up to 8 USB host cables (1-8).
	 */
	#cable-detect-cells = <1>;
};

gpio-cable: some-gpio-detection {
	compatible = "linux,gpio-cable-detect";
	gpios = <&gpio 4 2 3>;
	/*
	 * Maybe multiple GPIOs could be allowed instead?
	 */
	#cable-detect-cells = <0>;
};

some-extcon-consumer {
	compatible = "vendor,usb-host-device";

	/*
	 * This could instead be separate power-cables and usb-cables
	 * properties like the gpio bindings, but then describing an
	 * arbitrary subset of USB host cables becomes difficult (you
	 * end up needing separate usbX-gpios properties, from the
	 * start).
	 */
	cables = <&cable 0>,
		 <&cable 5>,
		 <&cable 6>;,
		 <&gpio-cable>;
	cable-names = "power", "usb3", "usb4", "usb6";
};

Another concern is that extcon handles more than just a binary state for
each cable type, and the precise definition of these states is
Linux-specific AFAICS. I'd prefer to keep this concern out of the DT as
much as possible -- an extcon driver should know the types of its
cables, and the consumer should know the types it expects to request. As
such, there's no need to encode "USB-HOST" and friends in the DT -- only
the name of the particular instance of that type of cable should appear.
This obviously makes it difficult to have generic wrappers such as those
using GPIOs -- a platform may require an arbitrary set of GPIOs which
detect an arbitrary value when a certain cable is in a specific state.

We *need* to consider the general case before we start proliferating
bindings, or we'll end up creating bindings that cannot express the
general case. Shortcuts we take early on to make implementation easier
create real problems for us later on, because they become ABI.

Cheers,
Mark.
