Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbbAGHKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:10:25 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43450 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbbAGHJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:09:57 -0500
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: shawn.guo@linaro.org
Cc: linux@arm.linux.org.uk, kernel@pengutronix.de, stefan@agner.ch,
        jingchang.lu@freescale.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [PATCH 2/2] ARM: dts: vfxxx: Add SNVS node
Date: Wed,  7 Jan 2015 12:39:30 +0530
Message-Id: <0d159705cd56248f53c8481a37471f3c0fc14efd.1420612799.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1420612799.git.maitysanchayan@gmail.com>
References: <cover.1420612799.git.maitysanchayan@gmail.com>
In-Reply-To: <cover.1420612799.git.maitysanchayan@gmail.com>
References: <cover.1420612799.git.maitysanchayan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree node for the Secure Non-Volatile Storage
(SNVS) on the VF610 platform. The SNVS block also has a
Real Time Counter (RTC).

Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
---
 arch/arm/boot/dts/vf500.dtsi |    4 ++++
 arch/arm/boot/dts/vfxxx.dtsi |   14 ++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/vf500.dtsi b/arch/arm/boot/dts/vf500.dtsi
index 2901609..0d0de864 100644
--- a/arch/arm/boot/dts/vf500.dtsi
+++ b/arch/arm/boot/dts/vf500.dtsi
@@ -130,6 +130,10 @@
 	interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
 };
 
+&snvsrtc {
+	interrupts = <GIC_SPI 100 IRQ_TYPE_LEVEL_HIGH>;
+};
+
 &src {
 	interrupts = <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>;
 };
diff --git a/arch/arm/boot/dts/vfxxx.dtsi b/arch/arm/boot/dts/vfxxx.dtsi
index a55e1f9..ae5c358 100644
--- a/arch/arm/boot/dts/vfxxx.dtsi
+++ b/arch/arm/boot/dts/vfxxx.dtsi
@@ -351,6 +351,20 @@
 				status = "disabled";
 			};
 
+			snvs0: snvs@400a7000 {
+			    compatible = "fsl,sec-v4.0-mon", "simple-bus";
+				#address-cells = <1>;
+				#size-cells = <1>;
+				ranges = <0 0x400a7000 0x2000>;
+
+				snvsrtc: snvs-rtc-lp@34 {
+					compatible = "fsl,sec-v4.0-mon-rtc-lp";
+					reg = <0x34 0x58>;
+					clocks = <&clks VF610_CLK_SNVS>;
+					clock-names = "snvs-rtc";
+				};
+			};
+
 			uart4: serial@400a9000 {
 				compatible = "fsl,vf610-lpuart";
 				reg = <0x400a9000 0x1000>;
-- 
1.7.9.5

