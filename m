Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbaGBOJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:09:45 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:60593 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbaGBOJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:09:41 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, srinivas.kandagatla@gmail.com,
        maxime.coquelin@st.com, patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH v2 2/4] reset: sti: Document sti-picophyreset controllers bindings.
Date: Wed,  2 Jul 2014 15:08:47 +0100
Message-Id: <1404310129-14667-3-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404310129-14667-1-git-send-email-peter.griffin@linaro.org>
References: <1404310129-14667-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT bindings documentation for sti-picophyreset controller.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 .../bindings/reset/st,sti-picophyreset.txt         | 42 ++++++++++++++++++++++
 1 file changed, 42 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt

diff --git a/Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt b/Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt
new file mode 100644
index 0000000..54ae9f7
--- /dev/null
+++ b/Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt
@@ -0,0 +1,42 @@
+STMicroelectronics STi family Sysconfig Picophy SoftReset Controller
+=============================================================================
+
+This binding describes a reset controller device that is used to enable and
+disable on-chip PicoPHY USB2 phy(s) using "softreset" control bits found in
+the STi family SoC system configuration registers.
+
+The actual action taken when softreset is asserted is hardware dependent.
+However, when asserted it may not be possible to access the hardware's
+registers and after an assert/deassert sequence the hardware's previous state
+may no longer be valid.
+
+Please refer to Documentation/devicetree/bindings/reset/reset.txt
+for common reset controller binding usage.
+
+Required properties:
+- compatible: Should be "st,stih407-picophyreset"
+- #reset-cells: 1, see below
+
+Example:
+
+	picophyreset: picophyreset-controller {
+		compatible = "st,stih407-picophyreset";
+		#reset-cells = <1>;
+	};
+
+Specifying picophyreset control of devices
+=======================================
+
+Device nodes should specify the reset channel required in their "resets"
+property, containing a phandle to the picophyreset device node and an
+index specifying which channel to use, as described in
+Documentation/devicetree/bindings/reset/reset.txt.
+
+Example:
+
+	usb2_picophy0: usbpicophy@0 {
+		resets = <&picophyreset STIH407_PICOPHY0_RESET>;
+	};
+
+Macro definitions for the supported reset channels can be found in:
+include/dt-bindings/reset-controller/stih407-resets.h
-- 
1.9.1

