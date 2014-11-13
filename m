Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875AbaKMLBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:01:13 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:47489 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932818AbaKMLBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:01:04 -0500
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        patrice.chotard@st.com, arnd@arndb.de
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH v2 09/14] ARM: STi: DT: STiH410:  Add pinctl config for usb controllers.
Date: Thu, 13 Nov 2014 11:00:12 +0000
Message-Id: <1415876417-28728-10-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org>
References: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the required pin configiguration for the extra usb
controllers found on the stih410 device.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/boot/dts/stih410-pinctrl.dtsi | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 arch/arm/boot/dts/stih410-pinctrl.dtsi

diff --git a/arch/arm/boot/dts/stih410-pinctrl.dtsi b/arch/arm/boot/dts/stih410-pinctrl.dtsi
new file mode 100644
index 0000000..b3e9dfc
--- /dev/null
+++ b/arch/arm/boot/dts/stih410-pinctrl.dtsi
@@ -0,0 +1,34 @@
+/*
+ * Copyright (C) 2014 STMicroelectronics Limited.
+ * Author: Peter Griffin <peter.griffin@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * publishhed by the Free Software Foundation.
+ */
+#include "st-pincfg.h"
+/ {
+
+	soc {
+		pin-controller-rear {
+
+			usb0 {
+				pinctrl_usb0: usb2-0 {
+					st,pins {
+						usb-oc-detect = <&pio35 0 ALT1 IN>;
+						usb-pwr-enable = <&pio35 1 ALT1 OUT>;
+					};
+				};
+			};
+
+			usb1 {
+				pinctrl_usb1: usb2-1 {
+					st,pins {
+						usb-oc-detect = <&pio35 2 ALT1 IN>;
+						usb-pwr-enable = <&pio35 3 ALT1 OUT>;
+					};
+				};
+			};
+		};
+	};
+};
-- 
1.9.1

