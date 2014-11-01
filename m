Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435AbaKACwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 22:52:09 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:50797 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760365AbaKACwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 22:52:07 -0400
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <f1620d74658ad27a0b0dd463f30ceb8d>
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com
Cc: zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dmitry.torokhov@gmail.com, dbasehore@chromium.org,
        huangtao@rock-chips.com, cjf@rock-chips.com, zhengsq@rock-chips.com,
        fzf@rock-chips.com, Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v17 3/5] ARM: dts: add RK3288 Thermal data
Date: Sat,  1 Nov 2014 10:44:31 +0800
Message-Id: <1414809873-32227-4-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414809873-32227-1-git-send-email-caesar.wang@rock-chips.com>
References: <1414809873-32227-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes a dtsi file to contain the thermal data
on RK3288 and later SoCs. This data will
enable a thermal shutdown over 100C.

Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 arch/arm/boot/dts/rk3288-thermal.dtsi | 78 +++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 arch/arm/boot/dts/rk3288-thermal.dtsi

diff --git a/arch/arm/boot/dts/rk3288-thermal.dtsi b/arch/arm/boot/dts/rk3288-thermal.dtsi
new file mode 100644
index 0000000..fca82b0
--- /dev/null
+++ b/arch/arm/boot/dts/rk3288-thermal.dtsi
@@ -0,0 +1,78 @@
+/*
+ * Device Tree Source for RK3288 SoC thermal
+ *
+ * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#include <dt-bindings/thermal/thermal.h>
+
+reserve_thermal: reserve_thermal {
+	polling-delay-passive = <1000>; /* milliseconds */
+	polling-delay = <5000>; /* milliseconds */
+
+			/* sensor	ID */
+	thermal-sensors = <&tsadc	0>;
+
+};
+
+cpu_thermal: cpu_thermal {
+	polling-delay-passive = <1000>; /* milliseconds */
+	polling-delay = <5000>; /* milliseconds */
+
+			/* sensor	ID */
+	thermal-sensors = <&tsadc	1>;
+
+	trips {
+		cpu_alert0: cpu_alert0 {
+			temperature = <80000>; /* millicelsius */
+			hysteresis = <2000>; /* millicelsius */
+			type = "passive";
+		};
+		cpu_crit: cpu_crit {
+			temperature = <100000>; /* millicelsius */
+			hysteresis = <2000>; /* millicelsius */
+			type = "critical";
+		};
+	};
+
+	cooling-maps {
+		map0 {
+			trip = <&cpu_alert0>;
+			cooling-device =
+				<&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+		};
+	};
+};
+
+gpu_thermal: gpu_thermal {
+	polling-delay-passive = <1000>; /* milliseconds */
+	polling-delay = <5000>; /* milliseconds */
+
+			/* sensor	ID */
+	thermal-sensors = <&tsadc	2>;
+
+	trips {
+		gpu_alert0: gpu_alert0 {
+			temperature = <80000>; /* millicelsius */
+			hysteresis = <2000>; /* millicelsius */
+			type = "passive";
+		};
+		gpu_crit: gpu_crit {
+			temperature = <100000>; /* millicelsius */
+			hysteresis = <2000>; /* millicelsius */
+			type = "critical";
+		};
+	};
+
+	cooling-maps {
+		map0 {
+			trip = <&gpu_alert0>;
+			cooling-device =
+				<&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+		};
+	};
+};
-- 
1.9.1

