Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaKXE7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 23:59:32 -0500
Received: from regular1.263xmail.com ([211.150.99.130]:56361 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbaKXE72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 23:59:28 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <1146be768f69e0d33be94e775ecd0a27>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com
Cc: zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dmitry.torokhov@gmail.com, huangtao@rock-chips.com,
        fzf@rock-chips.com, caesar.wang@rock-chips.com
Subject: [PATCH v19 3/5] ARM: dts: add RK3288 Thermal data
Date: Mon, 24 Nov 2014 12:59:00 +0800
Message-Id: <1416805142-27304-4-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416805142-27304-1-git-send-email-caesar.wang@rock-chips.com>
References: <1416805142-27304-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes a dtsi file to contain the thermal data
on RK3288 and later SoCs. This data will
enable a thermal shutdown over 90C.

Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 arch/arm/boot/dts/rk3288-thermal.dtsi | 78 +++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 arch/arm/boot/dts/rk3288-thermal.dtsi

diff --git a/arch/arm/boot/dts/rk3288-thermal.dtsi b/arch/arm/boot/dts/rk3288-thermal.dtsi
new file mode 100644
index 0000000..a8a5ea7
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
+			temperature = <70000>; /* millicelsius */
+			hysteresis = <2000>; /* millicelsius */
+			type = "passive";
+		};
+		cpu_crit: cpu_crit {
+			temperature = <90000>; /* millicelsius */
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
+			temperature = <70000>; /* millicelsius */
+			hysteresis = <2000>; /* millicelsius */
+			type = "passive";
+		};
+		gpu_crit: gpu_crit {
+			temperature = <90000>; /* millicelsius */
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


