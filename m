Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbbAXPF4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 10:05:56 -0500
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:34241 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbbAXPFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 10:05:54 -0500
X-ME-Helo: beldin.home
X-ME-Date: Sat, 24 Jan 2015 16:05:53 +0100
X-ME-IP: 109.222.126.211
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [PATCH v4 1/4] dt-bindings: mfd: add lubbock-cplds binding
Date: Sat, 24 Jan 2015 16:05:00 +0100
Message-Id: <1422111903-22176-1-git-send-email-robert.jarzmik@free.fr>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a binding for lubbock motherboard IO board.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
Since v3: name change to lubbock-cplds,
          Lee's comments taken into account.
---
 .../devicetree/bindings/mfd/lubbock-cplds.txt      | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/lubbock-cplds.txt

diff --git a/Documentation/devicetree/bindings/mfd/lubbock-cplds.txt b/Documentation/devicetree/bindings/mfd/lubbock-cplds.txt
new file mode 100644
index 0000000..211ed9a
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/lubbock-cplds.txt
@@ -0,0 +1,26 @@
+Intel XScale PXA255 development platform (Lubbock).
+
+This regroups all the CPLDs on the Lubbock motherboard, providing interrupt
+muxing, leds handling, ...
+
+Required properties:
+  - compatible : should be "intel,lubbock-cplds"
+
+  - interrupts : The first interrupt is the SoC input interrupt connected to the
+                 lubbock IO board interrupt multiplexer output. The only known
+                 working conifguration is GPIO0 on the PXA25X SoC.
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
+	compatible = "intel,lubbock-cplds";
+	interrupts = <0 IRQ_TYPE_EDGE_FALLING 400 IRQ_TYPE_NONE>;
+	#interrupt-cells = <2>;
+	interrupt-parent = <&pxairq>;
+};
-- 
2.1.0

