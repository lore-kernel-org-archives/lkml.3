Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3K0AXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:23:37 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:49143 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3K0AXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:23:32 -0500
From: Marc Carino <marc.ceeeee@gmail.com>
To: Russell King <linux@arm.linux.org.uk>, Christian Daudt <bcm@fixthebug.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marc Carino <marc.ceeeee@gmail.com>
Subject: [PATCH v2 4/6] ARM: brcmstb: add misc. DT bindings for brcm,brcmstb
Date: Tue, 26 Nov 2013 16:22:26 -0800
Message-Id: <1385511748-27869-5-git-send-email-marc.ceeeee@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1385511748-27869-1-git-send-email-marc.ceeeee@gmail.com>
References: <1385511748-27869-1-git-send-email-marc.ceeeee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document the bindings that the Broadcom STB platform needs
for proper bootup.

Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../devicetree/bindings/arm/brcm-brcmstb.txt       |   72 ++++++++++++++++++++
 1 files changed, 72 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/arm/brcm-brcmstb.txt

diff --git a/Documentation/devicetree/bindings/arm/brcm-brcmstb.txt b/Documentation/devicetree/bindings/arm/brcm-brcmstb.txt
new file mode 100644
index 0000000..2f3cd50
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/brcm-brcmstb.txt
@@ -0,0 +1,72 @@
+Broadcom STB platforms Device Tree Bindings
+-------------------------------------------
+Boards with Broadcom Brahma15-based BCM7xxx SOC shall have the following
+properties.
+
+Required root node properties:
+    - compatible = "brcm,brcmstb";
+
+Further, the following platform nodes shall be defined:
+
+    - sun-top-ctrl
+    - cpu-biu-ctrl
+    - hif-continuation
+
+sun-top-ctrl
+------------
+This node describes the register block which is used for generic reset control.
+
+    - compatible: "brcm,brcmstb-sun-top-ctrl"
+    - properties:
+        o reg = <base_of_sun_top_ctrl_regs length>;
+        o reset-source-enable-reg = <offset_from_base>;
+        o sw-master-reset-reg = <offset_from_base>;
+
+cpu-biu-ctrl
+------------
+This node describes the register block used for configuring the CPU complex.
+
+    - compatible: "brcm,brcmstb-cpu-biu-ctrl"
+    - properties:
+        o reg = <base_of_cpu_biu_ctrl_regs length>;
+        o cpu-reset-config-reg = <offset_from_base>;
+        o cpu0-pwr-zone-ctrl-reg = <offset_from_base>;
+
+hif-continuation
+----------------
+This node describes the registers for setting the starting PC for each CPU core.
+
+    - compatible: "brcm,brcmstb-hif-continuation"
+    - properties:
+        o reg = <base_of_hif_continuation_regs length>;
+        o stb-boot-hi-addr0-reg = <offset_from_base>;
+
+example:
+
+/ {
+	model = "Broadcom STB";
+	compatible =  "brcm,brcmstb";
+
+	/* snip */
+
+	sun-top-ctrl@f0404000 {
+		compatible = "brcm,brcmstb-sun-top-ctrl";
+		reg = <0xf0404000 0x51c>;
+		reset-source-enable-reg = <0x304>;
+		sw-master-reset-reg = <0x308>;
+	};
+
+	cpu-biu-ctrl@f0442400 {
+		compatible = "brcm,brcmstb-cpu-biu-ctrl";
+		reg = <0xf0442400 0x5b4>;
+		cpu-reset-config-reg = <0x178>;
+		cpu0-pwr-zone-ctrl-reg = <0x88>;
+	};
+
+	hif-continuation@f0452000 {
+		compatible = "brcm,brcmstb-hif-continuation";
+		reg = <0xf0452000 0x100>;
+	};
+
+	/* snip */
+};
-- 
1.7.1

