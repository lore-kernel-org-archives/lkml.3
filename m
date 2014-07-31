Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbaGaHXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 03:23:24 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57053 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbaGaHXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 03:23:22 -0400
Date: Thu, 31 Jul 2014 00:23:17 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        michal.simek@xilinx.com, grant.likely@linaro.org,
        gregkh@linuxfoundation.org, jason@lakedaemon.net,
        ezequiel.garcia@free-electrons.com, arnd@arndb.de, dwmw2@infradead.org,
        artem.bityutskiy@linux.intel.com, pekon@ti.com, jussi.kivilinna@iki.fi,
        acourbot@nvidia.com, ivan.khoronzhuk@ti.com, joern@logfs.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        kpc528@gmail.com, kalluripunnaiahchoudary@gmail.com,
        anirudh@xilinx.com, svemula@xilinx.com,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: Re: [PATCH RFC v4 3/4] nand: pl353: Add ONDIE ECC support
Message-ID: <20140731072317.GI11952@brian-ubuntu>
References: <1406561500-18264-1-git-send-email-punnaia@xilinx.com>
 <27fce982-6598-44a0-ad80-c13d02a952ee@BN1AFFO11FD042.protection.gbl>
 <20140731070643.GG11952@brian-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731070643.GG11952@brian-ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 12:06:43AM -0700, Brian Norris wrote:
> On Mon, Jul 28, 2014 at 09:01:39PM +0530, Punnaiah Choudary Kalluri wrote:
> > +/* Generic flash bbt decriptors */
> > +static uint8_t bbt_pattern[] = { 'B', 'b', 't', '0' };
> > +static uint8_t mirror_pattern[] = { '1', 't', 'b', 'B' };
> > +
> > +static struct nand_bbt_descr bbt_main_descr = {
> > +	.options = NAND_BBT_LASTBLOCK | NAND_BBT_CREATE | NAND_BBT_WRITE
> > +		| NAND_BBT_2BIT | NAND_BBT_VERSION | NAND_BBT_PERCHIP,
> > +	.offs = 4,
> > +	.len = 4,
> > +	.veroffs = 20,
> > +	.maxblocks = 4,
> > +	.pattern = bbt_pattern
> > +};
> > +
> > +static struct nand_bbt_descr bbt_mirror_descr = {
> > +	.options = NAND_BBT_LASTBLOCK | NAND_BBT_CREATE | NAND_BBT_WRITE
> > +		| NAND_BBT_2BIT | NAND_BBT_VERSION | NAND_BBT_PERCHIP,
> > +	.offs = 4,
> > +	.len = 4,
> > +	.veroffs = 20,
> > +	.maxblocks = 4,
> > +	.pattern = mirror_pattern
> > +};
> 
> Why do you need a custom BBT descriptor? It's much better to use the
> standard ones. Perhaps you just want the NAND_BBT_NO_OOB_BBM option, so
> you get the bbt_{main,mirror}_no_oob_descr structs from nand_bbt.c.

I see you answered this:

 http://lists.infradead.org/pipermail/linux-mtd/2014-April/053451.html

That's unfortunate.

Brian
