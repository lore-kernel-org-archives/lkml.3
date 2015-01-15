Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634AbbAOIER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:04:17 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:50696 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbbAOIEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:04:16 -0500
From: Stefan Agner <stefan@agner.ch>
To: tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com
Cc: u.kleine-koenig@pengutronix.de, shawn.guo@linaro.org,
        kernel@pengutronix.de, arnd@arndb.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stefan@agner.ch
Subject: [PATCH RESEND v3 2/3] irqchip: vf610-mscm: dt-bindings: add MSCM bindings
Date: Thu, 15 Jan 2015 09:04:05 +0100
Message-Id: <1421309046-22452-3-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421309046-22452-1-git-send-email-stefan@agner.ch>
References: <1421309046-22452-1-git-send-email-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding documentation for Miscellaneous System Control Module
found in Freescale Vybrid SoC's.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 .../bindings/arm/freescale/fsl,vf610-mscm.txt         | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/freescale/fsl,vf610-mscm.txt

diff --git a/Documentation/devicetree/bindings/arm/freescale/fsl,vf610-mscm.txt b/Documentation/devicetree/bindings/arm/freescale/fsl,vf610-mscm.txt
new file mode 100644
index 0000000..e051b88
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/freescale/fsl,vf610-mscm.txt
@@ -0,0 +1,19 @@
+Freescale Vybrid Miscellaneous System Control Module
+
+The MSCM IP contains Access Control and TrustZone Security hardware,
+CPU Configuration registers and Interrupt Router control.
+
+Required properties:
+- compatible : "fsl,vf610-mscm", "syscon"
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Two cells, interrupt number and flags (IRQ type)
+- reg : the register range of the MSCM module
+
+Example:
+	mscm: mscm@40001000 {
+		compatible = "fsl,vf610-mscm", "syscon";
+		interrupt-controller;
+		#interrupt-cells = <2>;
+		interrupt-parent = <&intc>;
+		reg = <0x40001000 0x1000>;
+	}
-- 
2.2.1

