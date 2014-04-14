Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbaDNRoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:44:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38820 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405AbaDNRm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:42:56 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <santosh.shilimkar@ti.com>, <grant.likely@linaro.org>
CC: <rdunlap@infradead.org>, <linux@arm.linux.org.uk>,
        <ivan.khoronzhuk@ti.com>, <grygorii.strashko@ti.com>, <olof@lixom.net>,
        <w-kwok2@ti.com>, <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2 2/5] Power: reset: add bindings for keystone reset driver
Date: Mon, 14 Apr 2014 20:41:20 +0300
Message-ID: <1397497283-16391-3-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397497283-16391-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1397497283-16391-1-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This node is intended to allow SoC reset in case of software reset
or appropriate watchdogs.

The Keystone SoCs can contain up to 4 watchdog timers to reset
SoC. Each watchdog timer event input is connected to the Reset Mux
block. The Reset Mux block can be configured to cause reset or not.

Additionally soft or hard reset can be configured.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
---
 .../bindings/power/reset/keystone-reset.txt        | 59 ++++++++++++++++++++++
 1 file changed, 59 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/reset/keystone-reset.txt

diff --git a/Documentation/devicetree/bindings/power/reset/keystone-reset.txt b/Documentation/devicetree/bindings/power/reset/keystone-reset.txt
new file mode 100644
index 0000000..5ad5883
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/reset/keystone-reset.txt
@@ -0,0 +1,59 @@
+* Device tree bindings for Texas Instruments keystone reset
+
+This node is intended to allow SoC reset in case of software reset
+of selected watchdogs.
+
+The Keystone SoCs can contain up to 4 watchdog timers to reset
+SoC. Each watchdog timer event input is connected to the Reset Mux
+block. The Reset Mux block can be configured to cause reset or not.
+
+Additionally soft or hard reset can be configured.
+
+Required properties:
+
+- compatible:		ti,keystone-reset
+
+- reg:			Contains offset/length value for mux registers.
+
+			reg = <0x23100e4 0x10>,
+			      <0x2620328 0x10>;
+
+-reg-names:		Contains two ranges "pllregs" and "muxregs".
+			"pllregs" - PLL reset control regs: RSTYPE, RSCTRL,
+			RSCFG, RSISO.
+			"muxregs" - mux block registers for all watchdogs.
+
+Optional properties:
+
+- ti,soft-reset:	Boolean option indicating soft reset.
+			By default hard reset is used.
+
+- ti,wdt_list:		WDT list that can cause SoC reset.
+			The list in format: <0>, <2>;
+			Begins from 0 to 3, as keystone can contain up
+			to 4 SoC reset watchdogs.
+
+Example 1:
+Setup keystone reset so that in case software reset or
+WDT1 is triggered it issues hard reset for SoC.
+
+rstctrl: reset-controller {
+	compatible = "ti,keystone-reset";
+	reg = <0x23100e4 0x10>,
+	      <0x2620328 0x10>;
+	reg-names = "pllregs", "muxregs";
+	ti,wdt_list = <0>;
+};
+
+Example 2:
+Setup keystone reset so that in case of software reset or
+WDT1 or WDT3 is triggered it issues soft reset for SoC.
+
+rstctrl: reset-controller {
+	compatible = "ti,keystone-reset";
+	reg = <0x23100e4 0x10>,
+	      <0x2620328 0x10>;
+	reg-names = "pllregs", "muxregs";
+	ti,wdt_list = <0>, <2>;
+	ti,soft-reset;
+};
-- 
1.8.3.2

