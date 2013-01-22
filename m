Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab3AVKZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:25:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:46754 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab3AVKZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:25:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,513,1355126400"; 
   d="scan'208";a="280457714"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>, cxie4@marvell.com,
        ytang5@marvell.com, Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v3 00/10] spi/pxa2xx: add Intel Lynxpoint SPI controller support
Date: Tue, 22 Jan 2013 12:26:23 +0200
Message-Id: <1358850393-23111-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is third iteration of the patches. The second version is available
here:

	http://lkml.org/lkml/2013/1/21/108

On Intel Lynxpoint (the PCH used with Haswell) we have two SPI controllers
that reside in the Low Power Subsystem of the PCH. The hardware is mostly
compliant with PXA2xx SPI controller except that there are few additional
registers. Those are described in patch [9/10].

Changes to v2:
	- Added parens to IS_DMA_ALIGNED(x) parameter.
	- Prefix the DMA function names with pxa2xx_spi_ so that we don't
	  pollute the global kernel namespace with too generic symbols.
	- By default select the DMA engine API support even on PXA and
	  treat the PXA private DMA API as legacy. It can still be selected
	  via Kconfig option CONFIG_SPI_PXA2XX_PXADMA.
	- Update patch [5/10] title to match better what it does.

Changes to v1:
	- Split 64-bit build support and warnings fix into separate patches
	  [1,2/10].
	- Convert to use common clk API instead of passing the clock rate
	  via custom platform data parameter.
	- Split the DMA implementation into a separate files for PXA and
	  DMA engine.

I've dropped the two patches that are already applied in Mark's SPI tree.

Tested on Haswell machine with both DMA and PIO modes. Only compile tested
on PXA (due to lack of hardware).

Mika Westerberg (10):
  spi/pxa2xx: allow building on a 64-bit kernel
  spi/pxa2xx: fix warnings when compiling a 64-bit kernel
  spi/pxa2xx: convert to the pump message infrastructure
  spi/pxa2xx: convert to the common clk framework
  spi/pxa2xx: break out the private DMA API usage into a separate file
  spi/pxa2xx: add support for DMA engine
  spi/pxa2xx: add support for runtime PM
  spi/pxa2xx: add support for SPI_LOOP
  spi/pxa2xx: add support for Intel Low Power Subsystem SPI
  spi/pxa2xx: add support for Lynxpoint SPI controllers

 drivers/spi/Kconfig             |   15 +-
 drivers/spi/Makefile            |    5 +-
 drivers/spi/spi-pxa2xx-dma.c    |  392 ++++++++++++++
 drivers/spi/spi-pxa2xx-pxadma.c |  490 ++++++++++++++++++
 drivers/spi/spi-pxa2xx.c        | 1092 ++++++++++++---------------------------
 drivers/spi/spi-pxa2xx.h        |  221 ++++++++
 include/linux/pxa2xx_ssp.h      |    9 +
 include/linux/spi/pxa2xx_spi.h  |  105 +---
 8 files changed, 1469 insertions(+), 860 deletions(-)
 create mode 100644 drivers/spi/spi-pxa2xx-dma.c
 create mode 100644 drivers/spi/spi-pxa2xx-pxadma.c
 create mode 100644 drivers/spi/spi-pxa2xx.h

-- 
1.7.10.4

