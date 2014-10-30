Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbaJ3DV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 23:21:58 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:37055 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932664AbaJ3DVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 23:21:55 -0400
X-Listener-Flag: 11101
From: <flora.fu@mediatek.com>
To: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, <arm@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Flora Fu <flora.fu@mediatek.com>
Subject: [PATCH 3/3] ARM: dts: mt8135: Add Reset Controller for MediaTek SoC
Date: Thu, 30 Oct 2014 11:12:13 +0800
Message-ID: <1414638733-10080-4-git-send-email-flora.fu@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1414638733-10080-1-git-send-email-flora.fu@mediatek.com>
References: <1414638733-10080-1-git-send-email-flora.fu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Flora Fu <flora.fu@mediatek.com>

Add reset controller to MT8135 board dts.

Signed-off-by: Flora Fu <flora.fu@mediatek.com>
---
 arch/arm/boot/dts/mt8135.dtsi | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm/boot/dts/mt8135.dtsi b/arch/arm/boot/dts/mt8135.dtsi
index 90a56ad..0b1ddc9 100644
--- a/arch/arm/boot/dts/mt8135.dtsi
+++ b/arch/arm/boot/dts/mt8135.dtsi
@@ -102,6 +102,28 @@
 			clock-names = "system-clk", "rtc-clk";
 		};
 
+		infracfg: syscon@10001000 {
+			compatible = "mediatek,mt8135-infracfg", "syscon";
+			reg = <0 0x10001000 0 0x1000>;
+		};
+
+		pericfg: syscon@10003000 {
+			compatible = "mediatek,mt8135-pericfg", "syscon";
+			reg = <0 0x10003000 0 0x1000>;
+		};
+
+		infrarst: reset-controller@10001030 {
+			#reset-cells = <1>;
+			compatible = "mediatek,mt8135-infracfg-reset", "mediatek,reset";
+			mediatek,syscon-reset = <&infracfg 0x30 0x8>;
+		};
+
+		perirst: reset-controller@10003000 {
+			#reset-cells = <1>;
+			compatible = "mediatek,mt8135-pericfg-reset", "mediatek,reset";
+			mediatek,syscon-reset = <&pericfg 0x00 0x8>;
+		};
+
 		gic: interrupt-controller@10211000 {
 			compatible = "arm,cortex-a15-gic";
 			interrupt-controller;
-- 
1.8.1.1.dirty

