Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab3JJK3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:29:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:54543 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab3JJK25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:28:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1070,1371106800"; 
   d="scan'208";a="306054709"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Wolfram Sang <wsa@the-dreams.de>,
        Mark Brown <broonie@kernel.org>, Aaron Lu <aaron.lu@intel.com>,
        Lv Zheng <lv.zheng@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] ACPI power management support for I2C and SPI devices
Date: Thu, 10 Oct 2013 13:28:45 +0300
Message-Id: <1381400928-2689-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381327461-10562-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1381327461-10562-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is an updated version. I added acks from Mark and Wolfram and dropped
if (ACPI_HANDLE()) checks as requested. This is already handled by
acpi_dev_pm_attach()/detach().

Rafael,

If you are OK with these, could you merge the series to your ACPI tree?

Thanks!

Lv Zheng (1):
  i2c: attach/detach I2C client device to the ACPI power domain

Mika Westerberg (2):
  ACPI / PM: allow child devices to ignore parent power state
  spi: attach/detach SPI device to the ACPI power domain

 drivers/acpi/device_pm.c |  8 +++++---
 drivers/i2c/i2c-core.c   |  5 +++++
 drivers/spi/spi.c        | 18 ++++++++++++++++--
 include/acpi/acpi_bus.h  |  3 ++-
 4 files changed, 28 insertions(+), 6 deletions(-)

-- 
1.8.4.rc3

