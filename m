Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785AbaGAIpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:45:17 -0400
Received: from regular2.263xmail.com ([211.157.152.3]:59941 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318AbaGAIpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:45:12 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: xjq@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <6393e883bad73cce047c7903ce871263>
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
Subject: [PATCH 1/2] ASoC: dt-bindings: add rockchip i2s bindings
Date: Tue,  1 Jul 2014 16:37:39 +0800
Message-Id: <1404203860-30712-2-git-send-email-xjq@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404203860-30712-1-git-send-email-xjq@rock-chips.com>
References: <1404203860-30712-1-git-send-email-xjq@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jianqun Xu <xjq@rock-chips.com>

Add devicetree bindings for i2s controller found on rk3066, rk3188 and rk3288
processors from rockchip.

Signed-off-by: Jianqun Xu <xjq@rock-chips.com>
---
 .../devicetree/bindings/sound/rockchip-i2s.txt     |   45 ++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/rockchip-i2s.txt

diff --git a/Documentation/devicetree/bindings/sound/rockchip-i2s.txt b/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
new file mode 100644
index 0000000..e9ab122
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
@@ -0,0 +1,45 @@
+* Rockchip I2S controller
+
+The I2S bus (Inter-IC sound bus) is a serial link for digital audio data transfer
+between devices in the system and be invented by Philips Semiconductor.
+
+Required properties:
+
+- compatible : should be one of the following.
+   "rockchip,rk3066-i2s": for rk3066
+   "rockchip,rk3188-i2s", "rockchip,rk3066-i2s" for rk3188
+   "rockchip,rk3288-i2s", "rockchip,rk3066-i2s" for rk3288
+- reg : physical base address of the controller and length of memory mapped
+  region.
+- interrupts : The interrupt number to the cpu. The interrupt specifier format
+  depends on the interrupt controller.
+- #address-cells : should be 1.
+- #size-cells : should be 0.
+- dmas : list of DMA controller phandle and DMA request line ordered pairs.
+- dma-names : identifier string for each DMA request line in the dmas property.
+  These strings correspond 1:1 with the ordered pairs in dmas.
+  Must include the following entries:
+  - rx:
+  - tx:
+- clocks : Handle to internal work clock and master clock output to IO.
+- clock-names :
+  - "i2s_hclk": support AHB bus interface
+  - "i2s_clk": work clock for i2s controller
+
+Example:
+
+aliases {
+	i2s0 = &i2s0;
+}
+
+i2s0: i2s@ff890000 {
+	compatible = "rockchip,rk3066-i2s";
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


