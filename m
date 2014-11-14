Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965572AbaKNNnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:43:31 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:43076 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965248AbaKNNn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:43:29 -0500
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <fb75c8d364e84a27991d0d81a9caccd9>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
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
Subject: [PATCH v11 06/12] dt-bindings: add document for dw_hdmi
Date: Fri, 14 Nov 2014 21:42:58 +0800
Message-Id: <1415972578-8577-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415972231-8283-1-git-send-email-andy.yan@rock-chips.com>
References: <1415972231-8283-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>

---

Changes in v11: None
Changes in v10: None
Changes in v9: None
Changes in v8:
- correct some spelling mistake
- modify ddc-i2c-bus and interrupt description

Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 .../devicetree/bindings/drm/bridge/dw_hdmi.txt     | 40 ++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt

diff --git a/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt b/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt
new file mode 100644
index 0000000..0558442
--- /dev/null
+++ b/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt
@@ -0,0 +1,40 @@
+DesignWare HDMI bridge bindings
+
+Required properities:
+- compatible: platform specific such as:
+   * "fsl,imx6q-hdmi"
+   * "fsl,imx6dl-hdmi"
+   * "rockchip,rk3288-dw-hdmi"
+- reg: physical base address of the controller and length
+- ddc-i2c-bus: phandle of an I2C controller used for DDC EDID probing
+- interrupts: The HDMI interrupt number
+
+Optional properties
+- reg-io-width: the width of the reg:1,4, default set to 1 if not present
+
+Example:
+	hdmi: hdmi@0120000 {
+		compatible = "fsl,imx6q-hdmi";
+		reg = <0x00120000 0x9000>;
+		interrupts = <0 115 0x04>;
+		gpr = <&gpr>;
+		clocks = <&clks 123>, <&clks 124>;
+		clock-names = "iahb", "isfr";
+		ddc-i2c-bus = <&i2c2>;
+
+		port@0 {
+			reg = <0>;
+
+			hdmi_mux_0: endpoint {
+				remote-endpoint = <&ipu1_di0_hdmi>;
+			};
+		};
+
+		port@1 {
+			reg = <1>;
+
+			hdmi_mux_1: endpoint {
+				remote-endpoint = <&ipu1_di1_hdmi>;
+			};
+		};
+	};
-- 
1.9.1

