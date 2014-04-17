Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaDQGmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 02:42:50 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:4170
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986AbaDQGms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 02:42:48 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh8275dh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Jingchang Lu <b35083@freescale.com>
Subject: [PATCH] clocksource: pit: Add Freescale PIT-RTI devicetree Documentation
Date: Thu, 17 Apr 2014 13:59:49 +0800
Message-ID: <1397714389-10263-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This add Freescale Periodic Interrupt Timer (PIT-RTI) devicetree
Documentation, The PIT-RTI binding has already been used on Vybrid,
so this add a binding document for it.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Jingchang Lu <b35083@freescale.com>
---
 .../devicetree/bindings/timer/fsl,vf610-pit.txt     | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/timer/fsl,vf610-pit.txt

diff --git a/Documentation/devicetree/bindings/timer/fsl,vf610-pit.txt b/Documentation/devicetree/bindings/timer/fsl,vf610-pit.txt
new file mode 100644
index 0000000..67df182
--- /dev/null
+++ b/Documentation/devicetree/bindings/timer/fsl,vf610-pit.txt
@@ -0,0 +1,21 @@
+Freescale Periodic Interrupt Timer (PIT-RTI)
+
+Required properties:
+
+- compatible : should be "fsl,vf610-pit"
+- reg : Specifies base physical address and size of the register set for the
+  clock event device and clock source device.
+- interrupts : Should be the clock event device interrupt.
+- clocks : The clocks provided by the SoC to drive the timer, must contain an
+  entry for each entry in clock-names.
+- clock-names : Must include the "pit" entry.
+
+Example:
+
+pit: pit@40037000 {
+	compatible = "fsl,vf610-pit";
+	reg = <0x40037000 0x1000>;
+	interrupts = <0 39 IRQ_TYPE_LEVEL_HIGH>;
+	clocks = <&clks VF610_CLK_PIT>;
+	clock-names = "pit";
+};
-- 
1.8.4


