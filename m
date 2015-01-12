Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbbALTDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:03:18 -0500
Received: from down.free-electrons.com ([37.187.137.238]:56955 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755440AbbALTCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:02:06 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 5/6] ARM: at91/dt: Add a dtsi for at91sam9xe
Date: Mon, 12 Jan 2015 20:01:56 +0100
Message-Id: <1421089317-12607-6-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421089317-12607-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1421089317-12607-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at91sam9xe is slightly different from at91sam9260, in particular it has a
different SRAM size and location.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 .../devicetree/bindings/arm/atmel-at91.txt         |  1 +
 arch/arm/boot/dts/at91sam9xe.dtsi                  | 60 ++++++++++++++++++++++
 2 files changed, 61 insertions(+)
 create mode 100644 arch/arm/boot/dts/at91sam9xe.dtsi

diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.txt b/Documentation/devicetree/bindings/arm/atmel-at91.txt
index 571fc76c6edb..ad319f84f560 100644
--- a/Documentation/devicetree/bindings/arm/atmel-at91.txt
+++ b/Documentation/devicetree/bindings/arm/atmel-at91.txt
@@ -24,6 +24,7 @@ compatible: must be one of:
     o "atmel,at91sam9g45"
     o "atmel,at91sam9n12"
     o "atmel,at91sam9rl"
+    o "atmel,at91sam9xe"
  * "atmel,sama5" for SoCs using a Cortex-A5, shall be extended with the specific
    SoC family:
     o "atmel,sama5d3" shall be extended with the specific SoC compatible:
diff --git a/arch/arm/boot/dts/at91sam9xe.dtsi b/arch/arm/boot/dts/at91sam9xe.dtsi
new file mode 100644
index 000000000000..0278f63b2daf
--- /dev/null
+++ b/arch/arm/boot/dts/at91sam9xe.dtsi
@@ -0,0 +1,60 @@
+/*
+ * at91sam9xe.dtsi - Device Tree Include file for AT91SAM9XE family SoC
+ *
+ *  Copyright (C) 2015 Atmel,
+ *                2015 Alexandre Belloni <alexandre.Belloni@free-electrons.com>
+ *
+ * This file is dual-licensed: you can use it either under the terms
+ * of the GPL or the X11 license, at your option. Note that this dual
+ * licensing only applies to this file, and not this project as a
+ * whole.
+ *
+ *  a) This file is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This file is distributed in the hope that it will be useful,
+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *     GNU General Public License for more details.
+ *
+ * Or, alternatively,
+ *
+ *  b) Permission is hereby granted, free of charge, to any person
+ *     obtaining a copy of this software and associated documentation
+ *     files (the "Software"), to deal in the Software without
+ *     restriction, including without limitation the rights to use,
+ *     copy, modify, merge, publish, distribute, sublicense, and/or
+ *     sell copies of the Software, and to permit persons to whom the
+ *     Software is furnished to do so, subject to the following
+ *     conditions:
+ *
+ *     The above copyright notice and this permission notice shall be
+ *     included in all copies or substantial portions of the Software.
+ *
+ *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
+ *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
+ *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
+ *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ *     OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include "at91sam9260.dtsi"
+
+/ {
+	model = "Atmel AT91SAM9XE family SoC";
+	compatible = "atmel,at91sam9xe", "atmel,at91sam9260";
+
+	sram0: sram@002ff000 {
+		status = "disabled";
+	};
+
+	sram1: sram@00300000 {
+		compatible = "mmio-sram";
+		reg = <0x00300000 0x4000>;
+	};
+};
-- 
2.1.0

