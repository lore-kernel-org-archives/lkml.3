Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbbAZOyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:54:04 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:65146 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbbAZOx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:53:26 -0500
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
To: <tiwai@suse.de>, <perex@perex.cz>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <Zubair.Kakakhel@imgtec.com>,
        <lars@metafoo.de>
Subject: [PATCH_V3 2/4] dt: sound: jz4740: Add binding documentation for jz4740-i2s
Date: Mon, 26 Jan 2015 14:53:11 +0000
Message-ID: <1422283993-53642-3-git-send-email-Zubair.Kakakhel@imgtec.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422283993-53642-1-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422283993-53642-1-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds binding for the jz4740-i2s driver.

Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>

---
The jz4740 is platform only at the moment.

But DT support is being added

See http://patchwork.linux-mips.org/bundle/paulburton/ci20-v3.20/

V3 changes: Missed out adding dma bindings in required properties.
Only put them in example node for V2.

V2 changes: Added DMA bindings for later on
---
 .../bindings/sound/ingenic,jz4740-i2s.txt          | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/ingenic,jz4740-i2s.txt

diff --git a/Documentation/devicetree/bindings/sound/ingenic,jz4740-i2s.txt b/Documentation/devicetree/bindings/sound/ingenic,jz4740-i2s.txt
new file mode 100644
index 0000000..b414333
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/ingenic,jz4740-i2s.txt
@@ -0,0 +1,23 @@
+Ingenic JZ4740 I2S controller
+
+Required properties:
+- compatible : "ingenic,jz4740-i2s"
+- reg : I2S registers location and length
+- clocks : AIC and I2S PLL clock specifiers.
+- clock-names: "aic" and "i2s"
+- dmas: DMA controller phandle and DMA request line for I2S Tx and Rx channels
+- dma-names: Must be "tx" and "rx"
+
+Example:
+
+i2s: i2s@10020000 {
+	compatible = "ingenic,jz4740-i2s";
+	reg = <0x10020000 0x94>;
+
+	clocks = <&cgu JZ4740_CLK_AIC>, <&cgu JZ4740_CLK_I2SPLL>;
+	clock-names = "aic", "i2s";
+
+	dmas = <&dma 2>, <&dma 3>;
+	dma-names = "tx", "rx";
+
+};
-- 
1.9.1

