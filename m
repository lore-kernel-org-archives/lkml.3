Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaI3KGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:06:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:26466 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbaI3KE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:04:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,625,1406617200"; 
   d="scan'208";a="598695224"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Carl Peng <carlpeng008@gmail.com>, Huang Rui <ray.huang@amd.com>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 0/3] i2c: designware: Add support for AMD I2C controller
Date: Tue, 30 Sep 2014 13:04:52 +0300
Message-Id: <1412071495-15323-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is second iteration of the patch series. First version is here:

 http://patchwork.ozlabs.org/patch/390694/
 http://patchwork.ozlabs.org/patch/390695/

In order to get source clock to the core driver we need some way of
creating it in the first place. For Intel LPSS it is done in
drivers/acpi/acpi_lpss.c but that is not applicable for AMD I2C host
controller which is too different from private parts to the LPSS one.

We solve this by creating the clock in ACPI parts of the platform driver
when we detect the AMD I2C host controller. Doing this requires small
refactoring to be done to the probe() which is what patches [1-2/3] are
doing.

Changes to the previous version:
 * Rebased on top of i2c/for-next branch
 * New patch defaulting ACPI probe to fast mode
 * Instead of direct dependency to COMMON_CLK we depend on (ACPI &&
   COMMON_CLK) || ACPI. (suggested by Wolfram)

Carl, can you test that this still works on your machine?

Carl Peng (1):
  i2c: designware: Add support for AMD I2C controller

Mika Westerberg (2):
  i2c: designware: Default to fast mode in case of ACPI
  i2c: designware: Rework probe() to get clock a bit later

 drivers/i2c/busses/Kconfig                  |  1 +
 drivers/i2c/busses/i2c-designware-platdrv.c | 71 +++++++++++++++++++----------
 2 files changed, 48 insertions(+), 24 deletions(-)

-- 
2.1.0

