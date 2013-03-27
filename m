Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3C0JAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:00:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:47262 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab3C0I6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:58:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,917,1355126400"; 
   d="scan'208";a="285153141"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-acpi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 0/6] dmaengine: add ACPI DMA helpers and use them in dw_dmac
Date: Wed, 27 Mar 2013 10:57:56 +0200
Message-Id: <1364374682-8547-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a patch series which introduces ACPI DMA helpers in similar way like
we have for DeviceTree.

In addition it applies this to the first user, namely dw_dmac driver.

Andy Shevchenko (6):
  dma: acpi-dma: introduce ACPI DMA helpers
  dmaengine: call acpi_dma_request_slave_channel as well
  dma: acpi-dma: parse CSRT to extract additional resources
  dw_dmac: add ACPI support
  ACPI / LPSS: return no error from register_device_clock in special
    cases
  ACPI / LPSS: add Lynxpoint DMA controller to the list

 Documentation/acpi/enumeration.txt |  77 +++++++
 drivers/acpi/Makefile              |   1 -
 drivers/acpi/acpi_lpss.c           |  11 +
 drivers/acpi/csrt.c                | 159 -------------
 drivers/acpi/internal.h            |   1 -
 drivers/acpi/scan.c                |   1 -
 drivers/clk/x86/clk-lpt.c          |   2 +-
 drivers/dma/Kconfig                |   4 +
 drivers/dma/Makefile               |   1 +
 drivers/dma/acpi-dma.c             | 447 +++++++++++++++++++++++++++++++++++++
 drivers/dma/dmaengine.c            |   6 +
 drivers/dma/dw_dmac.c              |  68 ++++--
 drivers/dma/dw_dmac_regs.h         |   1 -
 include/linux/acpi_dma.h           | 120 ++++++++++
 14 files changed, 717 insertions(+), 182 deletions(-)
 delete mode 100644 drivers/acpi/csrt.c
 create mode 100644 drivers/dma/acpi-dma.c
 create mode 100644 include/linux/acpi_dma.h

-- 
1.8.2.rc0.22.gb3600c3

