Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3H1TIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:08:30 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48476 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab3H1TI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:08:28 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, gregkh@linuxfoundation.org
Cc: Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        fabio.estevam@freescale.com, s.hauer@pengutronix.de,
        shawn.guo@linaro.org
Subject: [PATCH 1/2] serial: fsl-imx-uart: Cleanup duplicate device tree binding
Date: Wed, 28 Aug 2013 14:08:22 -0500
Message-Id: <1377716903-19699-1-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had two bindings for the same serial device, it looks like the one in
tty/serial/fsl-imx-uart.txt is the more up to date one so go with it and
merge a few things about the use/need for aliases in from
serial/fsl-imx-uart.txt.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 .../devicetree/bindings/serial/fsl-imx-uart.txt    | 35 ----------------------
 .../bindings/tty/serial/fsl-imx-uart.txt           |  9 +++++-
 2 files changed, 8 insertions(+), 36 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/serial/fsl-imx-uart.txt

diff --git a/Documentation/devicetree/bindings/serial/fsl-imx-uart.txt b/Documentation/devicetree/bindings/serial/fsl-imx-uart.txt
deleted file mode 100644
index c58573b..0000000
--- a/Documentation/devicetree/bindings/serial/fsl-imx-uart.txt
+++ /dev/null
@@ -1,35 +0,0 @@
-* Freescale i.MX UART controller
-
-Required properties:
-- compatible : should be "fsl,imx21-uart"
-- reg : Address and length of the register set for the device
-- interrupts : Should contain UART interrupt number
-
-Optional properties:
-- fsl,uart-has-rtscts: indicate that RTS/CTS signals are used
-
-Note: Each uart controller should have an alias correctly numbered
-in "aliases" node.
-
-Example:
-
-- From imx51.dtsi:
-aliases {
-	serial0 = &uart1;
-	serial1 = &uart2;
-	serial2 = &uart3;
-};
-
-uart1: serial@73fbc000 {
-	compatible = "fsl,imx51-uart", "fsl,imx21-uart";
-	reg = <0x73fbc000 0x4000>;
-	interrupts = <31>;
-	status = "disabled";
-}
-
-- From imx51-babbage.dts:
-uart1: serial@73fbc000 {
-	fsl,uart-has-rtscts;
-	status = "okay";
-};
-
diff --git a/Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt b/Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt
index c662eb3..35ae1fb 100644
--- a/Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt
+++ b/Documentation/devicetree/bindings/tty/serial/fsl-imx-uart.txt
@@ -11,9 +11,16 @@ Optional properties:
 - fsl,dte-mode : Indicate the uart works in DTE mode. The uart works
                   is DCE mode by default.
 
+Note: Each uart controller should have an alias correctly numbered
+in "aliases" node.
+
 Example:
 
-serial@73fbc000 {
+aliases {
+	serial0 = &uart1;
+};
+
+uart1: serial@73fbc000 {
 	compatible = "fsl,imx51-uart", "fsl,imx21-uart";
 	reg = <0x73fbc000 0x4000>;
 	interrupts = <31>;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

