Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaGABDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 21:03:22 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:60859 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaGABDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 21:03:21 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <1f34dd93bbf30d0c9f1f3355a1348ad7>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: addy ke <addy.ke@rock-chips.com>
To: broonie@kernel.org, heiko@sntech.de, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, wei.luo@rock-chips.com,
        addy ke <addy.ke@rock-chips.com>
Subject: [PATCH v2 1/2] documentation: add rockchip spi documentation
Date: Tue,  1 Jul 2014 09:02:57 +0800
Message-Id: <1404176577-3274-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403582324-9485-2-git-send-email-addy.ke@rock-chips.com>
References: <1403582324-9485-2-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: addy ke <addy.ke@rock-chips.com>
---
changes since v1:
- fix binding document according to comments from Mark Rutland
- fix address according to comments from Mark Brown
- combine all properties into "Required Properties" suggested by Heiko Stübner
- remove "Board Specific Portion" suggested by Heiko Stübner

 .../devicetree/bindings/spi/spi-rockchip.txt       | 37 ++++++++++++++++++++++
 1 file changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-rockchip.txt

diff --git a/Documentation/devicetree/bindings/spi/spi-rockchip.txt b/Documentation/devicetree/bindings/spi/spi-rockchip.txt
new file mode 100644
index 0000000..7bab355
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/spi-rockchip.txt
@@ -0,0 +1,37 @@
+* Rockchip SPI Controller
+
+The Rockchip SPI controller is used to interface with various devices such as flash
+and display controllers using the SPI communication interface.
+
+Required Properties:
+
+- compatible: should be one of the following.
+    "rockchip,rk3066-spi" for rk3066.
+    "rockchip,rk3188-spi", "rockchip,rk3066-spi" for rk3188.
+    "rockchip,rk3288-spi", "rockchip,rk3066-spi" for rk3288.
+- reg: physical base address of the controller and length of memory mapped
+       region.
+- interrupts: The interrupt number to the cpu. The interrupt specifier format
+              depends on the interrupt controller.
+- clocks: Must contain an entry for each entry in clock-names.
+- clock-names: Shall be "spiclk" for the transfer-clock, and "apb_pclk" for
+			   the peripheral clock.
+- dmas: DMA specifiers for tx and rx dma. See the DMA client binding,
+		Documentation/devicetree/bindings/dma/dma.txt
+- dma-names: DMA request names should include "tx" and "rx" if present.
+- #address-cells: should be 1.
+- #size-cells: should be 0.
+
+Example:
+
+	spi0: spi@ff110000 {
+		compatible = "rockchip,rk3066-spi";
+		reg = <0xff110000 0x1000>;
+		dmas = <&pdma1 11>, <&pdma1 12>;
+		dma-names = "tx", "rx";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru SCLK_SPI0>, <&cru PCLK_SPI0>;
+		clock-names = "spiclk", "apb_pclk";
+	};
-- 
1.8.3.2


