Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbaJHAHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 20:07:17 -0400
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:49546 "HELO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755533AbaJHAGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 20:06:50 -0400
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, jassisingbrar@gmail.com, =devicetree@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH 2/6] Documentation: mailbox: Add APM X-Gene SLIMpro mailbox dts documentation
Date: Tue,  7 Oct 2014 17:06:45 -0700
Message-Id: <1412726809-7525-3-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412726809-7525-1-git-send-email-fkan@apm.com>
References: <1412726809-7525-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the APM X-Gene SLIMpro mailbox device tree node documentation.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 .../bindings/mailbox/xgene-slimpro-mailbox.txt     | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mailbox/xgene-slimpro-mailbox.txt

diff --git a/Documentation/devicetree/bindings/mailbox/xgene-slimpro-mailbox.txt b/Documentation/devicetree/bindings/mailbox/xgene-slimpro-mailbox.txt
new file mode 100644
index 0000000..d0b74fb
--- /dev/null
+++ b/Documentation/devicetree/bindings/mailbox/xgene-slimpro-mailbox.txt
@@ -0,0 +1,41 @@
+The APM X-Gene SLIMpro mailbox driver is used to communicate messages between
+the ARM64 processors and the Cortex M3 (dubbed SLIMpro). It uses a simple
+interrupt based door bell mechanism and can exchange simple messages using the
+internal registers.
+
+There are total of 8 interrupts in this mailbox. Each used for an individual
+door bell (or mailbox channel).
+
+Required properties:
+- compatible:	Should be as "apm, xgene-slimpro-mbox".
+
+- reg:		Contain the mailbox register address range.
+
+- interrupts:	Contain interrupt information for the mailbox device.
+
+- #mbox-cells:	Specify the number of parameters used by the mailbox client.
+		Currently only one to specify the mailbox channel number.
+
+Example:
+
+Mailbox Node:
+		slimpro-mbox: slimpro-mbox@10540000 {
+			compatible = "apm,xgene-slimpro-mbox";
+			reg = <0x0 0x10540000 0x0 0xa000>;
+			#mbox-cells = <1>;
+			interrupts =  	<0x0 0x0 0x4>,
+					<0x0 0x1 0x4>,
+					<0x0 0x2 0x4>,
+					<0x0 0x3 0x4>,
+					<0x0 0x4 0x4>,
+					<0x0 0x5 0x4>,
+					<0x0 0x6 0x4>,
+					<0x0 0x7 0x4>;
+		};
+
+Client Node:
+		i2c-slimpro {
+			compatible = "apm,xgene-slimpro-i2c";
+			mbox = <&slimpro-mbox 0>;
+			mbox-names = "i2c-slimpro";
+		};
-- 
1.9.1

