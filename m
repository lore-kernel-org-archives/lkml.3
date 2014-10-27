Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaJ0Mhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:37:52 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37743 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaJ0Mhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:37:48 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Joerg Roedel <joro@8bytes.org>, Heiko Stuebner <heiko@sntech.de>
Cc: Grant Grundler <grundler@chromium.org>,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>, Simon Xue <xxm@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Doug Anderson <dianders@chromium.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 2/3] dt-bindings: iommu: Add documentation for rockchip iommu
Date: Mon, 27 Oct 2014 20:37:27 +0800
Message-Id: <1414413448-15819-3-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1414413448-15819-1-git-send-email-djkurtz@chromium.org>
References: <1414413448-15819-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding documentation for Rockchip IOMMU.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Simon Xue <xxm@rock-chips.com>
---
 .../devicetree/bindings/iommu/rockchip,iommu.txt   | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iommu/rockchip,iommu.txt

diff --git a/Documentation/devicetree/bindings/iommu/rockchip,iommu.txt b/Documentation/devicetree/bindings/iommu/rockchip,iommu.txt
new file mode 100644
index 0000000..9a55ac3
--- /dev/null
+++ b/Documentation/devicetree/bindings/iommu/rockchip,iommu.txt
@@ -0,0 +1,26 @@
+Rockchip IOMMU
+==============
+
+A Rockchip DRM iommu translates io virtual addresses to physical addresses for
+its master device.  Each slave device is bound to a single master device, and
+shares its clocks, power domain and irq.
+
+Required properties:
+- compatible      : Should be "rockchip,iommu"
+- reg             : Address space for the configuration registers
+- interrupts      : Interrupt specifier for the IOMMU instance
+- interrupt-names : Interrupt name for the IOMMU instance
+- #iommu-cells    : Should be <0>.  This indicates the iommu is a
+                    "single-master" device, and needs no additional information
+                    to associate with its master device.  See:
+                    Documentation/devicetree/bindings/iommu/iommu.txt
+
+Example:
+
+	vopl_mmu: iommu@ff940300 {
+		compatible = "rockchip,iommu";
+		reg = <0xff940300 0x100>;
+		interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "vopl_mmu";
+		#iommu-cells = <0>;
+	};
-- 
2.1.0.rc2.206.gedb03e5

