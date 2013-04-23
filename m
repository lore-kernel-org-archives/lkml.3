Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab3DWVtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:49:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39654 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290Ab3DWVtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:49:22 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCHv2 1/9] thermal: use strlcpy instead of strcpy
Date: Tue, 23 Apr 2013 17:48:12 -0400
Message-ID: <1366753700-1412-2-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366753700-1412-1-git-send-email-eduardo.valentin@ti.com>
References: <1366753700-1412-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For memory boundaries safety, use strlcpy instead of strcpy.

Acked-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/thermal_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 4cdc3e3..bea3884 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -1287,7 +1287,7 @@ thermal_cooling_device_register(char *type, void *devdata,
 		return ERR_PTR(result);
 	}
 
-	strcpy(cdev->type, type ? : "");
+	strlcpy(cdev->type, type ? : "", sizeof(cdev->type));
 	mutex_init(&cdev->lock);
 	INIT_LIST_HEAD(&cdev->thermal_instances);
 	cdev->ops = ops;
@@ -1592,7 +1592,7 @@ struct thermal_zone_device *thermal_zone_device_register(const char *type,
 		return ERR_PTR(result);
 	}
 
-	strcpy(tz->type, type ? : "");
+	strlcpy(tz->type, type ? : "", sizeof(tz->type));
 	tz->ops = ops;
 	tz->tzp = tzp;
 	tz->device.class = &thermal_class;
-- 
1.8.2.1.342.gfa7285d

