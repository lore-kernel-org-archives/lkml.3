Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaJAVbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:31:34 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:39066 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaJAVbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:31:31 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>, Carlo Caione <carlo@caione.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 2/6] ARM: dts: add dtsi for Amlogic Meson8 SoCs
Date: Wed,  1 Oct 2014 23:29:42 +0200
Message-Id: <1412198986-26534-3-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412198986-26534-1-git-send-email-b.galvani@gmail.com>
References: <1412198986-26534-1-git-send-email-b.galvani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dtsi for the Amlogic Meson8 SoCs. It differs from the Meson6
dtsi for the number of Cortex-A9 cores (4 vs 2) and for the
frequency of clk81.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 arch/arm/boot/dts/meson8.dtsi | 90 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)
 create mode 100644 arch/arm/boot/dts/meson8.dtsi

diff --git a/arch/arm/boot/dts/meson8.dtsi b/arch/arm/boot/dts/meson8.dtsi
new file mode 100644
index 0000000..7b3fc1e
--- /dev/null
+++ b/arch/arm/boot/dts/meson8.dtsi
@@ -0,0 +1,90 @@
+/*
+ * Copyright 2014 Carlo Caione <carlo@caione.org>
+ *
+ * This file is dual-licensed: you can use it either under the terms
+ * of the GPL or the X11 license, at your option. Note that this dual
+ * licensing only applies to this file, and not this project as a
+ * whole.
+ *
+ *  a) This library is free software; you can redistribute it and/or
+ *     modify it under the terms of the GNU General Public License as
+ *     published by the Free Software Foundation; either version 2 of the
+ *     License, or (at your option) any later version.
+ *
+ *     This library is distributed in the hope that it will be useful,
+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *     GNU General Public License for more details.
+ *
+ *     You should have received a copy of the GNU General Public
+ *     License along with this library; if not, write to the Free
+ *     Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
+ *     MA 02110-1301 USA
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
+/include/ "meson.dtsi"
+
+/ {
+	model = "Amlogic Meson8 SoC";
+	compatible = "amlogic,meson8";
+
+	interrupt-parent = <&gic>;
+
+	cpus {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		cpu@200 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0x200>;
+		};
+
+		cpu@201 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0x201>;
+		};
+
+		cpu@202 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0x202>;
+		};
+
+		cpu@203 {
+			device_type = "cpu";
+			compatible = "arm,cortex-a9";
+			reg = <0x203>;
+		};
+	};
+
+	clk81: clk@0 {
+		#clock-cells = <0>;
+		compatible = "fixed-clock";
+		clock-frequency = <141666666>;
+	};
+}; /* end of / */
-- 
1.9.1

