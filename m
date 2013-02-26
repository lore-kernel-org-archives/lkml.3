Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712Ab3BZWzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:55:54 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33165 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635Ab3BZWzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:55:52 -0500
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 05/15] staging: omap-thermal: remove from register map soc and mode on OMAP5
Date: Tue, 26 Feb 2013 18:53:28 -0400
Message-ID: <1361919218-9788-6-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
References: <1361919218-9788-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On OMAP54xx ES2.0 there is no single read and only one mode: continuous
mode. For this reason, there is no point in defining register fields
for these operations.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap5-thermal.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap5-thermal.c b/drivers/staging/omap-thermal/omap5-thermal.c
index 4965556..32d3f878 100644
--- a/drivers/staging/omap-thermal/omap5-thermal.c
+++ b/drivers/staging/omap-thermal/omap5-thermal.c
@@ -27,7 +27,6 @@ static struct temp_sensor_registers
 omap5430_mpu_temp_sensor_registers = {
 	.temp_sensor_ctrl = OMAP5430_TEMP_SENSOR_MPU_OFFSET,
 	.bgap_tempsoff_mask = OMAP5430_BGAP_TEMPSOFF_MASK,
-	.bgap_soc_mask = OMAP5430_BGAP_TEMP_SENSOR_SOC_MASK,
 	.bgap_eocz_mask = OMAP5430_BGAP_TEMP_SENSOR_EOCZ_MASK,
 	.bgap_dtemp_mask = OMAP5430_BGAP_TEMP_SENSOR_DTEMP_MASK,
 
@@ -35,8 +34,6 @@ omap5430_mpu_temp_sensor_registers = {
 	.mask_hot_mask = OMAP5430_MASK_HOT_MPU_MASK,
 	.mask_cold_mask = OMAP5430_MASK_COLD_MPU_MASK,
 
-	.bgap_mode_ctrl = OMAP5430_BGAP_COUNTER_MPU_OFFSET,
-	.mode_ctrl_mask = OMAP5430_REPEAT_MODE_MASK,
 
 	.bgap_counter = OMAP5430_BGAP_COUNTER_MPU_OFFSET,
 	.counter_mask = OMAP5430_COUNTER_MASK,
@@ -66,7 +63,6 @@ static struct temp_sensor_registers
 omap5430_gpu_temp_sensor_registers = {
 	.temp_sensor_ctrl = OMAP5430_TEMP_SENSOR_GPU_OFFSET,
 	.bgap_tempsoff_mask = OMAP5430_BGAP_TEMPSOFF_MASK,
-	.bgap_soc_mask = OMAP5430_BGAP_TEMP_SENSOR_SOC_MASK,
 	.bgap_eocz_mask = OMAP5430_BGAP_TEMP_SENSOR_EOCZ_MASK,
 	.bgap_dtemp_mask = OMAP5430_BGAP_TEMP_SENSOR_DTEMP_MASK,
 
@@ -74,9 +70,6 @@ omap5430_gpu_temp_sensor_registers = {
 	.mask_hot_mask = OMAP5430_MASK_HOT_GPU_MASK,
 	.mask_cold_mask = OMAP5430_MASK_COLD_GPU_MASK,
 
-	.bgap_mode_ctrl = OMAP5430_BGAP_COUNTER_GPU_OFFSET,
-	.mode_ctrl_mask = OMAP5430_REPEAT_MODE_MASK,
-
 	.bgap_counter = OMAP5430_BGAP_COUNTER_GPU_OFFSET,
 	.counter_mask = OMAP5430_COUNTER_MASK,
 
@@ -105,7 +98,6 @@ static struct temp_sensor_registers
 omap5430_core_temp_sensor_registers = {
 	.temp_sensor_ctrl = OMAP5430_TEMP_SENSOR_CORE_OFFSET,
 	.bgap_tempsoff_mask = OMAP5430_BGAP_TEMPSOFF_MASK,
-	.bgap_soc_mask = OMAP5430_BGAP_TEMP_SENSOR_SOC_MASK,
 	.bgap_eocz_mask = OMAP5430_BGAP_TEMP_SENSOR_EOCZ_MASK,
 	.bgap_dtemp_mask = OMAP5430_BGAP_TEMP_SENSOR_DTEMP_MASK,
 
@@ -113,9 +105,6 @@ omap5430_core_temp_sensor_registers = {
 	.mask_hot_mask = OMAP5430_MASK_HOT_CORE_MASK,
 	.mask_cold_mask = OMAP5430_MASK_COLD_CORE_MASK,
 
-	.bgap_mode_ctrl = OMAP5430_BGAP_COUNTER_CORE_OFFSET,
-	.mode_ctrl_mask = OMAP5430_REPEAT_MODE_MASK,
-
 	.bgap_counter = OMAP5430_BGAP_COUNTER_CORE_OFFSET,
 	.counter_mask = OMAP5430_COUNTER_MASK,
 
-- 
1.7.7.1.488.ge8e1c

