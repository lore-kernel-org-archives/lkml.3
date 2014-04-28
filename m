Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaD1IEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 04:04:35 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:21425
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752766AbaD1IE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 04:04:28 -0400
Date: Mon, 28 Apr 2014 15:06:08 +0800
From: Huang Shijie <b32955@freescale.com>
To: Marek Vasut <marex@denx.de>
CC: Huang Shijie <shijie8@gmail.com>, Graham Moore <grmoore@altera.com>,
        <ggrahammoore@gmail.com>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, <linux-kernel@vger.kernel.org>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        <linux-mtd@lists.infradead.org>, Insop Song <insop.song@gainspeed.com>,
        Alan Tull <atull@altera.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Brian Norris <computersforpeace@gmail.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH V3] Add support for flag status register on Micron
 chips.
Message-ID: <20140428070602.GA29525@localhost>
References: <1398175396-7560-1-git-send-email-grmoore@altera.com>
 <201404260012.24311.marex@denx.de>
 <20140426031011.GA4811@localhost.localdomain>
 <201404280706.18068.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201404280706.18068.marex@denx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(24454002)(189002)(377454003)(51704005)(4396001)(33716001)(74502001)(92726001)(74662001)(85852003)(83072002)(101416001)(46102001)(76482001)(77982001)(80022001)(83322001)(6806004)(87936001)(44976005)(80976001)(57986002)(23726002)(79102001)(77096999)(47776003)(99396002)(76176999)(50986999)(20776003)(97756001)(54356999)(81342001)(46406003)(81542001)(42262001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB027;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:gate-tx3.freescale.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 01952C6E96
Authentication-Results: spf=none (sender IP is 192.88.168.1)
 smtp.mailfrom=shijie.huang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 07:06:17AM +0200, Marek Vasut wrote:
> On Saturday, April 26, 2014 at 05:10:13 AM, Huang Shijie wrote:
> > On Sat, Apr 26, 2014 at 12:12:24AM +0200, Marek Vasut wrote:
> > > > > > the drivers may fills this hook itself, so the code should like this:
> > > > > >    --------------------------------------------------
> > > > > > 	
> > > > > > 	if ((info->flags & USE_FSR) &&
> > > > > > 	
> > > > > > 	       	nor->wait_till_ready == spi_nor_wait_till_fsr_ready)
> > > > > > 		
> > > > > > 		nor->wait_till_ready = spi_nor_wait_till_fsr_ready;
> > > > > > 		
> > > > > >    --------------------------------------------------
> > > > > 
> > > > > I sense a misdesign of the SPI NOR subsystem here. The subsystem and
> > > > > the driver compete for a function pointer here ? I guess one should
> > > > > have precedence in some way then ... and also, they should be two
> > > > > different pointers, where the subsystem decides which to use.
> > > > 
> > > > the subsystem do not decides which one to use, the driver decides which
> > > > one to use.
> > > > 
> > > > If driver has its own @wait_till_ready , it means the driver knows the
> > > > feature, and has implemented it in its own @wait_till_ready.
> > > > 
> > > > If the driver does not fill any wait_till_ready, it means the driver
> > > > will use the default @wait_till_ready. We can treat the
> > > > spi_nor_wait_till_fsr_ready as a default hook too.
> > > 
> > > I see the driver overwriting a hook previously set by the subsystem. This
> > 
> > not sure ;)
> > 
> > The driver set the hooks before the subsystem set these hooks.
> > 
> > If the driver has already set the @wait_till_ready hook before it calls
> > the spi_nor_scan, the subsystem will not set the hook anymore.
> > 
> > Please see the spi_nor_check().
> 
> Two things competing over the same pointer looks misdesigned to me. I will need 
> to dig into this one more time ...
Please refer to the code for NAND chip, the nand_get_flash_type() :

-----------------------------------------------------------
	/* Do not replace user supplied command function! */
	if (mtd->writesize > 512 && chip->cmdfunc == nand_command)
		chip->cmdfunc = nand_command_lp;
-----------------------------------------------------------

It uses the same logic: 
	" Do not replace user supplied command function!"

thanks
Huang Shijie
