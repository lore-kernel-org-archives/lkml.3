Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaENTLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:11:31 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:52720 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbaENTL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:11:27 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: marc.ceeeee@gmail.com, computersforpeace@gmail.com, gregory.0xf0@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Huang Shijie <b32955@freescale.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...)
Subject: [PATCH 2/3] Documentation: devicetree: add Broadcom GISB arbiter bindings
Date: Wed, 14 May 2014 12:10:48 -0700
Message-Id: <1400094649-11193-4-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400094649-11193-1-git-send-email-f.fainelli@gmail.com>
References: <1400094649-11193-1-git-send-email-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Broadcom GISB arbiter Device Tree binding that is
used on all Broadcom Set-top-box System-on-a-chip.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../devicetree/bindings/bus/brcm,gisb-arb.txt      | 30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/bus/brcm,gisb-arb.txt

diff --git a/Documentation/devicetree/bindings/bus/brcm,gisb-arb.txt b/Documentation/devicetree/bindings/bus/brcm,gisb-arb.txt
new file mode 100644
index 000000000000..e2d501d20c9a
--- /dev/null
+++ b/Documentation/devicetree/bindings/bus/brcm,gisb-arb.txt
@@ -0,0 +1,30 @@
+Broadcom GISB bus Arbiter controller
+
+Required properties:
+
+- compatible: should be "brcm,gisb-arb"
+- reg: specifies the base physical address and size of the registers
+- interrupt-parent: specifies the phandle to the parent interrupt controller
+  this arbiter gets interrupt line from
+- interrupts: specifies the two interrupts (timeout and TEA) to be used from
+  the parent interrupt controller
+
+Optional properties:
+
+- brcm,gisb-arb-master-mask: 32-bits wide bitmask used to specify which GISB
+  masters are valid at the system level
+- brcm,gisb-arb-master-names: string list of the litteral name of the GISB
+  masters. Should match the number of bits set in brcm,gisb-master-mask and
+  the order in which they appear
+
+Example:
+
+gisb-arb@f0400000 {
+	compatible = "brcm,gisb-arb";
+	reg = <0xf0400000 0x800>;
+	interrupts = <0>, <2>;
+	interrupt-parent = <&sun_l2_intc>;
+
+	brcm,gisb-arb-master-mask = <0x7>;
+	brcm,gisb-arb-master-names = "bsp_0", "scpu_0", "cpu_0";
+};
-- 
1.9.1

