Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaG2XYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:24:49 -0400
Received: from mail-pa0-f74.google.com ([209.85.220.74]:63672 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbaG2XYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:24:44 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Kever Yang <kever.yang@rock-chips.com>
Cc: Sonny Rao <sonnyrao@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ARM: dts: Turn on USB host vbus on rk3288-evb
Date: Tue, 29 Jul 2014 16:24:31 -0700
Message-Id: <1406676273-20701-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1406676273-20701-1-git-send-email-dianders@chromium.org>
References: <1406676273-20701-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no phy driver that works on the Rockchip board for either USB
host port yet.  For now just hardcode the vbus signal to be on all the
time which makes both the dwc2 host and the EHCI port work.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 arch/arm/boot/dts/rk3288-evb.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
index 749e20d..efd625e 100644
--- a/arch/arm/boot/dts/rk3288-evb.dtsi
+++ b/arch/arm/boot/dts/rk3288-evb.dtsi
@@ -35,6 +35,18 @@
 			debounce-interval = <100>;
 		};
 	};
+
+	/* This turns on vbus for both host0 (ehci) and host1 (dwc2) */
+	usb_host_vbus_regulator: usb-host-vbus-regulator {
+		compatible = "regulator-fixed";
+		enable-active-high;
+		gpio = <&gpio0 14 GPIO_ACTIVE_HIGH>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&usb_host_vbus>;
+		regulator-name = "usb-host-vbus";
+		regulator-always-on;
+		regulator-boot-on;
+	};
 };
 
 &i2c0 {
@@ -71,4 +83,10 @@
 			rockchip,pins = <0 5 RK_FUNC_GPIO &pcfg_pull_up>;
 		};
 	};
+
+	usb-host {
+		usb_host_vbus: usb-host-vbus {
+			rockchip,pins = <0 14 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+	};
 };
-- 
2.0.0.526.g5318336

