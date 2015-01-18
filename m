Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbbARMU5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 07:20:57 -0500
Received: from smtp-4.sys.kth.se ([130.237.48.193]:36532 "EHLO
	smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbbARMU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 07:20:28 -0500
X-KTH-Auth: niso [89.233.231.155]
X-KTH-mail-from: niso@kth.se
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niso@kth.se>
To: linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        linus.walleij@linaro.org
Cc: devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        magnus.damm@gmail.com,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niso@kth.se>
Subject: [PATCH v2 3/4] ARM: shmobile: emev2: Add PFC information to emev2.dtsi
Date: Sun, 18 Jan 2015 13:20:03 +0100
Message-Id: <1421583604-27256-4-git-send-email-niso@kth.se>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421583604-27256-1-git-send-email-niso@kth.se>
References: <1421583604-27256-1-git-send-email-niso@kth.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this information all GPIOs can make use of the PFC functionality.

Signed-off-by: Niklas Söderlund <niso@kth.se>
---
 arch/arm/boot/dts/emev2.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/emev2.dtsi b/arch/arm/boot/dts/emev2.dtsi
index cc7bfe0..bb45694 100644
--- a/arch/arm/boot/dts/emev2.dtsi
+++ b/arch/arm/boot/dts/emev2.dtsi
@@ -169,12 +169,18 @@
 		clock-names = "sclk";
 	};
 
+	pfc: pfc@e0140200 {
+		compatible = "renesas,pfc-emev2";
+		reg = <0xe0140200 0x100>;
+	};
+
 	gpio0: gpio@e0050000 {
 		compatible = "renesas,em-gio";
 		reg = <0xe0050000 0x2c>, <0xe0050040 0x20>;
 		interrupts = <0 67 IRQ_TYPE_LEVEL_HIGH>,
 			     <0 68 IRQ_TYPE_LEVEL_HIGH>;
 		gpio-controller;
+		gpio-ranges = <&pfc 0 0 32>;
 		#gpio-cells = <2>;
 		ngpios = <32>;
 		interrupt-controller;
@@ -186,6 +192,7 @@
 		interrupts = <0 69 IRQ_TYPE_LEVEL_HIGH>,
 			     <0 70 IRQ_TYPE_LEVEL_HIGH>;
 		gpio-controller;
+		gpio-ranges = <&pfc 0 32 32>;
 		#gpio-cells = <2>;
 		ngpios = <32>;
 		interrupt-controller;
@@ -197,6 +204,7 @@
 		interrupts = <0 71 IRQ_TYPE_LEVEL_HIGH>,
 			     <0 72 IRQ_TYPE_LEVEL_HIGH>;
 		gpio-controller;
+		gpio-ranges = <&pfc 0 64 32>;
 		#gpio-cells = <2>;
 		ngpios = <32>;
 		interrupt-controller;
@@ -208,6 +216,7 @@
 		interrupts = <0 73 IRQ_TYPE_LEVEL_HIGH>,
 			     <0 74 IRQ_TYPE_LEVEL_HIGH>;
 		gpio-controller;
+		gpio-ranges = <&pfc 0 96 32>;
 		#gpio-cells = <2>;
 		ngpios = <32>;
 		interrupt-controller;
@@ -219,6 +228,7 @@
 		interrupts = <0 75 IRQ_TYPE_LEVEL_HIGH>,
 			     <0 76 IRQ_TYPE_LEVEL_HIGH>;
 		gpio-controller;
+		gpio-ranges = <&pfc 0 128 31>;
 		#gpio-cells = <2>;
 		ngpios = <31>;
 		interrupt-controller;
-- 
2.2.1

