Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaIHKdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 06:33:19 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64148 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbaIHKdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 06:33:13 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH v4 2/4] phy: phy-stih41x-usb: Add dt documentation for USB phy on STiH415/6
Date: Mon,  8 Sep 2014 11:33:01 +0100
Message-Id: <1410172383-17306-3-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410172383-17306-1-git-send-email-peter.griffin@linaro.org>
References: <1410172383-17306-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds dt documentation bindings for the usb phy found
on STiH415/5 SoC's from STMicroelectronics, which support USB 1.1 and 2.0.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 .../devicetree/bindings/phy/phy-stih41x-usb.txt    | 24 ++++++++++++++++++++++
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
1.9.1

