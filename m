Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967438Ab3E3DG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 23:06:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:20732 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967340Ab3E3DDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 23:03:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,768,1363158000"; 
   d="scan'208";a="342312617"
From: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
To: x86@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, mark.gross@intel.com,
        len.brown@intel.com, david.a.cohen@intel.com, fei.yang@intel.com,
        sathyanarayanan.kuppuswamy@intel.com
Subject: [PATCH v1 00/13] mrst refactoring patches
Date: Wed, 29 May 2013 19:45:10 -0700
Message-Id: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Intel rolling out more SoC's after Moorestown, we need to re-structure
the code in a way that is backward compatible and easy to expand.This
patch set implements a flexible way to support multiple boards and devices.

Patch 1 - 5 fixes some indentation issue, compiler warnings and renames.
Patch 6 - 13 refactors mrst code.

Andy Shevchenko (2):
  sfi: fix compiler warnings
  gpiolib: append SFI helpers for GPIO API

Sathyanarayanan Kuppuswamy (11):
  mrst: Fixed printk/pr_* related issues
  mrst: Fixed indentation issues
  mrst: Fixed checkpatch warnings
  intel_mid: Renamed *mrst* to *intel_mid*
  intel_mid: Renamed *mrst* to *intel_mid*
  intel_mid: Refactored sfi_parse_devs() function
  intel_mid: Added custom device_handler support
  intel_mid: Added custom handler for ipc devices
  intel_mid: Moved board related code to a new file
  intel_mid: Moved SFI related code to intel_mid_sfi.c
  x86: mrst: move to generic SFI GPIO API

 Documentation/kernel-parameters.txt                |    6 +-
 arch/x86/include/asm/{mrst.h => intel-mid.h}       |   62 +-
 .../include/asm/{mrst-vrtc.h => intel_mid_vrtc.h}  |    4 +-
 arch/x86/include/asm/setup.h                       |    4 +-
 arch/x86/include/uapi/asm/bootparam.h              |    2 +-
 arch/x86/kernel/apb_timer.c                        |   10 +-
 arch/x86/kernel/early_printk.c                     |    2 +-
 arch/x86/kernel/head32.c                           |    4 +-
 arch/x86/kernel/rtc.c                              |    4 +-
 arch/x86/pci/Makefile                              |    2 +-
 arch/x86/pci/{mrst.c => intel_mid_pci.c}           |   22 +-
 arch/x86/platform/Makefile                         |    2 +-
 arch/x86/platform/intel-mid/Makefile               |    9 +
 arch/x86/platform/intel-mid/board.c                |  109 ++
 arch/x86/platform/intel-mid/device_libs/Makefile   |   21 +
 .../intel-mid/device_libs/platform_emc1403.c       |   33 +
 .../intel-mid/device_libs/platform_emc1403.h       |   16 +
 .../intel-mid/device_libs/platform_gpio_keys.c     |   82 ++
 .../intel-mid/device_libs/platform_gpio_keys.h     |   16 +
 .../platform/intel-mid/device_libs/platform_ipc.c  |   59 ++
 .../platform/intel-mid/device_libs/platform_ipc.h  |   17 +
 .../intel-mid/device_libs/platform_lis331.c        |   32 +
 .../intel-mid/device_libs/platform_lis331.h        |   16 +
 .../intel-mid/device_libs/platform_max3111.c       |   28 +
 .../intel-mid/device_libs/platform_max3111.h       |   16 +
 .../intel-mid/device_libs/platform_max7315.c       |   62 ++
 .../intel-mid/device_libs/platform_max7315.h       |   19 +
 .../intel-mid/device_libs/platform_mpu3050.c       |   28 +
 .../intel-mid/device_libs/platform_mpu3050.h       |   16 +
 .../platform/intel-mid/device_libs/platform_msic.c |   87 ++
 .../platform/intel-mid/device_libs/platform_msic.h |   19 +
 .../intel-mid/device_libs/platform_msic_audio.c    |   36 +
 .../intel-mid/device_libs/platform_msic_audio.h    |   16 +
 .../intel-mid/device_libs/platform_msic_battery.c  |   26 +
 .../intel-mid/device_libs/platform_msic_battery.h  |   17 +
 .../intel-mid/device_libs/platform_msic_gpio.c     |   37 +
 .../intel-mid/device_libs/platform_msic_gpio.h     |   16 +
 .../intel-mid/device_libs/platform_msic_ocd.c      |   39 +
 .../intel-mid/device_libs/platform_msic_ocd.h      |   16 +
 .../device_libs/platform_msic_power_btn.c          |   25 +
 .../device_libs/platform_msic_power_btn.h          |   17 +
 .../intel-mid/device_libs/platform_msic_thermal.c  |   26 +
 .../intel-mid/device_libs/platform_msic_thermal.h  |   17 +
 .../intel-mid/device_libs/platform_pmic_gpio.c     |   36 +
 .../intel-mid/device_libs/platform_pmic_gpio.h     |   16 +
 .../intel-mid/device_libs/platform_tc35876x.c      |   29 +
 .../intel-mid/device_libs/platform_tc35876x.h      |   16 +
 .../intel-mid/device_libs/platform_tca6416.c       |   45 +
 .../intel-mid/device_libs/platform_tca6416.h       |   20 +
 .../early_printk_intel_mid.c}                      |   11 +-
 arch/x86/platform/intel-mid/intel-mid.c            |  213 ++++
 arch/x86/platform/intel-mid/intel_mid_sfi.c        |  434 ++++++++
 .../{mrst/vrtc.c => intel-mid/intel_mid_vrtc.c}    |   21 +-
 arch/x86/platform/intel-mid/intel_mid_weak_decls.h |   15 +
 arch/x86/platform/mrst/Makefile                    |    3 -
 arch/x86/platform/mrst/mrst.c                      | 1052 --------------------
 drivers/gpio/Kconfig                               |    4 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpiolib-sfi.c                         |   76 ++
 drivers/gpu/drm/gma500/mdfld_dsi_output.h          |    2 +-
 drivers/gpu/drm/gma500/oaktrail_device.c           |    2 +-
 drivers/gpu/drm/gma500/oaktrail_lvds.c             |    2 +-
 drivers/platform/x86/intel_scu_ipc.c               |    4 +-
 drivers/rtc/rtc-mrst.c                             |    4 +-
 drivers/sfi/sfi_core.c                             |   11 +-
 drivers/watchdog/intel_scu_watchdog.c              |    4 +-
 include/linux/sfi_gpio.h                           |   27 +
 67 files changed, 2015 insertions(+), 1130 deletions(-)
 rename arch/x86/include/asm/{mrst.h => intel-mid.h} (50%)
 rename arch/x86/include/asm/{mrst-vrtc.h => intel_mid_vrtc.h} (81%)
 rename arch/x86/pci/{mrst.c => intel_mid_pci.c} (95%)
 create mode 100644 arch/x86/platform/intel-mid/Makefile
 create mode 100644 arch/x86/platform/intel-mid/board.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/Makefile
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_emc1403.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_ipc.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_ipc.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_lis331.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_lis331.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_max3111.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_max3111.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_max7315.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_max7315.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_mpu3050.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_audio.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_audio.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_battery.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_battery.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_power_btn.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_power_btn.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_thermal.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_thermal.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_tc35876x.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_tca6416.h
 rename arch/x86/platform/{mrst/early_printk_mrst.c => intel-mid/early_printk_intel_mid.c} (97%)
 create mode 100644 arch/x86/platform/intel-mid/intel-mid.c
 create mode 100644 arch/x86/platform/intel-mid/intel_mid_sfi.c
 rename arch/x86/platform/{mrst/vrtc.c => intel-mid/intel_mid_vrtc.c} (90%)
 create mode 100644 arch/x86/platform/intel-mid/intel_mid_weak_decls.h
 delete mode 100644 arch/x86/platform/mrst/Makefile
 delete mode 100644 arch/x86/platform/mrst/mrst.c
 create mode 100644 drivers/gpio/gpiolib-sfi.c
 create mode 100644 include/linux/sfi_gpio.h

-- 
1.7.9.5

