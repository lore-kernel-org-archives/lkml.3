Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab3HWXSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 19:18:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35511 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab3HWXSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 19:18:51 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <linux@roeck-us.net>, <rui.zhang@intel.com>,
        <wni@nvidia.com>
CC: <durgadoss.r@intel.com>, <linux-pm@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [RFC PATCH 06/14] arm: dts: add omap4 CPU thermal data
Date: Fri, 23 Aug 2013 19:15:47 -0400
Message-ID: <1377299755-5134-7-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com>
References: <1377299755-5134-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes a dtsi file to contain the thermal data
for MPU domain on OMAP4 and later SoCs. This data will
enable the passive cooling with CPUfreq cooling device
at 100C and the system will do a thermal shutdown at 125C.

This thermal data can be reused across TI SoC devices.

Cc: "Benoît Cousson" <b-cousson@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Ian Campbell <ian.campbell@citrix.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-omap@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 arch/arm/boot/dts/omap4-cpu-thermal.dtsi | 40 ++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 arch/arm/boot/dts/omap4-cpu-thermal.dtsi

diff --git a/arch/arm/boot/dts/omap4-cpu-thermal.dtsi b/arch/arm/boot/dts/omap4-cpu-thermal.dtsi
new file mode 100644
index 0000000..d74c565
--- /dev/null
+++ b/arch/arm/boot/dts/omap4-cpu-thermal.dtsi
@@ -0,0 +1,40 @@
+
+/*
+ * Device Tree Source for OMAP4/5 SoC CPU thermal
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
+cpu_thermal: cpu_thermal {
+	#thermal-cells = <1>;
+	mask = <0x03>; /* trips writability */
+	passive_delay = <250>; /* milliseconds */
+	polling_delay = <1000>; /* milliseconds */
+	trips {
+		alert@100000{
+			temperature = <100000>; /* milliCelsius */
+			hysteresis = <2000>; /* milliCelsius */
+			type = <THERMAL_TRIP_PASSIVE>;
+		};
+		crit@125000{
+			temperature = <125000>; /* milliCelsius */
+			hysteresis = <2000>; /* milliCelsius */
+			type = <THERMAL_TRIP_CRITICAL>;
+		};
+	};
+	bind_params {
+		action@0{
+			cooling_device = "thermal-cpufreq";
+			weight = <100>; /* percentage */
+			mask = <0x01>;
+			/* no limits, using defaults */
+		};
+	};
+};
-- 
1.8.2.1.342.gfa7285d

