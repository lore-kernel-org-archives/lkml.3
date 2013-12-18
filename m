Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab3LRVkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:40:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab3LRVNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 3.12 010/118] ARM: sun6i: dt: Fix interrupt trigger types
Date: Wed, 18 Dec 2013 13:10:47 -0800
Message-Id: <20131218211219.757570561@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <maxime.ripard@free-electrons.com>

commit 6f97dc8d4663abed96fa30e3ea4a1d4cfd1c4276 upstream.

The Allwinner A31 uses the ARM GIC as its internal interrupts controller. The
GIC can work on several interrupt triggers, and the A31 was actually setting it
up to use a rising edge as a trigger, while it was actually a level high
trigger, leading to some interrupts that would be completely ignored if the
edge was missed.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/sun6i-a31.dtsi |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -193,7 +193,10 @@
 		pio: pinctrl@01c20800 {
 			compatible = "allwinner,sun6i-a31-pinctrl";
 			reg = <0x01c20800 0x400>;
-			interrupts = <0 11 1>, <0 15 1>, <0 16 1>, <0 17 1>;
+			interrupts = <0 11 4>,
+				     <0 15 4>,
+				     <0 16 4>,
+				     <0 17 4>;
 			clocks = <&apb1_gates 5>;
 			gpio-controller;
 			interrupt-controller;
@@ -212,11 +215,11 @@
 		timer@01c20c00 {
 			compatible = "allwinner,sun4i-timer";
 			reg = <0x01c20c00 0xa0>;
-			interrupts = <0 18 1>,
-				     <0 19 1>,
-				     <0 20 1>,
-				     <0 21 1>,
-				     <0 22 1>;
+			interrupts = <0 18 4>,
+				     <0 19 4>,
+				     <0 20 4>,
+				     <0 21 4>,
+				     <0 22 4>;
 			clocks = <&osc24M>;
 		};
 
@@ -228,7 +231,7 @@
 		uart0: serial@01c28000 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28000 0x400>;
-			interrupts = <0 0 1>;
+			interrupts = <0 0 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
 			clocks = <&apb2_gates 16>;
@@ -238,7 +241,7 @@
 		uart1: serial@01c28400 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28400 0x400>;
-			interrupts = <0 1 1>;
+			interrupts = <0 1 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
 			clocks = <&apb2_gates 17>;
@@ -248,7 +251,7 @@
 		uart2: serial@01c28800 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28800 0x400>;
-			interrupts = <0 2 1>;
+			interrupts = <0 2 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
 			clocks = <&apb2_gates 18>;
@@ -258,7 +261,7 @@
 		uart3: serial@01c28c00 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c28c00 0x400>;
-			interrupts = <0 3 1>;
+			interrupts = <0 3 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
 			clocks = <&apb2_gates 19>;
@@ -268,7 +271,7 @@
 		uart4: serial@01c29000 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c29000 0x400>;
-			interrupts = <0 4 1>;
+			interrupts = <0 4 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
 			clocks = <&apb2_gates 20>;
@@ -278,7 +281,7 @@
 		uart5: serial@01c29400 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0x01c29400 0x400>;
-			interrupts = <0 5 1>;
+			interrupts = <0 5 4>;
 			reg-shift = <2>;
 			reg-io-width = <4>;
 			clocks = <&apb2_gates 21>;


