Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab3GWJIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:08:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59831 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab3GWJI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:08:28 -0400
Date: Tue, 23 Jul 2013 11:08:20 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [alsa-devel] [PATCH v3] ARM: kirkwood: extend the kirkwood i2s
 driver for	DT usage
Message-ID: <20130723090820.GN9434@pengutronix.de>
References: <20130723104615.3696f1a9@armhf>
 <20130723085346.GQ24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130723085346.GQ24642@n2100.arm.linux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:00:50 up 39 days, 21:11, 27 users,  load average: 0.09, 0.06,
 0.05
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 09:53:46AM +0100, Russell King - ARM Linux wrote:
> On Tue, Jul 23, 2013 at 10:46:15AM +0200, Jean-Francois Moine wrote:
> > The kirkwood i2s driver is used without DT in the Kirkwood machine.
> > This patch adds a DT compatible definition for use in other Marvell
> > machines as the Armada 88AP510 (Dove).
> 
> Yet again, this illustrates why converting to DT causes backwards
> steps in drivers: the conversion of devm_clk_get() to of_clk_get()
> necessitates a clk_put().
> 
> Can someone please provide a devm_of_clk_get() function before we
> accept any more patches doing this kind of thing?

The question is why isn't regular [devm_]clk_get used here? I don't know
what the Marvell stuff is doing here, but if the clk stuff is
implemented correctly then

	np = pdev->dev.of_node;
	priv->clk = of_clk_get(np, 0);

and

	devm_clk_get(&pdev->dev, "label");

should both work

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
