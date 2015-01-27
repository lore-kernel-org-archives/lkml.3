Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbbA0M2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:28:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35348 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758685AbbA0MTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jisheng Zhang <jszhang@marvell.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 096/126] ARM: dts: berlin: correct BG2Q's SM GPIO location.
Date: Tue, 27 Jan 2015 12:16:41 +0000
Message-Id: <1422361031-19364-97-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/boot/dts/berlin2q.dtsi | 60 ++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
index 39b181dc6fab..dc773bb4b6cd 100644
--- a/arch/arm/boot/dts/berlin2q.dtsi
+++ b/arch/arm/boot/dts/berlin2q.dtsi
@@ -264,36 +264,6 @@
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
@@ -312,6 +282,21 @@
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
 			uart0: uart@9000 {
 				compatible = "snps,dw-apb-uart";
 				reg = <0x9000 0x100>;
@@ -336,6 +321,21 @@
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
-- 
2.1.4

