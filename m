Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbaH1BAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 21:00:25 -0400
Received: from regular1.263xmail.com ([211.150.99.132]:45835 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150AbaH1BAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 21:00:20 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <07798bdd91ffef9bd2813ed763c6eef8>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        grant.likely@linaro.org
Cc: robh+dt@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, dtor@chromium.org, zyw@rock-chips.com,
        addy.ke@rock-chips.com, dmitry.torokhov@gmail.com,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v3 3/4] ARM: dts: add main Thermal info to rk3288
Date: Thu, 28 Aug 2014 08:59:21 +0800
Message-Id: <1409187562-12370-4-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409187562-12370-1-git-send-email-caesar.wang@rock-chips.com>
References: <1409187562-12370-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 36be7bb..3d672e3 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -224,6 +224,17 @@
 		status = "disabled";
 	};
 
+	tsadc: tsadc@ff280000 {
+		compatible = "rockchip,rk3288-tsadc";
+		reg = <0xff280000 0x100>;
+		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
+		clock-names = "tsadc", "apb_pclk";
+		pinctrl-names = "default";
+		pinctrl-1 = <&tsadc_int>;
+		status = "disabled";
+	};
+
 	/* NOTE: ohci@ff520000 doesn't actually work on hardware */
 
 	usb_hsic: usb@ff5c0000 {
@@ -611,5 +622,12 @@
 				rockchip,pins = <5 15 3 &pcfg_pull_none>;
 			};
 		};
+
+		tsadc {
+			tsadc_int: tsadc-int {
+				rockchip,pins = <0 10 RK_FUNC_1 &pcfg_pull_up>;
+			};
+		};
+
 	};
 };
-- 
1.9.1


