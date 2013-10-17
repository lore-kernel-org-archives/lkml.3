Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762994Ab3JQVwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:52:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:43631 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762874Ab3JQVwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:52:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,517,1378882800"; 
   d="scan'208";a="394625547"
From: David Cohen <david.a.cohen@linux.intel.com>
To: x86@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v9 00/14] rework arch/x86/platform/[mrst => intel-mid]
Date: Thu, 17 Oct 2013 14:55:43 -0700
Message-Id: <1382046957-15987-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set does initial rework from arch/x86/platform/mrst to
arch/x86/platform/intel-mid.
These changes are necessary to update the obsolete Intel Atom Moorestown code
to support the newer Atom processors of this family (called 'intel-mid'). 

Change from v8 to v9:
 - Fixed compilation issue when CONFIG_SFI is selected but
   CONFIG_X86_INTEL_MID isn't:

   arch/x86/built-in.o: In function `intel_scu_devices_create':
   (.text+0x24bea): undefined reference to `i2c_get_adapter'
   arch/x86/built-in.o: In function `intel_scu_devices_create':
   (.text+0x24bfa): undefined reference to `i2c_new_device'
   arch/x86/built-in.o: In function `sfi_parse_devs':
   sfi.c:(.init.text+0xeca4): undefined reference to `__x86_intel_mid_dev_start'
   sfi.c:(.init.text+0xeccb): undefined reference to `__x86_intel_mid_dev_end'

 - Added 2 more patches to avoid coccinelle warnings.
---

David Cohen (3):
  intel-mid: sfi: allow struct devs_id.get_platform_data to be NULL
  x86: intel-mid: add section for sfi device table
  intel_mid: move board related codes to their own platform_<device>.*
    files

Fengguang Wu (2):
  intel_mid: fix coccinelle warnings
  intel_mid: fix coccinelle warnings

Kuppuswamy Sathyanarayanan (9):
  mrst: Fixed printk/pr_* related issues
  mrst: Fixed indentation issues
  mrst: Fixed checkpatch warnings
  intel_mid: Renamed *mrst* to *intel_mid*
  intel_mid: Renamed *mrst* to *intel_mid*
  intel_mid: Refactored sfi_parse_devs() function
  intel_mid: Added custom device_handler support
  intel_mid: Added custom handler for ipc devices
  intel_mid: Moved SFI related code to sfi.c

 Documentation/kernel-parameters.txt                |    6 +-
 arch/x86/include/asm/intel-mid.h                   |  113 +++
 arch/x86/include/asm/intel_mid_vrtc.h              |    9 +
 arch/x86/include/asm/mrst-vrtc.h                   |    9 -
 arch/x86/include/asm/mrst.h                        |   81 --
 arch/x86/include/asm/setup.h                       |    4 +-
 arch/x86/include/uapi/asm/bootparam.h              |    2 +-
 arch/x86/kernel/apb_timer.c                        |   10 +-
 arch/x86/kernel/early_printk.c                     |    2 +-
 arch/x86/kernel/head32.c                           |    4 +-
 arch/x86/kernel/rtc.c                              |    4 +-
 arch/x86/kernel/vmlinux.lds.S                      |    9 +
 arch/x86/pci/Makefile                              |    2 +-
 arch/x86/pci/intel_mid_pci.c                       |  310 ++++++
 arch/x86/pci/mrst.c                                |  310 ------
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
 .../platform/intel-mid/early_printk_intel_mid.c    |  325 ++++++
 arch/x86/platform/intel-mid/intel-mid.c            |  213 ++++
 arch/x86/platform/intel-mid/intel_mid_vrtc.c       |  177 ++++
 arch/x86/platform/intel-mid/sfi.c                  |  488 +++++++++
 arch/x86/platform/mrst/Makefile                    |    3 -
 arch/x86/platform/mrst/early_printk_mrst.c         |  324 ------
 arch/x86/platform/mrst/mrst.c                      | 1052 --------------------
 arch/x86/platform/mrst/vrtc.c                      |  178 ----
 drivers/gpu/drm/gma500/mdfld_dsi_output.h          |    2 +-
 drivers/gpu/drm/gma500/oaktrail_device.c           |    2 +-
 drivers/gpu/drm/gma500/oaktrail_lvds.c             |    2 +-
 drivers/platform/x86/intel_scu_ipc.c               |    4 +-
 drivers/rtc/rtc-mrst.c                             |    4 +-
 drivers/watchdog/intel_scu_watchdog.c              |    4 +-
 include/linux/sfi.h                                |    3 +
 53 files changed, 2628 insertions(+), 1984 deletions(-)
 create mode 100644 arch/x86/include/asm/intel-mid.h
 create mode 100644 arch/x86/include/asm/intel_mid_vrtc.h
 delete mode 100644 arch/x86/include/asm/mrst-vrtc.h
 delete mode 100644 arch/x86/include/asm/mrst.h
 create mode 100644 arch/x86/pci/intel_mid_pci.c
 delete mode 100644 arch/x86/pci/mrst.c
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
 create mode 100644 arch/x86/platform/intel-mid/early_printk_intel_mid.c
 create mode 100644 arch/x86/platform/intel-mid/intel-mid.c
 create mode 100644 arch/x86/platform/intel-mid/intel_mid_vrtc.c
 create mode 100644 arch/x86/platform/intel-mid/sfi.c
 delete mode 100644 arch/x86/platform/mrst/Makefile
 delete mode 100644 arch/x86/platform/mrst/early_printk_mrst.c
 delete mode 100644 arch/x86/platform/mrst/mrst.c
 delete mode 100644 arch/x86/platform/mrst/vrtc.c

-- 
1.8.4.rc3

