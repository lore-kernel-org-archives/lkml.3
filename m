Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173AbaD3M6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:58:46 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:43983 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758930AbaD3M47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:56:59 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/15] ARM: dts: kirkwood: set default pinctrl for UART0/1
Date: Wed, 30 Apr 2014 14:56:36 +0200
Message-Id: <1398862602-29595-10-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1398862602-29595-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most boards use the default UART0/1 pinctrl setting without RTS/CTS.
Add the pinctrl setting to the toplevel SoC UART nodes and put a note
in front of the corresponding pinctrl node to overwrite the setting
on board level. Currently, both boards using a different UART pinctrl
setting (Openblocks A6, A7) already overwrite the pinctrl node.

While at it, also fix up some status = "ok" to "okay" and again
whitespace issues on mplcec4 uart nodes.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/kirkwood-b3.dts                      | 2 --
 arch/arm/boot/dts/kirkwood-cloudbox.dts                | 2 --
 arch/arm/boot/dts/kirkwood-db.dtsi                     | 4 +---
 arch/arm/boot/dts/kirkwood-dns320.dts                  | 2 --
 arch/arm/boot/dts/kirkwood-laplug.dts                  | 2 --
 arch/arm/boot/dts/kirkwood-mplcec4.dts                 | 8 +++-----
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts         | 4 +---
 arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts | 2 --
 arch/arm/boot/dts/kirkwood-netgear_readynas_nv+_v2.dts | 2 --
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi             | 2 --
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts           | 8 ++------
 arch/arm/boot/dts/kirkwood-openblocks_a7.dts           | 8 ++------
 arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi      | 2 --
 arch/arm/boot/dts/kirkwood-synology.dtsi               | 4 ----
 arch/arm/boot/dts/kirkwood-topkick.dts                 | 4 +---
 arch/arm/boot/dts/kirkwood-ts219.dtsi                  | 4 ----
 arch/arm/boot/dts/kirkwood.dtsi                        | 8 ++++++++
 17 files changed, 18 insertions(+), 50 deletions(-)

diff --git a/arch/arm/boot/dts/kirkwood-b3.dts b/arch/arm/boot/dts/kirkwood-b3.dts
index c723ce7ad1b8..38972b221089 100644
--- a/arch/arm/boot/dts/kirkwood-b3.dts
+++ b/arch/arm/boot/dts/kirkwood-b3.dts
@@ -114,8 +114,6 @@
 			 * UART0_TX = Testpoint 66
 			 * See the Excito Wiki for more details.
 		 	 */
-			pinctrl-0 = <&pmx_uart0>;
-			pinctrl-names = "default";
 			status = "okay";
 		};
 
diff --git a/arch/arm/boot/dts/kirkwood-cloudbox.dts b/arch/arm/boot/dts/kirkwood-cloudbox.dts
index 3f30475fea11..1ac6bd9f54de 100644
--- a/arch/arm/boot/dts/kirkwood-cloudbox.dts
+++ b/arch/arm/boot/dts/kirkwood-cloudbox.dts
@@ -26,8 +26,6 @@
 		};
 
 		serial@12000 {
-			pinctrl-0 = <&pmx_uart0>;
-			pinctrl-names = "default";
 			status = "okay";
 		};
 
diff --git a/arch/arm/boot/dts/kirkwood-db.dtsi b/arch/arm/boot/dts/kirkwood-db.dtsi
index 9b62f78b516b..2790f46d87e0 100644
--- a/arch/arm/boot/dts/kirkwood-db.dtsi
+++ b/arch/arm/boot/dts/kirkwood-db.dtsi
@@ -34,9 +34,7 @@
 		};
 
 		serial@12000 {
-			pinctrl-0 = <&pmx_uart0>;
-			pinctrl-names = "default";
-			status = "ok";
+			status = "okay";
 		};
 
 		sata@80000 {
diff --git a/arch/arm/boot/dts/kirkwood-dns320.dts b/arch/arm/boot/dts/kirkwood-dns320.dts
index 3210daeb264c..d85ef0a91b50 100644
--- a/arch/arm/boot/dts/kirkwood-dns320.dts
+++ b/arch/arm/boot/dts/kirkwood-dns320.dts
@@ -52,8 +52,6 @@
 		};
 
 		serial@12100 {
-			pinctrl-0 = <&pmx_uart1>;
-			pinctrl-names = "default";
 			status = "okay";
 		};
 	};
