Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751141AbaK1LoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:44:18 -0500
Received: from 10.mo69.mail-out.ovh.net ([46.105.73.241]:35908 "EHLO
	mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750904AbaK1LoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:44:15 -0500
X-Greylist: delayed 4726 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Nov 2014 06:44:15 EST
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
Subject: [PATCH] ARM: dts: rockchip: set FIFO size for SDMMC, SDIO and EMMC
Date: Fri, 28 Nov 2014 11:24:14 +0100
Message-Id: <1417170254-13615-1-git-send-email-julien.chauveau@neo-technologies.fr>
X-Mailer: git-send-email 2.1.0
X-Ovh-Tracer-Id: 5584182064490873057
X-Ovh-Remote: 193.248.240.88 (laubervilliers-656-1-116-88.w193-248.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejiedrtdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejiedrtdelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SDMMC, SDIO and EMMC controllers use an external FIFO whose size is 256x32bit.
This patch set the corresponding fifo-depth properties for both RK3066 and RK3188.

Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
---
 arch/arm/boot/dts/rk3xxx.dtsi | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/rk3xxx.dtsi b/arch/arm/boot/dts/rk3xxx.dtsi
index 87df6a8..c54a971 100644
--- a/arch/arm/boot/dts/rk3xxx.dtsi
+++ b/arch/arm/boot/dts/rk3xxx.dtsi
@@ -177,10 +177,9 @@
 		compatible = "rockchip,rk2928-dw-mshc";
 		reg = <0x10214000 0x1000>;
 		interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
-
 		clocks = <&cru HCLK_SDMMC>, <&cru SCLK_SDMMC>;
 		clock-names = "biu", "ciu";
-
+		fifo-depth = <256>;
 		status = "disabled";
 	};
 
@@ -188,10 +187,9 @@
 		compatible = "rockchip,rk2928-dw-mshc";
 		reg = <0x10218000 0x1000>;
 		interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
-
 		clocks = <&cru HCLK_SDIO>, <&cru SCLK_SDIO>;
 		clock-names = "biu", "ciu";
-
+		fifo-depth = <256>;
 		status = "disabled";
 	};
 
@@ -199,10 +197,9 @@
 		compatible = "rockchip,rk2928-dw-mshc";
 		reg = <0x1021c000 0x1000>;
 		interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
-
 		clocks = <&cru HCLK_EMMC>, <&cru SCLK_EMMC>;
 		clock-names = "biu", "ciu";
-
+		fifo-depth = <256>;
 		status = "disabled";
 	};
 
-- 
2.1.0

