Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbaJIPTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:19:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41242 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbaJIPTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:19:47 -0400
Date: Thu, 9 Oct 2014 17:19:35 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: atull <atull@opensource.altera.com>
Cc: Dinh Nguyen <dinguyen@opensource.altera.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, dinh.linux@gmail.com,
        grant.likely@linaro.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reset: socfpga: use arch_initcall for early
 initialization
Message-ID: <20141009151935.GK15799@pengutronix.de>
References: <1412822646-11257-1-git-send-email-dinguyen@opensource.altera.com>
 <1412845410.6809.3.camel@pengutronix.de>
 <54368AA2.9000104@opensource.altera.com>
 <20141009132835.GI15799@pengutronix.de>
 <alpine.DEB.2.02.1410090950540.17462@atx-linux-37>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1410090950540.17462@atx-linux-37>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:08:18 up 29 days,  7:55, 84 users,  load average: 0,04, 0,05,
 0,08
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Thu, Oct 09, 2014 at 09:57:49AM -0500, atull wrote:
> On Thu, 9 Oct 2014, Steffen Trumtrar wrote:
> 
> > On Thu, Oct 09, 2014 at 08:16:18AM -0500, Dinh Nguyen wrote:
> > > Hi Philipp,
> > > 
> > > On 10/9/14, 4:03 AM, Philipp Zabel wrote:
> > > > Am Mittwoch, den 08.10.2014, 21:44 -0500 schrieb
> > > > dinguyen@opensource.altera.com:
> > > >> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> > > >>
> > > >> There are certain drivers that are required to get loaded very early using
> > > >> arch_initcall. An example of such a driver is the SOCFPGA's FPGA bridge driver.
> > > >> This driver has to get loaded early because it needs to enable FPGA components
> > > >> that are connected to the bridge.
> > > >>
> > > >> This FPGA bridge driver will using the reset controller API to toggle it's
> > > >> reset bits, thus, it needs the reset driver to be loaded as early as possible
> > > >> in order for it to get used properly.
> > > > 
> > > > Without knowing the details, this sounds like the wrong approach. Can't
> > > > the bridge driver return -EPROBE_DEFER until the reset controller is
> > > > available?
> > > > 
> 
> I don't think we can do deferred probing for arch_initcall.
> 
> > > 
> > > The bridge driver is also using arch_initcall, as it also needs to get
> > > loaded early for FPGA IPs to work, and so later driver loading will work
> > > for the FPGA IPs.
> > > 
> > 
> > For the bridge driver the same is true. I guess that there *might* be
> > IP cores where you need to be very early, but that shouldn't be the normal
> > case. If the driver can't get loaded properly, the right thing would be to
> > fix the driver.
> 
> Some fpga ip drivers will need to be early (and will assume that the fpga
> was programmed by the bootloader).  We want to support that case.
>

Do you have an example where this is really needed?

> > 
> > I have developed a bridge driver, too (which only needs the devicetree binding
> > docu for a v1) and I have a driver+IP core that is directly connected to the
> > bridge. I don't need any messing around with the initcalls to work properly.
> > -EPROBE_DEFER works just fine.
> 
> Is this based on the "proposed fpga bridge framework" that I posted?
> What we are trying to do is update that bridge driver to use the reset driver for 
> submitting v2.

Are you talking about the FPGA manager patches? Then: no.
If not, I seem to have missed the patches.

The driver just probes and then releases the resets for the according bridge.
It shall however support the GPV configuration also (which it doesn't at the moment)

But this reminds me, why I didn't send the driver earlier. IIRC you want to reset
the bridges after writing the bitstream to the FPGA manager.
So, I would need to add that first so you can access that in your fpga manager
driver.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
