Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaEVNuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 09:50:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37304 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754580AbaEVNuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 09:50:04 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <santosh.shilimkar@ti.com>,
        <arnd@arndb.de>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <grant.likely@linaro.org>
CC: <rdunlap@infradead.org>, <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <olof@lixom.net>, <w-kwok2@ti.com>,
        <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <m-karicheri2@ti.com>,
        <sergei.shtylyov@cogentembedded.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [Patch v5 2/7] clock: keystone-pllctrl: add bindings for keystone pll controller
Date: Thu, 22 May 2014 16:48:31 +0300
Message-ID: <1400766516-14537-3-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400766516-14537-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1400766516-14537-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main pll controller used to drive theC66x CorePacs, the switch fabric,
and a majority of the peripheral clocks (all but the ARM CorePacs, DDR3 and
the NETCP modules) requires a PLL Controller to manage the various clock
divisions, gating, and synchronization.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 .../bindings/clock/ti-keystone-pllctrl.txt           | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/ti-keystone-pllctrl.txt

diff --git a/Documentation/devicetree/bindings/clock/ti-keystone-pllctrl.txt b/Documentation/devicetree/bindings/clock/ti-keystone-pllctrl.txt
new file mode 100644
index 0000000..208176d
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
+pllctrl: pll-controller {
+	compatible = "ti,keystone-pllctrl", "syscon";
+	reg = <0x02310000 0x200>;
+};
-- 
1.8.3.2

