Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaKLMFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 07:05:24 -0500
Received: from regular1.263xmail.com ([211.150.99.132]:36895 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbaKLMFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:05:21 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <9e9fb7ee32222f09d21f25367feec11e>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Andy yan <andy.yan@rock-chips.com>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v8 8/9] dt-bindings: Add documentation for rockchip dw hdmi
Date: Wed, 12 Nov 2014 20:05:08 +0800
Message-Id: <1415793908-5448-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415793593-5075-1-git-send-email-andy.yan@rock-chips.com>
References: <1415793593-5075-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>

---

Changes in v8:
- Add documentation for rockchip dw hdmi

Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 .../devicetree/bindings/video/dw_hdmi-rockchip.txt | 43 ++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/dw_hdmi-rockchip.txt

diff --git a/Documentation/devicetree/bindings/video/dw_hdmi-rockchip.txt b/Documentation/devicetree/bindings/video/dw_hdmi-rockchip.txt
new file mode 100644
index 0000000..6ea6764
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/dw_hdmi-rockchip.txt
@@ -0,0 +1,43 @@
+Rockchip specific extensions to the Synopsys Designware HDMI
+================================
+
+Required properties:
+- compatible: "rockchip,rk3288-dw-hdmi";
+- reg: physical base address of the controller and length
+- ddc-i2c-bus:  phandle of an I2C controller used for DDC EDID probing
+- clocks: from common clock binding: handle to hdmi clock.
+- clock-names: should be "clk" "hdcp_clk"
+- rockchip,grf: this soc should set GRF regs to mux vopl/vopb.
+- interrupts: HDMI interrupt number
+- ports: contain a port node with endpoint definitions as defined in
+  Documentation/devicetree/bindings/media/video-interfaces.txt. For
+  vopb,set the reg = <0> and set the reg = <1> for vopl.
+- reg-io-width: the width of the reg:1,4, the value should be 4 on
+  rk3288 platform
+
+Example:
+hdmi: hdmi@ff980000 {
+	compatible = "rockchip,rk3288-dw-hdmi";
+	reg = <0xff980000 0x20000>;
+	reg-io-width = <4>;
+	ddc-i2c-bus = <&i2c5>;
+	rockchip,grf = <&grf>;
+	interrupts = <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
+	clocks = <&cru  PCLK_HDMI_CTRL>, <&cru SCLK_HDMI_HDCP>;
+	clock-names = "clk", "hdcp_clk";
+	status = "disabled";
+	ports {
+		hdmi_in: port {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			hdmi_in_vopb: endpoint@0 {
+				reg = <0>;
+				remote-endpoint = <&vopb_out_hdmi>;
+			};
+			hdmi_in_vopl: endpoint@1 {
+				reg = <1>;
+				remote-endpoint = <&vopl_out_hdmi>;
+			};
+		};
+	};
+};
-- 
1.9.1


