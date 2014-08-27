Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbaH0JyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:54:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:3195 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684AbaH0JyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:54:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,409,1406617200"; 
   d="scan'208";a="473110606"
From: Weike Chen <alvin.chen@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Boon Leong Ong <boon.leong.ong@intel.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Hock Leong Kweh <hock.leong.kweh@intel.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Alvin Chen <alvin.chen@intel.com>
Subject: [PATCH 0/3] The Designware GPIO Supporting
Date: Wed, 27 Aug 2014 10:46:25 -0700
Message-Id: <1409161588-19417-1-git-send-email-alvin.chen@intel.com>
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

Weike Chen (3):
  GPIO: gpio-dwapb: Enable platform driver binding to MFD driver
  GPIO: gpio-dwapb: Support Debounce
  GPIO: gpio-dwapb: Suspend & Resume PM enabling

 drivers/gpio/Kconfig                     |    1 -
 drivers/gpio/gpio-dwapb.c                |  296 +++++++++++++++++++++++++-----
 include/linux/platform_data/gpio-dwapb.h |   32 ++++
 3 files changed, 280 insertions(+), 49 deletions(-)
 create mode 100644 include/linux/platform_data/gpio-dwapb.h

-- 
1.7.9.5

