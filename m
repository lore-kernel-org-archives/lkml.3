Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbaC1JBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 05:01:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51112 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaC1JBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 05:01:01 -0400
Date: Fri, 28 Mar 2014 10:00:23 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Huang Shijie <b32955@freescale.com>
Cc: Lothar =?iso-8859-15?Q?Wa=DFmann?= <LW@KARO-electronics.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mtd@lists.infradead.org, Shawn Guo <shawn.guo@freescale.com>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 1/1] mtd: gpmi: make blockmark swapping optional
Message-ID: <20140328090023.GB17250@pengutronix.de>
References: <1395399017-19005-1-git-send-email-LW@KARO-electronics.de>
 <20140324095902.GB11377@localhost>
 <20140326095156.3e5585b8@ipc1.ka-ro>
 <5332AEE7.2040402@freescale.com>
 <20140326125502.0e8d0657@ipc1.ka-ro>
 <20140327095956.GA29623@localhost>
 <20140327132109.06258526@ipc1.ka-ro>
 <5334D9F7.2030001@freescale.com>
 <20140328091646.1ce03f90@ipc1.ka-ro>
 <53353524.9020605@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53353524.9020605@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:52:31 up 215 days, 18:23, 42 users,  load average: 0.20, 0.13,
 0.14
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 04:39:00PM +0800, Huang Shijie wrote:
> 于 2014年03月28日 16:16, Lothar Waßmann 写道:
> >Still there is no need for the Linux NAND driver to be able to read or
> >write partitions in a format that the Boot ROM can understand. Thus it
> If you do not use the NAND boot, there really no need to do so.
> 
> Since you need the NAND boot, we should enable the swapping for imx28.
> >is perfectly legal to allow disregarding the BB marks and solely rely on
> >a flash based BBT.
> >
> The BB mark is in the page 0 of a NAND block. But the swapping can
> occur in _each_ page of
> a NAND block, _NOT_ only the page 0.
> 
> I think you are confusing at these two things.

I think you are confusing two things. If Lothar:

- disables swapping of BB marks in the FCB the ROM won't swap bytes.
- writes data without swapping
- Uses a DBBT for telling the ROM code where bad blocks are
- uses a Flash BBT for mtd

Then everything should work just fine.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
