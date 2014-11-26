Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbaKZV2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:28:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:58737 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbaKZV2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:28:03 -0500
From: Dave Gerlach <d-gerlach@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Kevin Hilman <khilman@linaro.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Suman Anna <s-anna@ti.com>, Dave Gerlach <d-gerlach@ti.com>
Subject: [RFC PATCH 2/3] Documentation: dt: add ti,am3353-wkup-m3 bindings
Date: Wed, 26 Nov 2014 15:27:11 -0600
Message-ID: <13e848f10614c0a276e54759e606210971d63fe0.1417029919.git.d-gerlach@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1417029919.git.d-gerlach@ti.com>
References: <cover.1417029919.git.d-gerlach@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device tree bindings document for ti,am3353-wkup-m3 which is
used by the wkup_m3_rproc driver.

Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
---
 .../bindings/remoteproc/wkup_m3_rproc.txt          | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/remoteproc/wkup_m3_rproc.txt

diff --git a/Documentation/devicetree/bindings/remoteproc/wkup_m3_rproc.txt b/Documentation/devicetree/bindings/remoteproc/wkup_m3_rproc.txt
new file mode 100644
index 0000000..4d64a23
--- /dev/null
+++ b/Documentation/devicetree/bindings/remoteproc/wkup_m3_rproc.txt
@@ -0,0 +1,32 @@
+Wakeup M3 Remote Proc Driver
+=====================
+
+TI AMx3 family of devices use a Cortex M3 co-processor to help with various
+low power tasks that cannot be controlled from the MPU. The CM3 requires
+a firmware binary to accomplish this. The wkup_m3 remoteproc driver handles
+the loading of the firmware and booting of the CM3.
+
+Wkup M3 Device Node:
+====================
+A wkup_m3 device node is used to represent a wakeup M3 IP instance within
+a SoC.
+
+Required properties:
+--------------------
+- compatible:		Should be "ti,am3353-wkup-m3" for AM33xx SoCs
+- reg:			Contains the wkup_m3 register address ranges for
+			umem and dmem.
+- ti,hwmods:		Name of the hwmod associated with the mailbox
+- ti,no-reset-on-init:	Reset is handled after fw has been loaded, not at
+			init of hwmod.
+
+Example:
+--------
+/* AM33xx */
+wkup_m3: wkup_m3@44d00000 {
+	compatible = "ti,am3353-wkup-m3";
+	reg = <0x44d00000 0x4000	/* M3 UMEM */
+	       0x44d80000 0x2000>;	/* M3 DMEM */
+	ti,hwmods = "wkup_m3";
+	ti,no-reset-on-init;
+};
-- 
2.1.0

