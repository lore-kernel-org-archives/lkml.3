Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbaC0MWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 08:22:25 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:54351 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaC0MWW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 08:22:22 -0400
Date: Thu, 27 Mar 2014 13:21:09 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Huang Shijie <b32955@freescale.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Rutland <mark.rutland@arm.com>, Shawn Guo <shawn.guo@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCHv2 1/1] mtd: gpmi: make blockmark swapping optional
Message-ID: <20140327132109.06258526@ipc1.ka-ro>
In-Reply-To: <20140327095956.GA29623@localhost>
References: <532BCFCC.4080205@freescale.com>
	<1395399017-19005-1-git-send-email-LW@KARO-electronics.de>
	<20140324095902.GB11377@localhost>
	<20140326095156.3e5585b8@ipc1.ka-ro>
	<5332AEE7.2040402@freescale.com>
	<20140326125502.0e8d0657@ipc1.ka-ro>
	<20140327095956.GA29623@localhost>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Huang Shijie wrote:
> > > Please see "Figure 12-13" in the 12.12.1.12:
> > >    "In order to preserve the BI (bad block information), flash updater 
> > > or gang programmer
> > > applications need to swap Bad Block Information (BI) data to byte 0 of 
> > > metadata area for
> > > every page before programming NAND Flash. ROM when loading firmware, 
> > > copies back
> > > the value at metadata[0] to BI offset in page data. The following figure 
> > > shows how the
> > > factory bad block marker is preserved."
> > > 
> > The inspection of the BB markers is only a fallback for the case that
> > there is no DBBT. From the same chapter that you quoted above:
> > | ROM uses DBBT to skip any bad block that falls within firmware data
> > | on NAND Flash device.
> > | If the address of DBBT Search Area in FCB is 0, ROM will rely on
> > | factory marked bad block markers to find out if a block is good or bad.
> > 
> > Thus, even the boot ROM of i.MX28 can well live without blockmark
> > swapping.
> 
> Assume that there is a NAND block "A",  and the A consist of 256 pages.
> the uboot is burned to the "A", can occupy 6 pages:
> 
>   -----------------------------------------------------------------------------
>  | page 0 |  page 1 | page 2 | page 3 | page 4 | page 5 | ... | ... | page 255 |
>   -----------------------------------------------------------------------------
>  
>   \-------------------------------------- ------------------------------------/
>                                          V  
>                                         "A"					 
> 
> The DBBT is used to track if "A" is bad or not.
> Assume we know that "A" is a good block, ROM then need to read out the uboot.
> When the ROM needs to read out the 6 pages one by one. And each time the ROM read
> the page, it should do the swapping for this page.
> 
> In this case, the ROM will do the swapping six times.
> 
> Please read the sector again, you will see the "every page" in it:
> --------------------------------------------------------------------
>    "In order to preserve the BI (bad block information), flash updater 
> or gang programmer applications need to swap Bad Block Information (BI) data to byte 0 of 
> metadata area for every page before programming NAND Flash. ROM when loading firmware, 
> copies back
> --------------------------------------------------------------------
>
I can assure you that the >100.000 i.MX28 based modules, that we sold
up to now boot from NAND just fine without any block mark swapping in
the U-Boot pages.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
