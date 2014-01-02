Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbaABHrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 02:47:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:11587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbaABHri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 02:47:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,589,1384329600"; 
   d="scan'208";a="460587372"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Thermal: update thermal zone device after setting emul_temp
Date: Thu,  2 Jan 2014 15:47:54 +0800
Message-Id: <1388648874-14198-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to update thermal zone device after setting emul_temp
in order to make governor work according to input temperature immediately.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/thermal/thermal_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 547217c..9d951aa 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -777,6 +777,9 @@ emul_temp_store(struct device *dev, struct device_attribute *attr,
 		ret = tz->ops->set_emul_temp(tz, temperature);
 	}
 
+	if (!ret)
+		thermal_zone_device_update(tz);
+
 	return ret ? ret : count;
 }
 static DEVICE_ATTR(emul_temp, S_IWUSR, NULL, emul_temp_store);
-- 
1.8.2.1

