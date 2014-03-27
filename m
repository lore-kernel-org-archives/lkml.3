Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbaC0KvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 06:51:16 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:19283
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754967AbaC0KvM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 06:51:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz98dIc89bh146fI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzzz2dh2a8h839h93fhd25hd2bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1de2h1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
Date: Thu, 27 Mar 2014 17:59:58 +0800
From: Huang Shijie <b32955@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Fabio Estevam <fabio.estevam@freescale.com>,
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
Message-ID: <20140327095956.GA29623@localhost>
References: <532BCFCC.4080205@freescale.com>
 <1395399017-19005-1-git-send-email-LW@KARO-electronics.de>
 <20140324095902.GB11377@localhost>
 <20140326095156.3e5585b8@ipc1.ka-ro>
 <5332AEE7.2040402@freescale.com>
 <20140326125502.0e8d0657@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140326125502.0e8d0657@ipc1.ka-ro>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 12:55:02PM +0100, Lothar Waßmann wrote:
> Hi,
> 
> Huang Shijie wrote:
> > 于 2014年03月26日 16:51, Lothar Waßmann 写道:
> > > I don't see why this should not be supported on i.MX28 (i.MX23 doesn't
> > > do byteswapping anyway, so this wouldn't change anything for i.MX23).
> > > The partitions used by Linux need not necessarily be accessible for the
> > > Boot ROM code (and vice versa).
> > But the first partition used to store the u-boot is accessible for the ROM.
> > 
> Whether this partition is available to Linux depends on the partition table
> passed in the DT.
yes, i agree.

But it is strange if we do not export this partition to Linux.

> 
> > Please see "Figure 12-13" in the 12.12.1.12:
> >    "In order to preserve the BI (bad block information), flash updater 
> > or gang programmer
> > applications need to swap Bad Block Information (BI) data to byte 0 of 
> > metadata area for
> > every page before programming NAND Flash. ROM when loading firmware, 
> > copies back
> > the value at metadata[0] to BI offset in page data. The following figure 
> > shows how the
> > factory bad block marker is preserved."
> > 
> The inspection of the BB markers is only a fallback for the case that
> there is no DBBT. From the same chapter that you quoted above:
> | ROM uses DBBT to skip any bad block that falls within firmware data
> | on NAND Flash device.
> | If the address of DBBT Search Area in FCB is 0, ROM will rely on
> | factory marked bad block markers to find out if a block is good or bad.
> 
> Thus, even the boot ROM of i.MX28 can well live without blockmark
> swapping.

Assume that there is a NAND block "A",  and the A consist of 256 pages.
the uboot is burned to the "A", can occupy 6 pages:

  -----------------------------------------------------------------------------
 | page 0 |  page 1 | page 2 | page 3 | page 4 | page 5 | ... | ... | page 255 |
  -----------------------------------------------------------------------------
 
  \-------------------------------------- ------------------------------------/
                                         V  
                                        "A"					 

The DBBT is used to track if "A" is bad or not.
Assume we know that "A" is a good block, ROM then need to read out the uboot.
When the ROM needs to read out the 6 pages one by one. And each time the ROM read
the page, it should do the swapping for this page.

In this case, the ROM will do the swapping six times.

Please read the sector again, you will see the "every page" in it:
--------------------------------------------------------------------
   "In order to preserve the BI (bad block information), flash updater 
or gang programmer applications need to swap Bad Block Information (BI) data to byte 0 of 
metadata area for every page before programming NAND Flash. ROM when loading firmware, 
copies back
--------------------------------------------------------------------

thanks
Huang Shijie

