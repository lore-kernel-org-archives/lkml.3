Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbaKEOW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:22:27 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:54322 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755035AbaKEOWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:22:24 -0500
X-Listener-Flag: 11101
From: Flora Fu <flora.fu@mediatek.com>
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
Subject: [PATCH v3 2/3] dt-bindings: Add Reset Controller for MediaTek SoC
Date: Wed, 5 Nov 2014 22:21:31 +0800
Message-ID: <1415197292-10546-3-git-send-email-flora.fu@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1415197292-10546-1-git-send-email-flora.fu@mediatek.com>
References: <1415197292-10546-1-git-send-email-flora.fu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree bindings.

Signed-off-by: Flora Fu <flora.fu@mediatek.com>
---
 .../devicetree/bindings/reset/mediatek,reset.txt   | 50 ++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reset/mediatek,reset.txt

diff --git a/Documentation/devicetree/bindings/reset/mediatek,reset.txt b/Documentation/devicetree/bindings/reset/mediatek,reset.txt
new file mode 100644
index 0000000..a876407
--- /dev/null
+++ b/Documentation/devicetree/bindings/reset/mediatek,reset.txt
@@ -0,0 +1,50 @@
+MediaTek SoC Reset Controller
+======================================
+The reset controller driver accesses registers through the syscon regmap. It
+is a child node of syscon.
+
+Required properties:
+- compatible : "mediatek,reset"
+- #reset-cells: 1
+- reg: The register region can be accessed from syscon. The first parameter is
+  reset base address offset. The second parameter is byte width of reset registers.
+
+example:
+infracfg: syscon@10001000 {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	compatible = "mediatek,mt8135-infracfg", "syscon";
+	reg = <0 0x10001000 0 0x1000>;
+
+	infrarst: reset-controller@30 {
+		#reset-cells = <1>;
+		compatible = "mediatek,mt8135-infracfg-reset", "mediatek,reset";
+		reg = <0x30 0x8>;
+	};
+};
+
+Specifying reset lines connected to IP modules
+==============================================
+
+The reset controller(mtk-reset) manages various reset sources. Those device nodes should
+specify the reset line on the rstc in their resets property, containing a phandle to the
+rstc device node and a RESET_INDEX specifying which module to reset, as described in
+reset.txt.
+
+For MediaTek SoC, RESET_INDEX is reset bit defined in INFRACFG or PERICFG registers.
+
+example:
+pwrap: pwrap@1000f000 {
+	compatible = "mediatek,mt8135-pwrap";
+	reg = <0 0x1000f000 0 0x1000>,
+		<0 0x11017000 0 0x1000>;
+	reg-names = "pwrap-base",
+		"pwrap-bridge-base";
+	resets = <&infrarst MT8135_INFRA_PMIC_WRAP_RST>,
+		<&perirst MT8135_PERI_PWRAP_BRIDGE_SW_RST>;
+	reset-names = "infrarst", "perirst";
+};
+
+Definitions for the supported resets by IC:
+MT8135:
+include/dt-bindings/reset-controller/mt8135-resets.h
-- 
1.8.1.1.dirty

