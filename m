Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaLDKK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:10:57 -0500
Received: from lucky1.263xmail.com ([211.157.147.132]:35662 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbaLDKKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:10:52 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <61d2bd3f72f002d3a9322a3545f79672>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Andy Yan <andy.yan@rock-chips.com>
To: airlied@linux.ie, Philipp Zabel <p.zabel@pengutronix.de>, heiko@sntech.de,
        fabio.estevam@freescale.com, rmk+kernel@arm.linux.org.uk
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
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
        Kumar Gala <galak@codeaurora.org>, vladimir_zapolskiy@mentor.com,
        Andy Yan <andy.yan@rock-chips.com>
Subject: [PATCH v17 11/12] dt-bindings: Add documentation for rockchip dw hdmi
Date: Thu,  4 Dec 2014 18:10:24 +0800
Message-Id: <1417687824-13451-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417686826-12687-1-git-send-email-andy.yan@rock-chips.com>
References: <1417686826-12687-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>

---

Changes in v17: None
Changes in v16:
- modify clocks bindings
- descrbie ddc-i2c-bus as optional

Changes in v15: None
Changes in v14: None
Changes in v13: None
Changes in v12: None
Changes in v11: None
Changes in v10: None
Changes in v9: None
Changes in v8:
- Add documentation for rockchip dw hdmi

Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None

 .../devicetree/bindings/video/dw_hdmi-rockchip.txt | 46 ++++++++++++++++++++++
 1 file changed, 46 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/video/dw_hdmi-rockchip.txt

diff --git a/Documentation/devicetree/bindings/video/dw_hdmi-rockchip.txt b/Documentation/devicetree/bindings/video/dw_hdmi-rockchip.txt
new file mode 100644
index 0000000..264cb4f
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/dw_hdmi-rockchip.txt
@@ -0,0 +1,46 @@
+Rockchip specific extensions to the Synopsys Designware HDMI
+================================
+
+Required properties:
+- compatible: "rockchip,rk3288-dw-hdmi";
+- reg: Physical base address and length of the controller's registers.
+- clocks: phandle to hdmi iahb and isrf clocks.
+- clock-names: should be "iahb" "isfr"
+- rockchip,grf: this soc should set GRF regs to mux vopl/vopb.
+- interrupts: HDMI interrupt number
+- ports: contain a port node with endpoint definitions as defined in
+  Documentation/devicetree/bindings/media/video-interfaces.txt. For
+  vopb,set the reg = <0> and set the reg = <1> for vopl.
+- reg-io-width: the width of the reg:1,4, the value should be 4 on
+  rk3288 platform
+
+Optional properties
+- ddc-i2c-bus: phandle of an I2C controller used for DDC EDID probing
+- clkocks, clock-names: phandle to the HDMI cec clock, name should be "cec"
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
+	clock-names = "iahb", "isfr";
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


