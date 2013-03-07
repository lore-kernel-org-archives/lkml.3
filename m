Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab3CGGZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 01:25:06 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55524 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab3CGGZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 01:25:03 -0500
From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <broonie@opensource.wolfsonmicro.com>, <nsekhar@ti.com>,
        <linux@arm.linux.org.uk>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <manishv.b@ti.com>
Subject: [RESEND 1/2] ARM: regulator: add tps6507x device tree data
Date: Thu, 7 Mar 2013 11:56:20 +0530
Message-ID: <1362637581-12673-2-git-send-email-manishv.b@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1362637581-12673-1-git-send-email-manishv.b@ti.com>
References: <1362637581-12673-1-git-send-email-manishv.b@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree data for tps6507x regulator by adding
all tps6507x regulator nodes. Regulators are initialized
based on compatible name provided in tps6507x DT file.

All tps6507x PMIC regulator device tree nodes are placed
in a separate device tree include file (tps6507x.dtsi).
tps6507x.dtsi file is created using datasheet
http://www.ti.com/lit/ds/symlink/tps65070.pdf

Tested on da850-evm.

Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
---
:000000 100644 0000000... 4c326e5... A	arch/arm/boot/dts/tps6507x.dtsi
 arch/arm/boot/dts/tps6507x.dtsi |   47 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tps6507x.dtsi b/arch/arm/boot/dts/tps6507x.dtsi
new file mode 100644
index 0000000..4c326e5
--- /dev/null
+++ b/arch/arm/boot/dts/tps6507x.dtsi
@@ -0,0 +1,47 @@
+/*
+ * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * Integrated Power Management Chip
+ * http://www.ti.com/lit/ds/symlink/tps65070.pdf
+ */
+
+&tps {
+	compatible = "ti,tps6507x";
+
+	regulators {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vdcdc1_reg: regulator@0 {
+			reg = <0>;
+			regulator-compatible = "VDCDC1";
+		};
+
+		vdcdc2_reg: regulator@1 {
+			reg = <1>;
+			regulator-compatible = "VDCDC2";
+		};
+
+		vdcdc3_reg: regulator@2 {
+			reg = <2>;
+			regulator-compatible = "VDCDC3";
+		};
+
+		ldo1_reg: regulator@3 {
+			reg = <3>;
+			regulator-compatible = "LDO1";
+		};
+
+		ldo2_reg: regulator@4 {
+			reg = <4>;
+			regulator-compatible = "LDO2";
+		};
+
+	};
+};
-- 
1.7.4.1

