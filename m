Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaJFQhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:37:31 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64913 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaJFQhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:37:07 -0400
Date: Mon, 6 Oct 2014 09:37:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Duson Lin <dusonlin@emc.com.tw>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "bleung@chromium.org" <bleung@chromium.org>,
        "agnescheng@chromium.org" <agnescheng@chromium.org>,
        "phoenix@emc.com.tw" <phoenix@emc.com.tw>,
        "jeff.chuang@emc.com.tw" <jeff.chuang@emc.com.tw>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2] Input: add i2c/smbus driver for elan touchpad
Message-ID: <20141006163703.GB27115@dtor-glaptop>
References: <1389064083-11018-1-git-send-email-dusonlin@emc.com.tw>
 <20141003210357.GB4987@dtor-ws>
 <20141003210651.GC4987@dtor-ws>
 <20141006092452.GA24686@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006092452.GA24686@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 10:24:52AM +0100, Mark Rutland wrote:
> On Fri, Oct 03, 2014 at 10:06:51PM +0100, Dmitry Torokhov wrote:
> > [adding devicetree folks...]
> > 
> > On Fri, Oct 03, 2014 at 02:03:57PM -0700, Dmitry Torokhov wrote:
> > > diff --git a/Documentation/devicetree/bindings/input/elan_i2c.txt b/Documentation/devicetree/bindings/input/elan_i2c.txt
> > > new file mode 100644
> > > index 0000000..0a6ee7d
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/input/elan_i2c.txt
> > > @@ -0,0 +1,34 @@
> > > +Elantech I2C Touchpad
> > > +
> > > +Required properties:
> > > +- compatible: must be "elan,i2c_touchpad".
> 
> s/_/-/ in DT strings and property names plase.
> 
> The name seems very generic, and you mention the driver supports a
> variety of touchpads. Please choose a specific device name for the
> compatible string. Other devices can have that as a fallback entry in
> addition to a more specific string.

Duson, what would be a good model/device name here?

> 
> > > +- reg: I2C address of the chip.
> > > +- interrupt-parent: a phandle for the gpio controller (see interrupt
> > > +  binding[0]).
> > > +- interrupts: (gpio) interrupt to which the chip is connected (see interrupt
> > > +  binding[0]).
> 
> If this is an interrupt from the PoV of this device, it doesn't matter
> if the other end is connected to a hardwired interrupt controller or a
> gpio. So drop the mention of GPIOs frmom the interrupt properties.
> 
> > > +
> > > +Optional properties:
> > > +- wakeup-source: touchpad should be configured as a wakeup source.
> 
> s/should be configured as/can be used as/
> 
> > > +- pinctrl-names: should be "default" (see pinctrl binding [1]).
> > > +- pinctrl-0: a phandle pointing to the pin settings for the device (see
> > > +  pinctrl binding [1]).
> > > +- vcc-supply: a phandle for the regulator supplying 3.3V power.
> > > +
> > > +[0]: Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> > > +[1]: Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> > > +
> > > +Example:
> > > +     &i2c1 {
> > > +             /* ... */
> > > +
> > > +             touchpad@15 {
> > > +                     compatible = "elan,i2c_touchpad";
> > > +                     reg = <0x15>;
> > > +                     interrupt-parent = <&gpio4>;
> > > +                     interrupts = <0x0 IRQ_TYPE_EDGE_FALLING>;
> > > +                     wakeup-source;
> > > +             };
> > > +
> > > +             /* ... */
> > > +     };
> 
> Otherwise this looks ok.

Thanks Mark.

-- 
Dmitry
