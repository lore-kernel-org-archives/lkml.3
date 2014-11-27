Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaK0Cx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 21:53:26 -0500
Received: from regular1.263xmail.com ([211.150.99.135]:45310 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbaK0CxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 21:53:23 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: roger.chen@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: roger.chen@rock-chips.com
X-UNIQUE-TAG: <e22927f4c702a53999dc13c6d5ca79a6>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Roger Chen <roger.chen@rock-chips.com>
To: heiko@sntech.de
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        kever.yang@rock-chips.com, eddie.cai@rock-chips.com,
        roger.chen@rock-chips.com
Subject: [PATCH v2 5/6] ARM: dts: rockchip: enable gmac on RK3288 evb board
Date: Thu, 27 Nov 2014 10:53:20 +0800
Message-Id: <1417056800-3789-1-git-send-email-roger.chen@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417056591-3570-1-git-send-email-roger.chen@rock-chips.com>
References: <1417056591-3570-1-git-send-email-roger.chen@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enable gmac in rk3288-evb-rk808.dts

Signed-off-by: Roger Chen <roger.chen@rock-chips.com>
---
 arch/arm/boot/dts/rk3288-evb-rk808.dts |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288-evb-rk808.dts b/arch/arm/boot/dts/rk3288-evb-rk808.dts
index d8c775e6..13ad2d2 100644
--- a/arch/arm/boot/dts/rk3288-evb-rk808.dts
+++ b/arch/arm/boot/dts/rk3288-evb-rk808.dts
@@ -15,6 +15,13 @@
 
 / {
 	compatible = "rockchip,rk3288-evb-rk808", "rockchip,rk3288";
+
+	ext_gmac: external-gmac-clock {
+		compatible = "fixed-clock";
+		clock-frequency = <125000000>;
+		clock-output-names = "ext_gmac";
+		#clock-cells = <0>;
+	};
 };
 
 &cpu0 {
@@ -152,3 +159,20 @@
 		};
 	};
 };
+
+&gmac {
+	//pmu_regulator = "act_ldo5";
+	//pmu_enable_level = <1>; //1->HIGH, 0->LOW
+	power-gpio = <&gpio0 6 GPIO_ACTIVE_HIGH>;
+	reset-gpio = <&gpio4 7 GPIO_ACTIVE_LOW>;
+	//phyirq-gpio = <&gpio4 2 GPIO_ACTIVE_LOW>;
+	phy-mode = "rgmii";
+	clock_in_out = "input";
+	assigned-clocks = <&cru SCLK_MAC>;
+	assigned-clock-parents = <&ext_gmac>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&rgmii_pins>;
+	tx_delay = <0x30>;
+	rx_delay = <0x10>;
+	status = "ok";
+};
-- 
1.7.9.5


