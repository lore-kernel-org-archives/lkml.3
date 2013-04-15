Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab3DORGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 13:06:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:20473 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab3DORGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 13:06:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,476,1363158000"; 
   d="scan'208";a="286400133"
Date: Mon, 15 Apr 2013 22:06:18 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 0/5] dmaengine: add ACPI DMA helpers and use them in
 dw_dmac
Message-ID: <20130415163618.GF12436@intel.com>
References: <1365505547-10552-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365505547-10552-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 02:05:42PM +0300, Andy Shevchenko wrote:
> There is a patch series which introduces ACPI DMA helpers in similar way like
> we have for DeviceTree.
> 
> In addition it applies this to the first user, namely dw_dmac driver.
Applied w/o 3 & 5.2 they failed, can you pls rebase and resend

--
~Vinod
> 
> Since v1:
>  - address one Vinod's comment
>  - replace 5/6 & 6/6 by 5/5 from Rafael
>  - tested on Intel Lynxpoint system
> 
> Andy Shevchenko (4):
>   dma: acpi-dma: introduce ACPI DMA helpers
>   dmaengine: call acpi_dma_request_slave_channel as well
>   dma: acpi-dma: parse CSRT to extract additional resources
>   dw_dmac: add ACPI support
> 
> Rafael J. Wysocki (1):
>   ACPI / LPSS: add support of shared clock
> 
>  Documentation/acpi/enumeration.txt     |  77 ++++++
>  drivers/acpi/Makefile                  |   1 -
>  drivers/acpi/acpi_lpss.c               |  26 +-
>  drivers/acpi/csrt.c                    | 159 ------------
>  drivers/acpi/internal.h                |   1 -
>  drivers/acpi/scan.c                    |   1 -
>  drivers/clk/x86/clk-lpt.c              |  15 +-
>  drivers/dma/Kconfig                    |   4 +
>  drivers/dma/Makefile                   |   1 +
>  drivers/dma/acpi-dma.c                 | 445 +++++++++++++++++++++++++++++++++
>  drivers/dma/dmaengine.c                |   6 +
>  drivers/dma/dw_dmac.c                  |  68 +++--
>  drivers/dma/dw_dmac_regs.h             |   1 -
>  include/linux/acpi_dma.h               | 120 +++++++++
>  include/linux/platform_data/clk-lpss.h |   5 +
>  15 files changed, 741 insertions(+), 189 deletions(-)
>  delete mode 100644 drivers/acpi/csrt.c
>  create mode 100644 drivers/dma/acpi-dma.c
>  create mode 100644 include/linux/acpi_dma.h
> 
> -- 
> 1.8.2.rc0.22.gb3600c3
> 
