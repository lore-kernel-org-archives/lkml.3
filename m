Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3AaKpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:45:47 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42210 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab3AaKpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:45:44 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <linux-mmc@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <hs@denx.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <cjb@laptop.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <mporter@ti.com>,
        <ido@wizery.com>, <gregkh@linuxfoundation.org>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] ARM: davinci: da850: add mmc DT entries
Date: Thu, 31 Jan 2013 16:03:07 +0530
Message-ID: <1359628387-14437-4-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359628387-14437-1-git-send-email-prakash.pm@ti.com>
References: <1359628387-14437-1-git-send-email-prakash.pm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT entry for MMC. Also add entry for pinmux information.
Tested on da850-evm without card detect and EDMA support as
DT support for GPIO and EDMA are yet come.

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
Cc: linux-mmc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
Cc: devicetree-discuss@lists.ozlabs.org
Cc: cjb@laptop.org
Cc: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/boot/dts/da850-evm.dts |   13 +++++++++++++
 arch/arm/boot/dts/da850.dtsi    |   15 +++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index fa04152..51c87e7 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -30,6 +30,19 @@
 		rtc0: rtc@1c23000 {
 			status = "okay";
 		};
+		mmc0: mmc@1c40000 {
+			status = "okay";
+			bus-width = <4>;
+			max-frequency = <50000000>;
+			/*
+			 * BIT(1) MMC_CAP_MMC_HIGHSPEED
+			 * BIT(2) MMC_CAP_SD_HIGHSPEED
+			 */
+			caps = <6>;
+			version = <1>;
+			pinctrl-names = "default";
+			pinctrl-0 = <&mmc0_pins>;
+		};
 	};
 	nand_cs3@62000000 {
 		status = "okay";
diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index 099c81e..5978a83 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -56,6 +56,15 @@
 					0x30 0x01100000  0x0ff00000
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
@@ -88,6 +97,12 @@
 				      19>;
 			status = "disabled";
 		};
+		mmc0: mmc@1c40000 {
+			compatible = "ti,davinci_mmc";
+			reg = <0x40000 0x1000>;
+			interrupts = <16>;
+			status = "disabled";
+		};
 	};
 	nand_cs3@62000000 {
 		compatible = "ti,davinci-nand";
-- 
1.7.4.1

