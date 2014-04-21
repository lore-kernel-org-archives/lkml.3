Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaDUIHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 04:07:48 -0400
Received: from [207.46.163.207] ([207.46.163.207]:20640 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751753AbaDUIHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 04:07:04 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>, <shawn.guo@linaro.org>,
        <R64188@freescale.com>, <b40534@freescale.com>, <b35083@freescale.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 2/3] ARM: dts: vf610: Add Freescale FlexTimer Module timer node.
Date: Mon, 21 Apr 2014 15:23:02 +0800
Message-ID: <1398064983-440-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1398064983-440-1-git-send-email-Li.Xiubo@freescale.com>
References: <1398064983-440-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(77156001)(92566001)(2201001)(48376002)(86362001)(31966008)(74502001)(36756003)(74662001)(4396001)(50226001)(81342001)(79102001)(87286001)(92726001)(81542001)(80976001)(77982001)(50466002)(80022001)(19580395003)(83322001)(46102001)(87936001)(77096999)(47776003)(99396002)(83072002)(85852003)(76176999)(50986999)(44976005)(19580405001)(6806004)(76482001)(20776003)(89996001)(62966002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB190;H:az84smr01.freescale.net;FPR:FB9FEB7E.3CB48CE1.2EFCCBA7.9C5A921E.20143;MLV:sfv;PTR:gate-az5.freescale.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0188D66E61
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Jingchang Lu <b35083@freescale.com>
---
 arch/arm/boot/dts/vf610.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 107e2c0..7e30bb1 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -281,6 +281,18 @@
 				status = "disabled";
 			};
 
+			ftm: ftm@400b8000 {
+				compatible = "fsl,ftm-timer";
+				reg = <0x400b8000 0x1000 0x400b9000 0x1000>;
+				interrupts = <0 44 IRQ_TYPE_LEVEL_HIGH>;
+				clock-names = "ftm-evt", "ftm-src",
+					"ftm-evt-counter-en", "ftm-src-counter-en";
+				clocks = <&clks VF610_CLK_FTM2>,
+					<&clks VF610_CLK_FTM3>,
+					<&clks VF610_CLK_FTM2_EXT_FIX_EN>,
+					<&clks VF610_CLK_FTM3_EXT_FIX_EN>;
+			};
+
 			fec0: ethernet@400d0000 {
 				compatible = "fsl,mvf600-fec";
 				reg = <0x400d0000 0x1000>;
-- 
1.8.4

