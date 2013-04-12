Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126Ab3DLW4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:56:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59683 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272Ab3DLWzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:55:08 -0400
From: Nishanth Menon <nm@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Mike Turquette <mturquette@linaro.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V4 3/6] ARM: dts: OMAP4: add clock nodes for CPU
Date: Fri, 12 Apr 2013 17:54:35 -0500
Message-ID: <1365807278-554-4-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365807278-554-1-git-send-email-nm@ti.com>
References: <1365807278-554-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP443x, OMAP446x and OMAP447x platforms use dpll_mpu clock.
Add same to common definition.

Cc: Benoit Cousson <b-cousson@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
RFC of this patch approach for OMAP3 was discussed in http://marc.info/?t=136370325600009&r=1&w=2
along with the detailed context as to why this is an intermediate step.

previous revisions of cpufreq-cpu0 support do not use this approach.
[Probably belongs to Benoit's tree]

 arch/arm/boot/dts/omap4.dtsi |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 2a56428..1c6d969 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -31,6 +31,8 @@
 		cpu@0 {
 			compatible = "arm,cortex-a9";
 			next-level-cache = <&L2>;
+			clocks = <&dpll_mpu>;
+			clock-names = "cpu";
 		};
 		cpu@1 {
 			compatible = "arm,cortex-a9";
@@ -106,6 +108,11 @@
 			ti,hwmods = "counter_32k";
 		};
 
+		dpll_mpu: dpll_mpu {
+			#clock-cells = <0>;
+			compatible = "ti,omap-clock";
+		};
+
 		omap4_pmx_core: pinmux@4a100040 {
 			compatible = "ti,omap4-padconf", "pinctrl-single";
 			reg = <0x4a100040 0x0196>;
-- 
1.7.9.5

