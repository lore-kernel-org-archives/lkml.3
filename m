Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab3CONCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:02:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42236 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab3CONCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:02:30 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 03/50] staging: omap-thermal: create header for register, bitfields and definitions
Date: Fri, 15 Mar 2013 08:59:51 -0400
Message-ID: <1363352438-15935-4-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to have a better code readability and organization, this patch
splits omap-bandgap.h into three headers.
. omap-bandgap.h will contain only the driver related data structures
definitions and macros
. omap4xxx-bandgap.h will contain only defines and bitfields
related to OMAP4 based devices
. omap5xxx-bandgap.h will contain only defines and bitfields
related to OMAP5 based devices

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.h       |  195 --------------------
 drivers/staging/omap-thermal/omap4-thermal-data.c |    1 +
 drivers/staging/omap-thermal/omap4xxx-bandgap.h   |  175 ++++++++++++++++++
 drivers/staging/omap-thermal/omap5-thermal-data.c |    1 +
 drivers/staging/omap-thermal/omap5xxx-bandgap.h   |  199 +++++++++++++++++++++
 5 files changed, 376 insertions(+), 195 deletions(-)
 create mode 100644 drivers/staging/omap-thermal/omap4xxx-bandgap.h
 create mode 100644 drivers/staging/omap-thermal/omap5xxx-bandgap.h

diff --git a/drivers/staging/omap-thermal/omap-bandgap.h b/drivers/staging/omap-thermal/omap-bandgap.h
index 5ce1659..7d5ac3f 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.h
+++ b/drivers/staging/omap-thermal/omap-bandgap.h
@@ -27,201 +27,6 @@
 #include <linux/types.h>
 #include <linux/err.h>
 
