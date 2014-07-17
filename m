Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbaGQU5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 16:57:09 -0400
Received: from exprod5og121.obsmtp.com ([64.18.0.139]:43177 "HELO
	exprod5og121.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756546AbaGQU5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 16:57:05 -0400
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, jaswinder.singh@linaro.org, =devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH 2/3] Documentation: mailbox: Add APM X-Gene SlimPro mailbox dts documentation
Date: Thu, 17 Jul 2014 13:57:24 -0700
Message-Id: <1405630645-15337-3-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405630645-15337-1-git-send-email-fkan@apm.com>
References: <1405630645-15337-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the APM X-Gene Slimpro mailbox device tree node documentation.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 .../bindings/mailbox/xgene-slimpro-mailbox.txt     | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mailbox/xgene-slimpro-mailbox.txt

diff --git a/Documentation/devicetree/bindings/mailbox/xgene-slimpro-mailbox.txt b/Documentation/devicetree/bindings/mailbox/xgene-slimpro-mailbox.txt
new file mode 100644
index 0000000..43e14393
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
+		mailbox: slimpro-mailbox@10540000 {
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
+		i2cslimpro {
+			compatible = "apm,xgene-slimpro-i2c";
+			mbox = <&mailbox 0>;
+			mbox-names = "i2c-slimpro";
+		};
-- 
1.9.1

