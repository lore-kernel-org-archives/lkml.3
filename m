Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaK1QoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:44:23 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:56038 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaK1Qnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:43:46 -0500
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@linaro.org, kernel@pengutronix.de, linux@roeck-us.net
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH 1/2] ARM: dts: vf610: add system reset controller (SRC)
Date: Fri, 28 Nov 2014 17:43:34 +0100
Message-Id: <1417193015-6033-2-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417193015-6033-1-git-send-email-stefan@agner.ch>
References: <1417193015-6033-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree property for system reset controller.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/vf500.dtsi | 4 ++++
 arch/arm/boot/dts/vfxxx.dtsi | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/vf500.dtsi b/arch/arm/boot/dts/vf500.dtsi
index de67005..3f38f49 100644
--- a/arch/arm/boot/dts/vf500.dtsi
+++ b/arch/arm/boot/dts/vf500.dtsi
@@ -130,6 +130,10 @@
 	interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
 };
 
+&src {
+	interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
+};
+
 &uart0 {
 	interrupts = <GIC_SPI 61 IRQ_TYPE_LEVEL_HIGH>;
 };
diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
index 505969a..5ff9cc5 100644
--- a/arch/arm/boot/dts/vfxxx.dtsi
+++ b/arch/arm/boot/dts/vfxxx.dtsi
@@ -318,6 +318,11 @@
 				clocks = <&clks VF610_CLK_USBC0>;
 				status = "disabled";
 			};
+
+			src: src@4006e000 {
+				compatible = "fsl,vf610-src";
+				reg = <0x4006e000 0x1000>;
+			};
 		};
 
 		aips1: aips-bus@40080000 {
-- 
2.1.3

