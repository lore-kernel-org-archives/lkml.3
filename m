Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164Ab3DPSEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:04:11 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34491 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936039Ab3DPSEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:04:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 0/5] dmaengine: add ACPI DMA helpers and use them in dw_dmac
Date: Tue, 16 Apr 2013 20:11:57 +0200
Message-ID: <1525811.597RVDyDxu@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc6+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1366114487.7932.29.camel@smile>
References: <1365505547-10552-1-git-send-email-andriy.shevchenko@linux.intel.com> <20130415163618.GF12436@intel.com> <1366114487.7932.29.camel@smile>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 16, 2013 03:14:47 PM Andy Shevchenko wrote:
> On Mon, 2013-04-15 at 22:06 +0530, Vinod Koul wrote: 
> > On Tue, Apr 09, 2013 at 02:05:42PM +0300, Andy Shevchenko wrote:
> > > There is a patch series which introduces ACPI DMA helpers in similar way like
> > > we have for DeviceTree.
> > > 
> > > In addition it applies this to the first user, namely dw_dmac driver.
> > Applied w/o 3 & 5.2 they failed, can you pls rebase and resend
> > 
> 
> Actually those two (at least 5/5) can't be applied on top of slave-dma.
> The patches requires slave-dma and linux-pm together. I heard it's
> usually achieved by creating a specific branch in one subsystem
> (linux-pm in our case) for another.
> 
> Rafael, what could we do here?

I suppose Vinod can pull from my acpi-lpss (which is guaranteed not to be
rebased at this point) and apply the series on top of that.

Thanks,
Rafael


> > > Since v1:
> > >  - address one Vinod's comment
> > >  - replace 5/6 & 6/6 by 5/5 from Rafael
> > >  - tested on Intel Lynxpoint system
> > > 
> > > Andy Shevchenko (4):
> > >   dma: acpi-dma: introduce ACPI DMA helpers
> > >   dmaengine: call acpi_dma_request_slave_channel as well
> > >   dma: acpi-dma: parse CSRT to extract additional resources
> > >   dw_dmac: add ACPI support
> > > 
> > > Rafael J. Wysocki (1):
> > >   ACPI / LPSS: add support of shared clock
> > > 
> > >  Documentation/acpi/enumeration.txt     |  77 ++++++
> > >  drivers/acpi/Makefile                  |   1 -
> > >  drivers/acpi/acpi_lpss.c               |  26 +-
> > >  drivers/acpi/csrt.c                    | 159 ------------
> > >  drivers/acpi/internal.h                |   1 -
> > >  drivers/acpi/scan.c                    |   1 -
> > >  drivers/clk/x86/clk-lpt.c              |  15 +-
> > >  drivers/dma/Kconfig                    |   4 +
> > >  drivers/dma/Makefile                   |   1 +
> > >  drivers/dma/acpi-dma.c                 | 445 +++++++++++++++++++++++++++++++++
> > >  drivers/dma/dmaengine.c                |   6 +
> > >  drivers/dma/dw_dmac.c                  |  68 +++--
> > >  drivers/dma/dw_dmac_regs.h             |   1 -
> > >  include/linux/acpi_dma.h               | 120 +++++++++
> > >  include/linux/platform_data/clk-lpss.h |   5 +
> > >  15 files changed, 741 insertions(+), 189 deletions(-)
> > >  delete mode 100644 drivers/acpi/csrt.c
> > >  create mode 100644 drivers/dma/acpi-dma.c
> > >  create mode 100644 include/linux/acpi_dma.h
> > > 
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
