Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaILU0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:26:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42451 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbaILUZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:25:40 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
CC: Tony Lindgren <tony@atomide.com>, Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCHv6 2/5] Documentation: dt: add the omap hwspinlock bindings document
Date: Fri, 12 Sep 2014 15:24:56 -0500
Message-ID: <1410553499-55951-3-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410553499-55951-1-git-send-email-s-anna@ti.com>
References: <1410553499-55951-1-git-send-email-s-anna@ti.com>
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
2.0.4

