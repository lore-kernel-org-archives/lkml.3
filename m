Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaD1FGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 01:06:30 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:60789 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaD1FG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 01:06:28 -0400
X-Auth-Info: QYhMsmobO+Z+3XLFFOkg8aPcJ+/bma+KCwLdZkjeCk4=
From: Marek Vasut <marex@denx.de>
To: Huang Shijie <shijie8@gmail.com>
Subject: Re: [PATCH V3] Add support for flag status register on Micron chips.
Date: Mon, 28 Apr 2014 07:06:17 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: Huang Shijie <b32955@freescale.com>, Graham Moore <grmoore@altera.com>,
        ggrahammoore@gmail.com,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        linux-mtd@lists.infradead.org, Insop Song <insop.song@gainspeed.com>,
        Alan Tull <atull@altera.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dinh Nguyen <dinguyen@altera.com>
References: <1398175396-7560-1-git-send-email-grmoore@altera.com> <201404260012.24311.marex@denx.de> <20140426031011.GA4811@localhost.localdomain>
In-Reply-To: <20140426031011.GA4811@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404280706.18068.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, April 26, 2014 at 05:10:13 AM, Huang Shijie wrote:
> On Sat, Apr 26, 2014 at 12:12:24AM +0200, Marek Vasut wrote:
> > > > > the drivers may fills this hook itself, so the code should like this:
> > > > >    --------------------------------------------------
> > > > > 	
> > > > > 	if ((info->flags & USE_FSR) &&
> > > > > 	
> > > > > 	       	nor->wait_till_ready == spi_nor_wait_till_fsr_ready)
> > > > > 		
> > > > > 		nor->wait_till_ready = spi_nor_wait_till_fsr_ready;
> > > > > 		
> > > > >    --------------------------------------------------
> > > > 
> > > > I sense a misdesign of the SPI NOR subsystem here. The subsystem and
> > > > the driver compete for a function pointer here ? I guess one should
> > > > have precedence in some way then ... and also, they should be two
> > > > different pointers, where the subsystem decides which to use.
> > > 
> > > the subsystem do not decides which one to use, the driver decides which
> > > one to use.
> > > 
> > > If driver has its own @wait_till_ready , it means the driver knows the
> > > feature, and has implemented it in its own @wait_till_ready.
> > > 
> > > If the driver does not fill any wait_till_ready, it means the driver
> > > will use the default @wait_till_ready. We can treat the
> > > spi_nor_wait_till_fsr_ready as a default hook too.
> > 
> > I see the driver overwriting a hook previously set by the subsystem. This
> 
> not sure ;)
> 
> The driver set the hooks before the subsystem set these hooks.
> 
> If the driver has already set the @wait_till_ready hook before it calls
> the spi_nor_scan, the subsystem will not set the hook anymore.
> 
> Please see the spi_nor_check().

Two things competing over the same pointer looks misdesigned to me. I will need 
to dig into this one more time ...

Best regards,
Marek Vasut