-/* TEMP_SENSOR OMAP4430 */
-#define OMAP4430_BGAP_TSHUT_MASK			BIT(11)
-
-/* TEMP_SENSOR OMAP4430 */
-#define OMAP4430_BGAP_TEMPSOFF_MASK			BIT(12)
-#define OMAP4430_SINGLE_MODE_MASK			BIT(10)
-#define OMAP4430_BGAP_TEMP_SENSOR_SOC_MASK		BIT(9)
-#define OMAP4430_BGAP_TEMP_SENSOR_EOCZ_MASK		BIT(8)
-#define OMAP4430_BGAP_TEMP_SENSOR_DTEMP_MASK		(0xff << 0)
-
-#define OMAP4430_ADC_START_VALUE			0
-#define OMAP4430_ADC_END_VALUE				127
-#define OMAP4430_MAX_FREQ				32768
-#define OMAP4430_MIN_FREQ				32768
-#define OMAP4430_MIN_TEMP				-40000
-#define OMAP4430_MAX_TEMP				125000
-#define OMAP4430_HYST_VAL				5000
-
-/* TEMP_SENSOR OMAP4460 */
-#define OMAP4460_BGAP_TEMPSOFF_MASK			BIT(13)
-#define OMAP4460_BGAP_TEMP_SENSOR_SOC_MASK		BIT(11)
-#define OMAP4460_BGAP_TEMP_SENSOR_EOCZ_MASK		BIT(10)
-#define OMAP4460_BGAP_TEMP_SENSOR_DTEMP_MASK		(0x3ff << 0)
-
-/* BANDGAP_CTRL */
-#define OMAP4460_SINGLE_MODE_MASK			BIT(31)
-#define OMAP4460_MASK_HOT_MASK				BIT(1)
-#define OMAP4460_MASK_COLD_MASK				BIT(0)
-
-/* BANDGAP_COUNTER */
-#define OMAP4460_COUNTER_MASK				(0xffffff << 0)
-
-/* BANDGAP_THRESHOLD */
-#define OMAP4460_T_HOT_MASK				(0x3ff << 16)
-#define OMAP4460_T_COLD_MASK				(0x3ff << 0)
-
-/* TSHUT_THRESHOLD */
-#define OMAP4460_TSHUT_HOT_MASK				(0x3ff << 16)
-#define OMAP4460_TSHUT_COLD_MASK			(0x3ff << 0)
-
-/* BANDGAP_STATUS */
-#define OMAP4460_CLEAN_STOP_MASK			BIT(3)
-#define OMAP4460_BGAP_ALERT_MASK			BIT(2)
-#define OMAP4460_HOT_FLAG_MASK				BIT(1)
-#define OMAP4460_COLD_FLAG_MASK				BIT(0)
-
-/* TEMP_SENSOR OMAP5430 */
-#define OMAP5430_BGAP_TEMP_SENSOR_SOC_MASK		BIT(12)
-#define OMAP5430_BGAP_TEMPSOFF_MASK			BIT(11)
-#define OMAP5430_BGAP_TEMP_SENSOR_EOCZ_MASK		BIT(10)
-#define OMAP5430_BGAP_TEMP_SENSOR_DTEMP_MASK		(0x3ff << 0)
-
-/* BANDGAP_CTRL */
-#define OMAP5430_MASK_HOT_CORE_MASK			BIT(5)
-#define OMAP5430_MASK_COLD_CORE_MASK			BIT(4)
-#define OMAP5430_MASK_HOT_GPU_MASK			BIT(3)
-#define OMAP5430_MASK_COLD_GPU_MASK			BIT(2)
-#define OMAP5430_MASK_HOT_MPU_MASK			BIT(1)
-#define OMAP5430_MASK_COLD_MPU_MASK			BIT(0)
-#define OMAP5430_MASK_SIDLEMODE_MASK			(0x3 << 30)
-#define OMAP5430_MASK_FREEZE_CORE_MASK			BIT(23)
-#define OMAP5430_MASK_FREEZE_GPU_MASK			BIT(22)
-#define OMAP5430_MASK_FREEZE_MPU_MASK			BIT(21)
-#define OMAP5430_MASK_CLEAR_CORE_MASK			BIT(20)
-#define OMAP5430_MASK_CLEAR_GPU_MASK			BIT(19)
-#define OMAP5430_MASK_CLEAR_MPU_MASK			BIT(18)
-#define OMAP5430_MASK_CLEAR_ACCUM_CORE_MASK		BIT(17)
-#define OMAP5430_MASK_CLEAR_ACCUM_GPU_MASK		BIT(16)
-#define OMAP5430_MASK_CLEAR_ACCUM_MPU_MASK		BIT(15)
-
-/* BANDGAP_COUNTER */
-#define OMAP5430_COUNTER_MASK				(0xffffff << 0)
-
-/* BANDGAP_THRESHOLD */
-#define OMAP5430_T_HOT_MASK				(0x3ff << 16)
-#define OMAP5430_T_COLD_MASK				(0x3ff << 0)
-
-/* TSHUT_THRESHOLD */
-#define OMAP5430_TSHUT_HOT_MASK				(0x3ff << 16)
-#define OMAP5430_TSHUT_COLD_MASK			(0x3ff << 0)
-
-/* BANDGAP_CUMUL_DTEMP_MPU */
-#define OMAP5430_CUMUL_DTEMP_MPU_MASK			(0xffffffff << 0)
-
-/* BANDGAP_CUMUL_DTEMP_GPU */
-#define OMAP5430_CUMUL_DTEMP_GPU_MASK			(0xffffffff << 0)
-
-/* BANDGAP_CUMUL_DTEMP_CORE */
-#define OMAP5430_CUMUL_DTEMP_CORE_MASK			(0xffffffff << 0)
-
-/* BANDGAP_STATUS */
-#define OMAP5430_BGAP_ALERT_MASK			BIT(31)
-#define OMAP5430_HOT_CORE_FLAG_MASK			BIT(5)
-#define OMAP5430_COLD_CORE_FLAG_MASK			BIT(4)
-#define OMAP5430_HOT_GPU_FLAG_MASK			BIT(3)
-#define OMAP5430_COLD_GPU_FLAG_MASK			BIT(2)
-#define OMAP5430_HOT_MPU_FLAG_MASK			BIT(1)
-#define OMAP5430_COLD_MPU_FLAG_MASK			BIT(0)
-
-/* Offsets from the base of temperature sensor registers */
-
-/* 4430 - All goes relative to OPP_BGAP */
-#define OMAP4430_FUSE_OPP_BGAP				0x0
-#define OMAP4430_TEMP_SENSOR_CTRL_OFFSET		0xCC
-
-/* 4460 - All goes relative to OPP_BGAP */
-#define OMAP4460_FUSE_OPP_BGAP				0x0
-#define OMAP4460_TEMP_SENSOR_CTRL_OFFSET		0xCC
-#define OMAP4460_BGAP_CTRL_OFFSET			0x118
-#define OMAP4460_BGAP_COUNTER_OFFSET			0x11C
-#define OMAP4460_BGAP_THRESHOLD_OFFSET			0x120
-#define OMAP4460_BGAP_TSHUT_OFFSET			0x124
-#define OMAP4460_BGAP_STATUS_OFFSET			0x128
-
-/* 5430 - All goes relative to OPP_BGAP_GPU */
-#define OMAP5430_FUSE_OPP_BGAP_GPU			0x0
-#define OMAP5430_TEMP_SENSOR_GPU_OFFSET			0x150
-#define OMAP5430_BGAP_THRESHOLD_GPU_OFFSET		0x1A8
-#define OMAP5430_BGAP_TSHUT_GPU_OFFSET			0x1B4
-#define OMAP5430_BGAP_CUMUL_DTEMP_GPU_OFFSET		0x1C0
-#define OMAP5430_BGAP_DTEMP_GPU_0_OFFSET		0x1F4
-#define OMAP5430_BGAP_DTEMP_GPU_1_OFFSET		0x1F8
-#define OMAP5430_BGAP_DTEMP_GPU_2_OFFSET		0x1FC
-#define OMAP5430_BGAP_DTEMP_GPU_3_OFFSET		0x200
-#define OMAP5430_BGAP_DTEMP_GPU_4_OFFSET		0x204
-
-#define OMAP5430_FUSE_OPP_BGAP_MPU			0x4
-#define OMAP5430_TEMP_SENSOR_MPU_OFFSET			0x14C
-#define OMAP5430_BGAP_CTRL_OFFSET			0x1A0
-#define OMAP5430_BGAP_THRESHOLD_MPU_OFFSET		0x1A4
-#define OMAP5430_BGAP_TSHUT_MPU_OFFSET			0x1B0
-#define OMAP5430_BGAP_CUMUL_DTEMP_MPU_OFFSET		0x1BC
-#define OMAP5430_BGAP_DTEMP_MPU_0_OFFSET		0x1E0
-#define OMAP5430_BGAP_DTEMP_MPU_1_OFFSET		0x1E4
-#define OMAP5430_BGAP_DTEMP_MPU_2_OFFSET		0x1E8
-#define OMAP5430_BGAP_DTEMP_MPU_3_OFFSET		0x1EC
-#define OMAP5430_BGAP_DTEMP_MPU_4_OFFSET		0x1F0
-
-#define OMAP5430_FUSE_OPP_BGAP_CORE			0x8
-#define OMAP5430_TEMP_SENSOR_CORE_OFFSET		0x154
-#define OMAP5430_BGAP_THRESHOLD_CORE_OFFSET		0x1AC
-#define OMAP5430_BGAP_TSHUT_CORE_OFFSET			0x1B8
-#define OMAP5430_BGAP_CUMUL_DTEMP_CORE_OFFSET		0x1C4
-#define OMAP5430_BGAP_DTEMP_CORE_0_OFFSET		0x208
-#define OMAP5430_BGAP_DTEMP_CORE_1_OFFSET		0x20C
-#define OMAP5430_BGAP_DTEMP_CORE_2_OFFSET		0x210
-#define OMAP5430_BGAP_DTEMP_CORE_3_OFFSET		0x214
-#define OMAP5430_BGAP_DTEMP_CORE_4_OFFSET		0x218
-
-#define OMAP5430_BGAP_STATUS_OFFSET			0x1C8
-
-#define OMAP4460_TSHUT_HOT				900	/* 122 deg C */
-#define OMAP4460_TSHUT_COLD				895	/* 100 deg C */
-#define OMAP4460_T_HOT					800	/* 73 deg C */
-#define OMAP4460_T_COLD					795	/* 71 deg C */
-#define OMAP4460_MAX_FREQ				1500000
-#define OMAP4460_MIN_FREQ				1000000
-#define OMAP4460_MIN_TEMP				-40000
-#define OMAP4460_MAX_TEMP				123000
-#define OMAP4460_HYST_VAL				5000
-#define OMAP4460_ADC_START_VALUE			530
-#define OMAP4460_ADC_END_VALUE				932
-
-#define OMAP5430_MPU_TSHUT_HOT				915
-#define OMAP5430_MPU_TSHUT_COLD				900
-#define OMAP5430_MPU_T_HOT				800
-#define OMAP5430_MPU_T_COLD				795
-#define OMAP5430_MPU_MAX_FREQ				1500000
-#define OMAP5430_MPU_MIN_FREQ				1000000
-#define OMAP5430_MPU_MIN_TEMP				-40000
-#define OMAP5430_MPU_MAX_TEMP				125000
-#define OMAP5430_MPU_HYST_VAL				5000
-#define OMAP5430_ADC_START_VALUE			540
-#define OMAP5430_ADC_END_VALUE				945
-
-#define OMAP5430_GPU_TSHUT_HOT				915
-#define OMAP5430_GPU_TSHUT_COLD				900
-#define OMAP5430_GPU_T_HOT				800
-#define OMAP5430_GPU_T_COLD				795
-#define OMAP5430_GPU_MAX_FREQ				1500000
-#define OMAP5430_GPU_MIN_FREQ				1000000
-#define OMAP5430_GPU_MIN_TEMP				-40000
-#define OMAP5430_GPU_MAX_TEMP				125000
-#define OMAP5430_GPU_HYST_VAL				5000
-
-#define OMAP5430_CORE_TSHUT_HOT				915
-#define OMAP5430_CORE_TSHUT_COLD			900
-#define OMAP5430_CORE_T_HOT				800
-#define OMAP5430_CORE_T_COLD				795
-#define OMAP5430_CORE_MAX_FREQ				1500000
-#define OMAP5430_CORE_MIN_FREQ				1000000
-#define OMAP5430_CORE_MIN_TEMP				-40000
-#define OMAP5430_CORE_MAX_TEMP				125000
-#define OMAP5430_CORE_HYST_VAL				5000
-
 /**
  * The register offsets and bit fields might change across
  * OMAP versions hence populating them in this structure.
diff --git a/drivers/staging/omap-thermal/omap4-thermal-data.c b/drivers/staging/omap-thermal/omap4-thermal-data.c
index 732c853..7ec5570 100644
--- a/drivers/staging/omap-thermal/omap4-thermal-data.c
+++ b/drivers/staging/omap-thermal/omap4-thermal-data.c
@@ -18,6 +18,7 @@
 
 #include "omap-thermal.h"
 #include "omap-bandgap.h"
+#include "omap4xxx-bandgap.h"
 
 /*
  * OMAP4430 has one instance of thermal sensor for MPU
diff --git a/drivers/staging/omap-thermal/omap4xxx-bandgap.h b/drivers/staging/omap-thermal/omap4xxx-bandgap.h
new file mode 100644
index 0000000..6f2de3a
--- /dev/null
+++ b/drivers/staging/omap-thermal/omap4xxx-bandgap.h
@@ -0,0 +1,175 @@
+/*
+ * OMAP4xxx bandgap registers, bitfields and temperature definitions
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ * Contact:
+ *   Eduardo Valentin <eduardo.valentin@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+#ifndef __OMAP4XXX_BANDGAP_H
+#define __OMAP4XXX_BANDGAP_H
+
+/**
+ * *** OMAP4430 ***
+ *
+ * Below, in sequence, are the Register definitions,
+ * the bitfields and the temperature definitions for OMAP4430.
+ */
+
+/**
+ * OMAP4430 register definitions
+ *
+ * Registers are defined as offsets. The offsets are
+ * relative to FUSE_OPP_BGAP on 4430.
+ */
+
+/* OMAP4430.FUSE_OPP_BGAP */
+#define OMAP4430_FUSE_OPP_BGAP				0x0
+
+/* OMAP4430.TEMP_SENSOR  */
+#define OMAP4430_TEMP_SENSOR_CTRL_OFFSET		0xCC
+
+/**
+ * Register and bit definitions for OMAP4430
+ *
+ * All the macros bellow define the required bits for
+ * controlling temperature on OMAP4430. Bit defines are
+ * grouped by register.
+ */
+
+/* OMAP4430.TEMP_SENSOR bits */
+#define OMAP4430_BGAP_TEMPSOFF_MASK			BIT(12)
+#define OMAP4430_BGAP_TSHUT_MASK			BIT(11)
+#define OMAP4430_SINGLE_MODE_MASK			BIT(10)
+#define OMAP4430_BGAP_TEMP_SENSOR_SOC_MASK		BIT(9)
+#define OMAP4430_BGAP_TEMP_SENSOR_EOCZ_MASK		BIT(8)
+#define OMAP4430_BGAP_TEMP_SENSOR_DTEMP_MASK		(0xff << 0)
+
+/**
+ * Temperature limits and thresholds for OMAP4430
+ *
+ * All the macros bellow are definitions for handling the
+ * ADC conversions and representation of temperature limits
+ * and thresholds for OMAP4430.
+ */
+
+/* ADC conversion table limits */
+#define OMAP4430_ADC_START_VALUE			0
+#define OMAP4430_ADC_END_VALUE				127
+/* bandgap clock limits (no control on 4430) */
+#define OMAP4430_MAX_FREQ				32768
+#define OMAP4430_MIN_FREQ				32768
+/* sensor limits */
+#define OMAP4430_MIN_TEMP				-40000
+#define OMAP4430_MAX_TEMP				125000
+#define OMAP4430_HYST_VAL				5000
+
+/**
+ * *** OMAP4460 *** Applicable for OMAP4470
+ *
+ * Below, in sequence, are the Register definitions,
+ * the bitfields and the temperature definitions for OMAP4460.
+ */
+
+/**
+ * OMAP4460 register definitions
+ *
+ * Registers are defined as offsets. The offsets are
+ * relative to FUSE_OPP_BGAP on 4460.
+ */
+
+/* OMAP4460.FUSE_OPP_BGAP */
+#define OMAP4460_FUSE_OPP_BGAP				0x0
+
+/* OMAP4460.TEMP_SENSOR */
+#define OMAP4460_TEMP_SENSOR_CTRL_OFFSET		0xCC
+
+/* OMAP4460.BANDGAP_CTRL */
+#define OMAP4460_BGAP_CTRL_OFFSET			0x118
+
+/* OMAP4460.BANDGAP_COUNTER */
+#define OMAP4460_BGAP_COUNTER_OFFSET			0x11C
+
+/* OMAP4460.BANDGAP_THRESHOLD */
+#define OMAP4460_BGAP_THRESHOLD_OFFSET			0x120
+
+/* OMAP4460.TSHUT_THRESHOLD */
+#define OMAP4460_BGAP_TSHUT_OFFSET			0x124
+
+/* OMAP4460.BANDGAP_STATUS */
+#define OMAP4460_BGAP_STATUS_OFFSET			0x128
+
+/**
+ * Register bitfields for OMAP4460
+ *
+ * All the macros bellow define the required bits for
+ * controlling temperature on OMAP4460. Bit defines are
+ * grouped by register.
+ */
+/* OMAP4460.TEMP_SENSOR bits */
+#define OMAP4460_BGAP_TEMPSOFF_MASK			BIT(13)
+#define OMAP4460_BGAP_TEMP_SENSOR_SOC_MASK		BIT(11)
+#define OMAP4460_BGAP_TEMP_SENSOR_EOCZ_MASK		BIT(10)
+#define OMAP4460_BGAP_TEMP_SENSOR_DTEMP_MASK		(0x3ff << 0)
+
+/* OMAP4460.BANDGAP_CTRL bits */
+#define OMAP4460_SINGLE_MODE_MASK			BIT(31)
+#define OMAP4460_MASK_HOT_MASK				BIT(1)
+#define OMAP4460_MASK_COLD_MASK				BIT(0)
+
+/* OMAP4460.BANDGAP_COUNTER bits */
+#define OMAP4460_COUNTER_MASK				(0xffffff << 0)
+
+/* OMAP4460.BANDGAP_THRESHOLD bits */
+#define OMAP4460_T_HOT_MASK				(0x3ff << 16)
+#define OMAP4460_T_COLD_MASK				(0x3ff << 0)
+
+/* OMAP4460.TSHUT_THRESHOLD bits */
+#define OMAP4460_TSHUT_HOT_MASK				(0x3ff << 16)
+#define OMAP4460_TSHUT_COLD_MASK			(0x3ff << 0)
+
+/* OMAP4460.BANDGAP_STATUS bits */
+#define OMAP4460_CLEAN_STOP_MASK			BIT(3)
+#define OMAP4460_BGAP_ALERT_MASK			BIT(2)
+#define OMAP4460_HOT_FLAG_MASK				BIT(1)
+#define OMAP4460_COLD_FLAG_MASK				BIT(0)
+
+/**
+ * Temperature limits and thresholds for OMAP4460
+ *
+ * All the macros bellow are definitions for handling the
+ * ADC conversions and representation of temperature limits
+ * and thresholds for OMAP4460.
+ */
+
+/* ADC conversion table limits */
+#define OMAP4460_ADC_START_VALUE			530
+#define OMAP4460_ADC_END_VALUE				932
+/* bandgap clock limits */
+#define OMAP4460_MAX_FREQ				1500000
+#define OMAP4460_MIN_FREQ				1000000
+/* sensor limits */
+#define OMAP4460_MIN_TEMP				-40000
+#define OMAP4460_MAX_TEMP				123000
+#define OMAP4460_HYST_VAL				5000
+/* interrupts thresholds */
+#define OMAP4460_TSHUT_HOT				900	/* 122 deg C */
+#define OMAP4460_TSHUT_COLD				895	/* 100 deg C */
+#define OMAP4460_T_HOT					800	/* 73 deg C */
+#define OMAP4460_T_COLD					795	/* 71 deg C */
+
+#endif /* __OMAP4XXX_BANDGAP_H */
diff --git a/drivers/staging/omap-thermal/omap5-thermal-data.c b/drivers/staging/omap-thermal/omap5-thermal-data.c
index b20db0c..3d10704 100644
--- a/drivers/staging/omap-thermal/omap5-thermal-data.c
+++ b/drivers/staging/omap-thermal/omap5-thermal-data.c
@@ -17,6 +17,7 @@
  */
 
 #include "omap-bandgap.h"
