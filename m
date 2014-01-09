Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbaAIMhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:37:01 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:56210 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbaAIMfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:35:16 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, b.brezillon@overkiz.com, arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v2 10/12] at91: dt: sam9261: Add an entry in the DT for the SMC/EBI bus driver.
Date: Thu,  9 Jan 2014 13:31:47 +0100
Message-Id: <1389270709-32662-11-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
References: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates a new entry in the device tree for the 9261 under which
should be the described the devices attached to the SMC/EBI.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 arch/arm/boot/dts/at91sam9261.dtsi | 73 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
index 695d5d2..6c90790 100644
--- a/arch/arm/boot/dts/at91sam9261.dtsi
+++ b/arch/arm/boot/dts/at91sam9261.dtsi
@@ -542,6 +542,79 @@
 			status = "disabled";
 		};
 
+		smc: smc@ffffec00 {
+			#address-cells = <2>;
+			#size-cells = <1>;
+			compatible = "atmel,at91sam9261-smc";
+			reg = <0xffffec00 0x80>;
+			pinctrl-names = "default";
+			status = "disabled";
+			ranges = <0 0 0x10000000 0x10000000
+				  1 0 0x20000000 0x10000000
+				  2 0 0x30000000 0x10000000
+				  3 0 0x40000000 0x10000000
+				  4 0 0x50000000 0x10000000
+				  5 0 0x60000000 0x10000000
+				  6 0 0x70000000 0x10000000>;
+
+			ebi_cs0@0,0 {
+				#address-cells = <1>;
+				#size-cells = <1>;
+				compatible = "simple-bus";
+				ranges = <0 0 0x00000000 0x10000000>;
+				smc,cs = <0>;
+				status = "disabled";
+			};
+			ebi_cs1@1,0 {
+				#address-cells = <1>;
+				#size-cells = <1>;
+				compatible = "simple-bus";
+				ranges = <0 1 0x00000000 0x10000000>;
+				smc,cs = <1>;
+				status = "disabled";
+			};
+			ebi_cs2@2,0 {
+				#address-cells = <1>;
+				#size-cells = <1>;
+				compatible = "simple-bus";
+				ranges = <0 2 0x00000000 0x10000000>;
+				smc,cs = <2>;
+				status = "disabled";
+			};
+			ebi_cs3@3,0 {
+				#address-cells = <1>;
+				#size-cells = <1>;
+				compatible = "simple-bus";
+				ranges = <0 3 0x00000000 0x10000000>;
+				smc,cs = <3>;
+				status = "disabled";
+			};
+			ebi_cs4@4,0 {
+				#address-cells = <1>;
+				#size-cells = <1>;
+				compatible = "simple-bus";
+				ranges = <0 4 0x00000000 0x10000000>;
+				smc,cs = <4>;
+				status = "disabled";
+			};
+			ebi_cs5@5,0 {
+				#address-cells = <1>;
+				#size-cells = <1>;
+				compatible = "simple-bus";
+				ranges = <0 5 0x00000000 0x10000000>;
+				smc,cs = <5>;
+				status = "disabled";
+			};
+			ebi_cs6@6,0 {
+				#address-cells = <1>;
+				#size-cells = <1>;
+				compatible = "simple-bus";
+				ranges = <0 6 0x00000000 0x10000000>;
+				smc,cs = <6>;
+				status = "disabled";
+			};
+		};
+
 		usb0: ohci@00500000 {
 			compatible = "atmel,at91rm9200-ohci", "usb-ohci";
 			reg = <0x00500000 0x100000>;
-- 
1.8.5.2

