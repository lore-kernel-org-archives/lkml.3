Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbaJWPyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:54:55 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:50104 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755863AbaJWPyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:54:36 -0400
X-Listener-Flag: 11101
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Rob Herring <robh+dt@kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>, <arm@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Grant Likely <grant.likely@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <srv_heupstream@mediatek.com>, <yingjoe.chen@gmail.com>,
        <hc.yen@mediatek.com>, <eddie.huang@mediatek.com>,
        <nathan.chung@mediatek.com>, <yh.chen@mediatek.com>
Subject: [PATCH v4 7/7] dt-bindings: add bindings for mediatek sysirq
Date: Thu, 23 Oct 2014 23:53:15 +0800
Message-ID: <1414079595-26129-8-git-send-email-yingjoe.chen@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1414079595-26129-1-git-send-email-yingjoe.chen@mediatek.com>
References: <1414079595-26129-1-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding documentation for Mediatek SoC SYSIRQ.

Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
---
 .../bindings/arm/mediatek/mediatek,sysirq.txt      | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
new file mode 100644
index 0000000..8669536
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
@@ -0,0 +1,26 @@
+Mediatek 65xx/81xx sysirq
+
+Mediatek SOCs sysirq support controllable irq inverter for each GIC SPI
+interrupt.
+
+Required properties:
+- compatible: should be one of:
+	"mediatek,mt8135-sysirq"
+	"mediatek,mt8127-sysirq"
+	"mediatek,mt6589-sysirq"
+	"mediatek,mt6582-sysirq"
+	"mediatek,mt6577-sysirq"
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Must use the same cells/format as parent controller.
+- interrupt-parent: phandle of irq domain parent for sysirq.
+- reg: Physical base address of the intpol registers and length of memory
+  mapped region.
+
+Example:
+	sysirq: interrupt-controller@10200100 {
+		compatible = "mediatek,mt6589-sysirq", "mediatek,mt6577-sysirq";
+		interrupt-controller;
+		#interrupt-cells = <3>;
+		interrupt-parent = <&gic>;
+		reg = <0 0x10200100 0 0x1c>;
+	};
-- 
1.8.1.1.dirty

