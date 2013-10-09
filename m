Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3JIOE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 10:04:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:51517 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab3JIOE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 10:04:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1063,1371106800"; 
   d="scan'208";a="390561611"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Aaron Lu <aaron.lu@intel.com>,
        Lv Zheng <lv.zheng@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] ACPI power management support for I2C and SPI devices
Date: Wed,  9 Oct 2013 17:04:18 +0300
Message-Id: <1381327461-10562-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We originally tried to add runtime PM support for I2C adapter devices in
order to have runtime PM core to power on the I2C host controller device
automatically whenever any of its children I2C device is powered on (See
[1] for the last patch series).

The rationale was that it is what the ACPI 5.0 specification requires: the
parent device cannot be lower power states than its children.

However, it looks like Windows can put the I2C controller device to low
power states independently of its children power states, just like Linux
does.

This patch series only adds I2C and SPI devices to the ACPI power domain
and make sure that the parent device power state is ignored when
transitioning child device to a different power states.

Since patches [2-3/3] depend on patch [1/3] it would be good if these all
could be merged together.

[1] http://lwn.net/Articles/568961/

Lv Zheng (1):
  i2c: attach/detach I2C client device to the ACPI power domain

Mika Westerberg (2):
  ACPI / PM: allow child devices to ignore parent power state
  spi: attach/detach SPI device to the ACPI power domain

 drivers/acpi/device_pm.c |  8 +++++---
 drivers/i2c/i2c-core.c   | 10 ++++++++++
 drivers/spi/spi.c        | 20 ++++++++++++++++++--
 include/acpi/acpi_bus.h  |  3 ++-
 4 files changed, 35 insertions(+), 6 deletions(-)

-- 
1.8.4.rc3

