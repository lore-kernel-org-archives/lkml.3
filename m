Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaKHFdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 00:33:16 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:48855 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbaKHFdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 00:33:14 -0500
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <037fe55a3006ddd026170f953770d33d>
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
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com
Subject: [PATCH V5 7/7] dt-bindings: add document for dw-hdmi
Date: Sat,  8 Nov 2014 13:32:47 +0800
Message-Id: <1415424767-7761-1-git-send-email-andy.yan@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415424410-7364-1-git-send-email-andy.yan@rock-chips.com>
References: <1415424410-7364-1-git-send-email-andy.yan@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
---
 .../devicetree/bindings/drm/bridge/dw-hdmi.txt     | 38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/drm/bridge/dw-hdmi.txt

diff --git a/Documentation/devicetree/bindings/drm/bridge/dw-hdmi.txt b/Documentation/devicetree/bindings/drm/bridge/dw-hdmi.txt
new file mode 100644
index 0000000..aa7ed17
--- /dev/null
+++ b/Documentation/devicetree/bindings/drm/bridge/dw-hdmi.txt
@@ -0,0 +1,38 @@
+DesignWare HDMI bridge bindings
+
+Required properities:
+- compatibel: platform specific such as "fsl,imx6q-hdmi","fsl,imx6dl-hdmi"
+	      "rockchip,rk3288-dw-hdmi"
+- reg: physical base address of the controller and length
+- ddc-i2c-bus: the ddc i2c bus
+- interrupts: The interrupt number to the cpu
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