diff --git a/arch/arm/boot/dts/kirkwood-laplug.dts b/arch/arm/boot/dts/kirkwood-laplug.dts
index 4f7741184f98..4c91fbb084c5 100644
--- a/arch/arm/boot/dts/kirkwood-laplug.dts
+++ b/arch/arm/boot/dts/kirkwood-laplug.dts
@@ -38,8 +38,6 @@
 
 	ocp@f1000000 {
 		serial@12000 {
-			pinctrl-0 = <&pmx_uart0>;
-			pinctrl-names = "default";
 			status = "okay";
 		};
 
diff --git a/arch/arm/boot/dts/kirkwood-mplcec4.dts b/arch/arm/boot/dts/kirkwood-mplcec4.dts
index 414024c578e8..79796c8b9c4f 100644
--- a/arch/arm/boot/dts/kirkwood-mplcec4.dts
+++ b/arch/arm/boot/dts/kirkwood-mplcec4.dts
@@ -90,11 +90,9 @@
 
                 };
 
-                serial@12000 {
-                        status = "ok";
-                        pinctrl-0 = <&pmx_uart0>;
-                        pinctrl-names = "default";
-                };
+		serial@12000 {
+			status = "okay";
+		};
 
 		rtc@10300 {
 			status = "disabled";
diff --git a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
index 52b80b108f8e..acbebc6dc169 100644
--- a/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
+++ b/arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts
@@ -75,9 +75,7 @@
 		};
 
 		serial@12000 {
-			pinctrl-0 = <&pmx_uart0>;
-			pinctrl-names = "default";
-			status = "ok";
+			status = "okay";
 		};
 
 		ehci@50000 {
diff --git a/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts b/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts
index c4741699605c..fd733c63bc27 100644
--- a/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts
+++ b/arch/arm/boot/dts/kirkwood-netgear_readynas_duo_v2.dts
@@ -113,8 +113,6 @@
 		};
 
 		serial@12000 {
-			pinctrl-0 = <&pmx_uart0>;
-			pinctrl-names = "default";
 			status = "okay";
 		};
 
diff --git a/arch/arm/boot/dts/kirkwood-netgear_readynas_nv+_v2.dts b/arch/arm/boot/dts/kirkwood-netgear_readynas_nv+_v2.dts
index 8437f3e3b8d7..b514d643fb6c 100644
--- a/arch/arm/boot/dts/kirkwood-netgear_readynas_nv+_v2.dts
+++ b/arch/arm/boot/dts/kirkwood-netgear_readynas_nv+_v2.dts
@@ -120,8 +120,6 @@
 		};
 
 		serial@12000 {
-			pinctrl-0 = <&pmx_uart0>;
-			pinctrl-names = "default";
 			status = "okay";
 		};
 
diff --git a/arch/arm/boot/dts/kirkwood-ns2-common.dtsi b/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
index 46eb8f6b6243..696b208b676f 100644
--- a/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
+++ b/arch/arm/boot/dts/kirkwood-ns2-common.dtsi
@@ -20,8 +20,6 @@
 		};
 
 		serial@12000 {
-			pinctrl-0 = <&pmx_uart0>;
-			pinctrl-names = "default";
 			status = "okay";
 		};
 
