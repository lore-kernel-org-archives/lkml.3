Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaD2DDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 23:03:36 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:41268
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752048AbaD2DDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 23:03:32 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>, <shawn.guo@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>,
        Jingchang Lu <b35083@freescale.com>
Subject: [PATCHv3 1/3] clocksource: ftm: Add FlexTimer Module (FTM) Timer devicetree Documentation
Date: Tue, 29 Apr 2014 10:18:57 +0800
Message-ID: <1398737939-5334-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1398737939-5334-1-git-send-email-Li.Xiubo@freescale.com>
References: <1398737939-5334-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(81542001)(83072002)(50986999)(31966008)(20776003)(81342001)(77982001)(80976001)(86362001)(101416001)(36756003)(74502001)(47776003)(76176999)(62966002)(87936001)(48376002)(46102001)(44976005)(80022001)(50226001)(83322001)(19580395003)(77096999)(6806004)(85852003)(88136002)(92726001)(4396001)(99396002)(77156001)(93916002)(92566001)(76482001)(50466002)(87286001)(79102001)(19580405001)(89996001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:tx30smr01.am.freescale.net;FPR:FA21FBFE.2D14D461.AF99F33.80DEF24B.2024A;MLV:sfv;PTR:gate-tx3.freescale.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0196A226D1
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FTM binding could be used on Vybrid and LS1+, add a binding
document for it.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Jingchang Lu <b35083@freescale.com>
---
 .../devicetree/bindings/timer/fsl,ftm-timer.txt    | 31 ++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/fsl,ftm-timer.txt

diff --git a/Documentation/devicetree/bindings/timer/fsl,ftm-timer.txt b/Documentation/devicetree/bindings/timer/fsl,ftm-timer.txt
new file mode 100644
index 0000000..aa8c402
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/fsl,ftm-timer.txt
@@ -0,0 +1,31 @@
+Freescale FlexTimer Module (FTM) Timer
+
+Required properties:
+
+- compatible : should be "fsl,ftm-timer"
+- reg : Specifies base physical address and size of the register sets for the
+  clock event device and clock source device.
+- interrupts : Should be the clock event device interrupt.
+- clocks : The clocks provided by the SoC to drive the timer, must contain an
+  entry for each entry in clock-names.
+- clock-names : Must include the following entries:
+  o "ftm-evt"
+  o "ftm-src"
+  o "ftm-evt-counter-en"
+  o "ftm-src-counter-en"
+- big-endian: One boolean property, the big endian mode will be in use if it is
+  present, or the little endian mode will be in use for all the device registers.
+
+Example:
+ftm: ftm@400b8000 {
+	compatible = "fsl,ftm-timer";
+	reg = <0x400b8000 0x1000 0x400b9000 0x1000>;
+	interrupts = <0 44 IRQ_TYPE_LEVEL_HIGH>;
+	clock-names = "ftm-evt", "ftm-src",
+		"ftm-evt-counter-en", "ftm-src-counter-en";
+	clocks = <&clks VF610_CLK_FTM2>,
+		<&clks VF610_CLK_FTM3>,
+		<&clks VF610_CLK_FTM2_EXT_FIX_EN>,
+		<&clks VF610_CLK_FTM3_EXT_FIX_EN>;
+	big-endian;
+};
-- 
1.8.4

