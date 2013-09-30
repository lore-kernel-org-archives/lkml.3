Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab3I3Oks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:40:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41514 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab3I3Okr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:40:47 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Joel Fernandes <joelf@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Koen Kooi <koen@dominion.thruhere.net>
Subject: [PATCH V2] ARM: dts: am335x-boneblack: move fixed regulator to board level
Date: Mon, 30 Sep 2013 09:40:16 -0500
Message-ID: <1380552016-23904-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3V fixed regulator does not belong to TPS node - as a result
the fixed regulator is never probed and MMC is continually deferred due
to lack of regulator.

Move the fixed regulator to be at root of platform.

Cc: Joel Fernandes <joelf@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Koen Kooi <koen@dominion.thruhere.net>

Signed-off-by: Nishanth Menon <nm@ti.com>
Tested-by: Felipe Balbi <balbi@ti.com>
Tested-by: Balaji T K <balajitk@ti.com>
---
V2: no changes - just rebase (carry forward of tested-bys)
V1: https://patchwork.kernel.org/patch/2912711/

Based on: (benoit's for_3.13/dts branch
Commit 45646cda707f13fe4a462bf3148f5178f817ef58)
https://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.13/dts
 +
https://patchwork.kernel.org/patch/2902711/

Test Log:
Before: http://pastebin.com/jAabNAcS
After: http://pastebin.com/pDZJKSvW
 arch/arm/boot/dts/am335x-bone-common.dtsi |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
index ff5c3ca..b3e6fcf 100644
--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -55,6 +55,13 @@
 			default-state = "off";
 		};
 	};
+
+	vmmcsd_fixed: fixedregulator@0 {
+		compatible = "regulator-fixed";
+		regulator-name = "vmmcsd_fixed";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+	};
 };
 
 &am33xx_pinmux {
@@ -257,13 +264,6 @@
 			regulator-always-on;
 		};
 	};
-
-	vmmcsd_fixed: fixedregulator@0 {
-		compatible = "regulator-fixed";
-		regulator-name = "vmmcsd_fixed";
-		regulator-min-microvolt = <3300000>;
-		regulator-max-microvolt = <3300000>;
-	};
 };
 
 &cpsw_emac0 {
-- 
1.7.9.5

