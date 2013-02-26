Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab3BZWze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:55:34 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50937 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759320Ab3BZWza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:55:30 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 04/15] staging: omap-thermal: standardize register nomenclature to use 'GPU'
Date: Tue, 26 Feb 2013 18:53:27 -0400
Message-ID: <1361919218-9788-5-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
References: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to keep same nomenclature across the register definition,
this change will make all 'MM' suffixes to be named 'GPU'.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.h  |   16 ++++++++--------
 drivers/staging/omap-thermal/omap5-thermal.c |    8 ++++----
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.h b/drivers/staging/omap-thermal/omap-bandgap.h
index a13e43a..ef342d8 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.h
+++ b/drivers/staging/omap-thermal/omap-bandgap.h
@@ -110,10 +110,10 @@
 #define OMAP5430_MASK_HOT_CORE_MASK			(1 << 5)
 #define OMAP5430_MASK_COLD_CORE_SHIFT			4
 #define OMAP5430_MASK_COLD_CORE_MASK			(1 << 4)
-#define OMAP5430_MASK_HOT_MM_SHIFT			3
-#define OMAP5430_MASK_HOT_MM_MASK			(1 << 3)
-#define OMAP5430_MASK_COLD_MM_SHIFT			2
-#define OMAP5430_MASK_COLD_MM_MASK			(1 << 2)
+#define OMAP5430_MASK_HOT_GPU_SHIFT			3
+#define OMAP5430_MASK_HOT_GPU_MASK			(1 << 3)
+#define OMAP5430_MASK_COLD_GPU_SHIFT			2
+#define OMAP5430_MASK_COLD_GPU_MASK			(1 << 2)
 #define OMAP5430_MASK_HOT_MPU_SHIFT			1
 #define OMAP5430_MASK_HOT_MPU_MASK			(1 << 1)
 #define OMAP5430_MASK_COLD_MPU_SHIFT			0
@@ -144,10 +144,10 @@
 #define OMAP5430_HOT_CORE_FLAG_MASK			(1 << 5)
 #define OMAP5430_COLD_CORE_FLAG_SHIFT			4
 #define OMAP5430_COLD_CORE_FLAG_MASK			(1 << 4)
-#define OMAP5430_HOT_MM_FLAG_SHIFT			3
-#define OMAP5430_HOT_MM_FLAG_MASK			(1 << 3)
-#define OMAP5430_COLD_MM_FLAG_SHIFT			2
-#define OMAP5430_COLD_MM_FLAG_MASK			(1 << 2)
+#define OMAP5430_HOT_GPU_FLAG_SHIFT			3
+#define OMAP5430_HOT_GPU_FLAG_MASK			(1 << 3)
+#define OMAP5430_COLD_GPU_FLAG_SHIFT			2
+#define OMAP5430_COLD_GPU_FLAG_MASK			(1 << 2)
 #define OMAP5430_HOT_MPU_FLAG_SHIFT			1
 #define OMAP5430_HOT_MPU_FLAG_MASK			(1 << 1)
 #define OMAP5430_COLD_MPU_FLAG_SHIFT			0
diff --git a/drivers/staging/omap-thermal/omap5-thermal.c b/drivers/staging/omap-thermal/omap5-thermal.c
index dfa0350..4965556 100644
--- a/drivers/staging/omap-thermal/omap5-thermal.c
+++ b/drivers/staging/omap-thermal/omap5-thermal.c
@@ -71,8 +71,8 @@ omap5430_gpu_temp_sensor_registers = {
 	.bgap_dtemp_mask = OMAP5430_BGAP_TEMP_SENSOR_DTEMP_MASK,
 
 	.bgap_mask_ctrl = OMAP5430_BGAP_CTRL_OFFSET,
-	.mask_hot_mask = OMAP5430_MASK_HOT_MM_MASK,
-	.mask_cold_mask = OMAP5430_MASK_COLD_MM_MASK,
+	.mask_hot_mask = OMAP5430_MASK_HOT_GPU_MASK,
+	.mask_cold_mask = OMAP5430_MASK_COLD_GPU_MASK,
 
 	.bgap_mode_ctrl = OMAP5430_BGAP_COUNTER_GPU_OFFSET,
 	.mode_ctrl_mask = OMAP5430_REPEAT_MODE_MASK,
@@ -91,8 +91,8 @@ omap5430_gpu_temp_sensor_registers = {
 	.bgap_status = OMAP5430_BGAP_STATUS_OFFSET,
 	.status_clean_stop_mask = 0x0,
 	.status_bgap_alert_mask = OMAP5430_BGAP_ALERT_MASK,
-	.status_hot_mask = OMAP5430_HOT_MM_FLAG_MASK,
-	.status_cold_mask = OMAP5430_COLD_MM_FLAG_MASK,
+	.status_hot_mask = OMAP5430_HOT_GPU_FLAG_MASK,
+	.status_cold_mask = OMAP5430_COLD_GPU_FLAG_MASK,
 
 	.bgap_efuse = OMAP5430_FUSE_OPP_BGAP_GPU,
 };
-- 
1.7.7.1.488.ge8e1c

