Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620AbaDUIEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 04:04:45 -0400
Received: from [207.46.163.210] ([207.46.163.210]:17025 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751477AbaDUIEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 04:04:23 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>, <shawn.guo@linaro.org>,
        <R64188@freescale.com>, <b40534@freescale.com>, <b35083@freescale.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 2/3] ARM: dts: vf610: Add Freescale FlexTimer Module timer node.
Date: Mon, 21 Apr 2014 15:19:59 +0800
Message-ID: <1398064800-27250-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1398064800-27250-1-git-send-email-Li.Xiubo@freescale.com>
References: <1398064800-27250-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(46102001)(77096999)(48376002)(81342001)(86362001)(36756003)(92726001)(62966002)(81542001)(77156001)(50466002)(19580405001)(77982001)(83322001)(44976005)(85852003)(6806004)(4396001)(74662001)(31966008)(50226001)(74502001)(50986999)(76176999)(87286001)(87936001)(83072002)(19580395003)(80976001)(99396002)(89996001)(2201001)(79102001)(92566001)(20776003)(47776003)(80022001)(76482001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB384;H:az84smr01.freescale.net;FPR:FB9FEB7E.3CB48CE1.2EFCCBA7.9C5A921E.20143;MLV:sfv;PTR:gate-az5.freescale.com;MX:1;A:1;LANG:en;
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

