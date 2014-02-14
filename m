Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaBNLYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 06:24:14 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:64423 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaBNLYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 06:24:11 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: alexandre.torgue@st.com, Lee Jones <lee.jones@linaro.org>,
        devicetree@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH 1/4] phy: miphy365x: Add Device Tree bindings for the MiPHY365x
Date: Fri, 14 Feb 2014 11:23:53 +0000
Message-Id: <1392377036-12816-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
devices. It has 2 ports which it can use for either; both SATA, both
PCIe or one of each in any configuration.

Cc: devicetree@vger.kernel.org
Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../devicetree/bindings/phy/phy-miphy365x.txt      | 54 ++++++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/phy-miphy365x.txt

diff --git a/Documentation/devicetree/bindings/phy/phy-miphy365x.txt b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
new file mode 100644
index 0000000..96f269f
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/phy-miphy365x.txt
@@ -0,0 +1,54 @@
+STMicroelectronics STi MIPHY365x PHY binding
+============================================
+
+This binding describes a miphy device that is used to control PHY hardware
+for SATA and PCIe.
+
+Required properties:
+- compatible: Should be "st,miphy365x-phy"
+- #phy-cells: Should be 2 (See second example)
+		First cell is the port number; MIPHY_PORT_{0,1}
+		Second cell is device type; MIPHY_TYPE_{SATA,PCI}
+- reg:	      Address and length of the register set for the device
+- reg-names:  The names of the register addresses corresponding to the
+	      registers filled in "reg"
+		Options are; sata{0,1} and pcie{0,1} (See first example)
+- st,syscfg : Should be a phandle of the system configuration register group
+	      which contain the SATA, PCIe mode setting bits
+
+Optional properties:
+- st,sata-gen	     : Generation of locally attached SATA IP. Expected values
+		       are {1,2,3). If not supplied generation 1 hardware will
+		       be expected
+- st,pcie-tx-pol-inv : Bool property to invert the polarity PCIe Tx (Txn/Txp)
+- st,sata-tx-pol-inv : Bool property to invert the polarity SATA Tx (Txn/Txp)
+
+Example:
+
+	miphy365x_phy: miphy365x@0 {
+		compatible = "st,miphy365x-phy";
+		#phy-cells = <2>;
+		reg =	<0xfe382000 0x100>,
+			<0xfe38a000 0x100>,
+			<0xfe394000 0x100>,
+			<0xfe804000 0x100>;
+		reg-names = "sata0", "sata1", "pcie0", "pcie1";
+		st,syscfg= <&syscfg_rear>;
+	};
+
+Specifying phy control of devices
+=================================
+
+Device nodes should specify the configuration required in their "phys"
+property, containing a phandle to the miphy device node, a port number
+and a device type.
+
+Example:
+
+#include <dt-bindings/phy/phy-miphy365x.h>
+
+	sata0: sata@fe380000 {
+		...
+		phys	  = <&miphy365x_phy MIPHY_PORT_0 MIPHY_TYPE_SATA>;
+		...
+	};
-- 
1.8.3.2

