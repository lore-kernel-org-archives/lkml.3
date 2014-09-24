Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaIXNrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:47:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55832 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753683AbaIXNrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:47:53 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 19/22] phy: phy-stih41x-usb: Add dt documentation for USB phy on STiH415/6
Date: Wed, 24 Sep 2014 19:17:17 +0530
Message-ID: <1411566440-19169-20-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411566440-19169-1-git-send-email-kishon@ti.com>
References: <1411566440-19169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Griffin <peter.griffin@linaro.org>

This patch adds dt documentation bindings for the usb phy found
on STiH415/5 SoC's from STMicroelectronics, which support USB 1.1 and 2.0.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/phy/phy-stih41x-usb.txt    |   24 ++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-stih41x-usb.txt

diff --git a/Documentation/devicetree/bindings/phy/phy-stih41x-usb.txt b/Documentation/devicetree/bindings/phy/phy-stih41x-usb.txt
new file mode 100644
index 0000000..00944a0
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/phy-stih41x-usb.txt
@@ -0,0 +1,24 @@
+STMicroelectronics STiH41x USB PHY binding
+------------------------------------------
+
+This file contains documentation for the usb phy found in STiH415/6 SoCs from
+STMicroelectronics.
+
+Required properties:
+- compatible	: should be "st,stih416-usb-phy" or "st,stih415-usb-phy"
+- st,syscfg	: should be a phandle of the syscfg node
+- clock-names	: must contain "osc_phy"
+- clocks	: must contain an entry for each name in clock-names.
+See: Documentation/devicetree/bindings/clock/clock-bindings.txt
+- #phy-cells	: must be 0 for this phy
+See: Documentation/devicetree/bindings/phy/phy-bindings.txt
+
+Example:
+
+usb2_phy: usb2phy@0 {
+	compatible	= "st,stih416-usb-phy";
+	#phy-cell	= <0>;
+	st,syscfg	= <&syscfg_rear>;
+	clocks		= <&clk_sysin>;
+	clock-names	= "osc_phy";
+};
-- 
1.7.9.5

