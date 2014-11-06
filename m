Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaKFGXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 01:23:35 -0500
Received: from regular1.263xmail.com ([211.150.99.140]:46642 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaKFGXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 01:23:20 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: linus.walleij@linaro.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <3ed4abc9640c86ae2947aea20c2c853f>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, dianders@chromium.org,
        linux-rockchip@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, fzf@rock-chips.com,
        cf@rock-chips.com, caesar.wang@rock-chips.com,
        Jack Dai <jack.dai@rock-chips.com>,
        "jinkun.hong" <jinkun.hong@rock-chips.com>
Subject: [PATCH v8 3/3] ARM: dts: add rk3288 power-domain node
Date: Thu,  6 Nov 2014 14:22:41 +0800
Message-Id: <1415254961-5746-4-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415254961-5746-1-git-send-email-caesar.wang@rock-chips.com>
References: <1415254961-5746-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Dai <jack.dai@rock-chips.com>
Signed-off-by: jinkun.hong <jinkun.hong@rock-chips.com>
Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>

---

Changes in v8:
    - DTS go back to v2

Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3:
    - Decomposition power-controller, changed to multiple controller
    (gpu-power-controller, hevc-power-controller)

Changes in v2:
    - make pd_vio clocks all one entry per line and alphabetize.
    - power: power-controller move back to pinctrl: pinctrl.

 arch/arm/boot/dts/rk3288.dtsi | 66 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index cb18bb4..9cd269a 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -989,4 +989,70 @@
 			};
 		};
 	};
+
+	power: power-controller {
+		compatible = "rockchip,rk3288-power-controller";
+		#power-domain-cells = <1>;
+		rockchip,pmu = <&pmu>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		pd_gpu {
+			reg = <RK3288_PD_GPU>;
+			clocks = <&cru ACLK_GPU>;
+		};
+
+		pd_hevc {
+			reg = <RK3288_PD_HEVC>;
+			clocks = <&cru ACLK_HEVC>,
+				 <&cru SCLK_HEVC_CABAC>,
+				 <&cru SCLK_HEVC_CORE>,
+				 <&cru HCLK_HEVC>;
+		};
+
+		pd_vio {
+			reg = <RK3288_PD_VIO>;
+			clocks = <&cru ACLK_IEP>,
+				 <&cru ACLK_ISP>,
+				 <&cru ACLK_RGA_NIU>,
+				 <&cru ACLK_RGA>,
+				 <&cru ACLK_VIO0_NIU>,
+				 <&cru ACLK_VIO1_NIU>,
+				 <&cru ACLK_VIP>,
+				 <&cru ACLK_VOP0>,
+				 <&cru ACLK_VOP1>,
+				 <&cru DCLK_VOP0>,
+				 <&cru DCLK_VOP1>,
+				 <&cru HCLK_IEP>,
+				 <&cru HCLK_ISP>,
+				 <&cru HCLK_RGA>,
+				 <&cru HCLK_VIO_AHB_ARBI>,
+				 <&cru HCLK_VIO_NIU>,
+				 <&cru HCLK_VIO2_H2P>,
+				 <&cru HCLK_VIP>,
+				 <&cru HCLK_VOP0>,
+				 <&cru HCLK_VOP1>,
+				 <&cru PCLK_EDP_CTRL>,
+				 <&cru PCLK_HDMI_CTRL>,
+				 <&cru PCLK_LVDS_PHY>,
+				 <&cru PCLK_MIPI_CSI>,
+				 <&cru PCLK_MIPI_DSI0>,
+				 <&cru PCLK_MIPI_DSI1>,
+				 <&cru PCLK_VIO2_H2P>,
+				 <&cru SCLK_EDP_24M>,
+				 <&cru SCLK_EDP>,
+				 <&cru SCLK_HDMI_CEC>,
+				 <&cru SCLK_HDMI_HDCP>,
+				 <&cru SCLK_ISP_JPE>,
+				 <&cru SCLK_ISP>,
+				 <&cru SCLK_RGA>;
+		};
+
+		pd_video {
+			reg = <RK3288_PD_VIDEO>;
+			/* FIXME: add clocks */
+			clocks = <&cru ACLK_VCODEC>,
+				 <&cru HCLK_VCODEC>;
+		};
+	};
 };
-- 
1.9.1


