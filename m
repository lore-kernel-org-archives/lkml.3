Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbaAFWj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:39:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47897 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535AbaAFWjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 3.12 130/144] ARM: sun7i: dt: Fix interrupt trigger types
Date: Mon,  6 Jan 2014 14:38:11 -0800
Message-Id: <20140106223749.073233988@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <maxime.ripard@free-electrons.com>

commit 378d0aee3b53bd8549b29dcc75f2bf47ee446e8f upstream.

The Allwinner A20 uses the ARM GIC as its internal interrupts controller. The
GIC can work on several interrupt triggers, and the A20 was actually setting it
up to use a rising edge as a trigger, while it was actually a level high
trigger, leading to some interrupts that would be completely ignored if the
edge was missed.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/sun7i-a20.dtsi |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -170,7 +170,7 @@
 		emac: ethernet@01c0b000 {
 			compatible = "allwinner,sun4i-emac";
 			reg = <0x01c0b000 0x1000>;
-			interrupts = <0 55 1>;
+			interrupts = <0 55 4>;
 			clocks = <&ahb_gates 17>;
 			status = "disabled";
 		};
@@ -186,7 +186,7 @@
 		pio: pinctrl@01c20800 {
 			compatible = "allwinner,sun7i-a20-pinctrl";
 			reg = <0x01c20800 0x400>;
-			interrupts = <0 28 1>;
+			interrupts = <0 28 4>;
 			clocks = <&apb0_gates 5>;
 			gpio-controller;
 			interrupt-controller;
@@ -230,12 +230,12 @@
 		timer@01c20c00 {
 			compatible = "allwinner,sun4i-timer";
 			reg = <0x01c20c00 0x90>;
-			interrupts = <0 22 1>,
-				     <0 23 1>,
-				     <0 24 1>,
-				     <0 25 1>,
-				     <0 67 1>,
-				     <0 68 1>;
+			interrupts = <0 22 4>,
+				     <0 23 4>,
+				     <0 24 4>,
+				     <0 25 4>,
+				     <0 67 4>,
+				     <0 68 4>;
 			clocks = <&osc24M>;
 		};
 
@@ -247,7 +247,7 @@
 		uart0: serial@01c28000 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28000 0x400>;
-			interrupts = <0 1 1>;
+			interrupts = <0 1 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
 			clocks = <&apb1_gates 16>;
@@ -257,7 +257,7 @@
 		uart1: serial@01c28400 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28400 0x400>;
-			interrupts = <0 2 1>;
+			interrupts = <0 2 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
 			clocks = <&apb1_gates 17>;
@@ -267,7 +267,7 @@
 		uart2: serial@01c28800 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28800 0x400>;
-			interrupts = <0 3 1>;
+			interrupts = <0 3 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
 			clocks = <&apb1_gates 18>;
@@ -277,7 +277,7 @@
 		uart3: serial@01c28c00 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28c00 0x400>;
-			interrupts = <0 4 1>;
+			interrupts = <0 4 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
 			clocks = <&apb1_gates 19>;
@@ -287,7 +287,7 @@
 		uart4: serial@01c29000 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c29000 0x400>;
-			interrupts = <0 17 1>;
+			interrupts = <0 17 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
 			clocks = <&apb1_gates 20>;
@@ -297,7 +297,7 @@
 		uart5: serial@01c29400 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c29400 0x400>;
-			interrupts = <0 18 1>;
+			interrupts = <0 18 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
 			clocks = <&apb1_gates 21>;
@@ -307,7 +307,7 @@
 		uart6: serial@01c29800 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c29800 0x400>;
-			interrupts = <0 19 1>;
+			interrupts = <0 19 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
 			clocks = <&apb1_gates 22>;
@@ -317,7 +317,7 @@
 		uart7: serial@01c29c00 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c29c00 0x400>;
-			interrupts = <0 20 1>;
+			interrupts = <0 20 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
 			clocks = <&apb1_gates 23>;


