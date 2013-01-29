Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab3A2FTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 00:19:19 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35113 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168Ab3A2FTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 00:19:12 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <b-cousson@ti.com>, <tony@atomide.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <linux@arm.linux.org.uk>, <nsekhar@ti.com>,
        <khilman@deeprootsystems.com>, <hs@denx.de>, <anilkumar.v@ti.com>
Subject: [PATCH 1/2] ARM: davinci: da850 evm: add norflash DT node
Date: Tue, 29 Jan 2013 10:49:55 +0530
Message-ID: <1359436796-25135-2-git-send-email-anilkumar.v@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359436796-25135-1-git-send-email-anilkumar.v@ti.com>
References: <1359436796-25135-1-git-send-email-anilkumar.v@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add norflash DT node on DA850 EVM and related pin mux.

Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
---
:100644 100644 087ba28... 95ffeca... M	arch/arm/boot/dts/da850-evm.dts
:100644 100644 160ebac... 036b02a... M	arch/arm/boot/dts/da850.dtsi
 arch/arm/boot/dts/da850-evm.dts |   25 +++++++++++++++++++++++
 arch/arm/boot/dts/da850.dtsi    |   41 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index 087ba28..95ffeca 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -28,4 +28,29 @@
 			status = "okay";
 		};
 	};
+	norflash_cs2@60000000 {
+		compatible = "intel,PC28F640P30T85", "cfi-flash";
+		reg = <0x60000000 0x1FFFFFF>;
+		bank-width = <2>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		linux,mtd-name = "physmap-flash";
+		pinctrl-names = "default";
+		pinctrl-0 = <&norflash_cs2_pins>;
+
+		bootloaders_env@0 {
+			label = "bootloaders_env";
+			reg = <0 0x80000>;
+		};
+
+		kernel@80000 {
+			label = "kernel";
+			reg = <0x80000 0x200000>;
+		};
+
+		filesystem@280000 {
+			label = "filesystem";
+			reg = <0x280000 0x580000>;
+		};
+	};
 };
diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index 160ebac..036b02a 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -38,6 +38,47 @@
 			pinctrl-single,register-width = <32>;
 			pinctrl-single,function-mask = <0xffffffff>;
 			status = "disabled";
+
+			norflash_cs2_pins: pinmux_norflash_pins{
+				pinctrl-single,bits = <
+					/* EMA_BA[1] */
+					0x14 0x01000000 0x0f000000
+					/* EMA_CLK, EMA_WAIT[1] */
+					0x18 0x01000001 0x0f00000f
+					/* EMA_OE, EMA_WE, EMA_CS[2] */
+					0x1c 0x00110001 0x00ff000f
+					/*
+					 * EMA_D[0], EMA_D[1], EMA_D[2],
+					 * EMA_D[3], EMA_D[4], EMA_D[5],
+					 * EMA_D[6], EMA_D[7]
+					 */
+					0x24 0x11111111 0xffffffff
+					/*
+					 * EMA_D[8], EMA_D[9], EMA_D[10],
+					 * EMA_D[11], EMA_D[12], EMA_D[13],
+					 * EMA_D[14], EMA_D[15]
+					 */
+					0x20 0x11111111 0xffffffff
+					/*
+					 * EMA_A[0], EMA_A[1], EMA_A[2],
+					 * EMA_A[3], EMA_A[4], EMA_A[5],
+					 * EMA_A[6], EMA_A[7]
+					 */
+					0x30 0x11111111 0xffffffff
+					/*
+					 * EMA_A[8], EMA_A[9], EMA_A[10],
+					 * EMA_A[11], EMA_A[12], EMA_A[13],
+					 * EMA_A[14], EMA_A[15]
+					 */
+					0x2c 0x11111111 0xffffffff
+					/*
+					 * EMA_A[16], EMA_A[17], EMA_A[18],
+					 * EMA_A[19], EMA_A[20], EMA_A[21],
+					 * EMA_A[22]
+					 */
+					0x28 0x11111110 0xfffffff0
+				>;
+			};
 		};
 		serial0: serial@1c42000 {
 			compatible = "ns16550a";
-- 
1.7.4.1

