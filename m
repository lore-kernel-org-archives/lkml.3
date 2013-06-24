Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3FXKxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:53:18 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:64899 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab3FXKxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:53:07 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH V7 28/30] Documentation: thermal: Explain the exynos thermal driver model
Date: Mon, 24 Jun 2013 16:20:49 +0530
Message-Id: <1372071051-3167-29-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com>
References: <1372071051-3167-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the documentation to explain the driver model
and file layout.

Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Acked-by: Eduardo Valentin <eduardo.valentin@ti.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 Documentation/thermal/exynos_thermal |   43 ++++++++++++++++++++++++++-------
 1 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/Documentation/thermal/exynos_thermal b/Documentation/thermal/exynos_thermal
index 2b46f67..9010c44 100644
--- a/Documentation/thermal/exynos_thermal
+++ b/Documentation/thermal/exynos_thermal
@@ -1,17 +1,17 @@
-Kernel driver exynos4_tmu
+Kernel driver exynos_tmu
 =================
 
 Supported chips:
-* ARM SAMSUNG EXYNOS4 series of SoC
-  Prefix: 'exynos4-tmu'
+* ARM SAMSUNG EXYNOS4, EXYNOS5 series of SoC
   Datasheet: Not publicly available
 
 Authors: Donggeun Kim <dg77.kim@samsung.com>
+Authors: Amit Daniel <amit.daniel@samsung.com>
 
-Description
------------
+TMU controller Description:
+---------------------------
 
-This driver allows to read temperature inside SAMSUNG EXYNOS4 series of SoC.
+This driver allows to read temperature inside SAMSUNG EXYNOS4/5 series of SoC.
 
 The chip only exposes the measured 8-bit temperature code value
 through a register.
@@ -34,9 +34,9 @@ The three equations are:
   TI2: Trimming info for 85 degree Celsius (stored at TRIMINFO register)
        Temperature code measured at 85 degree Celsius which is unchanged
 
-TMU(Thermal Management Unit) in EXYNOS4 generates interrupt
+TMU(Thermal Management Unit) in EXYNOS4/5 generates interrupt
 when temperature exceeds pre-defined levels.
-The maximum number of configurable threshold is four.
+The maximum number of configurable threshold is five.
 The threshold levels are defined as follows:
   Level_0: current temperature > trigger_level_0 + threshold
   Level_1: current temperature > trigger_level_1 + threshold
@@ -47,6 +47,31 @@ The threshold levels are defined as follows:
   through the corresponding registers.
 
 When an interrupt occurs, this driver notify kernel thermal framework
-with the function exynos4_report_trigger.
+with the function exynos_report_trigger.
 Although an interrupt condition for level_0 can be set,
 it can be used to synchronize the cooling action.
+
+TMU driver description:
+-----------------------
+
+The exynos thermal driver is structured as,
+
+					Kernel Core thermal framework
+				(thermal_core.c, step_wise.c, cpu_cooling.c)
+								^
+								|
+								|
+TMU configuration data -------> TMU Driver  <------> Exynos Core thermal wrapper
+(exynos_tmu_data.c)	      (exynos_tmu.c)	   (exynos_thermal_common.c)
+(exynos_tmu_data.h)	      (exynos_tmu.h)	   (exynos_thermal_common.h)
+
+a) TMU configuration data: This consist of TMU register offsets/bitfields
+		described through structure exynos_tmu_registers. Also several
+		other platform data (struct exynos_tmu_platform_data) members
+		are used to configure the TMU.
+b) TMU driver: This component initialises the TMU controller and sets different
+		thresholds. It invokes core thermal implementation with the call
+		exynos_report_trigger.
+c) Exynos Core thermal wrapper: This provides 3 wrapper function to use the
+		Kernel core thermal framework. They are exynos_unregister_thermal,
+		exynos_register_thermal and exynos_report_trigger.
-- 
1.7.1

