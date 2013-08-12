Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3HLSXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:23:24 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:49865 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab3HLSXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:23:20 -0400
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <tobetter@gmail.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v2] ARM: dts: Add USBPHY nodes to Exynos4x12
Date: Tue, 13 Aug 2013 03:23:08 +0900
Message-Id: <1376331788-16029-1-git-send-email-tobetter@gmail.com>
X-Mailer: git-send-email 1.7.9.5
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device nodes for USBPHY to Exynos4x12.

Signed-off-by: Dongjin Kim <tobetter@gmail.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
* Changes from v1
  o. 'status = "disabled"' is removed to probe as default

 arch/arm/boot/dts/exynos4x12.dtsi |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index 01da194..3ee6102 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -73,4 +73,21 @@
 		clock-names = "sclk_fimg2d", "fimg2d";
 		status = "disabled";
 	};
+
+	usbphy@125B00000 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "samsung,exynos4x12-usb2phy";
+		reg = <0x125B0000 0x100>;
+		ranges;
+
+		clocks = <&clock 2>, <&clock 305>;
+		clock-names = "xusbxti", "otg";
+
+		usbphy-sys {
+			/* USB device and host PHY_CONTROL registers */
+			reg = <0x10020704 0xc>,
+			      <0x1001021c 0x4>;
+		};
+	};
 };
-- 
1.7.9.5

