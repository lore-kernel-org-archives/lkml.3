Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967418Ab3E3DEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 23:04:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:3537 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967352Ab3E3DDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 23:03:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,768,1363158000"; 
   d="scan'208";a="342312648"
From: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
To: x86@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, mark.gross@intel.com,
        len.brown@intel.com, david.a.cohen@intel.com, fei.yang@intel.com,
        sathyanarayanan.kuppuswamy@intel.com
Subject: [PATCH v1 09/13] intel_mid: Moved board related code to a new file
Date: Wed, 29 May 2013 19:45:19 -0700
Message-Id: <1369881923-27067-10-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
References: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Intel rolling out more SoC's after Moorestown, we need to re-structure
the code in a way that is backward compatible and easy to expand.This
patch implements a flexible way to support multiple boards and devices.

This patch does not add any new functional support. It just refactors
the existing code to increase the modularity and decrease the code duplication
for supporting multiple soc's and boards.

Currently intel-mid.c has both board and soc related code in one file. This
patch moves the board related code to new files in the following order.

1. Moved the device specific code to arch/x86/platform/intel-mid/device-libs/
   platform_<device>.*. A new device file is added for every supported device.
   This code will get conditionally compiled by using corresponding device driver
   CONFIG option.

2. Moved the device_ids structure definition to board.c. All board specific code
   are added to this file . This will provide better scalability for our code
   when supporting multiple boards.

Change-Id: I9a99f8ff98037d2b9d5a1c013fa7c00a9453520d
Signed-off-by: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
---
 arch/x86/include/asm/intel-mid.h                   |   12 +
 arch/x86/platform/intel-mid/Makefile               |    5 +
 arch/x86/platform/intel-mid/board.c                |  109 +++++
 arch/x86/platform/intel-mid/device_libs/Makefile   |   21 +
 .../intel-mid/device_libs/platform_emc1403.c       |   33 ++
 .../intel-mid/device_libs/platform_emc1403.h       |   16 +
 .../intel-mid/device_libs/platform_gpio_keys.c     |   82 ++++
 .../intel-mid/device_libs/platform_gpio_keys.h     |   16 +
 .../platform/intel-mid/device_libs/platform_ipc.c  |   59 +++
 .../platform/intel-mid/device_libs/platform_ipc.h  |   17 +
 .../intel-mid/device_libs/platform_lis331.c        |   32 ++
 .../intel-mid/device_libs/platform_lis331.h        |   16 +
 .../intel-mid/device_libs/platform_max3111.c       |   28 ++
 .../intel-mid/device_libs/platform_max3111.h       |   16 +
 .../intel-mid/device_libs/platform_max7315.c       |   62 +++
 .../intel-mid/device_libs/platform_max7315.h       |   19 +
 .../intel-mid/device_libs/platform_mpu3050.c       |   28 ++
 .../intel-mid/device_libs/platform_mpu3050.h       |   16 +
 .../platform/intel-mid/device_libs/platform_msic.c |   87 ++++
 .../platform/intel-mid/device_libs/platform_msic.h |   19 +
 .../intel-mid/device_libs/platform_msic_audio.c    |   36 ++
 .../intel-mid/device_libs/platform_msic_audio.h    |   16 +
 .../intel-mid/device_libs/platform_msic_battery.c  |   26 ++
 .../intel-mid/device_libs/platform_msic_battery.h  |   17 +
 .../intel-mid/device_libs/platform_msic_gpio.c     |   37 ++
 .../intel-mid/device_libs/platform_msic_gpio.h     |   16 +
 .../intel-mid/device_libs/platform_msic_ocd.c      |   39 ++
 .../intel-mid/device_libs/platform_msic_ocd.h      |   16 +
 .../device_libs/platform_msic_power_btn.c          |   25 ++
 .../device_libs/platform_msic_power_btn.h          |   17 +
 .../intel-mid/device_libs/platform_msic_thermal.c  |   26 ++
 .../intel-mid/device_libs/platform_msic_thermal.h  |   17 +
 .../intel-mid/device_libs/platform_pmic_gpio.c     |   36 ++
 .../intel-mid/device_libs/platform_pmic_gpio.h     |   16 +
 .../intel-mid/device_libs/platform_tc35876x.c      |   29 ++
 .../intel-mid/device_libs/platform_tc35876x.h      |   16 +
 .../intel-mid/device_libs/platform_tca6416.c       |   45 ++
 .../intel-mid/device_libs/platform_tca6416.h       |   20 +
 arch/x86/platform/intel-mid/intel-mid.c            |  432 +-------------------
 arch/x86/platform/intel-mid/intel_mid_weak_decls.h |   15 +
 40 files changed, 1161 insertions(+), 429 deletions(-)
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
 create mode 100644 arch/x86/platform/intel-mid/intel_mid_weak_decls.h

diff --git a/arch/x86/include/asm/intel-mid.h b/arch/x86/include/asm/intel-mid.h
index ad236ae..afc282a 100644
--- a/arch/x86/include/asm/intel-mid.h
+++ b/arch/x86/include/asm/intel-mid.h
@@ -12,8 +12,11 @@
 #define _ASM_X86_INTEL_MID_H
 
 #include <linux/sfi.h>
+#include <linux/platform_device.h>
 
 extern int intel_mid_pci_init(void);
+extern int get_gpio_by_name(const char *name);
+extern void intel_scu_device_register(struct platform_device *pdev);
 extern int __init sfi_parse_mrtc(struct sfi_table_header *table);
 extern int sfi_mrtc_num;
 extern struct sfi_rtc_table_entry sfi_mrtc_array[];
@@ -54,9 +57,15 @@ static inline enum intel_mid_cpu_type intel_mid_identify_cpu(void)
 	return __intel_mid_cpu_chip;
 }
 
+static inline bool intel_mid_has_msic(void)
+{
+	return (intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_PENWELL);
+}
+
 #else /* !CONFIG_X86_INTEL_MID */
 
 #define intel_mid_identify_cpu()    (0)
+#define intel_mid_has_msic()    (0)
 
 #endif /* !CONFIG_X86_INTEL_MID */
 
@@ -93,4 +102,7 @@ extern void intel_scu_devices_destroy(void);
 
 extern void intel_mid_rtc_init(void);
 
+/* the offset for the mapping of global gpio pin to irq */
+#define INTEL_MID_IRQ_OFFSET 0x100
+
 #endif /* _ASM_X86_INTEL_MID_H */
diff --git a/arch/x86/platform/intel-mid/Makefile b/arch/x86/platform/intel-mid/Makefile
index de29635..36323ee 100644
--- a/arch/x86/platform/intel-mid/Makefile
+++ b/arch/x86/platform/intel-mid/Makefile
@@ -1,3 +1,8 @@
 obj-$(CONFIG_X86_INTEL_MID) += intel-mid.o
 obj-$(CONFIG_X86_INTEL_MID)	+= intel_mid_vrtc.o
 obj-$(CONFIG_EARLY_PRINTK_INTEL_MID)	+= early_printk_intel_mid.o
