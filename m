Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759740Ab3BZW5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:57:21 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51009 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758428Ab3BZW5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:57:16 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 09/15] staging: omap-thermal: remove dedicated counter register for OMAP5
Date: Tue, 26 Feb 2013 18:53:32 -0400
Message-ID: <1361919218-9788-10-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
References: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On OMAP54xx there is only one counter register. For this reason,
each domain must use the same counter register. This patch changes
the data definition to coupe with this.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.h  |    5 -----
 drivers/staging/omap-thermal/omap5-thermal.c |    6 +++---
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.h b/drivers/staging/omap-thermal/omap-bandgap.h
index 5994ebb..ef5503d 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.h
+++ b/drivers/staging/omap-thermal/omap-bandgap.h
@@ -140,8 +140,6 @@
 #define OMAP5430_MASK_CLEAR_ACCUM_MPU_MASK		(1 << 15)
 
 /* BANDGAP_COUNTER */
-#define OMAP5430_REPEAT_MODE_SHIFT			31
-#define OMAP5430_REPEAT_MODE_MASK			(1 << 31)
 #define OMAP5430_COUNTER_SHIFT				0
 #define OMAP5430_COUNTER_MASK				(0xffffff << 0)
 
@@ -203,7 +201,6 @@
 /* 5430 - All goes relative to OPP_BGAP_GPU */
 #define OMAP5430_FUSE_OPP_BGAP_GPU			0x0
 #define OMAP5430_TEMP_SENSOR_GPU_OFFSET			0x150
-#define OMAP5430_BGAP_COUNTER_GPU_OFFSET		0x1C0
 #define OMAP5430_BGAP_THRESHOLD_GPU_OFFSET		0x1A8
 #define OMAP5430_BGAP_TSHUT_GPU_OFFSET			0x1B4
 #define OMAP5430_BGAP_CUMUL_DTEMP_GPU_OFFSET		0x1C0
@@ -216,7 +213,6 @@
 #define OMAP5430_FUSE_OPP_BGAP_MPU			0x4
 #define OMAP5430_TEMP_SENSOR_MPU_OFFSET			0x14C
 #define OMAP5430_BGAP_CTRL_OFFSET			0x1A0
-#define OMAP5430_BGAP_COUNTER_MPU_OFFSET		0x1BC
 #define OMAP5430_BGAP_THRESHOLD_MPU_OFFSET		0x1A4
 #define OMAP5430_BGAP_TSHUT_MPU_OFFSET			0x1B0
 #define OMAP5430_BGAP_CUMUL_DTEMP_MPU_OFFSET		0x1BC
@@ -228,7 +224,6 @@
 
 #define OMAP5430_FUSE_OPP_BGAP_CORE			0x8
 #define OMAP5430_TEMP_SENSOR_CORE_OFFSET		0x154
-#define OMAP5430_BGAP_COUNTER_CORE_OFFSET		0x1C4
 #define OMAP5430_BGAP_THRESHOLD_CORE_OFFSET		0x1AC
 #define OMAP5430_BGAP_TSHUT_CORE_OFFSET			0x1B8
 #define OMAP5430_BGAP_CUMUL_DTEMP_CORE_OFFSET		0x1C4
diff --git a/drivers/staging/omap-thermal/omap5-thermal.c b/drivers/staging/omap-thermal/omap5-thermal.c
index 6306360..c2bfc65 100644
--- a/drivers/staging/omap-thermal/omap5-thermal.c
+++ b/drivers/staging/omap-thermal/omap5-thermal.c
@@ -43,7 +43,7 @@ omap5430_mpu_temp_sensor_registers = {
 	.mask_clear_accum_mask = OMAP5430_MASK_CLEAR_ACCUM_MPU_MASK,
 
 
-	.bgap_counter = OMAP5430_BGAP_COUNTER_MPU_OFFSET,
+	.bgap_counter = OMAP5430_BGAP_CTRL_OFFSET,
 	.counter_mask = OMAP5430_COUNTER_MASK,
 
 	.bgap_threshold = OMAP5430_BGAP_THRESHOLD_MPU_OFFSET,
@@ -87,7 +87,7 @@ omap5430_gpu_temp_sensor_registers = {
 	.mask_clear_mask = OMAP5430_MASK_CLEAR_GPU_MASK,
 	.mask_clear_accum_mask = OMAP5430_MASK_CLEAR_ACCUM_GPU_MASK,
 
-	.bgap_counter = OMAP5430_BGAP_COUNTER_GPU_OFFSET,
+	.bgap_counter = OMAP5430_BGAP_CTRL_OFFSET,
 	.counter_mask = OMAP5430_COUNTER_MASK,
 
 	.bgap_threshold = OMAP5430_BGAP_THRESHOLD_GPU_OFFSET,
@@ -132,7 +132,7 @@ omap5430_core_temp_sensor_registers = {
 	.mask_clear_mask = OMAP5430_MASK_CLEAR_CORE_MASK,
 	.mask_clear_accum_mask = OMAP5430_MASK_CLEAR_ACCUM_CORE_MASK,
 
-	.bgap_counter = OMAP5430_BGAP_COUNTER_CORE_OFFSET,
+	.bgap_counter = OMAP5430_BGAP_CTRL_OFFSET,
 	.counter_mask = OMAP5430_COUNTER_MASK,
 
 	.bgap_threshold = OMAP5430_BGAP_THRESHOLD_CORE_OFFSET,
-- 
1.7.7.1.488.ge8e1c

