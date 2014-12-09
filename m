Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbaLICss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 21:48:48 -0500
Received: from lucky1.263xmail.com ([211.157.147.131]:44800 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbaLICsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 21:48:47 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <e357b04914f1a5bf439faa2f6f82ea37>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Yunzhi Li <lyz@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        lyz@rock-chips.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: [PATCH v4 2/5] Documentation: bindings: add doc for the Rockchip usb PHY
Date: Tue,  9 Dec 2014 10:48:13 +0800
Message-Id: <1418093293-30557-1-git-send-email-lyz@rock-chips.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the bindings of the Rockchip usb PHY driver.

Signed-off-by: Yunzhi Li <lyz@rock-chips.com>

---

Changes in v4:
- Updata description for phy device tree subnode.

Changes in v3: None

 .../devicetree/bindings/phy/rockchip-usb-phy.txt   | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/rockchip-usb-phy.txt

diff --git a/Documentation/devicetree/bindings/phy/rockchip-usb-phy.txt b/Documentation/devicetree/bindings/phy/rockchip-usb-phy.txt
new file mode 100644
index 0000000..0b725e4
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/rockchip-usb-phy.txt
@@ -0,0 +1,32 @@
+ROCKCHIP USB2 PHY
+
+Required properties:
+ - compatible: rockchip,rk3288-usb-phy
+ - rockchip,grf : phandle to the syscon managing the "general
+   register files"
+ - #phy-cells: should be 1
+ - #address-cells: should be 1
+ - #size-cells: should be 0
+
+Sub-nodes:
+Each PHY should be represented as a sub-node.
+
+Sub-nodes
+required properties:
+- reg: the PHY number
+		"0" - PHY connect to OTG controller
+		"1" - PHY connect to HOST0 controller
+		"2" - PHY connect to HOST1 controller
+
+Optional Properties:
+- clocks : phandle + clock specifier for the phy clocks
+
+Example:
+
+usbphy: phy {
+	#phy-cells = <1>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+	compatible = "rockchip,rk3288-usb-phy";
+	rockchip,grf = <&grf>;
+};
-- 
2.0.0


