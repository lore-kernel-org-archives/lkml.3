Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaIGLiO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 07:38:14 -0400
Received: from www.augenpunkt.de ([213.239.207.9]:34474 "EHLO
	www.augenpunkt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaIGLiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 07:38:11 -0400
X-Greylist: delayed 1297 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Sep 2014 07:38:11 EDT
From: Stefan Wahren <info@lategoodbye.de>
To: lgirdwood@gmail.com, broonie@kernel.org, shawn.guo@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: festevam@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stefan.wahren@i2se.com, Stefan Wahren <info@lategoodbye.de>
Subject: [PATCH RFC 1/3] DT: add binding for MXS regulator
Date: Sun,  7 Sep 2014 13:37:47 +0200
Message-Id: <1410089869-6611-2-git-send-email-info@lategoodbye.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1410089869-6611-1-git-send-email-info@lategoodbye.de>
References: <1410089869-6611-1-git-send-email-info@lategoodbye.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Device tree bindings for the Freescale MXS on-chip
regulators.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 .../bindings/regulator/mxs-regulator.txt           | 38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/mxs-regulator.txt

diff --git a/Documentation/devicetree/bindings/regulator/mxs-regulator.txt b/Documentation/devicetree/bindings/regulator/mxs-regulator.txt
new file mode 100644
index 0000000..c3226cc
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/mxs-regulator.txt
@@ -0,0 +1,38 @@
+MXS regulators
+
+Required node properties:
+- compatible: Should be "fsl,<soc>-power", where soc is "imx23" or "imx28"
+- reg: Offset and length of the register set for the device
+
+Required regulator properties:
+- compatible: Must be "fsl,mxs-regulator"
+- reg: Offset of the register set for the regulator
+- mxs-max-reg-val: Maximum value of this register
+
+Optional regulator properties:
+- mxs-default-microvolt: initial voltage of the regulator
+
+Any regulator property defined as part of the core regulator
+binding, defined in regulator.txt, can also be used.
+
+Example:
+
+	power: power@80044000 {
+		compatible = "fsl,imx28-power";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		reg = <0x80044000 0x2000>;
+
+		reg_vddio: regulator-vddio@80044060 {
+			reg = <0x80044060>;
+			compatible = "fsl,mxs-regulator";
+			regulator-name = "vddio";
+			regulator-min-microvolt = <2800000>;
+			regulator-max-microvolt = <3600000>;
+			regulator-microvolt-offset = <80000>;
+			regulator-always-on;
+			mxs-max-reg-val = <0x10>;
+			mxs-default-microvolt = <3300000>;
+		};
+	};
+
-- 
1.8.1.4

