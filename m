Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaDRKXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:23:39 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60725 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752222AbaDRKX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:23:28 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH 5/8] ARM: mvebu: Add Device Tree description of xHCI hosts on Armada 38x
Date: Fri, 18 Apr 2014 12:22:40 +0200
Message-Id: <1397816563-9000-6-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1397816563-9000-1-git-send-email-gregory.clement@free-electrons.com>
References: <1397816563-9000-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Marvell Armada 38x SoCs contain two xHCI host. This commit adds
the Device Tree description of those interfaces at the SoC level, and
also enables the two USB3 ports on the Armada 385 DB platform and one
USB3 port on the Armada 385 RD platforms.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/boot/dts/armada-385-db.dts |  8 ++++++++
 arch/arm/boot/dts/armada-385-rd.dts |  4 ++++
 arch/arm/boot/dts/armada-38x.dtsi   | 17 +++++++++++++++++
 3 files changed, 29 insertions(+)

diff --git a/arch/arm/boot/dts/armada-385-db.dts b/arch/arm/boot/dts/armada-385-db.dts
index 6828d77696a6..d5db1466da82 100644
--- a/arch/arm/boot/dts/armada-385-db.dts
+++ b/arch/arm/boot/dts/armada-385-db.dts
@@ -101,6 +101,14 @@
 					reg = <0x1000000 0x3f000000>;
 				};
 			};
+
+			usb3@f0000 {
+				status = "okay";
+			};
+
+			usb3@f8000 {
+				status = "okay";
+			};
 		};
 
 		pcie-controller {
diff --git a/arch/arm/boot/dts/armada-385-rd.dts b/arch/arm/boot/dts/armada-385-rd.dts
index 45250c88814b..a505fe94ff37 100644
--- a/arch/arm/boot/dts/armada-385-rd.dts
+++ b/arch/arm/boot/dts/armada-385-rd.dts
@@ -77,6 +77,10 @@
 					reg = <1>;
 				};
 			};
+
+			usb3@f0000 {
+				status = "okay";
+			};
 		};
 
 		pcie-controller {
diff --git a/arch/arm/boot/dts/armada-38x.dtsi b/arch/arm/boot/dts/armada-38x.dtsi
index a064f59da02d..4f117e66aa1a 100644
--- a/arch/arm/boot/dts/armada-38x.dtsi
+++ b/arch/arm/boot/dts/armada-38x.dtsi
@@ -355,6 +355,23 @@
 				clocks = <&coredivclk 0>;
 				status = "disabled";
 			};
+
+			usb3@f0000 {
+				compatible = "marvell,xhci-armada-380";
+				reg = <0xf0000 0x3fff>,<0xf4000 0x3fff>;
+				interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&gateclk 9>;
+				status = "disabled";
+			};
+
+			usb3@f8000 {
+				compatible = "marvell,xhci-armada-380";
+				reg = <0xf8000 0x3fff>,<0xfc000 0x3fff>;
+				interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&gateclk 10>;
+				status = "disabled";
+			};
+
 		};
 	};
 
-- 
1.8.1.2

