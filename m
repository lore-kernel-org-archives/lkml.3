Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbaKULOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 06:14:41 -0500
Received: from 14.mo4.mail-out.ovh.net ([46.105.40.29]:44931 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750922AbaKULOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 06:14:39 -0500
From: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
To: Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Rockchip
	SoC...),
        linux-rockchip@lists.infradead.org (open list:ARM/Rockchip SoC...),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Cc: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Subject: [PATCH] ARM: dts: rockchip: enable I2C0, SPI and SARADC on Radxa Rock
Date: Fri, 21 Nov 2014 11:57:16 +0100
Message-Id: <1416567436-26706-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Mailer: git-send-email 2.1.0
X-Ovh-Tracer-Id: 2199726944346046689
X-Ovh-Remote: 193.248.240.88 (laubervilliers-656-1-116-88.w193-248.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrledtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrledtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables user space access to the I2C0 bus, SPI0 bus, SPI1 bus
and the 3 Analog-to-digital inputs available on the Radxa Rock headers.

We have to disable UART1 because SPI0 and UART1 are multiplexed together.

Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
---
 arch/arm/boot/dts/rk3188-radxarock.dts | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/rk3188-radxarock.dts b/arch/arm/boot/dts/rk3188-radxarock.dts
index 6eb62c0..06b2256 100644
--- a/arch/arm/boot/dts/rk3188-radxarock.dts
+++ b/arch/arm/boot/dts/rk3188-radxarock.dts
@@ -122,6 +122,10 @@
 	cpu0-supply = <&vdd_arm>;
 };
 
+&i2c0 {
+	status = "okay";
+};
+
 &i2c1 {
 	status = "okay";
 	clock-frequency = <400000>;
@@ -294,14 +298,22 @@
 	};
 };
 
+&saradc {
+	status = "okay";
+};
+
+&spi0 {
+	status = "okay";
+};
+
+&spi1 {
+	status = "okay";
+};
+
 &uart0 {
 	status = "okay";
 };
 
-&uart1 {
-	status = "okay";
-};
-
 &uart2 {
 	status = "okay";
 };
-- 
2.1.0

