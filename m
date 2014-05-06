Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaEFNZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:25:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54113 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbaEFNY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:24:57 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <mturquette@linaro.org>, <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <ldewangan@nvidia.com>,
        <linux-doc@vger.kernel.org>, <nm@ti.com>, <robh+dt@kernel.org>
Subject: [PATCH v2 1/2] dt/bindings: Binding documentation for Palmas clk32kg and clk32kgaudio clocks
Date: Tue, 6 May 2014 16:24:44 +0300
Message-ID: <1399382685-14781-2-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399382685-14781-1-git-send-email-peter.ujfalusi@ti.com>
References: <1399382685-14781-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palmas class of devices can provide 32K clock(s) to be used by other devices
on the board. Depending on the actual device the provided clocks can be:
CLK32K_KG and CLK32K_KGAUDIO
or only one:
CLK32K_KG (TPS659039 for example)

Use separate compatible flags for the two 32K clock.
A system which needs or have only one of the 32k clock from
Palmas will need to add node(s) for each clock as separate section
in the dts file.
The two compatible property is:
"ti,palmas-clk32kg" for clk32kg clock
"ti,palmas-clk32kgaudio" for clk32kgaudio clock

Apart from the register control of the clocks - which is done via
the clock API there is a posibility to enable the external sleep
control. In this way the clock can be enabled/disabled on demand by the
user of the clock.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 .../bindings/clock/clk-palmas-clk32kg-clocks.txt   | 35 ++++++++++++++++++++++
 include/dt-bindings/mfd/palmas.h                   | 18 +++++++++++
 2 files changed, 53 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/clk-palmas-clk32kg-clocks.txt
 create mode 100644 include/dt-bindings/mfd/palmas.h

diff --git a/Documentation/devicetree/bindings/clock/clk-palmas-clk32kg-clocks.txt b/Documentation/devicetree/bindings/clock/clk-palmas-clk32kg-clocks.txt
new file mode 100644
index 000000000000..4208886d834a
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/clk-palmas-clk32kg-clocks.txt
@@ -0,0 +1,35 @@
+* Palmas 32KHz clocks *
+
+Palmas device has two clock output pins for 32KHz, KG and KG_AUDIO.
+
+This binding uses the common clock binding ./clock-bindings.txt.
+
+Required properties:
+- compatible :	"ti,palmas-clk32kg" for clk32kg clock
+		"ti,palmas-clk32kgaudio" for clk32kgaudio clock
+- #clock-cells : shall be set to 0.
+
+Optional property:
+- ti,external-sleep-control: The external enable input pins controlled the
+	enable/disable of clocks.  The external enable input pins ENABLE1,
+	ENABLE2 and NSLEEP. The valid values for the external pins are:
+		PALMAS_EXT_CONTROL_PIN_ENABLE1 for ENABLE1 pin
+		PALMAS_EXT_CONTROL_PIN_ENABLE2 for ENABLE2 pin
+		PALMAS_EXT_CONTROL_PIN_NSLEEP for NSLEEP pin
+	Option 0 or missing this property means the clock is enabled/disabled
+	via register access and these pins do not have any control.
+	The macros of external control pins for DTS is defined at
+	dt-bindings/mfd/palmas.h
+
+Example:
+	#include <dt-bindings/mfd/palmas.h>
+	...
+	palmas: tps65913@58 {
+		...
+		clk32kg: palmas_clk32k@0 {
+			compatible = "ti,palmas-clk32kg";
+			#clock-cells = <0>;
+			ti,external-sleep-control = <PALMAS_EXT_CONTROL_PIN_NSLEEP>;
+		};
+		...
+	};
diff --git a/include/dt-bindings/mfd/palmas.h b/include/dt-bindings/mfd/palmas.h
new file mode 100644
index 000000000000..2c8ac4841385
--- /dev/null
+++ b/include/dt-bindings/mfd/palmas.h
@@ -0,0 +1,18 @@
+/*
+ * This header provides macros for Palmas device bindings.
+ *
+ * Copyright (c) 2013, NVIDIA Corporation.
+ *
+ * Author: Laxman Dewangan <ldewangan@nvidia.com>
+ *
+ */
+
+#ifndef __DT_BINDINGS_PALMAS_H__
+#define __DT_BINDINGS_PALMAS_H
+
+/* External control pins */
+#define PALMAS_EXT_CONTROL_PIN_ENABLE1	1
+#define PALMAS_EXT_CONTROL_PIN_ENABLE2	2
+#define PALMAS_EXT_CONTROL_PIN_NSLEEP	3
+
+#endif /* __DT_BINDINGS_PALMAS_H */
-- 
1.9.2

