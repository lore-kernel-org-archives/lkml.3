Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaANAUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:20:19 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60433 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbaANAUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:20:13 -0500
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>
CC: Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Suman Anna <s-anna@ti.com>, Rob Herring <robh+dt@kernel.org>
Subject: [PATCHv4 2/7] Documentation: dt: add the omap hwspinlock bindings document
Date: Mon, 13 Jan 2014 18:19:19 -0600
Message-ID: <1389658764-39199-3-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1389658764-39199-1-git-send-email-s-anna@ti.com>
References: <1389658764-39199-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HwSpinlock IP is present only on OMAP4 and other newer SoCs,
which are all device-tree boot only. This patch adds the
DT bindings information for OMAP hwspinlock module.

Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Suman Anna <s-anna@ti.com>
---
 .../devicetree/bindings/hwlock/omap-hwspinlock.txt | 24 ++++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt

diff --git a/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
new file mode 100644
index 0000000..568eae2
--- /dev/null
+++ b/Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
@@ -0,0 +1,24 @@
+OMAP4+ HwSpinlock Driver
+========================
+
+Required properties:
+- compatible:		Should be "ti,omap4-hwspinlock" for
+			    OMAP44xx, OMAP54xx, AM33xx, AM43xx, DRA7xx SoCs
+- reg:			Contains the hwspinlock module register address space
+			(base address and length)
+- ti,hwmods:		Name of the hwmod associated with the hwspinlock device
+- #hwlock-cells:	Should be 1. The OMAP hwspinlock users will use a
+			0-indexed relative hwlock number as the argument
+			specifier value for requesting a specific hwspinlock
+			within a hwspinlock bank.
+
+
+Example:
+
+/* OMAP4 */
+hwspinlock: spinlock@4a0f6000 {
+	compatible = "ti,omap4-hwspinlock";
+	reg = <0x4a0f6000 0x1000>;
+	ti,hwmods = "spinlock";
+	#hwlock-cells = <1>;
+};
-- 
1.8.4.3

