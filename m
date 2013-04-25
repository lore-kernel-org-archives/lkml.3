Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab3DYOO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:14:26 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40819 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932256Ab3DYOOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:14:25 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: Zhang Rui <rui.zhang@intel.com>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH 1/2] thermal: thermal_core: remove usage of IS_ERR_OR_NULL
Date: Thu, 25 Apr 2013 10:13:33 -0400
Message-ID: <1366899214-22639-2-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1366899214-22639-1-git-send-email-eduardo.valentin@ti.com>
References: <1366899214-22639-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the driver to avoid the usage of IS_ERR_OR_NULL()
macro. This macro can lead to dangerous results, like returning
success (0) during a failure scenario (NULL pointer handling).

The case present in this patch has simply be translated to
normal check for NULL and if the pointer has an error code.
The later case is needed because functions like
thermal_zone_get_zone_by_name() could return an ERR_PTR().

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/thermal/thermal_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index f36cd44..d755440 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -388,7 +388,7 @@ int thermal_zone_get_temp(struct thermal_zone_device *tz, unsigned long *temp)
 	enum thermal_trip_type type;
 #endif
 
-	if (IS_ERR_OR_NULL(tz))
+	if (!tz || IS_ERR(tz))
 		goto exit;
 
 	mutex_lock(&tz->lock);
-- 
1.8.2.1.342.gfa7285d

