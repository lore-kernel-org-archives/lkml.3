Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbbACV5E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 16:57:04 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:49322 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbbACV5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 16:57:01 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Lukasz Majewski <l.majewski@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] thermal: of: Remove bogus type qualifier for of_thermal_get_trip_points()
Date: Sat,  3 Jan 2015 22:56:56 +0100
Message-Id: <1420322216-13863-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With gcc 4.1.2, 4.2, and 4.2.4 (4.4 and later are OK):

drivers/thermal/thermal_core.h:110: warning: type qualifiers ignored on function return type

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Fixes: ce8be7785922de0e ("thermal: of: Extend of-thermal to export table of trip points")
---
 drivers/thermal/of-thermal.c   | 2 +-
 drivers/thermal/thermal_core.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index e145b66df444e65b..d717f3dab6f1410f 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -149,7 +149,7 @@ EXPORT_SYMBOL_GPL(of_thermal_is_trip_valid);
  *
  * Return: pointer to trip points table, NULL otherwise
  */
-const struct thermal_trip * const
+const struct thermal_trip *
 of_thermal_get_trip_points(struct thermal_zone_device *tz)
 {
 	struct __thermal_zone *data = tz->devdata;
diff --git a/drivers/thermal/thermal_core.h b/drivers/thermal/thermal_core.h
index 9083e75206236c19..0531c752fbbb6680 100644
--- a/drivers/thermal/thermal_core.h
+++ b/drivers/thermal/thermal_core.h
@@ -91,7 +91,7 @@ int of_parse_thermal_zones(void);
 void of_thermal_destroy_zones(void);
 int of_thermal_get_ntrips(struct thermal_zone_device *);
 bool of_thermal_is_trip_valid(struct thermal_zone_device *, int);
-const struct thermal_trip * const
+const struct thermal_trip *
 of_thermal_get_trip_points(struct thermal_zone_device *);
 #else
 static inline int of_parse_thermal_zones(void) { return 0; }
@@ -105,7 +105,7 @@ static inline bool of_thermal_is_trip_valid(struct thermal_zone_device *tz,
 {
 	return 0;
 }
-static inline const struct thermal_trip * const
+static inline const struct thermal_trip *
 of_thermal_get_trip_points(struct thermal_zone_device *tz)
 {
 	return NULL;
-- 
1.9.1

