Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab3DONuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 09:50:55 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:49748 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3DONux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 09:50:53 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v9 RESEND 2/4] misc: Generic on-chip SRAM allocation driver
To: Andrew Morton <akpm@linux-foundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>, Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <20130327152723.723cd65e884413df405abe2d@linux-foundation.org>
References: <1363776767-2635-1-git-send-email-p.zabel@pengutronix.de> <1363776767-2635-3-git-send-email-p.zabel@pengutronix.de> <20130327152723.723cd65e884413df405abe2d@linux-foundation.org>
Date: Mon, 15 Apr 2013 14:50:47 +0100
Message-Id: <20130415135047.315D43E0AA8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013 15:27:23 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 20 Mar 2013 11:52:45 +0100 Philipp Zabel <p.zabel@pengutronix.de> wrote:
> 
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
> >  Documentation/devicetree/bindings/misc/sram.txt |   16 +++
> >  drivers/misc/Kconfig                            |    9 ++
> >  drivers/misc/Makefile                           |    1 +
> >  drivers/misc/sram.c                             |  121 +++++++++++++++++++++++
> 
> drivers/misc/sram.c is a pretty generic-sounding thing.  Is it really
> Linux's One True SRAM driver?  How many different sorts of sram devices
> do we expect this can be used with?  If I don't use DT?
> 
> In other words, perhaps this should have a more specific and accurate
> name?

Well, it is SRAM. Not a whole lot of variation there, and all the driver
does is allow bits of it to be carved up so that multiple device drivers
don't step on each other's toes. I think that is pretty generic. If
some SRAM comes along that is sufficiently different that it requires a
different driver, then I'm pretty confident saying it would be the
oddball, not this driver, and so would need the more specific name.

All the users at the moment are DT platforms. When a non-DT user comes
along, it won't be a problem to add a non-DT binding. In the mean time I
wouldn't borrow trouble about it.

g.
