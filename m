Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3A1Hq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 02:46:56 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33272 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606Ab3A1Hqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 02:46:55 -0500
From: Mrugesh Katepallewar <mrugesh.mk@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <nsekhar@ti.com>, <hs@denx.de>
Subject: [PATCH V2] ARM: davinci: da850: add RTC DT entries
Date: Mon, 28 Jan 2013 13:17:48 +0530
Message-ID: <1359359268-9781-1-git-send-email-mrugesh.mk@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add RTC DT entries in da850 dts file.

Signed-off-by: Mrugesh Katepallewar <mrugesh.mk@ti.com>
---
Applies on top of v3.8-rc4 of linus tree.

This patch is depending on 
"ARM: davinci: da850: add interrupt-parent property in soc node"
https://patchwork.kernel.org/patch/2044101/

Tested on da850-evm device.

Test Procedure:
date 2013.01.28-10:00:00 (usage: date[YYYY.]MM.DD-hh:mm[:ss])
hwclock -w
reset board and check system time.

Changes Since V1:
Remove interrupt-parent property from RTC node.
Change RTC node name in dts and dtsi file.

:100644 100644 37dc5a3... af4b7cc... M	arch/arm/boot/dts/da850-evm.dts
:100644 100644 640ab75... 90be701... M	arch/arm/boot/dts/da850.dtsi
 arch/arm/boot/dts/da850-evm.dts |    3 +++
 arch/arm/boot/dts/da850.dtsi    |    7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index 37dc5a3..af4b7cc 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -24,5 +24,8 @@
 		serial2: serial@1d0d000 {
 			status = "okay";
 		};
+		rtc0: rtc@1c23000 {
+			status = "okay";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index 640ab75..90be701 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -56,5 +56,12 @@
 			interrupt-parent = <&intc>;
 			status = "disabled";
 		};
+		rtc0: rtc@1c23000 {
+			compatible = "ti,da830-rtc";
+			reg = <0x23000 0x1000>;
+			interrupts = <19
+				      19>;
+			status = "disabled";
+		};
 	};
 };
-- 
1.7.9.5

