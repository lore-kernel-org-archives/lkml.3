Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab3JLDmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 23:42:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:24856 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab3JLDjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 23:39:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,479,1378882800"; 
   d="scan'208";a="391905937"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        platform-driver-x86@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v3 00/10] rework arch/x86/platform/[mrst => intel-mid]
Date: Fri, 11 Oct 2013 20:43:14 -0700
Message-Id: <1381549404-22594-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set does initial rework from arch/x86/platform/mrst to
arch/x86/platform/intel-mid.
These changes are necessary to update the obsolete Intel Atom Moorestown code
to support the newer Atom processors of this family (called 'intel-mid'). 

Kuppuswamy Sathyanarayanan (10):
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
 arch/x86/pci/{mrst.c => intel_mid_pci.c}           |   14 +-
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
 arch/x86/platform/intel-mid/intel_mid_sfi.c        |  485 +++++++++
 .../{mrst/vrtc.c => intel-mid/intel_mid_vrtc.c}    |   19 +-
 arch/x86/platform/intel-mid/intel_mid_weak_decls.h |   15 +
 arch/x86/platform/mrst/Makefile                    |    3 -
 arch/x86/platform/mrst/mrst.c                      | 1052 --------------------
 drivers/gpu/drm/gma500/mdfld_dsi_output.h          |    2 +-
 drivers/gpu/drm/gma500/oaktrail_device.c           |    2 +-
 drivers/gpu/drm/gma500/oaktrail_lvds.c             |    2 +-
 drivers/platform/x86/intel_scu_ipc.c               |    4 +-
 drivers/rtc/rtc-mrst.c                             |    4 +-
 drivers/watchdog/intel_scu_watchdog.c              |    4 +-
 62 files changed, 1944 insertions(+), 1123 deletions(-)
 rename arch/x86/include/asm/{mrst.h => intel-mid.h} (50%)
 rename arch/x86/include/asm/{mrst-vrtc.h => intel_mid_vrtc.h} (81%)
 rename arch/x86/pci/{mrst.c => intel_mid_pci.c} (96%)
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

-- 
1.8.4.rc3

