Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527Ab3APDsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 22:48:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45242 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757582Ab3APDru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 22:47:50 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <khilman@deeprootsystems.com>,
        <hs@denx.de>, <anilkumar.v@ti.com>
Subject: [PATCH V4 3/3] ARM: davinci: da850: add NAND driver DT entries
Date: Wed, 16 Jan 2013 09:18:22 +0530
Message-ID: <1358308102-8169-4-git-send-email-anilkumar.v@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358308102-8169-1-git-send-email-anilkumar.v@ti.com>
References: <1358308102-8169-1-git-send-email-anilkumar.v@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add NAND driver DT node and related pinctrl DT data to export NAND
functionality on da850 evm.

Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
---
:100644 100644 c7609d0... 433027f... M	arch/arm/boot/dts/da850-evm.dts
:100644 100644 e9c6e82... 59e6ea4... M	arch/arm/boot/dts/da850.dtsi
 arch/arm/boot/dts/da850-evm.dts |    5 +++++
 arch/arm/boot/dts/da850.dtsi    |   30 ++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index c7609d0..433027f 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -28,4 +28,9 @@
 			status = "okay";
 		};
 	};
+	nand_cs3@62000000 {
+		status = "okay";
+		pinctrl-names = "default";
+		pinctrl-0 = <&nand_cs3_pins>;
+	};
 };
diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index e9c6e82..59e6ea4 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -38,6 +38,23 @@
 			pinctrl-single,register-width = <32>;
 			pinctrl-single,function-mask = <0xffffffff>;
 			status = "disabled";
+
+			nand_cs3_pins: pinmux_nand_pins {
+				pinctrl-single,bits = <
+					/* EMA_OE, EMA_WE */
+					0x1c 0x00110000  0x00ff0000
+					/* EMA_CS[4],EMA_CS[3]*/
+					0x1c 0x00000110  0x00000ff0
+					/*
+					 * EMA_D[0], EMA_D[1], EMA_D[2],
+					 * EMA_D[3], EMA_D[4], EMA_D[5],
+					 * EMA_D[6], EMA_D[7]
+					 */
+					0x24 0x11111111  0xffffffff
+					/* EMA_A[1], EMA_A[2] */
+					0x30 0x01100000  0x0ff00000
+				>;
+			};
 		};
 		serial0: serial@1c42000 {
 			compatible = "ns16550a";
@@ -67,4 +84,17 @@
 			status = "disabled";
 		};
 	};
+	nand_cs3@62000000 {
+		compatible = "ti,davinci-nand";
+		reg = <0x62000000 0x807ff
+			0x68000000 0x8000>;
+		ti,davinci-chipselect = <1>;
+		ti,davinci-mask-ale = <0>;
+		ti,davinci-mask-cle = <0>;
+		ti,davinci-mask-chipsel = <0>;
+		ti,davinci-ecc-mode = "hw";
+		ti,davinci-ecc-bits = <4>;
+		ti,davinci-nand-use-bbt;
+		status = "disabled";
+	};
 };
-- 
1.7.4.1

