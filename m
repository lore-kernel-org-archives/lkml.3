Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbaH1Uph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 16:45:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34326 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbaH1Upf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 16:45:35 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH] ARM: dts: omap4-panda: Fix model and SoC family details
Date: Thu, 28 Aug 2014 15:45:03 -0500
Message-ID: <1409258703-21188-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we claim that omap4-panda and omap4-panda-es are essentially
the same, but they are not since PandaBoard-ES uses OMAP4460 and
PandaBoard uses OMAP4430.

So, split the common definition and make the model name available.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
Based on v3.17-rc2

Testing logs: (boot test):
Before Patch(v3.17-rc2)
1: pandaboard-es:  Boot PASS: http://slexy.org/raw/s209HfpVTs
2: pandaboard-vanilla:  Boot PASS: http://slexy.org/raw/s21YNmOhQL

After Patch
1: pandaboard-es:  Boot PASS: http://slexy.org/raw/s20FH76BTn
2: pandaboard-vanilla:  Boot PASS: http://slexy.org/raw/s2vFLcfkBu

Note: 'ti,omap4-panda-es' is not documented in bindings, not entirely
sure if we should be doing the same for every board compatibility.

 arch/arm/boot/dts/omap4-panda-common.dtsi |    3 ---
 arch/arm/boot/dts/omap4-panda-es.dts      |    5 +++++
 arch/arm/boot/dts/omap4-panda.dts         |    5 +++++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index 8cfa3c8..1505135 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -8,9 +8,6 @@
 #include "elpida_ecb240abacn.dtsi"
 
 / {
-	model = "TI OMAP4 PandaBoard";
-	compatible = "ti,omap4-panda", "ti,omap4430", "ti,omap4";
-
 	memory {
 		device_type = "memory";
 		reg = <0x80000000 0x40000000>; /* 1 GB */
diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
index 816d1c9..2f1dabc 100644
--- a/arch/arm/boot/dts/omap4-panda-es.dts
+++ b/arch/arm/boot/dts/omap4-panda-es.dts
@@ -10,6 +10,11 @@
 #include "omap4460.dtsi"
 #include "omap4-panda-common.dtsi"
 
+/ {
+	model = "TI OMAP4 PandaBoard-ES";
+	compatible = "ti,omap4-panda-es", "ti,omap4-panda", "ti,omap4460", "ti,omap4430", "ti,omap4";
+};
+
 /* Audio routing is differnet between PandaBoard4430 and PandaBoardES */
 &sound {
 	ti,model = "PandaBoardES";
diff --git a/arch/arm/boot/dts/omap4-panda.dts b/arch/arm/boot/dts/omap4-panda.dts
index 6189a8b..a0e28b2 100644
--- a/arch/arm/boot/dts/omap4-panda.dts
+++ b/arch/arm/boot/dts/omap4-panda.dts
@@ -9,3 +9,8 @@
 
 #include "omap443x.dtsi"
 #include "omap4-panda-common.dtsi"
+
+/ {
+	model = "TI OMAP4 PandaBoard";
+	compatible = "ti,omap4-panda", "ti,omap4430", "ti,omap4";
+};
-- 
1.7.9.5

