Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbaLJRuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:50:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48170 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbaLJRuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:50:07 -0500
Date: Wed, 10 Dec 2014 18:49:45 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: atull <atull@opensource.altera.com>
Cc: gregkh@linuxfoundation.org, jgunthorpe@obsidianresearch.com, hpa@zytor.com,
        monstr@monstr.eu, michal.simek@xilinx.com, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        pantelis.antoniou@konsulko.com, robh+dt@kernel.org,
        grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, pavel@denx.de, broonie@kernel.org,
        philip@balister.org, rubini@gnudd.com, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH v4 2/6] arm: dts: socfpga: add altera fpga manager
Message-ID: <20141210174945.GC23358@pengutronix.de>
References: <1418156090-23578-1-git-send-email-atull@opensource.altera.com>
 <1418156090-23578-3-git-send-email-atull@opensource.altera.com>
 <20141210150109.GA23358@pengutronix.de>
 <alpine.DEB.2.02.1412101123530.25868@linuxheads99>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1412101123530.25868@linuxheads99>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:42:41 up 56 days,  4:56, 78 users,  load average: 0,03, 0,05,
 0,05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 11:25:59AM -0600, atull wrote:
> On Wed, 10 Dec 2014, Steffen Trumtrar wrote:
> 
> > Hi!
> > 
> > On Tue, Dec 09, 2014 at 02:14:46PM -0600, atull@opensource.altera.com wrote:
> > > From: Alan Tull <atull@opensource.altera.com>
> > > 
> > > Add Altera FGPA manager to device tree.
> > > 
> > > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > > ---
> > >  arch/arm/boot/dts/socfpga.dtsi |   10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> > > index 4472fd9..bab98b6 100644
> > > --- a/arch/arm/boot/dts/socfpga.dtsi
> > > +++ b/arch/arm/boot/dts/socfpga.dtsi
> > > @@ -751,5 +751,15 @@
> > >  			compatible = "altr,sys-mgr", "syscon";
> > >  			reg = <0xffd08000 0x4000>;
> > >  		};
> > > +
> > > +		hps_0_fpgamgr: fpgamgr@0xff706000 {
> > > +			compatible = "altr,fpga-mgr", "simple-bus";
> > > +			reg = <0xFF706000 0x1000
> > > +			       0xFFB90000 0x1000>;
> > > +			interrupts = <0 175 4>;
> > > +			#address-cells = <1>;
> > > +			#size-cells = <1>;
> > > +			ranges;
> > > +		};
> > 
> > The fpgamgr is NOT a bus. You don't need ranges and/or simple-bus.
> > 
> > Regards,
> > Steffen
> 
> Actually, I am going to be using this when I add the DT notification 
> stuff.  That stuff is waiting for DT overlays to show up in the main
> tree.
> 
> So the choice it to either change this file now, once, or do the minimal 
> changes and have to change it again later.
> 

Yes, that is what I thought. And still, devices can NOT show up
at the fpgamgr. They show up on the various bridges.

And as far as I understand the DT overlay stuff, you specify in
the overlay what the parent node will be.
For i2c this is one of the i2c-hosts, for spi one of the spi-hosts
and for IP cores in a bitstream one of the bridges.

The fpgamgr is, from my understanding, only responsible for writing
the bitstream to the FPGA; nothing more.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
