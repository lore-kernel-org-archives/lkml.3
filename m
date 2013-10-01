Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab3JASeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 14:34:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33553 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab3JASeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 14:34:06 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <grant.likely@linaro.org>
CC: <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 2/7] arm: dts: add dra7 IVA thermal data
Date: Tue, 1 Oct 2013 14:32:19 -0400
Message-ID: <1380652344-18819-3-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1380652344-18819-1-git-send-email-eduardo.valentin@ti.com>
References: <1380652344-18819-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes a dtsi file to contain the thermal data
for IVA domain on DRA7 and later SoCs. This data will
enable a thermal shutdown at 125C.

This thermal data can be reused across TI SoC devices.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 arch/arm/boot/dts/dra7-iva-thermal.dtsi | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 arch/arm/boot/dts/dra7-iva-thermal.dtsi

diff --git a/arch/arm/boot/dts/dra7-iva-thermal.dtsi b/arch/arm/boot/dts/dra7-iva-thermal.dtsi
new file mode 100644
index 0000000..fea0cea
--- /dev/null
+++ b/arch/arm/boot/dts/dra7-iva-thermal.dtsi
@@ -0,0 +1,28 @@
+/*
+ * Device Tree Source for DRA7 SoC IVA thermal
+ *
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ * Contact: Eduardo Valentin <eduardo.valentin@ti.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#include <dt-bindings/thermal/thermal.h>
+
+iva_thermal: iva_thermal {
+	polling-delay-passive = <250>; /* milliseconds */
+	polling-delay = <1000>; /* milliseconds */
+
+		/* sensor       ID */
+	thermal-sensors = <&bandgap     4>;
+
+	trips {
+		iva_crit: iva_crit {
+			temperature = <125000>; /* milliCelsius */
+			hysteresis = <2000>; /* milliCelsius */
+			type = THERMAL_TRIP_CRITICAL;
+		};
+	};
+};
-- 
1.8.2.1.342.gfa7285d

