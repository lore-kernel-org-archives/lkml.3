Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbbA2CMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:12:37 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59464 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933545AbbA2CMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:12:35 -0500
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: linux-pm@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v2] thermal: Fix examples in DT documentation
Date: Wed, 28 Jan 2015 17:13:35 +0000
Message-Id: <1422465215-12716-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are various issues with the examples in this documentation, some
of the DT labels are invalid and one of the macro THERMAL_NO_LIMITS
referenced is not available as well.

This patch attempts to fix such errors in the documentation.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
Changes Since v1:
	- Fixed few more typo's as suggested by Eduardo Valentin

 .../devicetree/bindings/thermal/thermal.txt        | 66 +++++++++++-----------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/Documentation/devicetree/bindings/thermal/thermal.txt b/Documentation/devicetree/bindings/thermal/thermal.txt
index f5db6b7..91c77da 100644
--- a/Documentation/devicetree/bindings/thermal/thermal.txt
+++ b/Documentation/devicetree/bindings/thermal/thermal.txt
@@ -251,24 +251,24 @@ ocp {
 };
 
 thermal-zones {
-	cpu-thermal: cpu-thermal {
+	cpu_thermal: cpu-thermal {
 		polling-delay-passive = <250>; /* milliseconds */
 		polling-delay = <1000>; /* milliseconds */
 
 		thermal-sensors = <&bandgap0>;
 
 		trips {
-			cpu-alert0: cpu-alert {
+			cpu_alert0: cpu-alert0 {
 				temperature = <90000>; /* millicelsius */
 				hysteresis = <2000>; /* millicelsius */
 				type = "active";
 			};
-			cpu-alert1: cpu-alert {
+			cpu_alert1: cpu-alert1 {
 				temperature = <100000>; /* millicelsius */
 				hysteresis = <2000>; /* millicelsius */
 				type = "passive";
 			};
-			cpu-crit: cpu-crit {
+			cpu_crit: cpu-crit {
 				temperature = <125000>; /* millicelsius */
 				hysteresis = <2000>; /* millicelsius */
 				type = "critical";
@@ -277,17 +277,17 @@ thermal-zones {
 
 		cooling-maps {
 			map0 {
-				trip = <&cpu-alert0>;
-				cooling-device = <&fan0 THERMAL_NO_LIMITS 4>;
+				trip = <&cpu_alert0>;
+				cooling-device = <&fan0 THERMAL_NO_LIMIT 4>;
 			};
 			map1 {
-				trip = <&cpu-alert1>;
-				cooling-device = <&fan0 5 THERMAL_NO_LIMITS>;
+				trip = <&cpu_alert1>;
+				cooling-device = <&fan0 5 THERMAL_NO_LIMIT>;
 			};
 			map2 {
-				trip = <&cpu-alert1>;
+				trip = <&cpu_alert1>;
 				cooling-device =
-				    <&cpu0 THERMAL_NO_LIMITS THERMAL_NO_LIMITS>;
+				    <&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 			};
 		};
 	};
@@ -298,13 +298,13 @@ used to monitor the zone 'cpu-thermal' using its sole sensor. A fan
 device (fan0) is controlled via I2C bus 1, at address 0x48, and has ten
 different cooling states 0-9. It is used to remove the heat out of
 the thermal zone 'cpu-thermal' using its cooling states
-from its minimum to 4, when it reaches trip point 'cpu-alert0'
+from its minimum to 4, when it reaches trip point 'cpu_alert0'
 at 90C, as an example of active cooling. The same cooling device is used at
-'cpu-alert1', but from 5 to its maximum state. The cpu@0 device is also
+'cpu_alert1', but from 5 to its maximum state. The cpu@0 device is also
 linked to the same thermal zone, 'cpu-thermal', as a passive cooling device,
-using all its cooling states at trip point 'cpu-alert1',
+using all its cooling states at trip point 'cpu_alert1',
 which is a trip point at 100C. On the thermal zone 'cpu-thermal', at the
-temperature of 125C, represented by the trip point 'cpu-crit', the silicon
+temperature of 125C, represented by the trip point 'cpu_crit', the silicon
 is not reliable anymore.
 
 (b) - IC with several internal sensors
@@ -329,7 +329,7 @@ ocp {
 };
 
 thermal-zones {
-	cpu-thermal: cpu-thermal {
+	cpu_thermal: cpu-thermal {
 		polling-delay-passive = <250>; /* milliseconds */
 		polling-delay = <1000>; /* milliseconds */
 
@@ -338,12 +338,12 @@ thermal-zones {
 
 		trips {
 			/* each zone within the SoC may have its own trips */
-			cpu-alert: cpu-alert {
+			cpu_alert: cpu-alert {
 				temperature = <100000>; /* millicelsius */
 				hysteresis = <2000>; /* millicelsius */
 				type = "passive";
 			};
-			cpu-crit: cpu-crit {
+			cpu_crit: cpu-crit {
 				temperature = <125000>; /* millicelsius */
 				hysteresis = <2000>; /* millicelsius */
 				type = "critical";
@@ -356,7 +356,7 @@ thermal-zones {
 		};
 	};
 
-	gpu-thermal: gpu-thermal {
+	gpu_thermal: gpu-thermal {
 		polling-delay-passive = <120>; /* milliseconds */
 		polling-delay = <1000>; /* milliseconds */
 
@@ -365,12 +365,12 @@ thermal-zones {
 
 		trips {
 			/* each zone within the SoC may have its own trips */
-			gpu-alert: gpu-alert {
+			gpu_alert: gpu-alert {
 				temperature = <90000>; /* millicelsius */
 				hysteresis = <2000>; /* millicelsius */
 				type = "passive";
 			};
-			gpu-crit: gpu-crit {
+			gpu_crit: gpu-crit {
 				temperature = <105000>; /* millicelsius */
 				hysteresis = <2000>; /* millicelsius */
 				type = "critical";
@@ -383,7 +383,7 @@ thermal-zones {
 		};
 	};
 
-	dsp-thermal: dsp-thermal {
+	dsp_thermal: dsp-thermal {
 		polling-delay-passive = <50>; /* milliseconds */
 		polling-delay = <1000>; /* milliseconds */
 
@@ -392,12 +392,12 @@ thermal-zones {
 
 		trips {
 			/* each zone within the SoC may have its own trips */
-			dsp-alert: gpu-alert {
+			dsp_alert: dsp-alert {
 				temperature = <90000>; /* millicelsius */
 				hysteresis = <2000>; /* millicelsius */
 				type = "passive";
 			};
-			dsp-crit: gpu-crit {
+			dsp_crit: gpu-crit {
 				temperature = <135000>; /* millicelsius */
 				hysteresis = <2000>; /* millicelsius */
 				type = "critical";
@@ -457,7 +457,7 @@ ocp {
 };
 
 thermal-zones {
-	cpu-thermal: cpu-thermal {
+	cpu_thermal: cpu-thermal {
 		polling-delay-passive = <250>; /* milliseconds */
 		polling-delay = <1000>; /* milliseconds */
 
@@ -508,7 +508,7 @@ with many sensors and many cooling devices.
 	/*
 	 * An IC with several temperature sensor.
 	 */
-	adc-dummy: sensor@0x50 {
+	adc_dummy: sensor@0x50 {
 		...
 		#thermal-sensor-cells = <1>; /* sensor internal ID */
 	};
@@ -531,7 +531,7 @@ thermal-zones {
 		};
 	};
 
-	board-thermal: board-thermal {
+	board_thermal: board-thermal {
 		polling-delay-passive = <1000>; /* milliseconds */
 		polling-delay = <2500>; /* milliseconds */
 
@@ -548,22 +548,22 @@ thermal-zones {
 
 		trips {
 			/* Trips are based on resulting linear equation */
-			cpu-trip: cpu-trip {
+			cpu_trip: cpu-trip {
 				temperature = <60000>; /* millicelsius */
 				hysteresis = <2000>; /* millicelsius */
 				type = "passive";
 			};
-			gpu-trip: gpu-trip {
+			gpu_trip: gpu-trip {
 				temperature = <55000>; /* millicelsius */
 				hysteresis = <2000>; /* millicelsius */
 				type = "passive";
 			}
-			lcd-trip: lcp-trip {
+			lcd_trip: lcp-trip {
 				temperature = <53000>; /* millicelsius */
 				hysteresis = <2000>; /* millicelsius */
 				type = "passive";
 			};
-			crit-trip: crit-trip {
+			crit_trip: crit-trip {
 				temperature = <68000>; /* millicelsius */
 				hysteresis = <2000>; /* millicelsius */
 				type = "critical";
@@ -572,17 +572,17 @@ thermal-zones {
 
 		cooling-maps {
 			map0 {
-				trip = <&cpu-trip>;
+				trip = <&cpu_trip>;
 				cooling-device = <&cpu0 0 2>;
 				contribution = <55>;
 			};
 			map1 {
-				trip = <&gpu-trip>;
+				trip = <&gpu_trip>;
 				cooling-device = <&gpu0 0 2>;
 				contribution = <20>;
 			};
 			map2 {
-				trip = <&lcd-trip>;
+				trip = <&lcd_trip>;
 				cooling-device = <&lcd0 5 10>;
 				contribution = <15>;
 			};
-- 
1.9.1

