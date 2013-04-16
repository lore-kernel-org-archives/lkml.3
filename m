Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab3DPMPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 08:15:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:41936 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab3DPMPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 08:15:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,485,1363158000"; 
   d="scan'208";a="323048888"
Message-ID: <1366114487.7932.29.camel@smile>
Subject: Re: [PATCH v2 0/5] dmaengine: add ACPI DMA helpers and use them in
 dw_dmac
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, linux-acpi@vger.kernel.org
Date: Tue, 16 Apr 2013 15:14:47 +0300
In-Reply-To: <20130415163618.GF12436@intel.com>
References: <1365505547-10552-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20130415163618.GF12436@intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 22:06 +0530, Vinod Koul wrote: 
> On Tue, Apr 09, 2013 at 02:05:42PM +0300, Andy Shevchenko wrote:
> > There is a patch series which introduces ACPI DMA helpers in similar way like
> > we have for DeviceTree.
> > 
> > In addition it applies this to the first user, namely dw_dmac driver.
> Applied w/o 3 & 5.2 they failed, can you pls rebase and resend
> 

Actually those two (at least 5/5) can't be applied on top of slave-dma.
The patches requires slave-dma and linux-pm together. I heard it's
usually achieved by creating a specific branch in one subsystem
(linux-pm in our case) for another.

Rafael, what could we do here?

> --
> ~Vinod
> > 
> > Since v1:
> >  - address one Vinod's comment
> >  - replace 5/6 & 6/6 by 5/5 from Rafael
> >  - tested on Intel Lynxpoint system
> > 
> > Andy Shevchenko (4):
> >   dma: acpi-dma: introduce ACPI DMA helpers
> >   dmaengine: call acpi_dma_request_slave_channel as well
> >   dma: acpi-dma: parse CSRT to extract additional resources
> >   dw_dmac: add ACPI support
> > 
> > Rafael J. Wysocki (1):
> >   ACPI / LPSS: add support of shared clock
> > 
> >  Documentation/acpi/enumeration.txt     |  77 ++++++
> >  drivers/acpi/Makefile                  |   1 -
> >  drivers/acpi/acpi_lpss.c               |  26 +-
> >  drivers/acpi/csrt.c                    | 159 ------------
> >  drivers/acpi/internal.h                |   1 -
> >  drivers/acpi/scan.c                    |   1 -
> >  drivers/clk/x86/clk-lpt.c              |  15 +-
> >  drivers/dma/Kconfig                    |   4 +
> >  drivers/dma/Makefile                   |   1 +
> >  drivers/dma/acpi-dma.c                 | 445 +++++++++++++++++++++++++++++++++
> >  drivers/dma/dmaengine.c                |   6 +
> >  drivers/dma/dw_dmac.c                  |  68 +++--
> >  drivers/dma/dw_dmac_regs.h             |   1 -
> >  include/linux/acpi_dma.h               | 120 +++++++++
> >  include/linux/platform_data/clk-lpss.h |   5 +
> >  15 files changed, 741 insertions(+), 189 deletions(-)
> >  delete mode 100644 drivers/acpi/csrt.c
> >  create mode 100644 drivers/dma/acpi-dma.c
> >  create mode 100644 include/linux/acpi_dma.h
> > 
> > -- 
> > 1.8.2.rc0.22.gb3600c3
> > 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
