Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab3AJUpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:45:31 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:62020 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab3AJUp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:45:26 -0500
Date: Thu, 10 Jan 2013 15:49:59 -0500
From: Matt Porter <mporter@ti.com>
To: Nishanth Menon <nm@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Chris Ball <cjb@laptop.org>, Russell King <linux@arm.linux.org.uk>,
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
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v3 16/16] ARM: dts: add AM33XX SPI support
Message-ID: <20130110204959.GS14660@beef>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
 <1350566815-409-17-git-send-email-mporter@ti.com>
 <508D1791.1040806@ti.com>
 <20130110193547.GQ14660@beef>
 <20130110194653.GA32519@kahuna>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130110194653.GA32519@kahuna>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 01:46:53PM -0600, Nishanth Menon wrote:
> On 14:35-20130110, Matt Porter wrote:
> > On Sun, Oct 28, 2012 at 05:01:29PM +0530, Sekhar Nori wrote:
> > > On 10/18/2012 6:56 PM, Matt Porter wrote:
> > > > Adds AM33XX SPI support for am335x-bone and am335x-evm.
> > > > 
> > > > Signed-off-by: Matt Porter <mporter@ti.com>
> > > > ---
> > > >  arch/arm/boot/dts/am335x-bone.dts |   17 +++++++++++++++
> > > >  arch/arm/boot/dts/am335x-evm.dts  |    9 ++++++++
> > > >  arch/arm/boot/dts/am33xx.dtsi     |   43 +++++++++++++++++++++++++++++++++++++
> > > >  3 files changed, 69 insertions(+)
> > > > 
> > > > diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
> > > > index 5510979..23edfd8 100644
> > > > --- a/arch/arm/boot/dts/am335x-bone.dts
> > > > +++ b/arch/arm/boot/dts/am335x-bone.dts
> > > > @@ -18,6 +18,17 @@
> > > >  		reg = <0x80000000 0x10000000>; /* 256 MB */
> > > >  	};
> > > >  
> > > > +	am3358_pinmux: pinmux@44e10800 {
> > > > +		spi1_pins: pinmux_spi1_pins {
> > > > +			pinctrl-single,pins = <
> > > > +				0x190 0x13	/* mcasp0_aclkx.spi1_sclk, OUTPUT_PULLUP | MODE3 */
> > > > +				0x194 0x33	/* mcasp0_fsx.spi1_d0, INPUT_PULLUP | MODE3 */
> > > > +				0x198 0x13	/* mcasp0_axr0.spi1_d1, OUTPUT_PULLUP | MODE3 */
> minor comment:
> doing as a 0x33 is better for both d1, d0 as D0,D1 can be switched between SDI and SDO
> as needed with ti,pindir-d0-out-d1-in

Yes, thanks. Forgot about the new property and feature even though I
told somebody about it yesterday. :)

> > > > +				0x19c 0x13	/* mcasp0_ahclkr.spi1_cs0, OUTPUT_PULLUP | MODE3 */
> > > > +			>;
> > > 
> > > Is there a single pinmux setting that provides SPI functionality on the
> > > bone headers? Or this is specific to a cape you tested with?
> > 
> > No, there are two usable settings for spi1 and one setting for spi0.
> > I'm dropping this from the series since it's specific to how I wired up
> > the homebrew cape I use for spi testing on the Bone. I publish the
> > branch where all these extra "test-specific" patches (that aren't intended
> > to be merged) are at in the cover letter.  Anybody that needs context of
> > how/what worked and was tested can grab them there.
> Possibly dumb question:
> Cant we have pre-usable spi configurations?  Like spi1_configuration1_pins,
> spi2_configuration1_pins, spi0_configuration1_pins? If documented with
> P9 pin names in the bone dts, it saves a bit of effort in looking up
> pad offset when dealing with capes.

Yes, let's introduce these things separately. I plan to reintroduce
patches to fix the incorrect 1-based numbering on many of the AM33xx as
previous ones were dropped...and I think this makes sense on top of
that.

-Matt
> -- 
> Regards,
> Nishanth Menon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
