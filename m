Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaKXJjm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:39:42 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:36555 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751127AbaKXJjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:39:05 -0500
X-Listener-Flag: 11101
From: Xudong Chen <xudong.chen@mediatek.com>
To: Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>
CC: <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Xudong Chen <xudong.chen@mediatek.com>,
        Jean Delvare <jdelvare@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-i2c@vger.kernel.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        YH Chen <yh.chen@mediatek.com>
Subject: [PATCH v3 1/2] dt-bindings: Add I2C bindings for mt65xx/mt81xx.
Date: Mon, 24 Nov 2014 17:38:47 +0800
Message-ID: <1416821928-11453-2-git-send-email-xudong.chen@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1416821928-11453-1-git-send-email-xudong.chen@mediatek.com>
References: <1416821928-11453-1-git-send-email-xudong.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree bindings for Mediatek Soc I2C driver.

Signed-off-by: Xudong Chen <xudong.chen@mediatek.com>
Change-Id: Iaaba1e8420abfbfb503501310de04ee25ae72e18
---
 .../devicetree/bindings/i2c/i2c-mt6577.txt         | 40 ++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-mt6577.txt

diff --git a/Documentation/devicetree/bindings/i2c/i2c-mt6577.txt b/Documentation/devicetree/bindings/i2c/i2c-mt6577.txt
new file mode 100644
index 0000000..08f86c7
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/i2c-mt6577.txt
@@ -0,0 +1,40 @@
+* Mediatek's I2C controller
+
+The Mediatek's I2C controller is used to interface with I2C devices.
+
+Required properties:
+  - compatible: value should be either of the following.
+      (a) "mediatek,mt6577-i2c", for i2c compatible with mt6577 i2c.
+      (b) "mediatek,mt6589-i2c", for i2c compatible with mt6589 i2c.
+      (c) "mediatek,mt8127-i2c", for i2c compatible with mt8127 i2c.
+      (d) "mediatek,mt8135-i2c", for i2c compatible with mt8135 i2c.
+  - reg: physical base address of the controller and dma base, length of memory
+    mapped region.
+  - interrupts: interrupt number to the cpu.
+  - clock-div: the fixed value for frequency divider of clock source in i2c
+    module. Each IC may be different.
+  - clocks: clock name from clock manager
+  - clock-names: Must include "main" and "dma", if enable have-pmic need include
+    "pmic" extra.
+
+Optional properties:
+  - clock-frequency: Frequency in Hz of the bus when transfer, the default value
+    is 100000.
+  - mediatek,have-pmic: platform can control i2c form special pmic side.
+    Only mt6589 and mt8135 support this feature.
+  - mediatek,use-push-pull: IO config use push-pull mode.
+
+Example:
+
+	i2c0: i2c@1100d000 {
+			compatible = "mediatek,mt6577-i2c";
+			reg = <0x1100d000 0x70>,
+			      <0x11000300 0x80>;
+			interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_LOW>;
+			clock-frequency = <100000>;
+			mediatek,have-pmic;
+			clock-div = <16>;
+			clocks = <&i2c0_ck>, <&ap_dma_ck>;
+			clock-names = "main", "dma";
+	};
+
-- 
1.8.1.1.dirty

