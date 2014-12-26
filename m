Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbaLZHKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 02:10:16 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:52537 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751574AbaLZHKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 02:10:09 -0500
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
Subject: [PATCH v4 3/6] dt-bindings:: Add document for MT8135 PMIC Wrapper
Date: Fri, 26 Dec 2014 15:09:25 +0800
Message-ID: <1419577768-12037-4-git-send-email-flora.fu@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1419577768-12037-1-git-send-email-flora.fu@mediatek.com>
References: <1419577768-12037-1-git-send-email-flora.fu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Flora Fu <flora.fu@mediatek.com>
---
 .../soc/mediatek/mediatek,mt8135-pwrap.txt         | 51 ++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/soc/mediatek/mediatek,mt8135-pwrap.txt

diff --git a/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt8135-pwrap.txt b/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt8135-pwrap.txt
new file mode 100644
index 0000000..d630fa0
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/mediatek/mediatek,mt8135-pwrap.txt
@@ -0,0 +1,51 @@
+MediaTek MT8135 PMIC Wrapper Driver
+
+MediaTek PMIC MFD is interfaced to host controller using SPI interface
+by a proprietary hardware called PMIC wrapper or pwrap.
+
++-----------------+           +---------------+
+|                 |           |               |
+| Mediatek AP SoC |           |               |
+| (ex. MT8135)    |           |    MT6397     |
+|                 |           |               |
+|      +--------+ | (SPI bus) | +--------+    |
+|      |        | |-----------| |        |    |
+|      |  PMIC  | |-----------| |  PMIC  |    |
+|      | Wrapper| |-----------| | Wrapper|    |
+|      |        | |-----------| |        |    |
+|      +--------+ |           | +--------+    |
+|                 |           |               |
++-----------------+           +---------------+
+
+This document describes the binding for MT8135 PMIC wrapper.
+
+Required properties in pwrap device node.
+- compatible:"mediatek,mt8135-pwrap"
+- interrupts: IRQ for pwrap in SOC
+- reg: address range for pwrap registers
+- resets: reset bit for pwrap
+- clock: clock frequency selection in SPI bus
+
+Optional properities:
+- pmic: Mediatek PMIC MFD is the child device of pwrap
+  See the following for child node definitions:
+  Documentation/devicetree/bindings/mfd/mt6397.txt
+
+Example:
+	pwrap: pwrap@1000f000 {
+		compatible = "mediatek,mt8135-pwrap";
+		reg = <0 0x1000f000 0 0x1000>,
+			<0 0x11017000 0 0x1000>;
+		reg-names = "pwrap-base", "pwrap-bridge-base";
+		interrupts = <GIC_SPI 128 IRQ_TYPE_LEVEL_HIGH>;
+		resets = <&infrarst MT8135_INFRA_PMIC_WRAP_RST>,
+				<&perirst MT8135_PERI_PWRAP_BRIDGE_SW_RST>;
+		reset-names = "infra-pwrap-rst",
+				"peri-pwrap-bridge-rst";
+		clocks = <&pmicspi_sel>, <&clk26m>;
+		clock-names = "pmicspi-sel", "pmicspi-parent";
+
+		pmic {
+			compatible = "mediatek,mt6397";
+		};
+	};
-- 
1.8.1.1.dirty

