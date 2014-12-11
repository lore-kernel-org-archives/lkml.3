Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885AbaLKPyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:54:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:43521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934157AbaLKPx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:53:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,558,1413270000"; 
   d="scan'208";a="636186987"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 0/4] mfd: reorganize Intel drivers
Date: Thu, 11 Dec 2014 17:53:52 +0200
Message-Id: <1418313236-10764-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset creates a new folder under drivers/mfd and moves there Intel
related drivers.

There is no functional change. The names of the kernel configuration variables
are kept the same.

Andy Shevchenko (4):
  mfd: change a layout for the Intel related drivers
  mfd: intel/lpc/sch: move driver to dedicated folder
  mfd: intel/lpc/ich: move driver to dedicated folder
  mfd: intel/pmic: move driver to dedicated folder

 .../platform/intel-mid/device_libs/platform_msic.c |  2 +-
 .../intel-mid/device_libs/platform_msic_audio.c    |  2 +-
 .../intel-mid/device_libs/platform_msic_battery.c  |  2 +-
 .../intel-mid/device_libs/platform_msic_gpio.c     |  2 +-
 .../intel-mid/device_libs/platform_msic_ocd.c      |  2 +-
 .../device_libs/platform_msic_power_btn.c          |  2 +-
 .../intel-mid/device_libs/platform_msic_thermal.c  |  2 +-
 drivers/acpi/pmic/intel_pmic_crc.c                 |  2 +-
 drivers/gpio/gpio-crystalcove.c                    |  2 +-
 drivers/gpio/gpio-ich.c                            |  2 +-
 drivers/gpio/gpio-msic.c                           |  2 +-
 drivers/mfd/Kconfig                                | 42 ++--------------------
 drivers/mfd/Makefile                               |  6 +---
 drivers/mfd/intel/Kconfig                          | 19 ++++++++++
 drivers/mfd/intel/Makefile                         |  9 +++++
 drivers/mfd/intel/lpc/Kconfig                      | 17 +++++++++
 drivers/mfd/intel/lpc/Makefile                     |  2 ++
 drivers/mfd/{lpc_ich.c => intel/lpc/ich.c}         | 10 ++----
 drivers/mfd/{lpc_sch.c => intel/lpc/sch.c}         |  2 +-
 drivers/mfd/intel/mid/Kconfig                      |  8 +++++
 drivers/mfd/intel/mid/Makefile                     |  1 +
 drivers/mfd/{intel_msic.c => intel/mid/msic.c}     |  2 +-
 .../{intel_soc_pmic_core.c => intel/pmic_core.c}   |  7 ++--
 .../{intel_soc_pmic_core.h => intel/pmic_core.h}   |  2 +-
 .../mfd/{intel_soc_pmic_crc.c => intel/pmic_crc.c} |  7 ++--
 drivers/platform/x86/intel_mid_powerbtn.c          |  2 +-
 drivers/platform/x86/intel_mid_thermal.c           |  2 +-
 drivers/watchdog/iTCO_wdt.c                        |  2 +-
 include/linux/mfd/{lpc_ich.h => intel/ich.h}       |  6 +---
 include/linux/mfd/{intel_msic.h => intel/msic.h}   |  2 +-
 .../linux/mfd/{intel_soc_pmic.h => intel/pmic.h}   |  0
 31 files changed, 90 insertions(+), 80 deletions(-)
 create mode 100644 drivers/mfd/intel/Kconfig
 create mode 100644 drivers/mfd/intel/Makefile
 create mode 100644 drivers/mfd/intel/lpc/Kconfig
 create mode 100644 drivers/mfd/intel/lpc/Makefile
 rename drivers/mfd/{lpc_ich.c => intel/lpc/ich.c} (98%)
 rename drivers/mfd/{lpc_sch.c => intel/lpc/sch.c} (99%)
 create mode 100644 drivers/mfd/intel/mid/Kconfig
 create mode 100644 drivers/mfd/intel/mid/Makefile
 rename drivers/mfd/{intel_msic.c => intel/mid/msic.c} (99%)
 rename drivers/mfd/{intel_soc_pmic_core.c => intel/pmic_core.c} (97%)
 rename drivers/mfd/{intel_soc_pmic_core.h => intel/pmic_core.h} (94%)
 rename drivers/mfd/{intel_soc_pmic_crc.c => intel/pmic_crc.c} (96%)
 rename include/linux/mfd/{lpc_ich.h => intel/ich.h} (81%)
 rename include/linux/mfd/{intel_msic.h => intel/msic.h} (99%)
 rename include/linux/mfd/{intel_soc_pmic.h => intel/pmic.h} (100%)

-- 
2.1.3

