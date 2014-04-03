Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594AbaDCGLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 02:11:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:59234 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162299AbaDCGLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 02:11:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,784,1389772800"; 
   d="scan'208";a="505931960"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com,
        srinivas.pandruvada@linux.intel.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Thermal/int3403: Fix thermal hysteresis unit conversion
Date: Thu,  3 Apr 2014 14:04:15 +0800
Message-Id: <1396505055-581-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thermal hysteresis represents a temperature difference.
But the original code treats it as a temperature value,
Convert it from tenths of degree Kelvin to Milli-Celsius
by deducing 273200. This is not right.

Kelvin and Celsius have same degree size. From temperature
difference view, the conversion between tenths of degree
Kelvin unit and Milli-Celsius unit is just to multiply 100.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
---
 drivers/thermal/int3403_thermal.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/int3403_thermal.c b/drivers/thermal/int3403_thermal.c
index 1301681..e93f025 100644
--- a/drivers/thermal/int3403_thermal.c
+++ b/drivers/thermal/int3403_thermal.c
@@ -62,7 +62,13 @@ static int sys_get_trip_hyst(struct thermal_zone_device *tzone,
 	if (ACPI_FAILURE(status))
 		return -EIO;
 
-	*temp = DECI_KELVIN_TO_MILLI_CELSIUS(hyst, KELVIN_OFFSET);
+	/*
+	 * Thermal hysteresis represents a temperature difference.
+	 * Kelvin and Celsius have same degree size. So the
+	 * conversion here between tenths of degree Kelvin unit
+	 * and Milli-Celsius unit is just to multiply 100.
+	 */
+	*temp = hyst * 100;
 
 	return 0;
 }
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

