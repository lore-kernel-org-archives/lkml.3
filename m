Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3BEO3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:29:19 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:51910 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab3BEO3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:29:17 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RFC 1/1] gpio: mcp23s08: convert driver to DT
To: Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>
Cc: poeschel@lemonage.de, rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        w.sang@pengutronix.de, ben-linux@fluff.org, linux-i2c@vger.kernel.org
In-Reply-To: <CACRpkda_HjzWNMD1H_a_fsWtbRWuTDsutS8kndb9jY31qf7Yyg@mail.gmail.com>
References: <1359647903-15801-1-git-send-email-larsi@wh2.tu-dresden.de> <1359647903-15801-2-git-send-email-larsi@wh2.tu-dresden.de> <CACRpkda_HjzWNMD1H_a_fsWtbRWuTDsutS8kndb9jY31qf7Yyg@mail.gmail.com>
Date: Tue, 05 Feb 2013 14:29:09 +0000
Message-Id: <20130205142909.4F5B83E1265@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013 21:51:36 +0100, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Jan 31, 2013 at 4:58 PM, Lars Poeschel <larsi@wh2.tu-dresden.de> wrote:
> 
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> > @@ -0,0 +1,27 @@
> > +Microchip MCP2308/MCP23S08/MCP23017/MCP23S17 driver for
> > +8-/16-bit I/O expander with serial interface (I2C/SPI)
> > +
> > +Required properties:
> > +- compatible : Should be "mcp,mcp23s08-gpio", "mcp,mcp23s17-gpio",
> > +                       "mcp,mcp23008-gpio" or "mcp,mcp23017-gpio"
> > +- base : The first gpio number that should be assigned by this chip.
> 
> No. We do not tie the global GPIO numbers into the device tree.
> 
> In the DT GPIOs are referenced by ampersand <&gpio0 1 2>
> notation referring to the instance, so as you realize DT itself
> has no need for that number.
> 
> Further it is not OS-neutral.
> 
> You have to find another way to handle this in the driver code.
> In worst case: use AUXDATA.

Hi Lars,

The trick is to declare the io expander to be a "gpio-controller" and
use the #gpio-cells property to declare how many cells (32-bit numbers)
are need to specify a single gpio line. Most gpio controllers use
"gpio-cells=<2>"; The first cell is the *controller local* gpio
number, and the second cell is used for flags. That way your gpio
controller can be referenced by other nodes in the tree with a "gpios"
property.

You can find lots of examples of this in the tree.

g.

