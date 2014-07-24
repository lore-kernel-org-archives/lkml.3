Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbaGXO0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:26:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35748 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758992AbaGXO0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:26:49 -0400
Date: Thu, 24 Jul 2014 10:26:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org,
        Peter Griffin <peter.griffin@linaro.org>, <devicetree@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <patrice.chotard@st.com>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@gmail.com>, <lee.jones@linaro.org>,
        <maxime.coquelin@st.com>
Subject: Re: [PATCH v2 1/3] usb: host: st-hcd: Add USB HCD support for STi
 SoCs
In-Reply-To: <5967609.vndF2bDyS1@wuerfel>
Message-ID: <Pine.LNX.4.44L0.1407241019530.1146-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014, Arnd Bergmann wrote:

> > > The way you do this apparently is to create a device that encapsulates
> > > the OHCI and the EHCI and then goes on to create child devices that
> > > are bound to the real drivers.
> > 
> > Yes, although this isn't the first driver to take that approach USB_HCD_BCMA
> > (bcma-hcd.c) and USB_HCD_SSB (ssb-hcd.c) do much the same thing.
> 
> I just had a look at them, and I think the case is different here:
> 
> For the two bcma driver, there is a discoverable bus (bcma) rather than
> the platform bus, and it only exposes one device, so the bcma-hcd driver
> is actually needed so we get two device that can be bound to the regular
> drivers.
> 
> For the ssb-hcd driver, it's less clear and that one could be
> reworked into two separate drivers.
> 
> > > The way it should be done however is to put the two host controllers
> > > into DT directly and describe their resources (phy, clock, reset, ...)
> > > using the DT bindings for those.
> > 
> > I'm of course happy to change it if required. I see looking through that a lot 
> > of other platforms do it the way you describe with a
> > 
> > ehci-<platname>.c and ohci-<platname>.c
> 
> Right. We are trying to  gradually move some of them over to use the
> generic *hci-platform.c drivers though.
> 
> > > Depending on what kind of special requirements the ST version has,
> > > this can be done either by using the generic ohci/ehci bindings
> > > with extensions where necessary, or by creating a new binding and
> > > new driver files that use 'ohci_init_driver'/'ehci_init_driver'
> > > to inherit from the common code.
> > > 
> > > The first of the two approaches is preferred.
> > 
> > We don't have anything particularly special, just a couple of reset lines,
> > clock, phy, etc.
> 
> Ok, good. Please see Documentation/devicetree/bindings/usb/usb-?hci.txt
> then. You might actually be able to just use the existing drivers
> without new code by just adding the proper DT nodes that follow these
> bindings.
> 
> > > > +   pdev->dev.parent = &parent->dev;
> > > > +   pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
> > > > +   pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> > > 
> > > This is something we shouldn't ever do these days, the DMA settings
> > > should come directly from DT without driver interaction.
> > 
> > Ok, I'll wait to hear the outcome of Greg/Alans views before either fixing
> > it or starting over.
> 
> Ok.

As far as I'm concerned, any of these approaches is okay although
putting everything into DT is the most desirable, because it will
minimize the code size.

Mostly what's at issue here is the design preferences of the people at 
Linaro and all others who work on architecture-specific stuff.

Alan Stern

