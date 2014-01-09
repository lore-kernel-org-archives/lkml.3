Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760AbaAIH6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 02:58:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54839 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaAIH6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 02:58:51 -0500
Date: Thu, 9 Jan 2014 08:58:28 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, kernel@pengutronix.de,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, rob@landley.net
Subject: Re: [PATCH] ARM: imx6q: Add missing esai_ahb clock to current clock
 tree
Message-ID: <20140109075827.GP6750@pengutronix.de>
Mail-Followup-To: Nicolin Chen <Guangyu.Chen@freescale.com>,
	Shawn Guo <shawn.guo@linaro.org>, kernel@pengutronix.de,
	linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	devicetree@vger.kernel.org, rob@landley.net
References: <1389236699-10387-1-git-send-email-Guangyu.Chen@freescale.com>
 <20140109035810.GB21717@S2101-09.ap.freescale.net>
 <20140109034940.GA14480@MrMyself>
 <20140109065740.GD21717@S2101-09.ap.freescale.net>
 <20140109074137.GA14809@MrMyself>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109074137.GA14809@MrMyself>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:55:48 up 137 days, 17:26, 49 users,  load average: 0.21, 0.17,
 0.10
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 03:41:38PM +0800, Nicolin Chen wrote:
> On Thu, Jan 09, 2014 at 02:57:42PM +0800, Shawn Guo wrote:
> > On Thu, Jan 09, 2014 at 11:49:41AM +0800, Nicolin Chen wrote:
> > > On Thu, Jan 09, 2014 at 11:58:12AM +0800, Shawn Guo wrote:
> > > > >  static struct clk *clk[clk_max];
> > > > > @@ -355,6 +355,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
> > > > >  	clk[ecspi5]       = imx_clk_gate2("ecspi5",        "ecspi_root",        base + 0x6c, 8);
> > > > >  	clk[enet]         = imx_clk_gate2("enet",          "ipg",               base + 0x6c, 10);
> > > > >  	clk[esai]         = imx_clk_gate2("esai",          "esai_podf",         base + 0x6c, 16);
> > > > > +	clk[esai_ahb]     = imx_clk_gate2("esai_ahb",      "ahb",               base + 0x6c, 16);
> > > > 
> > > > Hmm, having two clocks operating on the same gate bit will get us
> > > > problem in clock disabling.  Clock enabling is fine, since either
> > > > one who calls clk_enable() first will just set the gate bit.  But in
> > > > case that clk_enable() is called on both clocks, and then when either
> > > > clock calls clk_disable(), the gate bit will be cleared and thus breaks
> > > > the other one that might still be in use.
> > > 
> > > Understood. But how could we handle this situation? The only way I can figure
> > > out is to make sure the driver open/close them at the same time, it's not a
> > > perfect way though.
> > 
> > Hmm, we generally leave the gate bit to the clock used to access
> > register, because usually it's the first one to be on and the last one
> > to be off.
> 
> Then we should attach CLK_IGNORE_UNUSED to clk[esai] since clk[esai_ahb] is
> the clock used to access memory, shouldn't we?

Please wait for Mikes input or let's look how a proper solution can look
like. I've already seen the case that a single bit controls multiple
clocks. Hacking around this issue each time is not a solution.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
