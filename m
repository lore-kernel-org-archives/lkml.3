Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab3AUJbB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:31:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:2885 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab3AUJa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:30:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,505,1355126400"; 
   d="scan'208";a="274580403"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, chao.bi@intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 00/10] spi/pxa2xx: add Intel Lynxpoint SPI controller support
Date: Mon, 21 Jan 2013 11:31:53 +0200
Message-Id: <1358760723-32752-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is a second iteration of the patches first introduced here:

	http://thread.gmane.org/gmane.linux.kernel/1417691

On Intel Lynxpoint (the PCH used with Haswell) we have two SPI controllers
that reside in the Low Power Subsystem of the PCH. The hardware is mostly
compliant with PXA2xx SPI controller except that there are few additional
registers. Those are described in patch [9/10].

Changes to previous version:
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
  spi/pxa2xx: use the private DMA API only when CONFIG_ARCH_PXA is set
  spi/pxa2xx: add support for DMA engine
  spi/pxa2xx: add support for runtime PM
  spi/pxa2xx: add support for SPI_LOOP
  spi/pxa2xx: add support for Intel Low Power Subsystem SPI
  spi/pxa2xx: add support for Lynxpoint SPI controllers

 drivers/spi/Kconfig             |   11 +-
 drivers/spi/Makefile            |    5 +-
 drivers/spi/spi-pxa2xx-dma.c    |  388 ++++++++++++++
 drivers/spi/spi-pxa2xx-pxadma.c |  490 ++++++++++++++++++
 drivers/spi/spi-pxa2xx.c        | 1068 ++++++++++++---------------------------
 drivers/spi/spi-pxa2xx.h        |  201 ++++++++
 include/linux/pxa2xx_ssp.h      |    9 +
 include/linux/spi/pxa2xx_spi.h  |  105 +---
 8 files changed, 1433 insertions(+), 844 deletions(-)
 create mode 100644 drivers/spi/spi-pxa2xx-dma.c
 create mode 100644 drivers/spi/spi-pxa2xx-pxadma.c
 create mode 100644 drivers/spi/spi-pxa2xx.h

-- 
1.7.10.4

