Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935390Ab3BOGWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:22:25 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45810 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab3BOGWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:22:23 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <linux-mmc@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <hs@denx.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <cjb@laptop.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 4/5] ARM: davinci: da850: add mmc DT entries
Date: Fri, 15 Feb 2013 11:52:01 +0530
Message-ID: <1360909322-1858-5-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360909322-1858-1-git-send-email-prakash.pm@ti.com>
References: <1360909322-1858-1-git-send-email-prakash.pm@ti.com>
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
Since v2:
Remove properties specifying for highspeed card capability.
Since v1:
Removed bitfields for specifying the device capabilty and accomodate
controller revision in compatible field.

 arch/arm/boot/dts/da850-evm.dts |    7 +++++++
 arch/arm/boot/dts/da850.dtsi    |   14 ++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index f712fb6..78c8e54 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -39,6 +39,13 @@
 		wdt: wdt@1c21000 {
 			status = "okay";
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
index 4b2262a..ebe7386 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -67,6 +67,15 @@
 					0x10 0x00002200 0x0000ff00
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
@@ -110,6 +119,11 @@
 		wdt: wdt@1c21000 {
 			compatible = "ti,davinci-wdt";
 			reg = <0x21000 0x1000>;
+		};
+		mmc0: mmc@1c40000 {
+			compatible = "ti,davinci-mmc-da830";
+			reg = <0x40000 0x1000>;
+			interrupts = <16>;
 			status = "disabled";
 		};
 	};
-- 
1.7.4.1

