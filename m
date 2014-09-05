Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbaIEHBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:01:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:15023 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636AbaIEHBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:01:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,471,1406617200"; 
   d="scan'208";a="586646500"
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
        Andriy Shevchenko <andriy.shevchenko@intel.com>,
        Alvin Chen <alvin.chen@intel.com>
Subject: [PATCH 0/3 v2] The Designware GPIO Supporting
Date: Fri,  5 Sep 2014 07:53:15 -0700
Message-Id: <1409928798-31895-1-git-send-email-alvin.chen@intel.com>
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
functions will be sent subsequently. The second patch enables the gpio
'debounce' feature. And the third patch enables the power management.

---
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

Weike Chen (3):
  GPIO: gpio-dwapb: Enable platform driver binding to MFD driver
  GPIO: gpio-dwapb: Support Debounce
  GPIO: gpio-dwapb: Suspend & Resume PM enabling

 drivers/gpio/Kconfig                     |    1 -
 drivers/gpio/gpio-dwapb.c                |  397 +++++++++++++++++++++++++-----
 include/linux/platform_data/gpio-dwapb.h |   32 +++
 3 files changed, 365 insertions(+), 65 deletions(-)
 create mode 100644 include/linux/platform_data/gpio-dwapb.h

-- 
1.7.9.5

