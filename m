Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaESK3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:29:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60702 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbaESK1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:27:14 -0400
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <dbaryshkov@gmail.com>, <dwmw2@infradead.org>, <santosh.shilimkar@ti.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <grant.likely@linaro.org>
CC: <arnd@arndb.de>, <rdunlap@infradead.org>, <linux@arm.linux.org.uk>,
        <grygorii.strashko@ti.com>, <olof@lixom.net>, <w-kwok2@ti.com>,
        <sboyd@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [Patch v3 2/5] Power: reset: add bindings for keystone reset driver
Date: Mon, 19 May 2014 13:25:52 +0300
Message-ID: <1400495155-11136-3-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400495155-11136-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1400495155-11136-1-git-send-email-ivan.khoronzhuk@ti.com>
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
 .../bindings/power/reset/keystone-reset.txt        | 61 ++++++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power/reset/keystone-reset.txt

diff --git a/Documentation/devicetree/bindings/power/reset/keystone-reset.txt b/Documentation/devicetree/bindings/power/reset/keystone-reset.txt
new file mode 100644
index 0000000..d1f6f00
--- /dev/null
+++ b/Documentation/devicetree/bindings/power/reset/keystone-reset.txt
@@ -0,0 +1,61 @@
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
+- ti,wdt_list:		WDT list that can cause SoC reset. It's not related
+			to WDT driver, it's just needed to enable a SoC related
+			reset that's triggered by one of WDTs. The list is
+			in format: <0>, <2>; It can be in random order and
+			begins from 0 to 3, as keystone can contain up to 4 SoC
+			reset watchdogs and can be in random order.
+
+Example 1:
+Setup keystone reset so that in case software reset or
+WDT0 is triggered it issues hard reset for SoC.
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
+WDT0 or WDT2 is triggered it issues soft reset for SoC.
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

