Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaDAWTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 18:19:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33654 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaDAWTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 18:19:36 -0400
Date: Wed, 2 Apr 2014 00:19:13 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thor Thayer - Sendmail <tthayer@altera.com>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, linux@arm.linux.org.uk,
        pawel.moll@arm.com, linux-doc@vger.kernel.org,
        devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
        rob@landley.net, galak@codeaurora.org, dinguyen@altera.com
Subject: Re: [PATCH 1/2] dts: socfpga: Add bindings for Altera SoC SDRAM
 controller
Message-ID: <20140401221913.GR5052@pengutronix.de>
References: <1396303627-29198-1-git-send-email-tthayer@altera.com>
 <1396303627-29198-2-git-send-email-tthayer@altera.com>
 <20140401052807.GN5052@pengutronix.de>
 <1396383101.20336.6.camel@dinh-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396383101.20336.6.camel@dinh-ubuntu>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 00:04:28 up 220 days,  7:35, 42 users,  load average: 0,14, 0,09,
 0,11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tue, Apr 01, 2014 at 03:11:41PM -0500, Thor Thayer - Sendmail wrote:
> On Tue, 2014-04-01 at 07:28 +0200, Steffen Trumtrar wrote:
> > Hi!
> > 
> > On Mon, Mar 31, 2014 at 05:07:06PM -0500, tthayer@altera.com wrote:
> > > From: Thor Thayer <tthayer@altera.com>
> > > 
> > > Addition of the Altera SDRAM controller bindings and device
> > > tree changes to the Altera SoC project.
> > >
> 
> <snip>
> 
> > > diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> > > new file mode 100644
> > > index 0000000..351ab7b
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> > > @@ -0,0 +1,14 @@
> > > +Altera SOCFPGA SDRAM Controller
> > > +
> > > +Required properties:
> > > +- compatible : "altr,sdr-ctl", "syscon";
> > > +                Note that syscon is invoked for this device to support the FPGA
> > > +		bridge driver and possibly other devices in the future.  See
> > > +		also Documentation/devicetree/bindings/mfd/syscon.txt
> > 
> > This note is really linux specific (and specific to some vendor kernel driver
> > for that matter). I think you should remove that.
> 
> Hi Steffen. Are you asking for the path to syscon.txt to be removed or
> the entire note? 
> The note is explaining why the "syscon" tag is used for this Altera IP
> block (registers shared between multiple drivers).
> Thanks for the clarification.
> 

I was referring to the note. I don't know what the current guideline is for
this type of "devices", but I think referring to the syscon documentation
is okay.
The first part however describes a DT binding with things that might or might
not happen in the future. What I want to say is, I would rather have this
reworded, to have it just describe the SDRAM controller node as simple as it may
be.

> > 
> > > +- reg : Should contain 1 register ranges(address and length)
> > > +
> > > +Example:
> > > +	sdrctl@0xffc25000 {
> > > +		compatible = "altr,sdr-ctl", "syscon";
> > > +		reg = <0xffc25000 0x1000>;
> > > +	};
> > > diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> > > index 9e78c1d..3634de7 100644
> > > --- a/arch/arm/boot/dts/socfpga.dtsi
> > > +++ b/arch/arm/boot/dts/socfpga.dtsi
> > > @@ -528,6 +528,11 @@
> > >  			reg-io-width = <4>;
> > >  		};
> > >  
> > > +		sdrctl@0xffc25000 {
                       ^^
Oh, and Dinh just mentioned in my patch, that the 0x shall be removed here.
But I'm not so sure about that. Just FYI.

> > > +			compatible = "altr,sdr-ctl", "syscon";
> > > +			reg = <0xffc25000 0x1000>;
> > > +		};
> > > +
> > >  		rstmgr@ffd05000 {
> > >  			compatible = "altr,rst-mgr";
> > >  			reg = <0xffd05000 0x1000>;

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
