Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966907Ab3E2PIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:08:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53967 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966882Ab3E2PIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:08:37 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 6/7] thermal: ti-soc-thermal: add dra752 chip to device table
Date: Wed, 29 May 2013 11:07:45 -0400
Message-ID: <1369840066-20357-7-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1369840066-20357-1-git-send-email-eduardo.valentin@ti.com>
References: <1369840066-20357-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to TI dra752 chips by adapting the driver
device table.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/ti-soc-thermal/ti-bandgap.c | 6 ++++++
 drivers/thermal/ti-soc-thermal/ti-bandgap.h | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index f72695f..dea097d 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -1532,6 +1532,12 @@ static const struct of_device_id of_ti_bandgap_match[] = {
 		.data = (void *)&omap5430_data,
 	},
 #endif
+#ifdef CONFIG_DRA752_THERMAL
+	{
+		.compatible = "ti,dra752-bandgap",
+		.data = (void *)&dra752_data,
+	},
+#endif
 	/* Sentinel */
 	{ },
 };
diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.h b/drivers/thermal/ti-soc-thermal/ti-bandgap.h
index 5f4794a..b3adf72 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.h
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.h
@@ -400,4 +400,9 @@ extern const struct ti_bandgap_data omap5430_data;
 #define omap5430_data					NULL
 #endif
 
+#ifdef CONFIG_DRA752_THERMAL
+extern const struct ti_bandgap_data dra752_data;
+#else
+#define dra752_data					NULL
+#endif
 #endif
-- 
1.8.2.1.342.gfa7285d

