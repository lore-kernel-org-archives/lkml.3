Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaETNxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:53:06 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:48679 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaETNxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:53:04 -0400
Date: Tue, 20 May 2014 15:49:42 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, linux-ide@vger.kernel.org,
        alexandre.belloni@free-electrons.com, jszhang@marvell.com,
        tj@kernel.org, linux-arm-kernel@lists.infradead.org,
        sebastian.hesselbarth@gmail.com
Subject: Re: [PATCH v4 1/7] phy: add a driver for the Berlin SATA PHY
Message-ID: <20140520134942.GC9873@lunn.ch>
References: <1400576675-25265-1-git-send-email-antoine.tenart@free-electrons.com>
 <1400576675-25265-2-git-send-email-antoine.tenart@free-electrons.com>
 <1821771.zFvTDGF2Ae@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1821771.zFvTDGF2Ae@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 02:34:20PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> Few minor issues below..
> 
> On Tuesday, May 20, 2014 11:04:29 AM Antoine Ténart wrote:
> > The Berlin SoC has a two SATA ports. Add a PHY driver to handle them.
> > 
> > The mode selection can let us think this PHY can be configured to fit
> > other purposes. But there are reasons to think the SATA mode will be
> > the only one usable: the PHY registers are only accessible indirectly
> > through two registers in the SATA range, the PHY seems to be integrated
> > and no information tells us the contrary. For these reasons, make the
> > driver a SATA PHY driver.
> > 
> > Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> > ---
> >  drivers/phy/Kconfig           |   5 +
> >  drivers/phy/Makefile          |   1 +
> >  drivers/phy/phy-berlin-sata.c | 230 ++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 236 insertions(+)
> >  create mode 100644 drivers/phy/phy-berlin-sata.c
> > 
> > diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> > index 4906c27fa3bd..b31b1986fda4 100644
> > --- a/drivers/phy/Kconfig
> > +++ b/drivers/phy/Kconfig
> > @@ -15,6 +15,11 @@ config GENERIC_PHY
> >  	  phy users can obtain reference to the PHY. All the users of this
> >  	  framework should select this config.
> >  
> > +config PHY_BERLIN_SATA
> > +	bool
> 
> Is there any real reason why this cannot be tristate?

What we have seen with SATA drivers and phys, is there is link time
breakage if the SATA driver is built in and the phy is modular.

Maybe this has been fixed now? 
 
	Andrew