+
+# BOARD files
+obj-$(CONFIG_X86_INTEL_MID) += board.o
+# platform configuration for board devices
+obj-y += device_libs/
\ No newline at end of file
diff --git a/arch/x86/platform/intel-mid/board.c b/arch/x86/platform/intel-mid/board.c
new file mode 100644
index 0000000..6b2e8ec
--- /dev/null
+++ b/arch/x86/platform/intel-mid/board.c
@@ -0,0 +1,109 @@
+/*
+ * board.c: Intel MID board file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/sfi.h>
+#include <linux/intel_pmic_gpio.h>
+#include <linux/spi/spi.h>
+#include <linux/i2c.h>
+#include <linux/i2c/pca953x.h>
+#include <linux/gpio.h>
+#include <linux/gpio_keys.h>
+#include <linux/input.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/intel_msic.h>
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/notifier.h>
+#include <linux/i2c-gpio.h>
+
+#include <asm/setup.h>
+#include <asm/mpspec_def.h>
+#include <asm/hw_irq.h>
+#include <asm/apic.h>
+#include <asm/io_apic.h>
+#include <asm/intel-mid.h>
+#include <asm/intel_mid_vrtc.h>
+#include <asm/io.h>
+#include <asm/i8259.h>
+#include <asm/intel_scu_ipc.h>
+#include <asm/apb_timer.h>
+#include <asm/reboot.h>
+
+/*
+ * IPC devices
+ */
+#include "device_libs/platform_ipc.h"
+#include "device_libs/platform_pmic_gpio.h"
+#include "device_libs/platform_msic.h"
+#include "device_libs/platform_msic_battery.h"
+#include "device_libs/platform_msic_gpio.h"
+#include "device_libs/platform_msic_audio.h"
+#include "device_libs/platform_msic_power_btn.h"
+#include "device_libs/platform_msic_ocd.h"
+#include "device_libs/platform_msic_thermal.h"
+
+/*
+ * I2C devices
+ */
+#include "device_libs/platform_max7315.h"
+#include "device_libs/platform_tca6416.h"
+#include "device_libs/platform_mpu3050.h"
+#include "device_libs/platform_emc1403.h"
+#include "device_libs/platform_lis331.h"
+#include "device_libs/platform_mpu3050.h"
+#include "device_libs/platform_tc35876x.h"
+
+/*
+ * SPI devices
+ */
+#include "device_libs/platform_max3111.h"
+
+static void __init *no_platform_data(void *info)
+{
+	return NULL;
+}
+
+struct devs_id __initconst device_ids[] = {
+	{"bma023", SFI_DEV_TYPE_I2C, 1, &no_platform_data, NULL},
+	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data, NULL},
+	{"pmic_gpio", SFI_DEV_TYPE_IPC, 1, &pmic_gpio_platform_data,
+					&ipc_device_handler},
+	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data, NULL},
+	{"i2c_max7315", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data, NULL},
+	{"i2c_max7315_2", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data, NULL},
+	{"tca6416", SFI_DEV_TYPE_I2C, 1, &tca6416_platform_data, NULL},
+	{"emc1403", SFI_DEV_TYPE_I2C, 1, &emc1403_platform_data, NULL},
+	{"i2c_accel", SFI_DEV_TYPE_I2C, 0, &lis331dl_platform_data, NULL},
+	{"pmic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data,
+					&ipc_device_handler},
+	{"mpu3050", SFI_DEV_TYPE_I2C, 1, &mpu3050_platform_data, NULL},
+	{"i2c_disp_brig", SFI_DEV_TYPE_I2C, 0, &tc35876x_platform_data, NULL},
+
+	/* MSIC subdevices */
+	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data,
+					&ipc_device_handler},
+	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data,
+					&ipc_device_handler},
+	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data,
+					&ipc_device_handler},
+	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data,
+					&ipc_device_handler},
+	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data,
+					&ipc_device_handler},
+	{"msic_thermal", SFI_DEV_TYPE_IPC, 1, &msic_thermal_platform_data,
+					&ipc_device_handler},
+	{},
+};
diff --git a/arch/x86/platform/intel-mid/device_libs/Makefile b/arch/x86/platform/intel-mid/device_libs/Makefile
new file mode 100644
index 0000000..f076b09
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/Makefile
@@ -0,0 +1,21 @@
+# IPC Devices
+obj-y += platform_ipc.o
+obj-$(subst m,y,$(CONFIG_MFD_INTEL_MSIC)) += platform_msic.o
+obj-$(subst m,y,$(CONFIG_SND_MFLD_MACHINE)) += platform_msic_audio.o
+obj-$(subst m,y,$(CONFIG_GPIO_MSIC)) += platform_msic_gpio.o
+obj-$(subst m,y,$(CONFIG_MFD_INTEL_MSIC)) += platform_msic_ocd.o
+obj-$(subst m,y,$(CONFIG_BATTERY_INTEL_MDF)) += platform_msic_battery.o
+obj-$(subst m,y,$(CONFIG_INTEL_MID_POWER_BUTTON)) += platform_msic_power_btn.o
+obj-$(subst m,y,$(CONFIG_GPIO_INTEL_PMIC)) += platform_pmic_gpio.o
+obj-$(subst m,y,$(CONFIG_INTEL_MFLD_THERMAL)) += platform_msic_thermal.o
+# I2C Devices
+obj-$(subst m,y,$(CONFIG_SENSORS_EMC1403)) += platform_emc1403.o
+obj-$(subst m,y,$(CONFIG_SENSORS_LIS3LV02D)) += platform_lis331.o
+obj-$(subst m,y,$(CONFIG_GPIO_PCA953X)) += platform_max7315.o
+obj-$(subst m,y,$(CONFIG_SENSORS_MPU3050)) += platform_mpu3050.o
+obj-$(subst m,y,$(CONFIG_GPIO_PCA953X)) += platform_tca6416.o
+obj-$(subst m,y,$(CONFIG_DRM_MEDFIELD)) += platform_tc35876x.o
+# SPI Devices
+obj-$(subst m,y,$(CONFIG_SERIAL_MRST_MAX3110)) += platform_max3111.o
+# MISC Devices
+obj-$(subst m,y,$(CONFIG_KEYBOARD_GPIO)) += platform_gpio_keys.o
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c b/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
new file mode 100644
index 0000000..301e414
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_emc1403.c
@@ -0,0 +1,33 @@
+/*
+ * platform_emc1403.c: emc1403 platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/init.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <asm/intel-mid.h>
+#include "platform_emc1403.h"
+
+void __init *emc1403_platform_data(void *info)
+{
+	static short intr2nd_pdata;
+	struct i2c_board_info *i2c_info = info;
+	int intr = get_gpio_by_name("thermal_int");
+	int intr2nd = get_gpio_by_name("thermal_alert");
+
+	if (intr == -1 || intr2nd == -1)
+		return NULL;
+
+	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
+	intr2nd_pdata = intr2nd + INTEL_MID_IRQ_OFFSET;
+
+	return &intr2nd_pdata;
+}
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_emc1403.h b/arch/x86/platform/intel-mid/device_libs/platform_emc1403.h
new file mode 100644
index 0000000..9e1fafd
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_emc1403.h
@@ -0,0 +1,16 @@
+/*
+ * platform_emc1403.h: emc1403 platform data header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_EMC1403_H_
+#define _PLATFORM_EMC1403_H_
+
+extern void __init *emc1403_platform_data(void *info) __attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c b/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
new file mode 100644
index 0000000..4cae400
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.c
@@ -0,0 +1,82 @@
+/*
+ * platform_gpio_keys.c: gpio_keys platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/input.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/gpio.h>
+#include <linux/gpio_keys.h>
+#include <linux/platform_device.h>
+#include <asm/intel-mid.h>
+#include "platform_gpio_keys.h"
+
+/*
+ * we will search these buttons in SFI GPIO table (by name)
+ * and register them dynamically. Please add all possible
+ * buttons here, we will shrink them if no GPIO found.
+ */
+static struct gpio_keys_button gpio_button[] = {
+	{KEY_POWER,		-1, 1, "power_btn",	EV_KEY, 0, 3000},
+	{KEY_PROG1,		-1, 1, "prog_btn1",	EV_KEY, 0, 20},
+	{KEY_PROG2,		-1, 1, "prog_btn2",	EV_KEY, 0, 20},
+	{SW_LID,		-1, 1, "lid_switch",	EV_SW,  0, 20},
+	{KEY_VOLUMEUP,		-1, 1, "vol_up",	EV_KEY, 0, 20},
+	{KEY_VOLUMEDOWN,	-1, 1, "vol_down",	EV_KEY, 0, 20},
+	{KEY_CAMERA,		-1, 1, "camera_full",	EV_KEY, 0, 20},
+	{KEY_CAMERA_FOCUS,	-1, 1, "camera_half",	EV_KEY, 0, 20},
+	{SW_KEYPAD_SLIDE,	-1, 1, "MagSw1",	EV_SW,  0, 20},
+	{SW_KEYPAD_SLIDE,	-1, 1, "MagSw2",	EV_SW,  0, 20},
+};
+
+static struct gpio_keys_platform_data gpio_keys = {
+	.buttons	= gpio_button,
+	.rep		= 1,
+	.nbuttons	= -1, /* will fill it after search */
+};
+
+static struct platform_device pb_device = {
+	.name		= DEVICE_NAME,
+	.id		= -1,
+	.dev		= {
+		.platform_data	= &gpio_keys,
+	},
+};
+
+/*
+ * Shrink the non-existent buttons, register the gpio button
+ * device if there is some
+ */
+static int __init pb_keys_init(void)
+{
+	struct gpio_keys_button *gb = gpio_button;
+	int i, num, good = 0;
+
+	num = sizeof(gpio_button) / sizeof(struct gpio_keys_button);
+	for (i = 0; i < num; i++) {
+		gb[i].gpio = get_gpio_by_name(gb[i].desc);
+		pr_debug("info[%2d]: name = %s, gpio = %d\n", i, gb[i].desc,
+					gb[i].gpio);
+		if (gb[i].gpio == -1)
+			continue;
+
+		if (i != good)
+			gb[good] = gb[i];
+		good++;
+	}
+
+	if (good) {
+		gpio_keys.nbuttons = good;
+		return platform_device_register(&pb_device);
+	}
+	return 0;
+}
+late_initcall(pb_keys_init);
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.h b/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.h
new file mode 100644
index 0000000..a671505
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_gpio_keys.h
@@ -0,0 +1,16 @@
+/*
+ * platform_gpio_keys.h: gpio_keys platform data header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_GPIO_KEYS_H_
+#define _PLATFORM_GPIO_KEYS_H_
+
+#define DEVICE_NAME "gpio-keys"
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_ipc.c b/arch/x86/platform/intel-mid/device_libs/platform_ipc.c
new file mode 100644
index 0000000..eead55c
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_ipc.c
@@ -0,0 +1,59 @@
+/*
+ * platform_ipc.c: IPC platform library file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/sfi.h>
+#include <linux/gpio.h>
+#include <asm/intel-mid.h>
+#include "platform_ipc.h"
+
+void __init ipc_device_handler(struct sfi_device_table_entry *pentry,
+				struct devs_id *dev)
+{
+	struct platform_device *pdev;
+	void *pdata = NULL;
+	static struct resource __initdata res = {
+		.name = "IRQ",
+		.flags = IORESOURCE_IRQ,
+	};
+
+	pr_debug("IPC bus, name = %16.16s, irq = 0x%2x\n",
+		pentry->name, pentry->irq);
+
+	/*
+	 * We need to call platform init of IPC devices to fill misc_pdata
+	 * structure. It will be used in msic_init for initialization.
+	 */
+	if (dev != NULL)
+		pdata = dev->get_platform_data(pentry);
+
+	/*
+	 * On Medfield the platform device creation is handled by the MSIC
+	 * MFD driver so we don't need to do it here.
+	 */
+	if (intel_mid_has_msic())
+		return;
+
+	pdev = platform_device_alloc(pentry->name, 0);
+	if (pdev == NULL) {
+		pr_err("out of memory for SFI platform device '%s'.\n",
+			pentry->name);
+		return;
+	}
+	res.start = pentry->irq;
+	platform_device_add_resources(pdev, &res, 1);
+
+	pdev->dev.platform_data = pdata;
+	intel_scu_device_register(pdev);
+}
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_ipc.h b/arch/x86/platform/intel-mid/device_libs/platform_ipc.h
new file mode 100644
index 0000000..8f568dd
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_ipc.h
@@ -0,0 +1,17 @@
+/*
+ * platform_ipc.h: IPC platform library header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_IPC_H_
+#define _PLATFORM_IPC_H_
+
+extern void __init ipc_device_handler(struct sfi_device_table_entry *pentry,
+			struct devs_id *dev) __attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_lis331.c b/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
new file mode 100644
index 0000000..db96e30
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_lis331.c
@@ -0,0 +1,32 @@
+/*
+ * platform_lis331.c:  lis331 platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <asm/intel-mid.h>
+#include "platform_lis331.h"
+
+void __init *lis331dl_platform_data(void *info)
+{
+	static short intr2nd_pdata;
+	struct i2c_board_info *i2c_info = info;
+	int intr = get_gpio_by_name("accel_int");
+	int intr2nd = get_gpio_by_name("accel_2");
+
+	if (intr == -1 || intr2nd == -1)
+		return NULL;
+
+	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
+	intr2nd_pdata = intr2nd + INTEL_MID_IRQ_OFFSET;
+
+	return &intr2nd_pdata;
+}
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_lis331.h b/arch/x86/platform/intel-mid/device_libs/platform_lis331.h
new file mode 100644
index 0000000..af7512b
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_lis331.h
@@ -0,0 +1,16 @@
+/*
+ * platform_lis331.h: lis331 platform data header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_LIS331_H_
+#define _PLATFORM_LIS331_H_
+
+extern void __init *lis331dl_platform_data(void *info) __attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_max3111.c b/arch/x86/platform/intel-mid/device_libs/platform_max3111.c
new file mode 100644
index 0000000..1fdc259
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_max3111.c
@@ -0,0 +1,28 @@
+/*
+ * platform_max3111.c: max3111 platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/gpio.h>
+#include <linux/spi/spi.h>
+#include <asm/intel-mid.h>
+#include "platform_max3111.h"
+
+void __init *max3111_platform_data(void *info)
+{
+	struct spi_board_info *spi_info = info;
+	int intr = get_gpio_by_name("max3111_int");
+
+	spi_info->mode = SPI_MODE_0;
+	if (intr == -1)
+		return NULL;
+	spi_info->irq = intr + INTEL_MID_IRQ_OFFSET;
+	return NULL;
+}
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_max3111.h b/arch/x86/platform/intel-mid/device_libs/platform_max3111.h
new file mode 100644
index 0000000..66e1f26
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_max3111.h
@@ -0,0 +1,16 @@
+/*
+ * platform_max3111.h: max3111 platform data header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_MAX3111_H_
+#define _PLATFORM_MAX3111_H_
+
+extern void *max3111_platform_data(void *info) __attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_max7315.c b/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
new file mode 100644
index 0000000..1c10cb4
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_max7315.c
@@ -0,0 +1,62 @@
+/*
+ * platform_max7315.c: max7315 platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/init.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/i2c/pca953x.h>
+#include <asm/intel-mid.h>
+#include "platform_max7315.h"
+
+
+void __init *max7315_platform_data(void *info)
+{
+	static struct pca953x_platform_data max7315_pdata[MAX7315_NUM];
+	static int nr;
+	struct pca953x_platform_data *max7315 = &max7315_pdata[nr];
+	struct i2c_board_info *i2c_info = info;
+	int gpio_base, intr;
+	char base_pin_name[SFI_NAME_LEN + 1];
+	char intr_pin_name[SFI_NAME_LEN + 1];
+
+	if (nr == MAX7315_NUM) {
+		pr_err("too many max7315s, we only support %d\n",
+				MAX7315_NUM);
+		return NULL;
+	}
+	/* we have several max7315 on the board, we only need load several
+	 * instances of the same pca953x driver to cover them
+	 */
+	strcpy(i2c_info->type, "max7315");
+	if (nr++) {
+		sprintf(base_pin_name, "max7315_%d_base", nr);
+		sprintf(intr_pin_name, "max7315_%d_int", nr);
+	} else {
+		strcpy(base_pin_name, "max7315_base");
+		strcpy(intr_pin_name, "max7315_int");
+	}
+
+	gpio_base = get_gpio_by_name(base_pin_name);
+	intr = get_gpio_by_name(intr_pin_name);
+
+	if (gpio_base == -1)
+		return NULL;
+	max7315->gpio_base = gpio_base;
+	if (intr != -1) {
+		i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
+		max7315->irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
+	} else {
+		i2c_info->irq = -1;
+		max7315->irq_base = -1;
+	}
+	return max7315;
+}
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_max7315.h b/arch/x86/platform/intel-mid/device_libs/platform_max7315.h
new file mode 100644
index 0000000..d89cb7b
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_max7315.h
@@ -0,0 +1,19 @@
+/*
+ * platform_max7315.h: max7315 platform data header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_MAX7315_H_
+#define _PLATFORM_MAX7315_H_
+
+/* we have multiple max7315 on the board ... */
+#define MAX7315_NUM 2
+
+extern void __init *max7315_platform_data(void *info) __attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c b/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
new file mode 100644
index 0000000..1f91ad3
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.c
@@ -0,0 +1,28 @@
+/*
+ * platform_mpu3050.c: mpu3050 platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <asm/intel-mid.h>
+#include "platform_mpu3050.h"
+
+void *mpu3050_platform_data(void *info)
+{
+	struct i2c_board_info *i2c_info = info;
+	int intr = get_gpio_by_name("mpu3050_int");
+
+	if (intr == -1)
+		return NULL;
+
+	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
+	return NULL;
+}
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.h b/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.h
new file mode 100644
index 0000000..44452d6
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_mpu3050.h
@@ -0,0 +1,16 @@
+/*
+ * platform_mpu3050.h: mpu3050 platform data header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_MPU3050_H_
+#define _PLATFORM_MPU3050_H_
+
+extern void *mpu3050_platform_data(void *info) __attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic.c b/arch/x86/platform/intel-mid/device_libs/platform_msic.c
new file mode 100644
index 0000000..9f4a775
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic.c
@@ -0,0 +1,87 @@
+/*
+ * platform_msic.c: MSIC platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/init.h>
+#include <linux/sfi.h>
+#include <linux/mfd/intel_msic.h>
+#include <asm/intel_scu_ipc.h>
+#include <asm/intel-mid.h>
+#include "platform_msic.h"
+
+struct intel_msic_platform_data msic_pdata;
+
+static struct resource msic_resources[] = {
+	{
+		.start	= INTEL_MSIC_IRQ_PHYS_BASE,
+		.end	= INTEL_MSIC_IRQ_PHYS_BASE + 64 - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device msic_device = {
+	.name		= "intel_msic",
+	.id		= -1,
+	.dev		= {
+		.platform_data	= &msic_pdata,
+	},
+	.num_resources	= ARRAY_SIZE(msic_resources),
+	.resource	= msic_resources,
+};
+
+static int msic_scu_status_change(struct notifier_block *nb,
+				  unsigned long code, void *data)
+{
+	if (code == SCU_DOWN) {
+		platform_device_unregister(&msic_device);
+		return 0;
+	}
+
+	return platform_device_register(&msic_device);
+}
+
+static int __init msic_init(void)
+{
+	static struct notifier_block msic_scu_notifier = {
+		.notifier_call	= msic_scu_status_change,
+	};
+
+	/*
+	 * We need to be sure that the SCU IPC is ready before MSIC device
+	 * can be registered.
+	 */
+	if (intel_mid_has_msic())
+		intel_scu_notifier_add(&msic_scu_notifier);
+
+	return 0;
+}
+arch_initcall(msic_init);
+
+/*
+ * msic_generic_platform_data - sets generic platform data for the block
+ * @info: pointer to the SFI device table entry for this block
+ * @block: MSIC block
+ *
+ * Function sets IRQ number from the SFI table entry for given device to
+ * the MSIC platform data.
+ */
+void *msic_generic_platform_data(void *info, enum intel_msic_block block)
+{
+	struct sfi_device_table_entry *entry = info;
+
+	BUG_ON(block < 0 || block >= INTEL_MSIC_BLOCK_LAST);
+	msic_pdata.irq[block] = entry->irq;
+
+	return NULL;
+}
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic.h b/arch/x86/platform/intel-mid/device_libs/platform_msic.h
new file mode 100644
index 0000000..917eb56
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic.h
@@ -0,0 +1,19 @@
+/*
+ * platform_msic.h: MSIC platform data header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_MSIC_H_
+#define _PLATFORM_MSIC_H_
+
+extern struct intel_msic_platform_data msic_pdata;
+
+extern void *msic_generic_platform_data(void *info,
+			enum intel_msic_block block) __attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_audio.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_audio.c
new file mode 100644
index 0000000..942cc47
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_audio.c
@@ -0,0 +1,36 @@
+/*
+ * platform_msic_audio.c: MSIC audio platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/init.h>
+#include <linux/sfi.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/intel_msic.h>
+#include <asm/intel-mid.h>
+#include "platform_msic.h"
+#include "platform_msic_audio.h"
+
+void *msic_audio_platform_data(void *info)
+{
+	struct platform_device *pdev;
+
+	pdev = platform_device_register_simple("sst-platform", -1, NULL, 0);
+
+	if (IS_ERR(pdev)) {
+		pr_err("failed to create audio platform device\n");
+		return NULL;
+	}
+
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_AUDIO);
+}
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_audio.h b/arch/x86/platform/intel-mid/device_libs/platform_msic_audio.h
new file mode 100644
index 0000000..7d1a00e
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_audio.h
@@ -0,0 +1,16 @@
+/*
+ * platform_msic_audio.h: MSIC audio platform data header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_MSIC_AUDIO_H_
+#define _PLATFORM_MSIC_AUDIO_H_
+
+extern void __init *msic_audio_platform_data(void *info) __attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_battery.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_battery.c
new file mode 100644
index 0000000..38b6113
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_battery.c
@@ -0,0 +1,26 @@
+/*
+ * platform_msic_battery.c: MSIC battery platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/init.h>
+#include <linux/sfi.h>
+#include <linux/mfd/intel_msic.h>
+#include <asm/intel-mid.h>
+#include "platform_msic.h"
+#include "platform_msic_battery.h"
+
+void __init *msic_battery_platform_data(void *info)
+{
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_BATTERY);
+}
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_battery.h b/arch/x86/platform/intel-mid/device_libs/platform_msic_battery.h
new file mode 100644
index 0000000..d2d3d6c
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_battery.h
@@ -0,0 +1,17 @@
+/*
+ * platform_msic_battery.h: MSIC battery platform data header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_MSIC_BATTERY_H_
+#define _PLATFORM_MSIC_BATTERY_H_
+
+extern void __init *msic_battery_platform_data(void *info)
+			__attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
new file mode 100644
index 0000000..ada9bd1
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.c
@@ -0,0 +1,37 @@
+/*
+ * platform_msic_gpio.c: MSIC GPIO platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/sfi.h>
+#include <linux/init.h>
+#include <linux/gpio.h>
+#include <linux/mfd/intel_msic.h>
+#include <asm/intel-mid.h>
+#include "platform_msic.h"
+#include "platform_msic_gpio.h"
+
+void __init *msic_gpio_platform_data(void *info)
+{
+	static struct intel_msic_gpio_pdata msic_gpio_pdata;
+
+	int gpio = get_gpio_by_name("msic_gpio_base");
+
+	if (gpio < 0)
+		return NULL;
+
+	msic_gpio_pdata.gpio_base = gpio;
+	msic_pdata.gpio = &msic_gpio_pdata;
+
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_GPIO);
+}
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.h b/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.h
new file mode 100644
index 0000000..19eebc0
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_gpio.h
@@ -0,0 +1,16 @@
+/*
+ * platform_msic_gpio.h: MSIC GPIO platform data header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_MSIC_GPIO_H_
+#define _PLATFORM_MSIC_GPIO_H_
+
+extern void __init *msic_gpio_platform_data(void *info) __attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
new file mode 100644
index 0000000..18446ca
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.c
@@ -0,0 +1,39 @@
+/*
+ * platform_msic_ocd.c: MSIC OCD platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/sfi.h>
+#include <linux/init.h>
+#include <linux/gpio.h>
+#include <linux/mfd/intel_msic.h>
+#include <asm/intel-mid.h>
+#include "platform_msic.h"
+#include "platform_msic_ocd.h"
+
+void __init *msic_ocd_platform_data(void *info)
+{
+	static struct intel_msic_ocd_pdata msic_ocd_pdata;
+	int gpio;
+
+	gpio = get_gpio_by_name("ocd_gpio");
+
+	if (gpio < 0)
+		return NULL;
+
+	msic_ocd_pdata.gpio = gpio;
+	msic_pdata.ocd = &msic_ocd_pdata;
+
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_OCD);
+}
+
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.h b/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.h
new file mode 100644
index 0000000..cb08fbf
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_ocd.h
@@ -0,0 +1,16 @@
+/*
+ * platform_msic_ocd.h: MSIC OCD platform data header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_MSIC_OCD_H_
+#define _PLATFORM_MSIC_OCD_H_
+
+extern void __init *msic_ocd_platform_data(void *info) __attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_power_btn.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_power_btn.c
new file mode 100644
index 0000000..d8b087f
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_power_btn.c
@@ -0,0 +1,25 @@
+/*
+ * platform_msic_power_btn.c: MSIC power btn platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/sfi.h>
+#include <linux/init.h>
+#include <linux/mfd/intel_msic.h>
+#include <asm/intel-mid.h>
+#include "platform_msic.h"
+#include "platform_msic_power_btn.h"
+
+void __init *msic_power_btn_platform_data(void *info)
+{
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_POWER_BTN);
+}
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_power_btn.h b/arch/x86/platform/intel-mid/device_libs/platform_msic_power_btn.h
new file mode 100644
index 0000000..f389b3d
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_power_btn.h
@@ -0,0 +1,17 @@
+/*
+ * platform_msic_power_btn.h: MSIC power btn platform data header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_MSIC_POWER_BTN_H_
+#define _PLATFORM_MSIC_POWER_BTN_H_
+
+extern void __init *msic_power_btn_platform_data(void *info)
+				__attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_thermal.c b/arch/x86/platform/intel-mid/device_libs/platform_msic_thermal.c
new file mode 100644
index 0000000..236aa21
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_thermal.c
@@ -0,0 +1,26 @@
+/*
+ * platform_msic_thermal.c: msic_thermal platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/input.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/gpio.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/intel_msic.h>
+#include <asm/intel-mid.h>
+#include "platform_msic.h"
+#include "platform_msic_thermal.h"
+
+void __init *msic_thermal_platform_data(void *info)
+{
+	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_THERMAL);
+}
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_msic_thermal.h b/arch/x86/platform/intel-mid/device_libs/platform_msic_thermal.h
new file mode 100644
index 0000000..4cf45b8
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_msic_thermal.h
@@ -0,0 +1,17 @@
+/*
+ * platform_msic_thermal.h: msic_thermal platform data header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_MSIC_THERMAL_H_
+#define _PLATFORM_MSIC_THERMAL_H_
+
+extern void __init *msic_thermal_platform_data(void *info)
+			__attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c b/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
new file mode 100644
index 0000000..f5d3ec8
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.c
@@ -0,0 +1,36 @@
+/*
+ * platform_pmic_gpio.c: PMIC GPIO platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include <linux/scatterlist.h>
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/sfi.h>
+#include <asm/intel-mid.h>
+#include <linux/intel_pmic_gpio.h>
+#include "platform_pmic_gpio.h"
+
+void __init *pmic_gpio_platform_data(void *info)
+{
+	static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;
+	int gpio_base = get_gpio_by_name("pmic_gpio_base");
+
+	if (gpio_base == -1)
+		gpio_base = 64;
+	pmic_gpio_pdata.gpio_base = gpio_base;
+	pmic_gpio_pdata.irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
+	pmic_gpio_pdata.gpiointr = 0xffffeff8;
+
+	return &pmic_gpio_pdata;
+}
+
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.h b/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.h
new file mode 100644
index 0000000..e35d359
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_pmic_gpio.h
@@ -0,0 +1,16 @@
+/*
+ * platform_pmic_gpio.h: PMIC GPIO platform data header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_PMIC_GPIO_H_
+#define _PLATFORM_PMIC_GPIO_H_
+
+extern void __init *pmic_gpio_platform_data(void *info) __attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c b/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c
new file mode 100644
index 0000000..dd9ef63
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.c
@@ -0,0 +1,29 @@
+/*
+ * platform_tc35876x.c: tc35876x platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/gpio.h>
+#include <linux/i2c/tc35876x.h>
+#include <asm/intel-mid.h>
+#include "platform_tc35876x.h"
+
+/*tc35876x DSI_LVDS bridge chip and panel platform data*/
+void *tc35876x_platform_data(void *data)
+{
+	static struct tc35876x_platform_data pdata;
+
+	/* gpio pins set to -1 will not be used by the driver */
+	pdata.gpio_bridge_reset = get_gpio_by_name("LCMB_RXEN");
+	pdata.gpio_panel_bl_en = get_gpio_by_name("6S6P_BL_EN");
+	pdata.gpio_panel_vadd = get_gpio_by_name("EN_VREG_LCD_V3P3");
+
+	return &pdata;
+}
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.h b/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.h
new file mode 100644
index 0000000..21ccf23
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_tc35876x.h
@@ -0,0 +1,16 @@
+/*
+ * platform_tc35876x.h: tc35876x platform data header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_TC35876X_H_
+#define _PLATFORM_TC35876X_H_
+
+extern void *tc35876x_platform_data(void *info) __attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c b/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
new file mode 100644
index 0000000..79fccdd
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_tca6416.c
@@ -0,0 +1,45 @@
+/*
+ * platform_tca6416.c: tca6416 platform data initilization file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/i2c/pca953x.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <asm/intel-mid.h>
+#include "platform_tca6416.h"
+
+void *tca6416_platform_data(void *info)
+{
+	static struct pca953x_platform_data tca6416;
+	struct i2c_board_info *i2c_info = info;
+	int gpio_base, intr;
+	char base_pin_name[SFI_NAME_LEN + 1];
+	char intr_pin_name[SFI_NAME_LEN + 1];
+
+	strcpy(i2c_info->type, TCA6416_NAME);
+	strcpy(base_pin_name, TCA6416_BASE);
+	strcpy(intr_pin_name, TCA6416_INTR);
+
+	gpio_base = get_gpio_by_name(base_pin_name);
+	intr = get_gpio_by_name(intr_pin_name);
+
+	if (gpio_base == -1)
+		return NULL;
+	tca6416.gpio_base = gpio_base;
+	if (intr != -1) {
+		i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
+		tca6416.irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
+	} else {
+		i2c_info->irq = -1;
+		tca6416.irq_base = -1;
+	}
+	return &tca6416;
+}
diff --git a/arch/x86/platform/intel-mid/device_libs/platform_tca6416.h b/arch/x86/platform/intel-mid/device_libs/platform_tca6416.h
new file mode 100644
index 0000000..fe9c041
--- /dev/null
+++ b/arch/x86/platform/intel-mid/device_libs/platform_tca6416.h
@@ -0,0 +1,20 @@
+/*
+ * platform_tca6416.h: tca6416 platform data header file
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _PLATFORM_TCA6416_H_
+#define _PLATFORM_TCA6416_H_
+
+#define TCA6416_NAME	"tca6416"
+#define TCA6416_BASE	"tca6416_base"
+#define TCA6416_INTR	"tca6416_int"
+
+extern void *tca6416_platform_data(void *info) __attribute__((weak));
+#endif
diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index 1018ee8..e770028 100644
--- a/arch/x86/platform/intel-mid/intel-mid.c
+++ b/arch/x86/platform/intel-mid/intel-mid.c
@@ -44,6 +44,7 @@
 #include <asm/intel_scu_ipc.h>
 #include <asm/apb_timer.h>
 #include <asm/reboot.h>
+#include "intel_mid_weak_decls.h"
 
 /*
  * the clockevent devices on Moorestown/Medfield can be APBT or LAPIC clock,
@@ -78,8 +79,6 @@ int sfi_mtimer_num;
 struct sfi_rtc_table_entry sfi_mrtc_array[SFI_MRTC_MAX];
 EXPORT_SYMBOL_GPL(sfi_mrtc_array);
 int sfi_mrtc_num;
-static void __init ipc_device_handler(struct sfi_device_table_entry *pentry,
-			struct devs_id *dev);
 
 static void intel_mid_power_off(void)
 {
@@ -374,7 +373,7 @@ static int __init sfi_parse_gpio(struct sfi_table_header *table)
 	return 0;
 }
 
-static int get_gpio_by_name(const char *name)
+int get_gpio_by_name(const char *name)
 {
 	struct sfi_gpio_table_entry *pentry = gpio_table;
 	int i;
@@ -388,329 +387,6 @@ static int get_gpio_by_name(const char *name)
 	return -1;
 }
 
-/* the offset for the mapping of global gpio pin to irq */
-#define INTEL_MID_IRQ_OFFSET 0x100
-
-static void __init *pmic_gpio_platform_data(void *info)
-{
-	static struct intel_pmic_gpio_platform_data pmic_gpio_pdata;
-	int gpio_base = get_gpio_by_name("pmic_gpio_base");
-
-	if (gpio_base == -1)
-		gpio_base = 64;
-	pmic_gpio_pdata.gpio_base = gpio_base;
-	pmic_gpio_pdata.irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
-	pmic_gpio_pdata.gpiointr = 0xffffeff8;
-
-	return &pmic_gpio_pdata;
-}
-
-static void __init *max3111_platform_data(void *info)
-{
-	struct spi_board_info *spi_info = info;
-	int intr = get_gpio_by_name("max3111_int");
-
-	spi_info->mode = SPI_MODE_0;
-	if (intr == -1)
-		return NULL;
-	spi_info->irq = intr + INTEL_MID_IRQ_OFFSET;
-	return NULL;
-}
-
-/* we have multiple max7315 on the board ... */
-#define MAX7315_NUM 2
-static void __init *max7315_platform_data(void *info)
-{
-	static struct pca953x_platform_data max7315_pdata[MAX7315_NUM];
-	static int nr;
-	struct pca953x_platform_data *max7315 = &max7315_pdata[nr];
-	struct i2c_board_info *i2c_info = info;
-	int gpio_base, intr;
-	char base_pin_name[SFI_NAME_LEN + 1];
-	char intr_pin_name[SFI_NAME_LEN + 1];
-
-	if (nr == MAX7315_NUM) {
-		pr_err("too many max7315s, we only support %d\n",
-				MAX7315_NUM);
-		return NULL;
-	}
-	/* we have several max7315 on the board, we only need load several
-	 * instances of the same pca953x driver to cover them
-	 */
-	strcpy(i2c_info->type, "max7315");
-	if (nr++) {
-		sprintf(base_pin_name, "max7315_%d_base", nr);
-		sprintf(intr_pin_name, "max7315_%d_int", nr);
-	} else {
-		strcpy(base_pin_name, "max7315_base");
-		strcpy(intr_pin_name, "max7315_int");
-	}
-
-	gpio_base = get_gpio_by_name(base_pin_name);
-	intr = get_gpio_by_name(intr_pin_name);
-
-	if (gpio_base == -1)
-		return NULL;
-	max7315->gpio_base = gpio_base;
-	if (intr != -1) {
-		i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
-		max7315->irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
-	} else {
-		i2c_info->irq = -1;
-		max7315->irq_base = -1;
-	}
-	return max7315;
-}
-
-static void *tca6416_platform_data(void *info)
-{
-	static struct pca953x_platform_data tca6416;
-	struct i2c_board_info *i2c_info = info;
-	int gpio_base, intr;
-	char base_pin_name[SFI_NAME_LEN + 1];
-	char intr_pin_name[SFI_NAME_LEN + 1];
-
-	strcpy(i2c_info->type, "tca6416");
-	strcpy(base_pin_name, "tca6416_base");
-	strcpy(intr_pin_name, "tca6416_int");
-
-	gpio_base = get_gpio_by_name(base_pin_name);
-	intr = get_gpio_by_name(intr_pin_name);
-
-	if (gpio_base == -1)
-		return NULL;
-	tca6416.gpio_base = gpio_base;
-	if (intr != -1) {
-		i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
-		tca6416.irq_base = gpio_base + INTEL_MID_IRQ_OFFSET;
-	} else {
-		i2c_info->irq = -1;
-		tca6416.irq_base = -1;
-	}
-	return &tca6416;
-}
-
-static void *mpu3050_platform_data(void *info)
-{
-	struct i2c_board_info *i2c_info = info;
-	int intr = get_gpio_by_name("mpu3050_int");
-
-	if (intr == -1)
-		return NULL;
-
-	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
-	return NULL;
-}
-
-static void __init *emc1403_platform_data(void *info)
-{
-	static short intr2nd_pdata;
-	struct i2c_board_info *i2c_info = info;
-	int intr = get_gpio_by_name("thermal_int");
-	int intr2nd = get_gpio_by_name("thermal_alert");
-
-	if (intr == -1 || intr2nd == -1)
-		return NULL;
-
-	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
-	intr2nd_pdata = intr2nd + INTEL_MID_IRQ_OFFSET;
-
-	return &intr2nd_pdata;
-}
-
-static void __init *lis331dl_platform_data(void *info)
-{
-	static short intr2nd_pdata;
-	struct i2c_board_info *i2c_info = info;
-	int intr = get_gpio_by_name("accel_int");
-	int intr2nd = get_gpio_by_name("accel_2");
-
-	if (intr == -1 || intr2nd == -1)
-		return NULL;
-
-	i2c_info->irq = intr + INTEL_MID_IRQ_OFFSET;
-	intr2nd_pdata = intr2nd + INTEL_MID_IRQ_OFFSET;
-
-	return &intr2nd_pdata;
-}
-
-static void __init *no_platform_data(void *info)
-{
-	return NULL;
-}
-
-static struct resource msic_resources[] = {
-	{
-		.start	= INTEL_MSIC_IRQ_PHYS_BASE,
-		.end	= INTEL_MSIC_IRQ_PHYS_BASE + 64 - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-};
-
-static struct intel_msic_platform_data msic_pdata;
-
-static struct platform_device msic_device = {
-	.name		= "intel_msic",
-	.id		= -1,
-	.dev		= {
-		.platform_data	= &msic_pdata,
-	},
-	.num_resources	= ARRAY_SIZE(msic_resources),
-	.resource	= msic_resources,
-};
-
-static inline bool intel_mid_has_msic(void)
-{
-	return intel_mid_identify_cpu() == INTEL_MID_CPU_CHIP_PENWELL;
-}
-
-static int msic_scu_status_change(struct notifier_block *nb,
-				  unsigned long code, void *data)
-{
-	if (code == SCU_DOWN) {
-		platform_device_unregister(&msic_device);
-		return 0;
-	}
-
-	return platform_device_register(&msic_device);
-}
-
-static int __init msic_init(void)
-{
-	static struct notifier_block msic_scu_notifier = {
-		.notifier_call	= msic_scu_status_change,
-	};
-
-	/*
-	 * We need to be sure that the SCU IPC is ready before MSIC device
-	 * can be registered.
-	 */
-	if (intel_mid_has_msic())
-		intel_scu_notifier_add(&msic_scu_notifier);
-
-	return 0;
-}
-arch_initcall(msic_init);
-
-/*
- * msic_generic_platform_data - sets generic platform data for the block
- * @info: pointer to the SFI device table entry for this block
- * @block: MSIC block
- *
- * Function sets IRQ number from the SFI table entry for given device to
- * the MSIC platform data.
- */
-static void *msic_generic_platform_data(void *info, enum intel_msic_block block)
-{
-	struct sfi_device_table_entry *entry = info;
-
-	BUG_ON(block < 0 || block >= INTEL_MSIC_BLOCK_LAST);
-	msic_pdata.irq[block] = entry->irq;
-
-	return no_platform_data(info);
-}
-
-static void *msic_battery_platform_data(void *info)
-{
-	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_BATTERY);
-}
-
-static void *msic_gpio_platform_data(void *info)
-{
-	static struct intel_msic_gpio_pdata pdata;
-	int gpio = get_gpio_by_name("msic_gpio_base");
-
-	if (gpio < 0)
-		return NULL;
-
-	pdata.gpio_base = gpio;
-	msic_pdata.gpio = &pdata;
-
-	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_GPIO);
-}
-
-static void *msic_audio_platform_data(void *info)
-{
-	struct platform_device *pdev;
-
-	pdev = platform_device_register_simple("sst-platform", -1, NULL, 0);
-	if (IS_ERR(pdev)) {
-		pr_err("failed to create audio platform device\n");
-		return NULL;
-	}
-
-	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_AUDIO);
-}
-
-static void *msic_power_btn_platform_data(void *info)
-{
-	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_POWER_BTN);
-}
-
-static void *msic_ocd_platform_data(void *info)
-{
-	static struct intel_msic_ocd_pdata pdata;
-	int gpio = get_gpio_by_name("ocd_gpio");
-
-	if (gpio < 0)
-		return NULL;
-
-	pdata.gpio = gpio;
-	msic_pdata.ocd = &pdata;
-
-	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_OCD);
-}
-
-static void *msic_thermal_platform_data(void *info)
-{
-	return msic_generic_platform_data(info, INTEL_MSIC_BLOCK_THERMAL);
-}
-
-/* tc35876x DSI-LVDS bridge chip and panel platform data */
-static void *tc35876x_platform_data(void *data)
-{
-	static struct tc35876x_platform_data pdata;
-
-	/* gpio pins set to -1 will not be used by the driver */
-	pdata.gpio_bridge_reset = get_gpio_by_name("LCMB_RXEN");
-	pdata.gpio_panel_bl_en = get_gpio_by_name("6S6P_BL_EN");
-	pdata.gpio_panel_vadd = get_gpio_by_name("EN_VREG_LCD_V3P3");
-
-	return &pdata;
-}
-
-static const struct devs_id __initconst device_ids[] = {
-	{"bma023", SFI_DEV_TYPE_I2C, 1, &no_platform_data, NULL},
-	{"pmic_gpio", SFI_DEV_TYPE_SPI, 1, &pmic_gpio_platform_data, NULL},
-	{"pmic_gpio", SFI_DEV_TYPE_IPC, 1, &pmic_gpio_platform_data,
-					&ipc_device_handler},
-	{"spi_max3111", SFI_DEV_TYPE_SPI, 0, &max3111_platform_data, NULL},
-	{"i2c_max7315", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data, NULL},
-	{"i2c_max7315_2", SFI_DEV_TYPE_I2C, 1, &max7315_platform_data, NULL},
-	{"tca6416", SFI_DEV_TYPE_I2C, 1, &tca6416_platform_data, NULL},
-	{"emc1403", SFI_DEV_TYPE_I2C, 1, &emc1403_platform_data, NULL},
-	{"i2c_accel", SFI_DEV_TYPE_I2C, 0, &lis331dl_platform_data, NULL},
-	{"pmic_audio", SFI_DEV_TYPE_IPC, 1, &no_platform_data,
-					&ipc_device_handler},
-	{"mpu3050", SFI_DEV_TYPE_I2C, 1, &mpu3050_platform_data, NULL},
-	{"i2c_disp_brig", SFI_DEV_TYPE_I2C, 0, &tc35876x_platform_data, NULL},
-
-	/* MSIC subdevices */
-	{"msic_battery", SFI_DEV_TYPE_IPC, 1, &msic_battery_platform_data,
-					&ipc_device_handler},
-	{"msic_gpio", SFI_DEV_TYPE_IPC, 1, &msic_gpio_platform_data,
-					&ipc_device_handler},
-	{"msic_audio", SFI_DEV_TYPE_IPC, 1, &msic_audio_platform_data,
-					&ipc_device_handler},
-	{"msic_power_btn", SFI_DEV_TYPE_IPC, 1, &msic_power_btn_platform_data,
-					&ipc_device_handler},
-	{"msic_ocd", SFI_DEV_TYPE_IPC, 1, &msic_ocd_platform_data,
-					&ipc_device_handler},
-	{"msic_thermal", SFI_DEV_TYPE_IPC, 1, &msic_thermal_platform_data,
-					&ipc_device_handler},
-	{},
-};
-
 #define MAX_IPCDEVS	24
 static struct platform_device *ipc_devs[MAX_IPCDEVS];
 static int ipc_next_dev;
