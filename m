Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbaEVQpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:45:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53420 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaEVQpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:45:42 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <lee.jones@linaro.org>,
        <santosh.shilimkar@ti.com>, <arnd@arndb.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <grant.likely@linaro.org>
CC: <rdunlap@infradead.org>, <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <olof@lixom.net>, <w-kwok2@ti.com>,
        <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <m-karicheri2@ti.com>,
        <sergei.shtylyov@cogentembedded.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [Patch v6 2/7] clock: keystone-pllctrl: add bindings for keystone pll controller
Date: Thu, 22 May 2014 19:44:17 +0300
Message-ID: <1400777062-19276-3-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400777062-19276-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1400777062-19276-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main pll controller used to drive theC66x CorePacs, the switch fabric,
and a majority of the peripheral clocks (all but the ARM CorePacs, DDR3 and
the NETCP modules) requires a PLL Controller to manage the various clock
divisions, gating, and synchronization.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 .../bindings/clock/ti-keystone-pllctrl.txt           | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/ti-keystone-pllctrl.txt

diff --git a/Documentation/devicetree/bindings/clock/ti-keystone-pllctrl.txt b/Documentation/devicetree/bindings/clock/ti-keystone-pllctrl.txt
new file mode 100644
index 0000000..3e6a81e
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/ti-keystone-pllctrl.txt
@@ -0,0 +1,20 @@
+* Device tree bindings for Texas Instruments keystone pll controller
+
+The main pll controller used to drive theC66x CorePacs, the switch fabric,
+and a majority of the peripheral clocks (all but the ARM CorePacs, DDR3 and
+the NETCP modules) requires a PLL Controller to manage the various clock
+divisions, gating, and synchronization.
+
+Required properties:
+
+- compatible:		"ti,keystone-pllctrl", "syscon"
+
+- reg:			contains offset/length value for pll controller
+			registers space.
+
+Example:
+
+pllctrl: pll-controller@0x02310000 {
+	compatible = "ti,keystone-pllctrl", "syscon";
+	reg = <0x02310000 0x200>;
+};
-- 
1.8.3.2

