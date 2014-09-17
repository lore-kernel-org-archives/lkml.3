Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbaIQI0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:26:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:28461 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbaIQI03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:26:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,539,1406617200"; 
   d="scan'208";a="600839233"
From: Weike Chen <alvin.chen@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, atull <atull@opensource.altera.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Boon Leong Ong <boon.leong.ong@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alvin Chen <alvin.chen@intel.com>
Subject: [PATCH 0/4 v5] The Designware GPIO Supporting
Date: Wed, 17 Sep 2014 09:18:38 -0700
Message-Id: <1410970722-8579-1-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
These patches are for Intel Quark X1000 designware GPIO supporting. The first
patch enables the Synopsys DesignWare APB GPIO driver to support the MFD device.
And the Quark designware GPIO controller is registered as MFD device,
because Quark exports a single PCI device with both GPIO and I2C functions.
It is about reviewing the GPIO changes in gpio-dwapb, and in near future,
the Quark I2C driver and the MFD driver that binds these GPIO & I2C
functions will be sent subsequently. The second patch replaces all
'readl&writel' with 'dwapb_read'&'dwapb_write. The third patch enables the gpio
'debounce' feature. And the fourth patch enables the power management.

---
v5:
 [PATCH 1/4]
 * Remove 'pp->irq = 0' since the memory is already set to '0'.
 [PATCH 2/4]
 * No changes.
 [PATCH 3/4]
 * Correct the 'Reviewed-by'.
 * Use inline helper for 'container_of'.
 * Other minor fixes.
 [PATCH 4/4]
 * Allocate PM context in 'probe' if 'PM_SLEEP' is enabled.
 * Other minor fixes.

v4:
 [PATCH 1/4]
 * Use 'unsigned int i' instead of 'int i' in 'probe'.
 [PATCH 2/4]
 * No changes.
 [PATCH 3/4]
 * No changes.
 [PATCH 4/4]
 * No changes.

v3:
 Split [PATCH 2/3] into two patches [PATCH 2/4] and [PATCH 3/4],
 and now inlucde 4 patches.

 [PATCH 1/4]
 * Use 'is_pdata_alloc' instead of 'is_of'.
 * Allocate 'pdata' by 'kmalloc/kfree' instead of 'devm_*' for OF.
 * Use 'IS_ENABLED(CONFIG_OF_GPIO)' instead of '#ifdef CONFIG_OF_GPIO'.
 * A couple of other minor changes.
 [PATCH 2/4]
 * New patch splitted from the original [PATCH 2/3]
 * Use 'dwapb_read/write' instead of readl&writel.
 [PATCH 3/4]
 * Move 'dwapb_read/write' defination to new patch [PATCH 2/4].
 * Only port A support 'debounce' now.
 [PATCH 4/4]
 * The original patch [PATCH 3/3]
 * Use 'struct dwapb_context' instead of 'struct gpio_saved_regs'.
 * Allocate and save context dynamically by per port.

v2:
 [PATCH 1/3]
 * Fixed a bug to set the base gpio number to '-1' for the OF flow.
 * Set device node for each gpio chip for the OF flow.
 * Change the name of 'struct dwapb_gpio_platform_data' to
   'struct dwapb_platform_data'.
 * Change the name of 'struct dwapb_gpio_port_property' to
   'struct dwapb_port_property'.
 * Access pdata directly in 'probe' instead of accesing it
   by 'struct dwapb_gpio'.
 * Free 'pdata' at the end of 'probe' if it is OF case to save memory.
 * Improve the interrupt handler.
 * Move 'irq_set_handler_data' together with 'irq_set_chained_hanlder'.
 * Remove unncessary comments.
 [PATCH 2/3]
 * Change all 'readl'&'writel' to 'dwapb_read'&'dwapb_write'.
 [PATCH 3/3]
 * Change the name for 'struct gpio_saved_regs' to 'struct dwapb_context'.
 * Save the registers for all ports according to the port index.
 * Change '#if defined' to '#ifdef'.

Weike Chen (4):
  GPIO: gpio-dwapb: Enable platform driver binding to MFD driver
  GPIO: gpio-dwapb: Change readl&writel to dwapb_read&dwapb_write
  GPIO: gpio-dwapb: Support Debounce
  GPIO: gpio-dwapb: Suspend & Resume PM enabling

 drivers/gpio/Kconfig                     |    1 -
 drivers/gpio/gpio-dwapb.c                |  410 +++++++++++++++++++++++++-----
 include/linux/platform_data/gpio-dwapb.h |   32 +++
 3 files changed, 374 insertions(+), 69 deletions(-)
 create mode 100644 include/linux/platform_data/gpio-dwapb.h

-- 
1.7.9.5

