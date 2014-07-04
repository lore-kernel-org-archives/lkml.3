Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaGDH2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:28:12 -0400
Received: from regular1.263xmail.com ([211.150.99.133]:41367 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaGDH2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:28:10 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <7a18386a481d7fd1e88afc79aa2adabe>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: jianqun <xjq@rock-chips.com>
To: heiko@sntech.de, lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz,
        tiwai@suse.de, grant.likely@linaro.org, robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, zhangqing@rock-chips.com,
        hj@rock-chips.com, kever.yang@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, kfx@rock-chips.com, Jianqun Xu <xjq@rock-chips.com>
Subject: [PATCH v2 1/2] ASoC: dt-bindings: add rockchip i2s bindings
Date: Fri,  4 Jul 2014 15:26:36 +0800
Message-Id: <1404458796-6818-1-git-send-email-xjq@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404203860-30712-2-git-send-email-xjq@rock-chips.com>
References: <1404203860-30712-2-git-send-email-xjq@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianqun Xu <xjq@rock-chips.com>

Add devicetree bindings for i2s controller found on
rk3066, rk3188 and rk3288 processors from rockchip.

Signed-off-by: Jianqun Xu <xjq@rock-chips.com>
---
Changes since v1:
- modify the description of clock-names property, adviced by Mark Rutland.
- modify the example to fit for rk3288.

 .../devicetree/bindings/sound/rockchip-i2s.txt     |   36 ++++++++++++++++++++
 1 file changed, 36 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/rockchip-i2s.txt

diff --git a/Documentation/devicetree/bindings/sound/rockchip-i2s.txt b/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
new file mode 100644
index 0000000..9fc577d
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
@@ -0,0 +1,36 @@
+* Rockchip I2S controller
+
+The I2S bus (Inter-IC sound bus) is a serial link for digital
+audio data transfer between devices in the system.
+
+Required properties:
+
+- compatible: should be one of the followings
+   - "rockchip,rk3066-i2s": for rk3066
+   - "rockchip,rk3188-i2s", "rockchip,rk3066-i2s": for rk3188
+   - "rockchip,rk3288-i2s", "rockchip,rk3066-i2s": for rk3288
+- reg: physical base address of the controller and length of memory mapped
+  region.
+- interrupts: The interrupt number to the cpu. The interrupt specifier format
+  depends on the interrupt controller.
+- #address-cells: should be 1.
+- #size-cells: should be 0.
+- dmas: DMA specifiers for tx and rx dma. See the DMA client binding,
+	Documentation/devicetree/bindings/dma/dma.txt
+- dma-names: DMA request names should include "tx" and "rx" if present.
+- clocks: a list of phandle + clock-specifer pairs, one for each entry in clock-names.
+- clock-names: Shall be "i2s_hclk" for I2S bus and "i2s_clk" for master clock
+
+Example, for rk3288 I2S controller:
+
+i2s0: i2s@ff890000 {
+	compatible = "rockchip,rk3066-i2s", "rockchip,rk3288-i2s";
+	reg = <0xff890000 0x10000>;
+	interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+	dmas = <&pdma1 0>, <&pdma1 1>;
+	dma-names = "rx", "tx";
+	clock-names = "i2s_hclk", "i2s_clk";
+	clocks = <&cru HCLK_I2S0>, <&cru SCLK_I2S0>;
+};
-- 
1.7.9.5


