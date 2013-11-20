Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab3KTOcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:32:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:59118 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860Ab3KTOcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:32:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="438546254"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>,
        "linux-gpio @ vger . kernel . org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 0/3] sfi, intel_mid: introduce SFI GPIO API and use it
Date: Wed, 20 Nov 2013 16:31:33 +0200
Message-Id: <1384957896-3477-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a second [1] version of the SFI GPIO API. This series contains SFI GPIO
API layer along with the update of intel-mid platform to use it instead of
internal copy.

It has been tested on Medfield device with linux-next 20131118.

[1] https://lkml.org/lkml/2013/6/5/316

Andy Shevchenko (3):
  sfi: fix compiler warnings
  gpiolib: append SFI helpers for GPIO API
  intel_mid: switch to use SFI GPIO API

 arch/x86/include/asm/intel-mid.h                   |  1 -
 .../intel-mid/device_libs/platform_emc1403.c       |  8 +--
 .../intel-mid/device_libs/platform_gpio_keys.c     | 10 +--
 .../intel-mid/device_libs/platform_lis331.c        |  8 +--
 .../intel-mid/device_libs/platform_max3111.c       |  6 +-
 .../intel-mid/device_libs/platform_max7315.c       | 10 +--
 .../intel-mid/device_libs/platform_mpu3050.c       |  6 +-
 .../intel-mid/device_libs/platform_msic_gpio.c     |  6 +-
 .../intel-mid/device_libs/platform_msic_ocd.c      |  5 +-
 .../intel-mid/device_libs/platform_pmic_gpio.c     |  7 +-
 .../intel-mid/device_libs/platform_tc35876x.c      |  8 +--
 .../intel-mid/device_libs/platform_tca6416.c       | 10 +--
 arch/x86/platform/intel-mid/sfi.c                  | 51 --------------
 drivers/gpio/Kconfig                               |  4 ++
 drivers/gpio/Makefile                              |  1 +
 drivers/gpio/gpiolib-sfi.c                         | 77 ++++++++++++++++++++++
 drivers/sfi/sfi_acpi.c                             |  8 +--
 drivers/sfi/sfi_core.c                             | 13 +++-
 include/linux/gpio/sfi.h                           | 37 +++++++++++
 include/linux/sfi_acpi.h                           |  2 +-
 20 files changed, 176 insertions(+), 102 deletions(-)
 create mode 100644 drivers/gpio/gpiolib-sfi.c
 create mode 100644 include/linux/gpio/sfi.h

-- 
1.8.4.3

