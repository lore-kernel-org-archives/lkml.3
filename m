Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaB1SLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 13:11:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33892 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbaB1SK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 13:10:28 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <santosh.shilimkar@ti.com>
CC: <olof@lixom.net>, <w-kwok2@ti.com>, <grygorii.strashko@ti.com>,
        <anton@enomsg.org>, <catalin.marinas@arm.com>, <sboyd@codeaurora.org>,
        <ksankaran@apm.com>, <abhimany@codeaurora.org>, <ldewangan@nvidia.com>,
        <lho@apm.com>, <fkan@apm.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>
Subject: [PATCH 2/5] Power: reset: add bindings for keystone reset driver
Date: Fri, 28 Feb 2014 20:07:42 +0200
Message-ID: <1393610865-23630-3-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393610865-23630-1-git-send-email-ivan.khoronzhuk@ti.com>
References: <1393610865-23630-1-git-send-email-ivan.khoronzhuk@ti.com>
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

CC: Rob Herring <robh+dt@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>
CC: Mark Rutland <mark.rutland@arm.com>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
CC: Kumar Gala <galak@codeaurora.org>
CC: Rob Landley <rob@landley.net>

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