+#include "omap5xxx-bandgap.h"
 #include "omap-thermal.h"
 
 /*
diff --git a/drivers/staging/omap-thermal/omap5xxx-bandgap.h b/drivers/staging/omap-thermal/omap5xxx-bandgap.h
new file mode 100644
index 0000000..8824db4
--- /dev/null
+++ b/drivers/staging/omap-thermal/omap5xxx-bandgap.h
@@ -0,0 +1,199 @@
+/*
+ * OMAP5xxx bandgap registers, bitfields and temperature definitions
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ * Contact:
+ *   Eduardo Valentin <eduardo.valentin@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+#ifndef __OMAP5XXX_BANDGAP_H
+#define __OMAP5XXX_BANDGAP_H
+
+/**
+ * *** OMAP5430 ***
+ *
+ * Below, in sequence, are the Register definitions,
+ * the bitfields and the temperature definitions for OMAP5430.
+ */
+
+/**
+ * OMAP5430 register definitions
+ *
+ * Registers are defined as offsets. The offsets are
+ * relative to FUSE_OPP_BGAP_GPU on 5430.
+ *
+ * Register below are grouped by domain (not necessarily in offset order)
+ */
+
+/* OMAP5430.GPU register offsets */
+#define OMAP5430_FUSE_OPP_BGAP_GPU			0x0
+#define OMAP5430_TEMP_SENSOR_GPU_OFFSET			0x150
+#define OMAP5430_BGAP_THRESHOLD_GPU_OFFSET		0x1A8
+#define OMAP5430_BGAP_TSHUT_GPU_OFFSET			0x1B4
+#define OMAP5430_BGAP_CUMUL_DTEMP_GPU_OFFSET		0x1C0
+#define OMAP5430_BGAP_DTEMP_GPU_0_OFFSET		0x1F4
+#define OMAP5430_BGAP_DTEMP_GPU_1_OFFSET		0x1F8
+#define OMAP5430_BGAP_DTEMP_GPU_2_OFFSET		0x1FC
+#define OMAP5430_BGAP_DTEMP_GPU_3_OFFSET		0x200
+#define OMAP5430_BGAP_DTEMP_GPU_4_OFFSET		0x204
+
+/* OMAP5430.MPU register offsets */
+#define OMAP5430_FUSE_OPP_BGAP_MPU			0x4
+#define OMAP5430_TEMP_SENSOR_MPU_OFFSET			0x14C
+#define OMAP5430_BGAP_THRESHOLD_MPU_OFFSET		0x1A4
+#define OMAP5430_BGAP_TSHUT_MPU_OFFSET			0x1B0
+#define OMAP5430_BGAP_CUMUL_DTEMP_MPU_OFFSET		0x1BC
+#define OMAP5430_BGAP_DTEMP_MPU_0_OFFSET		0x1E0
+#define OMAP5430_BGAP_DTEMP_MPU_1_OFFSET		0x1E4
+#define OMAP5430_BGAP_DTEMP_MPU_2_OFFSET		0x1E8
+#define OMAP5430_BGAP_DTEMP_MPU_3_OFFSET		0x1EC
+#define OMAP5430_BGAP_DTEMP_MPU_4_OFFSET		0x1F0
+
+/* OMAP5430.MPU register offsets */
+#define OMAP5430_FUSE_OPP_BGAP_CORE			0x8
+#define OMAP5430_TEMP_SENSOR_CORE_OFFSET		0x154
+#define OMAP5430_BGAP_THRESHOLD_CORE_OFFSET		0x1AC
+#define OMAP5430_BGAP_TSHUT_CORE_OFFSET			0x1B8
+#define OMAP5430_BGAP_CUMUL_DTEMP_CORE_OFFSET		0x1C4
+#define OMAP5430_BGAP_DTEMP_CORE_0_OFFSET		0x208
+#define OMAP5430_BGAP_DTEMP_CORE_1_OFFSET		0x20C
+#define OMAP5430_BGAP_DTEMP_CORE_2_OFFSET		0x210
+#define OMAP5430_BGAP_DTEMP_CORE_3_OFFSET		0x214
+#define OMAP5430_BGAP_DTEMP_CORE_4_OFFSET		0x218
+
+/* OMAP5430.common register offsets */
+#define OMAP5430_BGAP_CTRL_OFFSET			0x1A0
+#define OMAP5430_BGAP_STATUS_OFFSET			0x1C8
+
+/**
+ * Register bitfields for OMAP5430
+ *
+ * All the macros bellow define the required bits for
+ * controlling temperature on OMAP5430. Bit defines are
+ * grouped by register.
+ */
+
+/* OMAP5430.TEMP_SENSOR */
+#define OMAP5430_BGAP_TEMP_SENSOR_SOC_MASK		BIT(12)
+#define OMAP5430_BGAP_TEMPSOFF_MASK			BIT(11)
+#define OMAP5430_BGAP_TEMP_SENSOR_EOCZ_MASK		BIT(10)
+#define OMAP5430_BGAP_TEMP_SENSOR_DTEMP_MASK		(0x3ff << 0)
+
+/* OMAP5430.BANDGAP_CTRL */
+#define OMAP5430_MASK_SIDLEMODE_MASK			(0x3 << 30)
+#define OMAP5430_MASK_FREEZE_CORE_MASK			BIT(23)
+#define OMAP5430_MASK_FREEZE_GPU_MASK			BIT(22)
+#define OMAP5430_MASK_FREEZE_MPU_MASK			BIT(21)
+#define OMAP5430_MASK_CLEAR_CORE_MASK			BIT(20)
+#define OMAP5430_MASK_CLEAR_GPU_MASK			BIT(19)
+#define OMAP5430_MASK_CLEAR_MPU_MASK			BIT(18)
+#define OMAP5430_MASK_CLEAR_ACCUM_CORE_MASK		BIT(17)
+#define OMAP5430_MASK_CLEAR_ACCUM_GPU_MASK		BIT(16)
+#define OMAP5430_MASK_CLEAR_ACCUM_MPU_MASK		BIT(15)
+#define OMAP5430_MASK_HOT_CORE_MASK			BIT(5)
+#define OMAP5430_MASK_COLD_CORE_MASK			BIT(4)
+#define OMAP5430_MASK_HOT_GPU_MASK			BIT(3)
+#define OMAP5430_MASK_COLD_GPU_MASK			BIT(2)
+#define OMAP5430_MASK_HOT_MPU_MASK			BIT(1)
+#define OMAP5430_MASK_COLD_MPU_MASK			BIT(0)
+
+/* OMAP5430.BANDGAP_COUNTER */
+#define OMAP5430_COUNTER_MASK				(0xffffff << 0)
+
+/* OMAP5430.BANDGAP_THRESHOLD */
+#define OMAP5430_T_HOT_MASK				(0x3ff << 16)
+#define OMAP5430_T_COLD_MASK				(0x3ff << 0)
+
+/* OMAP5430.TSHUT_THRESHOLD */
+#define OMAP5430_TSHUT_HOT_MASK				(0x3ff << 16)
+#define OMAP5430_TSHUT_COLD_MASK			(0x3ff << 0)
+
+/* OMAP5430.BANDGAP_CUMUL_DTEMP_MPU */
+#define OMAP5430_CUMUL_DTEMP_MPU_MASK			(0xffffffff << 0)
+
+/* OMAP5430.BANDGAP_CUMUL_DTEMP_GPU */
+#define OMAP5430_CUMUL_DTEMP_GPU_MASK			(0xffffffff << 0)
+
+/* OMAP5430.BANDGAP_CUMUL_DTEMP_CORE */
+#define OMAP5430_CUMUL_DTEMP_CORE_MASK			(0xffffffff << 0)
+
+/* OMAP5430.BANDGAP_STATUS */
+#define OMAP5430_BGAP_ALERT_MASK			BIT(31)
+#define OMAP5430_HOT_CORE_FLAG_MASK			BIT(5)
+#define OMAP5430_COLD_CORE_FLAG_MASK			BIT(4)
+#define OMAP5430_HOT_GPU_FLAG_MASK			BIT(3)
+#define OMAP5430_COLD_GPU_FLAG_MASK			BIT(2)
+#define OMAP5430_HOT_MPU_FLAG_MASK			BIT(1)
+#define OMAP5430_COLD_MPU_FLAG_MASK			BIT(0)
+
+/**
+ * Temperature limits and thresholds for OMAP5430
+ *
+ * All the macros bellow are definitions for handling the
+ * ADC conversions and representation of temperature limits
+ * and thresholds for OMAP5430. Definitions are grouped
+ * by temperature domain.
+ */
+
+/* OMAP5430.common temperature definitions */
+/* ADC conversion table limits */
+#define OMAP5430_ADC_START_VALUE			540
+#define OMAP5430_ADC_END_VALUE				945
+
+/* OMAP5430.GPU temperature definitions */
+/* bandgap clock limits */
+#define OMAP5430_GPU_MAX_FREQ				1500000
+#define OMAP5430_GPU_MIN_FREQ				1000000
+/* sensor limits */
+#define OMAP5430_GPU_MIN_TEMP				-40000
+#define OMAP5430_GPU_MAX_TEMP				125000
+#define OMAP5430_GPU_HYST_VAL				5000
+/* interrupts thresholds */
+#define OMAP5430_GPU_TSHUT_HOT				915
+#define OMAP5430_GPU_TSHUT_COLD				900
+#define OMAP5430_GPU_T_HOT				800
+#define OMAP5430_GPU_T_COLD				795
+
+/* OMAP5430.MPU temperature definitions */
+/* bandgap clock limits */
+#define OMAP5430_MPU_MAX_FREQ				1500000
+#define OMAP5430_MPU_MIN_FREQ				1000000
+/* sensor limits */
+#define OMAP5430_MPU_MIN_TEMP				-40000
+#define OMAP5430_MPU_MAX_TEMP				125000
+#define OMAP5430_MPU_HYST_VAL				5000
+/* interrupts thresholds */
+#define OMAP5430_MPU_TSHUT_HOT				915
+#define OMAP5430_MPU_TSHUT_COLD				900
+#define OMAP5430_MPU_T_HOT				800
+#define OMAP5430_MPU_T_COLD				795
+
+/* OMAP5430.CORE temperature definitions */
+/* bandgap clock limits */
+#define OMAP5430_CORE_MAX_FREQ				1500000
+#define OMAP5430_CORE_MIN_FREQ				1000000
+/* sensor limits */
+#define OMAP5430_CORE_MIN_TEMP				-40000
+#define OMAP5430_CORE_MAX_TEMP				125000
+#define OMAP5430_CORE_HYST_VAL				5000
+/* interrupts thresholds */
+#define OMAP5430_CORE_TSHUT_HOT				915
+#define OMAP5430_CORE_TSHUT_COLD			900
+#define OMAP5430_CORE_T_HOT				800
+#define OMAP5430_CORE_T_COLD				795
+
+#endif /* __OMAP5XXX_BANDGAP_H */
-- 
1.7.7.1.488.ge8e1c

