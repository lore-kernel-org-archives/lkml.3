Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaIQEBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 00:01:44 -0400
Received: from regular1.263xmail.com ([211.150.99.130]:53923 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaIQEAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 00:00:22 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <52bd69c8c9f1530371c42701e413e265>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com, arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, dtor@chromium.org, dmitry.torokhov@gmail.com,
        addy.ke@rock-chips.com, zyf@rock-chips.com, cjf@rock-chips.com,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v5 3/4] ARM: dts: add main Thermal info to rk3288
Date: Wed, 17 Sep 2014 11:59:12 +0800
Message-Id: <1410926353-15674-4-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410926353-15674-1-git-send-email-caesar.wang@rock-chips.com>
References: <1410926353-15674-1-git-send-email-caesar.wang@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 36be7bb..ba7ad94 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -215,6 +215,17 @@
 		status = "disabled";
 	};
 
+	tsadc: tsadc@ff280000 {
+		compatible = "rockchip,rk3288-tsadc";
+		reg = <0xff280000 0x100>;
+		interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru SCLK_TSADC>, <&cru PCLK_TSADC>;
+		clock-names = "tsadc", "apb_pclk";
+		pinctrl-names = "default";
+		pinctrl-1 = <&otp_out>;
+		status = "disabled";
+	};
+
 	usb_host0_ehci: usb@ff500000 {
 		compatible = "generic-ehci";
 		reg = <0xff500000 0x100>;
@@ -611,5 +622,12 @@
 				rockchip,pins = <5 15 3 &pcfg_pull_none>;
 			};
 		};
+
+		tsadc {
+			otp_out: otp-out {
+				rockchip,pins = <0 10 RK_FUNC_1 &pcfg_pull_up>;
+			};
+		};
+
 	};
 };
-- 
1.9.1


