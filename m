Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaETJUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:20:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36082 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbaETJSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:18:33 -0400
From: Keerthy <j-keerthy@ti.com>
To: <devicetree@vger.kernel.org>
CC: <robh+dt@kernel.org>, <mark.rutland@arm.com>, <sameo@linux.intel.com>,
        <grant.likely@linaro.org>, <ian@slimlogic.co.uk>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <broonie@linaro.org>, <swarren@nvidia.com>, <lee.jones@linaro.org>,
        <linux-omap@vger.kernel.org>, Keerthy <j-keerthy@ti.com>
Subject: [PATCH v2 1/4] MFD: DT bindings for the TPS65917 family MFD
Date: Tue, 20 May 2014 14:41:36 +0530
Message-ID: <1400577099-8743-2-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400577099-8743-1-git-send-email-j-keerthy@ti.com>
References: <1400577099-8743-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the various binding files for the TPS65917 family of chips. There is a
top level MFD binding then a seperate binding for regulators IP blocks on chips.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 Documentation/devicetree/bindings/mfd/tps65917.txt |   35 ++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/tps65917.txt

diff --git a/Documentation/devicetree/bindings/mfd/tps65917.txt b/Documentation/devicetree/bindings/mfd/tps65917.txt
new file mode 100644
index 0000000..287a713
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/tps65917.txt
@@ -0,0 +1,35 @@
+* TPS65917 device tree bindings
+
+The TI TPS65917 family of PMICs.
+
+Required properties:
+- compatible : Should be from the list
+  ti,tps65917
+- interrupt-controller : TPS65917 has its own internal IRQs
+- #interrupt-cells : should be set to 2 for IRQ number and flags
+  The first cell is the IRQ number.
+  The second cell is the flags, encoded as the trigger masks from
+  Documentation/devicetree/bindings/interrupts.txt
+- interrupt-parent : The parent interrupt controller.
+
+Optional properties:
+  ti,mux-padX : set the pad register X (1-2) to the correct muxing for the
+		hardware, if not set will use muxing in OTP.
+
+Example:
+
+tps65917 {
+	compatible = "ti,tps65917";
+	reg = <0x58>
+	interrupt-parent = <&intc>;
+	interrupt-controller;
+	#interrupt-cells = <2>;
+
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	pmic {
+		compatible = "ti,tps65917-pmic";
+		....
+	};
+}
-- 
1.7.9.5

