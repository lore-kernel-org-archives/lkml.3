Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaDZDKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 23:10:31 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:52977 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaDZDKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 23:10:30 -0400
Date: Sat, 26 Apr 2014 11:10:13 +0800
From: Huang Shijie <shijie8@gmail.com>
To: Marek Vasut <marex@denx.de>
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
Subject: Re: [PATCH V3] Add support for flag status register on Micron chips.
Message-ID: <20140426031011.GA4811@localhost.localdomain>
References: <1398175396-7560-1-git-send-email-grmoore@altera.com>
 <201404250442.33197.marex@denx.de>
 <20140425015245.GB24530@localhost>
 <201404260012.24311.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201404260012.24311.marex@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 12:12:24AM +0200, Marek Vasut wrote:
> > > > the drivers may fills this hook itself, so the code should like this:
> > > >    --------------------------------------------------
> > > > 	
> > > > 	if ((info->flags & USE_FSR) &&
> > > > 	
> > > > 	       	nor->wait_till_ready == spi_nor_wait_till_fsr_ready)
> > > > 		
> > > > 		nor->wait_till_ready = spi_nor_wait_till_fsr_ready;
> > > > 		
> > > >    --------------------------------------------------
> > > 
> > > I sense a misdesign of the SPI NOR subsystem here. The subsystem and the
> > > driver compete for a function pointer here ? I guess one should have
> > > precedence in some way then ... and also, they should be two different
> > > pointers, where the subsystem decides which to use.
> > 
> > the subsystem do not decides which one to use, the driver decides which one
> > to use.
> > 
> > If driver has its own @wait_till_ready , it means the driver knows the
> > feature, and has implemented it in its own @wait_till_ready.
> > 
> > If the driver does not fill any wait_till_ready, it means the driver will
> > use the default @wait_till_ready. We can treat the
> > spi_nor_wait_till_fsr_ready as a default hook too.
> 
> I see the driver overwriting a hook previously set by the subsystem. This 
not sure ;)

The driver set the hooks before the subsystem set these hooks.

If the driver has already set the @wait_till_ready hook before it calls
the spi_nor_scan, the subsystem will not set the hook anymore.

Please see the spi_nor_check().

thanks
Huang Shijie


