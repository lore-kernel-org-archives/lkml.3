Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbaAIHz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 02:55:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35897 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaAIHz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 02:55:56 -0500
Date: Thu, 9 Jan 2014 08:55:26 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Nicolin Chen <Guangyu.Chen@freescale.com>
Cc: shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, rob@landley.net, mturquette@linaro.org
Subject: Re: [PATCH] ARM: imx6q: Add missing esai_ahb clock to current clock
 tree
Message-ID: <20140109075525.GO6750@pengutronix.de>
Mail-Followup-To: Nicolin Chen <Guangyu.Chen@freescale.com>,
	shawn.guo@linaro.org, kernel@pengutronix.de, linux@arm.linux.org.uk,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	devicetree@vger.kernel.org, rob@landley.net, mturquette@linaro.org
References: <1389236699-10387-1-git-send-email-Guangyu.Chen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389236699-10387-1-git-send-email-Guangyu.Chen@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:51:38 up 137 days, 17:22, 49 users,  load average: 0.13, 0.11,
 0.07
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added Mike Turquette to Cc]

On Thu, Jan 09, 2014 at 11:04:59AM +0800, Nicolin Chen wrote:
> esai_ahb clock is derived from ahb and used to provide ESAI the capability of
> register accessing and FSYS clock source for I2S clocks dividing. Although the
> gate of this esai_ahb is duplicated with esai clock -- the baud clock, yet
> considering about the differences of their clock rates, it's quite essential
> to patch this missing clock.
> 

[...]

>  static struct clk *clk[clk_max];
> @@ -355,6 +355,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
>  	clk[ecspi5]       = imx_clk_gate2("ecspi5",        "ecspi_root",        base + 0x6c, 8);
>  	clk[enet]         = imx_clk_gate2("enet",          "ipg",               base + 0x6c, 10);
>  	clk[esai]         = imx_clk_gate2("esai",          "esai_podf",         base + 0x6c, 16);
> +	clk[esai_ahb]     = imx_clk_gate2("esai_ahb",      "ahb",               base + 0x6c, 16);

We have the situation here that a single bit controls two clocks. As
Shawn mentioned just using two gates on the same bit doesn't work
properly. Do we need a new basic clock type or expand the common gate
code somehow?
This situation happens from time to time and I haven't seen a solution
for this.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
