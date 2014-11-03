Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaKCCyF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 21:54:05 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:56302 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaKCCx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 21:53:58 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
        Joerg Roedel <joro@8bytes.org>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Simon Xue <xxm@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Rockchip
	SoC...),
        linux-rockchip@lists.infradead.org (open list:ARM/Rockchip SoC...),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v7 3/3] ARM: dts: rk3288: add VOP iommu nodes
Date: Mon,  3 Nov 2014 10:53:29 +0800
Message-Id: <1414983209-2472-4-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1414983209-2472-1-git-send-email-djkurtz@chromium.org>
References: <1414983209-2472-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device nodes for the VOP iommus.
Device nodes for other iommus will be added in later patches.

The iommu nodes use the #iommu-cells property as described in:
  Documentation/devicetree/bindings/iommu/iommu.txt

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Simon Xue <xxm@rock-chips.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 5950b0a..df1170c 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -271,6 +271,24 @@
 		status = "disabled";
 	};
 
+	vopb_mmu: iommu@ff930300 {
+		compatible = "rockchip,iommu";
+		reg = <0xff930300 0x100>;
+		interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "vopb_mmu";
+		#iommu-cells = <0>;
+		status = "disabled";
+	};
+
+	vopl_mmu: iommu@ff940300 {
+		compatible = "rockchip,iommu";
+		reg = <0xff940300 0x100>;
+		interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "vopl_mmu";
+		#iommu-cells = <0>;
+		status = "disabled";
+	};
+
 	gic: interrupt-controller@ffc01000 {
 		compatible = "arm,gic-400";
 		interrupt-controller;
-- 
2.1.0.rc2.206.gedb03e5

