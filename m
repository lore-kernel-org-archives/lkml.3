Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab3AJTXL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 14:23:11 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:46860 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab3AJTXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 14:23:08 -0500
Date: Thu, 10 Jan 2013 14:27:40 -0500
From: Matt Porter <mporter@ti.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v3 08/16] ARM: dts: add AM33XX EDMA support
Message-ID: <20130110192740.GO14660@beef>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
 <1350566815-409-9-git-send-email-mporter@ti.com>
 <508D1414.2000506@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508D1414.2000506@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 04:46:36PM +0530, Sekhar Nori wrote:
> On 10/18/2012 6:56 PM, Matt Porter wrote:
> > Adds AM33XX EDMA support to the am33xx.dtsi as documented in
> > Documentation/devicetree/bindings/dma/ti-edma.txt
> > 
> > Signed-off-by: Matt Porter <mporter@ti.com>
> > ---
> >  arch/arm/boot/dts/am33xx.dtsi |   31 +++++++++++++++++++++++++++++++
> >  1 file changed, 31 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> > index bb31bff..ab9c78f 100644
> > --- a/arch/arm/boot/dts/am33xx.dtsi
> > +++ b/arch/arm/boot/dts/am33xx.dtsi
> > @@ -62,6 +62,37 @@
> >  			reg = <0x48200000 0x1000>;
> >  		};
> >  
> > +		edma: edma@49000000 {
> > +			compatible = "ti,edma3";
> > +			ti,hwmods = "tpcc", "tptc0", "tptc1", "tptc2";
> > +			reg =	<0x49000000 0x10000>,
> > +				<0x44e10f90 0x10>;
> > +			interrupt-parent = <&intc>;
> > +			interrupts = <12 13 14>;
> > +			#dma-cells = <1>;
> > +			dma-channels = <64>;
> > +			ti,edma-regions = <4>;
> > +			ti,edma-slots = <256>;
> > +			ti,edma-reserved-channels = <0  2
> > +						     14 2
> > +						     26 6
> > +						     48 4
> > +						     56 8>;
> > +			ti,edma-reserved-slots = <0  2
> > +						  14 2
> > +						  26 6
> > +						  48 4
> > +						  56 8
> > +						  64 127>;
> 
> No need to reserve any channels or slots on AM335x, I think. This is
> used on DaVinci devices to share channels with DSP. I am not sure the
> cortex-M3 or PRU on the AM335x need to (or even can) have EDMA access.

I agree. I'm dropping this from the .dtsi in v4 as it is board/application
specific. The PRU, at least, can use the EDMA and I've seen examples as
such, but we can't hardcode this. The feature is there and documented in
the binding if somebody needs to reserve channels in their .dts.

-Matt
