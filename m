Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaBRXEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:04:13 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:56946 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaBRWrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:01 -0500
From: Max Filippov <jcmvbkbc@gmail.com>
To: netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robherring2@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH v2] net: ethoc: document OF bindings
Date: Wed, 19 Feb 2014 02:46:50 +0400
Message-Id: <1392763610-19197-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
Changes v1->v2:
- drop local-mac-address optional property description
  (described in the common ethernet.txt);
- drop optional properties for MDIO bus frequency and MAC frequency
  (removed from the implementation);
- add clocks property.

 .../devicetree/bindings/net/opencores-ethoc.txt    | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/opencores-ethoc.txt

diff --git a/Documentation/devicetree/bindings/net/opencores-ethoc.txt b/Documentation/devicetree/bindings/net/opencores-ethoc.txt
new file mode 100644
index 0000000..41e2675
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/opencores-ethoc.txt
@@ -0,0 +1,22 @@
+* OpenCores MAC 10/100 Mbps
+
+Required properties:
+- compatible: Should be "opencores,ethoc".
+- reg: two memory regions (address and length),
+  first region is for the device registers and descriptor rings,
+  second is for the device packet memory.
+- interrupts: interrupt for the device.
+
+Optional properties:
+- clocks: phandle to refer to the clk used as per
+  Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Examples:
+
+	enet0: ethoc@fd030000 {
+		compatible = "opencores,ethoc";
+		reg = <0xfd030000 0x4000 0xfd800000 0x4000>;
+		interrupts = <1>;
+		local-mac-address = [00 50 c2 13 6f 00];
+		clocks = <&osc>;
+        };
-- 
1.8.1.4

