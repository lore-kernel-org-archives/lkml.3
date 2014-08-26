Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990AbaHZP25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 11:28:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:28311 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbaHZP24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 11:28:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,405,1406617200"; 
   d="scan'208";a="581902829"
Message-ID: <1409066845.30155.17.camel@linux.intel.com>
Subject: Re: [PATCH v1 00/12] dmaengine: dw: remove slave_id, add PCI support
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: dmaengine <dmaengine@vger.kernel.org>
Cc: Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Date: Tue, 26 Aug 2014 18:27:25 +0300
In-Reply-To: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-19 at 20:29 +0300, Andy Shevchenko wrote:
> The patchset is targeting two things:
>  - removal of slave_id which is deprecated (suggested by Arnd Bergmann)
>  - support BayTrail and Braswell SoCs in PCI case
> 
> They are tight with each other, thus comes in one series.
> 
> The patch set was BAT tested on Braswell and BayTrail machines.
> 
> We would like to push this through slave-dma tree, so, Mark, Greg,
> Hans-Christian, and Haavard, please, Ack them if you have no objections.

Greg, gently ping you to get your Ack (or comments) on patches 11/12 and
12/12.

> 
> Vinod, we would like them to be pushed during this cycle since we have more
> coming. And it would be nice to have Braswell support in v3.18-rc1.
> 
> Alan Cox (1):
>   serial: 8250_pci: Add PCI IDs for Intel Braswell
> 
> Andy Shevchenko (9):
>   dmaengine: dw: move dw_dmac.h to where it belongs to
>   avr32: at32ap700x: don't rely on default DMA masters
>   dmaengine: dw: convert dw_dma_slave to use explicit HS interfaces
>   dmaengine: dw: apply both HS interfaces and remove slave_id usage
>   dmaengine: dw: introduce generic filter function
>   dmaengine: dw: move clock operations to platform.c
>   dmaengine: dw: add PCI IDs for Braswell DMAs
>   spi/pxa2xx-pci: remove unnecessary assignment
>   serial: 8250: don't use slave_id of dma_slave_config
> 
> Mika Westerberg (2):
>   spi/pxa2xx: Don't use slave_id of dma_slave_config
>   spi/pxa2xx-pci: Add support for Intel Braswell
> 
>  MAINTAINERS                                     |   2 +-
>  arch/avr32/mach-at32ap/at32ap700x.c             |  19 ++--
>  arch/avr32/mach-at32ap/include/mach/atmel-mci.h |   2 +-
>  drivers/dma/dw/core.c                           |  72 +++++----------
>  drivers/dma/dw/internal.h                       |  28 +-----
>  drivers/dma/dw/pci.c                            |   4 +
>  drivers/dma/dw/platform.c                       |  86 +++++++++---------
>  drivers/dma/dw/regs.h                           |  14 +--
>  drivers/spi/spi-pxa2xx-dma.c                    |  15 +---
>  drivers/spi/spi-pxa2xx-pci.c                    | 102 ++++++++++++++++++----
>  drivers/spi/spi-pxa2xx.c                        |   2 -
>  drivers/tty/serial/8250/8250.h                  |   6 +-
>  drivers/tty/serial/8250/8250_dw.c               |   7 +-
>  drivers/tty/serial/8250/8250_pci.c              |  78 ++++++++++++++---
>  include/linux/dw_dmac.h                         | 111 ------------------------
>  include/linux/platform_data/dma-dw.h            | 109 +++++++++++++++++++++++
>  include/linux/spi/pxa2xx_spi.h                  |   9 +-
>  include/sound/atmel-abdac.h                     |   2 +-
>  include/sound/atmel-ac97c.h                     |   2 +-
>  sound/atmel/abdac.c                             |   2 +-
>  sound/atmel/ac97c.c                             |   2 +-
>  21 files changed, 365 insertions(+), 309 deletions(-)
>  delete mode 100644 include/linux/dw_dmac.h
>  create mode 100644 include/linux/platform_data/dma-dw.h
> 


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

