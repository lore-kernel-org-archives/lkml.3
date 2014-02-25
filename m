Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaBYLlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 06:41:51 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:47770 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaBYLlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 06:41:49 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, DCG_UPD_stlinux_kernel@list.st.com,
        devicetree@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH v2 1/3] ata: ahci_st: Provide DT bindings for ST's SATA implementation
Date: Tue, 25 Feb 2014 11:41:19 +0000
Message-Id: <1393328481-7251-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: devicetree@vger.kernel.org
Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 Documentation/devicetree/bindings/ata/ahci-st.txt | 31 +++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ata/ahci-st.txt

diff --git a/Documentation/devicetree/bindings/ata/ahci-st.txt b/Documentation/devicetree/bindings/ata/ahci-st.txt
new file mode 100644
index 0000000..1b69fa9
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/ahci-st.txt
@@ -0,0 +1,31 @@
+STMicroelectronics STi SATA controller
+
+This binding describes a SATA device.
+
+Required properties:
+ - compatible	   : Must be "st,ahci"
+ - reg		   : Physical base addresses and length of register sets
+ - interrupts	   : Interrupt associated with the SATA device
+ - interrupt-names :   Associated name must be; "hostc"
+ - resets	   : The power-down and soft-reset lines of SATA IP
+ - reset-names	   :   Associated names must be; "pwr-dwn" and "sw-rst"
+ - clocks	   : The phandle for the clock
+ - clock-names	   :   Associated name must be; "ahci_clk"
+ - phys		   : The phandle for the PHY device
+ - phy-names	   :   Associated name must be; "ahci_phy"
+
+Example:
+
+	sata0: sata@fe380000 {
+		compatible      = "st,ahci";
+		reg             = <0xfe380000 0x1000>;
+		interrupts      = <GIC_SPI 157 IRQ_TYPE_NONE>;
+		interrupt-names = "hostc";
+		phys	        = <&miphy365x_phy MIPHY_PORT_0 MIPHY_TYPE_SATA>;
+		phy-names       = "ahci_phy";
+		resets	        = <&powerdown STIH416_SATA0_POWERDOWN>,
+				  <&softreset STIH416_SATA0_SOFTRESET>;
+		reset-names     = "pwr-dwn", "sw-rst";
+		clocks	        = <&CLK_S_ICN_REG_0>;
+		clock-names     = "ahci_clk";
+	};
-- 
1.8.3.2

