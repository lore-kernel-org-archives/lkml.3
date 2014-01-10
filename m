Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbaAJPaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:30:13 -0500
Received: from [85.220.129.33] ([85.220.129.33]:47184 "EHLO smtp2.goneo.de"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756176AbaAJPaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:30:11 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.846
From: Lars Poeschel <poeschel@lemonage.de>
To: Gerhard Sittig <gsi@denx.de>
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, robh+dt@kernel.org,
        linus.walleij@linaro.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, rob@landley.net, galak@codeaurora.org,
        gnurou@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH v2] gpio: mcp23s08: Add irq functionality for i2c chips
Date: Fri, 10 Jan 2014 16:29:36 +0100
Message-ID: <29565656.1ncixD0qYE@lem-wkst-02>
User-Agent: KMail/4.11.3 (Linux/3.11-2-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140110150836.GZ20094@book.gsilab.sittig.org>
References: <1389363750-25989-1-git-send-email-larsi@wh2.tu-dresden.de> <20140110150836.GZ20094@book.gsilab.sittig.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 January 2014 16:08:36, Gerhard Sittig wrote:
> On Fri, Jan 10, 2014 at 15:22 +0100, Lars Poeschel wrote:
> > --- a/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> > +++ b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> > 
> > @@ -38,12 +38,37 @@ Required device specific properties (only for SPI 
chips):
> >      removed.
> >  
> >  - spi-max-frequency = The maximum frequency this chip is able to handle
> > 
> > -Example I2C:
> > +Optional properties:
> > +- #interrupt-cells : Should be two.
> > +  - first cell is the pin number
> > +  - second cell is used to specify flags.
> > +- interrupt-controller: Marks the device node as a interrupt controller.
> > +NOTE: The interrupt functionality is only supported for i2c versions of
> > the +chips yet.
> 
> Is this "IRQ feature for I2C chips only" limitation specific to
> the hardware or an implementation detail of the Linux driver?  I
> could not determine this from either the binding text nor the
> driver source.

Ok, you're right. My description is not 100% clear about this. I will update 
this. It is currently an implementation detail of the linux driver. According 
to the datasheet the spi chips should also be able to do the interrupts.

> If it's just the status of the Linux driver, then it should not
> be in the binding document.  If it's a limitation of the
> hardware, then it's appropriate in the binding but I suggest to
> adjust the text to avoid the next person to ask the same
> question. :)

I do not agree. I remember a rule that every binding has to be documented, so 
this should be documented, but you are right: The description has to be a bit 
more clear about this beeing a (current) limitation of the driver.
I will update this and do a v3, but I will wait a bit for further comments.

> > --- a/drivers/gpio/Kconfig
> > +++ b/drivers/gpio/Kconfig
> > @@ -697,6 +697,7 @@ config GPIO_MCP23S08
> > 
> >  	  SPI/I2C driver for Microchip MCP23S08/MCP23S17/MCP23008/MCP23017
> >  	  I/O expanders.
> >  	  This provides a GPIO interface supporting inputs and outputs.
> > 
> > +	  The I2C versions of the chips can be used as interrupt-controller.
> > 
> >  config GPIO_MC33880
> >  
> >  	tristate "Freescale MC33880 high-side/low-side switch"
> > 
> > diff --git a/drivers/gpio/gpio-mcp23s08.c b/drivers/gpio/gpio-mcp23s08.c
> > index 2deb0c5..1346ea6 100644
> > --- a/drivers/gpio/gpio-mcp23s08.c
> > +++ b/drivers/gpio/gpio-mcp23s08.c
> > @@ -1,5 +1,10 @@
> > 
> >  /*
> > 
> > - * MCP23S08 SPI/GPIO gpio expander driver
> > + * MCP23S08 SPI/I2C GPIO gpio expander driver
> > + *
> > + * The inputs and outputs of the mcp23s08, mcp23s17, mcp23008 and
> > mcp23017 are + * supported.
> > + * For the I2C versions of the chips (mcp23008 and mcp23017) generation
> > of
> > + * interrupts is also supported.
> > 
> >   */
> 
> Adjust these as well to reflect whether it's hardware or software
> which limits the feature.

Yes,I will do that too.

Lars
