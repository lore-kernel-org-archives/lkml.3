Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbbAPLAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:00:35 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:53327 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbbAPLAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:00:33 -0500
X-ME-Helo: beldin.home
X-ME-Date: Fri, 16 Jan 2015 12:00:31 +0100
X-ME-IP: 109.214.23.205
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 1/3] dt-bindings: mfd: add lubbock-io binding
Date: Fri, 16 Jan 2015 12:00:08 +0100
Message-Id: <1421406010-14851-1-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a binding for lubbock motherboard IO board.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 .../devicetree/bindings/mfd/lubbock-io.txt         | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/lubbock-io.txt

diff --git a/Documentation/devicetree/bindings/mfd/lubbock-io.txt b/Documentation/devicetree/bindings/mfd/lubbock-io.txt
new file mode 100644
index 0000000..33c9e21
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/lubbock-io.txt
@@ -0,0 +1,26 @@
+Intel's pxa255 system development platform motherboard.
+
+This is the motherboard, or IO board, of the pxa25x development system,
+supporting a lubbock pxa25x SoC board.
+
+Required properties:
+  - compatible : One of the following chip-specific strings:
+        "intel,lubbock-io"
+  - interrupts : The first interrupt is the line the /IRQ signal the IO board
+                 multiplex is connected to. The only known case is GPIO0 on the
+                 pxa25x SoC.
+
+Optional properties:
+  - interrupts : The second optional interrupt is the base of the interrupts
+                 multiplexed by the lubbock motherboard. If unspecified, the
+                 range is fully dynamic, and the irqdomain will generate its
+                 interrupt base on the fly.
+
+Example:
+
+mb: lubbock-mb@0 {
+	compatible = "intel,lubbock-io";
+	interrupts = <0 IRQ_TYPE_EDGE_FALLING 400 IRQ_TYPE_NONE>;
+	#interrupt-cells = <2>;
+        interrupt-parent = <&pxairq>;
+};
-- 
2.1.0

