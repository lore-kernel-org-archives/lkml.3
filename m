Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaCCOvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:51:15 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:41333 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775AbaCCOvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:51:11 -0500
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <linux@arm.linux.org.uk>, <akpm@linux-foundation.org>, <nm@ti.com>,
        <balajitk@ti.com>, <r.sricharan@ti.com>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [RESEND Patch 4/9] ARM: dts: OMAP36xx: Add device node for ABB
Date: Mon, 3 Mar 2014 20:20:21 +0530
Message-ID: <1393858226-32595-6-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393858226-32595-1-git-send-email-mugunthanvnm@ti.com>
References: <1393858226-32595-1-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Andrii.Tseglytskyi" <andrii.tseglytskyi@ti.com>

Add ABB device node for OMAP36xx family of devices. Data is based on
OMAP36XX Technical Reference Manual revision AB (Dec 2012).

[nm@ti.com: co-developer]
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Andrii.Tseglytskyi <andrii.tseglytskyi@ti.com>
Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 arch/arm/boot/dts/omap36xx.dtsi | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/omap36xx.dtsi b/arch/arm/boot/dts/omap36xx.dtsi
index 7e8dee9..ba077cd 100644
--- a/arch/arm/boot/dts/omap36xx.dtsi
+++ b/arch/arm/boot/dts/omap36xx.dtsi
@@ -39,6 +39,26 @@
 			clock-frequency = <48000000>;
 		};
 
+		abb_mpu_iva: regulator-abb-mpu {
+			compatible = "ti,abb-v1";
+			regulator-name = "abb_mpu_iva";
+			#address-cell = <0>;
+			#size-cells = <0>;
+			reg = <0x483072f0 0x8>, <0x48306818 0x4>;
+			reg-names = "base-address", "int-address";
+			ti,tranxdone-status-mask = <0x4000000>;
+			clocks = <&sys_ck>;
+			ti,settling-time = <30>;
+			ti,clock-cycles = <8>;
+			ti,abb_info = <
+			/*uV		ABB	efuse	rbb_m	fbb_m	vset_m*/
+			1012500		0	0	0	0	0
+			1200000		0	0	0	0	0
+			1325000		0	0	0	0	0
+			1375000		1	0	0	0	0
+			>;
+		};
+
 		omap3_pmx_core2: pinmux@480025a0 {
 			compatible = "ti,omap3-padconf", "pinctrl-single";
 			reg = <0x480025a0 0x5c>;
-- 
1.9.0

