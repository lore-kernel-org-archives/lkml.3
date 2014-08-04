Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360AbaHDEvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:51:40 -0400
Received: from regular1.263xmail.com ([211.150.99.131]:33699 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaHDEvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:51:38 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Aug 2014 00:51:36 EDT
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: yzq@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: yzq@rock-chips.com
X-UNIQUE-TAG: <476364ccccece7828a908374cd2adef0>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: mark yao <yzq@rock-chips.com>
To: heiko@sntech.de, Rob Clark <robdclark@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-api@vger.kernel.org, olof@lixom.net, djkurtz@chromium.org,
        xjq@rock-chips.com, kfx@rock-chips.com, cym@rock-chips.com,
        cf@rock-chips.com, zyw@rock-chips.com, zwl@rock-chips.com,
        xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com,
        zhangqing@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com,
        xw@rock-chips.com, mark yao <yzq@rock-chips.com>
Subject: [PATCH 4/9] Add devicetree bindings for Rockchip lcd controller
Date: Mon,  4 Aug 2014 12:50:27 +0800
Message-Id: <1407127827-1741-1-git-send-email-yzq@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
References: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: mark yao <yzq@rock-chips.com>
---
 .../devicetree/bindings/video/rockchip-lcdc.txt    |   33 ++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/rockchip-lcdc.txt

diff --git a/Documentation/devicetree/bindings/video/rockchip-lcdc.txt b/Documentation/devicetree/bindings/video/rockchip-lcdc.txt
new file mode 100644
index 0000000..7fb2b73
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/rockchip-lcdc.txt
@@ -0,0 +1,33 @@
+Device-Tree bindings for Rockchip SoC display controller (LCDC)
+
+LCDC (LCD Controller) is the Display Controller for the Rockchip
+series of SoCs which transfers the image data from a video memory
+buffer to an external LCD interface.
+
+Required properties:
+- compatible: value should be one of the following
+		"rockchip,rk3066-lcdc";
+		"rockchip,rk3188-lcdc";
+		"rockchip,rk3288-lcdc";
+
+- interrupts: should contain a list of all LCDC IP block interrupts in the
+		 order: VSYNC, LCD_SYSTEM. The interrupt specifier
+		 format depends on the interrupt controller used.
+
+- clocks: must include clock specifiers corresponding to entries in the
+		clock-names property.
+
+- clock-names: Must contain
+		aclk_lcdc: for ddr buffer transfer.
+		hclk_lcdc: for ahb bus to R/W the phy regs.
+		dclk_lcdc: pixel clock.
+
+Example:
+SoC specific DT entry:
+	lcdc1: lcdc@ff940000 {
+		compatible = "rockchip,rk3288-lcdc";
+		reg = <0xff940000 0x19c>;
+		interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru ACLK_LCDC1>, <&cru DCLK_LCDC1>, <&cru HCLK_LCDC1>;
+		clock-names = "aclk_lcdc", "dclk_lcdc", "hclk_lcdc";
+	};
-- 
1.7.9.5


