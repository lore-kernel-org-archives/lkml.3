Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbaLZHK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 02:10:28 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:34352 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751729AbaLZHKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 02:10:23 -0500
X-Listener-Flag: 11101
From: Flora Fu <flora.fu@mediatek.com>
To: Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>, Flora Fu <flora.fu@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Dongdong Cheng <dongdong.cheng@mediatek.com>,
        HenryC Chen <henryc.chen@mediatek.com>,
        Menghui Lin <menghui.lin@mediatek.com>,
        Chen Zhong <chen.zhong@mediatek.com>
Subject: [PATCH v4 5/6] arm: dts: mt8135: Add support for MT8135 PMIC wrapper
Date: Fri, 26 Dec 2014 15:09:27 +0800
Message-ID: <1419577768-12037-6-git-send-email-flora.fu@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1419577768-12037-1-git-send-email-flora.fu@mediatek.com>
References: <1419577768-12037-1-git-send-email-flora.fu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree for MT8135 PMIC wrapper in mt8135.dtsi.

Signed-off-by: Flora Fu <flora.fu@mediatek.com>
---
 arch/arm/boot/dts/mt8135.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/mt8135.dtsi b/arch/arm/boot/dts/mt8135.dtsi
index ec83e69..ab08063 100644
--- a/arch/arm/boot/dts/mt8135.dtsi
+++ b/arch/arm/boot/dts/mt8135.dtsi
@@ -117,6 +117,20 @@
 			reg = <0 0x10200030 0 0x1c>;
 		};
 
+		pwrap: pwrap@1000f000 {
+			compatible = "mediatek,mt8135-pwrap";
+			reg = <0 0x1000f000 0 0x1000>,
+				<0 0x11017000 0 0x1000>;
+			reg-names = "pwrap-base", "pwrap-bridge-base";
+			interrupts = <GIC_SPI 128 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&infrarst MT8135_INFRA_PMIC_WRAP_RST>,
+					<&perirst MT8135_PERI_PWRAP_BRIDGE_SW_RST>;
+			reset-names = "infra-pwrap-rst",
+					"peri-pwrap-bridge-rst";
+			clocks = <&topckgen TOP_PMICSPI_SEL>, <&clk26m> ;
+			clock-names = "pmicspi-sel", "pmicspi-parent";
+		};
+
 		gic: interrupt-controller@10211000 {
 			compatible = "arm,cortex-a15-gic";
 			interrupt-controller;
-- 
1.8.1.1.dirty

