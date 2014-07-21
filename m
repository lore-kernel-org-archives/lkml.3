Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbaGUI3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:29:05 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:52697 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbaGUI3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:29:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tj@kernel.org, devicetree@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH 1/1] ahci: st: Provide DT bindings for ST's SATA implementation
Date: Mon, 21 Jul 2014 09:28:36 +0100
Message-Id: <1405931316-12276-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: devicetree@vger.kernel.org
Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Acked-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---

Hi Tejun,

This patch has been on the MLs for a few months now.  It documents
ST's AHCI driver which was accepted by you and now resides in
Mainline.

Kind regards,
Lee

 Documentation/devicetree/bindings/ata/ahci-st.txt | 31 +++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ata/ahci-st.txt

diff --git a/Documentation/devicetree/bindings/ata/ahci-st.txt b/Documentation/devicetree/bindings/ata/ahci-st.txt
new file mode 100644
index 0000000..0574a77
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/ahci-st.txt
@@ -0,0 +1,31 @@
+STMicroelectronics STi SATA controller
+
+This binding describes a SATA device.
+
+Required properties:
+ - compatible	   : Must be "st,sti-ahci"
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
+		compatible      = "st,sti-ahci";
+		reg             = <0xfe380000 0x1000>;
+		interrupts      = <GIC_SPI 157 IRQ_TYPE_NONE>;
+		interrupt-names = "hostc";
+		phys	        = <&miphy365x_phy MIPHY_PORT_0 MIPHY_TYPE_SATA>;
+		phy-names       = "ahci_phy";
+		resets	        = <&powerdown STIH416_SATA0_POWERDOWN>,
+				  <&softreset STIH416_SATA0_SOFTRESET>;
+		reset-names     = "pwr-dwn", "sw-rst";
+		clocks	        = <&clk_s_a0_ls CLK_ICN_REG>;
+		clock-names     = "ahci_clk";
+	};
-- 
1.8.3.2

