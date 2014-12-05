Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaLETFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:05:37 -0500
Received: from service87.mimecast.com ([91.220.42.44]:38224 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaLETFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:05:34 -0500
From: "Javi Merino" <javi.merino@arm.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: punit.agrawal@arm.com, broonie@kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [RFC PATCH v6 9/9] of: thermal: Introduce sustainable power for a thermal zone
Date: Fri,  5 Dec 2014 19:04:20 +0000
Message-Id: <1417806260-9264-10-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
X-OriginalArrivalTime: 05 Dec 2014 19:05:31.0220 (UTC) FILETIME=[70922140:01D010BE]
X-MC-Unique: 114120519053300201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id sB5J5jw6013849

From: Punit Agrawal <punit.agrawal@arm.com>

Introduce an optional property called, sustainable-power, which
represents the power (in mW) which the thermal zone can safely
dissipate.

If provided the property is parsed and associated with the thermal
zone via the thermal zone parameters.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
---
 Documentation/devicetree/bindings/thermal/thermal.txt | 4 ++++
 drivers/thermal/of-thermal.c                          | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Documentation/devicetree/bindings/thermal/thermal.txt
index f5db6b72a36f..c6eb9a8d2aed 100644
--- a/Documentation/devicetree/bindings/thermal/thermal.txt
+++ b/Documentation/devicetree/bindings/thermal/thermal.txt
@@ -167,6 +167,10 @@ Optional property:
 			by means of sensor ID. Additional coefficients are
 			interpreted as constant offset.
 
+- sustainable-power:	An estimate of the sustainable power (in mW) that the
+  Type: unsigned	thermal zone can dissipate.
+  Size: one cell
+
 Note: The delay properties are bound to the maximum dT/dt (temperature
 derivative over time) in two situations for a thermal zone:
 (i)  - when passive cooling is activated (polling-delay-passive); and
diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
index 62143ba31001..e032b9bf4085 100644
--- a/drivers/thermal/of-thermal.c
+++ b/drivers/thermal/of-thermal.c
@@ -794,6 +794,7 @@ int __init of_parse_thermal_zones(void)
 	for_each_child_of_node(np, child) {
 		struct thermal_zone_device *zone;
 		struct thermal_zone_params *tzp;
+		u32 prop;
 
 		/* Check whether child is enabled or not */
 		if (!of_device_is_available(child))
@@ -820,6 +821,9 @@ int __init of_parse_thermal_zones(void)
 		/* No hwmon because there might be hwmon drivers registering */
 		tzp->no_hwmon = true;
 
+		if (!of_property_read_u32(child, "sustainable-power", &prop))
+			tzp->sustainable_power = prop;
+
 		zone = thermal_zone_device_register(child->name, tz->ntrips,
 						    0, tz,
 						    ops, tzp,
-- 
1.9.1


