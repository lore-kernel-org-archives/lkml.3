Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770Ab3BKSPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 13:15:34 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41082 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758684Ab3BKSPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 13:15:32 -0500
Message-ID: <1360606524.4954.46.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v8 2/4] misc: Generic on-chip SRAM allocation driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Date: Mon, 11 Feb 2013 19:15:24 +0100
In-Reply-To: <20130208201634.B94C83E2C02@localhost>
References: <1359977538-5859-1-git-send-email-p.zabel@pengutronix.de>
	 <1359977538-5859-3-git-send-email-p.zabel@pengutronix.de>
	 <20130208201634.B94C83E2C02@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Am Freitag, den 08.02.2013, 20:16 +0000 schrieb Grant Likely:
> On Mon,  4 Feb 2013 12:32:16 +0100, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > This driver requests and remaps a memory region as configured in the
> > device tree. It serves memory from this region via the genalloc API.
> > It optionally enables the SRAM clock.
> > 
> > Other drivers can retrieve the genalloc pool from a phandle pointing
> > to this drivers' device node in the device tree.
> > 
> > The allocation granularity is hard-coded to 32 bytes for now,
> > to make the SRAM driver useful for the 6502 remoteproc driver.
> > There is overhead for bigger SRAMs, where only a much coarser
> > allocation granularity is needed: At 32 bytes minimum allocation
> > size, a 256 KiB SRAM needs a 1 KiB bitmap to track allocations.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
> > ---
> > Changes since v7:
> >  - Removed obsolete __devinit/__devexit/__devexit_p
> > ---
> >  Documentation/devicetree/bindings/misc/sram.txt |   17 ++++
> >  drivers/misc/Kconfig                            |    9 ++
> >  drivers/misc/Makefile                           |    1 +
> >  drivers/misc/sram.c                             |  121 +++++++++++++++++++++++
> >  4 files changed, 148 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/misc/sram.txt
> >  create mode 100644 drivers/misc/sram.c
> > 
> > diff --git a/Documentation/devicetree/bindings/misc/sram.txt b/Documentation/devicetree/bindings/misc/sram.txt
> > new file mode 100644
> > index 0000000..b64136c
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/misc/sram.txt
> > @@ -0,0 +1,17 @@
> > +Generic on-chip SRAM
> > +
> > +Simple IO memory regions to be managed by the genalloc API.
> > +
> > +Required properties:
> > +
> > +- compatible : sram
> 
> I'm a little concerned that 'sram' is just too generic for a compatible
> value and we may end up needing a blacklist of systems where the sram
> device should not be driven with this driver. If you can think of
> a more descriptive name here then I would use it.

various SoC vendors call this (variations of) "on-chip" or "internal"
SRAM/memory. "on-chip-sram" or "internal-sram" are still plenty generic,
though. How about "mmio-sram", as opposed to an SRAM that needs more
than the simple mmio region handled by this driver?

An alternative would be to use the vendor specific names and grow a
compatible list in the driver ("fsl,ocram", "ti,ocm", ...).

> However, I'm not worried about it enough to nak it and the rest of the
> series looks fine.
> 
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Thank you.

regards
Philipp

