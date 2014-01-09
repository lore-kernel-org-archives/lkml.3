Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbaAIMgv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:36:51 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:60610 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbaAIMfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:35:18 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, b.brezillon@overkiz.com, arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v2 11/12] at91: dt: sam9261: moved the NAND under the smc node
Date: Thu,  9 Jan 2014 13:31:48 +0100
Message-Id: <1389270709-32662-12-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
References: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 arch/arm/boot/dts/at91sam9261.dtsi  | 35 ++++++++++++++-------------
 arch/arm/boot/dts/at91sam9261ek.dts | 48 ++++++++++++++++++++++++++++---------
 2 files changed, 55 insertions(+), 28 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
index 6c90790..c558918 100644
--- a/arch/arm/boot/dts/at91sam9261.dtsi
+++ b/arch/arm/boot/dts/at91sam9261.dtsi
@@ -525,23 +525,6 @@
 			status = "disabled";
 		};
 
-		nand0: nand@40000000 {
-			compatible = "atmel,at91rm9200-nand";
-			#address-cells = <1>;
-			#size-cells = <1>;
-			reg = <0x40000000 0x10000000>;
-			atmel,nand-addr-offset = <22>;
-			atmel,nand-cmd-offset = <21>;
-			pinctrl-names = "default";
-			pinctrl-0 = <&pinctrl_nand>;
-
-			gpios = <&pioC 15 GPIO_ACTIVE_HIGH
-				&pioC 14 GPIO_ACTIVE_HIGH
-				0
-				>;
-			status = "disabled";
-		};
-
 		smc: smc@ffffec00 {
 			#address-cells = <2>;
 			#size-cells = <1>;
@@ -588,6 +571,24 @@
 				ranges = <0 3 0x00000000 0x10000000>;
 				smc,cs = <3>;
 				status = "disabled";
+
+				nand0: nand@3,0 {
+					compatible = "atmel,at91rm9200-nand";
+					#address-cells = <1>;
+					#size-cells = <1>;
+					reg = <0x0 0x10000000>;
+					atmel,nand-addr-offset = <22>;
+					atmel,nand-cmd-offset = <21>;
+					pinctrl-names = "default";
+					pinctrl-0 = <&pinctrl_nand>, <&pinctrl_smc_nandoe>, <&pinctrl_smc_nandwe>;
+					smc,cs = <3>;
+
+					gpios = <&pioC 15 GPIO_ACTIVE_HIGH
+						&pioC 14 GPIO_ACTIVE_HIGH
+						0
+						>;
+					status = "disabled";
+				};
 			};
 			ebi_cs4@4,0 {
 				#address-cells = <1>;
diff --git a/arch/arm/boot/dts/at91sam9261ek.dts b/arch/arm/boot/dts/at91sam9261ek.dts
index 03c05fc..e92cb8e 100644
--- a/arch/arm/boot/dts/at91sam9261ek.dts
+++ b/arch/arm/boot/dts/at91sam9261ek.dts
@@ -42,17 +42,6 @@
 			};
 		};
 
-		nand0: nand@40000000 {
-			nand-bus-width = <8>;
-			nand-ecc-mode = "soft";
-			nand-on-flash-bbt = <1>;
-			status = "okay";
-			at91bootstrap@0 {
-				label = "at91bootstrap";
-				reg = <0x0 0x20000>;
-			};
-		};
-
 		fb0: fb@0x00600000 {
 			display = <&display0>;
 			status = "okay";
@@ -83,6 +72,43 @@
 				};
 			};
 		};
+
+		smc: smc@ffffec00 {
+			status = "okay";
+
+			ebi_cs3@3,0 {
+				status = "okay";
+				smc,ncs_read_setup = <0>;
+				smc,nrd_setup = <1>;
+				smc,ncs_write_setup = <0>;
+				smc,nwe_setup = <1>;
+				smc,ncs_read_pulse = <3>;
+				smc,nrd_pulse = <3>;
+				smc,ncs_write_pulse = <3>;
+				smc,nwe_pulse = <3>;
+				smc,read_cycle = <5>;
+				smc,write_cycle = <5>;
+				smc,tdf_cycles = <2>;
+				smc,tdf_optimized = <0>;
+				smc,page_size = <0>;
+				smc,byte_access_type = <0>;
+				smc,bus_width = <0>;
+				smc,nwait_mode = <0>;
+				smc,read_mode = <1>;
+				smc,write_mode = <1>;
+
+				nand0: nand@3,0 {
+					nand-bus-width = <8>;
+					nand-ecc-mode = "soft";
+					nand-on-flash-bbt = <1>;
+					status = "okay";
+					at91bootstrap@0 {
+						label = "at91bootstrap";
+						reg = <0x0 0x20000>;
+					};
+				};
+			};
+		};
 	};
 
 	leds {
-- 
1.8.5.2