@@ -724,7 +400,7 @@ static struct i2c_board_info *i2c_devs[MAX_SCU_I2C];
 static int i2c_bus[MAX_SCU_I2C];
 static int i2c_next_dev;
 
-static void __init intel_scu_device_register(struct platform_device *pdev)
+void __init intel_scu_device_register(struct platform_device *pdev)
 {
 	if (ipc_next_dev == MAX_IPCDEVS)
 		pr_err("too many SCU IPC devices");
@@ -902,46 +578,6 @@ static void __init sfi_handle_i2c_dev(struct sfi_device_table_entry *pentry,
 		i2c_register_board_info(pentry->host_num, &i2c_info, 1);
 }
 
-static void __init ipc_device_handler(struct sfi_device_table_entry *pentry,
-				struct devs_id *dev)
-{
-	struct platform_device *pdev;
-	void *pdata = NULL;
-	static struct resource __initdata res = {
-		.name = "IRQ",
-		.flags = IORESOURCE_IRQ,
-	};
-
-	pr_debug("IPC bus, name = %16.16s, irq = 0x%2x\n",
-		pentry->name, pentry->irq);
-
-	/*
-	 * We need to call platform init of IPC devices to fill misc_pdata
-	 * structure. It will be used in msic_init for initialization.
-	 */
-	if (dev != NULL)
-		pdata = dev->get_platform_data(pentry);
-
-	/*
-	 * On Medfield the platform device creation is handled by the MSIC
-	 * MFD driver so we don't need to do it here.
-	 */
-	if (intel_mid_has_msic())
-		return;
-
-	pdev = platform_device_alloc(pentry->name, 0);
-	if (pdev == NULL) {
-		pr_err("out of memory for SFI platform device '%s'.\n",
-			pentry->name);
-		return;
-	}
-	res.start = pentry->irq;
-	platform_device_add_resources(pdev, &res, 1);
-
-	pdev->dev.platform_data = pdata;
-	intel_scu_device_register(pdev);
-}
-
 static struct devs_id __init *get_device_id(u8 type, char *name)
 {
 	struct devs_id *dev = device_ids;
@@ -1025,65 +661,3 @@ static int __init intel_mid_platform_init(void)
 	return 0;
 }
 arch_initcall(intel_mid_platform_init);
-
-/*
- * we will search these buttons in SFI GPIO table (by name)
- * and register them dynamically. Please add all possible
- * buttons here, we will shrink them if no GPIO found.
- */
-static struct gpio_keys_button gpio_button[] = {
-	{KEY_POWER,		-1, 1, "power_btn",	EV_KEY, 0, 3000},
-	{KEY_PROG1,		-1, 1, "prog_btn1",	EV_KEY, 0, 20},
-	{KEY_PROG2,		-1, 1, "prog_btn2",	EV_KEY, 0, 20},
-	{SW_LID,		-1, 1, "lid_switch",	EV_SW,  0, 20},
-	{KEY_VOLUMEUP,		-1, 1, "vol_up",	EV_KEY, 0, 20},
-	{KEY_VOLUMEDOWN,	-1, 1, "vol_down",	EV_KEY, 0, 20},
-	{KEY_CAMERA,		-1, 1, "camera_full",	EV_KEY, 0, 20},
-	{KEY_CAMERA_FOCUS,	-1, 1, "camera_half",	EV_KEY, 0, 20},
-	{SW_KEYPAD_SLIDE,	-1, 1, "MagSw1",	EV_SW,  0, 20},
-	{SW_KEYPAD_SLIDE,	-1, 1, "MagSw2",	EV_SW,  0, 20},
-};
-
-static struct gpio_keys_platform_data intel_mid_gpio_keys = {
-	.buttons	= gpio_button,
-	.rep		= 1,
-	.nbuttons	= -1, /* will fill it after search */
-};
-
-static struct platform_device pb_device = {
-	.name		= "gpio-keys",
-	.id		= -1,
-	.dev		= {
-		.platform_data	= &intel_mid_gpio_keys,
-	},
-};
-
-/*
- * Shrink the non-existent buttons, register the gpio button
- * device if there is some
- */
-static int __init pb_keys_init(void)
-{
-	struct gpio_keys_button *gb = gpio_button;
-	int i, num, good = 0;
-
-	num = sizeof(gpio_button) / sizeof(struct gpio_keys_button);
-	for (i = 0; i < num; i++) {
-		gb[i].gpio = get_gpio_by_name(gb[i].desc);
-		pr_debug("info[%2d]: name = %s, gpio = %d\n", i, gb[i].desc,
-					gb[i].gpio);
-		if (gb[i].gpio == -1)
-			continue;
-
-		if (i != good)
-			gb[good] = gb[i];
-		good++;
-	}
-
-	if (good) {
-		intel_mid_gpio_keys.nbuttons = good;
-		return platform_device_register(&pb_device);
-	}
-	return 0;
-}
-late_initcall(pb_keys_init);
diff --git a/arch/x86/platform/intel-mid/intel_mid_weak_decls.h b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
new file mode 100644
index 0000000..dcbe643
--- /dev/null
+++ b/arch/x86/platform/intel-mid/intel_mid_weak_decls.h
@@ -0,0 +1,15 @@
+/*
+ * intel_mid_weak_decls.h: Weak declarations of intel-mid.c
+ *
+ * (C) Copyright 2013 Intel Corporation
+ * Author: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+
+/* __attribute__((weak)) makes these declarations overridable */
+extern struct devs_id __initconst device_ids[] __attribute__((weak));
-- 
1.7.9.5

