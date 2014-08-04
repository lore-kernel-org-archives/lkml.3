Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaHDE5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 00:57:14 -0400
Received: from regular1.263xmail.com ([211.150.99.131]:57861 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaHDE5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 00:57:11 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: yzq@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: yzq@rock-chips.com
X-UNIQUE-TAG: <33e93a97af9ae787b65ea9b9063c246a>
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
Subject: [PATCH 8/9] Add devicetree bindings for Rockchip Soc EDP
Date: Mon,  4 Aug 2014 12:55:59 +0800
Message-Id: <1407128159-1930-1-git-send-email-yzq@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
References: <1407127274-1356-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: mark yao <yzq@rock-chips.com>
---
 .../devicetree/bindings/video/rockchip-panel.txt   |   34 ++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/Documentation/devicetree/bindings/video/rockchip-panel.txt b/Documentation/devicetree/bindings/video/rockchip-panel.txt
index f599806..f6d80f6 100644
--- a/Documentation/devicetree/bindings/video/rockchip-panel.txt
+++ b/Documentation/devicetree/bindings/video/rockchip-panel.txt
@@ -80,3 +80,37 @@ Example:
 		rockchip,data-width = <24>;
 		rockchip,panel = <&panel>;
 	};
+
+Rockchip RK3288 EDP interface
+================================
+Required properties:
+-compatible: "rockchip,rk3288-edp";
+
+- reg: physical base address of the controller and length
+- clocks: from common clock binding: handle to dp clock.
+	of memory mapped region.
+- clock-names: from common clock binding:
+	Required elements: "clk_edp"
+			"clk_edp_24m"
+			"clk_edp_24m_parent"
+			"pclk_edp"
+- rockchip,grf: this soc should set GRF regs, so need get grf here.
+- resets: Must contain an entry for each entry in reset-names.
+	See ../reset/reset.txt for details.
+- reset-names: Must include the following entries:
+  - edp
+- rockchip,panel: required a panel node
+
+Example:
+	edp: edp@ff970000 {
+		compatible = "rockchip,rk3288-edp";
+                reg = <0xff970000 0x4000>;
+                interrupts = <GIC_SPI 98 IRQ_TYPE_LEVEL_HIGH>;
+                clocks = <&cru SCLK_EDP>, <&cru SCLK_EDP_24M>, <&cru PCLK_EDP_CTRL>, <&xin24m>;
+                clock-names = "clk_edp", "clk_edp_24m", "pclk_edp", "clk_edp_24m_parent";
+
+                rockchip,grf = <&grf>;
+                resets = <&cru 111>;
+                reset-names = "edp";
+		rockchip,panel = <&panel>;
+	};
-- 
1.7.9.5


