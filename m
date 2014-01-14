Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaANIqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:46:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:23264 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbaANIqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:46:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,657,1384329600"; 
   d="scan'208";a="464783144"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org
Cc: wsa@the-dreams.de, broonie@linaro.org, gregkh@linuxfoundation.org,
        rafael.j.wysocki@intel.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, jarkko.nikula@linux.intel.com,
        mika.westerberg@linux.intel.com, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 0/4] module autoloading fixes
Date: Tue, 14 Jan 2014 16:46:34 +0800
Message-Id: <1389689198-2641-1-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all,

This patch set fixes a couple of module autoloading problem.

Patch 1/4 fixes a bug in ACPI device 'modalias' and 'uevent' attributes,
          although the bug can rarely be reproduced (only if there is an
          output error of snprintf, or the ids are longer than 1024 bytes)
Patch 2/4 introduces two new APIs for exporting ACPI style 'modalias' and
          'uevent' attributes in other buses.
Patch 3/4 introduce support for ACPI style 'modalias' and 'uevent'
          attributes in platform, I2C and SPI bus.
Patch 4/4 add OF style 'modalias' support for platform bus.

I did some tests and can confirm that the code for ACPI enumerated platform
bus device works well.
I tried with a patch with convert ACPI Fan device/driver to platform bus,
and can confirm that the code for ACPI enumerated platform device works well,
both the platform Fan driver and device show their modalias as "acpi:PNP0C0B".

thanks,
rui

----------------------------------------------------------------
Zhang Rui (4):
      ACPI: fix create_modalias() return value handling
      ACPI: add module autoloading support for ACPI enumerated devices
      fix module autoloading for ACPI enumerated devices
      OF: introduce OF style 'modalias' support for platform bus.

 drivers/acpi/scan.c       |   73 +++++++++++++++++++++++++++++++++++++++++----
 drivers/base/platform.c   |   16 +++++++++-
 drivers/i2c/i2c-core.c    |   11 +++++++
 drivers/of/device.c       |    3 ++
 drivers/spi/spi.c         |   10 +++++++
 include/linux/acpi.h      |   15 ++++++++++
 include/linux/of_device.h |    6 ++++
 7 files changed, 127 insertions(+), 7 deletions(-)
