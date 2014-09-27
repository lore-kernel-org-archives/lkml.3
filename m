Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaI0BAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 21:00:31 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:61772 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbaI0BA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 21:00:29 -0400
From: Stefan Wahren <stefan.wahren@i2se.com>
To: lgirdwood@gmail.com, broonie@kernel.org, shawn.guo@linaro.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: festevam@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH 1/2] DT: add binding for mxs regulator
Date: Sat, 27 Sep 2014 00:59:47 +0000
Message-Id: <1411779588-22031-2-git-send-email-stefan.wahren@i2se.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com>
References: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com>
X-Provags-ID: V02:K0:qYsJNq2x7U4ms1lnkEekfC8RPg1b1QnpVTjs4qC3zrv
 vusEM7IWtrsXC5ZcCf/3fcNxbo4/i+3/628dPa8SJxmqhlxaMD
 Jtu1a4QAeTp+kOoB7xh7VrApBDS2oZq5KpvqT8+q2NuFO32qK6
 6aMy0a591JnMeiSFt2Hxu7GKriUWTIX2WfGSnKtaV4c3G5EwST
 sSmXXrraeh6yRJSw/zb1ANDZ09o6gbhgF9qtqUBYzcJmhkbMzE
 5A+x8rlY2+Ws854zngHl/uHUre1+IKAS2IHyx4xKXnGToHJjaQ
 fI2vdb9YImazijv7SaYfyiCyx7/G/Gpi2CE/yVnXYh9cO8+Zxk
 lzB8apP5DH1oT+Wi+eKEtnUQcK53VnvBEpkucBCyUIB9llcOsJ
 nVg6TAq3Arn7SxA4UE4pu8pYMwArtXrHl8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Device tree bindings for the Freescale MXS
on-chip regulators.

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
---
 .../bindings/regulator/mxs-regulator.txt           |   36 ++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/regulator/mxs-regulator.txt

diff --git a/Documentation/devicetree/bindings/regulator/mxs-regulator.txt b/Documentation/devicetree/bindings/regulator/mxs-regulator.txt
new file mode 100644
index 0000000..e3133a4
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/mxs-regulator.txt
@@ -0,0 +1,36 @@
+MXS regulators
+
+Required node properties:
+- compatible: Should be "simple-bus"
+- #address-cells: Number of cells required to define regulator register,
+  must be 1
+- #size-cells: Number of cells required to define register size, must be 1
+- reg: Absolute physical address and size of the register set for the device
+
+Required regulator properties:
+- compatible: Must be "fsl,mxs-regulator"
+- reg: Absolute physical address of the register set for the regulator
+
+Any regulator property defined as part of the core regulator
+binding, defined in regulator.txt, can also be used.
+
+Example:
+
+	power: power@80044000 {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		reg = <0x80044000 0x2000>;
+		ranges;
+
+		reg_vddd: regulator@80044040 {
+			reg = <0x80044040 0x10>;
+			compatible = "fsl,mxs-regulator";
+			regulator-name = "vddd";
+			regulator-min-microvolt = <800000>;
+			regulator-max-microvolt = <1575000>;
+			regulator-boot-on;
+			vddd-supply = <&reg_vdda>;
+		};
+	};
+
-- 
1.7.9.5

