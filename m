Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab3HBLup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 07:50:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41131 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab3HBLuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 07:50:44 -0400
Message-ID: <1375444203.4098.11.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v3 6/6] mfd: da9063: add 32 kHz output clock to clock
 tree
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Date: Fri, 02 Aug 2013 13:50:03 +0200
In-Reply-To: <20130729181554.GB9858@sirena.org.uk>
References: <1375117247-6376-1-git-send-email-p.zabel@pengutronix.de>
	 <1375117247-6376-7-git-send-email-p.zabel@pengutronix.de>
	 <20130729181554.GB9858@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 29.07.2013, 19:15 +0100 schrieb Mark Brown:
> On Mon, Jul 29, 2013 at 07:00:47PM +0200, Philipp Zabel wrote:
> 
> > +	clk = devm_clk_register(da9063->dev, &out_32k->clk_hw);
> > +	if (IS_ERR(clk))
> > +		return PTR_ERR(clk);
> > +
> 
> This introduces a dependency on COMMON_CLK.  It might be best to make
> this a function device in drivers/clk, and for something like this we
> really ought to be able to create regmap helpers though that can be done
> later on.

If we just add regmap variants of the current basic clocks (think
clk_gate_regmap etc.) there wouldn't be much code left for this function
device. I'll drop the clock part for now and reintroduce it after we
have some helpers.

regards
Philipp

