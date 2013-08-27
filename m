Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab3H0Oog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:44:36 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42810 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752881Ab3H0Oof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:44:35 -0400
Date: Tue, 27 Aug 2013 15:44:26 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH v2 3/3] gpio: pcf857x: Add OF support
Message-ID: <20130827144426.GO19893@e106331-lin.cambridge.arm.com>
References: <1376953494-9684-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <2417846.CRj8QejgZy@flatron>
 <20130827103949.GF19893@e106331-lin.cambridge.arm.com>
 <2048253.b587MQDRGG@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2048253.b587MQDRGG@avalon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 11:50:40AM +0100, Laurent Pinchart wrote:
> Hi Mark,
> 
> On Tuesday 27 August 2013 11:39:49 Mark Rutland wrote:
> > On Sat, Aug 24, 2013 at 03:13:11PM +0100, Tomasz Figa wrote:
> > > On Saturday 24 of August 2013 02:54:07 Laurent Pinchart wrote:
> > > > On Saturday 24 August 2013 02:41:59 Tomasz Figa wrote:
> > > > > On Tuesday 20 of August 2013 01:04:54 Laurent Pinchart wrote:
> > > > > > Add DT bindings for the pcf857x-compatible chips and parse the
> > > > > > device tree node in the driver.
> > > > > > 
> > > > > > Signed-off-by: Laurent Pinchart
> > > > > > <laurent.pinchart+renesas@ideasonboard.com>
> > > > > > ---
> > > > > > 
> > > > > >  .../devicetree/bindings/gpio/gpio-pcf857x.txt      | 71 +++++++++++
> > > > > >  drivers/gpio/gpio-pcf857x.c                        | 57 +++++++++--
> > > > > >  2 files changed, 119 insertions(+), 9 deletions(-)
> > > > > >  create mode 100644
> > > > > > Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
> > > > > > 
> > > > > > diff --git a/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
> > > > > > b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt new file
> > > > > > mode 100644
> > > > > > index 0000000..df94462
> > > > > > --- /dev/null
> > > > > > +++ b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
> > > > > > @@ -0,0 +1,71 @@
> > > > 
> > > > [snip]
> > > > 
> > > > > > +  - pins-initial-state: Bitmask that specifies the initial state of
> > > > > > +    each pin. When a bit is set to zero, the corresponding pin will
> > > > > > be
> > > > > > +    initialized to the input (pulled-up) state. When the  bit is
> > > > > > set to +    one, the pin will be initialized the the low-level
> > > > > > output state. If +    the property is not specified all pins will
> > > > > > be initialized to the +    input state.
> > > > > 
> > > > > Hmm, do you actually need to know whether those pins are outputs or
> > > > > inputs before they get used for first time? I believe any driver
> > > > > using GPIO will call gpio_direction_{in,out}put() before it starts
> > > > > using the pin, which will initialize the pin to a known state.
> > > > > 
> > > > > What I'd suggest is making the driver handle this by having a bit mask
> > > > > that marks states of pins as defined and flagging all pins as
> > > > > undefined by default. Then any call to gpio_direction_output() or
> > > > > _input() would mark it as defined and direction of the pin could be
> > > > > stored in internal driver structures.
> > > > 
> > > > The problem is that all pins are controlled through a single I2C write.
> > > > Setting the direction of a pin will set the direction of all other pins.
> > > > I thus need to know what the initial settings are to avoid glitches.
> > 
> > I guess it's not possible to read the initial state from the hardware?
> 
> I wish. Unfortunately it can only be written.

What a shame :(

Thanks,
Mark.
