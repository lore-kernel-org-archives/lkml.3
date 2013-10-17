Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab3JQWbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 18:31:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:3046 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069Ab3JQWba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 18:31:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,517,1378882800"; 
   d="scan'208";a="420869455"
From: David Cohen <david.a.cohen@linux.intel.com>
To: x86@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, sathyanarayanan.kuppuswamy@linux.intel.com,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v10 00/12] rework arch/x86/platform/[mrst => intel-mid]
Date: Thu, 17 Oct 2013 15:35:24 -0700
Message-Id: <1382049336-21316-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set does initial rework from arch/x86/platform/mrst to
arch/x86/platform/intel-mid.
These changes are necessary to update the obsolete Intel Atom Moorestown code
to support the newer Atom processors of this family (called 'intel-mid'). 

Change from v9 to v10:
 - Improved patch title of one coccinelle warning fix.
 - Removed one non-functional patch fixing coccinelle warning.
 - Squashed non-functional patch which fixed compilation warning on the deleted
   mrst.c file.

There is no function change in the end.
---

David Cohen (3):
  intel-mid: sfi: allow struct devs_id.get_platform_data to be NULL
  x86: intel-mid: add section for sfi device table
  intel_mid: move board related codes to their own platform_<device>.*
    files

Fengguang Wu (1):
  pci: intel_mid: return true/false in function returning bool

Kuppuswamy Sathyanarayanan (8):
  mrst: Fixed printk/pr_* related issues
  mrst: Fixed indentation issues
  intel_mid: Renamed *mrst* to *intel_mid*
  intel_mid: Renamed *mrst* to *intel_mid*
  intel_mid: Refactored sfi_parse_devs() function
  intel_mid: Added custom device_handler support
  intel_mid: Added custom handler for ipc devices
  intel_mid: Moved SFI related code to sfi.c

 Documentation/kernel-parameters.txt                |    6 +-
 arch/x86/include/asm/intel-mid.h                   |  113 +++
 .../include/asm/{mrst-vrtc.h => intel_mid_vrtc.h}  |    4 +-
 arch/x86/include/asm/mrst.h                        |   81 --
 arch/x86/include/asm/setup.h                       |    4 +-
 arch/x86/include/uapi/asm/bootparam.h              |    2 +-
 arch/x86/kernel/apb_timer.c                        |   10 +-
 arch/x86/kernel/early_printk.c                     |    2 +-
 arch/x86/kernel/head32.c                           |    4 +-
 arch/x86/kernel/rtc.c                              |    4 +-
 arch/x86/kernel/vmlinux.lds.S                      |    9 +
 arch/x86/pci/Makefile                              |    2 +-
 arch/x86/pci/{mrst.c => intel_mid_pci.c}           |   20 +-
 arch/x86/platform/Makefile                         |    2 +-
 arch/x86/platform/intel-mid/Makefile               |    7 +
 arch/x86/platform/intel-mid/device_libs/Makefile   |   22 +
 .../intel-mid/device_libs/platform_bma023.c        |   20 +
 .../intel-mid/device_libs/platform_emc1403.c       |   41 +
 .../intel-mid/device_libs/platform_gpio_keys.c     |   83 ++
 .../platform/intel-mid/device_libs/platform_ipc.c  |   68 ++
 .../platform/intel-mid/device_libs/platform_ipc.h  |   17 +
 .../intel-mid/device_libs/platform_lis331.c        |   39 +
 .../intel-mid/device_libs/platform_max3111.c       |   35 +
 .../intel-mid/device_libs/platform_max7315.c       |   79 ++
 .../intel-mid/device_libs/platform_mpu3050.c       |   36 +
 .../platform/intel-mid/device_libs/platform_msic.c |   87 ++
 .../platform/intel-mid/device_libs/platform_msic.h |   19 +
 .../intel-mid/device_libs/platform_msic_audio.c    |   47 +
 .../intel-mid/device_libs/platform_msic_battery.c  |   37 +
 .../intel-mid/device_libs/platform_msic_gpio.c     |   48 +
 .../intel-mid/device_libs/platform_msic_ocd.c      |   49 +
 .../device_libs/platform_msic_power_btn.c          |   36 +
 .../intel-mid/device_libs/platform_msic_thermal.c  |   37 +
 .../intel-mid/device_libs/platform_pmic_gpio.c     |   54 +
 .../intel-mid/device_libs/platform_tc35876x.c      |   36 +
 .../intel-mid/device_libs/platform_tca6416.c       |   57 ++
 .../early_printk_intel_mid.c}                      |   11 +-
 arch/x86/platform/intel-mid/intel-mid.c            |  213 ++++
 .../{mrst/vrtc.c => intel-mid/intel_mid_vrtc.c}    |   19 +-
 arch/x86/platform/intel-mid/sfi.c                  |  488 +++++++++
 arch/x86/platform/mrst/Makefile                    |    3 -
 arch/x86/platform/mrst/mrst.c                      | 1052 --------------------
 drivers/gpu/drm/gma500/mdfld_dsi_output.h          |    2 +-
 drivers/gpu/drm/gma500/oaktrail_device.c           |    2 +-
 drivers/gpu/drm/gma500/oaktrail_lvds.c             |    2 +-
 drivers/platform/x86/intel_scu_ipc.c               |    4 +-
 drivers/rtc/rtc-mrst.c                             |    4 +-
 drivers/watchdog/intel_scu_watchdog.c              |    4 +-
 include/linux/sfi.h                                |    3 +
 49 files changed, 1834 insertions(+), 1190 deletions(-)
 create mode 100644 arch/x86/include/asm/intel-mid.h
 rename arch/x86/include/asm/{mrst-vrtc.h => intel_mid_vrtc.h} (81%)
 delete mode 100644 arch/x86/include/asm/mrst.h
 rename arch/x86/pci/{mrst.c => intel_mid_pci.c} (96%)
 create mode 100644 arch/x86/platform/intel-mid/Makefile
 create mode 100644 arch/x86/platform/intel-mid/device_libs/Makefile
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_bma023.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_ipc.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_ipc.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_lis331.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_max3111.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_max7315.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic.h
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_audio.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_battery.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_power_btn.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_msic_thermal.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c
 create mode 100644 arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
 rename arch/x86/platform/{mrst/early_printk_mrst.c => intel-mid/early_printk_intel_mid.c} (97%)
 create mode 100644 arch/x86/platform/intel-mid/intel-mid.c
 rename arch/x86/platform/{mrst/vrtc.c => intel-mid/intel_mid_vrtc.c} (90%)
 create mode 100644 arch/x86/platform/intel-mid/sfi.c
 delete mode 100644 arch/x86/platform/mrst/Makefile
 delete mode 100644 arch/x86/platform/mrst/mrst.c

-- 
1.8.4.rc3

