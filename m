Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbbAYSel (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:34:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbbAYSKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jisheng Zhang <jszhang@marvell.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH 3.18 131/183] ARM: dts: berlin: correct BG2Qs SM GPIO location.
Date: Sun, 25 Jan 2015 10:07:33 -0800
Message-Id: <20150125180815.864653170@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@marvell.com>

commit 5138d5c562e3bfe30964e20ab46eec9f8b89225d upstream.

The gpio4 and gpio5 are in 0xf7fc0000 apb which is located in the SM domain.
This patch moves gpio4 and gpio5 to the correct location. This patch also
renames them as the following to match the names we internally used in
marvell:
	gpio4 -> sm_gpio1
	gpio5 -> sm_gpio0
	porte -> portf
	portf -> porte

This also matches what we did for BG2 and BG2CD's SM GPIO.

Fixes: cedf57fc4f2f ("ARM: dts: berlin: add the BG2Q GPIO nodes")
Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/berlin2q.dtsi |   60 ++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -315,36 +315,6 @@
 				interrupt-parent = <&gic>;
 				interrupts = <GIC_SPI 3 IRQ_TYPE_LEVEL_HIGH>;
 			};
-
-			gpio4: gpio@5000 {
-				compatible = "snps,dw-apb-gpio";
-				reg = <0x5000 0x400>;
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				porte: gpio-port@4 {
-					compatible = "snps,dw-apb-gpio-port";
-					gpio-controller;
-					#gpio-cells = <2>;
-					snps,nr-gpios = <32>;
-					reg = <0>;
-				};
-			};
-
-			gpio5: gpio@c000 {
-				compatible = "snps,dw-apb-gpio";
-				reg = <0xc000 0x400>;
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				portf: gpio-port@5 {
-					compatible = "snps,dw-apb-gpio-port";
-					gpio-controller;
-					#gpio-cells = <2>;
-					snps,nr-gpios = <32>;
-					reg = <0>;
-				};
-			};
 		};
 
 		chip: chip-control@ea0000 {
@@ -373,6 +343,21 @@
 			ranges = <0 0xfc0000 0x10000>;
 			interrupt-parent = <&sic>;
 
+			sm_gpio1: gpio@5000 {
+				compatible = "snps,dw-apb-gpio";
+				reg = <0x5000 0x400>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				portf: gpio-port@5 {
+					compatible = "snps,dw-apb-gpio-port";
+					gpio-controller;
+					#gpio-cells = <2>;
+					snps,nr-gpios = <32>;
+					reg = <0>;
+				};
+			};
+
 			i2c2: i2c@7000 {
 				compatible = "snps,designware-i2c";
 				#address-cells = <1>;
@@ -423,6 +408,21 @@
 				status = "disabled";
 			};
 
+			sm_gpio0: gpio@c000 {
+				compatible = "snps,dw-apb-gpio";
+				reg = <0xc000 0x400>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				porte: gpio-port@4 {
+					compatible = "snps,dw-apb-gpio-port";
+					gpio-controller;
+					#gpio-cells = <2>;
+					snps,nr-gpios = <32>;
+					reg = <0>;
+				};
+			};
+
 			sysctrl: pin-controller@d000 {
 				compatible = "marvell,berlin2q-system-ctrl";
 				reg = <0xd000 0x100>;


