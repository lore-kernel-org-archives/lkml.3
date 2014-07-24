Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbaGXMXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:23:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50384 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834AbaGXMW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:22:59 -0400
Date: Thu, 24 Jul 2014 13:22:54 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        gregkh@linuxfoundation.org, srinivas.kandagatla@gmail.com,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        lee.jones@linaro.org
Subject: Re: [PATCH v2 1/3] usb: host: st-hcd: Add USB HCD support for STi
 SoCs
Message-ID: <20140724122254.GA15266@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1406199616-10533-1-git-send-email-peter.griffin@linaro.org>
 <1406199616-10533-2-git-send-email-peter.griffin@linaro.org>
 <11018717.Ey5qEJxGNJ@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11018717.Ey5qEJxGNJ@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for reviewing, see my comments below: -

> Unfortunately, this seems to be done in a rather strange way,
> I suspect you'll have to start over, but I'll let Alan and Greg
> weigh in.
> 
> > +
> > +struct st_hcd_dev {
> > +	int port_nr;
> > +	struct platform_device *ehci_device;
> > +	struct platform_device *ohci_device;
> > +	struct clk *ic_clk;
> > +	struct clk *ohci_clk;
> > +	struct reset_control *pwr;
> > +	struct reset_control *rst;
> > +	struct phy *phy;
> > +};
> 
> The way you do this apparently is to create a device that encapsulates
> the OHCI and the EHCI and then goes on to create child devices that
> are bound to the real drivers.

Yes, although this isn't the first driver to take that approach USB_HCD_BCMA
(bcma-hcd.c) and USB_HCD_SSB (ssb-hcd.c) do much the same thing.

> 
> The way it should be done however is to put the two host controllers
> into DT directly and describe their resources (phy, clock, reset, ...)
> using the DT bindings for those.

I'm of course happy to change it if required. I see looking through that a lot 
of other platforms do it the way you describe with a

ehci-<platname>.c and ohci-<platname>.c 
> 
> Depending on what kind of special requirements the ST version has,
> this can be done either by using the generic ohci/ehci bindings
> with extensions where necessary, or by creating a new binding and
> new driver files that use 'ohci_init_driver'/'ehci_init_driver'
> to inherit from the common code.
> 
> The first of the two approaches is preferred.

We don't have anything particularly special, just a couple of reset lines,
clock, phy, etc.
> 
> > +	pdev->dev.parent = &parent->dev;
> > +	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
> > +	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
> 
> This is something we shouldn't ever do these days, the DMA settings
> should come directly from DT without driver interaction.

Ok, I'll wait to hear the outcome of Greg/Alans views before either fixing
it or starting over.

regards,

Peter.
