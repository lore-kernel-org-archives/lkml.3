Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbbABUA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 15:00:58 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49509 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbbABUAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 15:00:52 -0500
From: Dave Gerlach <d-gerlach@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: Benoit Cousson <bcousson@baylibre.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Suman Anna <s-anna@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Dave Gerlach <d-gerlach@ti.com>
Subject: [PATCH 1/3] Documentation: dt: add ti,am3353-wkup-m3-ipc bindings
Date: Fri, 2 Jan 2015 14:00:15 -0600
Message-ID: <1420228817-41310-2-git-send-email-d-gerlach@ti.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420228817-41310-1-git-send-email-d-gerlach@ti.com>
References: <1420228817-41310-1-git-send-email-d-gerlach@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device tree bindings document for ti,am3353-wkup-m3-ipc which
is used by the wkup_m3_ipc driver.

Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
---
 .../devicetree/bindings/soc/ti/wkup_m3_ipc.txt     | 41 ++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/soc/ti/wkup_m3_ipc.txt

diff --git a/Documentation/devicetree/bindings/soc/ti/wkup_m3_ipc.txt b/Documentation/devicetree/bindings/soc/ti/wkup_m3_ipc.txt
new file mode 100644
index 0000000..ceb6acf
--- /dev/null
+++ b/Documentation/devicetree/bindings/soc/ti/wkup_m3_ipc.txt
@@ -0,0 +1,41 @@
+Wakeup M3 IPC Driver
+=====================
+
+TI AMx3 family of devices use a Cortex M3 co-processor to help with various
+low power tasks that cannot be controlled from the MPU like suspend/resume
+and certain deep C-states for CPU Idle. Once the wkup_m3_ipc driver uses the
+wkup_m3_rproc driver to boot the wkup_m3, it handles communication with the
+CM3 using IPC registers present in the SoC's control module and a mailbox.
+The wkup_m3_ipc exposes an API to allow the SoC PM code to execute specific
+PM tasks.
+
+Wkup M3 Device Node:
+====================
+A wkup_m3_ipc device node is used to represent a wakeup M3 IP instance within
+an SoC. The sub-mailboxes are represented as child node of this parent node.
+
+Required properties:
+--------------------
+- compatible:		Should be "ti,am3353-wkup-m3-ipc" for AM33xx SoCs
+- reg:			Contains the wkup_m3 register address ranges for
+			ipc-regs.
+- reg-names:		Name for ipc-regs given above
+- interrupts:		Contains the interrupt information for the wkup_m3
+			interrupt that signals the MPU.
+- ti,rproc:		Phandle to the wkup_m3 rproc node so the IPC driver
+			can boot it.
+- mboxes:		Phandles used by IPC framework to get correct mbox
+			channel for communication. Must point to appropriate
+			mbox_wkupm3 child node.
+
+Example:
+--------
+/* AM33xx */
+wkup_m3_ipc: wkup_m3_ipc@44e11324 {
+	compatible = "ti,am3353-wkup-m3-ipc";
+	reg = <0x44e11324 0x0024>;
+	reg-names = "ipc_regs";
+	interrupts = <78>;
+	ti,rproc = <&wkup_m3>;
+	mboxes = <&mailbox &mbox_wkupm3>;
+};
-- 
2.1.0

