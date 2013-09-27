Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab3I0DRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 23:17:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33697 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3I0DRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 23:17:50 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <wni@nvidia.com>
CC: <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv4 16/18] arm: dts: add omap5 CORE thermal data
Date: Thu, 26 Sep 2013 23:13:23 -0400
Message-ID: <1380251605-3804-17-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.8.2.1.342.gfa7285d
In-Reply-To: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com>
References: <1380251605-3804-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes a dtsi file to contain the thermal data
for CORE domain on OMAP5 and later SoCs. This data will
enable a thermal shutdown at 125C.

This thermal data can be reused across TI SoC devices.

Cc: "Benoît Cousson" <bcousson@baylibre.com>
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
 arch/arm/boot/dts/omap5-core-thermal.dtsi | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 arch/arm/boot/dts/omap5-core-thermal.dtsi

diff --git a/arch/arm/boot/dts/omap5-core-thermal.dtsi b/arch/arm/boot/dts/omap5-core-thermal.dtsi
new file mode 100644
index 0000000..3e9dc00
--- /dev/null
+++ b/arch/arm/boot/dts/omap5-core-thermal.dtsi
@@ -0,0 +1,28 @@
+/*
+ * Device Tree Source for OMAP543x SoC CORE thermal
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
+core_thermal: core_thermal {
+	polling-delay-passive = <250>; /* milliseconds */
+	polling-delay = <1000>; /* milliseconds */
+
+			/* sensor       ID */
+	thermal-sensors = <&bandgap     2>;
+
+	trips {
+		core_crit: core_crit {
+			temperature = <125000>; /* milliCelsius */
+			hysteresis = <2000>; /* milliCelsius */
+			type = THERMAL_TRIP_CRITICAL;
+		};
+	};
+};
-- 
1.8.2.1.342.gfa7285d

