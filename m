Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab3EUQmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 12:42:23 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:48645 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab3EUQmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 12:42:20 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 08/12] ARM: orion5x: add gigabit ethernet and mvmdio device tree nodes
Date: Tue, 21 May 2013 18:41:46 +0200
Message-Id: <1369154510-4927-9-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1367854420-8006-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds mv643xx_eth and mvmdio device tree nodes for DT enabled
Orion5x boards. Phy nodes are also added with reg property set on a
per-board basis.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v3->v4:
- convert to new device tree binding

Cc: David Miller <davem@davemloft.net>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
---
 .../dts/orion5x-lacie-ethernet-disk-mini-v2.dts    |   17 ++++++++++++
 arch/arm/boot/dts/orion5x.dtsi                     |   29 ++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/arch/arm/boot/dts/orion5x-lacie-ethernet-disk-mini-v2.dts b/arch/arm/boot/dts/orion5x-lacie-ethernet-disk-mini-v2.dts
index 0077fc8..c7e2efd 100644
--- a/arch/arm/boot/dts/orion5x-lacie-ethernet-disk-mini-v2.dts
+++ b/arch/arm/boot/dts/orion5x-lacie-ethernet-disk-mini-v2.dts
@@ -53,3 +53,20 @@
 		};
 	};
 };
+
+&mdio {
+	status = "okay";
+
+	&ethphy: ethernet-phy {
+		device-type = "ethernet-phy";
+		reg = <8>;
+	};
+};
+
+&eth {
+	status = "okay";
+
+	ethernet-port@0 {
+		phy-handle = <&ethphy>;
+	};
+};
diff --git a/arch/arm/boot/dts/orion5x.dtsi b/arch/arm/boot/dts/orion5x.dtsi
index 892c64e..6fe45d5 100644
--- a/arch/arm/boot/dts/orion5x.dtsi
+++ b/arch/arm/boot/dts/orion5x.dtsi
@@ -132,5 +132,34 @@
 			interrupts = <28>;
 			status = "okay";
 		};
+
+		mdio: mdio-bus@72004 {
+			compatible = "marvell,orion-mdio";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x72004 0x84>;
+			interrupts = <22>;
+			status = "disabled";
+
+			/* add phy nodes in board file */
+		};
+
+		eth: ethernet-controller@72000 {
+			compatible = "marvell,orion-eth";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <0x72000 0x4000>;
+			marvell,tx-checksum-limit = <1600>;
+			status = "disabled";
+
+			ethernet-port@0 {
+				device_type = "network";
+				compatible = "marvell,orion-eth-port";
+				reg = <0>;
+				/* overwrite MAC address in bootloader */
+				local-mac-address = [00 00 00 00 00 00];
+				/* set phy-handle property in board file */
+			};
+		};
 	};
 };
-- 
1.7.10.4

