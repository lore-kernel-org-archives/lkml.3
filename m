Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaIVK7u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:59:50 -0400
Received: from regular1.263xmail.com ([211.150.99.135]:49483 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaIVK7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:59:48 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <97004881aa960cc6cc38a17995475203>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Mark yao <mark.yao@rock-chips.com>
To: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-api@vger.kernel.org, linux-rockchip@lists.infradead.org,
        dianders@chromium.org, marcheu@chromium.org, dbehr@chromium.org,
        olof@lixom.net, djkurtz@chromium.org, xjq@rock-chips.com,
        kfx@rock-chips.com, cym@rock-chips.com, cf@rock-chips.com,
        zyw@rock-chips.com, xxm@rock-chips.com, huangtao@rock-chips.com,
        kever.yang@rock-chips.com, yxj@rock-chips.com, wxt@rock-chips.com,
        xw@rock-chips.com, Mark yao <mark.yao@rock-chips.com>,
        Jeff Chen <jeff.chen@rock-chips.com>
Subject: [PATCH v4 4/5] dt-bindings: video: Add documentation for rockchip edp
Date: Mon, 22 Sep 2014 18:58:35 +0800
Message-Id: <1411383515-2035-1-git-send-email-mark.yao@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding documentation for Rockchip SoC EDP driver.

Signed-off-by: Jeff Chen <jeff.chen@rock-chips.com>
Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
---
Changes in v2:
- add edp reset
- add panel node
- add port for display-subsystem

Changes in v3: None

Changes in v4: None

 .../devicetree/bindings/video/rockchip-edp.txt     |   50 ++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/rockchip-edp.txt

diff --git a/Documentation/devicetree/bindings/video/rockchip-edp.txt b/Documentation/devicetree/bindings/video/rockchip-edp.txt
new file mode 100644
index 0000000..515e806
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/rockchip-edp.txt
@@ -0,0 +1,50 @@
+Rockchip RK3288 EDP interface
+================================
+
+Required properties:
+- compatible: "rockchip,rk3288-edp";
+
+- reg: physical base address of the controller and length
+- clocks: from common clock binding: handle to dp clock.
+	of memory mapped region.
+- clock-names: from common clock binding:
+	Required elements: "clk_edp"
+			"clk_edp_24m"
+			"pclk_edp"
+- resets: Must contain an entry for each entry in reset-names.
+	See ../reset/reset.txt for details.
+- reset-names: Must include the name "edp"
+
+- rockchip,grf: this soc should set GRF regs, so need get grf here.
+- rockchip,panel: required a simple panel node as described by
+	Documentation/devicetree/bindings/panel/simple-panel.txt
+
+- ports: contain a port node with endpoint definitions as defined in
+  Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+	edp: edp@ff970000 {
+		compatible = "rockchip,rk3288-edp";
+		reg = <0xff970000 0x4000>;
+		interrupts = <GIC_SPI 98 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru SCLK_EDP>, <&cru SCLK_EDP_24M>, <&cru PCLK_EDP_CTRL>;
+		clock-names = "clk_edp", "clk_edp_24m", "pclk_edp";
+		rockchip,grf = <&grf>;
+		resets = <&cru 111>;
+		reset-names = "edp";
+		rockchip,panel = <&panel>;
+		ports {
+			edp_in: port {
+				#address-cells = <1>;
+				#size-cells = <0>;
+				edp_in_vopb: endpoint@0 {
+					reg = <0>;
+					remote-endpoint = <&vopb_out_edp>;
+				};
+				edp_in_vopl: endpoint@1 {
+					reg = <1>;
+					remote-endpoint = <&vopl_out_edp>;
+				};
+			};
+		};
+	};
-- 
1.7.9.5


