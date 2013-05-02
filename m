Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761317Ab3EBRU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:20:56 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45649 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761160Ab3EBRUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:20:52 -0400
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Mike Turquette <mturquette@linaro.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Andrii.Tseglytskyi" <andrii.tseglytskyi@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH v3 4/5] ARM: dts: OMAP4460: Add device nodes for ABB
Date: Thu, 2 May 2013 12:20:13 -0500
Message-ID: <1367515215-30753-5-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367515215-30753-1-git-send-email-nm@ti.com>
References: <1367515215-30753-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Andrii.Tseglytskyi" <andrii.tseglytskyi@ti.com>

Add ABB device nodes for OMAP4460 device Data is based on OMAP4460
Technical Reference Manual revision Z (April 2013)

[nm@ti.com: co-developer]
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Andrii.Tseglytskyi <andrii.tseglytskyi@ti.com>
---
 arch/arm/boot/dts/omap4460.dtsi |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm/boot/dts/omap4460.dtsi b/arch/arm/boot/dts/omap4460.dtsi
index 2cf227c..e854c41 100644
--- a/arch/arm/boot/dts/omap4460.dtsi
+++ b/arch/arm/boot/dts/omap4460.dtsi
@@ -29,4 +29,42 @@
 			     <0 55 0x4>;
 		ti,hwmods = "debugss";
 	};
+
+	ocp {
+		abb_mpu: regulator-abb-mpu {
+			status = "okay";
+
+			reg = <0x4a307bd0 0x8>, <0x4a306014 0x4>,
+			      <0x4A002268 0x4>;
+			reg-names = "base-address", "int-address",
+				    "efuse-address";
+
+			ti,abb_info = <
+			/*uV		ABB	efuse	rbb_m	fbb_m	vset_m*/
+			1025000		0	0	0	0	0
+			1200000		0	0	0	0	0
+			1313000		0	0	0x100000 0x40000 0
+			1375000		1	0	0	0	0
+			1389000		1	0	0	0	0
+			>;
+		};
+
+		abb_iva: regulator-abb-iva {
+			status = "okay";
+
+			reg = <0x4a307bd8 0x8>, <0x4a306010 0x4>,
+			      <0x4A002268 0x4>;
+			reg-names = "base-address", "int-address",
+				    "efuse-address";
+
+			ti,abb_info = <
+			/*uV		ABB	efuse	rbb_m	fbb_m	vset_m*/
+			950000		0	0	0	0	0
+			1140000		0	0	0	0	0
+			1291000		0	0	0x200000 0	0
+			1375000		1	0	0	0	0
+			1376000		1	0	0	0	0
+			>;
+		};
+	};
 };
-- 
1.7.9.5

