Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaKYIE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 03:04:59 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:35491 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752244AbaKYIE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 03:04:56 -0500
X-Listener-Flag: 11101
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Mark Rutland <mark.rutland@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>
CC: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        <devicetree@vger.kernel.org>, <hc.yen@mediatek.com>,
        <srv_heupstream@mediatek.com>, <yh.chen@mediatek.com>,
        <linux-kernel@vger.kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>, Rob Herring <robh+dt@kernel.org>,
        <nathan.chung@mediatek.com>, <yingjoe.chen@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>, <eddie.huang@mediatek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v8 4/4] dt-bindings: add bindings for mediatek sysirq
Date: Tue, 25 Nov 2014 16:04:22 +0800
Message-ID: <1416902662-19281-5-git-send-email-yingjoe.chen@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1416902662-19281-1-git-send-email-yingjoe.chen@mediatek.com>
References: <1416902662-19281-1-git-send-email-yingjoe.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding documentation for Mediatek SoC SYSIRQ.

Signed-off-by: Yingjoe Chen <yingjoe.chen@mediatek.com>
---
 .../bindings/arm/mediatek/mediatek,sysirq.txt      | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
new file mode 100644
index 0000000..d680b07
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sysirq.txt
@@ -0,0 +1,28 @@
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
+- #interrupt-cells : Use the same format as specified by GIC in
+  Documentation/devicetree/bindings/arm/gic.txt
+- interrupt-parent: phandle of irq parent for sysirq. The parent must
+  use the same interrupt-cells format as GIC.
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

