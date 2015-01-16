Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbbAPKfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:35:30 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:51710 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751365AbbAPKet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:34:49 -0500
X-Listener-Flag: 11101
From: Eddie Huang <eddie.huang@mediatek.com>
To: Wolfram Sang <wsa@the-dreams.de>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC: <srv_heupstream@mediatek.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Doug Anderson <dianders@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Max Schwarz <max.schwarz@online.de>,
        Uwe Kleine-Konig <u.kleine-koenig@pengutronix.de>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Anders Berg <anders.berg@avagotech.com>,
        Neelesh Gupta <neelegup@linux.vnet.ibm.com>,
        Wei Yan <sledge.yanwei@huawei.com>, Lee Jones <lee.jones@linaro.org>,
        Simon Glass <sjg@chromium.org>, Jim Cromie <jim.cromie@gmail.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Xudong Chen <xudong.chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>, <linux-i2c@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <yingjoe.chen@mediatek.com>,
        <yh.chen@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>
Subject: [PATCH v4 1/2] dt-bindings: Add I2C bindings for mt65xx/mt81xx.
Date: Fri, 16 Jan 2015 18:33:37 +0800
Message-ID: <1421404418-50718-2-git-send-email-eddie.huang@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
In-Reply-To: <1421404418-50718-1-git-send-email-eddie.huang@mediatek.com>
References: <1421404418-50718-1-git-send-email-eddie.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xudong Chen <xudong.chen@mediatek.com>

Add devicetree bindings for Mediatek Soc I2C driver.

Signed-off-by: Xudong Chen <xudong.chen@mediatek.com>
Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
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

