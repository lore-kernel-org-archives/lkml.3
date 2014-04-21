Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaDUIHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 04:07:05 -0400
Received: from [207.46.163.183] ([207.46.163.183]:3796 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750774AbaDUIG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 04:06:56 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>, <shawn.guo@linaro.org>,
        <R64188@freescale.com>, <b40534@freescale.com>, <b35083@freescale.com>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 1/3] clocksource: ftm: Add FlexTimer Module (FTM) Timer devicetree Documentation
Date: Mon, 21 Apr 2014 15:23:01 +0800
Message-ID: <1398064983-440-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1398064983-440-1-git-send-email-Li.Xiubo@freescale.com>
References: <1398064983-440-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.246;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(979002)(6009001)(428001)(199002)(189002)(85852003)(79102001)(93916002)(86362001)(83072002)(77982001)(50466002)(74502001)(81542001)(87286001)(80022001)(47776003)(20776003)(89996001)(92726001)(36756003)(62966002)(2201001)(92566001)(31966008)(81342001)(74662001)(48376002)(87936001)(19580395003)(80976001)(44976005)(83322001)(76482001)(46102001)(76176999)(50986999)(88136002)(19580405001)(77156001)(77096999)(50226001)(4396001)(6806004)(99396002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:az84smr01.freescale.net;FPR:FA21FBFE.2D14D461.AF99F33.80DEF24B.2024A;MLV:ovrnspm;PTR:gate-az5.freescale.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0188D66E61
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

