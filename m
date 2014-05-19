Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaESKXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:23:50 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:44699
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753805AbaESKXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:23:47 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>, <shawn.guo@linaro.org>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Xiubo Li <Li.Xiubo@freescale.com>, Jingchang Lu <b35083@freescale.com>
Subject: [PATCHv4 2/3] ARM: dts: vf610: Add Freescale FlexTimer Module timer node.
Date: Mon, 19 May 2014 17:36:07 +0800
Message-ID: <1400492168-12813-3-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1400492168-12813-1-git-send-email-Li.Xiubo@freescale.com>
References: <1400492168-12813-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(50466002)(80022001)(64706001)(69596002)(84676001)(20776003)(79102001)(92566001)(102836001)(83322001)(48376002)(50226001)(19580395003)(85852003)(83072002)(6806004)(89996001)(68736004)(44976005)(77982001)(74662001)(87936001)(81156002)(47776003)(19580405001)(4396001)(36756003)(76176999)(50986999)(62966002)(97736001)(87286001)(81342001)(99396002)(81542001)(21056001)(74502001)(76482001)(86362001)(31966008)(2201001)(88136002)(46102001)(77156001)(77096999)(93916002)(92726001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB476;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 021670B4D2
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Jingchang Lu <b35083@freescale.com>
---
 arch/arm/boot/dts/vf610.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
index 107e2c0..6ab65fa 100644
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@ -281,6 +281,19 @@
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
+				status = "disabled";
+			};
+
 			fec0: ethernet@400d0000 {
 				compatible = "fsl,mvf600-fec";
 				reg = <0x400d0000 0x1000>;
-- 
1.8.4