diff --git a/arch/arm/boot/dts/kirkwood-openblocks_a6.dts b/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
index fd1c8b535e28..1e056b3b1817 100644
--- a/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
+++ b/arch/arm/boot/dts/kirkwood-openblocks_a6.dts
@@ -19,15 +19,11 @@
 
 	ocp@f1000000 {
 		serial@12000 {
-			status = "ok";
-			pinctrl-0 = <&pmx_uart0>;
-			pinctrl-names = "default";
+			status = "okay";
 		};
 
 		serial@12100 {
-			status = "ok";
-			pinctrl-0 = <&pmx_uart1>;
-			pinctrl-names = "default";
+			status = "okay";
 		};
 
 		sata@80000 {
diff --git a/arch/arm/boot/dts/kirkwood-openblocks_a7.dts b/arch/arm/boot/dts/kirkwood-openblocks_a7.dts
index 622a3ca12c2d..07f6bf6aba91 100644
--- a/arch/arm/boot/dts/kirkwood-openblocks_a7.dts
+++ b/arch/arm/boot/dts/kirkwood-openblocks_a7.dts
@@ -31,15 +31,11 @@
 
 	ocp@f1000000 {
 		serial@12000 {
-			status = "ok";
-			pinctrl-0 = <&pmx_uart0>;
-			pinctrl-names = "default";
+			status = "okay";
 		};
 
 		serial@12100 {
-			status = "ok";
-			pinctrl-0 = <&pmx_uart1>;
-			pinctrl-names = "default";
+			status = "okay";
 		};
 
 		sata@80000 {
diff --git a/arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi b/arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi
index a015af4da9a2..e2c43aecc7b2 100644
--- a/arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi
+++ b/arch/arm/boot/dts/kirkwood-sheevaplug-common.dtsi
@@ -45,8 +45,6 @@
 			};
 		};
 		serial@12000 {
-			pinctrl-0 = <&pmx_uart0>;
-			pinctrl-names = "default";
 			status = "okay";
 		};
 	};
diff --git a/arch/arm/boot/dts/kirkwood-synology.dtsi b/arch/arm/boot/dts/kirkwood-synology.dtsi
index e137bd4e26fd..370af7f69319 100644
--- a/arch/arm/boot/dts/kirkwood-synology.dtsi
+++ b/arch/arm/boot/dts/kirkwood-synology.dtsi
@@ -277,14 +277,10 @@
 
 		serial@12000 {
 			status = "okay";
-			pinctrl-0 = <&pmx_uart0>;
-			pinctrl-names = "default";
 		};
 
 		serial@12100 {
 			status = "okay";
-			pinctrl-0 = <&pmx_uart1>;
-			pinctrl-names = "default";
 		};
 
 		poweroff@12100 {
diff --git a/arch/arm/boot/dts/kirkwood-topkick.dts b/arch/arm/boot/dts/kirkwood-topkick.dts
index 5bc57efbee99..14b12189d464 100644
--- a/arch/arm/boot/dts/kirkwood-topkick.dts
+++ b/arch/arm/boot/dts/kirkwood-topkick.dts
@@ -86,9 +86,7 @@
 		};
 
 		serial@12000 {
-			status = "ok";
-			pinctrl-0 = <&pmx_uart0>;
-			pinctrl-names = "default";
+			status = "okay";
 		};
 
 		sata@80000 {
diff --git a/arch/arm/boot/dts/kirkwood-ts219.dtsi b/arch/arm/boot/dts/kirkwood-ts219.dtsi
index 414d2246b37c..21cb9aeb2455 100644
--- a/arch/arm/boot/dts/kirkwood-ts219.dtsi
+++ b/arch/arm/boot/dts/kirkwood-ts219.dtsi
@@ -36,13 +36,9 @@
 		};
 		serial@12000 {
 			status = "okay";
-			pinctrl-0 = <&pmx_uart0>;
-			pinctrl-names = "default";
 		};
 		serial@12100 {
 			status = "okay";
-			pinctrl-0 = <&pmx_uart1>;
-			pinctrl-names = "default";
 		};
 		poweroff@12100 {
 			compatible = "qnap,power-off";
diff --git a/arch/arm/boot/dts/kirkwood.dtsi b/arch/arm/boot/dts/kirkwood.dtsi
index fff28b71b474..f92c8c4e3908 100644
--- a/arch/arm/boot/dts/kirkwood.dtsi
+++ b/arch/arm/boot/dts/kirkwood.dtsi
@@ -98,6 +98,10 @@
 				marvell,function = "twsi0";
 			};
 
+			/*
+			 * Default UART pinctrl setting without RTS/CTS,
+			 * overwrite marvell,pins on board level if required.
+			 */
 			pmx_uart0: pmx-uart0 {
 				marvell,pins = "mpp10", "mpp11";
 				marvell,function = "uart0";
@@ -167,6 +171,8 @@
 			reg-shift = <2>;
 			interrupts = <33>;
 			clocks = <&gate_clk 7>;
+			pinctrl-0 = <&pmx_uart0>;
+			pinctrl-names = "default";
 			status = "disabled";
 		};
 
@@ -176,6 +182,8 @@
 			reg-shift = <2>;
 			interrupts = <34>;
 			clocks = <&gate_clk 7>;
+			pinctrl-0 = <&pmx_uart1>;
+			pinctrl-names = "default";
 			status = "disabled";
 		};
 
-- 
1.9.1

