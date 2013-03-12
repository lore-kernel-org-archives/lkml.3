Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab3CLONx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 10:13:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52441 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab3CLONv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 10:13:51 -0400
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <linux-mmc@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <hs@denx.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <cjb@laptop.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 3/4] ARM: davinci: da850: add mmc DT entries
Date: Tue, 12 Mar 2013 19:43:56 +0530
Message-ID: <1363097637-11371-4-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363097637-11371-1-git-send-email-prakash.pm@ti.com>
References: <1363097637-11371-1-git-send-email-prakash.pm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT entry for MMC. Also add entry for pinmux information.
Tested:
1) Without GPIO card detection and EDMA support as DT support for
   GPIO and EDMA are yet come.
2) By creating/deleting files and mounting/unmounting the partition.

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
Cc: linux-mmc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
Cc: devicetree-discuss@lists.ozlabs.org
Cc: cjb@laptop.org
Cc: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/boot/dts/da850-evm.dts |    7 +++++++
 arch/arm/boot/dts/da850.dtsi    |   15 +++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index fe2bbe7..bc1f951 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -81,6 +81,13 @@
 				};
 			};
 		};
+		mmc0: mmc@1c40000 {
+			max-frequency = <50000000>;
+			bus-width = <4>;
+			status = "okay";
+			pinctrl-names = "default";
+			pinctrl-0 = <&mmc0_pins>;
+		};
 	};
 	nand_cs3@62000000 {
 		status = "okay";
diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index 327fb06..142382d 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -70,6 +70,15 @@
 					0x14 0x00111111 0x00ffffff
 				>;
 			};
+			mmc0_pins: pinmux_mmc_pins {
+				pinctrl-single,bits = <
+					/* MMCSD0_DAT[3] MMCSD0_DAT[2]
+					 * MMCSD0_DAT[1] MMCSD0_DAT[0]
+					 * MMCSD0_CMD    MMCSD0_CLK
+					 */
+					0x28 0x00222222  0x00ffffff
+				>;
+			};
 		};
 		serial0: serial@1c42000 {
 			compatible = "ns16550a";
@@ -115,6 +124,12 @@
 			reg = <0x21000 0x1000>;
 			status = "disabled";
 		};
+		mmc0: mmc@1c40000 {
+			compatible = "ti,davinci-mmc-da830";
+			reg = <0x40000 0x1000>;
+			interrupts = <16>;
+			status = "disabled";
+		};
 		spi1: spi@1f0e000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
1.7.4.1

