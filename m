Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760711Ab3JPLAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:00:19 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:33521 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760658Ab3JPLAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:00:14 -0400
From: Robert Richter <rric@kernel.org>
To: linux-edac@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH 2/5] ARM: dts: calxeda: move memory-controller node out of ecx-common.dtsi
Date: Wed, 16 Oct 2013 12:59:35 +0200
Message-Id: <1381921178-28511-3-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381921178-28511-1-git-send-email-rric@kernel.org>
References: <1381921178-28511-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

The DDR controller is slightly different in ECX-2000 and ECX-1000, so we
need to have different nodes for each platform.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
[Device Tree documentation updated.]
Signed-off-by: Robert Richter <rric@kernel.org>
---
 Documentation/devicetree/bindings/arm/calxeda/mem-ctrlr.txt | 4 +++-
 arch/arm/boot/dts/ecx-2000.dts                              | 6 ++++++
 arch/arm/boot/dts/ecx-common.dtsi                           | 6 ------
 arch/arm/boot/dts/highbank.dts                              | 6 ++++++
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/calxeda/mem-ctrlr.txt b/Documentation/devicetree/bindings/arm/calxeda/mem-ctrlr.txt
index f770ac0..0496759 100644
--- a/Documentation/devicetree/bindings/arm/calxeda/mem-ctrlr.txt
+++ b/Documentation/devicetree/bindings/arm/calxeda/mem-ctrlr.txt
@@ -1,7 +1,9 @@
 Calxeda DDR memory controller
 
 Properties:
-- compatible : Should be "calxeda,hb-ddr-ctrl"
+- compatible : Should be:
+  - "calxeda,hb-ddr-ctrl" for ECX-1000
+  - "calxeda,ecx-2000-ddr-ctrl" for ECX-2000
 - reg : Address and size for DDR controller registers.
 - interrupts : Interrupt for DDR controller.
 
diff --git a/arch/arm/boot/dts/ecx-2000.dts b/arch/arm/boot/dts/ecx-2000.dts
index 139b40c..2ccbb57f 100644
--- a/arch/arm/boot/dts/ecx-2000.dts
+++ b/arch/arm/boot/dts/ecx-2000.dts
@@ -85,6 +85,12 @@
 				<1 10 0xf08>;
 		};
 
+		memory-controller@fff00000 {
+			compatible = "calxeda,ecx-2000-ddr-ctrl";
+			reg = <0xfff00000 0x1000>;
+			interrupts = <0 91 4>;
+		};
+
 		intc: interrupt-controller@fff11000 {
 			compatible = "arm,cortex-a15-gic";
 			#interrupt-cells = <3>;
diff --git a/arch/arm/boot/dts/ecx-common.dtsi b/arch/arm/boot/dts/ecx-common.dtsi
index e8559b7..f95988f 100644
--- a/arch/arm/boot/dts/ecx-common.dtsi
+++ b/arch/arm/boot/dts/ecx-common.dtsi
@@ -45,12 +45,6 @@
 			status = "disabled";
 		};
 
-		memory-controller@fff00000 {
-			compatible = "calxeda,hb-ddr-ctrl";
-			reg = <0xfff00000 0x1000>;
-			interrupts = <0 91 4>;
-		};
-
 		ipc@fff20000 {
 			compatible = "arm,pl320", "arm,primecell";
 			reg = <0xfff20000 0x1000>;
diff --git a/arch/arm/boot/dts/highbank.dts b/arch/arm/boot/dts/highbank.dts
index 6aad34a..ed14aea 100644
--- a/arch/arm/boot/dts/highbank.dts
+++ b/arch/arm/boot/dts/highbank.dts
@@ -86,6 +86,12 @@
 	soc {
 		ranges = <0x00000000 0x00000000 0xffffffff>;
 
+		memory-controller@fff00000 {
+			compatible = "calxeda,hb-ddr-ctrl";
+			reg = <0xfff00000 0x1000>;
+			interrupts = <0 91 4>;
+		};
+
 		timer@fff10600 {
 			compatible = "arm,cortex-a9-twd-timer";
 			reg = <0xfff10600 0x20>;
-- 
1.8.4.rc3

