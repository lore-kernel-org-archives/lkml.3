Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbaDHOd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:33:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33073 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093AbaDHOd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:33:57 -0400
Date: Tue, 8 Apr 2014 16:33:27 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thor Thayer <tthayer@altera.com>
Cc: robherring2@gmail.com, dougthompson@xmission.com, grant.likely@linaro.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, dinguyen@altera.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] dts: socfpga: Add bindings for Altera SoC SDRAM
 controller
Message-ID: <20140408143327.GC16054@pengutronix.de>
References: <1396907649-20212-1-git-send-email-tthayer@altera.com>
 <1396907649-20212-2-git-send-email-tthayer@altera.com>
 <20140408133818.GB16054@pengutronix.de>
 <1396967390.23349.15.camel@dinh-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396967390.23349.15.camel@dinh-ubuntu>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:26:28 up 226 days, 23:57, 55 users,  load average: 0,13, 0,14,
 0,14
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 09:29:50AM -0500, Thor Thayer wrote:
> On Tue, 2014-04-08 at 15:38 +0200, Steffen Trumtrar wrote:
> > Hi!
> > 
> > On Mon, Apr 07, 2014 at 04:54:07PM -0500, tthayer@altera.com wrote:
> > > From: Thor Thayer <tthayer@altera.com>
> > > 
> > > Addition of the Altera SDRAM controller bindings and device
> > > tree changes to the Altera SoC project.
> > > 
> [snip]
> > > +
> > > +Required properties:
> > > +- compatible : "altr,sdr-ctl", "syscon";
> > > +                Note that syscon is invoked for this device to support the FPGA
> > > +		bridge driver, EDAC driver and other devices that share the
> > > +		registers.
> > > +- reg : Should contain 1 register ranges(address and length)
> > 
> > I haven't really thought this through, but why would the FPGA bridge driver
> > access the sdram controller? For releasing the resets in fpgaportrst ? Or is
> > there more?
> 
> Hi Steffan. No, not for resets. We need to enable the FPGA to SDRAM
> path. Our SDRAM controller allows FPGA master access to the SDRAM.
>

Yes. But what you have to do to enable the path is let the FPGA port you use
out of reset. And that is it as far as I can see. The rest happens in the
bitstream. Or is there more to enable the path?
The FPGA2SDRAM bridge is the one I didn't use as of yet, so if I miss something
please elaborate.

> > Wouldn't it be more appropriate to represent those bits as a reset-controller to
> > some hypothetical IP core driver?
> > Then you could have something like
> > 
> > 	hps2fpga@c0000000 {
> > 		ipcore@0 {
> > 			resets = <&sdr 1>;
> > 			reset-names = "foo";
> > 			resets = <&rst 96>;
> > 			reset-names = "bar";
> > 			(...)
> > 		};
> > 
> > 		ipcore@1000 {
> > 			resets = <&rst 96>;
> > 			reset-names = "baz";
> > 			(...)
> > 		};
> > 	};
> > 
> > And you would always have the correct bridges released out of reset for your
> > IP core. Does the FPGA bridge driver do more? I think that is basically it.
> > Where we maybe could run into problems though is the early_init stuff.
> > 
> > I think syscon is nice for some things, but we should try not to overuse it.
> 
> Understood. In this case, syscon seems to be appropriate.

I'm not convinced yet.

Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
